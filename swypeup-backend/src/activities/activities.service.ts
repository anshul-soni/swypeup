import { Injectable, NotFoundException, BadRequestException } from '@nestjs/common';
import { InjectModel } from '@nestjs/mongoose';
import { Model, Types } from 'mongoose';
import { Activity, ActivityDocument } from './schemas/activity.schema';
import { Membership, MembershipDocument } from './schemas/membership.schema';
import { Chat, ChatDocument } from './schemas/chat.schema';
import { CreateActivityDto } from './dto/create-activity.dto';
import { ChatService } from '../services/chat.service';

@Injectable()
export class ActivitiesService {
  constructor(
    @InjectModel(Activity.name) private activityModel: Model<ActivityDocument>,
    @InjectModel(Membership.name) private membershipModel: Model<MembershipDocument>,
    @InjectModel(Chat.name) private chatModel: Model<ChatDocument>,
    private chatService: ChatService,
  ) {}

  async create(createActivityDto: CreateActivityDto, userId: string): Promise<Activity> {
    const activity = new this.activityModel({
      ...createActivityDto,
      location: {
        type: 'Point',
        coordinates: createActivityDto.location,
      },
      hostId: new Types.ObjectId(userId),
    });

    const savedActivity = await activity.save();

    // Create membership for the host
    await this.membershipModel.create({
      userId: new Types.ObjectId(userId),
      activityId: savedActivity._id,
      role: 'host',
    });

    // Create chat channel for the activity
    try {
      const { channelId } = await this.chatService.createActivityChannel(
        savedActivity._id.toString(),
        createActivityDto.title,
        userId
      );

      // Store chat channel info in database
      await this.chatModel.create({
        activityId: savedActivity._id,
        thirdPartyChannelId: channelId,
      });
    } catch (error) {
      console.error('Failed to create chat channel:', error);
      // Don't fail the activity creation if chat creation fails
    }

    return savedActivity;
  }

  async getFeed(lat: number, lon: number): Promise<Activity[]> {
    return this.activityModel
      .find({
        status: 'active',
        startTime: { $gte: new Date() },
      })
      .where('location')
      .near({
        center: {
          type: 'Point',
          coordinates: [lon, lat],
        },
        maxDistance: 50000, // 50km
        spherical: true,
      })
      .sort({ startTime: 1 })
      .populate('hostId', 'name profilePictureUrl')
      .exec();
  }

  async joinActivity(activityId: string, userId: string): Promise<void> {
    const activity = await this.activityModel.findById(activityId);
    if (!activity) {
      throw new NotFoundException('Activity not found');
    }

    if (activity.status !== 'active') {
      throw new BadRequestException('Activity is not available for joining');
    }

    // Check if user is already a member
    const existingMembership = await this.membershipModel.findOne({
      userId: new Types.ObjectId(userId),
      activityId: new Types.ObjectId(activityId),
    });

    if (existingMembership) {
      throw new BadRequestException('User is already a member of this activity');
    }

    // Count current participants
    const participantCount = await this.membershipModel.countDocuments({
      activityId: new Types.ObjectId(activityId),
    });

    if (participantCount >= activity.maxParticipants) {
      // Update activity status to full
      await this.activityModel.findByIdAndUpdate(activityId, { status: 'full' });
      throw new BadRequestException('Activity is full');
    }

    // Create membership
    await this.membershipModel.create({
      userId: new Types.ObjectId(userId),
      activityId: new Types.ObjectId(activityId),
      role: 'participant',
    });

    // Add user to chat channel
    try {
      const chatInfo = await this.chatModel.findOne({ activityId: new Types.ObjectId(activityId) });
      if (chatInfo) {
        await this.chatService.addUserToChannel(
          chatInfo.thirdPartyChannelId,
          userId,
          'User' // This will be updated with actual user name
        );
      }
    } catch (error) {
      console.error('Failed to add user to chat channel:', error);
      // Don't fail the join if chat addition fails
    }

    // Check if activity is now full
    const newParticipantCount = await this.membershipModel.countDocuments({
      activityId: new Types.ObjectId(activityId),
    });

    if (newParticipantCount >= activity.maxParticipants) {
      await this.activityModel.findByIdAndUpdate(activityId, { status: 'full' });
    }
  }

  async getUserActivities(userId: string) {
    const memberships = await this.membershipModel
      .find({ userId: new Types.ObjectId(userId) })
      .populate({
        path: 'activityId',
        populate: {
          path: 'hostId',
          select: 'name profilePictureUrl',
        },
      })
      .exec();

    const hosting = memberships
      .filter(membership => membership.role === 'host')
      .map(membership => membership.activityId);

    const participating = memberships
      .filter(membership => membership.role === 'participant')
      .map(membership => membership.activityId);

    return {
      hosting,
      participating,
    };
  }
}

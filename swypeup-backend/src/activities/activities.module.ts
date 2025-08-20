import { Module } from '@nestjs/common';
import { MongooseModule } from '@nestjs/mongoose';
import { ActivitiesService } from './activities.service';
import { ActivitiesController } from './activities.controller';
import { Activity, ActivitySchema } from './schemas/activity.schema';
import { Membership, MembershipSchema } from './schemas/membership.schema';
import { Chat, ChatSchema } from './schemas/chat.schema';
import { ChatService } from '../services/chat.service';

@Module({
  imports: [
    MongooseModule.forFeature([
      { name: Activity.name, schema: ActivitySchema },
      { name: Membership.name, schema: MembershipSchema },
      { name: Chat.name, schema: ChatSchema },
    ]),
  ],
  controllers: [ActivitiesController],
  providers: [ActivitiesService, ChatService],
  exports: [ActivitiesService],
})
export class ActivitiesModule {}

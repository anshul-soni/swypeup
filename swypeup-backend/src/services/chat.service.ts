import { Injectable } from '@nestjs/common';
import { StreamChat } from 'stream-chat';

@Injectable()
export class ChatService {
  private streamClient: StreamChat;

  constructor() {
    // Initialize Stream Chat client
    // In production, these should be environment variables
    this.streamClient = StreamChat.getInstance(
      process.env.STREAM_API_KEY || 'your-stream-api-key',
      process.env.STREAM_API_SECRET || 'your-stream-api-secret'
    );
  }

  async createActivityChannel(activityId: string, activityTitle: string, hostId: string) {
    try {
      const channelId = `activity-${activityId}`;
      
      // Create a channel for the activity
      const channel = this.streamClient.channel('messaging', channelId, {
        name: activityTitle,
        members: [hostId],
        created_by_id: hostId,
        activity_id: activityId,
      });

      await channel.create();
      
      // Store channel info in our database
      // This will be handled by the activities service when creating an activity
      
      return {
        channelId,
        channel: channel,
      };
    } catch (error) {
      throw new Error(`Failed to create chat channel: ${error.message}`);
    }
  }

  async addUserToChannel(channelId: string, userId: string, userName: string) {
    try {
      const channel = this.streamClient.channel('messaging', channelId);
      
      // Add user to the channel
      await channel.addMembers([userId]);
      
      return { success: true };
    } catch (error) {
      throw new Error(`Failed to add user to channel: ${error.message}`);
    }
  }

  async removeUserFromChannel(channelId: string, userId: string) {
    try {
      const channel = this.streamClient.channel('messaging', channelId);
      
      // Remove user from the channel
      await channel.removeMembers([userId]);
      
      return { success: true };
    } catch (error) {
      throw new Error(`Failed to remove user from channel: ${error.message}`);
    }
  }

  async generateUserToken(userId: string, userName: string) {
    try {
      // Create or update user in Stream
      await this.streamClient.upsertUser({
        id: userId,
        name: userName,
      });

      // Generate user token for client-side authentication
      const token = this.streamClient.createToken(userId);
      
      return {
        token,
        user: {
          id: userId,
          name: userName,
        },
      };
    } catch (error) {
      throw new Error(`Failed to generate user token: ${error.message}`);
    }
  }

  async getChannelInfo(channelId: string) {
    try {
      const channel = this.streamClient.channel('messaging', channelId);
      const state = await channel.watch();
      
      return {
        channelId,
        members: state.members,
        messages: state.messages,
        channel: state.channel,
      };
    } catch (error) {
      throw new Error(`Failed to get channel info: ${error.message}`);
    }
  }

  async deleteChannel(channelId: string) {
    try {
      const channel = this.streamClient.channel('messaging', channelId);
      await channel.delete();
      
      return { success: true };
    } catch (error) {
      throw new Error(`Failed to delete channel: ${error.message}`);
    }
  }
}

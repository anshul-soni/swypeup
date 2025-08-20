import { Controller, Post, Get, Body, Param, UseGuards, Request, HttpStatus } from '@nestjs/common';
import { ChatService } from '../services/chat.service';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';

@Controller('chat')
@UseGuards(JwtAuthGuard)
export class ChatController {
  constructor(private chatService: ChatService) {}

  @Post('token')
  async generateToken(@Request() req) {
    try {
      const { token, user } = await this.chatService.generateUserToken(
        req.user.userId,
        req.user.name || 'User'
      );

      return {
        statusCode: HttpStatus.OK,
        data: {
          token,
          user,
        },
      };
    } catch (error) {
      return {
        statusCode: HttpStatus.INTERNAL_SERVER_ERROR,
        message: error.message,
      };
    }
  }

  @Post('channels/:activityId/join')
  async joinChannel(
    @Param('activityId') activityId: string,
    @Request() req,
  ) {
    try {
      const channelId = `activity-${activityId}`;
      
      await this.chatService.addUserToChannel(
        channelId,
        req.user.userId,
        req.user.name || 'User'
      );

      return {
        statusCode: HttpStatus.OK,
        message: 'Successfully joined chat channel',
        data: { channelId },
      };
    } catch (error) {
      return {
        statusCode: HttpStatus.INTERNAL_SERVER_ERROR,
        message: error.message,
      };
    }
  }

  @Post('channels/:activityId/leave')
  async leaveChannel(
    @Param('activityId') activityId: string,
    @Request() req,
  ) {
    try {
      const channelId = `activity-${activityId}`;
      
      await this.chatService.removeUserFromChannel(
        channelId,
        req.user.userId
      );

      return {
        statusCode: HttpStatus.OK,
        message: 'Successfully left chat channel',
      };
    } catch (error) {
      return {
        statusCode: HttpStatus.INTERNAL_SERVER_ERROR,
        message: error.message,
      };
    }
  }

  @Get('channels/:activityId')
  async getChannelInfo(@Param('activityId') activityId: string) {
    try {
      const channelId = `activity-${activityId}`;
      const channelInfo = await this.chatService.getChannelInfo(channelId);

      return {
        statusCode: HttpStatus.OK,
        data: channelInfo,
      };
    } catch (error) {
      return {
        statusCode: HttpStatus.INTERNAL_SERVER_ERROR,
        message: error.message,
      };
    }
  }
}

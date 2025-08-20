import { Controller, Post, Get, Body, Param, Query, UseGuards, Request, HttpStatus } from '@nestjs/common';
import { ActivitiesService } from './activities.service';
import { CreateActivityDto } from './dto/create-activity.dto';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';

@Controller('activities')
@UseGuards(JwtAuthGuard)
export class ActivitiesController {
  constructor(private activitiesService: ActivitiesService) {}

  @Post()
  async create(@Body() createActivityDto: CreateActivityDto, @Request() req) {
    const activity = await this.activitiesService.create(createActivityDto, req.user.userId);
    return {
      statusCode: HttpStatus.CREATED,
      data: activity,
    };
  }

  @Get('feed')
  async getFeed(
    @Query('lat') lat: string,
    @Query('lon') lon: string,
  ) {
    const latitude = parseFloat(lat);
    const longitude = parseFloat(lon);

    if (isNaN(latitude) || isNaN(longitude)) {
      throw new Error('Invalid latitude or longitude');
    }

    const activities = await this.activitiesService.getFeed(latitude, longitude);
    return {
      statusCode: HttpStatus.OK,
      data: activities,
    };
  }

  @Post(':id/join')
  async joinActivity(@Param('id') activityId: string, @Request() req) {
    await this.activitiesService.joinActivity(activityId, req.user.userId);
    return {
      statusCode: HttpStatus.OK,
      message: 'Successfully joined activity',
    };
  }

  @Get('me')
  async getUserActivities(@Request() req) {
    const activities = await this.activitiesService.getUserActivities(req.user.userId);
    return {
      statusCode: HttpStatus.OK,
      data: activities,
    };
  }
}

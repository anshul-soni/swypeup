import { Prop, Schema, SchemaFactory } from '@nestjs/mongoose';
import { Document, Types } from 'mongoose';

export type MembershipDocument = Membership & Document;

@Schema({ timestamps: true })
export class Membership {
  @Prop({ type: Types.ObjectId, ref: 'User', required: true })
  userId: Types.ObjectId;

  @Prop({ type: Types.ObjectId, ref: 'Activity', required: true })
  activityId: Types.ObjectId;

  @Prop({ 
    type: String, 
    enum: ['host', 'participant'], 
    required: true 
  })
  role: string;

  @Prop({ default: Date.now })
  joinedAt: Date;
}

export const MembershipSchema = SchemaFactory.createForClass(Membership);

// Create compound index to ensure unique user-activity combinations
MembershipSchema.index({ userId: 1, activityId: 1 }, { unique: true });

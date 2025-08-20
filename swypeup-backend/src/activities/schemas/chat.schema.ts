import { Prop, Schema, SchemaFactory } from '@nestjs/mongoose';
import { Document, Types } from 'mongoose';

export type ChatDocument = Chat & Document;

@Schema({ timestamps: true })
export class Chat {
  @Prop({ type: Types.ObjectId, ref: 'Activity', required: true, unique: true })
  activityId: Types.ObjectId;

  @Prop({ required: true })
  thirdPartyChannelId: string;
}

export const ChatSchema = SchemaFactory.createForClass(Chat);

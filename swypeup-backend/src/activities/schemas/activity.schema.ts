import { Prop, Schema, SchemaFactory } from '@nestjs/mongoose';
import { Document, Types } from 'mongoose';

export type ActivityDocument = Activity & Document;

@Schema({ timestamps: true })
export class Activity {
  @Prop({ required: true })
  title: string;

  @Prop({ required: true })
  description: string;

  @Prop({
    type: {
      type: String,
      enum: ['Point'],
      required: true,
    },
    coordinates: {
      type: [Number],
      required: true,
    },
  })
  location: {
    type: string;
    coordinates: number[];
  };

  @Prop({ required: true })
  address: string;

  @Prop({ required: true })
  startTime: Date;

  @Prop({ required: true })
  endTime: Date;

  @Prop({ required: true, min: 1 })
  maxParticipants: number;

  @Prop({ type: Types.ObjectId, ref: 'User', required: true })
  hostId: Types.ObjectId;

  @Prop({ 
    type: String, 
    enum: ['active', 'full', 'expired'], 
    default: 'active' 
  })
  status: string;
}

export const ActivitySchema = SchemaFactory.createForClass(Activity);

// Create 2dsphere index for geospatial queries
ActivitySchema.index({ location: '2dsphere' });

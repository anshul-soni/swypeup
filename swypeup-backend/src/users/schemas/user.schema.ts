import { Prop, Schema, SchemaFactory } from '@nestjs/mongoose';
import { Document } from 'mongoose';

export type UserDocument = User & Document;

@Schema({ timestamps: true })
export class User {
  @Prop({ required: true })
  name: string;

  @Prop()
  profilePictureUrl?: string;

  @Prop()
  bio?: string;

  @Prop({ required: true })
  email: string;

  @Prop({ required: true })
  password: string;

  @Prop({ required: true, default: 'local' })
  authProvider: string;

  @Prop()
  authId?: string;
}

export const UserSchema = SchemaFactory.createForClass(User);

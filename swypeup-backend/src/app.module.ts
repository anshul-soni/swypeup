import { Module } from '@nestjs/common';
import { ConfigModule } from '@nestjs/config';
import { MongooseModule } from '@nestjs/mongoose';
import { AppController } from './app.controller';
import { AppService } from './app.service';
import { AuthModule } from './auth/auth.module';
import { UsersModule } from './users/users.module';
import { ActivitiesModule } from './activities/activities.module';
import { ChatController } from './controllers/chat.controller';
import { ChatService } from './services/chat.service';

@Module({
  imports: [
    ConfigModule.forRoot({
      isGlobal: true,
    }),
    MongooseModule.forRoot(process.env.MONGO_URI || 'mongodb://localhost:27017/swypeup'),
    AuthModule,
    UsersModule,
    ActivitiesModule,
  ],
  controllers: [AppController, ChatController],
  providers: [AppService, ChatService],
})
export class AppModule {}

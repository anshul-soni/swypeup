import { IsNotEmpty, IsString, IsNumber, IsDateString, Min, IsArray } from 'class-validator';

export class CreateActivityDto {
  @IsNotEmpty()
  @IsString()
  title: string;

  @IsNotEmpty()
  @IsString()
  description: string;

  @IsArray()
  @IsNumber({}, { each: true })
  location: number[]; // [longitude, latitude]

  @IsNotEmpty()
  @IsString()
  address: string;

  @IsDateString()
  startTime: string;

  @IsDateString()
  endTime: string;

  @IsNumber()
  @Min(1)
  maxParticipants: number;
}

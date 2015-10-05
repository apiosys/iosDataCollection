/*
 //  CSensorSampleInfoContainer.h
 //  CoreMotionCapture
 //
 //  Created by Jeff Behrbaum on 9/26/14.
 //  Copyright (c) 2014 Apio Systems. All rights reserved.
 */

#import <Foundation/Foundation.h>

@class CMGyroData;
@class CLLocation;
@class CMDeviceMotion;
@class CMAccelerometerData;
@class CMMagnetometerData;

@interface CSensorSampleInfoContainer : NSObject

+(NSDate *)startRecTime;
+(void)setStartRecTime:(NSDate *)startRecTime;

@property(nonatomic, strong) NSDate *dateOfRecord;

@property(nonatomic, strong) CMGyroData *gyroData;
@property(nonatomic, strong) CLLocation *locationData;
@property(nonatomic, strong) CMDeviceMotion *motionData;

@property(nonatomic, strong) CMMagnetometerData *magnetrometerData;
@property(nonatomic, strong) CMAccelerometerData *rawAcceleration;

-(BOOL)stopSensors;
-(BOOL)startSensors;

@end

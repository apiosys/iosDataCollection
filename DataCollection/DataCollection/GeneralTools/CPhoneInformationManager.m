//
//  CPhoneInformationManager.m
//  DataCollection
//
//  Created by Brandon Bodnar on 10/15/15.
//  Copyright © 2015 Apio Systems. All rights reserved.
//

#import "CPhoneInformationManager.h"

#import "CMotionLogger.h"

static NSString * const WALKING_INCLUDE_IN_LOG_KEY =@"WALKING_INCLUDE_IN_LOG_KEY";
static NSString * const WALKING_SIDE_KEY = @"WALKING_SIDE_KEY";
static NSString * const WALKING_DEVICE_LOCATION_KEY = @"WALKING_DEVICE_LOCATION_KEY";
static NSString * const VEHICLE_INCLUDE_IN_LOG_KEY = @"VEHICLE_INCLUDE_IN_LOG_KEY";
static NSString * const VEHICLE_SIDE_KEY = @"VEHICLE_SIDE_KEY";
static NSString * const VEHICLE_DEVICE_LOCATION_KEY = @"VEHICLE_DEVICE_LOCATION_KEY";
static NSString * const VEHICLE_ENTRY_INCLUDE_IN_LOG_KEY = @"VEHICLE_ENTRY_INCLUDE_IN_LOG_KEY";
static NSString * const VEHICLE_ENTRY_SIDE_KEY = @"VEHICLE_ENTRY_SIDE_KEY";
static NSString * const VEHICLE_ENTRY_END_KEY = @"VEHICLE_ENTRY_END_KEY";

@interface CPhoneInformationManager()

	-(void)loadData;

@end

@implementation CPhoneInformationManager

+ (CPhoneInformationManager *)thePhoneInformationManager
{
	static CPhoneInformationManager *phoneInformationMgr;

	static dispatch_once_t onceToken;

	dispatch_once(&onceToken, ^{
		phoneInformationMgr = [[CPhoneInformationManager alloc] init];
		[phoneInformationMgr loadData];
	});

	return phoneInformationMgr;
}

-(NSArray *)allWalkingDevicePositionLocations
{
	return @[
			 @"Hand",
			 @"Purse",
			 @"Sling Bag",
			 @"Backpack",
			 @"Front Pants Pocket",
			 @"Rear Pants Pocket",
			 @"Cargo Pocket",
			 @"Jacket Pocket",
			 @"Breast Pocket Outside",
			 @"Breast Pocket Inside"
			 ];
}

-(NSArray *)allVehicleDevicePositionLocations
{
	return @[
			 @"Console",
			 @"Cradle",
			 @"Cup Holder",
			 @"Back Seat",
			 @"Front Seat",
			 @"Front-Door",
			 @"Back Door",
			 @"Trunk"
			 ];
}

-(void)logPhoneInformationUsing:(CMotionLogger *)logger
{
	if (self.walkingDevicePositionIncludeInLog)
	{
		[logger logWalkingDevicePositionWithSide: self.walkingDevicePositionSide andLocation: self.walkingDevicePositionLocation];
	}

	if (self.vehicleDevicePositionIncludeInLog)
	{
		[logger logVehicleDevicePositionWithSide: self.vehicleDevicePositionSide andLocation: self.vehicleDevicePositionLocation];
	}

	if (self.vehicleEntryInformationIncludeInLog)
	{
		[logger logVehicleEntryInformationWithVehicleEnd: self.vehicleEntryInformationVehicleEnd andVehicleSide: self.vehicleEntryInformationVehicleSide];
	}
}

-(void)loadData
{
	NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];

	[defaults registerDefaults:@{
								 WALKING_INCLUDE_IN_LOG_KEY:@NO,
								 WALKING_SIDE_KEY:[NSNumber numberWithInt:VehicleSideLeft],
								 WALKING_DEVICE_LOCATION_KEY:self.allWalkingDevicePositionLocations.firstObject,
								 VEHICLE_INCLUDE_IN_LOG_KEY:@NO,
								 VEHICLE_SIDE_KEY:[NSNumber numberWithInt:VehicleSideLeft],
								 VEHICLE_DEVICE_LOCATION_KEY:self.allVehicleDevicePositionLocations.firstObject,
								 VEHICLE_ENTRY_INCLUDE_IN_LOG_KEY:@NO,
								 VEHICLE_ENTRY_END_KEY:[NSNumber numberWithInt:VehicleEndFront],
								 VEHICLE_ENTRY_SIDE_KEY:[NSNumber numberWithInt:VehicleSideLeft]
								 }];

	self.walkingDevicePositionIncludeInLog = [defaults boolForKey:WALKING_INCLUDE_IN_LOG_KEY];
	self.walkingDevicePositionSide = [defaults integerForKey:WALKING_SIDE_KEY];
	self.walkingDevicePositionLocation = [defaults stringForKey:WALKING_DEVICE_LOCATION_KEY];

	self.vehicleDevicePositionIncludeInLog = [defaults boolForKey:VEHICLE_INCLUDE_IN_LOG_KEY];
	self.vehicleDevicePositionSide = [defaults integerForKey:VEHICLE_SIDE_KEY];
	self.vehicleDevicePositionLocation = [defaults stringForKey:VEHICLE_DEVICE_LOCATION_KEY];


	self.vehicleEntryInformationIncludeInLog = [defaults boolForKey:VEHICLE_ENTRY_INCLUDE_IN_LOG_KEY];
	self.vehicleEntryInformationVehicleEnd = [defaults integerForKey:VEHICLE_ENTRY_END_KEY];
	self.vehicleEntryInformationVehicleSide = [defaults integerForKey:VEHICLE_ENTRY_SIDE_KEY];
}

-(BOOL)saveData
{
	NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];

	[defaults setBool:self.walkingDevicePositionIncludeInLog forKey:WALKING_INCLUDE_IN_LOG_KEY];
	[defaults setInteger:self.walkingDevicePositionSide forKey:WALKING_SIDE_KEY];
	[defaults setObject:self.walkingDevicePositionLocation forKey:WALKING_DEVICE_LOCATION_KEY];

	[defaults setBool:self.vehicleDevicePositionIncludeInLog forKey:VEHICLE_INCLUDE_IN_LOG_KEY];
	[defaults setInteger:self.vehicleDevicePositionSide forKey:VEHICLE_SIDE_KEY];
	[defaults setObject:self.vehicleDevicePositionLocation forKey:VEHICLE_DEVICE_LOCATION_KEY];

	[defaults setBool:self.vehicleEntryInformationIncludeInLog forKey:VEHICLE_ENTRY_INCLUDE_IN_LOG_KEY];
	[defaults setInteger:self.vehicleEntryInformationVehicleSide forKey:VEHICLE_ENTRY_SIDE_KEY];
	[defaults setInteger:self.vehicleEntryInformationVehicleEnd forKey:VEHICLE_ENTRY_END_KEY];

	return [defaults synchronize];
}

@end

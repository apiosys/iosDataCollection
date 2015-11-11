//
//  CPhoneInformationManager.h
//  DataCollection
//
//  Created by Brandon Bodnar on 10/15/15.
//  Copyright © 2015 Apio Systems. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PhoneInformationDefs.h"

@class CMotionLogger;

@interface CPhoneInformationManager : NSObject

+(CPhoneInformationManager*) thePhoneInformationManager;

@property(nonatomic) BOOL enableLoggingOfWalkingDevicePosition;
@property(nonatomic) WalkingSide walkingDevicePositionSide;
@property(nonatomic) NSString * walkingDevicePositionLocation;

@property(nonatomic) BOOL enableLoggingOfVehicleDevicePosition;
@property(nonatomic) VehicleSide vehicleDevicePositionSide;
@property(nonatomic) NSString * vehicleDevicePositionLocation;


@property(nonatomic) BOOL enableLoggingOfVehicleEntryInformation;
@property(nonatomic) VehicleEnd vehicleEntryInformationVehicleEnd;
@property(nonatomic) VehicleSide vehicleEntryInformationVehicleSide;

-(NSArray*) allWalkingDevicePositionLocations;
-(NSArray*) allVehicleDevicePositionLocations;

-(void) logPhoneInformation;

-(BOOL) saveData;

@end

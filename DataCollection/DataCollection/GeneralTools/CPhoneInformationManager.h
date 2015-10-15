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

@property(nonatomic) BOOL walkingDevicePositionIncludeInLog;
@property(nonatomic) VehicleSide walkingDevicePositionSide;
@property(nonatomic) NSString * walkingDevicePositionLocation;

@property(nonatomic) BOOL vehicleDevicePositionIncludeInLog;
@property(nonatomic) VehicleSide vehicleDevicePositionSide;
@property(nonatomic) NSString * vehicleDevicePositionLocation;


@property(nonatomic) BOOL vehicleEntryInformationIncludeInLog;
@property(nonatomic) VehicleEnd vehicleEntryInformationVehicleEnd;
@property(nonatomic) VehicleSide vehicleEntryInformationVehicleSide;

-(NSArray*) allWalkingDevicePositionLocations;
-(NSArray*) allVehicleDevicePositionLocations;

-(void) logPhoneInformationUsing:(CMotionLogger*) logger;

-(BOOL) saveData;

@end

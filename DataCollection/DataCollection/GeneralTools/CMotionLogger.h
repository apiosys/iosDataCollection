#import <Foundation/Foundation.h>
#import "PhoneInformationDefs.h"

@class CSensorSampleInfoContainer;

@interface CMotionLogger : NSObject

+(CMotionLogger *)theLogger;

@property(nonatomic, readonly) BOOL isLogging;

-(void)closeFileDescriptor;

/**
 @param: bIsStarting = TRUE (Starting to type/text) FALSE = Completed your typing/texting
 */
-(void)logTexting:(BOOL)bIsStarting;
-(void)logPhoneCall:(BOOL)bIsStarting;
-(void)logUserIsDriver:(BOOL)bUserIsDriver;
-(void)logGeneralHandling:(BOOL)bIsStarting;

-(void)logWalkingDeviceSide:(WalkingSide)side;
-(void)logWalkingDeviceLocation:(NSString*) location;
-(void)logVehicleDeviceSide:(VehicleSide)side;
-(void)logVehicleDeviceLocation:(NSString*) location;
-(void)logVehicleEntryVehicleEnd:(VehicleEnd)end;
-(void)logVehicleEntryVehicleSide:(VehicleSide)side;

-(void)writeCurrentSamplesToLogFile;
-(void)writeLineToLog:(NSString *)lineEntry;
-(void)markAsStartDataCaptureTime;//Used to name the log file. The file is named the start time.

@end

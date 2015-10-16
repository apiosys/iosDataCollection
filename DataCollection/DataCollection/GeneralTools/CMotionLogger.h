#import <Foundation/Foundation.h>

@class CSensorSampleInfoContainer;

@interface CMotionLogger : NSObject

+(CMotionLogger *)theLogger;

-(void)closeFileDescriptor;

/**
 @param: bIsStarting = TRUE (Starting to type/text) FALSE = Completed your typing/texting
 */
-(void)logTexting:(BOOL)bIsStarting;
-(void)logPhoneCall:(BOOL)bIsStarting;
-(void)logUserIsDriver:(BOOL)bUserIsDriver;
-(void)logGeneralHandling:(BOOL)bIsStarting;

-(void)writeCurrentSamplesToLogFile;
-(void)writeLineToLog:(NSString *)lineEntry;
-(void)markAsStartDataCaptureTime;//Used to name the log file. The file is named the start time.

@end

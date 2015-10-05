/*
//  STAltimiterMonitor.h
//  DataCollection
//
//  Created by Jeff Behrbaum on 10/5/15.
//  Copyright © 2015 Apio Systems. All rights reserved.
*/

#import <Foundation/Foundation.h>

@class CMAltitudeData;
@class CMMotionManager;

@interface STAltimiterMonitor : NSObject

/**
 The actual altimiter data as provided by Core Motion
 */
@property(nonatomic, readonly) CMAltitudeData *latestAltimiterData;//Don't synthesize

@property(nonatomic, readonly) NSString *printableAltimiterInfo;

/**
 Allows the caller to stop listening for the altimiter updates.
 
 @param motionMgr The motion manager used to access the altimiter.
 */
-(void)stopAltimiter:(CMMotionManager *)motionMgr;

/**
 Allows the caller to start monitoring the altimiter.
 
 @param motionMgr - The motion manager used to access the altimiter.
 
 @return True if the altimiter is available and was started successfully. False otherwise.
 */
-(BOOL)startAltimiter:(CMMotionManager *)motionMgr;

@end

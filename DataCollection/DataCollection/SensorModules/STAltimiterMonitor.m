/*
//  STAltimiterMonitor.m
//  DataCollection
//
//  Created by Jeff Behrbaum on 10/5/15.
//  Copyright © 2015 Apio Systems. All rights reserved.
*/

#import <CoreMotion/CoreMotion.h>

#import "STAltimiterMonitor.h"

@interface STAltimiterMonitor()
	@property(nonatomic, strong) CMAltimeter *altimeterManager;
	@property(nonatomic, strong) CMAltitudeData *altimiterData;
@end

@implementation STAltimiterMonitor

@synthesize altimiterData = _altimiterData;
@synthesize altimeterManager = _altimeterManager;

-(CMAltitudeData *)latestAltimiterData
{
	return _altimiterData;
}

-(CMAltimeter *)altimeterManager
{
	if(_altimeterManager == nil)
		_altimeterManager = [[CMAltimeter alloc]init];

	return _altimeterManager;
}

-(NSString *)printableAltimiterInfo
{
	if(self.altimiterData == nil)
		return @"-:- -:-";
	
	NSString *str = @"Alt:";
	
	//Altitiude in meters
	//The pressure in kPa.
	str = [NSString stringWithFormat:@"%.4lf %.4lf", [self.altimiterData.relativeAltitude floatValue], [self.altimiterData.pressure floatValue]];

	return str;
}

-(void)stopAltimiter:(CMMotionManager *)motionMgr
{
	if([CMAltimeter isRelativeAltitudeAvailable] == TRUE)
		[self.altimeterManager stopRelativeAltitudeUpdates];
}

-(BOOL)startAltimiter:(CMMotionManager *)motionMgr
{
	if([CMAltimeter isRelativeAltitudeAvailable] == FALSE)
		return FALSE;
	
	[self.altimeterManager startRelativeAltitudeUpdatesToQueue:[NSOperationQueue mainQueue] withHandler:^(CMAltitudeData *altitudeData, NSError *error) {
		self.altimiterData = altitudeData;
	}];
	
	return TRUE;
}


@end

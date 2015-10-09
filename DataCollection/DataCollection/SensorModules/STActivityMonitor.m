/*
//  STActivityMonitor.m
//  SALTester
//
//  Created by Jeff Behrbaum on 2/24/15.
//  Copyright (c) 2015 Apio Systems. All rights reserved.
*/

#import <CoreMotion/CoreMotion.h>

#import "STActivityMonitor.h"

@interface STActivityMonitor()
	@property(nonatomic, strong) CMMotionActivity *latestActivity;
	@property(nonatomic, strong) CMMotionActivityManager *activityManager;

	-(void)onMotionActivity:(CMMotionActivity *)activity;
@end

@implementation STActivityMonitor

@synthesize latestActivity = _latestActivity;
@synthesize activityManager = _activityManager;

-(BOOL)bHasNativeMotionActivityDetection
{
	return [CMMotionActivityManager isActivityAvailable];
}

-(CMMotionActivity *)currActivity
{
	@synchronized(self)
	{
		return self.latestActivity;
	}
}

-(NSString *)printableActivityInfo
{
	static const int ACTIVITY_UNKNOWN = 0;
	static const int ACTIVITY_CYCLING = 1;
	static const int ACTIVITY_WALKING = 2;
	static const int ACTIVITY_RUNNING = 3;
	static const int ACTIVITY_CARMODE = 4;
	static const int ACTIVITY_NO_MOVEMENT = 5;
	static const int ACTIVITY_CAR_AND_STATIONARY = 6;
	
	static const int CONFIDENCE_LOW = 0;
	static const int CONFIDENCE_MED = 1;
	static const int CONFIDENCE_HIGH = 2;
	
	if(self.latestActivity == nil)
		return @"0 0";
	
	int confidence = 0;
	switch (self.latestActivity.confidence)
	{
		case CMMotionActivityConfidenceLow:
			confidence = CONFIDENCE_LOW;
			break;
		case CMMotionActivityConfidenceMedium:
			confidence = CONFIDENCE_MED;
			break;
		case CMMotionActivityConfidenceHigh:
			confidence = CONFIDENCE_HIGH;
			break;
		default:
			break;
	}

	int event = ACTIVITY_UNKNOWN;

	if(self.latestActivity.unknown == TRUE)
		event = ACTIVITY_UNKNOWN;

	if(self.latestActivity.automotive == TRUE)
		event = ACTIVITY_CARMODE;

	if(self.latestActivity.cycling == TRUE)
		event = ACTIVITY_CYCLING;

	if(self.latestActivity.running == TRUE)
		event = ACTIVITY_RUNNING;

	if(self.latestActivity.walking == TRUE)
		event = ACTIVITY_WALKING;

	if(self.latestActivity.stationary == TRUE)
		event = ACTIVITY_NO_MOVEMENT;

	if (self.latestActivity.stationary  == TRUE && self.latestActivity.automotive == TRUE) {
		event = ACTIVITY_CAR_AND_STATIONARY;
	}

	return [NSString stringWithFormat:@"%d %d", event, confidence];
}

-(void)stopActivityMonitoring
{
	if(self.activityManager == nil)
		return;//Not much to do.

	[self.activityManager stopActivityUpdates];
	self.activityManager = nil;
}

-(BOOL)startUpActivityMonitoring
{
	if([CMMotionActivityManager isActivityAvailable] == FALSE)
		return FALSE;

	if(self.activityManager != nil)
		return TRUE;//Means you've already started up your activity monitoring.

	self.activityManager = [[CMMotionActivityManager alloc]init];

	STActivityMonitor *__weak weakSelf = self;

	[self.activityManager startActivityUpdatesToQueue:[NSOperationQueue mainQueue] withHandler:^(CMMotionActivity *activity) {
		[weakSelf onMotionActivity:activity];
	}];

	return TRUE;
}

-(void)onMotionActivity:(CMMotionActivity *)activity
{
	@synchronized(self)
	{
		self.latestActivity = activity;

		//if(isLoggingAllowed() == true)
		//	[self activityToString:activity];
	}
}

@end

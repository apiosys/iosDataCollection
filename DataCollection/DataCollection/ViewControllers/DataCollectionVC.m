/*
//  DataCollectionVC.m
//  DataCollection
//
//  Created by Jeff Behrbaum on 10/5/15.
//  Copyright © 2015 Apio Systems. All rights reserved.
*/

#import <Coremotion/CoreMotion.h>
#import <CoreLocation/CoreLocation.h>

#import "DataCollectionVC.h"

#import "AppDelegate.h"

#import "CSensorSampleInfoContainer.h"
#import "STSensorManager.h"

#import "CMotionLogger.h"
#import "CPhoneInformationManager.h"

@interface DataCollectionVC ()
	@property(nonatomic) BOOL bIsRunning;

	@property(nonatomic, readonly) NSString *stopPhoneCall;
	@property(nonatomic, readonly) NSString *startPhoneCall;

	@property(nonatomic, readonly) NSString *stopGeneralHandling;
	@property(nonatomic, readonly) NSString *startGeneralHandling;

	@property(nonatomic, strong) UIColor *activeButtonColor;
	@property(nonatomic, strong) UIColor *inactiveButtonColor;
	@property(nonatomic, strong) UIColor *sensorsStoppedColor;

	@property(nonatomic, weak) IBOutlet UIButton *btnStopRecording;
	@property(nonatomic, weak) IBOutlet UIButton *btnStartRecording;
	@property (weak, nonatomic) IBOutlet UIButton *btnStartStopPhoneCall;
	@property (weak, nonatomic) IBOutlet UIButton *btnStartStopGeneralHandling;

	@property (weak, nonatomic) IBOutlet UISwitch *userIsDriverSwitch;
	@property(nonatomic, weak) IBOutlet UIActivityIndicatorView *activityWheel;

	-(IBAction)onStopSensors:(UIButton *)sender;
	-(IBAction)onStartSensors:(UIButton *)sender;
	-(IBAction)onGeneralHandling:(UIButton *)sender;
	-(IBAction)onUserIsDriverSwitch:(UISwitch *)sender;
	-(IBAction)onPhoneCallSimulation:(UIButton *)sender;
@end

@implementation DataCollectionVC

@synthesize lblAppInfo = _lblAppInfo;
@synthesize bIsRunning = _bIsRunning;
@synthesize activityWheel = _activityWheel;
@synthesize btnStopRecording = _btnStopRecording;
@synthesize btnStartRecording = _btnStartRecording;
@synthesize activeButtonColor = _activeButtonColor;
@synthesize sensorsStoppedColor = _sensorsStoppedColor;
@synthesize inactiveButtonColor = _inactiveButtonColor;

-(NSString *)stopPhoneCall
{
	return @"Stop Phone Call";
}

-(NSString *)startPhoneCall
{
	return @"Start Phone Call";
}

-(NSString *)stopGeneralHandling
{
	return @"Stop General Handling";
}

-(NSString *)startGeneralHandling
{
	return @"Start General Handling";
}

-(UIColor *)activeButtonColor
{
	if(_activeButtonColor == nil)
		_activeButtonColor = [UIColor colorWithRed:21.0 / 255.0 green:126.0 / 255.0 blue:251.0 / 255.0 alpha:1.0];
	
	return _activeButtonColor;
}

-(UIColor *)inactiveButtonColor
{
	if(_inactiveButtonColor == nil)
		_inactiveButtonColor = [UIColor colorWithRed:135.0 / 255.0 green:206.0 / 255.0 blue:250.0 / 255.0 alpha:1.0];
	
	return _inactiveButtonColor;
}

-(UIColor *)sensorsStoppedColor
{
	if(_sensorsStoppedColor == nil)
		_sensorsStoppedColor = [UIColor colorWithRed:127.0 / 255.0 green:127.0 / 255.0 blue:127.0 / 255.0 alpha:1.0];
	
	return _sensorsStoppedColor;
}

-(void)viewDidLoad
{
	[super viewDidLoad];
	
	NSString *bundleName = [[NSBundle mainBundle] bundleIdentifier];
	
	id localizedValue = [[[NSBundle mainBundle] localizedInfoDictionary] objectForKey:@"CFBundleShortVersionString"];
	NSString *strVersion =  (localizedValue != nil) ? localizedValue : [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
	
	NSString *strVer = [NSString stringWithFormat:@"Ver: %@", strVersion];
	NSString *strName = [[bundleName componentsSeparatedByString:@"."] lastObject];
	
	self.lblAppInfo.text = [NSString stringWithFormat:@"%@ - %@", strName, strVer];
	
	// Do any additional setup after loading the view, typically from a nib.
	self.bIsRunning = FALSE;
}

-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
	[STSensorManager theSensorManager].deviceOrientation = [[UIDevice currentDevice] orientation];
}

//The return/done button on the keyboard was selected
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
	const char LF = 10;
	
	if( (text == nil) || (text.length < 1) )
		return TRUE;
	
	if([text characterAtIndex:0] == LF)
	{
		if(self.bIsRunning == TRUE)
			[[CMotionLogger theLogger] logTexting:FALSE];
		
		textView.text = @"Start Your Texting";
		[textView resignFirstResponder];
	}
	
	return TRUE;
}

-(BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
	if(self.bIsRunning == TRUE)
	{
		[[CMotionLogger theLogger] logTexting:TRUE];
		textView.text = nil;
	}
	
	return self.bIsRunning;
}

-(void)outlineButton:(UIButton *)btn state:(BOOL)bActive
{
	if(bActive == TRUE)
	{
		btn.layer.borderWidth = 0.0;
		btn.layer.borderColor = nil;
		btn.backgroundColor = self.activeButtonColor;
	}
	else
	{
		btn.layer.borderWidth = 1.0;
		btn.layer.borderColor = [UIColor blackColor].CGColor;
		btn.backgroundColor = self.inactiveButtonColor;
	}
}

-(IBAction)onUserIsDriverSwitch:(UISwitch *)sender
{
	[[CMotionLogger theLogger] logUserIsDriver:sender.on];
}

-(IBAction)onPhoneCallSimulation:(UIButton *)sender
{
	if(self.bIsRunning == FALSE)
		return;
	
	if([sender.currentTitle caseInsensitiveCompare:self.startPhoneCall] == NSOrderedSame)
	{
		[[CMotionLogger theLogger]logPhoneCall:TRUE];
		[sender setTitle:self.stopPhoneCall forState:UIControlStateNormal];
		
		[self outlineButton:self.btnStartStopPhoneCall state:FALSE];
	}
	else
	{
		[[CMotionLogger theLogger]logPhoneCall:FALSE];
		[sender setTitle:self.startPhoneCall forState:UIControlStateNormal];
		
		[self outlineButton:self.btnStartStopPhoneCall state:TRUE];
	}
}

-(IBAction)onGeneralHandling:(UIButton *)sender
{
	if(self.bIsRunning == FALSE)
		return;
	
	if([sender.currentTitle caseInsensitiveCompare:self.startGeneralHandling] == NSOrderedSame)
	{
		[[CMotionLogger theLogger]logGeneralHandling:TRUE];
		[sender setTitle:self.stopGeneralHandling forState:UIControlStateNormal];
		
		[self outlineButton:self.btnStartStopGeneralHandling state:FALSE];
	}
	else
	{
		[[CMotionLogger theLogger]logGeneralHandling:FALSE];
		[sender setTitle:self.startGeneralHandling forState:UIControlStateNormal];
		
		[self outlineButton:self.btnStartStopGeneralHandling state:TRUE];
		
	}
}

-(IBAction)onStartSensors:(UIButton *)sender
{
	if(self.bIsRunning == TRUE)
		return;
	
	self.btnStopRecording.backgroundColor =
	self.btnStartRecording.backgroundColor =
	self.btnStartStopPhoneCall.backgroundColor =
	self.btnStartStopGeneralHandling.backgroundColor = self.activeButtonColor;
	
	//Before anything else happens - mark the start recording time!
	CSensorSampleInfoContainer.startRecTime = [NSDate date];
	
	[[CMotionLogger theLogger] markAsStartDataCaptureTime];
	[[CMotionLogger theLogger] logUserIsDriver:self.userIsDriverSwitch.on];
	[[CPhoneInformationManager thePhoneInformationManager] logPhoneInformationUsing:[CMotionLogger theLogger]];
	
	if ([[STSensorManager theSensorManager] startSensors] == FALSE)
		NSLog(@"Failed to start all the sensors");
	
	self.bIsRunning = TRUE;
}

-(IBAction)onStopSensors:(UIButton *)sender
{
	if(self.bIsRunning == FALSE)
		return;
	
	[self.btnStartStopPhoneCall setTitle:self.startPhoneCall forState:UIControlStateNormal];
	[self.btnStartStopGeneralHandling setTitle:self.startGeneralHandling forState:UIControlStateNormal];
	
	self.btnStopRecording.backgroundColor =
	self.btnStartRecording.backgroundColor =
	self.btnStartStopPhoneCall.backgroundColor =
	self.btnStartStopGeneralHandling.backgroundColor = self.sensorsStoppedColor;
	
	[self.activityWheel startAnimating];
	self.btnStopRecording.enabled = self.btnStartRecording.enabled = FALSE;
	
	self.bIsRunning = FALSE;
	
	[[STSensorManager theSensorManager] stopSensors];
	
	[self.activityWheel stopAnimating];
	self.btnStopRecording.enabled = self.btnStartRecording.enabled = TRUE;
	
	[[CMotionLogger theLogger] closeFileDescriptor];
}

@end

/*
//  CBtleConnectionViewController.m
//  CoreMotionCapture
//
//  Created by Jeff Behrbaum on 7/15/15.
//  Copyright (c) 2015 Apio Systems. All rights reserved.
*/

#import "CBtleConnectionViewController.h"

@interface CBtleConnectionViewController ()

-(IBAction)onToolbarBackSelect:(UIButton *)sender;

@end

@implementation CBtleConnectionViewController

-(void)viewDidLoad
{
	[super viewDidLoad];

	// Do any additional setup after loading the view.
}

#pragma mark - Bluetooth manager connection callbacks

-(void)calledToConnect
{}

-(void)disconnecteCalled
{}

-(void)discoveredNewPeripheral:(CBPeripheral *)peripheral
{}

-(void)connectedToPeripheral:(BOOL)bConnected thePeripheral:(CBPeripheral *)peripheral
{}

-(IBAction)onToolbarBackSelect:(UIButton *)sender
{
	[self.navigationController popViewControllerAnimated:YES];	
}

@end

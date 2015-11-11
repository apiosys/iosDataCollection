/*
//  BTConnectionVC.m
//  DataCollection
//
//  Created by Jeff Behrbaum on 10/5/15.
//  Copyright © 2015 Apio Systems. All rights reserved.
*/

#import "BTConnectionVC.h"
#import <OHAlertView/OHAlertView.h>

@interface BTConnectionVC ()
	@property(nonatomic, strong) CBPeripheral *peripheral;

	@property(nonatomic, weak) IBOutlet UITextField *txtbxPeripheral;

	@property(nonatomic, weak) IBOutlet UIButton *discoverBTPeripheral;
	@property(nonatomic, weak) IBOutlet UIButton *connectToBTPeripheral;
@end

@implementation BTConnectionVC

-(void)viewDidLoad
{
	[super viewDidLoad];

	// Do any additional setup after loading the view.
	[[CentralManager theCentral] addDelegateListener:self];
	[self disableConnectButton];
}

-(void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];

	if(self.peripheral == nil)
		[self disableConnectButton];
	else if(self.peripheral.state == CBPeripheralStateDisconnected)
		[self enableConnectButton];//If you have a peripheral that isn't yet connected,
}

-(void)displayPeripheralInfomation
{
	if([NSThread isMainThread] == FALSE)
	{
		[self performSelectorOnMainThread:@selector(displayPeripheralInfomation) withObject:nil waitUntilDone:FALSE];
		return;
	}

	if(self.peripheral == nil)
	{
		[OHAlertView showAlertWithTitle:@"No Peripherals" message:@"There are no discovered periperals to connect to." dismissButton:@"OK"];
		return;
	}
	
	if(self.peripheral.state == CBPeripheralStateConnecting)
		return;//You'll get this callback when "connected" is

	switch (self.peripheral.state)
	{
		case CBPeripheralStateConnected:
			[self enableConnectButton];
			[self.connectToBTPeripheral setTitle:@"Disconnect" forState:UIControlStateNormal];
			self.txtbxPeripheral.text = self.peripheral.name;
			break;
		case CBPeripheralStateDisconnected:
		default:
			[self enableConnectButton];
			[self.connectToBTPeripheral setTitle:@"Connect" forState:UIControlStateNormal];
			self.txtbxPeripheral.text = self.peripheral.name;
			break;
	}
}

-(void)enableConnectButton
{
	[self.connectToBTPeripheral setTitle:@"Connect" forState:UIControlStateNormal];
	self.connectToBTPeripheral.enabled = TRUE;
	self.connectToBTPeripheral.layer.opacity = 1.0;
}

-(void)disableConnectButton
{
	[self.connectToBTPeripheral setTitle:@"Connect" forState:UIControlStateNormal];
	self.connectToBTPeripheral.enabled = FALSE;
	self.connectToBTPeripheral.layer.opacity = 0.5;
}

#pragma mark - calls to find and connect to peripherals

-(IBAction)onFindPeripherals:(UIButton *)sender
{
	[[CentralManager theCentral] startScanning];
}

-(IBAction)onConnectDisconnectPeripherals:(UIButton *)sender
{
	[[CentralManager theCentral] stopScanning];

	if( (self.peripheral != nil) && (self.peripheral.state == CBPeripheralStateConnected) )
	{
		[[CentralManager theCentral] disconnectAllBTPeripherals];
		return;
	}

	if([CentralManager theCentral].numberOfPeripherals <= 0)
	{
		[OHAlertView showAlertWithTitle:@"No Peripherals" message:@"There are no discovered periperals which have been found." dismissButton:@"OK"];
		return;
	}

	if([CentralManager theCentral].numberOfPeripherals > 1)
	{
		[OHAlertView showAlertWithTitle:@"Too many Peripherals" message:@"There are to many discovered periperals found." dismissButton:@"OK"];
		return;
	}

	self.peripheral = [[CentralManager theCentral] peripheralAtIndex:0];
	[[CentralManager theCentral] connectToPeripheral:self.peripheral];
}

#pragma mark - The bluetooth connection calls

-(void)calledToConnect
{
	if(self.peripheral == nil)
		return;

	[[CentralManager theCentral] connectToPeripheral:self.peripheral];
}

-(void)disconnecteCalled
{
	[[CentralManager theCentral] disconnectAllBTPeripherals];
	[self displayPeripheralInfomation];
	self.peripheral = nil;
	self.connectToBTPeripheral.enabled = FALSE;
}

-(void)discoveredNewPeripheral:(CBPeripheral *)peripheral
{
	if([NSThread isMainThread] == FALSE)
		NSLog(@"Not Main");

	[self enableConnectButton];
	
	self.peripheral = peripheral;
	[self displayPeripheralInfomation];
}

-(void)connectedToPeripheral:(BOOL)bConnected thePeripheral:(CBPeripheral *)peripheral
{
	if( (bConnected == FALSE) || (peripheral == nil) )
	{
		[OHAlertView showAlertWithTitle:@"Connection Failure" message:@"Unable to connect to the peripheral" dismissButton:@"OK"];
		return;
	}
	
	if(self.peripheral != peripheral)
		self.peripheral = peripheral;

	[self displayPeripheralInfomation];
}

@end

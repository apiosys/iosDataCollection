/*
//  BTConnectionVC.m
//  DataCollection
//
//  Created by Jeff Behrbaum on 10/5/15.
//  Copyright © 2015 Apio Systems. All rights reserved.
*/

#import "BTConnectionVC.h"

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
}

#pragma mark - calls to find and connect to peripherals

-(IBAction)onFindPeripherals:(UIButton *)sender
{
	[[CentralManager theCentral] startScanning];
}

-(IBAction)onConnectPeripherals:(UIButton *)sender
{
	[[CentralManager theCentral] stopScanning];

	if([CentralManager theCentral].numberOfPeripherals <= 0)
	{
		UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"No Peripherals" message:@"There are no discovered periperals which have been found." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
		[alert show];
		return;
	}
	
	if([CentralManager theCentral].numberOfPeripherals > 1)
	{
		UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Too many Peripherals" message:@"There are to many discovered periperals found." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
		[alert show];
		return;
	}
	
	self.peripheral = [[CentralManager theCentral] peripheralAtIndex:0];
	[[CentralManager theCentral] connectToPeripheral:self.peripheral];
}

#pragma mark - The bluetooth connection calls

-(void)calledToConnect
{
	
}

-(void)disconnecteCalled
{
	[[CentralManager theCentral] disconnectAllBTPeripherals];
}

-(void)discoveredNewPeripheral:(CBPeripheral *)peripheral
{
	
}

-(void)connectedToPeripheral:(BOOL)bConnected thePeripheral:(CBPeripheral *)peripheral
{
	
}


@end

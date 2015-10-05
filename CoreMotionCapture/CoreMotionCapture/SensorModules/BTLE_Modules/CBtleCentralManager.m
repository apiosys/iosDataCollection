/*
//  CBtleCentralManager.m
//  SALTester
//
//  Created by Jeff Behrbaum on 12/15/14.
//  Copyright (c) 2014 Apio Systems. All rights reserved.
*/

#import "CBtleCentralManager.h"

@interface CBtleCentralManager()
	@property(nonatomic, strong) dispatch_queue_t procQueue;
	@property(nonatomic, strong) CBCentralManager *centralMgr;
@end

@implementation CBtleCentralManager

@synthesize procQueue = _procQueue;
@synthesize centralMgr = _centralMgr;

-(id)init
{
	self = [super init];

	if(self == nil)
		return self;

	self.procQueue = dispatch_queue_create("com.apiosystems.saltester.btlemodule", nil);
	self.centralMgr = [[CBCentralManager alloc]initWithDelegate:self queue:nil];
	
	return self;
}

-(BOOL)startScanning
{
	//CBUUID *ud = [CBUUID UUIDWithString:@"B08D298B-C02A-4E85-B7D4-D7580ADD2323"];
	[self.centralMgr scanForPeripheralsWithServices:nil options:nil];//  @[ud] options:nil];
	return TRUE;
}

#pragma mark - CBCentralManagerDelegate

-(void)centralManagerDidUpdateState:(CBCentralManager *)central
{
	if (central == nil)
	{
		return;
	}

	if(central != self.centralMgr)
		NSLog(@"Why are they different");
	
	switch(central.state)
	{
		case CBCentralManagerStateUnknown:
			NSLog(@"Unknown");
			break;
		case CBCentralManagerStateResetting:
			NSLog(@"Resetting");
			break;
		case CBCentralManagerStateUnsupported:
			NSLog(@"Unsupported");
			break;
		case CBCentralManagerStateUnauthorized:
			NSLog(@"Unauthorized");
			break;
		case CBCentralManagerStatePoweredOff:
			NSLog(@"Power Off");
			break;
		case CBCentralManagerStatePoweredOn:
			NSLog(@"Power ON");
			[self startScanning];
			break;
		default:
			NSLog(@"WTF!!!!");
			break;
	}
}

-(void)stopScan
{
	
}

-(NSArray *)retrieveConnectedPeripheralsWithServices:(NSArray *)serviceUUIDs
{
	return nil;
}

-(void)scanForPeripheralsWithServices:(NSArray *)serviceUUIDs options:(NSDictionary *)options
{
	NSLog(@"Peripheral Scan");
	
}

-(void)connectPeripheral:(CBPeripheral *)peripheral options:(NSDictionary *)options
{
	if(peripheral == nil)
		return;
}

-(void)cancelPeripheralConnection:(CBPeripheral *)peripheral
{
	if(peripheral == nil)
		return;
}

-(void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI
{
	/*
	NSObject *objSvrVal = [advertisementData valueForKey:@"kCBAdvDataServiceData"];
	
	if(objSvrVal != nil)
	{
		if([objSvrVal isKindOfClass:[NSDictionary class]] == TRUE)
		{
			NSDictionary *d = (NSDictionary *)objSvrVal;
			NSArray *arrK = [d allKeys];
			for(NSObject *ok in arrK)
			{
				if([ok isKindOfClass:[CBUUID class]] == TRUE)
					NSLog(@"Requeste Service: %@", ((CBUUID *)ok).UUIDString);
			}
		}
	}
	
	
	NSLog(@"Discovered Peripheral Name: %@", peripheral.name);
	NSLog(@"Peripheral State: %@", (peripheral.state == CBPeripheralStateDisconnected) ? @"Disconneted" : @"Connected'ish");
	
	//[peripheral discoverServices:nil];
	
	for(NSObject *pS in peripheral.services)
		NSLog(@"%@", [pS class]);
	
	NSArray *arrKeys = [advertisementData allKeys];
	NSArray *arrVals = [advertisementData allValues];
	
	for (NSString *sKey in arrKeys)
		NSLog(@"Key: %@", sKey);
	
	for(NSString *sVal in arrVals)
		NSLog(@"Val: %@", sVal);
	
	NSLog(@"RSSI: %@", RSSI);
	
	[self.centralMgr connectPeripheral:peripheral options:nil];
//[self.periphChangeStateDelegate calledToConnect];
*/	
	
}

@end

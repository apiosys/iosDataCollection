/*
//  PeripheralHandler.m
//  BTCentralPract
//
//  Created by Jeff Behrbaum on 12/9/14.
//  Copyright (c) 2014 Apio Systems. All rights reserved.
*/

#import "CentralManager.h"
//#import "CMasterController.h"

#import "PeripheralHandler.h"

@interface PeripheralHandler()
	@property(nonatomic, strong) NSMutableArray *arrPeripherals;

	-(void)printPeripheralInfo:(CBPeripheral *)peripheral;
@end

@implementation PeripheralHandler

@synthesize arrPeripherals = _arrPeripherals;

-(NSMutableArray *)arrPeripherals
{
	if(_arrPeripherals == nil)
		_arrPeripherals = [[NSMutableArray alloc]init];
	
	return _arrPeripherals;
}

-(NSInteger)numberOfDiscoveredPeripherals
{
	return self.arrPeripherals.count;
}

-(CBPeripheral *)peripheralAt:(NSInteger)index
{
	if(index >= self.arrPeripherals.count)
		return nil;
	
	return [self.arrPeripherals objectAtIndex:index];
}

-(void)clearPreviousPeripherals
{
	if(self.arrPeripherals.count <= 0)
		return;
	
	for(CBPeripheral *periph in self.arrPeripherals)
	{
		if(periph.state == CBPeripheralStateConnected)
			[[CentralManager theCentral] cancelPeripheralConnection:periph];
	}
	
	[self.arrPeripherals removeAllObjects];
}

-(BOOL)addPeripheral:(CBPeripheral *)discoveredPeripheral
{
	//NOTE: The name may be nil if the devices aren't paired. Note that some devices
	//have prompted for pairing while others have not. Not sure what to do about this.
	//However, since we're only scanning for the specific service, we can determine that
	//we are here only because we've discovered the service we want.
	//if( (discoveredPeripheral == nil) || (discoveredPeripheral.name == nil) )
	if(discoveredPeripheral == nil)
		return FALSE;
	
	if([self.arrPeripherals containsObject:discoveredPeripheral] == FALSE)
	{
		if(discoveredPeripheral.delegate == nil)
			discoveredPeripheral.delegate = self;

		[self.arrPeripherals addObject:discoveredPeripheral];
	}

	return TRUE;
}

-(void)disconnectAllPeripherals
{
	if(self.arrPeripherals.count <= 0)
		return;
	
	for(CBPeripheral *periph in self.arrPeripherals)
	{
		if(periph.state == CBPeripheralStateConnected)
			[[CentralManager theCentral] cancelPeripheralConnection:periph];
	}
}

-(void)printPeripheralInfo:(CBPeripheral *)peripheral
{
}

-(void)peripheralIsNowConnected:(CBPeripheral *)peripheral
{
	if( (peripheral == nil) || ([self.arrPeripherals containsObject:peripheral] == FALSE) )
		return;

	[self startDiscoveringServices:peripheral];
}

-(void)startDiscoveringServices:(CBPeripheral *)peripheral
{
	if(peripheral == nil)
		return;

	//We'll go ahead and discover all services.
	[peripheral discoverServices:nil];
}

#pragma mark - PeripheralDataChange delegate

-(void)calledToConnect
{}

-(void)disconnecteCalled
{}

-(void)discoveredNewPeripheral:(CBPeripheral *)peripheral
{}

-(void)connectedToPeripheral:(BOOL)bConnected thePeripheral:(CBPeripheral *)peripheral
{
	if(peripheral.delegate == nil)
		peripheral.delegate = self;

	[self startDiscoveringServices:peripheral];
}

#pragma mark - CBPeripheral Delegate calls

-(void)peripheralDidUpdateName:(CBPeripheral *)peripheral
{
}

-(void)peripheral:(CBPeripheral *)peripheral didModifyServices:(NSArray *)invalidatedServices
{
}

-(void)peripheral:(CBPeripheral *)peripheral didReadRSSI:(NSNumber *)RSSI error:(NSError *)error
{
}

-(void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error
{
	for(CBService *svrc in peripheral.services)
	{
		[peripheral discoverCharacteristics:nil forService:svrc];
	}
}

-(void)peripheral:(CBPeripheral *)peripheral didDiscoverIncludedServicesForService:(CBService *)service error:(NSError *)error
{
}

-(void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error
{
	for (NSObject *charObj in service.characteristics)
	{
		CBCharacteristic *c = (CBCharacteristic *)charObj;

		[peripheral setNotifyValue:TRUE forCharacteristic:c];//Means we're telling the peripheral to notify us when the characteristic updates its value.
	}
}

//This is what gets called because of the call to "setNotifyValue"
-(void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
	const int MIN_MSG_LEN = 5;
	const int MAX_MSG_LEN = 32;

	NSString *strValue = [[NSString alloc]initWithData:characteristic.value encoding:NSUTF8StringEncoding];
	if( (strValue.length >= MIN_MSG_LEN) && (strValue.length <= MAX_MSG_LEN) )
	{
		strValue = [strValue stringByAppendingString:@"\n"];
	}
}

-(void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{}

-(void)peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{}

-(void)peripheral:(CBPeripheral *)peripheral didDiscoverDescriptorsForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
}

-(void)peripheral:(CBPeripheral *)peripheral didUpdateValueForDescriptor:(CBDescriptor *)descriptor error:(NSError *)error
{
}

-(void)peripheral:(CBPeripheral *)peripheral didWriteValueForDescriptor:(CBDescriptor *)descriptor error:(NSError *)error
{

}

@end

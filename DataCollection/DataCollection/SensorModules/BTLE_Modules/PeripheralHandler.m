/*
//  PeripheralHandler.m
//  BTCentralPract
//
//  Created by Jeff Behrbaum on 12/9/14.
//  Copyright (c) 2014 Apio Systems. All rights reserved.
*/

#import "CentralManager.h"

#import "CMotionLogger.h"

#import "PeripheralHandler.h"

#import "CentralManager+RemoteDataCollection.h"
#import "NotifierCBUUIDManager.h"

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
	[peripheral discoverServices:@[
								   [NotifierCBUUIDManager eventNotificationServiceUUID],
								   [NotifierCBUUIDManager remoteDataCollectionServiceUUID]
								   ]];
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
		if ([svrc.UUID isEqual:[NotifierCBUUIDManager eventNotificationServiceUUID]])
		{
			[peripheral discoverCharacteristics:@[[NotifierCBUUIDManager eventNotificationMessageCharacteristicUUID]] forService:svrc];
		}
		else if ([svrc.UUID isEqual:[NotifierCBUUIDManager remoteDataCollectionServiceUUID]])
		{
			[peripheral discoverCharacteristics:@[
												  [NotifierCBUUIDManager remoteDataCollectionCommandCharacteristicUUID],
												  [NotifierCBUUIDManager remoteDataCollectionDataCollectorIdentifierCharacteristicUUID],
												  [NotifierCBUUIDManager remoteDataCollectionDataCollectorCollectionStatusCharacteristicUUID],
												  ]
									 forService:svrc];
		}
	}
}

-(void)peripheral:(CBPeripheral *)peripheral didDiscoverIncludedServicesForService:(CBService *)service error:(NSError *)error
{
}

-(void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error
{

	for (CBCharacteristic * characteristic in service.characteristics) {
		if ([characteristic.UUID isEqual:[NotifierCBUUIDManager eventNotificationMessageCharacteristicUUID]])
		{
			[peripheral setNotifyValue:TRUE forCharacteristic:characteristic];
		}
		else if ([characteristic.UUID isEqual:[NotifierCBUUIDManager remoteDataCollectionCommandCharacteristicUUID]])
		{
			[peripheral setNotifyValue:TRUE forCharacteristic:characteristic];
		}
		else if ([characteristic.UUID isEqual:[NotifierCBUUIDManager remoteDataCollectionDataCollectorIdentifierCharacteristicUUID]])
		{
			[[CentralManager theCentral] didDiscoverDataCollectorIdentifierCharacteristic: characteristic ForPeripheral:peripheral];
		}
		else if ([characteristic.UUID isEqual:[NotifierCBUUIDManager remoteDataCollectionDataCollectorCollectionStatusCharacteristicUUID]])
		{
			[[CentralManager theCentral] didDiscoverDataCollectionStatusCharacteristic: characteristic ForPeripheral: peripheral];
		}
	}

}

//This is what gets called because of the call to "setNotifyValue"
-(void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{

	NSString *strValue = [[NSString alloc] initWithData:characteristic.value encoding:NSUTF8StringEncoding];

	// Handle Service Messages (Events Start/Stop and Updated Conditions
	if ([characteristic.UUID isEqual: [NotifierCBUUIDManager eventNotificationMessageCharacteristicUUID]])
	{
		const int MIN_MSG_LEN = 5;
		const int MAX_MSG_LEN = 32;

		if( (strValue.length >= MIN_MSG_LEN) && (strValue.length <= MAX_MSG_LEN) )
		{
			strValue = [strValue stringByAppendingString:@"\n"];
			[[CMotionLogger theLogger] writeLineToLog:strValue];
		}
	}
	else if ([characteristic.UUID isEqual:[NotifierCBUUIDManager remoteDataCollectionCommandCharacteristicUUID]])
	{
		if ([strValue isEqualToString:@"START_CAPTURE"])
		{
			[[CentralManager theCentral] startDataCollection];
		}
		else if ([strValue isEqualToString:@"STOP_CAPTURE"])
		{
			[[CentralManager theCentral] stopDataCollection];
		}
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

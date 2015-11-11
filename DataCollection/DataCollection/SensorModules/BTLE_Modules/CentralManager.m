/*
//  CentralManager.m
//  BTCentralPract
//
//  Created by Jeff Behrbaum on 12/8/14.
//  Copyright (c) 2014 Apio Systems. All rights reserved.
*/

#import "CentralManager.h"
#import "PeripheralHandler.h"
#import "NotifierCBUUIDManager.h"

@interface CentralManager()
	@property(nonatomic, strong) PeripheralHandler *periphHndlr;
	@property(nonatomic, strong) CBCentralManager *centralMgr;
	@property(nonatomic, strong) NSMutableArray *arrDelegateListeners;
	@property(nonatomic, strong) NSMutableDictionary * subscribedPeripheralsToCharacteristicMapForDataCollectionStatus;
@end

@implementation CentralManager
{
	BOOL _bAllowedToScan;
}

@synthesize centralMgr = _centralMgr;
@synthesize periphHndlr = _periphHndlr;
@synthesize arrDelegateListeners = _arrDelegateListeners;

+(CentralManager *)theCentral
{
	static CentralManager *sharedInstance = nil;
	
	static dispatch_once_t onceToken;
	
	dispatch_once(&onceToken, ^{
		sharedInstance = [[CentralManager alloc] init];
	});
	
	return sharedInstance;
}

-(PeripheralHandler *)periphHndlr
{
	if(_periphHndlr == nil)
	{
		_periphHndlr = [[PeripheralHandler alloc]init];
		[self addDelegateListener:_periphHndlr];
	}

	return _periphHndlr;
}

-(id)init
{
	self = [super init];
	
	if(_centralMgr == nil)
	{
		self.centralMgr = [[CBCentralManager alloc]initWithDelegate:self queue:nil];
	}
	
	return self;
}

-(void)addDelegateListener:(id<PeripheralDataChange>) periphChangeStateDelegate
{
	if(self.arrDelegateListeners == nil)
		self.arrDelegateListeners = [[NSMutableArray alloc] init];

	if([self.arrDelegateListeners containsObject:periphChangeStateDelegate] == FALSE)
		[self.arrDelegateListeners addObject:periphChangeStateDelegate];
}

-(NSInteger) numberOfPeripherals
{
	return self.periphHndlr.numberOfDiscoveredPeripherals;
}

-(CBPeripheral *)peripheralAtIndex:(NSInteger)iIndex
{
	return [self.periphHndlr peripheralAt:iIndex];
}

-(void)stopScanning
{
	[self.centralMgr stopScan];
}

-(void)startScanning
{
	if(_bAllowedToScan == FALSE)
		return;

	NSArray * allowedServices = @[[NotifierCBUUIDManager eventNotificationServiceUUID], [NotifierCBUUIDManager remoteDataCollectionServiceUUID]];

	[self.centralMgr scanForPeripheralsWithServices:allowedServices options:nil];
}

-(void)cancelPeripheralConnection:(CBPeripheral *)peripheral
{
	[self.centralMgr cancelPeripheralConnection:peripheral];
}

-(void)connectToPeripheral:(CBPeripheral *)peripheral
{
	if(peripheral == nil)
		return;

	[self.centralMgr connectPeripheral:peripheral options:nil];
}

-(void)disconnectAllBTPeripherals
{
	[self.periphHndlr disconnectAllPeripherals];
}

-(void)centralManagerDidUpdateState:(CBCentralManager *)central
{
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
			_bAllowedToScan = TRUE;
			break;
		default:
			NSLog(@"WTF!!!!");
			break;
	}
}

//-(void)centralManager:(CBCentralManager *)central willRestoreState:(NSDictionary *)dict
//{
//	NSLog(@"Restored state");
//}

-(void)centralManager:(CBCentralManager *)central didRetrievePeripherals:(NSArray *)peripherals
{
	NSLog(@"Retreived Peripherals");
}

-(void)centralManager:(CBCentralManager *)central didRetrieveConnectedPeripherals:(NSArray *)peripherals
{
	NSLog(@"Retreived Connected Peripherals");
}

-(void)centralManager:(CBCentralManager *)central
didDiscoverPeripheral:(CBPeripheral *)peripheral
	 advertisementData:(NSDictionary *)advertisementData
					  RSSI:(NSNumber *)RSSI
{
	[self.periphHndlr addPeripheral:peripheral];
	
	for(id<PeripheralDataChange> peripheralDelegate in self.arrDelegateListeners)
		[peripheralDelegate discoveredNewPeripheral:peripheral];
}

-(void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
	for(id<PeripheralDataChange> peripheralDelegate in self.arrDelegateListeners)
		[peripheralDelegate connectedToPeripheral:TRUE thePeripheral:peripheral];
}

-(void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
	for(id<PeripheralDataChange> peripheralDelegate in self.arrDelegateListeners)
		[peripheralDelegate connectedToPeripheral:FALSE thePeripheral:peripheral];	
}

-(void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
	for(id<PeripheralDataChange> peripheralDelegate in self.arrDelegateListeners)
		[peripheralDelegate disconnecteCalled];
}

/*!
 *  @method discoverServices:
 *
 *  @param serviceUUIDs A list of <code>CBUUID</code> objects representing the service types to be discovered. If <i>nil</i>,
 *						all services will be discovered, which is considerably slower and not recommended.
 *
 *  @discussion			Discovers available service(s) on the peripheral.
 *
 *  @see				peripheral:didDiscoverServices:
 */
//- (void)discoverServices:(NSArray *)serviceUUIDs;

/*!
 *  @method discoverCharacteristics:forService:
 *
 *  @param characteristicUUIDs	A list of <code>CBUUID</code> objects representing the characteristic types to be discovered. If <i>nil</i>,
 *								all characteristics of <i>service</i> will be discovered, which is considerably slower and not recommended.
 *  @param service				A GATT service.
 *
 *  @discussion					Discovers the specified characteristic(s) of <i>service</i>.
 *
 *  @see						peripheral:didDiscoverCharacteristicsForService:error:
 */
//- (void)discoverCharacteristics:(NSArray *)characteristicUUIDs forService:(CBService *)service;

/*!
 *  @method readValueForCharacteristic:
 *
 *  @param characteristic	A GATT characteristic.
 *
 *  @discussion				Reads the characteristic value for <i>characteristic</i>.
 *
 *  @see					peripheral:didUpdateValueForCharacteristic:error:
 */
//- (void)readValueForCharacteristic:(CBCharacteristic *)characteristic;

/*!
 *  @method discoverDescriptorsForCharacteristic:
 *
 *  @param characteristic	A GATT characteristic.
 *
 *  @discussion				Discovers the characteristic descriptor(s) of <i>characteristic</i>.
 *
 *  @see					peripheral:didDiscoverDescriptorsForCharacteristic:error:
 */
//- (void)discoverDescriptorsForCharacteristic:(CBCharacteristic *)characteristic;

/*!
 *  @method readValueForDescriptor:
 *
 *  @param descriptor	A GATT characteristic descriptor.
 *
 *  @discussion			Reads the value of <i>descriptor</i>.
 *
 *  @see				peripheral:didUpdateValueForDescriptor:error:
 */
//- (void)readValueForDescriptor:(CBDescriptor *)descriptor;

#pragma mark - Remote Data Collection Methods

-(void)startDataCollection
{
	if (self.remoteNotifierDelegate != nil && [self.remoteNotifierDelegate respondsToSelector:@selector(didReceiveStartDataCollectionCommand)])
	{
		[self.remoteNotifierDelegate didReceiveStartDataCollectionCommand];
	}
}

-(void)stopDataCollection
{
	if (self.remoteNotifierDelegate != nil && [self.remoteNotifierDelegate respondsToSelector:@selector(didReceiveStopDataCollectionCommand)])
	{
		[self.remoteNotifierDelegate didReceiveStopDataCollectionCommand];
	}
}

-(void)didDiscoverDataCollectorIdentifierCharacteristic:(CBCharacteristic *)characteristic ForPeripheral:(CBPeripheral *)peripheral
{
	if (self.remoteNotifierDelegate != nil && [self.remoteNotifierDelegate respondsToSelector:@selector(deviceIdenfitier)])
	{
		NSString * deviceIdentifier = [self.remoteNotifierDelegate deviceIdenfitier];
		NSData * data = [deviceIdentifier dataUsingEncoding:NSUTF8StringEncoding];
		[peripheral writeValue:data forCharacteristic:characteristic type:CBCharacteristicWriteWithoutResponse];
	}
}

-(void)didDiscoverDataCollectionStatusCharacteristic:(CBCharacteristic *)characteristic ForPeripheral:(CBPeripheral *) peripheral
{

	if (self.subscribedPeripheralsToCharacteristicMapForDataCollectionStatus == nil)
	{
		self.subscribedPeripheralsToCharacteristicMapForDataCollectionStatus = [NSMutableDictionary dictionary];
	}

	if (self.remoteNotifierDelegate != nil && [self.remoteNotifierDelegate respondsToSelector:@selector(startDataCollectionStatusUpdates:)])
	{
		[self.subscribedPeripheralsToCharacteristicMapForDataCollectionStatus setObject:characteristic forKey:peripheral];
		[self.remoteNotifierDelegate startDataCollectionStatusUpdates:self];
	}
}

-(void)dataCollectionStatusUpdated:(BOOL)isCollecting
{

	NSString * stringValue = isCollecting ? @"Y" : @"N";
	NSData * data = [stringValue dataUsingEncoding:NSUTF8StringEncoding];

	for (CBPeripheral * peripheral in self.subscribedPeripheralsToCharacteristicMapForDataCollectionStatus.allKeys)
	{
		CBCharacteristic * characteristic = [self.subscribedPeripheralsToCharacteristicMapForDataCollectionStatus objectForKey:peripheral];
		[peripheral writeValue:data forCharacteristic:characteristic type:CBCharacteristicWriteWithoutResponse];
	}
}


@end

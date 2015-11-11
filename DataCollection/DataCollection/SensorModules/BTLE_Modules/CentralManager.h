/*
//  CentralManager.h
//  BTCentralPract
//
//  Created by Jeff Behrbaum on 12/8/14.
//  Copyright (c) 2014 Apio Systems. All rights reserved.
*/

#import <CoreBluetooth/CoreBluetooth.h>
#import <Foundation/Foundation.h>

@protocol PeripheralDataChange <NSObject>
@required
	-(void)calledToConnect;
	-(void)disconnecteCalled;
	-(void)discoveredNewPeripheral:(CBPeripheral *)peripheral;
	-(void)connectedToPeripheral:(BOOL)bConnected thePeripheral:(CBPeripheral *)peripheral;
@end

@protocol DataCollectionStatusDelegate <NSObject>

@required
	-(void) dataCollectionStatusUpdated:(BOOL)isCollecting;

@end

@protocol RemoteNotifierDelegate <NSObject>

@optional
-(void)didReceiveStartDataCollectionCommand;
-(void)didReceiveStopDataCollectionCommand;

-(NSString*) deviceIdenfitier;
-(void) startDataCollectionStatusUpdates:(id<DataCollectionStatusDelegate>)delegate;
@end

@interface CentralManager : NSObject<CBCentralManagerDelegate, DataCollectionStatusDelegate>
	@property(nonatomic, readonly) NSInteger numberOfPeripherals;

	-(void)addDelegateListener:(id<PeripheralDataChange>) periphChangeStateDelegate;

	+(CentralManager *)theCentral;

	-(void)stopScanning;
	-(void)startScanning;
	-(void)disconnectAllBTPeripherals;
	-(CBPeripheral *)peripheralAtIndex:(NSInteger)iIndex;
	-(void)connectToPeripheral:(CBPeripheral *)peripheral;
	-(void)cancelPeripheralConnection:(CBPeripheral *)peripheral;


	@property(nonatomic, strong) id<RemoteNotifierDelegate> remoteNotifierDelegate;

	-(void)startDataCollection;
	-(void)stopDataCollection;
	-(void)didDiscoverDataCollectorIdentifierCharacteristic:(CBCharacteristic *)characteristic ForPeripheral:(CBPeripheral *)peripheral;
	-(void)didDiscoverDataCollectionStatusCharacteristic:(CBCharacteristic *)characteristic ForPeripheral:(CBPeripheral *) peripheral;

@end

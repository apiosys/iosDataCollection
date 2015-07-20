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

@interface CentralManager : NSObject<CBCentralManagerDelegate>
	@property(nonatomic, readonly) NSInteger numberOfPeripherals;

	-(void)addDelegateListener:(id<PeripheralDataChange>) periphChangeStateDelegate;

	+(CentralManager *)theCentral;

	-(void)stopScanning;
	-(void)startScanning;
	-(void)disconnectAllBTPeripherals;
	-(CBPeripheral *)peripheralAtIndex:(NSInteger)iIndex;
	-(void)connectToPeripheral:(CBPeripheral *)peripheral;
	-(void)cancelPeripheralConnection:(CBPeripheral *)peripheral;

@end

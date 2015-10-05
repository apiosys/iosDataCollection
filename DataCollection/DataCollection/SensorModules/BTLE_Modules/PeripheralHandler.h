/*
//  PeripheralHandler.h
//  BTCentralPract
//
//  Created by Jeff Behrbaum on 12/9/14.
//  Copyright (c) 2014 Apio Systems. All rights reserved.
*/

#import <CoreBluetooth/CoreBluetooth.h>
#import <Foundation/Foundation.h>

#import "CentralManager.h"

@interface PeripheralHandler : NSObject<CBPeripheralDelegate, PeripheralDataChange>
	@property(nonatomic, readonly) NSInteger numberOfDiscoveredPeripherals;

	-(void)clearPreviousPeripherals;
	-(void)peripheralIsNowConnected:(CBPeripheral *)peripheral;
	-(void)startDiscoveringServices:(CBPeripheral *)peripheral;

	-(void)disconnectAllPeripherals;
	-(CBPeripheral *)peripheralAt:(NSInteger)index;
	-(BOOL)addPeripheral:(CBPeripheral *)discoveredPeripheral;

@end

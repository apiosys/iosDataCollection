/*
//  CBtleCentralManager.h
//  SALTester
//
//  Created by Jeff Behrbaum on 12/15/14.
//  Copyright (c) 2014 Apio Systems. All rights reserved.
*/

#import <CoreBluetooth/CoreBluetooth.h>

#import <Foundation/Foundation.h>

@interface CBtleCentralManager : NSObject<CBCentralManagerDelegate>

-(BOOL)startScanning;

@end

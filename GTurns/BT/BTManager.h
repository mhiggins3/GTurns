//
//  BTManager.h
//  GTurns
//
//  Created by Matt Higgins on 5/8/13.
//  Copyright (c) 2013 Matt Higgins. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "GTurnsConst.h"
#import "Sensors.h"
#import "AccelerometerSensor.h"

@protocol BTManagerDelegate;


@interface BTManager : NSObject <CBCentralManagerDelegate, CBPeripheralDelegate>

@property (strong, retain) NSMutableOrderedSet      *managedPeripherals;
@property (strong, retain) CBPeripheral             *activePeripheral;
@property (strong, retain) NSMutableOrderedSet      *discoveredPeripherals;
@property (strong, retain) id<BTManagerDelegate>    delegate;
@property (strong, retain) AccelerometerSensor      *accelerometer;

+ (id) sharedInstance;

/*!
 *
 * @method addManagedPeripheral
 *
 * @param peripheral    We are attempting to manage
 *
 * @discussion  This method will look to internal objects and decide if we can manage
 the discoverd peripheral. If we can manage it we will add the device
 to the list else it will be discarded.
 *
 */
-(void)addManagedPeripheral:(CBPeripheral *)peripheral;

/*!
 *
 * @method canManagePeripheral
 *
 * @param peripheral    We are attempting to manage
 *
 * @return BOOL
 *
 * @discussion  This method will look to internal objects and decide if we can manage
 the discoverd peripheral. If we can manage it we will add the device
 to the list else it will be discarded.
 *
 */
-(BOOL)canManagePeripheral:(CBPeripheral *)peripheral;

/*!
 *
 * @method startScan
 *
 * @return void
 *
 * @discussion  This method will tell the centralManager to start scanning for
 peripheral objects that match our service uuids 
 *
 */
-(void)startScan;

@end

@protocol BTManagerDelegate<NSObject>

@optional
    -(void)didDiscoverPerhipheral:(CBPeripheral *)peripheral;
    -(void)didActivatePerhipheral:(CBPeripheral *)peripheral;
    -(void)didUpdateAccelerometerValues:(AccelerometerSensor *)accelerometer;
@end
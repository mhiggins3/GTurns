//
//  GTurnsConst.m
//  GTurns
//
//  Created by Matt Higgins on 5/15/13.
//  Copyright (c) 2013 Matt Higgins. All rights reserved.
//

#import "GTurnsConst.h"

// Sensor Tag Const
NSString *const GATT_SERVICE_UUID_STRING =                      @"F0000000-0451-4000-B000-000000001800";

// Accelerometer Const                                        
NSString *const ACCELEROMETER_SERVICE_UUID_STRING =             @"F000AA10-0451-4000-B000-000000000000";
NSString *const ACCELEROMETER_CHARACTERISTIC_CONFIG_STRING =    @"F000AA12-0451-4000-B000-000000000000";
NSString *const ACCELEROMETER_CHARACTERISTIC_PERIOD_STRING =    @"F000AA13-0451-4000-B000-000000000000";
NSString *const ACCELEROMETER_CHARACTERISTIC_DATA_STRING =      @"F000AA11-0451-4000-B000-000000000000";

// User Defaults Keys
NSString *const MANAGED_PERIPHERALS_KEY =                       @"managed_peripherals";
@implementation GTurnsConst

@end

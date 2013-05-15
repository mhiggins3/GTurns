//
//  Main Program.m
// 
//
//  Created by BLE Sensor Tag.
//  
//

#include "Main Program.h"

/*

-(void) configureSensorTag {
    // Configure sensortag, turning on Sensors and setting update period for sensors etc ...
    

    //Configure Accelerometer



    NSLog(@"Configured TI SensorTag Accelerometer Service profile");

    CBUUID *sUUID = [CBUUID UUIDWithString:@"F000AA10-0451-4000-B000-000000000000"];

    CBUUID *cUUID = [CBUUID UUIDWithString:@"F000AA12-0451-4000-B000-000000000000"];

    CBUUID *pUUID = [CBUUID UUIDWithString:@"F000AA13-0451-4000-B000-000000000000"];

    NSInteger period = 300;

    uint8_t periodData = (uint8_t)(period / 10);

    [BLEUtility writeCharacteristic:self.d.p sCBUUID:sUUID cCBUUID:pUUID data:[NSData dataWithBytes:&periodData length:1]];

    uint8_t data = 0x01;

    [BLEUtility writeCharacteristic:self.d.p sCBUUID:sUUID cCBUUID:cUUID data:[NSData dataWithBytes:&data length:1]];]

    cUUID = [CBUUID UUIDWithString:@"F000AA11-0451-4000-B000-000000000000"];

    [BLEUtility setNotificationForCharacteristic:self.d.p sCBUUID:sUUID cCBUUID:cUUID enable:YES];



    //Configure Magnetometer



    NSLog(@"Configured TI SensorTag Magnetometer Service profile");

    CBUUID *sUUID = [CBUUID UUIDWithString:@"F000AA30-0451-4000-B000-000000000000"];

    CBUUID *cUUID = [CBUUID UUIDWithString:@"F000AA32-0451-4000-B000-000000000000"];

    CBUUID *pUUID = [CBUUID UUIDWithString:@"F000AA33-0451-4000-B000-000000000000"];

    NSInteger period = 300;

    uint8_t periodData = (uint8_t)(period / 10);

    [BLEUtility writeCharacteristic:self.d.p sCBUUID:sUUID cCBUUID:pUUID data:[NSData dataWithBytes:&periodData length:1]];

    uint8_t data = 0x01;

    [BLEUtility writeCharacteristic:self.d.p sCBUUID:sUUID cCBUUID:cUUID data:[NSData dataWithBytes:&data length:1]];]

    cUUID = [CBUUID UUIDWithString:@"F000AA31-0451-4000-B000-000000000000"];

    [BLEUtility setNotificationForCharacteristic:self.d.p sCBUUID:sUUID cCBUUID:cUUID enable:YES];



    //Configure Gyroscope



    NSLog(@"Configured TI SensorTag Gyroscope Service profile");

    CBUUID *sUUID = [CBUUID UUIDWithString:@"F000AA50-0451-4000-B000-000000000000"];

    CBUUID *cUUID = [CBUUID UUIDWithString:@"F000AA52-0451-4000-B000-000000000000"];

    uint8_t data = 0x07;

    [BLEUtility writeCharacteristic:self.d.p sCBUUID:sUUID cCBUUID:cUUID data:[NSData dataWithBytes:&data length:1]];]

    cUUID = [CBUUID UUIDWithString:@"F000AA51-0451-4000-B000-000000000000"];

    [BLEUtility setNotificationForCharacteristic:self.d.p sCBUUID:sUUID cCBUUID:cUUID enable:YES];



    //Configure IR Termometer



    NSLog(@"Configured TI SensorTag IR Termometer Service profile");

    CBUUID *sUUID = [CBUUID UUIDWithString:@"F000AA00-0451-4000-B000-000000000000"];

    CBUUID *cUUID = [CBUUID UUIDWithString:@"F000AA02-0451-4000-B000-000000000000"];

    uint8_t data = 0x01;

    [BLEUtility writeCharacteristic:self.d.p sCBUUID:sUUID cCBUUID:cUUID data:[NSData dataWithBytes:&data length:1]];]

    cUUID = [CBUUID UUIDWithString:@"F000AA01-0451-4000-B000-000000000000"];

    [BLEUtility setNotificationForCharacteristic:self.d.p sCBUUID:sUUID cCBUUID:cUUID enable:YES];



    //Configure IR Termometer



    NSLog(@"Configured TI SensorTag IR Termometer Service profile");

    CBUUID *sUUID = [CBUUID UUIDWithString:@"F000AA00-0451-4000-B000-000000000000"];

    CBUUID *cUUID = [CBUUID UUIDWithString:@"F000AA02-0451-4000-B000-000000000000"];

    uint8_t data = 0x01;

    [BLEUtility writeCharacteristic:self.d.p sCBUUID:sUUID cCBUUID:cUUID data:[NSData dataWithBytes:&data length:1]];]

    cUUID = [CBUUID UUIDWithString:@"F000AA01-0451-4000-B000-000000000000"];

    [BLEUtility setNotificationForCharacteristic:self.d.p sCBUUID:sUUID cCBUUID:cUUID enable:YES];



    //Configure Barometer



    NSLog(@"Configured TI SensorTag Barometer Service profile");

    CBUUID *sUUID = [CBUUID UUIDWithString:@"F000AA40-0451-4000-B000-000000000000"];

    CBUUID *cUUID = [CBUUID UUIDWithString:@"F000AA42-0451-4000-B000-000000000000"];

    uint8_t data = 0x02;

    [BLEUtility writeCharacteristic:self.d.p sCBUUID:sUUID cCBUUID:cUUID data:[NSData dataWithBytes:&data length:1]];]

    cUUID = [CBUUID UUIDWithString:@"F000AA41-0451-4000-B000-000000000000"];

    [BLEUtility setNotificationForCharacteristic:self.d.p sCBUUID:sUUID cCBUUID:cUUID enable:YES];



    cUUID = [CBUUID UUIDWithString:@"F000AA43-0451-4000-B000-000000000000"];

    [BLEUtility readCharacteristic:self.d.p sCBUUID:sUUID cCBUUID:cUUID];    //Configure Humidity



    NSLog(@"Configured TI SensorTag Humidity Service profile");

    CBUUID *sUUID = [CBUUID UUIDWithString:@"F000AA20-0451-4000-B000-000000000000"];

    CBUUID *cUUID = [CBUUID UUIDWithString:@"F000AA22-0451-4000-B000-000000000000"];

    uint8_t data = 0x02;

    [BLEUtility writeCharacteristic:self.d.p sCBUUID:sUUID cCBUUID:cUUID data:[NSData dataWithBytes:&data length:1]];]

    cUUID = [CBUUID UUIDWithString:@"F000AA21-0451-4000-B000-000000000000"];

    [BLEUtility setNotificationForCharacteristic:self.d.p sCBUUID:sUUID cCBUUID:cUUID enable:YES];



    
}

-(void) deconfigureSensorTag {

    //Deconfigure Accelerometer

    NSLog(@"Deconfigured TI SensorTag Accelerometer Service profile");

    CBUUID *sUUID = [CBUUID UUIDWithString:@"F000AA10-0451-4000-B000-000000000000"];

    CBUUID *cUUID = [CBUUID UUIDWithString:@"F000AA12-0451-4000-B000-000000000000"];

    uint8_t data = 0x00;

    [BLEUtility writeCharacteristic:self.d.p sCBUUID:sUUID cCBUUID:cUUID data:[NSData dataWithBytes:&data length:1]];]

    cUUID = [CBUUID UUIDWithString:@"F000AA11-0451-4000-B000-000000000000"];

    [BLEUtility setNotificationForCharacteristic:self.d.p sCBUUID:sUUID cCBUUID:cUUID enable:NO];



    //Deconfigure Magnetometer

    NSLog(@"Deconfigured TI SensorTag Magnetometer Service profile");

    CBUUID *sUUID = [CBUUID UUIDWithString:@"F000AA30-0451-4000-B000-000000000000"];

    CBUUID *cUUID = [CBUUID UUIDWithString:@"F000AA32-0451-4000-B000-000000000000"];

    uint8_t data = 0x00;

    [BLEUtility writeCharacteristic:self.d.p sCBUUID:sUUID cCBUUID:cUUID data:[NSData dataWithBytes:&data length:1]];]

    cUUID = [CBUUID UUIDWithString:@"F000AA31-0451-4000-B000-000000000000"];

    [BLEUtility setNotificationForCharacteristic:self.d.p sCBUUID:sUUID cCBUUID:cUUID enable:NO];



    //Deconfigure Gyroscope

    NSLog(@"Deconfigured TI SensorTag Gyroscope Service profile");

    CBUUID *sUUID = [CBUUID UUIDWithString:@"F000AA50-0451-4000-B000-000000000000"];

    CBUUID *cUUID = [CBUUID UUIDWithString:@"F000AA52-0451-4000-B000-000000000000"];

    uint8_t data = 0x00;

    [BLEUtility writeCharacteristic:self.d.p sCBUUID:sUUID cCBUUID:cUUID data:[NSData dataWithBytes:&data length:1]];]

    cUUID = [CBUUID UUIDWithString:@"F000AA51-0451-4000-B000-000000000000"];

    [BLEUtility setNotificationForCharacteristic:self.d.p sCBUUID:sUUID cCBUUID:cUUID enable:NO];



    //Deconfigure IR Termometer

    NSLog(@"Deconfigured TI SensorTag IR Termometer Service profile");

    CBUUID *sUUID = [CBUUID UUIDWithString:@"F000AA00-0451-4000-B000-000000000000"];

    CBUUID *cUUID = [CBUUID UUIDWithString:@"F000AA02-0451-4000-B000-000000000000"];

    uint8_t data = 0x00;

    [BLEUtility writeCharacteristic:self.d.p sCBUUID:sUUID cCBUUID:cUUID data:[NSData dataWithBytes:&data length:1]];]

    cUUID = [CBUUID UUIDWithString:@"F000AA01-0451-4000-B000-000000000000"];

    [BLEUtility setNotificationForCharacteristic:self.d.p sCBUUID:sUUID cCBUUID:cUUID enable:NO];



    //Deconfigure IR Termometer

    NSLog(@"Deconfigured TI SensorTag IR Termometer Service profile");

    CBUUID *sUUID = [CBUUID UUIDWithString:@"F000AA00-0451-4000-B000-000000000000"];

    CBUUID *cUUID = [CBUUID UUIDWithString:@"F000AA02-0451-4000-B000-000000000000"];

    uint8_t data = 0x00;

    [BLEUtility writeCharacteristic:self.d.p sCBUUID:sUUID cCBUUID:cUUID data:[NSData dataWithBytes:&data length:1]];]

    cUUID = [CBUUID UUIDWithString:@"F000AA01-0451-4000-B000-000000000000"];

    [BLEUtility setNotificationForCharacteristic:self.d.p sCBUUID:sUUID cCBUUID:cUUID enable:NO];



    //Deconfigure Barometer

    NSLog(@"Deconfigured TI SensorTag Barometer Service profile");

    CBUUID *sUUID = [CBUUID UUIDWithString:@"F000AA40-0451-4000-B000-000000000000"];

    CBUUID *cUUID = [CBUUID UUIDWithString:@"F000AA42-0451-4000-B000-000000000000"];

    uint8_t data = 0x00;

    [BLEUtility writeCharacteristic:self.d.p sCBUUID:sUUID cCBUUID:cUUID data:[NSData dataWithBytes:&data length:1]];]

    cUUID = [CBUUID UUIDWithString:@"F000AA41-0451-4000-B000-000000000000"];

    [BLEUtility setNotificationForCharacteristic:self.d.p sCBUUID:sUUID cCBUUID:cUUID enable:NO];



    //Deconfigure Humidity

    NSLog(@"Deconfigured TI SensorTag Humidity Service profile");

    CBUUID *sUUID = [CBUUID UUIDWithString:@"F000AA20-0451-4000-B000-000000000000"];

    CBUUID *cUUID = [CBUUID UUIDWithString:@"F000AA22-0451-4000-B000-000000000000"];

    uint8_t data = 0x00;

    [BLEUtility writeCharacteristic:self.d.p sCBUUID:sUUID cCBUUID:cUUID data:[NSData dataWithBytes:&data length:1]];]

    cUUID = [CBUUID UUIDWithString:@"F000AA21-0451-4000-B000-000000000000"];

    [BLEUtility setNotificationForCharacteristic:self.d.p sCBUUID:sUUID cCBUUID:cUUID enable:NO];



}

-(void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {

    //Read Accelerometer

    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"F000AA11-0451-4000-B000-000000000000"]]) {

        float x = [sensorKXTJ9 calcXValue:characteristic.value];

        float y = [sensorKXTJ9 calcYValue:characteristic.value];

        float z = [sensorKXTJ9 calcZValue:characteristic.value];

    }



    //Read Magnetometer

    //A Mag sensor must be added to the class to keep calibration values : @property (strong,nonatomic) sensorMAG3110 *magSensor;

    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"F000AA31-0451-4000-B000-000000000000"]]) {

        float x = [self.magSensor calcXValue:characteristic.value];

        float y = [self.magSensor calcYValue:characteristic.value];

        float z = [self.magSensor calcZValue:characteristic.value];

    }



    //Read Gyroscope

    //A gyro sensor must be added to the class to keep calibration values : @property (strong,nonatomic) sensorIMU3000 *gyroSensor;

    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"F000AA51-0451-4000-B000-000000000000"]]) {

        float x = [self.gyroSensor calcXValue:characteristic.value];

        float y = [self.gyroSensor calcXValue:characteristic.value];

        float z = [self.gyroSensor calcXValue:characteristic.value];

    }



    //Read IR Termometer

    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"F000AA01-0451-4000-B000-000000000000"]]) {

        float tObj = [sensorTMP006 calcTObj:characteristic.value];

    }



    //Read IR Termometer

    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"F000AA01-0451-4000-B000-000000000000"]]) {

        float tAmb = [sensorTMP006 calcTAmb:characteristic.value];

    }



    //Read Barometer calibration

    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"(null)"]]) {

    self.baroSensor = [[sensorC953A alloc] initWithCalibrationData:characteristic.value];

    CBUUID *sUUID = [CBUUID UUIDWithString:@"F000AA40-0451-4000-B000-000000000000"];

    CBUUID *cUUID = [CBUUID UUIDWithString:@"F000AA42-0451-4000-B000-000000000000"];

    uint8_t data = 0x00;

    [BLEUtility writeCharacteristic:self.d.p sCBUUID:sUUID cCBUUID:cUUID data:[NSData dataWithBytes:&data length:1]];]

    }



    //Read Barometer

    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"F000AA41-0451-4000-B000-000000000000"]]) {

        int pressure = [self.baroSensor calcPressure:characteristic.value];

    }



    //Read Humidity

    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"F000AA21-0451-4000-B000-000000000000"]]) {

        float rHVal = [sensorSHT21 calcPress:characteristic.value];

    }



}
 */






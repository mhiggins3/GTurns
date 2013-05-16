//
//  BTManager.m
//  GTurns
//
//  Created by Matt Higgins on 5/8/13.
//  Copyright (c) 2013 Matt Higgins. All rights reserved.
//

#import "BTManager.h"


@interface BTManager () <CBCentralManagerDelegate,CBPeripheralDelegate>
    
@property (strong, retain) CBCentralManager    *centralManager;
@property (strong, retain) NSUserDefaults *userDefaults;
@property (strong, retain) CBPeripheral *currentPeripheral;

@property (nonatomic, assign, getter=isPendingInit) BOOL pendingInit;

@end

@implementation BTManager

-(void)addManagedPeripheral:(CBPeripheral *)peripheral
{
    
    if(![self.managedPeripherals containsObject:peripheral]){
        NSLog(@"Adding a peripheral to manage");
        [self.managedPeripherals addObject:peripheral];
        [self.centralManager connectPeripheral:peripheral options:nil];
    }
    [self.discoveredPeripherals removeObject:peripheral];

    
}

-(void)addDiscoveredPeripheral:(CBPeripheral *) peripheral
{
    if(![self.managedPeripherals containsObject:peripheral] && ![self.discoveredPeripherals containsObject:peripheral]){
        [self.discoveredPeripherals addObject:peripheral];
        [self.delegate didDiscoverPerhipheral:peripheral];
    }
}
-(BOOL)canManagePeripheral:(CBPeripheral *)peripheral{
    return NO;
}

-(void)startScan{
    
    
    //We need to do scan for peripheral with nil services list because the sensor tag does not advertise
    //its services. This will force the tag to send us back everything its knows.
    [self.centralManager scanForPeripheralsWithServices:nil options:@{ CBCentralManagerScanOptionAllowDuplicatesKey : @YES}];

}

#pragma mark - CBCentralManagerDelegate

/*!
 *  @method centralManagerDidUpdateState:
 *
 *  @param central  The central manager whose state has changed.
 *
 *  @discussion     Invoked whenever the central manager's state has been updated. Commands should only be issued when the state is
 *                  <code>CBCentralManagerStatePoweredOn</code>. A state below <code>CBCentralManagerStatePoweredOn</code>
 *                  implies that scanning has stopped and any connected peripherals have been disconnected. If the state moves below
 *                  <code>CBCentralManagerStatePoweredOff</code>, all <code>CBPeripheral</code> objects obtained from this central
 *                  manager become invalid and must be retrieved or discovered again.
 *
 *  @see            state
 *
 */
- (void)centralManagerDidUpdateState:(CBCentralManager *)central
{

    switch(central.state){
        case CBCentralManagerStateUnknown:
            NSLog(@"CBCentralManagerStateUnknow: Ouch this is not good! ");
            break;
        case CBCentralManagerStateResetting:
            NSLog(@"CBCentralManagerStateResetting: Resetting please wait. ");
            break;
        case CBCentralManagerStateUnsupported:
            NSLog(@"CBCentralManagerStateUnsupported: Not sure what to do here ?");
            break;
        case CBCentralManagerStateUnauthorized:
            NSLog(@"CBCentralManagerStateUnauthorized: Unauthorized ? Do you konw who I am ? ");
            break;
        case CBCentralManagerStatePoweredOff:
            NSLog(@"CBCentralManagerStatePoweredOff: Device off killing activePeripheral list. ");
            self.activePeripheral = nil;
            break;
        case CBCentralManagerStatePoweredOn:
            NSLog(@"CBCentralManagerStatePoweredOn: Powered on going to discover some nice peripherals now. ");
            [self startScan];
            break;
    }
}

/*!
 *  @method centralManager:didRetrievePeripherals:
 *
 *  @param central      The central manager providing this information.
 *  @param peripherals  A list of <code>CBPeripheral</code> objects.
 *
 *  @discussion         This method returns the result of a @link retrievePeripherals @/link call, with the peripheral(s) that the central manager was
 *                      able to match to the provided UUID(s).
 *
 */
- (void)centralManager:(CBCentralManager *)central didRetrievePeripherals:(NSArray *)peripherals
{
    NSLog(@"didRetrievePeripherals: UNIMPLIMENTED");
}

/*!
 *  @method centralManager:didRetrieveConnectedPeripherals:
 *
 *  @param central      The central manager providing this information.
 *  @param peripherals  A list of <code>CBPeripheral</code> objects representing all peripherals currently connected to the system.
 *
 *  @discussion         This method returns the result of a @link retrieveConnectedPeripherals @/link call.
 *
 */
- (void)centralManager:(CBCentralManager *)central didRetrieveConnectedPeripherals:(NSArray *)peripherals
{
    NSLog(@"didRetrieveConnectedPeripherals: UNIMPLIMENTED");    
}

/*!
 *  @method centralManager:didDiscoverPeripheral:advertisementData:RSSI:
 *
 *  @param central              The central manager providing this update.
 *  @param peripheral           A <code>CBPeripheral</code> object.
 *  @param advertisementData    A dictionary containing any advertisement and scan response data.
 *  @param RSSI                 The current RSSI of <i>peripheral</i>, in decibels.
 *
 *  @discussion                 This method is invoked while scanning, upon the discovery of <i>peripheral</i> by <i>central</i>. Any advertisement/scan response
 *                              data stored in <i>advertisementData</i> can be accessed via the <code>CBAdvertisementData</code> keys. A discovered peripheral must
 *                              be retained in order to use it; otherwise, it is assumed to not be of interest and will be cleaned up by the central manager.
 *
 *  @seealso                    CBAdvertisementData.h
 *
 */
- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI
{
    NSLog(@"Did discover peripheral ");
    peripheral.delegate = self;

    //This is a little strange but we have to save off the peripheral
    //before we connect or it will get dealloced before we connect.
    self.currentPeripheral = peripheral;

    //We have to connect at this point because the services list for this peripheral
    //is empty before we connect. 
    [central connectPeripheral:peripheral options:nil];

   
}

/*!
 *  @method centralManager:didConnectPeripheral:
 *
 *  @param central      The central manager providing this information.
 *  @param peripheral   The <code>CBPeripheral</code> that has connected.
 *
 *  @discussion         This method is invoked when a connection initiated by @link connectPeripheral:options: @/link has succeeded.
 *
 */
- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
        //Now we are connected we just discover all services
        //we should prob provide a list of uuids we are interested in
        //TODO: add a list of uuids we are interested in.
        [peripheral discoverServices:nil];
    
}

/*!
 *  @method centralManager:didFailToConnectPeripheral:error:
 *
 *  @param central      The central manager providing this information.
 *  @param peripheral   The <code>CBPeripheral</code> that has failed to connect.
 *  @param error        The cause of the failure.
 *
 *  @discussion         This method is invoked when a connection initiated by @link connectPeripheral:options: @/link has failed to complete. As connection attempts do not
 *                      timeout, the failure of a connection is atypical and usually indicative of a transient issue.
 *
 */
- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    NSLog(@"didFailToConnectPeripheral: UNIMPLIMENTED");
   
}

/*!
 *  @method centralManager:didDisconnectPeripheral:error:
 *
 *  @param central      The central manager providing this information.
 *  @param peripheral   The <code>CBPeripheral</code> that has disconnected.
 *  @param error        If an error occurred, the cause of the failure.
 *
 *  @discussion         This method is invoked upon the disconnection of a peripheral that was connected by @link connectPeripheral:options: @/link. If the disconnection
 *                      was not initiated by @link cancelPeripheralConnection @/link, the cause will be detailed in the <i>error</i> parameter. Once this method has been
 *                      called, no more methods will be invoked on <i>peripheral</i>'s <code>CBPeripheralDelegate</code>.
 *
 */
- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    self.activePeripheral = nil;
    NSLog(@"didDisconnectPeripheral: UNIMPLIMENTED");
    
}

#pragma mark - CBPeripheralDelegate
/*!
 *  @method peripheralDidUpdateName:
 *
 *  @param peripheral	The peripheral providing this update.
 *
 *  @discussion			This method is invoked when the @link name @/link of <i>peripheral</i> changes.
 */
- (void)peripheralDidUpdateName:(CBPeripheral *)peripheral NS_AVAILABLE(NA, 6_0)
{
    NSLog(@"peripheralDidUpdateName: UNIMPLIMENTED: %@", peripheral.name);
}

/*!
 *  @method peripheralDidInvalidateServices:
 *
 *  @param peripheral	The peripheral providing this update.
 *
 *  @discussion			This method is invoked when the @link services @/link of <i>peripheral</i> have been changed. At this point,
 *						all existing <code>CBService</code> objects are invalidated. Services can be re-discovered via @link discoverServices: @/link.
 */
- (void)peripheralDidInvalidateServices:(CBPeripheral *)peripheral NS_AVAILABLE(NA, 6_0)
{
    NSLog(@"peripheralDidInvalidateServices: UNIMPLIMENTED");
}

/*!
 *  @method peripheralDidUpdateRSSI:error:
 *
 *  @param peripheral	The peripheral providing this update.
 *	@param error		If an error occurred, the cause of the failure.
 *
 *  @discussion			This method returns the result of a @link readRSSI: @/link call.
 */
- (void)peripheralDidUpdateRSSI:(CBPeripheral *)peripheral error:(NSError *)error
{
    NSLog(@"peripheralDidUpdateRSSI: UNIMPLIMENTED");
}

/*!
 *  @method peripheral:didDiscoverServices:
 *
 *  @param peripheral	The peripheral providing this information.
 *	@param error		If an error occurred, the cause of the failure.
 *
 *  @discussion			This method returns the result of a @link discoverServices: @/link call. If the service(s) were read successfully, they can be retrieved via
 *						<i>peripheral</i>'s @link services @/link property.
 *
 */
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error
{
    //This is a peripheral we are already familiar with so just set it as active and setup retreival stuff
    //TODO: setup retreival stuff.
    if(peripheral == self.activePeripheral || [self.managedPeripherals containsObject:peripheral]){
        NSLog(@"Back again so let's get notified");
        self.activePeripheral = peripheral;
        for(CBService *service in self.activePeripheral.services){
            if ([service.UUID isEqual: [CBUUID UUIDWithString:ACCELEROMETER_SERVICE_UUID_STRING]]) {
                for (CBCharacteristic *characteristic in service.characteristics ) {
                        [peripheral setNotifyValue:YES forCharacteristic:characteristic];
                }

            }
        }
        [self.delegate didActivatePerhipheral:peripheral];
    } else {
        
        for(CBService *service in peripheral.services){
            if ([service.UUID isEqual: [CBUUID UUIDWithString:ACCELEROMETER_SERVICE_UUID_STRING]]) {
                [self.centralManager stopScan];
                [self addDiscoveredPeripheral:peripheral];
            } else {
                [self.centralManager cancelPeripheralConnection:peripheral];
            }
        }
    }
}

/*!
 *  @method peripheral:didDiscoverIncludedServicesForService:error:
 *
 *  @param peripheral	The peripheral providing this information.
 *  @param service		The <code>CBService</code> object containing the included services.
 *	@param error		If an error occurred, the cause of the failure.
 *
 *  @discussion			This method returns the result of a @link discoverIncludedServices:forService: @/link call. If the included service(s) were read successfully,
 *						they can be retrieved via <i>service</i>'s <code>includedServices</code> property.
 */
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverIncludedServicesForService:(CBService *)service error:(NSError *)error
{
    NSLog(@"didDiscoverIncludedServicesForService: UNIMPLIMENTED");  
}

/*!
 *  @method peripheral:didDiscoverCharacteristicsForService:error:
 *
 *  @param peripheral	The peripheral providing this information.
 *  @param service		The <code>CBService</code> object containing the characteristic(s).
 *	@param error		If an error occurred, the cause of the failure.
 *
 *  @discussion			This method returns the result of a @link discoverCharacteristics:forService: @/link call. If the characteristic(s) were read successfully,
 *						they can be retrieved via <i>service</i>'s <code>characteristics</code> property.
 */
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error
{
    NSLog(@"didDiscoverCharacteristicsForService: UNIMPLIMENTED"); 
}

/*!
 *  @method peripheral:didUpdateValueForCharacteristic:error:
 *
 *  @param peripheral		The peripheral providing this information.
 *  @param characteristic	A <code>CBCharacteristic</code> object.
 *	@param error			If an error occurred, the cause of the failure.
 *
 *  @discussion				This method is invoked after a @link readValueForCharacteristic: @/link call, or upon receipt of a notification/indication.
 */
- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    
    NSLog(@"didUpdateValueForCharacteristic: UNIMPLIMENTED"); 
}

/*!
 *  @method peripheral:didWriteValueForCharacteristic:error:
 *
 *  @param peripheral		The peripheral providing this information.
 *  @param characteristic	A <code>CBCharacteristic</code> object.
 *	@param error			If an error occurred, the cause of the failure.
 *
 *  @discussion				This method returns the result of a @link writeValue:forCharacteristic: @/link call.
 */
- (void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    NSLog(@"didWriteValueForCharacteristic: UNIMPLIMENTED");    
}

/*!
 *  @method peripheral:didUpdateNotificationStateForCharacteristic:error:
 *
 *  @param peripheral		The peripheral providing this information.
 *  @param characteristic	A <code>CBCharacteristic</code> object.
 *	@param error			If an error occurred, the cause of the failure.
 *
 *  @discussion				This method returns the result of a @link setNotifyValue:forCharacteristic: @/link call.
 */
- (void)peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    NSLog(@"didUpdateNotificationStateForCharacteristic: UNIMPLIMENTED");  
}

/*!
 *  @method peripheral:didDiscoverDescriptorsForCharacteristic:error:
 *
 *  @param peripheral		The peripheral providing this information.
 *  @param characteristic	A <code>CBCharacteristic</code> object.
 *	@param error			If an error occurred, the cause of the failure.
 *
 *  @discussion				This method returns the result of a @link discoverDescriptorsForCharacteristic: @/link call. If the descriptors were read successfully,
 *							they can be retrieved via <i>characteristic</i>'s <code>descriptors</code> property.
 */
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverDescriptorsForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    NSLog(@"didDiscoverDescriptorsForCharacteristic: UNIMPLIMENTED");
}

/*!
 *  @method peripheral:didUpdateValueForDescriptor:error:
 *
 *  @param peripheral		The peripheral providing this information.
 *  @param descriptor		A <code>CBDescriptor</code> object.
 *	@param error			If an error occurred, the cause of the failure.
 *
 *  @discussion				This method returns the result of a @link readValueForDescriptor: @/link call.
 */
- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForDescriptor:(CBDescriptor *)descriptor error:(NSError *)error
{
    NSLog(@"didUpdateValueForDescriptor: UNIMPLIMENTED");
}

/*!
 *  @method peripheral:didWriteValueForDescriptor:error:
 *
 *  @param peripheral		The peripheral providing this information.
 *  @param descriptor		A <code>CBDescriptor</code> object.
 *	@param error			If an error occurred, the cause of the failure.
 *
 *  @discussion				This method returns the result of a @link writeValue:forDescriptor: @/link call.
 */
- (void)peripheral:(CBPeripheral *)peripheral didWriteValueForDescriptor:(CBDescriptor *)descriptor error:(NSError *)error
{
    NSLog(@"didWriteValueForDescriptor: UNIMPLIMENTED");
}

+ (id) sharedInstance
{
    static BTManager  *this   = nil;
    
    if (!this)
        this = [[BTManager alloc] init];
    
    return this;
}

- (id) init
{
    self = [super init];
    if (self) {
        self.pendingInit = YES;
        self.centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:dispatch_get_main_queue()];
        self.managedPeripherals = [[NSMutableOrderedSet alloc] init];
        self.discoveredPeripherals = [[NSMutableOrderedSet alloc]init];
        self.userDefaults = [NSUserDefaults standardUserDefaults];
        
        self.managedPeripherals = [self.userDefaults objectForKey:MANAGED_PERIPHERALS_KEY];
        for(CBPeripheral *peripheral in self.managedPeripherals){
            if(peripheral.isConnected){
                [self.managedPeripherals addObject:peripheral];
            }
        }

    }
    return self;
}


- (void) dealloc
{
    // We are a singleton and as such, dealloc shouldn't be called.
    assert(NO);
}

@end

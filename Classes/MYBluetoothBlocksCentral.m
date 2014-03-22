//
//  BTBlocksCentral.m
//  NearBy
//
//  Created by 吉田 正史 on 2013/03/07.
//  Copyright (c) 2013年 masafumi yoshida. All rights reserved.
//

#import "MYBluetoothBlocksCentral.h"

@implementation MYBluetoothBlocksCentral



-(id) init{
    self = [ super init];
    if(self){
        self.peripherals = [[ NSMutableArray alloc] init];
        self.isReady = FALSE;
        self.isRunning = FALSE;
    }
    return self;
}

-(void) startCentral{
    NSLog(@"CLIENT: start central");
    self.centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
    self.isRunning =TRUE;
    
    
}



-(void)startCentralWithIdentifier:(NSString*)restoreIdentifirer{
    NSLog(@"CLIENT: start central with identifirer %@",restoreIdentifirer);
    
    self.centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil options:@{ CBCentralManagerOptionRestoreIdentifierKey:restoreIdentifirer}];
    self.isRunning = TRUE;
    
}

-(void) stopSearch{
     NSLog(@"CENTRAL: stop search");
    if(self.centralManager != nil){
        [self.centralManager stopScan];
    }
    self.isSearhing = NO;
}



-(void) stopAll{
    NSLog(@"CLIENT: stop all");
    [self stopSearch];
    
    for(CBPeripheral *peripheal in self.peripherals){
        [ self closePeripheral:peripheal];
    }
    
    self.centralManager = nil;
    self.isRunning =NO;
}

-(void) closePeripheral:(CBPeripheral*)peripheral{
    NSLog(@"CENTRAL: close connection");
    [self.centralManager cancelPeripheralConnection:peripheral];
}

-(void) searchPeripheral{
    NSLog(@"CENTRAL: searchPeripheral");
    /*
     NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:FALSE], CBCentralManagerScanOptionAllowDuplicatesKey, nil];
     */
    [self.centralManager scanForPeripheralsWithServices:self.serviceUUIDs options:nil];
    self.isSearhing = YES;
}

-(void) searchPeripheralAllowDuplicate{
    NSLog(@"CENTRAL: searchPeripheral allow duplicate");
    
     NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:FALSE], CBCentralManagerScanOptionAllowDuplicatesKey, nil];
    
    [self.centralManager scanForPeripheralsWithServices:self.serviceUUIDs options:options];
    self.isSearhing = YES;
}

-(NSArray *) retrieveConnectedPeripheralWithServices{
    NSLog(@"CENTRAL: retrievePeripheralWithService");
    return [self.centralManager retrieveConnectedPeripheralsWithServices:self.serviceUUIDs];
}

// retrieve with saved identifirers
-(NSArray *) retrievePeripheralWithIdentifirers:(NSArray*)identifiers{
    NSLog(@"CENTRAL: retrievePeripheral with identifiers");
    return  [self.centralManager retrievePeripheralsWithIdentifiers:identifiers];
}

// deprecate 
-(void)discoverServices:(CBPeripheral*)peripheral services:(NSMutableArray *)services{
      NSLog(@"CENTRAL: discoverPeripheral");
     [peripheral discoverServices:services];
}

-(void)discoverCharacteristics:(CBService*)service characteristics:(NSMutableArray *)characteristics{
    [self.peripheral discoverCharacteristics:characteristics forService:service];
}


-(void)connectPeripheral:(CBPeripheral*)peripheral{
    NSLog(@"CENTRAL: connect");
  
    
    self.peripheral = peripheral;
    self.peripheral.delegate = self;
    [self.centralManager connectPeripheral:self.peripheral options:nil];
}


- (void)centralManager:(CBCentralManager *)central
 didDiscoverPeripheral:(CBPeripheral *)peripheral
     advertisementData:(NSDictionary *)advertisementData
                  RSSI:(NSNumber *)RSSI
{
    NSLog(@"CENTRAL: discover peripheral");
    if(self.didDiscoverPeripheral){
        self.didDiscoverPeripheral(peripheral,advertisementData,RSSI);
    }
}

- (void)centralManager:(CBCentralManager *)central
  didConnectPeripheral:(CBPeripheral *)peripheral
{
    // 外部デバイスとの接続完了を通知
    NSLog(@"CENTRAL: did connect peripheral");
   // NSLog(@"connect %@",(__bridge_transfer NSString *)CFUUIDCreateString(NULL,peripheral.UUID));

    if(self.didConnectPeripheral){
        self.didConnectPeripheral(peripheral);
    }
   
}


- (void)peripheral:(CBPeripheral *)peripheral
didDiscoverServices:(NSError *)error
{
    NSLog(@"CENTRAL: discover service");
    if(self.didDiscoverServices){
        self.didDiscoverServices(peripheral,error);
    }
}


- (void) peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service
              error:(NSError *)error
{
     NSLog(@"CENTRAL: didDiscoverCharacteristic");
    if(self.didDiscoverCharacteristic){
        self.didDiscoverCharacteristic(peripheral,service,error);
    }    
}

- (void)centralManager:(CBCentralManager *)central
didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error{
    NSLog(@"CENTRAL: did fail connect peripheral");
    if(self.didFailToConnectPeripheral){
        self.didFailToConnectPeripheral(peripheral,error);
    }
}



- (void) centralManager:(CBCentralManager *)central didRetrievePeripherals:(NSArray *)peripherals {
    NSLog(@"CENTRAL: didRetrievePeripherals");
    if(self.didRetrievePeripherals){
        self.didRetrievePeripherals(peripherals);
    }
   
}


- (void) centralManager:(CBCentralManager *)central
didDisconnectPeripheral:(CBPeripheral *)peripheral
                  error:(NSError *)error
{
    NSLog(@"CENTRAL: centralManager:didDisconnectPeripheral:%@ error:%@", peripheral, [error localizedDescription]);
    
    if(self.didDisconnectPeripheral){
        self.didDisconnectPeripheral(peripheral,error);
    }
}



- (void)peripheralDidInvalidateServices:(CBPeripheral *)peripheral
{
    NSLog(@"CENTRAL: peripheralDidInvalidateServices:%@", peripheral);
    if(self.didInvalidateServices){
        self.didInvalidateServices(peripheral);
    }
}



- (void)peripheral:(CBPeripheral *)peripheral didDiscoverIncludedServicesForService:(CBService *)service error:(NSError *)error
{
    NSLog(@"CENTRAL: peripheral:%@ didDiscoverIncludedServicesForService:%@ error:%@",
          peripheral, service, [error localizedDescription]);
}


- (void)centralManagerDidUpdateState:(CBCentralManager *)central{
    if(self.didUpdateStateCentral){
        self.didUpdateStateCentral();
    }
    [ self checkState];
}


- (void)centralManager:(CBCentralManager *)central willRestoreState:(NSDictionary *)dict{
    NSLog(@"CENTRAL: willRestoreState");
    NSArray *peripherals = dict[CBCentralManagerRestoredStatePeripheralsKey];
    
    
  
    
}


// BLE対応デバイスが検出されると呼び出される
- (void)checkState{
    
    switch (self.centralManager.state) {
        case CBCentralManagerStateUnknown:
        {
            NSLog(@"CENTRAL: State unknown, update imminent.");
            break;
        }
        case CBCentralManagerStateResetting:
        {
            NSLog(@"CENTRAL: The connection with the system service was momentarily lost, update imminent.");
            break;
        }
        case CBCentralManagerStateUnsupported:
        {
            NSLog(@"CENTRAL: The platform doesn't support Bluetooth Low Energy");
            break;
        }
        case CBCentralManagerStateUnauthorized:
        {
            NSLog(@"CENTRAL: The app is not authorized to use Bluetooth Low Energy");
            break;
        }
        case CBCentralManagerStatePoweredOff:
        {
            NSLog(@"CENTRAL: Bluetooth is currently powered off.");
            break;
        }
        case CBCentralManagerStatePoweredOn:
        {
            NSLog(@"CENTRAL: Bluetooth is currently powered on and available to use.");
            self.isReady = TRUE;
            if(self.didReadyCentral){
                self.didReadyCentral();
            }
            return;
        }
            
    }
    _isReady = FALSE;
    if(self.didNotReadyCentral){
        self.didNotReadyCentral();
    }
}


-(void) readRSSI{
    [self.peripheral readRSSI];
}


-(void) writeValue:(NSData*) data characteristic:(CBCharacteristic *)characteristic{
    [self.peripheral writeValue:data forCharacteristic:characteristic
                      type:CBCharacteristicWriteWithResponse];
}

-(void) readValue:(CBCharacteristic *)characteristic{
    @try{
    [self.peripheral readValueForCharacteristic:characteristic];
        NSLog(@"CENTRAL: read");
    }@catch (NSError *error) {
        NSLog([error localizedDescription]);
    };
}

-(void) setNotifyValue:(BOOL)boolean characteristic:(CBCharacteristic *)characteristic{
    [self.peripheral setNotifyValue:boolean forCharacteristic:characteristic];
}


- (void)peripheral:(CBPeripheral *)peripheral
didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic
             error:(NSError *)error
{
    NSLog(@"CENTRAL: peripheral:%@ didUpdateValueForCharacteristic:%@ error:%@",
          peripheral, characteristic, error);
    
    if(self.didUpdateValueForCharacteristic){
        self.didUpdateValueForCharacteristic(characteristic,error);
    }
    
}

- (void)peripheral:(CBPeripheral *)peripheral
didWriteValueForCharacteristic:(CBCharacteristic *)characteristic
             error:(NSError *)error
{
    NSLog(@"CENTRAL: peripheral:%@ didWriteValueForCharacteristic:%@ error:%@",
          peripheral, characteristic, [error description]);
    
    if(self.didWriteValueForCharacteristic){
        self.didWriteValueForCharacteristic(characteristic,error);
    }
}

- (void)peripheral:(CBPeripheral *)peripheral
didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic
             error:(NSError *)error
{
    NSLog(@"CENTRAL: didUpdateNotificationStateForCharacteristic");
    
    if(self.didUpdateNotificationStateForCharacteristic){
        self.didUpdateNotificationStateForCharacteristic(characteristic,error);
    }
}
- (void)peripheralDidUpdateName:(CBPeripheral *)peripheral
{
    NSLog(@"CENTRAL: peripheralDidUpdateName:%@", peripheral);
    if(self.didUpdateName){
        self.didUpdateName();
    }
}



- (void)peripheralDidUpdateRSSI:(CBPeripheral *)peripheral error:(NSError *)error{
    
    NSLog(@"CENTRAL: peripheral:%@ peripheralDidUpdateRSSI:%d error:%@ ",
          peripheral, [peripheral.RSSI intValue], [error localizedDescription]);
    
    if(self.didUpdateRSSI){
        self.didUpdateRSSI(error);
    }
}


@end

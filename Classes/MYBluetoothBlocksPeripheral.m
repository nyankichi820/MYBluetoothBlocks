//
//  BlueToothServer.m
//  NearBy
//
//  Created by 吉田 正史 on 2013/03/06.
//  Copyright (c) 2013年 masafumi yoshida. All rights reserved.
//

#import "MYBluetoothBlocksPeripheral.h"

@implementation MYBluetoothBlocksPeripheral


-(id) init{
    self = [ super init];
    if(self){
        _isReady = FALSE;
        _isRunning = FALSE;
    }
    return self;
}

-(void)startPeripheral{
    NSLog(@"PERIPHERAL: start peripheral");
    
    NSMutableArray *UUIDs = [[NSMutableArray alloc] init];
    for(CBService *service in self.services){
        [UUIDs addObject:service.UUID];
    }
    self.advertiseInfo = @{ CBAdvertisementDataLocalNameKey : self.localName, CBAdvertisementDataServiceUUIDsKey : UUIDs};
    
    self.peripheralManager =   [[CBPeripheralManager alloc] initWithDelegate:self queue:nil];
    self.isRunning = TRUE;
    

}





-(void)startPeripheralWithIdentifier:(NSString*)restoreIdentifirer{
    NSLog(@"PERIPHERAL: start peripheral");
    self.peripheralManager =   [[CBPeripheralManager alloc] initWithDelegate:self queue:nil options:@{ CBPeripheralManagerOptionRestoreIdentifierKey:restoreIdentifirer}];
    self.isRunning = TRUE;
    
}




-(void) stopPeripheral{
    NSLog(@"PERIPHERAL: stop pheripheral");
    if(self.peripheralManager != nil){
        [self.peripheralManager stopAdvertising];
        [self.peripheralManager removeAllServices];
      
    }
    
    self.isRunning = FALSE;
}

- (void)addServices{
    for(CBService *service in self.services){
        [self.peripheralManager addService:service];
    }
}

- (void)advertiseServices {
    NSLog(@"PERIPHERAL: advertise");
    
    [self.peripheralManager startAdvertising:self.advertiseInfo];
    
}




- (BOOL)sendValue:(NSData*) data characteristic:(CBCharacteristic *)characteristic onSubscribedCentrals:(NSArray*)centrals{
    
    return [self.peripheralManager updateValue:data
                             forCharacteristic:characteristic
                          onSubscribedCentrals:centrals];
    
    NSLog(@"PERIPHERAL: sended");
}


- (void)peripheralManagerDidUpdateState:(CBPeripheralManager *)peripheral {
    NSLog(@"PERIPHERAL: update Status");
    
    
    if(self.didUpdateStatePeripheral){
        self.didUpdateStatePeripheral(peripheral);
    }
    [ self checkState];
}

-(void)checkState{
    switch (self.peripheralManager.state) {
        case CBPeripheralManagerStatePoweredOn:
            self.isReady = TRUE;
            NSLog(@"PERIPHERAL: setup");
            if(self.didReadyPeripheral){
                self.didReadyPeripheral();
            }
            return;
        default: NSLog(@"PERIPHERAL: Peripheral Manager did change state");
            if(self.didNotReadyPeripheral){
                self.didNotReadyPeripheral();
            }
            break;
    }
    self.isReady = FALSE;
}

- (void)peripheralManager:(CBPeripheralManager *)peripheral
            didAddService:(CBService *)service
            error:(NSError *)error {
    NSLog(@"PERIPHERAL: didAddService");
    
    if(self.didAddService){
        self.didAddService(service,error);
    }
}

- (void)peripheralManagerDidStartAdvertising:(CBPeripheralManager *)peripheral error:(NSError *)error
{
    NSLog(@"PERIPHERAL: advertised");
    if(self.didStartAdvertising){
        self.didStartAdvertising(error);
    }

}



- (void) peripheralManager:(CBPeripheralManager *) peripheral
                   central:(CBCentral *)central
didSubscribeToCharacteristic:(CBCharacteristic *)characteristic
{
    
    NSLog(@"PERIPHERAL: peripheralManager:central:didSubscribeToCharacteristic:");
    if(self.didSubscribeToCharacteristic){
        self.didSubscribeToCharacteristic(central,characteristic);
    }
}

- (void)peripheralManager:(CBPeripheralManager *)peripheral central:(CBCentral *)central didUnsubscribeFromCharacteristic:(CBCharacteristic *)characteristic
{
  
    NSLog(@"PERIPHERAL: peripheralManager:central:didUnsubscribeFromCharacteristic:");
    if(self.didUnsubscribeFromCharacteristic){
        self.didUnsubscribeFromCharacteristic(central,characteristic);
    }
}

- (void)peripheralManager:(CBPeripheralManager *)peripheral didReceiveReadRequest:(CBATTRequest *)request
{
    NSLog(@"PERIPHERAL: peripheralManager:didReceiveRequest:");
    if(self.didReceiveReadRequest){
        self.didReceiveReadRequest(request);
    }
}

- (void)peripheralManager:(CBPeripheralManager *)peripheral didReceiveWriteRequests:(NSArray *)requests
{
    NSLog(@"PERIPHERAL: peripheralManager:%@ didReceiveWriteRequests:%@", peripheral, requests);
    if(self.didReceiveWriteRequests){
        self.didReceiveWriteRequests(requests);
    }
}

- (void)peripheralManagerIsReadyToUpdateSubscribers:(CBPeripheralManager *)peripheral
{
     NSLog(@"PERIPHERAL: peripheralManagerIsReadyToUpdateSubscribers:");
    
    if(self.isReadyToUpdateSubscribers){
        self.isReadyToUpdateSubscribers();
    }
}

- (void)peripheralManager:(CBPeripheralManager *)peripheral willRestoreState:(NSDictionary *)dict{
    NSLog(@"PERIPHERAL: willRestoreState");
     NSArray *peripherals = dict[CBCentralManagerRestoredStatePeripheralsKey];
    
}




@end

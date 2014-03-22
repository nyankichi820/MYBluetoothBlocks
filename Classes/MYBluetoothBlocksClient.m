//
//  BlueToothBrowser.m
//  NearBy
//
//  Created by 吉田 正史 on 2013/03/07.
//  Copyright (c) 2013年 masafumi yoshida. All rights reserved.
//

#import "MYBluetoothBlocksClient.h"

@implementation MYBluetoothBlocksClient

static MYBluetoothBlocksClient *instance = 0;

+ (MYBluetoothBlocksClient *) shared{
    if( instance == 0 ) {
        instance = [ [ MYBluetoothBlocksClient alloc ] init ];
    }
    return (instance);
}

-(void)setupRootClient:(NSArray*)serviceUUIDs{
    instance.childClients = [[NSMutableArray alloc] init];
    self.serviceUUIDs = serviceUUIDs;
    
    __weak typeof(self) weakSelf = self;
    
    self.didReadyCentral = ^(){
        NSLog(@"CLIENT: ready");
        if(weakSelf.didReady){
            weakSelf.didReady();
        }
        [ weakSelf searchPeripheral];

    };
    
    self.didDiscoverPeripheral = ^(CBPeripheral *peripheral,NSDictionary *advertisementData,NSNumber *RSSI){
        NSLog(@"CLIENT: discover peripheral");
        if (peripheral.state == CBPeripheralStateDisconnected){
            [weakSelf connectPeripheral:peripheral];
        }
    };
    
    self.didRetrievePeripherals = ^(NSArray *peripherals){
        NSLog(@"CLIENT: retrieve pheripheral");
        for(CBPeripheral *peripheral in peripherals){
            if (peripheral.state == CBPeripheralStateDisconnected){
                [weakSelf connectPeripheral:peripheral];
            }
            else{
                [weakSelf discoverServices:peripheral services:weakSelf.serviceUUIDs];
            }
        }
    };
    
    self.didConnectPeripheral = ^(CBPeripheral *peripheral){
        NSLog(@"CLIENT: connect pheripheral");
        if(weakSelf.didConnect){
            weakSelf.didConnect(peripheral);
        }
        [weakSelf.peripherals addObject:peripheral];
        [weakSelf discoverServices:peripheral services:weakSelf.serviceUUIDs];
        
    };
    
    self.didDisconnectPeripheral = ^(CBPeripheral *peripheral,NSError *error){
        NSLog(@"CLIENT: disconnect pheripheral");
        if(weakSelf.didDisconnect){
            weakSelf.didDisconnect(peripheral,error);
        }
        [weakSelf.peripherals removeObject:peripheral];
        [weakSelf connectPeripheral:peripheral];
    };
    
    
    self.didDiscoverServices  = ^(CBPeripheral *aPeripheral,NSError *error){
        
        for (CBService *service in aPeripheral.services)
        {
            
            NSLog(@"CLIENT: didDiscoverService UUID %@", [ service UUID]);
            
            
            if([weakSelf.serviceUUIDs containsObject:service.UUID]){
                
                [weakSelf discoverCharacteristics:service characteristics:weakSelf.characteristics];
            }
            
        }
    };

    
    self.didDiscoverCharacteristic = ^(CBPeripheral *peripheral,CBService *service,NSError *error){
        NSLog(@"CLIENT: discover characteristics");
        
        MYBluetoothBlocksClient *child = [[MYBluetoothBlocksClient alloc] init];
        child.didDiscoverServer = weakSelf.didDiscoverServer;
       
        if(!error){
             NSLog(@"CLIENT: start Child");
            [child setupChildClient:peripheral service:service];
            if(weakSelf.didDiscoverServer){
                weakSelf.didDiscoverServer(child);
            }
        }
        else{
            NSLog(@"CLIENT: discover characteristics error %@",[error description]);
        }
    };
    
    
}


-(void)setupChildClient:(CBPeripheral *)peripheral service:(CBService*)service{
    self.peripheral = peripheral;
    self.service    = service;
    
    
    
}

-(NSString*)UUIDString:(CBUUID *)uuid{
    return (__bridge_transfer NSString*) CFUUIDCreateString(nil ,(__bridge CFUUIDRef)(uuid));
}

-(BOOL)isEqualUUID:(CBUUID *)uuid1 and:(CBUUID *)uuid2{
    NSString *uuid = (__bridge_transfer NSString*) CFUUIDCreateString(nil ,(__bridge CFUUIDRef)(uuid1));
    NSString *uuidTarget = (__bridge_transfer NSString*) CFUUIDCreateString(nil ,(__bridge CFUUIDRef)(uuid2));
    return [uuid isEqualToString:uuidTarget];
}


-(void) stopAll{
    NSLog(@"CLIENT: stop all");
    for(CBPeripheral *peripheal in self.peripherals){
        [ self closePeripheral:peripheal];
    }
    [self stopSearch];
}

@end

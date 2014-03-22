//
//  BlueToothServer.m
//  NearBy
//
//  Created by 吉田 正史 on 2013/03/06.
//  Copyright (c) 2013年 masafumi yoshida. All rights reserved.
//

#import "MYBluetoothBlocksServer.h"


@implementation MYBluetoothBlocksServer

static MYBluetoothBlocksServer *instance = 0;

+ (MYBluetoothBlocksServer *) shared{
    if( instance == 0 ) {
        instance = [ [ MYBluetoothBlocksServer alloc ] init ];
    }
    
    return (instance);
}




-(void)setupServer:(NSString*)localName services:(NSArray*)services{
    self.localName = localName;
    self.services  = services;
    
    
    __weak typeof(self) weakSelf = self;

    self.didReadyPeripheral = ^(){
         NSLog(@"SERVER: ready peripheral");
        [ weakSelf addServices];
    };
 
    self.didAddService = ^(CBService *service,NSError * error){
        NSLog(@"SERVER: add service");
        [ weakSelf advertiseServices];
    };
    
    self.didStartAdvertising = ^(NSError * error){
        if(!error && weakSelf.didReadyServer){
            weakSelf.didReadyServer();
        }
        else{
            NSLog(@"SERVER ERROR :%@",error.description);
        }
    };
    
    self.subscribers = [NSMutableArray array];
    
    
    // notification send
    self.didSubscribeToCharacteristic = ^(CBCentral *central,CBCharacteristic *characteristic){
        NSLog(@"subscribe");
        MYBluetoothBlocksSubscriber *subscriber = [[MYBluetoothBlocksSubscriber alloc] init];
        subscriber.central = central;
        subscriber.characteristic = characteristic;
        [weakSelf.subscribers addObject:subscriber];
        if(weakSelf.didSubscribe){
            weakSelf.didSubscribe(subscriber);
        }
    };
    
    self.didUnsubscribeFromCharacteristic = ^(CBCentral *central,CBCharacteristic *characteristic){
        NSLog(@"unsubscribe");
        
        for(MYBluetoothBlocksSubscriber *subscriber in weakSelf.subscribers){
            if([subscriber.central isEqual:central] && [subscriber.characteristic isEqual:characteristic]){
                [weakSelf.subscribers removeObject:subscriber];
                if(weakSelf.didUnSubscribe){
                    weakSelf.didUnSubscribe(subscriber);
                }
            }
        }
        
    };
    
    self.didReceiveWriteRequests = ^(NSArray *requests){
        NSLog(@"SERVER: didReceiveWriteRequests");
        NSMutableData *data = [[NSMutableData alloc]init];
        
        
        for(CBATTRequest *request in requests){
            [data appendData:request.value];
            [weakSelf.peripheralManager respondToRequest:request withResult:CBATTErrorSuccess];
            if([requests.lastObject isEqual:request]){
                if(weakSelf.didReceiveData){
                    weakSelf.didReceiveData(request,data);
                }
            }
            
        }
        
    };

}


@end

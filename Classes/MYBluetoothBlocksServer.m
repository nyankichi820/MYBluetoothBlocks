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
        if(weakSelf.didReady){
            weakSelf.didReady();
        }
        [ weakSelf addServices];
    };
 
    self.didAddService = ^(CBService *service,NSError * error){
        NSLog(@"SERVER: add service");
        [ weakSelf advertiseServices];
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

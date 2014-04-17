//
//  MYBeaconBlocksServer.m
//  MYBluetoothBlocks
//
//  Created by masafumi yoshida on 2014/04/17.
//  Copyright (c) 2014年 masafumi yoshida. All rights reserved.
//

#import "MYBeaconBlocksServer.h"

@implementation MYBeaconBlocksServer

static MYBeaconBlocksServer *instance = 0;

+ (MYBeaconBlocksServer *) shared{
    if( instance == 0 ) {
        instance = [ [ MYBeaconBlocksServer alloc ] init ];
    }
    
    return (instance);
}

-(void)startBeacon{
    NSLog(@"PERIPHERAL: start beacon");
    self.peripheralManager =   [[CBPeripheralManager alloc] initWithDelegate:self queue:nil];
    self.isRunning = TRUE;
    
    
}



-(void)setupBeacon:(CLBeaconRegion*)beaconRegion{
    
    self.beaconRegion =  beaconRegion;
    self.advertiseInfo =  [beaconRegion peripheralDataWithMeasuredPower:nil];
    
    
    
    __weak typeof(self) weakSelf = self;
    
    self.didReadyPeripheral = ^(){
        NSLog(@"SERVER: ready peripheral");
        [ weakSelf advertiseServices];
    };
    
    
    self.didStartAdvertising = ^(NSError * error){
        if(error){
            NSLog(@"SERVER ERROR :%@",error.description);
        }
        else if(weakSelf.didReadyServer){
            weakSelf.didReadyServer();
        }
    };
    
  
    
}




@end

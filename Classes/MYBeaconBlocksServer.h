//
//  MYBeaconBlocksServer.h
//  MYBluetoothBlocks
//
//  Created by masafumi yoshida on 2014/04/17.
//  Copyright (c) 2014年 masafumi yoshida. All rights reserved.
//

#import "MYBluetoothBlocksPeripheral.h"
#import <CoreLocation/CoreLocation.h>

@interface MYBeaconBlocksServer : MYBluetoothBlocksPeripheral
typedef void (^MYBeaconBlocksServerDidReadyBlock)();

@property(readwrite, copy) MYBeaconBlocksServerDidReadyBlock didReadyServer;
@property (nonatomic,strong) CLBeaconRegion *beaconRegion;



+ (MYBeaconBlocksServer *) shared;
-(void)startBeacon;
-(void)setupBeacon:(CLBeaconRegion*)beaconRegion;
@end

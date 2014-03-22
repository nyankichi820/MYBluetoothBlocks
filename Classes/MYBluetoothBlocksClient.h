//
//  BlueToothBrowser.h
//  NearBy
//
//  Created by 吉田 正史 on 2013/03/07.
//  Copyright (c) 2013年 masafumi yoshida. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "MYBluetoothBlocks.h"




@interface MYBluetoothBlocksClient : MYBluetoothBlocksCentral
typedef void (^MYBluetoothBlocksClientDidReadyBlock)();
typedef void (^MYBluetoothBlocksClientDidConnectBlocks)(CBPeripheral *peripheral);
typedef void (^MYBluetoothBlocksClientDidDisconnectBlocks)(CBPeripheral *peripheral,NSError *error);
typedef void (^MYBluetoothBlocksDidFailToConnectBlocks)(CBPeripheral *peripheral,NSError *error);
typedef void (^MYBluetoothBlocksDidDiscoverServerBlocks)(MYBluetoothBlocksClient *childClient);

+ (MYBluetoothBlocksClient *) shared;

@property(readwrite, copy) MYBluetoothBlocksClientDidReadyBlock didReady;
@property(readwrite, copy) MYBluetoothBlocksClientDidConnectBlocks didConnect;
@property(readwrite, copy) MYBluetoothBlocksClientDidDisconnectBlocks didDisconnect;
@property(readwrite, copy) MYBluetoothBlocksDidFailToConnectBlocks didFailToConnect;

@property(readwrite, copy) MYBluetoothBlocksDidDiscoverServerBlocks didDiscoverServer;


@property (nonatomic,retain) NSMutableArray *childClients;

-(void)setupRootClient:(NSArray*)serviceUUIDs;

-(void)setupChildClient:(CBPeripheral *)peripheral service:(CBService*)service;


-(void) stopAll;

@end

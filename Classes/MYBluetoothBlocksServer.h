//
//  BlueToothServer.h
//  NearBy
//
//  Created by 吉田 正史 on 2013/03/06.
//  Copyright (c) 2013年 masafumi yoshida. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "MYBluetoothBlocks.h"
#import "MYBluetoothBlocksSubscriber.h"

@interface MYBluetoothBlocksServer : MYBluetoothBlocksPeripheral

typedef void (^MYBluetoothBlocksServerDidReadyBlock)();
typedef void (^MYBluetoothBlocksServerDidReceiveDataBlocks)(CBATTRequest *request,NSData *data);
typedef void (^MYBluetoothBlocksServerDidSubscribe)(MYBluetoothBlocksSubscriber *subscriber);
typedef void (^MYBluetoothBlocksServerDidUnSubscribe)(MYBluetoothBlocksSubscriber *subscriber);

@property(readwrite, copy) MYBluetoothBlocksServerDidReadyBlock didReadyServer;
@property(readwrite, copy) MYBluetoothBlocksServerDidReceiveDataBlocks didReceiveData;
@property(readwrite, copy) MYBluetoothBlocksServerDidSubscribe didSubscribe;
@property(readwrite, copy) MYBluetoothBlocksServerDidUnSubscribe didUnSubscribe;
@property (nonatomic,strong) NSMutableArray *subscribers;


+ (MYBluetoothBlocksServer *) shared;
-(void)setupServer:(NSString*)localName services:(NSArray*)services;

@end

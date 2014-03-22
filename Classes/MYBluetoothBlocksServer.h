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
@interface MYBluetoothBlocksServer : MYBluetoothBlocksPeripheral
typedef void (^MYBluetoothBlocksServerDidReadyBlock)();
typedef void (^MYBluetoothBlocksServerDidReceiveDataBlocks)(CBATTRequest *request,NSData *data);

@property (nonatomic,retain) NSString *shortMessage;

@property(readwrite, copy) MYBluetoothBlocksServerDidReadyBlock didReady;
@property(readwrite, copy) MYBluetoothBlocksServerDidReceiveDataBlocks didReceiveData;


+ (MYBluetoothBlocksServer *) shared;
-(void)setupServer:(NSString*)localName services:(NSArray*)services;

@end

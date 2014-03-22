//
//  MYBluetoothBlocksSubscriber.h
//  MYBluetoothBlocks
//
//  Created by masafumi yoshida on 2014/03/22.
//  Copyright (c) 2014年 masafumi yoshida. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

@interface MYBluetoothBlocksSubscriber : NSObject
@property(nonatomic, strong) CBCentral *central;
@property(nonatomic, strong) CBCharacteristic *characteristic;


@end

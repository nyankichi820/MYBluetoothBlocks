//
//  BTBlocksPeripheral.h
//  NearBy
//
//  Created by 吉田 正史 on 2013/03/06.
//  Copyright (c) 2013年 masafumi yoshida. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>



@interface MYBluetoothBlocksPeripheral : NSObject<CBPeripheralManagerDelegate>

typedef void (^BTBlocksPeripheralDidReadyPeripheralBlock)();
typedef void (^BTBlocksPeripheralDidNotReadyPeripheralBlock)();

typedef void (^BTBlocksPeripheralDidUpdateStatePeripheralBlock)(CBPeripheralManager *peripheral );
typedef void (^BTBlocksPeripheralIsReadyToUpdateSubscribersBlock)();
typedef void (^BTBlocksPeripheralDidAddServiceBlock)(CBService *service,NSError * error);
typedef void (^BTBlocksPeripheralDidStartAdvertisingBlock)(NSError *error);
typedef void (^BTBlocksPeripheralDidReceiveWriteRequestslocks)(NSArray *requests);
typedef void (^BTBlocksPeripheralDidSubscribeToCharacteristicBlocks)(CBCentral * central,CBCharacteristic *characteristic);
typedef void (^BTBlocksPeripheralDidUnsubscribeFromCharacteristicBlocks)(CBCentral * central,CBCharacteristic *characteristic);
typedef void (^BTBlocksPeripheralDidReceiveReadRequestBlocks)(CBATTRequest *request);

@property(readwrite, copy) BTBlocksPeripheralDidReadyPeripheralBlock didReadyPeripheral;
@property(readwrite, copy) BTBlocksPeripheralDidNotReadyPeripheralBlock didNotReadyPeripheral;
@property(readwrite, copy) BTBlocksPeripheralDidUpdateStatePeripheralBlock didUpdateStatePeripheral;
@property(readwrite, copy) BTBlocksPeripheralDidAddServiceBlock didAddService;
@property(readwrite, copy) BTBlocksPeripheralDidStartAdvertisingBlock didStartAdvertising;
@property(readwrite, copy) BTBlocksPeripheralIsReadyToUpdateSubscribersBlock isReadyToUpdateSubscribers;
@property(readwrite, copy) BTBlocksPeripheralDidReceiveWriteRequestslocks   didReceiveWriteRequests;
@property(readwrite, copy) BTBlocksPeripheralDidSubscribeToCharacteristicBlocks didSubscribeToCharacteristic;
@property(readwrite, copy) BTBlocksPeripheralDidUnsubscribeFromCharacteristicBlocks didUnsubscribeFromCharacteristic;
@property(readwrite, copy) BTBlocksPeripheralDidReceiveReadRequestBlocks didReceiveReadRequest;
@property (nonatomic,strong)  CBCentralManager *centralManager;
@property (nonatomic,strong)  NSString *localName;
@property (nonatomic,strong)  CBPeripheralManager *peripheralManager;
@property (nonatomic,strong)  NSDictionary *advertiseInfo;
@property (nonatomic,strong)  NSArray *services;
@property (nonatomic) BOOL isRunning;
@property (nonatomic) BOOL isReady;

- (BOOL)sendValue:(NSData*) data characteristic:(CBCharacteristic *)characteristic onSubscribedCentrals:(NSArray*)centrals;

- (void)startPeripheral;
- (void)startPeripheralWithIdentifier:(NSString*)restoreIdentifirer;
- (void)stopPeripheral;

- (void)addServices;

- (void)advertiseServices;
@end

//
//  BTBlocksCentral.h
//  NearBy
//
//  Created by 吉田 正史 on 2013/03/07.
//  Copyright (c) 2013年 masafumi yoshida. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>




@interface MYBluetoothBlocksCentral : NSObject<CBCentralManagerDelegate,CBPeripheralDelegate>
typedef void (^BTBlocksCentralDidReadyCentralBlock)();
typedef void (^BTBlocksCentralDidNotReadyCentralBlock)();
typedef void (^BTBlocksCentralDidUpdateStateCentralBlock)();
typedef void (^BTBlocksCentralDiscoverPeripherarlBlocks)(CBPeripheral *peripheral,NSDictionary *advertisementData
                                                         ,NSNumber *RSSI);
typedef void (^BTBlocksCentralDidConnectPeripheralBlocks)(CBPeripheral *peripheral);
typedef void (^BTBlocksCentralDidDisconnectPeripheralBlocks)(CBPeripheral *peripheral,NSError *error);

typedef void (^BTBlocksCentralDidDiscoverServicesBlocks)(CBPeripheral *peripheral,NSError *error);
typedef void (^BTBlocksCentralDidDiscoverCharacteristicBlocks)(CBPeripheral *peripheral,CBService *service,NSError *error);
typedef void (^BTBlocksCentralDidFailToConnectPeripheralBlocks)(CBPeripheral *peripheral,NSError *error);
typedef void (^BTBlocksCentralDidRetrievePeripheralsBlocks)(NSArray *peripherals);
typedef void (^BTBlocksCentralDidInvalidateServicesBlocks)();

typedef void (^BTBlocksCentralDidWriteValueForCharacteristicBlocks)(CBCharacteristic *characteristic,NSError *error);
typedef void (^BTBlocksCentralDidUpdateNotificationStateForCharacteristicBlocks)(CBCharacteristic *characteristic,NSError *error);
typedef void (^BTBlocksCentralDidUpdateValueForCharacteristicBlocks)(CBCharacteristic *characteristic,NSError *error);
typedef void (^BTBlocksCentralDidUpdateRSSIBlocks)(NSError *error);
typedef void (^BTBlocksCentralDidUpdateNameBlocks)();

@property(readwrite, copy) BTBlocksCentralDidReadyCentralBlock didReadyCentral;
@property(readwrite, copy) BTBlocksCentralDidNotReadyCentralBlock didNotReadyCentral;
@property(readwrite, copy) BTBlocksCentralDidUpdateStateCentralBlock didUpdateStateCentral;
@property(readwrite, copy) BTBlocksCentralDidConnectPeripheralBlocks didConnectPeripheral;
@property(readwrite, copy) BTBlocksCentralDidDisconnectPeripheralBlocks didDisconnectPeripheral;
@property(readwrite, copy) BTBlocksCentralDiscoverPeripherarlBlocks didDiscoverPeripheral;
@property(readwrite, copy) BTBlocksCentralDidDiscoverServicesBlocks didDiscoverServices;
@property(readwrite, copy) BTBlocksCentralDidDiscoverCharacteristicBlocks didDiscoverCharacteristic;
@property(readwrite, copy) BTBlocksCentralDidFailToConnectPeripheralBlocks didFailToConnectPeripheral;
@property(readwrite, copy) BTBlocksCentralDidRetrievePeripheralsBlocks didRetrievePeripherals;
@property(readwrite, copy) BTBlocksCentralDidInvalidateServicesBlocks didInvalidateServices;
@property(readwrite, copy) BTBlocksCentralDidUpdateValueForCharacteristicBlocks didUpdateValueForCharacteristic;
@property(readwrite, copy) BTBlocksCentralDidWriteValueForCharacteristicBlocks didWriteValueForCharacteristic;
@property(readwrite, copy) BTBlocksCentralDidUpdateNotificationStateForCharacteristicBlocks didUpdateNotificationStateForCharacteristic;
@property(readwrite, copy) BTBlocksCentralDidUpdateRSSIBlocks didUpdateRSSI;
@property(readwrite, copy) BTBlocksCentralDidUpdateNameBlocks didUpdateName;


@property (nonatomic,strong) CBCentralManager *centralManager;
@property (nonatomic,strong) CBPeripheral *peripheral;
@property (nonatomic,strong) CBCharacteristic *characteristic;
@property (nonatomic,strong) CBService *service;

@property (nonatomic,retain) NSMutableArray *peripherals;
@property (nonatomic,strong) NSArray *serviceUUIDs;
@property (nonatomic,strong) NSMutableArray *characteristics;
@property (nonatomic) BOOL isRunning;
@property (nonatomic) BOOL isReady;
@property (nonatomic) BOOL isSearhing;


-(void) startCentral;
-(void) startCentralWithIdentifier:(NSString*)restoreIdentifirer;
-(void) searchPeripheral;
-(void) searchPeripheralAllowDuplicate;
-(void) stopSearch;
-(void) stopAll;
-(void) closePeripheral:(CBPeripheral*)peripheral;
-(NSArray *) retrieveConnectedPeripheralWithServices;
-(NSArray *) retrievePeripheralWithIdentifirers:(NSArray*)identifiers;
-(void) discoverServices:(CBPeripheral*)peripheral services:(NSMutableArray *)services;
-(void) discoverCharacteristics:(CBService*)service characteristics:(NSMutableArray *)characteristics;
-(void) connectPeripheral:(CBPeripheral*)peripheral;
-(void) readRSSI;
-(void) writeValue:(NSData*) data characteristic:(CBCharacteristic *)characteristic;
-(void) readValue:(CBCharacteristic *)characteristic;
-(void) setNotifyValue:(BOOL)boolean characteristic:(CBCharacteristic *)characteristic;
@end

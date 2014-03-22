//
//  MYViewController.m
//  MYBluetoothBlocks
//
//  Created by masafumi yoshida on 2014/03/21.
//  Copyright (c) 2014年 masafumi yoshida. All rights reserved.
//

#import "MYViewController.h"
#import "MYBluetoothBlocksClient.h"
#import "MYBluetoothBlocksServer.h"
#import <CoreBluetooth/CoreBluetooth.h>


// generate from uuidgen command
static NSString * kCBUUIDTestNotify = @"39D7E799-7191-4974-8E7C-5393E3EA5866";
static NSString * kCBUUIDTestWrite  = @"34432C9B-5A4B-42AB-A3EA-A6A5E48975EE";
static NSString * kCBUUIDTestRead   = @"A28B8144-9573-4EF3-A491-2C090D71B77C";
static NSString * kCBUUIDTestService   = @"F1453167-EC82-4DE9-BD9C-1406F3B8A7B4";

@interface MYViewController ()

@end

@implementation MYViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
     // Creates the service UUID
    
    
     
     CBMutableCharacteristic * notifyCharacteristic = [[CBMutableCharacteristic alloc] initWithType:[CBUUID UUIDWithString:kCBUUIDTestNotify] properties:CBCharacteristicPropertyNotify value:nil permissions:CBAttributePermissionsReadable];
    
    
     CBMutableCharacteristic * writeCharacteristic = [[CBMutableCharacteristic alloc] initWithType:[CBUUID UUIDWithString:kCBUUIDTestWrite] properties:CBCharacteristicPropertyWrite value:nil permissions:CBAttributePermissionsWriteable];
     
     CBMutableCharacteristic * readCharacteristic = [[CBMutableCharacteristic alloc] initWithType:[CBUUID UUIDWithString:kCBUUIDTestRead] properties:CBCharacteristicPropertyRead value:nil permissions:CBAttributePermissionsReadable];
     
     [readCharacteristic setValue:[@"hello" dataUsingEncoding:NSUTF8StringEncoding]];
     
     // Creates the service and adds the characteristic to it
     CBMutableService *service = [[CBMutableService alloc] initWithType:[CBUUID UUIDWithString:kCBUUIDTestService ] primary:YES];
     
     // Sets the characteristics for this service
     [service setCharacteristics:@[notifyCharacteristic,writeCharacteristic,readCharacteristic]];
     
     
     NSMutableArray *services = [ NSMutableArray arrayWithObjects:service,nil];
   
    
    MYBluetoothBlocksServer *server = [MYBluetoothBlocksServer shared];
    
    [server setupServer:@"my bt" services:services];
    
    
    // receive data
    server.didReceiveData = ^(CBATTRequest *request,NSData *data){
        NSLog(@"receive data");
        NSString *readString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        
        NSLog(@"receive data %@",readString);
    };
    
   
    // notification send
    server.didSubscribeToCharacteristic = ^(CBCentral *central,CBCharacteristic *characteristic){
        NSLog(@"subscribe");
        
        NSLog(@"send notify");
        NSData *writeData = [@"notify" dataUsingEncoding:NSUTF8StringEncoding];
        [server sendValue:writeData characteristic:characteristic onSubscribedCentrals:@[central]];
        
       
    };
    
    
    [server  startPeripheral];
    
     //  set background restore identifier if require multi peripheral
    //[server  startPeripheralWithIdentifier:@"myPeripheral"];
    
    
    
    MYBluetoothBlocksClient *client = [MYBluetoothBlocksClient shared];
    [client setupRootClient:@[[CBUUID UUIDWithString:kCBUUIDTestService]]];
    
    
    client.didReady = ^() {
        self.status.text = @"ready";
    };
    
    client.didConnect = ^(CBPeripheral *peripheral) {
        self.status.text = [NSString stringWithFormat:@"connect %@",peripheral.name] ;
    
    };
    
    
    client.didDiscoverServer = ^(MYBluetoothBlocksClient *childClient) {
        self.status.text = [NSString stringWithFormat:@"find server "] ;
        
        
        
        
        childClient.didUpdateValueForCharacteristic = ^(CBCharacteristic *characteristic,NSError *error){
            NSString *readString = [[NSString alloc] initWithData:characteristic.value encoding:NSUTF8StringEncoding];
            
            NSLog(@"read data %@",readString);

            
        };
        
        childClient.didWriteValueForCharacteristic = ^(CBCharacteristic *characteristic,NSError *error){
            
          
            
        };
        
        childClient.didUpdateRSSI = ^(NSError *error){
            NSLog(@"RSSI %f",childClient.peripheral.RSSI.floatValue);
            
        };
        
        for(CBCharacteristic *characteristic in childClient.service.characteristics){
            if([characteristic.UUID isEqual:notifyCharacteristic.UUID]){
                
                NSLog(@"notify charastaristic");
                [childClient setNotifyValue:YES characteristic:characteristic];
            }
            
            if([characteristic.UUID isEqual:readCharacteristic.UUID]){
                 NSLog(@"read charastaristic");
                [childClient readValue:characteristic];
            }
            
            if([characteristic.UUID isEqual:writeCharacteristic.UUID]){
                 NSLog(@"write charastaristic");
                NSData *writeData = [@"send data" dataUsingEncoding:NSUTF8StringEncoding];
                [childClient writeValue:writeData characteristic:characteristic];
            }
            
        }
        
        
        [childClient readRSSI];
        
    };
    
    [client startCentral];
    
    //  set background restore identifier if require multi central
    //[client startCentralWithIdentifier:@"myCentral"];
    
    
    
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

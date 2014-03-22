//
//  MYViewController.m
//  MYBluetoothBlocks
//
//  Created by masafumi yoshida on 2014/03/21.
//  Copyright (c) 2014年 masafumi yoshida. All rights reserved.
//

#import "MYViewController.h"
#import "MYBluetoothBlocks.h"
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
    
    __weak typeof(self) weakSelf = self;
     // Creates the service UUID
    
    
     // initialize peripheral
     
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
    
    
    __weak typeof(server) weakServer = server;
    
    [server setupServer:@"my bt" services:services];
    
    server.didReadyServer = ^(){
        weakSelf.peripheralStatus.text = @"ready";
    };
    
    // receive data
    server.didReceiveData = ^(CBATTRequest *request,NSData *data){
        NSLog(@"receive data");
        NSString *readString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        
        NSLog(@"receive data %@",readString);
    };
    
   
    // notification send
    server.didSubscribe = ^(MYBluetoothBlocksSubscriber *subscriber){
        NSLog(@"subscribe");
        weakSelf.centralPeripheralsCount.text = [NSString stringWithFormat:@"Subscribers : %d",weakServer.subscribers.count] ;
        
    };
    
    
    
    
    // initialize central
    
    
    MYBluetoothBlocksClient *client = [MYBluetoothBlocksClient shared];
    [client setupRootClient:@[[CBUUID UUIDWithString:kCBUUIDTestService]]];
    
    
    client.didReadyCentral = ^() {
        weakSelf.centralStatus.text = @"ready";
    };
    
    __weak typeof(client) weakClient = client;
    client.didDiscoverServer = ^(MYBluetoothBlocksClient *childClient) {
        
        
        weakSelf.centralStatus.text = [NSString stringWithFormat:@"found server "] ;
        weakSelf.centralPeripheralsCount.text = [NSString stringWithFormat:@"Peripherals : %d",weakClient.childClients.count] ;
        
       
        
        
    };
    
   
    
}

-(IBAction)toggleServer:(id)sender{
    MYBluetoothBlocksServer *server = [MYBluetoothBlocksServer shared];
    
   
    if(!server.isRunning){
        //  set background restore identifier if require multi peripheral
        //[server  startPeripheral];
        [server  startPeripheralWithIdentifier:@"myPeripheral"];
        [self.peripheralRunButton setTitle:@"Stop" forState:UIControlStateNormal];
        
    }
    else{
        
        [server stopPeripheral];
         [self.peripheralRunButton setTitle:@"Start" forState:UIControlStateNormal];
        self.peripheralStatus.text = @"Not ready";
    }
}



-(IBAction)toggleClient:(id)sender{
    
    MYBluetoothBlocksClient *client = [MYBluetoothBlocksClient shared];
    
    if(!client.isRunning){
        //[client startCentral];
        //  set background restore identifier if require multi central
        [client startCentralWithIdentifier:@"myCentral"];
        [self.centralRunButton setTitle:@"Stop" forState:UIControlStateNormal];
        self.searchPeripheralButton.enabled = YES;
    }
    else{
        [client stopAll];
        [self.searchPeripheralButton setTitle:@"Search" forState:UIControlStateNormal];
        [self.centralRunButton setTitle:@"Start" forState:UIControlStateNormal];
        self.centralStatus.text = @"Not ready";
        self.searchPeripheralButton.enabled = NO;
    }
}

-(IBAction)searchPeripheral:(id)sender{
    
    MYBluetoothBlocksClient *client = [MYBluetoothBlocksClient shared];
    
    if(!client.isRunning){
        return;
    }
    if(!client.isSearhing){
        [client searchPeripheral];
        [self.searchPeripheralButton setTitle:@"Stop" forState:UIControlStateNormal];
        self.centralStatus.text = @"Search peripheral";
        
    }
    else{
        [client stopSearch];
        [self.searchPeripheralButton setTitle:@"Search" forState:UIControlStateNormal];
        self.centralStatus.text = @"Stop Search";
        
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

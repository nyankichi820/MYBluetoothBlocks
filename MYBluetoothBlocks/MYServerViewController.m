//
//  MYServerViewController.m
//  MYBluetoothBlocks
//
//  Created by masafumi yoshida on 2014/03/23.
//  Copyright (c) 2014年 masafumi yoshida. All rights reserved.
//

#import "MYServerViewController.h"
#import "MYUUID.h"
#import <CoreBluetooth/CoreBluetooth.h>
#import "MYBluetoothBlocksServer.h"
@interface MYServerViewController ()

@end

@implementation MYServerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setup];
}

-(void)setup{
    CBMutableCharacteristic * notifyCharacteristic = [[CBMutableCharacteristic alloc] initWithType:[CBUUID UUIDWithString:kCBUUIDTestNotify] properties:CBCharacteristicPropertyNotify value:nil permissions:CBAttributePermissionsReadable];
    
    
    CBMutableCharacteristic * writeCharacteristic = [[CBMutableCharacteristic alloc] initWithType:[CBUUID UUIDWithString:kCBUUIDTestWrite] properties:CBCharacteristicPropertyWrite value:nil permissions:CBAttributePermissionsWriteable];
    
    CBMutableCharacteristic * readCharacteristic = [[CBMutableCharacteristic alloc] initWithType:[CBUUID UUIDWithString:kCBUUIDTestRead] properties:CBCharacteristicPropertyRead value:nil permissions:CBAttributePermissionsReadable];
    
   
    [readCharacteristic setValue:[@"hello!" dataUsingEncoding:NSUTF8StringEncoding]];
    
    // Creates the service and adds the characteristic to it
    CBMutableService *service = [[CBMutableService alloc] initWithType:[CBUUID UUIDWithString:kCBUUIDTestService ] primary:YES];
    
    // Sets the characteristics for this service
    [service setCharacteristics:@[notifyCharacteristic,writeCharacteristic,readCharacteristic]];
    
    
    NSMutableArray *services = [ NSMutableArray arrayWithObjects:service,nil];
    
    
    MYBluetoothBlocksServer *server = [MYBluetoothBlocksServer shared];
    [server setupServer:@"CASIO GB-6900B" services:services];
    
   
    
    
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.navigationController.navigationBar.barTintColor = RGB(194,68,69);
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];

    [self registerBlocks];
}


-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self unregisterBlocks];
}



-(void)registerBlocks{
    __weak typeof(self) weakSelf = self;
    
    MYBluetoothBlocksServer *server = [MYBluetoothBlocksServer shared];
    
    __weak typeof(server) weakServer = server;
    
    
    server.didReadyServer = ^(){
        weakSelf.peripheralStatus.text = @"ready";
    };
    
    // receive data
    server.didReceiveData = ^(CBATTRequest *request,NSData *data){
        NSLog(@"receive data");
        NSString *readString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        
        NSLog(@"receive data %@",readString);
        
        self.peripheralWriteData.text = [NSString stringWithFormat:@"Write Data %@",readString];
    };
    
    
    // notification send
    server.didSubscribe = ^(MYBluetoothBlocksSubscriber *subscriber){
        NSLog(@"did subscribe");
        weakSelf.peripheralSubscribersCount.text = [NSString stringWithFormat:@"Subscribers : %d",weakServer.subscribers.count];
        
        
    };
    
    
}

-(void)unregisterBlocks{
    MYBluetoothBlocksServer *server = [MYBluetoothBlocksServer shared];
    
    
    server.didReadyServer = nil;
    
    server.didReceiveData =nil;
    
    // notification send
    server.didSubscribe =nil;
    
    
}



-(IBAction)toggleServer:(id)sender{
    MYBluetoothBlocksServer *server = [MYBluetoothBlocksServer shared];
    
    
    if(!server.isRunning){
        //  set background restore identifier if require multi peripheral
        //[server  startPeripheral];
        [server  startPeripheralWithIdentifier:@"myPeripheral"];
        [self.peripheralRunButton setTitle:@"Stop" forState:UIControlStateNormal];
        self.peripheralReadDataLabel.enabled = YES;
        self.peripheralSubscribersCount.enabled = YES;
        self.peripheralWriteData.enabled = YES;
        self.checkSubscriberButton.enabled = YES;
    }
    else{
        
        [server stopPeripheral];
        [self.peripheralRunButton setTitle:@"Start" forState:UIControlStateNormal];
        self.peripheralStatus.text = @"Not ready";
        self.peripheralReadDataLabel.enabled = NO;
        self.peripheralSubscribersCount.enabled = NO;
        self.peripheralWriteData.enabled = NO;
        self.checkSubscriberButton.enabled = NO;
    }
}


@end

//
//  MYClientViewController.m
//  MYBluetoothBlocks
//
//  Created by masafumi yoshida on 2014/03/23.
//  Copyright (c) 2014年 masafumi yoshida. All rights reserved.
//

#import "MYClientViewController.h"
#import "MYUUID.h"
#import <CoreBluetooth/CoreBluetooth.h>
#import "MYBluetoothBlocksClient.h"

@interface MYClientViewController ()

@end

@implementation MYClientViewController

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
    MYBluetoothBlocksClient *client = [MYBluetoothBlocksClient shared];
  //  [client setupRootClient:@[[CBUUID UUIDWithString:kCBUUIDTestService]]];
    
    [client setupRootClient:nil];
    
    
    
}


-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.navigationController.navigationBar.barTintColor = RGB(255,204,0);
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];

    [self registerBlocks];
}


-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self unregisterBlocks];
}


-(void)registerBlocks{
    __weak typeof(self) weakSelf = self;
    
    
    MYBluetoothBlocksClient *client = [MYBluetoothBlocksClient shared];
    
    // initialize central
    client.didReadyCentral = ^() {
        weakSelf.centralStatus.text = @"ready";
    };
    
    __weak typeof(client) weakClient = client;
    client.didDiscoverServer = ^(MYBluetoothBlocksClient *childClient) {
        
        weakSelf.centralStatus.text = [NSString stringWithFormat:@"found server "] ;
        weakSelf.centralPeripheralsCount.text = [NSString stringWithFormat:@"Peripherals : %d",weakClient.childClients.count] ;
    };
    
}

-(void)unregisterBlocks{
    
    MYBluetoothBlocksClient *client = [MYBluetoothBlocksClient shared];
    // initialize central
    client.didReadyCentral = nil;
    
    client.didDiscoverServer = nil;
}



-(IBAction)toggleClient:(id)sender{
    
    MYBluetoothBlocksClient *client = [MYBluetoothBlocksClient shared];
    
    if(!client.isRunning){
        //[client startCentral];
        //  set background restore identifier if require multi central
        [client startCentralWithIdentifier:@"myCentral"];
        [self.centralRunButton setTitle:@"Stop" forState:UIControlStateNormal];
        self.searchPeripheralButton.enabled = YES;
        self.centralPeripheralsCount.enabled = YES;
        self.checkPeripheralButton.enabled = YES;
        
    }
    else{
        [client stopAll];
        [self.searchPeripheralButton setTitle:@"Search" forState:UIControlStateNormal];
        [self.centralRunButton setTitle:@"Start" forState:UIControlStateNormal];
        self.centralStatus.text = @"Not ready";
        self.searchPeripheralButton.enabled = NO;
        self.centralPeripheralsCount.enabled = NO;
        self.checkPeripheralButton.enabled = NO;
        
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

@end

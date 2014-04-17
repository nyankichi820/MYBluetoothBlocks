//
//  MYBeaconServerViewController.m
//  MYBluetoothBlocks
//
//  Created by masafumi yoshida on 2014/04/17.
//  Copyright (c) 2014年 masafumi yoshida. All rights reserved.
//

#import "MYBeaconServerViewController.h"
#import "MYUUID.h"
#import "MYBeaconBlocksServer.h"
#import <CoreLocation/CoreLocation.h>
@interface MYBeaconServerViewController ()

@end

@implementation MYBeaconServerViewController

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
   
    
    
    MYBeaconBlocksServer *server = [MYBeaconBlocksServer shared];
    
    CLBeaconRegion * beaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:[[NSUUID alloc] initWithUUIDString:kCBUUIDTestBeacon]  identifier:@"test beacon"];
    [server setupBeacon:beaconRegion];
    
    
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.navigationController.navigationBar.barTintColor = RGB(26,188,156);
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
}


-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
   
}



-(IBAction)toggleBeaconServer:(id)sender{
    MYBeaconBlocksServer *server = [MYBeaconBlocksServer shared];
    
    if(!server.isRunning){
        [server startBeacon];
        [self.peripheralRunButton setTitle:@"Stop" forState:UIControlStateNormal];
        self.peripheralStatus.text = @"Start";
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

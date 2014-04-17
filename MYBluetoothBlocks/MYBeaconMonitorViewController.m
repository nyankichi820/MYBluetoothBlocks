//
//  MYBeaconMonitorViewController.m
//  MYBluetoothBlocks
//
//  Created by masafumi yoshida on 2014/04/17.
//  Copyright (c) 2014年 masafumi yoshida. All rights reserved.
//

#import "MYBeaconMonitorViewController.h"
#import "MYBeaconBlocksClient.h"
#import "MYUUID.h"
@interface MYBeaconMonitorViewController ()

@end

@implementation MYBeaconMonitorViewController

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
    
    MYBeaconBlocksClient *client = [MYBeaconBlocksClient shared];
    client.beacons = [[NSMutableArray alloc] init];
    
    __weak typeof(self) weakSelf = self;
    
    __weak typeof(client) weakClient = client;
    
    client.didRangeBeacons = ^(NSArray *beacons ,CLBeaconRegion *region){
        
        
        if (beacons.count > 0) {
            CLBeacon *beacon = beacons.firstObject;
            switch (beacon.proximity) {
                case CLProximityImmediate:
                    weakSelf.centralStatus.text = [NSString stringWithFormat:@"found beacon immediate rssi %d",beacon.rssi] ;
                    break;
                case CLProximityNear:
                    weakSelf.centralStatus.text = [NSString stringWithFormat:@"found beacon near rssi %d",beacon.rssi] ;
                    break;
                case CLProximityFar:
                    weakSelf.centralStatus.text = [NSString stringWithFormat:@"found beacon far rssi %d",beacon.rssi] ;
                    break;
                default:
                    weakSelf.centralStatus.text = [NSString stringWithFormat:@"found beacon unknown  rssi %d",beacon.rssi] ;
                    break;
            }
            
            weakSelf.centralPeripheralsCount.text = [NSString stringWithFormat:@"beacons : %d",beacons.count] ;
        }

    };
    
}


-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.navigationController.navigationBar.barTintColor = RGB(0,122,255);
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    
}


-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
}




-(IBAction)toggleClient:(id)sender{
    
    MYBeaconBlocksClient *client = [MYBeaconBlocksClient shared];
    
    if(!client.isRunning){
        //[client startCentral];
        //  set background restore identifier if require multi central
        [client startMonitoring:[[NSUUID alloc] initWithUUIDString:kCBUUIDTestBeacon] identifier:@"test beacon monitor"];
        [self.centralRunButton setTitle:@"Stop" forState:UIControlStateNormal];
        self.searchPeripheralButton.enabled = YES;
        self.centralPeripheralsCount.enabled = YES;
        self.checkPeripheralButton.enabled = YES;
        
    }
    else{
          [client stopMonitoring];
        [self.searchPeripheralButton setTitle:@"Search" forState:UIControlStateNormal];
        [self.centralRunButton setTitle:@"Start" forState:UIControlStateNormal];
        self.centralStatus.text = @"Not ready";
        self.searchPeripheralButton.enabled = NO;
        self.centralPeripheralsCount.enabled = NO;
        self.checkPeripheralButton.enabled = NO;
        
    }
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

//
//  MYBeaconServerViewController.h
//  MYBluetoothBlocks
//
//  Created by masafumi yoshida on 2014/04/17.
//  Copyright (c) 2014年 masafumi yoshida. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MYBeaconServerViewController : UIViewController
@property(nonatomic,strong) IBOutlet UILabel *peripheralStatus;
@property(nonatomic,strong) IBOutlet UIButton *peripheralRunButton;
@property(nonatomic,strong) IBOutlet UIButton *checkSubscriberButton;
@property(nonatomic,strong) IBOutlet UILabel *peripheralSubscribersCount;

@property(nonatomic,strong) IBOutlet UILabel *peripheralWriteData;

@property(nonatomic,strong) IBOutlet UILabel *peripheralReadDataLabel;

@end

//
//  MYViewController.h
//  MYBluetoothBlocks
//
//  Created by masafumi yoshida on 2014/03/21.
//  Copyright (c) 2014年 masafumi yoshida. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MYViewController : UIViewController
@property(nonatomic,strong) IBOutlet UILabel *peripheralStatus;
@property(nonatomic,strong) IBOutlet UIButton *peripheralRunButton;

@property(nonatomic,strong) IBOutlet UILabel *peripheralSubscribersCount;

@property(nonatomic,strong) IBOutlet UILabel *peripheralWriteData;

@property(nonatomic,strong) IBOutlet UILabel *peripheralReadDataLabel;

@property(nonatomic,strong) IBOutlet UILabel *centralStatus;
@property(nonatomic,strong) IBOutlet UIButton *centralRunButton;
@property(nonatomic,strong) IBOutlet UIButton *searchPeripheralButton;


@property(nonatomic,strong) IBOutlet UILabel *centralPeripheralsCount;



@end

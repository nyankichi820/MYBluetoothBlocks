//
//  MYChildClientViewController.h
//  MYBluetoothBlocks
//
//  Created by masafumi yoshida on 2014/03/22.
//  Copyright (c) 2014年 masafumi yoshida. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MYBluetoothBlocks.h"
@interface MYChildClientViewController : UIViewController
@property(nonatomic) int rowIndex;
@property(nonatomic,strong) MYBluetoothBlocksClient *childClient;
@property(nonatomic,strong) IBOutlet UILabel *centralRSSILabel;

@property(nonatomic,strong) IBOutlet UILabel *centralNotifyLabel;
@property(nonatomic,strong) IBOutlet UIButton *centralSubscribeButton;

@property(nonatomic,strong) IBOutlet UITextField *centralWriteDataTextField;
@property(nonatomic,strong) IBOutlet UIButton *centralWriteDataButton;

@property(nonatomic,strong) IBOutlet UILabel *centralReadDataLabel;
@property(nonatomic,strong) IBOutlet UIButton *centralReadDataButton;

@end

//
//  MYSubscriberViewController.h
//  MYBluetoothBlocks
//
//  Created by masafumi yoshida on 2014/03/22.
//  Copyright (c) 2014年 masafumi yoshida. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MYBluetoothBlocks.h"
@interface MYSubscriberViewController : UIViewController
@property(nonatomic) int rowIndex;
@property(nonatomic,strong) MYBluetoothBlocksSubscriber *subscriber;

@property(nonatomic,strong) IBOutlet UITextField *peripheralNotifyTextField;
@property(nonatomic,strong) IBOutlet UIButton *peripheralNotifyButton;


@end

//
//  MYClientViewController.h
//  MYBluetoothBlocks
//
//  Created by masafumi yoshida on 2014/03/23.
//  Copyright (c) 2014年 masafumi yoshida. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MYClientViewController : UIViewController

@property(nonatomic,strong) IBOutlet UILabel *centralStatus;
@property(nonatomic,strong) IBOutlet UIButton *centralRunButton;
@property(nonatomic,strong) IBOutlet UIButton *searchPeripheralButton;


@property(nonatomic,strong) IBOutlet UILabel *centralPeripheralsCount;

@end

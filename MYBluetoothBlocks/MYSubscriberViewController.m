//
//  MYSubscriberViewController.m
//  MYBluetoothBlocks
//
//  Created by masafumi yoshida on 2014/03/22.
//  Copyright (c) 2014年 masafumi yoshida. All rights reserved.
//

#import "MYSubscriberViewController.h"
#import "MYBluetoothBlocks.h"
@interface MYSubscriberViewController ()

@end

@implementation MYSubscriberViewController

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
    
    self.subscriber = [[MYBluetoothBlocksServer shared].subscribers objectAtIndex:self.rowIndex];
    
    
    // Do any additional setup after loading the view.
}



-(IBAction)sendNotify:(id)sender{
    NSData *writeData = [self.peripheralNotifyTextField.text dataUsingEncoding:NSUTF8StringEncoding];
    [[MYBluetoothBlocksServer shared] sendValue:writeData characteristic:self.subscriber.characteristic onSubscribedCentrals:@[self.subscriber.central]];
    
}



- (BOOL)textFieldShouldReturn:(UITextField*)textField

{
    [textField resignFirstResponder];
    
    return YES;
    
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

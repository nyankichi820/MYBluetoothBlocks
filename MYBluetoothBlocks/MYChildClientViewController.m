

//
//  MYChildClientViewController.m
//  MYBluetoothBlocks
//
//  Created by masafumi yoshida on 2014/03/22.
//  Copyright (c) 2014年 masafumi yoshida. All rights reserved.
//

#import "MYChildClientViewController.h"


@interface MYChildClientViewController ()

@end

@implementation MYChildClientViewController

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
    
     self.childClient = [[MYBluetoothBlocksClient shared].childClients objectAtIndex:self.rowIndex];
    
    __weak typeof(self) weakSelf = self;
    
    self.childClient.didUpdateNotificationStateForCharacteristic =^(CBCharacteristic *characteristic,NSError *error){
        NSString *readString = [[NSString alloc] initWithData:characteristic.value encoding:NSUTF8StringEncoding];
        
        NSLog(@"notify state change");
        if(characteristic.isNotifying){
            NSLog(@"notify start");
        }
        else{
            NSLog(@"notify end");
        }
      
    };

    
    self.childClient.didUpdateValueForCharacteristic = ^(CBCharacteristic *characteristic,NSError *error){
        NSString *readString = [[NSString alloc] initWithData:characteristic.value encoding:NSUTF8StringEncoding];
        
        NSLog(@"read data %@",readString);
        if(characteristic.properties & CBCharacteristicPropertyNotify){
            NSLog(@"notify charastaristic");
            weakSelf.centralNotifyLabel.text = readString;
        }
        
        if(characteristic.properties& CBCharacteristicPropertyRead){
            NSLog(@"read charastaristic");
            weakSelf.centralReadDataLabel.text = readString;
        }
    };
    
    self.childClient.didWriteValueForCharacteristic = ^(CBCharacteristic *characteristic,NSError *error){
        NSString *readString = [[NSString alloc] initWithData:characteristic.value encoding:NSUTF8StringEncoding];
        NSLog(@"write data %@",readString);
        
    };
    
    self.childClient.didUpdateRSSI = ^(NSError *error){
       weakSelf.centralRSSILabel.text = [NSString stringWithFormat:@"RSSI : %f", weakSelf.childClient.peripheral.RSSI.floatValue];
        
        float dist = weakSelf.childClient.peripheral.RSSI.floatValue;
        dist = dist * -1.0f - 30.0f;
        if(dist < 0.0){
            dist = 0.0;
        }
        else if( dist > 63){
            dist = 63;
        }
        dist = dist/63.0;
        
        CGRect frame = weakSelf.centralImage.frame;
        frame.origin.x  = 10.0f  + 300.0f* dist;
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.5];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        int image = 9 - floor(dist*63/7);
        weakSelf.centralImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"g%d",image]];
         weakSelf.centralImage.frame = frame;
        [UIView commitAnimations];
    };
    
   
    
    [self.childClient readRSSI];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(IBAction)subscribe:(id)sender{
    
    for(CBCharacteristic *characteristic in self.childClient.service.characteristics){
        if(characteristic.properties & CBCharacteristicPropertyNotify){
            NSLog(@"notify charastaristic %@",characteristic);
            if(!characteristic.isNotifying){
                [self.childClient setNotifyValue:YES characteristic:characteristic];
                [self.centralSubscribeButton setTitle:@"UnSubscribe" forState:UIControlStateNormal];
                
            }
            else{
                [self.childClient setNotifyValue:NO characteristic:characteristic];
                [self.centralSubscribeButton setTitle:@"Subscribe" forState:UIControlStateNormal];
            }
        }
        
        
        
    }
    
}

-(IBAction)toggleUpdateRSSI:(id)sender{
    
    
    
    if(!self.timer){
        
        dispatch_queue_t queue = dispatch_queue_create("timerQueue", DISPATCH_QUEUE_CONCURRENT);
        
        self.timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
        
        dispatch_source_set_timer(self.timer, dispatch_time(DISPATCH_TIME_NOW, 0), 0.5 * NSEC_PER_SEC, 0);
        
        dispatch_source_set_event_handler(self.timer, ^{
            [self.childClient readRSSI];
   
            
        });
        dispatch_resume(self.timer);
        
        [self.updateRSSIButton setTitle:@"Stop" forState:UIControlStateNormal];
        
        
    }
    else{
        dispatch_source_cancel(self.timer);
        self.timer = nil;
         [self.updateRSSIButton setTitle:@"Update RSSI" forState:UIControlStateNormal];
    }
}



- (BOOL)textFieldShouldReturn:(UITextField*)textField

{
    [textField resignFirstResponder];
    
    return YES;
    
}


-(IBAction)writeData:(id)sender{
    
    for(CBCharacteristic *characteristic in self.childClient.service.characteristics){
        if(characteristic.properties& CBCharacteristicPropertyWrite){
            NSLog(@"write charastaristic");
            NSData *writeData = [self.centralWriteDataTextField.text dataUsingEncoding:NSUTF8StringEncoding];
            [self.childClient writeValue:writeData characteristic:characteristic];
        }
        
    }
    
}


-(IBAction)readData:(id)sender{
    
    for(CBCharacteristic *characteristic in self.childClient.service.characteristics){
        
        if(characteristic.properties& CBCharacteristicPropertyRead){
            NSLog(@"read charastaristic");
            [self.childClient readValue:characteristic];
        }
        
    }
    
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

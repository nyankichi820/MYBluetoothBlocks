

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

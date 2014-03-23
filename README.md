MYBluetoothBlocks
=================

Core Bluetooth wrapper with block and simple interface wrapper

- wrapper CoreBluetooth delegate 
- Addon API Class Peripheral and Central

# Install

instal from cocoapods

  pod 'MYBluetoothBlocks', '~> 0.1.0'

# Usage



## Server(Peripheral) 


	CBMutableCharacteristic * notifyCharacteristic = [[CBMutableCharacteristic alloc] initWithType:[CBUUID UUIDWithString:kCBUUIDTestNotify] properties:CBCharacteristicPropertyNotify value:nil permissions:CBAttributePermissionsReadable];
    
    
    CBMutableCharacteristic * writeCharacteristic = [[CBMutableCharacteristic alloc] initWithType:[CBUUID UUIDWithString:kCBUUIDTestWrite] properties:CBCharacteristicPropertyWrite value:nil permissions:CBAttributePermissionsWriteable];
    
    CBMutableCharacteristic * readCharacteristic = [[CBMutableCharacteristic alloc] initWithType:[CBUUID UUIDWithString:kCBUUIDTestRead] properties:CBCharacteristicPropertyRead value:nil permissions:CBAttributePermissionsReadable];
    
    [readCharacteristic setValue:[@"hello" dataUsingEncoding:NSUTF8StringEncoding]];
    
    // Creates the service and adds the characteristic to it
    CBMutableService *service = [[CBMutableService alloc] initWithType:[CBUUID UUIDWithString:kCBUUIDTestService ] primary:YES];
    
    // Sets the characteristics for this service
    [service setCharacteristics:@[notifyCharacteristic,writeCharacteristic,readCharacteristic]];
    
    
    NSMutableArray *services = [ NSMutableArray arrayWithObjects:service,nil];
    
    
    MYBluetoothBlocksServer *server = [MYBluetoothBlocksServer shared];
    
    
    
     __weak typeof(server) weakServer = server;
    
    
    server.didReadyServer = ^(){
        NSLog(@"ready");
    };
    
    // receive data
    server.didReceiveData = ^(CBATTRequest *request,NSData *data){
        NSLog(@"receive data");
        NSString *readString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        
        NSLog(@"receive data %@",readString);
        
    };
    
    
    // notification send
    server.didSubscribe = ^(MYBluetoothBlocksSubscriber *subscriber){
        NSLog(@"did subscribe");
        NSLog(@"Subscribers : %d",weakServer.subscribers.count);
        
        
    };


    [server setupServer:@"my bt servre" services:services];


## Client(Central)



    MYBluetoothBlocksClient *client = [MYBluetoothBlocksClient shared];
      
    __weak typeof(client) weakClient = client;
    
    // initialize central
    client.didReadyCentral = ^() {
        weakSelf.centralStatus.text = @"ready";
    };
      
    client.didDiscoverServer = ^(MYBluetoothBlocksClient *childClient) {
          
         NSLog(@"Peripherals : %d",weakClient.childClients.count);
    
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
            
            if(characteristic.properties & CBCharacteristicPropertyNotify){
                NSLog(@"notify charastaristic %@",readString);
            }
            
            if(characteristic.properties& CBCharacteristicPropertyRead){
                NSLog(@"read charastaristic %@",readString);
            }
        };
        
        childClient.didWriteValueForCharacteristic = ^(CBCharacteristic *characteristic,NSError *error){
            NSString *readString = [[NSString alloc] initWithData:characteristic.value encoding:NSUTF8StringEncoding];
            NSLog(@"write data %@",readString);
            
        };
        
        self.childClient.didUpdateRSSI = ^(NSError *error){
           NSLog(@"RSSI : %f", weakSelf.childClient.peripheral.RSSI.floatValue);
            
        };
    
    
    };
    
     [client setupRootClient:@[[CBUUID UUIDWithString:kCBUUIDTestService]]];
    
    
    
    

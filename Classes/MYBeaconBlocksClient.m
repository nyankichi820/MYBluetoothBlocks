//
//  MYBeaconBlocksClient.m
//  MYBluetoothBlocks
//
//  Created by masafumi yoshida on 2014/04/17.
//  Copyright (c) 2014年 masafumi yoshida. All rights reserved.
//

#import "MYBeaconBlocksClient.h"

@implementation MYBeaconBlocksClient

static MYBeaconBlocksClient *instance = 0;

+ (MYBeaconBlocksClient *) shared{
    if( instance == 0 ) {
        instance = [ [ MYBeaconBlocksClient alloc ] init ];
    }
    
    return (instance);
}

-(id) init{
    self = [ super init];
    if(self){
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;

        self.isReady = FALSE;
        self.isRunning = FALSE;
    }
    return self;
}

-(void) startMonitoring:(NSUUID *)proximityUUID identifier:(NSString *)identifier{
    self.region = [[CLBeaconRegion alloc] initWithProximityUUID:proximityUUID
                                                           identifier:identifier];
    [self.locationManager startMonitoringForRegion:self.region];
    self.isRunning = YES;
    
}

-(void) stopMonitoring{
    [self.locationManager stopMonitoringForRegion:self.region];
    self.isRunning = NO;
}


- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    NSLog(@"%s", __func__);
    if(self.didUpdateLocations){
        self.didUpdateLocations(locations);
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"%s", __func__);
    if(self.didFailWithError){
        self.didFailWithError(error);
    }
}

- (void)locationManager:(CLLocationManager *)manager didFinishDeferredUpdatesWithError:(NSError *)error
{
    NSLog(@"%s", __func__);
    if(self.didFinishDeferredUpdatesWithError){
        self.didFinishDeferredUpdatesWithError(error);
    }
}

- (void)locationManagerDidPauseLocationUpdates:(CLLocationManager *)manager
{
    NSLog(@"%s", __func__);
    if(self.didPauseLocationUpdates){
        self.didPauseLocationUpdates();
    }
}

- (void)locationManagerDidResumeLocationUpdates:(CLLocationManager *)manager
{
    NSLog(@"%s", __func__);
    if(self.didResumeLocationUpdates){
        self.didResumeLocationUpdates();
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading
{
    NSLog(@"%s", __func__);
    if(self.didUpdateHeading){
        self.didUpdateHeading(newHeading);
    }
}

- (BOOL)locationManagerShouldDisplayHeadingCalibration:(CLLocationManager *)manager
{
    NSLog(@"%s", __func__);
    if(self.shouldDisplayHeadingCalibration){
        return self.shouldDisplayHeadingCalibration();
    }
    return YES;
}

- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region
{
    NSLog(@"%s", __func__);
    
    if([region isKindOfClass:[CLBeaconRegion class]]){
        if(self.didEnterRegion){
            self.didEnterRegion(region);
        }
    }
}

- (void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region
{
    NSLog(@"%s", __func__);
    
    if([region isKindOfClass:[CLBeaconRegion class]]){
        if(self.didExitRegion){
            self.didExitRegion(region);
        }
    }
}

- (void)locationManager:(CLLocationManager *)manager didDetermineState:(CLRegionState)state forRegion:(CLRegion *)region
{
    NSLog(@"%s", __func__);
    
    if(self.didDetermineState){
        self.didDetermineState(state,region);
    }
    
    switch (state) {
        case CLRegionStateUnknown:
            break;
        case CLRegionStateInside:
            [self.locationManager startRangingBeaconsInRegion:(CLBeaconRegion *)region];
            break;
        case CLRegionStateOutside:
            break;
        default:
            break;
    }
    
    
}

- (void)locationManager:(CLLocationManager *)manager monitoringDidFailForRegion:(CLRegion *)region withError:(NSError *)error
{
    NSLog(@"%s", __func__);
    if(self.monitoringDidFailForRegion){
        self.monitoringDidFailForRegion(region,error);
    }
    
}

- (void)locationManager:(CLLocationManager *)manager didStartMonitoringForRegion:(CLRegion *)region
{
    NSLog(@"%s", __func__);
    
    [self.locationManager requestStateForRegion:region];
    
    if(self.didStartMonitoringForRegion){
        self.didStartMonitoringForRegion(region);
    }
}

- (void)locationManager:(CLLocationManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region
{
    NSLog(@"%s", __func__);
    
    if(self.didRangeBeacons){
        self.didRangeBeacons(beacons,region);
    }
    
}

- (void)locationManager:(CLLocationManager *)manager rangingBeaconsDidFailForRegion:(CLBeaconRegion *)region withError:(NSError *)error
{
    NSLog(@"%s", __func__);
    if(self.rangingBeaconsDidFailForRegion){
        self.rangingBeaconsDidFailForRegion(region,error);
    }
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    NSLog(@"%s", __func__);
    if(self.didChangeAuthorizationStatus){
        self.didChangeAuthorizationStatus(status);
    }
}
@end

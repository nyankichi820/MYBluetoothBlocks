//
//  MYBeaconBlocksClient.h
//  MYBluetoothBlocks
//
//  Created by masafumi yoshida on 2014/04/17.
//  Copyright (c) 2014年 masafumi yoshida. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
typedef void (^MYBeaconBlocksClientDidUpdateLocations)(NSArray *locations);
typedef void (^MYBeaconBlocksClientDidFailWithError)(NSError *error);
typedef void (^MYBeaconBlocksClientDidFinishDeferredUpdatesWithError)(NSError *error);
typedef void (^MYBeaconBlocksClientDidPauseLocationUpdates)();
typedef void (^MYBeaconBlocksClientDidResumeLocationUpdates)();
typedef void (^MYBeaconBlocksClientDidUpdateHeading)(CLHeading *newHeading);
typedef BOOL (^MYBeaconBlocksClientShouldDisplayHeadingCalibration)();
typedef void (^MYBeaconBlocksClientDidEnterRegion)(CLRegion *region);
typedef void (^MYBeaconBlocksClientDidExitRegion)(CLRegion *region);
typedef void (^MYBeaconBlocksClientDidDetermineState)(CLRegionState state ,CLRegion *region);
typedef void (^MYBeaconBlocksClientMonitoringDidFailForRegion)(CLRegion *region ,NSError *error);
typedef void (^MYBeaconBlocksClientDidStartMonitoringForRegion)(CLRegion *region);
typedef void (^MYBeaconBlocksClientDidRangeBeacons)(NSArray *beacons ,CLBeaconRegion *region);
typedef void (^MYBeaconBlocksClientRangingBeaconsDidFailForRegion)(CLBeaconRegion *region ,NSError *error);
typedef void (^MYBeaconBlocksClientDidChangeAuthorizationStatus)(CLAuthorizationStatus status);


@interface MYBeaconBlocksClient : NSObject

@property(readwrite, copy) MYBeaconBlocksClientDidUpdateLocations didUpdateLocations;
@property(readwrite, copy) MYBeaconBlocksClientDidFailWithError didFailWithError;
@property(readwrite, copy) MYBeaconBlocksClientDidFinishDeferredUpdatesWithError didFinishDeferredUpdatesWithError;
@property(readwrite, copy) MYBeaconBlocksClientDidPauseLocationUpdates didPauseLocationUpdates;
@property(readwrite, copy) MYBeaconBlocksClientDidResumeLocationUpdates didResumeLocationUpdates;
@property(readwrite, copy) MYBeaconBlocksClientDidUpdateHeading didUpdateHeading;
@property(readwrite, copy) MYBeaconBlocksClientShouldDisplayHeadingCalibration shouldDisplayHeadingCalibration;
@property(readwrite, copy) MYBeaconBlocksClientDidEnterRegion didEnterRegion;
@property(readwrite, copy) MYBeaconBlocksClientDidExitRegion didExitRegion;
@property(readwrite, copy) MYBeaconBlocksClientDidDetermineState didDetermineState;
@property(readwrite, copy) MYBeaconBlocksClientMonitoringDidFailForRegion monitoringDidFailForRegion;
@property(readwrite, copy) MYBeaconBlocksClientDidStartMonitoringForRegion didStartMonitoringForRegion;
@property(readwrite, copy) MYBeaconBlocksClientDidRangeBeacons didRangeBeacons;
@property(readwrite, copy) MYBeaconBlocksClientRangingBeaconsDidFailForRegion rangingBeaconsDidFailForRegion;
@property(readwrite, copy) MYBeaconBlocksClientDidChangeAuthorizationStatus didChangeAuthorizationStatus;

@property (nonatomic,strong)  CLLocationManager *locationManager;
@property (nonatomic,strong)  CLRegion *region;
@property (nonatomic) BOOL isRunning;
@property (nonatomic) BOOL isReady;
@property (nonatomic) BOOL isSearhing;
@property (nonatomic,retain) NSMutableArray *beacons;

+ (MYBeaconBlocksClient *) shared;
-(void) stopMonitoring;
-(void) startMonitoring:(NSUUID *)proximityUUID identifier:(NSString *)identifier;
@end

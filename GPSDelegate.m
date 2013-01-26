//
//  GPSDelegate.m
//  BladeGuardTracker
//
//  Created by Jakob Ketterl on 08.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GPSDelegate.h"

@implementation GPSDelegate

@synthesize locationManager, socket;

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    BGTLogCommand* command = [[BGTLogCommand alloc] initWithLocation:newLocation];
    [socket sendCommand:command];
}
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"failure: %@", error);
}
- (void)startUpdates {
    socket = [BGTSocket getSharedInstanceWithStake:self];
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    [locationManager startUpdatingLocation];
}
- (void) endUpdates {
    BGTQuitCommand* quit = [[BGTQuitCommand alloc] initWithDefaults];
    [socket sendCommand:quit];
    [socket removeStake:self];
    [locationManager stopUpdatingLocation];
    locationManager.delegate = nil;
    socket = nil;
}
@end

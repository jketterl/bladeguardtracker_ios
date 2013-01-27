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

- (id) init {
    self = [super init];
    if (self) {
        events = [NSMutableArray arrayWithCapacity:5];
    }
    return self;
}

+ (GPSDelegate *) getSharedInstance {
    static dispatch_once_t pred;
    static GPSDelegate* shared = nil;
    dispatch_once(&pred, ^{
        shared = [[GPSDelegate alloc] init];
    });
    return shared;
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    if (newLocation.horizontalAccuracy > 50) return;
    for (BGTEvent* event in events) {
        BGTLogCommand* command = [[BGTLogCommand alloc] initWithLocation:newLocation andEvent:event];
        [socket sendCommand:command];
    }
}
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"failure: %@", error);
}

- (void) addEvent:(BGTEvent *)event {
    if ([self hasEvent:event]) return;
    [events addObject:event];
    [self startUpdates];
}

- (void) removeEvent:(BGTEvent *)event {
    if (![self hasEvent:event]) return;
    [events removeObject:event];
    BGTQuitCommand* quit = [[BGTQuitCommand alloc] initWithEvent:event];
    [socket sendCommand:quit];
    if ([events count] == 0) [self endUpdates];
}

- (bool) hasEvent:(BGTEvent *)event {
    return [events containsObject:event];
}

- (void)startUpdates {
    if (running) return;
    running = true;
    socket = [BGTSocket getSharedInstanceWithStake:self];
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    [locationManager startUpdatingLocation];
}
- (void) endUpdates {
    if (!running) return;
    running = false;
    [socket removeStake:self];
    [locationManager stopUpdatingLocation];
    locationManager.delegate = nil;
    socket = nil;
}

@end

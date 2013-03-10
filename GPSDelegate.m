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
        updatesBlocked = false;
        gpsUp = false;
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
    [self sendLocation:newLocation];
}

- (void) sendLocation: (CLLocation*) location {
    if (location.horizontalAccuracy > 50) {
        //NSLog(@"accurracy is to low");
        [self sendGPSUnavailable];
        return;
    }
    
    if (lastLocation != nil && [location distanceFromLocation:lastLocation] == 0) return;
    
    if (updatesBlocked) {
        queuedLocation = location;
        return;
    }
    
    //NSLog(@"sending log command");
    for (BGTEvent* event in events) {
        BGTLogCommand* command = [[BGTLogCommand alloc] initWithLocation:location andEvent:event];
        
        NSMethodSignature* sig = [self methodSignatureForSelector:@selector(onLogResult:forEvent:)];
        NSInvocation* callback = [NSInvocation invocationWithMethodSignature:sig];
        [callback setTarget:self];
        [callback setSelector:@selector(onLogResult:forEvent:)];
        [callback setArgument:&command atIndex:2];
        BGTEvent* foo = event;
        [callback setArgument:&foo atIndex:3];
        
        [command addCallback:callback];
        [socket sendCommand:command];
    }
    
    gpsUp = true;
    updatesBlocked = true;
    [self resetFrequencyLimiter];
    [self resetLocationTimeout];
    lastLocation = location;
}

- (void) onLogResult: (BGTLogCommand*) command forEvent:(BGTEvent*) event {
    NSDictionary* result = [command getResult];
    if ([[result valueForKey:@"locked"] intValue] == 1 && [result valueForKey:@"distanceToEnd"] != NULL) {
        [event setDistanceToEnd:[[result valueForKey:@"distanceToEnd"] floatValue]];
    } else {
        [event setDistanceToEnd:-1];
    }
}

- (void) sendGPSUnavailable {
    if (!gpsUp) return;
    //NSLog(@"sending gpsunavailable command");
    for (BGTEvent* event in events) {
        BGTGPSUnavailableCommand* command = [[BGTGPSUnavailableCommand alloc] initWithEvent:event];
        [socket sendCommand:command];
        [event setDistanceToEnd:-1];
    }
    gpsUp = false;
}

- (void) resetFrequencyLimiter {
    if (updateFrequencyLimiter != nil) [updateFrequencyLimiter invalidate];
    updateFrequencyLimiter = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(unblockUpdates) userInfo:nil repeats:NO];
}

- (void) resetLocationTimeout {
    if (locationTimer != nil) [locationTimer invalidate];
    locationTimer = [NSTimer scheduledTimerWithTimeInterval:60 target:self selector:@selector(sendGPSUnavailable) userInfo:nil repeats:NO];
}

- (void) unblockUpdates {
    updatesBlocked = false;
    if (queuedLocation == nil) return;
    [self sendLocation:queuedLocation];
    queuedLocation = nil;
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
    locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
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
    lastLocation = nil;
}

- (BOOL) isActive {
    return running;
}

@end

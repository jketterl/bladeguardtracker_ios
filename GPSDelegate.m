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
    NSLog(@"location update: %@", newLocation);
    NSMutableDictionary* json = [NSMutableDictionary dictionaryWithCapacity:2];
    [json setValue:@"log" forKey:@"command"];
    NSMutableDictionary* data = [NSMutableDictionary dictionaryWithCapacity:2];
    [data setValue:[NSNumber numberWithFloat:newLocation.coordinate.latitude] forKey:@"lat"];
    [data setValue:[NSNumber numberWithFloat:newLocation.coordinate.longitude] forKey:@"lon"];
    [json setValue:data forKey:@"data"];
    [socket send:[json JSONRepresentation]];
    //NSLog(@"json string: %@", [json JSONRepresentation]);
}
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"failure: %@", error);
}
- (void)startUpdates {
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    [locationManager startUpdatingLocation];
}
- (void)setSocket:(SRWebSocket *)newSocket {
    socket = newSocket;
}
@end

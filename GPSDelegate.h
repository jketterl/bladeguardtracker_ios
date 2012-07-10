//
//  GPSDelegate.h
//  BladeGuardTracker
//
//  Created by Jakob Ketterl on 08.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "WebSocketDelegate.h"
#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface GPSDelegate : NSObject <CLLocationManagerDelegate>
@property (nonatomic, retain) CLLocationManager *locationManager;
@property (strong, nonatomic) WebSocketDelegate* socket;
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation;
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error;
- (void)startUpdates;
- (void)endUpdates;
- (void)setSocket:(WebSocketDelegate *) newSocket;
@end

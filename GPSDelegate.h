//
//  GPSDelegate.h
//  BladeGuardTracker
//
//  Created by Jakob Ketterl on 08.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BGTSocket.h"
#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "BGTLogCommand.h"
#import "BGTQuitCommand.h"
#import "BGTEvent.h"
#import "BGTGPSUnavailableCommand.h"

@interface GPSDelegate : NSObject <CLLocationManagerDelegate>{
  @private
    NSMutableArray* events;
    bool running;
    CLLocation* lastLocation;
    CLLocation* queuedLocation;
    NSTimer* locationTimer;
    NSTimer* updateFrequencyLimiter;
    BOOL updatesBlocked;
    BOOL gpsUp;
}
@property (nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) BGTSocket* socket;
- (id) init;
+ (GPSDelegate *) getSharedInstance;
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation;
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error;

- (void) addEvent: (BGTEvent*) event;
- (void) removeEvent: (BGTEvent*) event;
- (bool) hasEvent: (BGTEvent*) event;
- (BOOL) isActive;
@end

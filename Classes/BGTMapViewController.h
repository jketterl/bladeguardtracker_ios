//
//  BGTMapViewController.h
//  BladeGuardTracker
//
//  Created by Jakob Ketterl on 15.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MKMapView.h>
#import "BGTSocket.h"
#import "BGTSocketEventListener.h"
#import "BGTTeam.h"
#import "BGTUser.h"
#import "BGTUserMarker.h"
#import "BGTEvent.h"
#import "BGTEventSubscriber.h"
#import "GPSDelegate.h"

@interface BGTMapViewController : UIViewController <BGTSocketEventListener, MKMapViewDelegate, BGTEventSubscriber> {
    IBOutlet UIActivityIndicatorView* activity;
    @private NSMutableDictionary* userMarkers;
    @private MKPolyline* route;
    @private MKPolyline* track;
    @private int from, to;
    @private BGTEvent* event;
    
    @private NSNumber* speed;
    @private NSNumber* distanceToEnd;
}
@property (nonatomic) IBOutlet MKMapView* mapView;
@property (nonatomic) BGTSocket* socket;
@property (nonatomic) IBOutlet UILabel* trackLengthView;
@property (nonatomic) IBOutlet UILabel* speedView;
@property (nonatomic) IBOutlet UILabel* cycleTimeView;
@property (nonatomic) IBOutlet UILabel* timeToEndView;
@property (nonatomic) IBOutlet UILabel* trackLengthLabel;
@property (nonatomic) IBOutlet UILabel* speedLabel;
@property (nonatomic) IBOutlet UILabel* cycleTimeLabel;
@property (nonatomic) IBOutlet UILabel* timeToEndLabel;

- (void) setEvent: (BGTEvent*) event;

@end

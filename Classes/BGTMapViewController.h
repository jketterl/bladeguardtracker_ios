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

@interface BGTMapViewController : UIViewController <BGTSocketEventListener, MKMapViewDelegate> {
    @private NSMutableDictionary* userMarkers;
    @private MKPolyline* route;
    @private MKPolyline* track;
    @private int from, to;
    @private BGTEvent* event;
}
@property (nonatomic) IBOutlet MKMapView* mapView;
@property (nonatomic) BGTSocket* socket;
@property (nonatomic) IBOutlet UILabel* trackLengthView;
@property (nonatomic) IBOutlet UILabel* speedView;
@property (nonatomic) IBOutlet UILabel* cycleTimeView;
@property (nonatomic) IBOutlet UILabel* trackLengthLabel;
@property (nonatomic) IBOutlet UILabel* speedLabel;
@property (nonatomic) IBOutlet UILabel* cycleTimeLabel;

- (void) setEvent: (BGTEvent*) event;

@end

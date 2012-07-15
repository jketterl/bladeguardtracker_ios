//
//  BGTMapViewController.h
//  BladeGuardTracker
//
//  Created by Jakob Ketterl on 15.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MKMapView.h>
#import "WebSocketDelegate.h"

@interface BGTMapViewController : UIViewController
@property (nonatomic, retain) IBOutlet MKMapView* mapView;
@property (nonatomic, retain) WebSocketDelegate* socket;
@end

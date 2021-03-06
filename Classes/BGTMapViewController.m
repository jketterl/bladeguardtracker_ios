//
//  BGTMapViewController.m
//  BladeGuardTracker
//
//  Created by Jakob Ketterl on 15.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BGTMapViewController.h"

@interface BGTMapViewController ()

@end

@implementation BGTMapViewController

@synthesize mapView, socket, speedView, trackLengthView, cycleTimeView, trackLengthLabel, cycleTimeLabel, speedLabel, timeToEndView, timeToEndLabel;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    userMarkers = [[NSMutableDictionary alloc] initWithCapacity:15];
    socket = [BGTSocket getSharedInstanceWithStake:self];
    if (socket.status != BGTSocketConnected) [activity startAnimating];
    [socket addListener:self];
    [event addSubscriber:self forCategories:[NSArray arrayWithObjects:@"map", @"movements", @"quit", @"stats", @"distanceToEnd", nil]];
    // Localization
    self.title = [event getMapName];
    self.trackLengthLabel.text = NSLocalizedString(@"Track length", nil);
    self.speedLabel.text = NSLocalizedString(@"Speed", nil);
    self.cycleTimeLabel.text = NSLocalizedString(@"Cycle time", nil);
    self.timeToEndLabel.text = NSLocalizedString(@"Time to end", nil);
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // center the map somewhere around the Theresienhöhe, the default starting location
    CLLocationCoordinate2D coord = {.latitude = 48.132501, .longitude = 11.543460};
    MKCoordinateSpan span = {.latitudeDelta = .02, .longitudeDelta = .02};
    MKCoordinateRegion region = {coord, span};
    [mapView setRegion:region];
    
    mapView.showsUserLocation = [[GPSDelegate getSharedInstance] isActive];
}

- (void)viewDidDisappear:(BOOL)animated {
    [event removeSubscriber:self];
    [socket removeListener:self];
    [socket removeStake:self];
    socket = nil;
    [super viewDidDisappear:animated];
}

- (void)viewDidUnload{
    [super viewDidUnload];
    if (route != nil) {
        route = nil;
    }
    if (track != nil) {
        track = nil;
    }
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

- (void) receiveUpdate: (NSDictionary*) data {
    // nothing happening here. we receive our updates through the event
}

- (void) receiveStatus:(int)status {
    if (status == BGTSocketDisconnected) {
        if (route != nil) {
            [self.mapView removeOverlay:route];
            route = nil;
        }
        if (track != nil) {
            [self.mapView removeOverlay:track];
            track = nil;
        }
        for (MKPointAnnotation* marker in [userMarkers allValues]) {
            [self.mapView removeAnnotation:marker];
        }
        [userMarkers removeAllObjects];
        [trackLengthView setText:@"n/a"];
        [speedView setText:@"n/a"];
        [cycleTimeView setText:@"n/a"];
    }
    if (status != BGTSocketConnected) {
        [activity startAnimating];
    } else {
        [activity stopAnimating];
    }
}

- (void) processStats: (NSDictionary*) stats {
    NSNumber* trackLength = [stats valueForKey:@"bladeNightLength"];
    if (trackLength != NULL) {
        NSNumberFormatter* format = [[NSNumberFormatter alloc] init];
        [format setFormatterBehavior:NSNumberFormatterBehavior10_4];
        format.numberStyle = NSNumberFormatterDecimalStyle;
        [format setMaximumFractionDigits:1];
        [self.trackLengthView setText:[[format stringFromNumber:trackLength] stringByAppendingString:@" km"]];
    } else {
        [self.trackLengthView setText:@"n/a"];
    }
    
    speed = [stats valueForKey:@"bladeNightSpeed"];
    if (speed != NULL) {
        NSNumberFormatter* format = [[NSNumberFormatter alloc] init];
        [format setFormatterBehavior:NSNumberFormatterBehavior10_4];
        format.numberStyle = NSNumberFormatterDecimalStyle;
        [format setMaximumFractionDigits:1];
        [self.speedView setText:[[format stringFromNumber:[NSNumber numberWithFloat:[speed floatValue] * 3.6]] stringByAppendingString:@" km/h"]];
    } else {
        [self.speedView setText:@"n/a"];
    }
    
    if (speed != NULL && trackLength != NULL) {
        float cycleTime = ([trackLength floatValue] * 1000 / [speed floatValue]) / 60;
        NSNumberFormatter* format = [[NSNumberFormatter alloc] init];
        [format setFormatterBehavior:NSNumberFormatterBehavior10_4];
        format.numberStyle = NSNumberFormatterDecimalStyle;
        [format setMaximumFractionDigits:0];
        [self.cycleTimeView setText:[[format stringFromNumber:[NSNumber numberWithFloat:cycleTime]] stringByAppendingString:@" min"]];
    } else {
        [self.cycleTimeView setText:@"n/a"];
    }
    [self updateTimeToEnd];

    if (track != nil) {
        [self.mapView removeOverlay:track];
        track = nil;
    }
    
    NSArray* between = [stats objectForKey:@"between"];
    if (between == nil) {
        from = 0; to = 0;
        return;
    }
    from = [[between objectAtIndex:0] intValue];
    to = [[between objectAtIndex:1] intValue];
    
    track = [self generateTrack];
    if (track != nil) [self.mapView addOverlay:track];
    
    // this is a little trick to keep the route overlay *above* the track overlay.
    // this app is supposed to have a consistent look across platforms, and this is part of it.
    if (route == nil) return;
    [self.mapView addOverlay:route];
}

- (MKPolyline*) generateTrack {
    if (from == 0 && to == 0) return nil;
    if (route == nil) return nil;
    if (to >= route.pointCount) return nil;
    
    MKMapPoint coordinates[route.pointCount];
    int i = from, k = 0;
    while (i != to) {
        coordinates[k++] = route.points[i];
        i++;
        if (i >= route.pointCount) i = 0;
    }
    return [MKPolyline polylineWithPoints:coordinates count:k];
}

- (void) processQuit: (NSDictionary*) quit {
    NSDictionary* user = [quit objectForKey:@"user"];
    NSNumber* userId = [user objectForKey:@"id"];
    MKPointAnnotation* marker = [userMarkers objectForKey:userId];
    if (marker == nil) return;
    [self.mapView removeAnnotation:marker];
    [userMarkers removeObjectForKey:userId];
}

- (void) processMovements: (NSDictionary*) movement {
    NSDictionary* user = [movement objectForKey:@"user"];
    NSNumber* userId = [user objectForKey:@"id"];
    BGTUser* userObj = [BGTUser userWithId:[userId intValue]];
    if (userObj == NULL) {
        userObj = [[BGTUser alloc] initWithData:user];
    }
    
    NSDictionary* location = [movement objectForKey:@"location"];
    BGTUserMarker* marker = [userMarkers objectForKey:userId];
    if (marker == nil) {
        marker = [[BGTUserMarker alloc] initWithUser:userObj];
        [self.mapView addAnnotation:marker];
        [userMarkers setObject:marker forKey:userId];
    }
    marker.coordinate = CLLocationCoordinate2DMake([[location objectForKey:@"lat"] floatValue], [[location objectForKey:@"lon"] floatValue]);
}

- (void) processMap: (NSDictionary*) map {
    NSArray* points = [map objectForKey:@"points"];
    int count = [points count];
    CLLocationCoordinate2D coordinates[count];
    
    for (int i = 0; i < count; i++) {
        NSDictionary* point = [points objectAtIndex:i];
        double lat = [[point valueForKey:@"lat"] floatValue];
        double lon = [[point valueForKey:@"lon"] floatValue];
        coordinates[i] = CLLocationCoordinate2DMake(lat, lon);
    }
    if (route != nil) {
        [self.mapView removeOverlay:route];
    }
    if (track != nil) {
        [self.mapView removeOverlay:track];
        track = nil;
    }
    route = [MKPolyline polylineWithCoordinates:coordinates count:count];
    track = [self generateTrack];
    if (track != nil) {
        [self.mapView addOverlay:track];
    }
    [self.mapView addOverlay:route];
    [self.mapView setVisibleMapRect:route.boundingMapRect];
}

- (void) processDistancetoend: (NSDictionary*) data {
    distanceToEnd = [data valueForKey:@"distanceToEnd"];
    [self updateTimeToEnd];
}

- (void) updateTimeToEnd {
    float distance = [distanceToEnd floatValue];
    if (speed != NULL && distanceToEnd != NULL && distance >= 0) {
        float cycleTime = (distance * 1000 / [speed floatValue]) / 60;
        NSNumberFormatter* format = [[NSNumberFormatter alloc] init];
        [format setFormatterBehavior:NSNumberFormatterBehavior10_4];
        format.numberStyle = NSNumberFormatterDecimalStyle;
        [format setMaximumFractionDigits:0];
        timeToEndView.text = [[format stringFromNumber:[NSNumber numberWithFloat:cycleTime]] stringByAppendingString:@" min"];
    } else {
        timeToEndView.text = @"n/a";
    }
}

- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id <MKOverlay>)overlay {
    if (overlay == route) {
        MKPolylineView *polylineView = [[MKPolylineView alloc] initWithPolyline:overlay];
        polylineView.strokeColor = [UIColor blueColor];
        polylineView.lineWidth = 2.0 * [UIScreen mainScreen].scale;
        polylineView.alpha = .5;
    
        return polylineView;
    }
    
    if (overlay == track) {
        MKPolylineView *polylineView = [[MKPolylineView alloc] initWithPolyline:overlay];
        polylineView.strokeColor = [UIColor colorWithRed:1 green:.75 blue:0 alpha:1];
        polylineView.lineWidth = 6.0 * [UIScreen mainScreen].scale;
        polylineView.alpha = 1;
        
        return polylineView;
    }
    return NULL;
}

- (MKAnnotationView *) mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    if ([annotation class] != [BGTUserMarker class]) return nil;
    BGTUserMarker* marker = (BGTUserMarker*) annotation;
    
    MKAnnotationView *annView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"currentloc"];
    annView.canShowCallout = YES;

    annView.image = [[[marker getUser] getTeam] getImage];
    return annView;
}

- (void) setEvent:(BGTEvent *) newEvent {
    event = newEvent;
}

- (void) receiveMessage:(NSString *)type withData:(NSDictionary *)data fromEvent:(BGTEvent *)event {
    NSMutableString* method = [[NSMutableString alloc] init];
    [method appendString:@"process"];
    [method appendString:[type capitalizedString]];
    [method appendString:@":"];
    
    SEL s = NSSelectorFromString(method);
    if (! [self respondsToSelector:s]) {
        NSLog(@"Don't know how to handle update of type \"%@\"", type);
        return;
    }
    NSMethodSignature* sig = [self methodSignatureForSelector:s];
    NSInvocation* inv = [NSInvocation invocationWithMethodSignature:sig];
    [inv setTarget:self];
    [inv setSelector:s];
    [inv setArgument:&data atIndex:2];
    [inv invoke];
}

@end

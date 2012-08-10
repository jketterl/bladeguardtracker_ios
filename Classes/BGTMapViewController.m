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

@synthesize mapView, socket, speedView, trackLengthView, cycleTimeView, trackLengthLabel, cycleTimeLabel, speedLabel;

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
    [socket addListener:self];
    [socket subscribeCategoryArray:[NSArray arrayWithObjects:@"map", @"movements", @"quit", @"stats", nil]];
    // Localization
    self.title = NSLocalizedString(@"Map View", nil);
    self.trackLengthLabel.text = NSLocalizedString(@"Track length", nil);
    self.speedLabel.text = NSLocalizedString(@"Speed", nil);
    self.cycleTimeLabel.text = NSLocalizedString(@"Cycle time", nil);
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // center the map somewhere around the Theresienhöhe, the default starting location
    CLLocationCoordinate2D coord = {.latitude = 48.132501, .longitude = 11.543460};
    MKCoordinateSpan span = {.latitudeDelta = .02, .longitudeDelta = .02};
    MKCoordinateRegion region = {coord, span};
    [mapView setRegion:region];
}

- (void)viewDidDisappear:(BOOL)animated {
    [socket unsubscribeCategoryArray:[NSArray arrayWithObjects:@"map", @"movements", @"quit", @"stats", nil]];
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
    [self processMap:[data valueForKey:@"map"]];
    [self processMovements:[data valueForKey:@"movements"]];
    [self processQuits:[data valueForKey:@"quit"]];
    [self processStats:[data valueForKey:@"stats"]];
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
}

- (void) processStats: (NSArray*) statsArray {
    if (statsArray == nil) return;
    NSDictionary* stats = [statsArray objectAtIndex:0];

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
    
    NSNumber* speed = [stats objectForKey:@"bladeNightSpeed"];
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
    
    if (from == 0 && to == 0) return;
    if (route == nil) return;
    if (to >= route.pointCount) return;
    
    MKMapPoint coordinates[route.pointCount];
    int i = from, k = 0;
    while (i != to) {
        coordinates[k++] = route.points[i];
        i++;
        if (i >= route.pointCount) i = 0;
    }
    
    track = [MKPolyline polylineWithPoints:coordinates count:k];
    [self.mapView addOverlay:track];
    
    // this is a little trick to keep the route overlay *above* the track overlay.
    // this app is supposed to have a consistent look across platforms, and this is part of it.
    [self.mapView removeOverlay:route];
    [self.mapView addOverlay:route];
}

- (void) processQuits: (NSArray*) quits {
    if (quits == nil) return;
    for (int i = 0, count = [quits count]; i < count; i++) {
        NSDictionary* quit = [quits objectAtIndex:i];
        NSDictionary* user = [quit objectForKey:@"user"];
        NSNumber* userId = [user objectForKey:@"id"];
        MKPointAnnotation* marker = [userMarkers objectForKey:userId];
        if (marker == nil) continue;
        [self.mapView removeAnnotation:marker];
        [userMarkers removeObjectForKey:userId];
    }
}

- (void) processMovements: (NSArray*) movements {
    if (movements == nil) return;
    for (int i = 0, count = [movements count]; i < count; i++) {
        NSDictionary* movement = [movements objectAtIndex:i];
        NSDictionary* user = [movement objectForKey:@"user"];
        NSNumber* userId = [user objectForKey:@"id"];
        BGTUser* userObj = [BGTUser userWithId:[userId intValue]];
        NSString* teamName = [user objectForKey:@"team"];
        BGTTeam* teamObj = [BGTTeam teamForName:teamName];
        [userObj setTeam:teamObj];
        
        NSDictionary* location = [movement objectForKey:@"location"];
        BGTUserMarker* marker = [userMarkers objectForKey:userId];
        if (marker == nil) {
            marker = [BGTUserMarker markerWithUser:userObj];
            [self.mapView addAnnotation:marker];
            [userMarkers setObject:marker forKey:userId];
        }
        marker.coordinate = CLLocationCoordinate2DMake([[location objectForKey:@"lat"] floatValue], [[location objectForKey:@"lon"] floatValue]);
    }
}

- (void) processMap: (NSArray*) mapArray {
    if (mapArray == nil) return;
    NSDictionary* map = [mapArray objectAtIndex:0];
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
    [self.mapView addOverlay:route];
    [self.mapView setVisibleMapRect:route.boundingMapRect];
}

- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id <MKOverlay>)overlay {
    if (overlay == route) {
        MKPolylineView *polylineView = [[MKPolylineView alloc] initWithPolyline:overlay];
        polylineView.strokeColor = [UIColor blueColor];
        polylineView.lineWidth = 2.0;
        polylineView.alpha = .5;
    
        return polylineView;
    }
    
    if (overlay == track) {
        MKPolylineView *polylineView = [[MKPolylineView alloc] initWithPolyline:overlay];
        polylineView.strokeColor = [UIColor colorWithRed:1 green:.75 blue:0 alpha:1];
        polylineView.lineWidth = 6.0;
        polylineView.alpha = 1;
        
        return polylineView;
    }
    return NULL;
}

- (MKAnnotationView *) mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    if ([annotation class] != [BGTUserMarker class]) return nil;
    BGTUserMarker* marker = (BGTUserMarker*) annotation;
    
    MKAnnotationView *annView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"currentloc"];

    annView.image = [[[marker getUser] getTeam] getImage];
    return annView;
}

@end

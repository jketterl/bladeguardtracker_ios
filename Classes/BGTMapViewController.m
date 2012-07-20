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

@synthesize mapView, socket;

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
    userMarkers = [[[NSMutableDictionary alloc] initWithCapacity:15] retain];
    socket = [BGTSocket getSharedInstanceWithStake:self];
    [socket addListener:self];
    [socket subscribeCategoryArray:[NSArray arrayWithObjects:@"map", @"movements", @"quit", @"stats", nil]];
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
    [userMarkers release];
    if (route != nil) {
        [route release];
        route = nil;
    }
    if (track != nil) {
        [track release];
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
            [route release];
            route = nil;
        }
        if (track != nil) {
            [self.mapView removeOverlay:track];
            [track release];
            track = nil;
        }
        for (MKPointAnnotation* marker in [userMarkers allValues]) {
            [self.mapView removeAnnotation:marker];
        }
        [userMarkers removeAllObjects];
    }
}

- (void) processStats: (NSArray*) statsArray {
    if (statsArray == nil) return;

    if (track != nil) {
        [self.mapView removeOverlay:track];
        [track release];
        track = nil;
    }
    
    NSDictionary* stats = [statsArray objectAtIndex:0];
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
    
    track = [[MKPolyline polylineWithPoints:coordinates count:k] retain];
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
        NSDictionary* location = [movement objectForKey:@"location"];
        MKPointAnnotation* marker = [userMarkers objectForKey:userId];
        if (marker == nil) {
            marker = [[MKPointAnnotation alloc] init];
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
        [route release];
    }
    if (track != nil) {
        [self.mapView removeOverlay:track];
        [track release];
        track = nil;
    }
    route = [[MKPolyline polylineWithCoordinates:coordinates count:count] retain];
    [self.mapView addOverlay:route];
    [self.mapView setVisibleMapRect:route.boundingMapRect];
}

- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id <MKOverlay>)overlay {
    if (overlay == route) {
        MKPolylineView *polylineView = [[[MKPolylineView alloc] initWithPolyline:overlay] autorelease];
        polylineView.strokeColor = [UIColor blueColor];
        polylineView.lineWidth = 2.0;
        polylineView.alpha = .5;
    
        return polylineView;
    }
    
    if (overlay == track) {
        MKPolylineView *polylineView = [[[MKPolylineView alloc] initWithPolyline:overlay] autorelease];
        polylineView.strokeColor = [UIColor colorWithRed:1 green:.75 blue:0 alpha:1];
        polylineView.lineWidth = 6.0;
        polylineView.alpha = 1;
        
        return polylineView;
    }
    return NULL;
}

- (MKAnnotationView *) mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    MKAnnotationView *annView = [[MKAnnotationView alloc ] initWithAnnotation:annotation reuseIdentifier:@"currentloc"];
    annView.image = [ UIImage imageNamed:@"map_pin.png" ];
    return annView;
}

@end

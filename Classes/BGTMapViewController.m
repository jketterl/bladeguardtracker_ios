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
    [socket subscribeCategoryArray:[NSArray arrayWithObjects:@"map", @"movements", @"quit", nil]];
}

- (void)viewDidDisappear:(BOOL)animated {
    [socket unsubscribeCategoryArray:[NSArray arrayWithObjects:@"map", @"movements", @"quit", nil]];
    [socket removeListener:self];
    [socket removeStake:self];
    socket = nil;
    [super viewDidDisappear:animated];
}

- (void)viewDidUnload{
    [super viewDidUnload];
    [userMarkers release];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

- (void) receiveUpdate: (NSDictionary*) data {
    [self processMap:[data valueForKey:@"map"]];
    [self processMovements:[data valueForKey:@"movements"]];
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
    MKPolyline* route = [MKPolyline polylineWithCoordinates:coordinates count:count];
    [self.mapView addOverlay:route];
    [self.mapView setVisibleMapRect:route.boundingMapRect];
}

- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id <MKOverlay>)overlay {
    MKPolylineView *polylineView = [[[MKPolylineView alloc] initWithPolyline:overlay] autorelease];
    polylineView.strokeColor = [UIColor blueColor];
    polylineView.lineWidth = 2.0;
    polylineView.alpha = 64;
    
    return polylineView;
}

@end

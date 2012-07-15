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
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

- (void) receiveUpdate: (NSDictionary*) data {
    NSLog(@"received event: %@", data);
}

@end

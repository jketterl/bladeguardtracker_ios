//
//  BladeGuardTrackerViewController.m
//  BladeGuardTracker
//
//  Created by Jakob Ketterl on 04.07.12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "BladeGuardTrackerViewController.h"

@implementation BladeGuardTrackerViewController

@synthesize tableView, selectLabel, upcomingLabel;

/*
// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    events = [[BGTEventList alloc] init];
    [events addListener:self];
    [self.tableView setDataSource:events];
    
    /*
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadEvents) name:UIApplicationDidBecomeActiveNotification object:nil];
     */
    
    // localization
    self.selectLabel.text = NSLocalizedString(@"select_event", nil);
    self.upcomingLabel.text = NSLocalizedString(@"Upcoming bladenight events", nil);
    
    [super viewDidLoad];
}

- (void) reloadEvents {
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    
    [events load];
}

- (void) onBeforeLoad {
    [activity startAnimating];
}

- (void) onLoad {
    [self.tableView reloadData];
    [activity stopAnimating];
}


- (void) viewWillAppear:(BOOL)animated {
    [self reloadEvents];
    [super viewWillAppear:animated];
}

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    //return (interfaceOrientation == UIInterfaceOrientationPortrait);
    return YES;
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showDetails"]) {
        NSIndexPath *selectedRowIndex = [self.tableView indexPathForSelectedRow];
        BGTEventViewController *detailViewController = [segue destinationViewController];
        [detailViewController setEvent: [events eventAtIndex:selectedRowIndex.row]];
    }
}

@end

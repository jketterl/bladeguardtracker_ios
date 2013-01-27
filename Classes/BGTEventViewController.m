//
//  BGTEventViewController.m
//  Bladeguard Tracker
//
//  Created by Jakob Ketterl on 22.01.13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "BGTEventViewController.h"

@interface BGTEventViewController ()

@end

@implementation BGTEventViewController

@synthesize nameValue, startValue, mapNameValue, weatherView,
            nameLabel, startLabel, mapNameLabel, weatherLabel,
            enableSwitch, mapButton, switchLabel;

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
    self.nameValue.text = [event getName];
    self.mapNameValue.text = [event getMapName];
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    self.startValue.text = [formatter stringFromDate:[event getStart]];
    NSNumber* weather = [event getWeather];
    self.weatherView.value = weather;
    
    //self.weatherValue.text = NSLocalizedString(weatherText, nil);
    self.enableSwitch.on=[[GPSDelegate getSharedInstance] hasEvent:event];

    // Localization
    [self.mapButton setTitle: NSLocalizedString(@"View on map", nil) forState:UIControlStateNormal ];
    self.nameLabel.text = NSLocalizedString(@"Title", nil);
    self.startLabel.text = NSLocalizedString(@"Start time", nil);
    self.mapNameLabel.text = NSLocalizedString(@"Map", nil);
    self.weatherLabel.text = NSLocalizedString(@"Weather", nil);
    self.switchLabel.text = NSLocalizedString(@"Yes! I'm participating!", nil);
    self.navigationItem.title = NSLocalizedString(@"Event details", nil);
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

- (void) setEvent:(BGTEvent *) newEvent {
    event = newEvent;
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"map"]) {
        BGTMapViewController* destination = [segue destinationViewController];
        [destination setEvent: event];
    }
}

- (IBAction)toggle:(id)sender {
    if (enableSwitch.on) {
        [[GPSDelegate getSharedInstance] addEvent:event];
    } else {
        [[GPSDelegate getSharedInstance] removeEvent:event];
    }
}

@end

//
//  BGTSettingsViewController.m
//  Bladeguard Tracker
//
//  Created by Jakob Ketterl on 01.02.13.
//
//

#import "BGTSettingsViewController.h"

@interface BGTSettingsViewController ()

@end

@implementation BGTSettingsViewController

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
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(sessionStateChanged:)
     name:FBSessionStateChangedNotification
     object:nil];
    
    // Check the session for a cached token to show the proper authenticated
    // UI. However, since this is not user intitiated, do not show the login UX.
    BladeGuardTrackerAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    [appDelegate openSessionWithAllowLoginUI:NO];
    
    // Localization
    self.title = NSLocalizedString(@"Settings", nil);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (IBAction) toggleAnonymous:(id)sender {
    credentialsView.hidden = anonymousSwitch.on;
    anonymousInfoText.hidden = !anonymousSwitch.on;
}

- (IBAction) loginWithFacebook:(id)sender {
    BladeGuardTrackerAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];

    // If the user is authenticated, log out when the button is clicked.
    // If the user is not authenticated, log in when the button is clicked.
    if (FBSession.activeSession.isOpen) {
        [appDelegate closeSession];
    } else {
        // The user has initiated a login, so call the openSession method
        // and show the login UX if necessary.
        [appDelegate openSessionWithAllowLoginUI:YES];
    }
}


- (void)sessionStateChanged:(NSNotification*)notification {
    if (FBSession.activeSession.isOpen) {
        [facebookButton setTitle:@"Disconnect from Facebook" forState:UIControlStateNormal];
    } else {
        [facebookButton setTitle:@"Login with Facebook" forState:UIControlStateNormal];
    }
}

@end

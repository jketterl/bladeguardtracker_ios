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
    
    // Localization
    self.title = NSLocalizedString(@"Settings", nil);
    anonymousLabel.text = NSLocalizedString(@"Anonymous Tracking", nil);
    usernameLabel.text = NSLocalizedString(@"Username", nil);
    passwordLabel.text = NSLocalizedString(@"Password", nil);
    orLabel.text = NSLocalizedString(@"or", nil);
    anonymousInfoText.text = NSLocalizedString(@"anonymous_summary", nil);
    [registerButton setTitle:NSLocalizedString(@"Register", nil) forState:UIControlStateNormal];
    [loginButton setTitle:NSLocalizedString(@"Login", nil) forState:UIControlStateNormal];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // Check the session for a cached token to show the proper authenticated
    // UI. However, since this is not user intitiated, do not show the login UX.
    BladeGuardTrackerAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    [appDelegate openSessionWithAllowLoginUI:NO];
    
    [self sessionStateChanged:nil];

    NSUserDefaults* settings = [NSUserDefaults standardUserDefaults];
    userField.text = [settings valueForKey:@"user"];
    passwordField.text = [settings valueForKey:@"pass"];
    anonymousSwitch.on = [settings boolForKey:@"anonymous"];
    [self toggleAnonymous:anonymousSwitch];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (IBAction) toggleAnonymous:(id)sender {
    Boolean on = anonymousSwitch.on;
    credentialsView.hidden = on;
    anonymousInfoText.hidden = !on;
    if (!on && FBSession.activeSession.isOpen) {
        BladeGuardTrackerAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
        [appDelegate closeSession];
    }
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
        [facebookButton setTitle:NSLocalizedString(@"Disconnect from Facebook", nil) forState:UIControlStateNormal];
        userField.enabled = false;
        passwordField.enabled = false;
        registerButton.enabled = false;
        loginButton.enabled = false;
        regularLoginView.alpha = .2;
        anonymousSwitch.on = false;
        credentialsView.hidden = false;
        anonymousInfoText.hidden = true;
    } else {
        [facebookButton setTitle:NSLocalizedString(@"Login with Facebook", nil) forState:UIControlStateNormal];
        userField.enabled = true;
        passwordField.enabled = true;
        registerButton.enabled = true;
        loginButton.enabled = true;
        regularLoginView.alpha = 1;
        anonymousSwitch.on = true;
        credentialsView.hidden = true;
        anonymousInfoText.hidden = false;
    }
}

- (void) login:(id)sender {
    NSString* user = userField.text;
    NSString* pass = passwordField.text;
    
    
    if (user == nil) user = @"";
    if (pass == nil) pass = @"";
    
    [loginActivity startAnimating];
    
    BGTAuthCommand* auth = [[BGTSocket getSharedInstance] authenticateWithUser:user andPass:pass];
    
    NSMethodSignature* sig = [self methodSignatureForSelector:@selector(processAuthentication:)];
    NSInvocation* callback = [NSInvocation invocationWithMethodSignature:sig];
    [callback setTarget:self];
    [callback setSelector:@selector(processAuthentication:)];
    [callback setArgument:&auth atIndex:2];
    
    [auth addCallback:callback];
}

- (void) processAuthentication: (BGTAuthCommand*) command {
    [loginActivity stopAnimating];
    if (![command wasSuccessful]) {
        return;
    }
    NSUserDefaults* settings = [NSUserDefaults standardUserDefaults];
    [settings setValue:userField.text forKey:@"user"];
    [settings setValue:passwordField.text forKey:@"pass"];
    [settings setBool:false forKey:@"anonymous"];
    [settings synchronize];
    
    [[self navigationController] popViewControllerAnimated:YES];
}

@end

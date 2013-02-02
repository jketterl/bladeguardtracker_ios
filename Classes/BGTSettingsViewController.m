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
    
    UIBarButtonItem* back = [[UIBarButtonItem alloc] initWithTitle:@"Bladeguard Tracker" style:UIBarButtonItemStyleBordered target:self action:@selector(back:)];
    self.navigationItem.leftBarButtonItem = back;
    
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
    [self updateUI];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (IBAction) toggleAnonymous:(id)sender {
    NSUserDefaults* settings = [NSUserDefaults standardUserDefaults];
    if (anonymousSwitch.on) {
        if (FBSession.activeSession.isOpen) {
            NSLog(@"closing session");
            BladeGuardTrackerAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
            [appDelegate closeSession];
        }
        [settings setBool:true forKey:@"anonymous"];
        [settings setValue:@"" forKey:@"user"];
        [settings setValue:@"" forKey:@"pass"];
        [settings synchronize];
    } else {
        [settings setBool:false forKey:@"anonymous"];
    }
    [self updateUI];
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

- (void) updateUI {
    NSUserDefaults* settings = [NSUserDefaults standardUserDefaults];
    if (FBSession.activeSession.isOpen) {
        [facebookButton setTitle:NSLocalizedString(@"Disconnect from Facebook", nil) forState:UIControlStateNormal];
        anonymousSwitch.on = false;
        credentialsView.hidden = false;
        anonymousInfoText.hidden = true;
        userField.enabled = false;
        passwordField.enabled = false;
        registerButton.enabled = false;
        loginButton.enabled = false;
        regularLoginView.alpha = .2;
    } else {
        [facebookButton setTitle:NSLocalizedString(@"Login with Facebook", nil) forState:UIControlStateNormal];
        Boolean anonymous = [settings boolForKey:@"anonymous"];
        anonymousSwitch.on = anonymous;
        credentialsView.hidden = anonymous;
        anonymousInfoText.hidden = !anonymous;
        userField.enabled = true;
        passwordField.enabled = true;
        registerButton.enabled = true;
        loginButton.enabled = true;
        regularLoginView.alpha = 1;
    }
    userField.text = [settings valueForKey:@"user"];
    passwordField.text = [settings valueForKey:@"pass"];
}

- (void)sessionStateChanged:(NSNotification*)notification {
    [self updateUI];
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
        NSDictionary* result = [command getResult];
        NSString* message = [result valueForKey:@"message"];
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", nil) message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        return;
    }
    NSUserDefaults* settings = [NSUserDefaults standardUserDefaults];
    [settings setValue:userField.text forKey:@"user"];
    [settings setValue:passwordField.text forKey:@"pass"];
    [settings setBool:false forKey:@"anonymous"];
    [settings synchronize];
    
    [[self navigationController] popViewControllerAnimated:YES];
}

- (void) back: (id) sender {
    if (anonymousSwitch.on || FBSession.activeSession.isOpen) {
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    [self login:sender];
}

@end

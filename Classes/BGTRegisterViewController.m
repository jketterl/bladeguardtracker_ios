//
//  BGTRegisterViewController.m
//  Bladeguard Tracker
//
//  Created by Jakob Ketterl on 02.02.13.
//
//

#import "BGTRegisterViewController.h"

@interface BGTRegisterViewController ()

@end

@implementation BGTRegisterViewController

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
    self.title = NSLocalizedString(@"Register", nil);
    
    // Localization
    userLabel.text = NSLocalizedString(@"Username", nil);
    passLabel.text = NSLocalizedString(@"Password", nil);
    confirmLabel.text = NSLocalizedString(@"Confirm", nil);
    [registerButton setTitle:NSLocalizedString(@"Register", nil) forState:UIControlStateNormal];
    
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)register:(id)sender {
    NSString* user = userField.text;
    NSString* pass = passField.text;
    NSString* confirm = confirmField.text;
    
    if ([user isEqualToString:@""]) {
        NSLog(@"user empty");
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", nil) message:NSLocalizedString(@"Username cannot be empty", nil) delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        return;
    }

    if (![pass isEqualToString:confirm]) {
        NSLog(@"password mismatch");
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", nil) message:NSLocalizedString(@"Passwords do not match", nil) delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        return;
    }
    
    if ([pass isEqualToString:@""]) {
        NSLog(@"password empty");
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", nil) message:NSLocalizedString(@"Password cannot be empty", nil) delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        return;
    }
    
    BGTSignupCommand* command = [[BGTSignupCommand alloc] initWIthUser:user andPass:pass];
    
    NSMethodSignature* sig = [self methodSignatureForSelector:@selector(receiveResult:)];
    NSInvocation* callback = [NSInvocation invocationWithMethodSignature:sig];
    [callback setTarget:self];
    [callback setSelector:@selector(receiveResult:)];
    [callback setArgument:&command atIndex:2];
    [command addCallback:callback];
    
    [[BGTSocket getSharedInstance] sendCommand:command];
}

- (void) receiveResult: (BGTSignupCommand*) command {
    if (! [command wasSuccessful]) {
        NSDictionary* result = [command getResult];
        NSString* message = [result valueForKey:@"message"];
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", nil) message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        return;
    }
    
    NSUserDefaults* settings = [NSUserDefaults standardUserDefaults];
    [settings setValue:userField.text forKey:@"user"];
    [settings setValue:passField.text forKey:@"pass"];
    [settings synchronize];

    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Success", nil) message:NSLocalizedString(@"User created successfully", nil) delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];
}

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSLog(@"%d", buttonIndex);
    [[self navigationController] popViewControllerAnimated:YES];
}

@end

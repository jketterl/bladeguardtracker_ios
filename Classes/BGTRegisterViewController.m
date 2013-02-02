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

    if (![pass isEqualToString:confirm]) {
        NSLog(@"strings to not match");
    }
}

@end

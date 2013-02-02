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
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

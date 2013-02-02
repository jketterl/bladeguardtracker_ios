//
//  BGTSettingsViewController.h
//  Bladeguard Tracker
//
//  Created by Jakob Ketterl on 01.02.13.
//
//

#import <UIKit/UIKit.h>
#import "BladeGuardTrackerAppDelegate.h"
#import "BGTAuthCommand.h"

@interface BGTSettingsViewController : UIViewController {
    @private
    IBOutlet UIButton* facebookButton;
    IBOutlet UIView* credentialsView;
    IBOutlet UISwitch* anonymousSwitch;
    IBOutlet UITextView* anonymousInfoText;
    IBOutlet UIView* regularLoginView;
    
    IBOutlet UITextField* userField;
    IBOutlet UITextField* passwordField;
    
    IBOutlet UIButton* registerButton;
    IBOutlet UIButton* loginButton;
    
    IBOutlet UILabel* anonymousLabel;
    IBOutlet UILabel* usernameLabel;
    IBOutlet UILabel* passwordLabel;
    IBOutlet UILabel* orLabel;
    
    IBOutlet UIActivityIndicatorView* loginActivity;
}

- (IBAction) toggleAnonymous:(id)sender;
- (IBAction) loginWithFacebook:(id)sender;
- (IBAction) login:(id)sender;

@end

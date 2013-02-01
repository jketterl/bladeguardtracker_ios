//
//  BGTSettingsViewController.h
//  Bladeguard Tracker
//
//  Created by Jakob Ketterl on 01.02.13.
//
//

#import <UIKit/UIKit.h>
#import "BladeGuardTrackerAppDelegate.h"

@interface BGTSettingsViewController : UIViewController {
    @private
    IBOutlet UIButton* facebookButton;
    IBOutlet UIView* credentialsView;
    IBOutlet UISwitch* anonymousSwitch;
    IBOutlet UITextView* anonymousInfoText;
}

- (IBAction) toggleAnonymous:(id)sender;
- (IBAction) loginWithFacebook:(id)sender;

@end

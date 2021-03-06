//
//  BGTRegisterViewController.h
//  Bladeguard Tracker
//
//  Created by Jakob Ketterl on 02.02.13.
//
//

#import <UIKit/UIKit.h>
#import "BGTSocket.h"
#import "BGTSignupCommand.h"

@interface BGTRegisterViewController : UIViewController <UIAlertViewDelegate> {
    IBOutlet UILabel* userLabel;
    IBOutlet UILabel* passLabel;
    IBOutlet UILabel* confirmLabel;
    
    IBOutlet UITextField* userField;
    IBOutlet UITextField* passField;
    IBOutlet UITextField* confirmField;
    
    IBOutlet UIButton* registerButton;
}

- (IBAction)register:(id)sender;

@end

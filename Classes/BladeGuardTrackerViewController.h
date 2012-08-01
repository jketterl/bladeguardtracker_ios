//
//  BladeGuardTrackerViewController.h
//  BladeGuardTracker
//
//  Created by Jakob Ketterl on 04.07.12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GPSDelegate.h"

@interface BladeGuardTrackerViewController : UIViewController

@property (nonatomic) IBOutlet UISwitch* trackerSwitch;
@property (nonatomic) GPSDelegate* gps;
- (IBAction)trackerSwitchChanged:(id)sender;
@property (nonatomic) IBOutlet UILabel* trackerSwitchLabel;
@property (nonatomic) IBOutlet UIButton* mapButton;

@end


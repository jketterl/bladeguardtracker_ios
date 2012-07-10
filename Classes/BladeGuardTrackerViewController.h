//
//  BladeGuardTrackerViewController.h
//  BladeGuardTracker
//
//  Created by Jakob Ketterl on 04.07.12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GPSDelegate.h"

@interface BladeGuardTrackerViewController : UIViewController {
    IBOutlet UISwitch* trackerSwitch;
}
@property (nonatomic, retain) UISwitch* trackerSwitch;
@property (nonatomic, retain) WebSocketDelegate* socket;
@property (nonatomic, retain) GPSDelegate* gps;
- (IBAction)trackerSwitchChanged:(id)sender;

@end


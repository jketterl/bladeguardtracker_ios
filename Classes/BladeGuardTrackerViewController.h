//
//  BladeGuardTrackerViewController.h
//  BladeGuardTracker
//
//  Created by Jakob Ketterl on 04.07.12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GPSDelegate.h"
#import "BGTEventList.h"
#import "BGTEventViewController.h"

@interface BladeGuardTrackerViewController : UIViewController {
    @private BGTEventList* events;
}

@property (nonatomic) IBOutlet UITableView* tableView;

@end


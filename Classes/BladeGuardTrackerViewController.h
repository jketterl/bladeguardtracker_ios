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
#import "BGTEventListListener.h"

@interface BladeGuardTrackerViewController : UIViewController <BGTEventListListener> {
    IBOutlet UIActivityIndicatorView* activity;
    @private BGTEventList* events;
}

@property (nonatomic) IBOutlet UITableView* tableView;

@property (nonatomic) IBOutlet UILabel* selectLabel;
@property (nonatomic) IBOutlet UILabel* upcomingLabel;

@end


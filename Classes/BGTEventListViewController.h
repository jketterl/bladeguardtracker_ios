//
//  BGTEventViewController.h
//  Bladeguard Tracker
//
//  Created by Jakob Ketterl on 20.01.13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BGTEvent.h"
#import "BGTEventList.h"
#import "BGTEventViewController.h"

@interface BGTEventListViewController : UITableViewController {
@private BGTEventList* events;
}

@end
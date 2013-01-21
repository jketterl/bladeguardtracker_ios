//
//  BGTEventViewController.h
//  Bladeguard Tracker
//
//  Created by Jakob Ketterl on 20.01.13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BGTSocket.h"
#import "BGTSocketCommand.h"
#import "BGTGetEventsCommand.h"
#import "BGTEvent.h"

@interface BGTEventViewController : UITableViewController {
@private NSMutableArray* events;
}

@end

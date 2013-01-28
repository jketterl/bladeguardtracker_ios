//
//  BGTEventList.m
//  Bladeguard Tracker
//
//  Created by Jakob Ketterl on 22.01.13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "BGTEventList.h"

@implementation BGTEventList

- (id) initWithTableview:(UITableView *) newTableview {
    self = [super init];
    if (self) {
        events = [[NSMutableArray alloc] init];
        tableview = newTableview;
    
    }
    return self;
}

- (void) load: (NSInvocation*) onLoad {
    BGTSocket* socket = [BGTSocket getSharedInstanceWithStake:self];
    BGTSocketCommand* command = [[BGTGetEventsCommand alloc] initWithDefaults];
    
    NSMethodSignature* sig = [self methodSignatureForSelector:@selector(onCommandResult:)];
    NSInvocation* callback = [NSInvocation invocationWithMethodSignature:sig];
    [callback setArgument:&command atIndex:2];
    [callback setTarget:self];
    [callback setSelector:@selector(onCommandResult:)];
    [command addCallback:callback];
    [command addCallback:onLoad];
    
    [socket sendCommand:command];
}

- (void) onCommandResult: (BGTSocketCommand *) command
{
    for (NSDictionary* entry in [command getResult]) {
        BGTEvent* event = [[BGTEvent alloc] initWithJSON:entry];
        [events addObject:event];
    }
    [tableview reloadData];
    BGTSocket* socket = [BGTSocket getSharedInstanceWithStake:self];
    [socket removeStake:self];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [events count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"event";
    BGTEventTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    BGTEvent* event = [events objectAtIndex:[indexPath row]];
    
    cell.textLabel.text = [event getName];
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    
    NSMutableString* detail = [[NSMutableString alloc] init];
    [detail appendString:[formatter stringFromDate:[event getStart]]];
    [detail appendString:@" "];
    [detail appendString:[event getMapName]];
    cell.detailTextLabel.text = detail;
    
    NSNumber* weather = [event getWeather];
    if (weather == (NSNumber*) [NSNull null]) {
        [cell.weatherIcon setImage:nil];
    } else if ([weather intValue] == 1) {
        [cell.weatherIcon setImage:[UIImage imageNamed:@"ampel_gruen.png"]];
    } else {
        [cell.weatherIcon setImage:[UIImage imageNamed:@"ampel_rot.png"]];
    }
    
    return cell;
}

- (BGTEvent *) eventAtIndex:(int)index {
    return [events objectAtIndex:index];
}

@end

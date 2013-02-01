//
//  CustomCalendarView.h
//  FunCalendar
//
//  Created by Susim Samanta  on 2/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <EventKit/EventKit.h>
#import <EventKitUI/EventKitUI.h>
#import "AddNewCalendar.h"

@interface CustomCalendarView : UITableViewController<AddNewCalendarDelegate>
@property(nonatomic,strong) EKEventStore * eventStore;
@property (weak, nonatomic) IBOutlet UITableView *calendarListTableView;
@property(nonatomic,strong) NSMutableArray *calendarsList;
@end

//
//  ViewController.h
//  FunCalendar
//
//
//  Created by Susim Samanta  on 2/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <EventKit/EventKit.h>
#import <EventKitUI/EventKitUI.h>
#import "AddNewCalendar.h"
#import "AddCustomEvent.h"

@interface ViewController : UIViewController<EKEventEditViewDelegate,UIActionSheetDelegate,EKCalendarChooserDelegate,AddCustomEventDelegate>

@property (nonatomic, strong) EKEventStore * eventStore;
@property (nonatomic, strong) EKCalendar * selectedCalendar;
@property (strong, nonatomic) IBOutlet UITableView * eventListsTableview;
@property (nonatomic, strong) NSMutableArray * eventsList;

- (NSMutableArray *)fetchEventsByCalender : (EKCalendar *)calender;
- (IBAction)addEvent : (id)sender;
- (IBAction)getCalendars : (id)sender;
@end

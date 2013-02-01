//
//  AddCustomEvent.h
//  FunCalendar
//
//  Created by Susim Samanta  on 2/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <EventKit/EventKit.h>
#import <EventKitUI/EventKitUI.h>
#import "DatePicker.h"

@protocol AddCustomEventDelegate <NSObject>

-(void)updateEventList;

@end

@interface AddCustomEvent : UITableViewController<EKCalendarChooserDelegate,DatePickerDelegate>
{
    EKCalendar *selectedCalendar;
    NSDate *startDate;
    NSDate *endDate;
}
@property (weak, nonatomic) IBOutlet UIButton *calendarButton;
@property (weak, nonatomic) IBOutlet UITextField *eventNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *locationTextField;
@property (weak, nonatomic) IBOutlet UIButton *startButton;
@property (weak, nonatomic) IBOutlet UIButton *endButton;
@property (nonatomic,assign) NSObject<AddCustomEventDelegate> *addCustomEventDelegate;
@property(strong,nonatomic) EKEventStore *eventStore; 

- (IBAction)selectCalenderForNewEvent:(id)sender;
- (IBAction)getStartTimeForNewEvent:(id)sender;
- (IBAction)getEndTimeForNewEvent:(id)sender;
@end

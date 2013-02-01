//
//  AddNewCalendar.h
//  FunCalendar
//
//  Created by Susim Samanta  on 2/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AddNewCalendarDelegate

-(void)addNewCalendarTitle:(NSString *)title;

@end;

@interface AddNewCalendar : UIViewController

@property(nonatomic,weak) id<AddNewCalendarDelegate> addNewControllerDelegate;
@property (weak, nonatomic) IBOutlet UITextField *calendarTitleTf;

- (IBAction)doneButtonPressed:(id)sender;
@end

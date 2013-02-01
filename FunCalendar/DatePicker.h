//
//  DatePicker.h
//  FunCalendar
//
//  Created by Susim Samanta  on 2/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DatePickerDelegate <NSObject>

-(void)getDate:(NSDate *)selectedDate buttonTitle:(NSString *)buttonTitle;

@end

@interface DatePicker : UIViewController
{
    
}
@property(nonatomic,assign) NSObject<DatePickerDelegate> *datePickerDelegate;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (strong, nonatomic) NSString *buttonTag;

- (IBAction)doneButtonPressed:(id)sender;
@end

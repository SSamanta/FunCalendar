//
//  AddCustomEvent.m
//  FunCalendar
//
//  Created by Susim Samanta  on 2/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AddCustomEvent.h"


@implementation AddCustomEvent
@synthesize calendarButton;
@synthesize eventNameTextField;
@synthesize locationTextField;
@synthesize startButton;
@synthesize endButton;
@synthesize eventStore,addCustomEventDelegate;

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(donePressed:)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelPressed:)];
    
}
-(void)donePressed:(id)sender {
    if (self.eventNameTextField.text && startDate && endDate && selectedCalendar)
    {
        EKEvent *event  = [EKEvent eventWithEventStore:eventStore];
        event.title     = self.eventNameTextField.text;
        event.location  = self.locationTextField.text;
        event.startDate = startDate;
        event.endDate   = endDate;
        [event setCalendar:selectedCalendar];
        NSError *error;
        if([self.eventStore saveEvent:event span:EKSpanThisEvent error:&error])
        {
            NSLog(@"Event Saved");
            [self.addCustomEventDelegate updateEventList];
            [self.navigationController popViewControllerAnimated:YES];
        }
        else if (error)
        {
            
            NSLog(@"Error:%@",error);
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[error localizedDescription] delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [alert show];
            
            
        }
        else
        {
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Event is not saved" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [alert show];
            
        }
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Enter Proper Info" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
    }
    
    
}
-(void)cancelPressed:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewDidUnload
{
    [self setEventNameTextField:nil];
    [self setLocationTextField:nil];
    [self setStartButton:nil];
    [self setEndButton:nil];
    [self setCalendarButton:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (IBAction)selectCalenderForNewEvent:(id)sender  {
    EKCalendarChooser *calendarChooser = [[EKCalendarChooser alloc] initWithSelectionStyle:EKCalendarChooserSelectionStyleSingle displayStyle:EKCalendarChooserDisplayAllCalendars eventStore:self.eventStore];
    calendarChooser.showsDoneButton = YES;
    calendarChooser.showsCancelButton = YES;
    calendarChooser.delegate = self;
    [self.navigationController pushViewController:calendarChooser animated:YES];
}

- (IBAction)getStartTimeForNewEvent:(id)sender {
    DatePicker *datePicker = [self.storyboard instantiateViewControllerWithIdentifier:@"datepicker"];
    datePicker.datePickerDelegate = self;
    datePicker.buttonTag = @"0";
    [self presentModalViewController:datePicker animated:YES];
}

- (IBAction)getEndTimeForNewEvent:(id)sender {
    DatePicker *datePicker = [self.storyboard instantiateViewControllerWithIdentifier:@"datepicker"];
    datePicker.buttonTag = @"1";
    datePicker.datePickerDelegate = self;
    [self presentModalViewController:datePicker animated:YES];
}
#pragma mark -
#pragma mark EKCalendarChooserDelegate

// Called whenever the selection is changed by the user

- (void)calendarChooserSelectionDidChange:(EKCalendarChooser *)calendarChooser {
}
- (void)calendarChooserDidFinish:(EKCalendarChooser *)calendarChooser {
    NSArray *calendarsArray = [calendarChooser.selectedCalendars allObjects];
    selectedCalendar = (EKCalendar *)[calendarsArray objectAtIndex:0];
    calendarButton.titleLabel.text = [NSString stringWithFormat:@"Calendar : %@",selectedCalendar.title];
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)calendarChooserDidCancel:(EKCalendarChooser *)calendarChooser{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark -
#pragma mark DatePickerDelegate
-(void)getDate:(NSDate *)selectedDate buttonTitle:(NSString *)buttonTag{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"dd/MM/yy hh:mma"];
    if ([buttonTag isEqualToString:@"0"]){
        startDate = selectedDate;
       
        NSString *startDateString = [dateFormat stringFromDate:startDate];
        startButton.titleLabel.text = [NSString stringWithFormat:@"Start Date : %@",startDateString];
    }
    else if([buttonTag isEqualToString:@"1"]){
        endDate = selectedDate;
        NSString *endDateString = [dateFormat stringFromDate:startDate];
        endButton.titleLabel.text = [NSString stringWithFormat:@"End Date : %@",endDateString];
    }
}
@end

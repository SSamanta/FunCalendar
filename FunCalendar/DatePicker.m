//
//  DatePicker.m
//  FunCalendar
//
//  Created by Susim Samanta  on 2/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DatePicker.h"

@implementation DatePicker
@synthesize datePicker;
@synthesize buttonTag,datePickerDelegate;

- (void)viewDidLoad {
    [super viewDidLoad];
}
- (void)viewDidUnload {
    [self setDatePicker:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)doneButtonPressed:(id)sender  {
    [self.datePickerDelegate getDate:self.datePicker.date buttonTitle:self.buttonTag];
    [self dismissModalViewControllerAnimated:YES];
}
@end

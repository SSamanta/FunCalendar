//
//  AddNewCalendar.m
//  FunCalendar
//
//  Created by Susim Samanta  on 2/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AddNewCalendar.h"

@implementation AddNewCalendar
@synthesize addNewControllerDelegate;
@synthesize calendarTitleTf;

#pragma mark - View lifecycle
- (void)viewDidLoad{
    [super viewDidLoad];
}

- (void)viewDidUnload {
    [self setCalendarTitleTf:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)doneButtonPressed:(id)sender  {
    if (calendarTitleTf.text.length > 0){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Please Enter Calendar Name" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
        
    }
    else {
        [self.addNewControllerDelegate addNewCalendarTitle:calendarTitleTf.text];
        [self dismissModalViewControllerAnimated:YES];
    }
    
}
@end

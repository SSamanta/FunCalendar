//
//  ViewController.m
//  FunCalendar
//
//  Created by Susim Samanta  on 2/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"
#import "AddNewCalendar.h"
#import "CustomCalendarView.h"
#import "AddCustomEvent.h"

@implementation ViewController
@synthesize eventListsTableview;
@synthesize eventStore,eventsList,selectedCalendar;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.eventStore = [[EKEventStore alloc] init];
    self.eventsList = [[NSMutableArray alloc] init];
   
}

- (void)viewDidUnload
{
    [self setEventListsTableview:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}
- (NSMutableArray *)fetchEventsByCalender:(EKCalendar *)calender
{
    NSMutableArray *events = [[NSMutableArray alloc] init];
	NSDate *startDate = [NSDate date];
	NSDate *endDate = [NSDate dateWithTimeIntervalSinceNow:86400*30];//next 30 days
    if (self.selectedCalendar)
    {
        NSArray *calendarArray = [NSArray arrayWithObject:self.selectedCalendar];
        NSPredicate *predicate = [self.eventStore predicateForEventsWithStartDate:startDate endDate:endDate calendars:calendarArray];
        [eventStore enumerateEventsMatchingPredicate:predicate
                                          usingBlock:^(EKEvent *event, BOOL *stop) 
         {
             
             if (event) 
             {
                 [events addObject:event];
             }
         }];
    }
	
	return events;
}
#pragma mark -
#pragma mark Table View

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
	return eventsList.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	
	static NSString *CellIdentifier = @"events";
	UITableViewCellAccessoryType editableCellAccessoryType =UITableViewCellAccessoryDisclosureIndicator;
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) 
    {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault 
                                       reuseIdentifier:CellIdentifier];
	}
	
	cell.accessoryType = editableCellAccessoryType;
    
	// Get the event at the row selected and display it's title
	cell.textLabel.text = [[self.eventsList objectAtIndex:indexPath.row] title];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"dd/MM/yy hh:mma"];
    NSString *startDate = [dateFormat stringFromDate:[[self.eventsList objectAtIndex:indexPath.row] startDate]];
    NSString *endDate = [dateFormat stringFromDate:[[self.eventsList objectAtIndex:indexPath.row] endDate]];
    NSString *showtimings=[NSString stringWithFormat:@"Starts : %@\nEnds : %@",startDate,endDate];
    cell.detailTextLabel.text=showtimings;
    
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{	
	EKEventEditViewController *detailsEventView = [[EKEventEditViewController alloc] initWithNibName:nil bundle:nil];			
	detailsEventView.event = [self.eventsList objectAtIndex:indexPath.row];
    detailsEventView.eventStore = self.eventStore;
    detailsEventView.editViewDelegate = self;
	[self presentModalViewController:detailsEventView animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
- (IBAction)addEvent:(id)sender 
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Choose Option"
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:nil  otherButtonTitles:@"Custom",@"Default",nil];
    actionSheet.tag = 0;
    [actionSheet showInView:self.view];
    
    
}
- (IBAction)getCalendars:(id)sender 
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Choose Option"
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:nil otherButtonTitles:@"Add / Delete Calendar",@"Choose Calendar",nil];
    actionSheet.tag = 1;
    [actionSheet showInView:self.view];

}

-(void)cancelBtnClicked:(id) sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark EKEventEditViewDelegate

// Overriding EKEventEditViewDelegate method to update event store according to user actions.

- (void)eventEditViewController:(EKEventEditViewController *)controller 
          didCompleteWithAction:(EKEventEditViewAction)action 
{
	
	NSError *error = nil;
	EKEvent *thisEvent = controller.event;
	
	switch (action) 
    {
		case EKEventEditViewActionCanceled:
			 
			break;
			
		case EKEventEditViewActionSaved:
			
			[controller.eventStore saveEvent:controller.event span:EKSpanThisEvent error:&error];
            if (self.selectedCalendar)
            {
                self.eventsList = [self fetchEventsByCalender:self.selectedCalendar];	
                [eventListsTableview reloadData];
            }
			break;
			
		case EKEventEditViewActionDeleted:
			
			[controller.eventStore removeEvent:thisEvent span:EKSpanThisEvent error:&error];
            if (self.selectedCalendar) 
            {
                self.eventsList = [self fetchEventsByCalender:self.selectedCalendar];	
                [eventListsTableview reloadData];
            }
			
			break;
			
		default:
			break;
	}
	// Dismiss the modal view controller
	[controller dismissModalViewControllerAnimated:YES];
	
}
#pragma mark -
#pragma mark EKCalendarChooserDelegate

// Called whenever the selection is changed by the user

- (void)calendarChooserSelectionDidChange:(EKCalendarChooser *)calendarChooser
{
}
- (void)calendarChooserDidFinish:(EKCalendarChooser *)calendarChooser
{
    NSArray *calendarsArray = [calendarChooser.selectedCalendars allObjects];
    self.selectedCalendar = (EKCalendar *)[calendarsArray objectAtIndex:0];
    self.eventsList = [self fetchEventsByCalender:self.selectedCalendar];
    [self.eventListsTableview reloadData];
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)calendarChooserDidCancel:(EKCalendarChooser *)calendarChooser
{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark -
#pragma mark UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)sender clickedButtonAtIndex:(int)index
{
    if (sender.tag==0)
    {
        if (index == 0) 
        {
            AddCustomEvent *addCustomEvent = [self.storyboard instantiateViewControllerWithIdentifier:@"addCustomEvent"];
            addCustomEvent.eventStore = self.eventStore;
            addCustomEvent.addCustomEventDelegate = self;
            [self.navigationController pushViewController:addCustomEvent animated:YES];
        } 
        else if (index ==1)
        {
            EKEventEditViewController *addEventController = [[EKEventEditViewController alloc] initWithNibName:nil bundle:nil];
            addEventController.eventStore = self.eventStore;
            [self presentModalViewController:addEventController animated:YES];
            addEventController.editViewDelegate = self;
        }
        else if (index ==2)
        {
            
            
        }
    }
    else if(sender.tag==1)
    {
        if (index == 0) 
        {
            CustomCalendarView *customCalendarView = [self.storyboard instantiateViewControllerWithIdentifier:@"customCalendar"];
            customCalendarView.eventStore=self.eventStore;
            UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:customCalendarView];
            [self presentModalViewController:navigationController animated:YES]; 
        } 
        else if (index ==1)
        {
            EKCalendarChooser *calendarChooser=[[EKCalendarChooser alloc] initWithSelectionStyle:EKCalendarChooserSelectionStyleSingle displayStyle:EKCalendarChooserDisplayAllCalendars eventStore:self.eventStore];
            calendarChooser.showsDoneButton = YES;
            calendarChooser.showsCancelButton = YES;
            calendarChooser.delegate = self;
            [self.navigationController pushViewController:calendarChooser animated:YES];
        }
        else if (index == 2)
        {
            
            
        }
    }
    
}
#pragma mark -
#pragma mark AddCustomEventDelegate
-(void)updateEventList
{
    if (self.selectedCalendar)
    {
        self.eventsList=[self fetchEventsByCalender:self.selectedCalendar];	
        [eventListsTableview reloadData];
    }
}
@end

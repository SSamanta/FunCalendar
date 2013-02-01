//
//  CustomCalendarView.m
//  FunCalendar
//
//  Created by Susim Samanta  on 2/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CustomCalendarView.h"
#import "AddNewCalendar.h"

@implementation CustomCalendarView
@synthesize calendarListTableView;
@synthesize calendarsList,eventStore;

#pragma mark - View lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    NSArray *calerdarArray=[eventStore calendars];
    self.calendarsList=[NSMutableArray arrayWithArray:calerdarArray] ;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Add" style:UIBarButtonItemStylePlain target:self action:@selector(addButtonPressed:)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancelButtonPressed:)];
    
}
-(void)addButtonPressed:(id)sender {
    AddNewCalendar *addNew=[self.storyboard instantiateViewControllerWithIdentifier:@"addNew"];
    addNew.addNewControllerDelegate=self;
    [self presentModalViewController:addNew animated:YES];
}
-(void)cancelButtonPressed:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}
-(void)addNewCalendarTitle:(NSString *)title {
    NSString* calendarName = title;
    EKCalendar* calendar = [EKCalendar calendarWithEventStore:self.eventStore];
    EKSource* localSource;
    for (EKSource* source in self.eventStore.sources) {
        if (source.sourceType == EKSourceTypeLocal){
            localSource = source;
            break;
        }
    }
    calendar.source = localSource;
    calendar.title = calendarName;
    NSError* error;
    bool success = [eventStore saveCalendar:calendar commit:YES error:&error];
    if (success){
        NSArray *calerdarArray = [self.eventStore calendars];
        self.calendarsList = [NSMutableArray arrayWithArray:calerdarArray] ;
        [self.calendarListTableView reloadData];
    }
    else if (error){
        NSLog(@"Error: %@",error);
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[error localizedDescription] delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
    }
    
}
- (void)viewDidUnload
{
    [self setCalendarListTableView:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return calendarsList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell;
    cell = nil;
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        EKCalendar *calendar = calendarsList[indexPath.row];
        cell.textLabel.text = calendar.title;
    }
    return cell;
}
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        EKCalendar *deletedCalendar = calendarsList[indexPath.row];
        NSError *error;
        if ([self.eventStore removeCalendar:deletedCalendar commit:YES error:&error]){
            [calendarsList removeObjectAtIndex:indexPath.row];
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }
        else if(error){
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[error localizedDescription] delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [alert show];
        }
    }
    
}
@end

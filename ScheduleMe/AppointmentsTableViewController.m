//
//  AppointmentsTableViewController.m
//  ScheduleMe
//
//  Created by jchavezk on 4/1/15.
//  Copyright (c) 2015 JCKortlang. All rights reserved.
//

#import "AppointmentsTableViewController.h"
#import "AppointmentManager.h"

@interface AppointmentsTableViewController ()

@property long firstAppointmentTime;
@property NSNumber* selectedIndex;

@end

@implementation AppointmentsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //Only one reservation at a time.
    self.tableView.allowsMultipleSelection = false;
    
    self.firstAppointmentTime = START_TIMESLOT;
    
    UINib *cellNib = [UINib nibWithNibName:APPOINTMENT_CELL_IDENTIFIER bundle:nil];
    [self.tableView registerNib:cellNib forCellReuseIdentifier:APPOINTMENT_CELL_IDENTIFIER];
    
    //Set the NavItem title to the date.
    self.navigationItem.title = [Appointment dateOnlyDescriptionFromDate:self.selectedDate];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)reserveButtonClicked:(id)sender
{
    [[AppointmentManager getInstance] scheduleAppointmentOn:self.selectedDate ForTimeslot:self.selectedIndex WithCallback:^(bool success) {
        if(success)
        {
            //Inefficient.
            [self.tableView reloadData];
        }
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return TIMESLOT_COUNT;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* MyIdentifier = APPOINTMENT_CELL_IDENTIFIER;
    
    AppointmentTableViewCell *cell = (AppointmentTableViewCell*)[tableView dequeueReusableCellWithIdentifier:MyIdentifier forIndexPath:indexPath];
    
    if(cell == nil)
    {
        //We create the style.
        NSArray* nib = [[NSBundle mainBundle] loadNibNamed:MyIdentifier owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    NSNumber* index = [[NSNumber alloc] initWithInteger:indexPath.row];
    
    cell.delegate = self;
    cell.timeSlot = index;
    cell.isAvailable = [[AppointmentManager getInstance] checkTimeslotAvailability:cell.timeSlot];
    
    if (!cell.isAvailable)
    {
        cell.availableMessage.text = @"Reserved";
        cell.availableMessage.textColor = [[UIColor alloc] initWithRed:255 green:0 blue:0 alpha:1];
    }
    
    cell.time.text = [Appointment timeDescriptionFromStartingTime:self.firstAppointmentTime WithTimeslot:indexPath.row];
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectedIndex = [[NSNumber alloc] initWithInteger:indexPath.row];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

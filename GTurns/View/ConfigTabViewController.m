//
//  ConfigTabViewController.m
//  GTurns
//
//  Created by Matt Higgins on 5/15/13.
//  Copyright (c) 2013 Matt Higgins. All rights reserved.
//

#import "ConfigTabViewController.h"

@interface ConfigTabViewController () <BTManagerDelegate>
    @property (strong) BTManager *btManager;
@end

@implementation ConfigTabViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
            }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.btManager = [BTManager sharedInstance];
    self.btManager.delegate = self;

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - BTManagerDelegate
-(void)didDiscoverPerhipheral:(CBPeripheral *)peripheral
{
    NSLog(@"Found something reload table view please");
    [self.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
}
-(void)didActivatePerhipheral:(CBPeripheral *)peripheral
{
    NSLog(@"Found something reload table view please");
    [self.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0){
        return self.btManager.managedPeripherals.count;
    } else {
        return self.btManager.discoveredPeripherals.count;
    }

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:[NSString stringWithFormat:@"cell-%d",indexPath.row]];
    
    CBPeripheral *peripheral = [[CBPeripheral alloc]init];
    if(indexPath.section == 0){
        if(self.btManager.managedPeripherals || !self.btManager.managedPeripherals.count){
            peripheral = [self.btManager.managedPeripherals objectAtIndex:indexPath.row];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
    } else {
        if(self.btManager.discoveredPeripherals && self.btManager.discoveredPeripherals.count){
            peripheral = [self.btManager.discoveredPeripherals objectAtIndex:indexPath.row];
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.editingAccessoryType = UITableViewCellAccessoryCheckmark;

        }
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%@",peripheral.name];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",CFUUIDCreateString(nil, peripheral.UUID)];
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(indexPath.section == 0){
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
    } else {
        [self.btManager addManagedPeripheral:[self.btManager.discoveredPeripherals objectAtIndex:indexPath.row]];
    }
    
}
-(NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        if(self.btManager.managedPeripherals.count > 0){
            if(self.btManager.managedPeripherals.count > 1){
                return [NSString stringWithFormat:@"%d Active TI Sensor Tags", self.btManager.managedPeripherals.count];
            } else {
                return [NSString stringWithFormat:@"%d Active TI Sensor Tag", self.btManager.managedPeripherals.count];
            }
        } else {
            return @"No Active TI Sensor Tags Found";
        }
    } else {
        if(self.btManager.discoveredPeripherals.count > 0){
            if(self.btManager.discoveredPeripherals.count > 1){
                return [NSString stringWithFormat:@"%d New TI Sensor Tags Discovered\nClick To Add", self.btManager.discoveredPeripherals.count];
            } else {
                return [NSString stringWithFormat:@"%d New TI Sensor Tag Discovered\nClick To Add", self.btManager.discoveredPeripherals.count];
            }
        } else {
            return @"No New TI Sensor Tags Discovered";
        }
        
    }
    
    return @"";
}
@end

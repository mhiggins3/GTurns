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
    
}

- (void) viewWillAppear:(BOOL)animated
{
    [self.btManager startScan];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Rotation
-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft);
}
#pragma mark - BTManagerDelegate
-(void)didDiscoverPerhipheral:(CBPeripheral *)peripheral
{
    [self.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
}
-(void)didActivatePerhipheral:(CBPeripheral *)peripheral
{
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

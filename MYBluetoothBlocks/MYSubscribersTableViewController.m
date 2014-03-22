//
//  MYSubscribersTableViewController.m
//  MYBluetoothBlocks
//
//  Created by masafumi yoshida on 2014/03/22.
//  Copyright (c) 2014年 masafumi yoshida. All rights reserved.
//

#import "MYSubscribersTableViewController.h"
#import "MYBluetoothBlocks.h"
#import "MYSubscriberViewController.h"
@interface MYSubscribersTableViewController ()

@end

@implementation MYSubscribersTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.tableView reloadData];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  [MYBluetoothBlocksServer shared].subscribers.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    MYBluetoothBlocksSubscriber *subscriber = [[MYBluetoothBlocksServer shared].subscribers objectAtIndex:indexPath.row];
    cell.textLabel.text = subscriber.central.identifier.UUIDString;
    
    return cell;
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    MYSubscriberViewController *viewController = [segue destinationViewController];
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    viewController.rowIndex = indexPath.row; 
}

@end

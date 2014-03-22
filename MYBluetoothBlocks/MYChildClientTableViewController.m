//
//  MYChildClientTableViewController.m
//  MYBluetoothBlocks
//
//  Created by masafumi yoshida on 2014/03/22.
//  Copyright (c) 2014年 masafumi yoshida. All rights reserved.
//

#import "MYChildClientTableViewController.h"
#import "MYBluetoothBlocks.h"
#import "MYChildClientViewController.h"

@interface MYChildClientTableViewController ()

@end

@implementation MYChildClientTableViewController

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
    return  [MYBluetoothBlocksClient shared].childClients.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    MYBluetoothBlocksClient *child = [[MYBluetoothBlocksClient shared].childClients objectAtIndex:indexPath.row];
    
    cell.textLabel.text = child.service.UUID.UUIDString;
    
    return cell;
}


- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    MYChildClientViewController *viewController = [segue destinationViewController];
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    viewController.rowIndex = indexPath.row;
}


@end

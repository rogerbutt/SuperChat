//
//  ChatTableViewController.m
//  experiment3
//
//  Created by Andrew Luu on 8/5/15.
//  Copyright (c) 2015 RogerButt. All rights reserved.
//

#import "ChatTableViewController.h"

@implementation ChatTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.conversations = [[NSMutableArray alloc] init];
    [self.conversations addObject:@"Jordy"];
    [self.conversations addObject:@"Marshall"];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    self.chatViewController = [[ChatViewController alloc] init];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.conversations count];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Conversation Cell"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Conversation Cell"];
    }
    
    NSString *name = [self.conversations objectAtIndex:indexPath.row];
    cell.textLabel.text = name;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.navigationController pushViewController:self.chatViewController animated:YES];
}

@end

//
//  ChatTableViewController.h
//  experiment3
//
//  Created by Andrew Luu on 8/5/15.
//  Copyright (c) 2015 RogerButt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChatViewController.h"

@interface ChatTableViewController : UITableViewController

@property (strong, nonatomic) NSMutableArray *conversations;
@property (strong, nonatomic) ChatViewController *chatViewController;

@end

//
//  ChatData.m
//  experiment3
//
//  Created by Andrew Luu on 8/4/15.
//  Copyright (c) 2015 RogerButt. All rights reserved.
//

#import "ChatData.h"

@implementation ChatData

- (void)addObject:(NSObject*)anObj
{
    if (!self.data) {
        self.data = [[NSMutableArray alloc] init];
    }
    [self.data addObject:anObj];
}

@end

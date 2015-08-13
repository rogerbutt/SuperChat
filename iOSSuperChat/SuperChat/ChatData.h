//
//  ChatData.h
//  experiment3
//
//  Created by Andrew Luu on 8/4/15.
//  Copyright (c) 2015 RogerButt. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChatData : NSObject

@property (strong, nonatomic) NSMutableArray* data;

- (void)addObject:(NSObject*)anObj;

@end

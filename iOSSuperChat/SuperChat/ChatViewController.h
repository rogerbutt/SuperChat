//
//  ChatViewController.h
//  experiment3
//
//  Created by Andrew Luu on 8/3/15.
//  Copyright (c) 2015 RogerButt. All rights reserved.
//

#import "JSQMessages.h"
#import "SRWebSocket.h"
#import "ChatData.h"
#import "JSQMessagesViewController.h"


@class ChatViewController;

@protocol ChatViewControllerDelegate <NSObject>

- (void)didDismissJSQDemoViewController:(ChatViewController *)vc;

@end



@interface ChatViewController : JSQMessagesViewController <SRWebSocketDelegate, UIActionSheetDelegate>

@property (weak, nonatomic) id<ChatViewControllerDelegate> delegateModal;

@property (strong, nonatomic) NSMutableArray *chatData;

@property (strong, nonatomic) JSQMessagesBubbleImage *outgoingBubbleImageData;

@property (strong, nonatomic) JSQMessagesBubbleImage *incomingBubbleImageData;

- (void)receiveMessagePressed:(UIBarButtonItem *)sender;

- (void)closePressed:(UIBarButtonItem *)sender;

@end

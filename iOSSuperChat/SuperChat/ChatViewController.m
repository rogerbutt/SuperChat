//
//  ChatViewController.m
//  experiment3
//
//  Created by Andrew Luu on 8/3/15.
//  Copyright (c) 2015 RogerButt. All rights reserved.
//

#import "ChatViewController.h"
#import "JSQSystemSoundPlayer.h"

@implementation ChatViewController {
    SRWebSocket* websocket;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"SuperChat";
    
    // Should be unique
    self.senderId = @"Andy";
    self.senderDisplayName = @"Andy";
    
    self.automaticallyScrollsToMostRecentMessage = YES;
    self.showLoadEarlierMessagesHeader = YES;
    
    self.chatData = [[NSMutableArray alloc] init];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage jsq_defaultTypingIndicatorImage]
                                                                              style:UIBarButtonItemStyleBordered
                                                                             target:self
                                                                             action:@selector(receiveMessagePressed:)];
    
    JSQMessagesBubbleImageFactory *bubbleFactory = [[JSQMessagesBubbleImageFactory alloc] init];
    
    self.outgoingBubbleImageData = [bubbleFactory outgoingMessagesBubbleImageWithColor:[UIColor jsq_messageBubbleLightGrayColor]];
    self.incomingBubbleImageData = [bubbleFactory incomingMessagesBubbleImageWithColor:[UIColor jsq_messageBubbleGreenColor]];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (self.delegateModal) {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop
                                                                                              target:self
                                                                                              action:@selector(closePressed:)];
    }
    
    self->websocket.delegate = nil;
    [self->websocket close];
    
    self->websocket = [[SRWebSocket alloc] initWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"ws://localhost:3000"]]];
    self->websocket.delegate = self;
    [self->websocket open];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    self->websocket.delegate = nil;
    [self->websocket close];
}

- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message {
    NSLog(@"Message: %@", message);
    NSData* data = [message dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *messageMap = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    
    NSTimeInterval seconds = [messageMap[@"time"] doubleValue];
    NSDate* time = [NSDate dateWithTimeIntervalSince1970:seconds];
    
    JSQMessage *messageObj = [[JSQMessage alloc] initWithSenderId:messageMap[@"username"]
                                             senderDisplayName:messageMap[@"username"]
                                                             date:time
                                                             text:messageMap[@"message"]];
    [JSQSystemSoundPlayer jsq_playMessageSentSound];
    
    [self.chatData addObject:messageObj];
    [self finishReceivingMessageAnimated:YES];
}

- (void)webSocketDidOpen:(SRWebSocket *)webSocket {
    NSLog(@"Opened");
    
    [self->websocket send:self.senderId];
}

- (void)didPressSendButton:(UIButton *)button withMessageText:(NSString *)text senderId:(NSString *)senderId senderDisplayName:(NSString *)senderDisplayName date:(NSDate *)date {
    
    [JSQSystemSoundPlayer jsq_playMessageSentSound];
    
    JSQMessage *message = [[JSQMessage alloc] initWithSenderId:senderId
                                             senderDisplayName:senderDisplayName
                                                          date:date
                                                          text:text];
    
    [self.chatData addObject:message];
    
    
    NSLog(@"%@", text);
    [self->websocket send:text];
    [self finishSendingMessageAnimated:YES];
}



- (id<JSQMessageData>)collectionView:(JSQMessagesCollectionView *)collectionView messageDataForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.chatData objectAtIndex:indexPath.item];
}


- (id<JSQMessageBubbleImageDataSource>)collectionView:(JSQMessagesCollectionView *)collectionView messageBubbleImageDataForItemAtIndexPath:(NSIndexPath *)indexPath
{
    JSQMessage *message = [self.chatData objectAtIndex:indexPath.item];
    
    if ([message.senderId isEqualToString:self.senderId]) {
        return self.outgoingBubbleImageData;
    }
    
    return self.incomingBubbleImageData;
}

- (id<JSQMessageAvatarImageDataSource>)collectionView:(JSQMessagesCollectionView *)collectionView avatarImageDataForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

- (NSAttributedString *)collectionView:(JSQMessagesCollectionView *)collectionView attributedTextForCellBottomLabelAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.item % 3 == 0) {
        JSQMessage *message = [self.chatData objectAtIndex:indexPath.item];
        return [[JSQMessagesTimestampFormatter sharedFormatter] attributedTimestampForDate:message.date];
    }
    
    return nil;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.chatData count];
}

- (void)receiveMessagePressed:(UIBarButtonItem *)sender {
    
}

- (void)closePressed:(UIBarButtonItem *)sender {
    
}

@end

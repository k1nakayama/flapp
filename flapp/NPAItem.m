//
//  NPAItem.m
//
//  Created by Thanh  Ta on 5/19/14.
//  Copyright (c) 2014 BeetSoft. All rights reserved.
//

#import "NPAItem.h"

@implementation NPAItem

@synthesize itemType = _itemType;
@synthesize position = _postion;


- (id)init {
    if (self = [super init]) {
        return self;
    }
    
    return nil;
}

- (instancetype)itemWithType:(NPAItemType)itemType {
    //NSLog(@"itemTyp%lu%u",itemType);
    if ([self init]) {
        self.itemType = itemType;
        return self;
    }
    return nil;
}

- (void)moveToPosition:(CGPoint)target atView:(UIView*)superView {
    [UIView beginAnimations:@"Move" context:nil];
    
    [UIView animateWithDuration:0.8f
                          delay:0.0f
                        options:UIViewAnimationOptionTransitionNone
                     animations:^{
                         CGRect frame = CGRectMake(self.position.x, self.position.y, self.image.size.width, self.image.size.height);
                         frame.origin.x = target.x - self.image.size.width * 0.5;
                         frame.origin.y = target.y;
                         
                         self.frame = frame;
                         
                         self.transform = CGAffineTransformScale(self.transform, 2.0, 2.0);
                     }
                     completion:^(BOOL finish){
                         if (finish) {
                             if ([self.delegate respondsToSelector:@selector(finishAnimation:withItem:)]) {
                                 [self.delegate finishAnimation:@"Move" withItem:self];
                             }
                         }
                     }];
    
    [UIView commitAnimations];
}

@end

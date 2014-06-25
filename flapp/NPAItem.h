//
//  NPAItem.h
//
//  Created by Thanh  Ta on 5/19/14.
//  Copyright (c) 2014 BeetSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

typedef enum : NSUInteger {
    kItemNone       = 0,
    kItem10         = 1,
    kItem50         = 2,
    kItem100        = 3,
    kItem500        = 4,
    kItem1000       = 5,
    kItem10000      = 6
} NPAItemType;

#define ArrayItemName     @[@"10.png",@"50.png",@"100.png",@"500.png",@"1000.png",@"10000.png"]

@class NPAItem;

@protocol NPAItemDelegate <NSObject>

- (void)finishAnimation:(NSString*)name withItem:(NPAItem*)item;

@end

@interface NPAItem : UIImageView {
    NPAItemType _itemType;
    CGPoint _postion;
}

@property (nonatomic, assign) NPAItemType itemType;
@property (nonatomic, assign) CGPoint position;

@property (nonatomic, assign) id<NPAItemDelegate> delegate;

/**
 *	@brief	method create instance object
 *
 *	@param 	itemType 	NPAItemType
 *
 *	@return	instancetype
 */
- (instancetype)itemWithType:(NPAItemType)itemType;


/**
 *	@brief	Change item's position
 *
 *	@param 	target 	It is location, that item is moved to.
 *	@param 	superView It is parent view.
 *
 *	@return	void
 */
- (void)moveToPosition:(CGPoint)target atView:(UIView*)superView
;

@end

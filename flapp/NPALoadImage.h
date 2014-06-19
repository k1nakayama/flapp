//
//  NPALoadImage.h
//
//  Created by Thanh  Ta on 5/20/14.
//  Copyright (c) 2014 BeetSoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NPALoadImage : UIImage
/**
 *	@brief	Using to load background image
 *
 *	@param 	name 	Image's name without extension ".png"
 *	@param 	flag 	Using define IS_WIDESCREEN
 *
 *	@return	UIImage
 */
+ (UIImage *)imageNamed:(NSString *)name isWideScreen:(BOOL)flag
;
@end

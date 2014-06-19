//
//  NPALoadImage.m
//
//  Created by Thanh  Ta on 5/20/14.
//  Copyright (c) 2014 BeetSoft. All rights reserved.
//

#import "NPALoadImage.h"

@implementation NPALoadImage

+ (UIImage *)imageNamed:(NSString *)name isWideScreen:(BOOL)flag {
    
    if (flag)
        name = [name stringByAppendingString:@"_ip5.png"];
    else
        name = [name stringByAppendingString:@".png"];
    
    return [UIImage imageNamed:name];
}

@end

//
//  AppApiUtil.h
//  testApp031105
//
//  Created by 中山桂一 on 2014/03/12.
//  Copyright (c) 2014年 Pocket Solution Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBProgressHUD.h"

@interface AppApiUtil : NSObject

-(NSArray *) getBanner:(NSString *)category sort:(NSString *)sort;
-(NSArray *) getRecommended;
-(NSString *) registUser;
-(NSDictionary *) getUserInfo;
-(NSDictionary *) sendAuthCode:(NSString *)phonenumber;
-(NSDictionary *) checkAuthCode:(NSString *)auth_code;
-(NSDictionary *) orderExchange:(NSArray *)order_detail;
-(NSDictionary *) getGiftInfo;
-(NSDictionary *) registNotification: (NSData *)token;
-(NSDictionary *) checkNewPoint;

-(NSArray *) getBanner;
-(NSString *) dateWithMyFormat:(NSDate *)date;
-(NSString *) dateWithMyFormat;
-(NSString *) createSignature:(NSMutableArray *)param_list;
-(NSString *) sha1:(NSString *)str;
-(NSData *) createJsonObject:(NSMutableDictionary *)param_list;
-(NSDictionary *) requestApiWithRequestUrl:(NSString *)request_url json:(NSData *)json_data;
-(NSString *) getUuid;
-(NSString *) getUserId;

@end

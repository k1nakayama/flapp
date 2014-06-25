//
//  AppApiUtil.m
//  testApp031105
//
//  Created by 中山桂一 on 2014/03/12.
//  Copyright (c) 2014年 Pocket Solution Inc. All rights reserved.
//

#import "AppApiUtil.h"
#import <CommonCrypto/CommonDigest.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>

@implementation AppApiUtil{
    NSString *site_code;
}

//getBannerAPIを実行しパース済みの配列を返却する
-(NSArray *)getBanner:(NSString *) category sort:(NSString *)sort{
    site_code = SITE_CODE;
    // TODO: "User_idの取得を書く"
    NSString *user_id = [self getUserId];
    //NSString *user_id = @"123456789012345";
    NSString *date = [self dateWithMyFormat];
    //NSString *signature = @"aaa";
    
    CTTelephonyNetworkInfo *netinfo = [[CTTelephonyNetworkInfo alloc] init];
    CTCarrier *carrier = [netinfo subscriberCellularProvider];
    //NSLog(@"getBanner Carrier: %@",carrier);
    
    NSString *carrierName;
    if([carrier.mobileNetworkCode isEqualToString:@"00"]) {
        carrierName = @"EMOBILE";
    } else if([carrier.mobileNetworkCode isEqualToString:@"10"]){
        carrierName = @"DOCOMO";
    } else if([carrier.mobileNetworkCode isEqualToString:@"20"]){
        carrierName = @"SOFTBANK";
    } else if([carrier.mobileNetworkCode isEqualToString:@"50"]){
        carrierName = @"KDDI";
    } else if([carrier.mobileNetworkCode isEqualToString:@"54"]){
        carrierName = @"KDDI";
    } else {
        carrierName = @"OTHER";
    }

    //パラメータの配列を作成
    //NSMutableDictionary *param_list = [NSMutableDictionary dictionaryWithObjectsAndKeys:site_code,
    //@"site_code",user_id,@"user_id",category,@"category",sort,@"sort",date, @"transaction_date",nil];
    NSMutableDictionary *param_list = [NSMutableDictionary dictionaryWithObjectsAndKeys:site_code,
    @"site_code",user_id,@"user_id",carrierName,@"carrier",date, @"transaction_date",nil];
    NSMutableArray *param_list2 = [[NSMutableArray alloc]init];
    [param_list2 insertObject:[param_list objectForKey:@"site_code"] atIndex:0];
    [param_list2 insertObject:[param_list objectForKey:@"user_id"] atIndex:1];
    //[param_list2 insertObject:[param_list objectForKey:@"category"] atIndex:2];
    //[param_list2 insertObject:[param_list objectForKey:@"sort"] atIndex:3];
    [param_list2 insertObject:[param_list objectForKey:@"carrier"] atIndex:2];
    [param_list2 insertObject:[param_list objectForKey:@"transaction_date"] atIndex:3];
    NSString *signature = [self createSignature:param_list2];
    [param_list setObject:signature forKey:@"signature"];
    NSData *json_data = [self createJsonObject:param_list];
    NSDictionary *jsonObj = [self requestApiWithRequestUrl:@"http://pc.flapp.pbase.pocket.ph/api/getBanner" json:json_data];
    
    NSString *status_code = [jsonObj objectForKey:@"status_code"];
    NSString *detail_code = [jsonObj objectForKey:@"detail_code"];
    if ([status_code isEqualToString:@"OK"]) {
        if ([detail_code isEqualToString:@"00"]) {
            if ([[jsonObj allKeys] containsObject:@"bannerInfo"]) {
                NSArray *bannerInfo = [jsonObj objectForKey:@"bannerInfo"];
                return bannerInfo;
            } else {
                // TODO: バナー情報が正常に取得できたが空の場合の例外処理
                return nil;
            }
        } else {
            // TODO: OKなのに00じゃない処理
            return nil;
        }
    }
    // TODO: バナー情報取得APIで取得できない例外
    return nil;
}
//getRecommendAPIを実行しパース済みの配列を返却する
-(NSArray *)getRecommended{
    site_code = SITE_CODE;
    // TODO: "User_idの取得を書く"
    NSString *user_id = [self getUserId];
    //NSString *user_id = @"123456789012345";
    NSString *date = [self dateWithMyFormat];
    //NSString *signature = @"aaa";

    CTTelephonyNetworkInfo *netinfo = [[CTTelephonyNetworkInfo alloc] init];
    CTCarrier *carrier = [netinfo subscriberCellularProvider];
    NSLog(@"getBanner Carrier: %@",carrier);
    
    NSString *carrierName;
    if([carrier.mobileNetworkCode isEqualToString:@"00"]) {
        carrierName = @"EMOBILE";
    } else if([carrier.mobileNetworkCode isEqualToString:@"10"]){
        carrierName = @"DOCOMO";
    } else if([carrier.mobileNetworkCode isEqualToString:@"20"]){
        carrierName = @"SOFTBANK";
    } else if([carrier.mobileNetworkCode isEqualToString:@"50"]){
        carrierName = @"KDDI";
    } else if([carrier.mobileNetworkCode isEqualToString:@"54"]){
        carrierName = @"KDDI";
    } else {
        carrierName = @"OTHER";
    }
    
    //パラメータの配列を作成
    NSMutableDictionary *param_list = [NSMutableDictionary dictionaryWithObjectsAndKeys:site_code,
                                       @"site_code",user_id,@"user_id",carrierName,@"carrier",date, @"transaction_date",nil];
    
    NSMutableArray *param_list2 = [[NSMutableArray alloc]init];
    [param_list2 insertObject:[param_list objectForKey:@"site_code"] atIndex:0];
    [param_list2 insertObject:[param_list objectForKey:@"user_id"] atIndex:1];
    [param_list2 insertObject:[param_list objectForKey:@"carrier"] atIndex:2];
    [param_list2 insertObject:[param_list objectForKey:@"transaction_date"] atIndex:3];
    NSString *signature = [self createSignature:param_list2];
    [param_list setObject:signature forKey:@"signature"];
    NSData *json_data = [self createJsonObject:param_list];

    NSDictionary *jsonObj = [self requestApiWithRequestUrl:@"http://pc.flapp.pbase.pocket.ph/api/getRecommended" json:json_data];

    NSString *status_code = [jsonObj objectForKey:@"status_code"];
    NSString *detail_code = [jsonObj objectForKey:@"detail_code"];
    if ([status_code isEqualToString:@"OK"]) {
        if ([detail_code isEqualToString:@"00"]) {
            if ([[jsonObj allKeys] containsObject:@"bannerInfo"]) {
                NSArray *bannerInfo = [jsonObj objectForKey:@"bannerInfo"];
                return bannerInfo;
            } else {
                // TODO: バナー情報が正常に取得できたが空の場合の例外処理
                return nil;
            }
        } else {
            // TODO: OKなのに00じゃない処理
            return nil;
        }
    }
    // TODO: バナー情報取得APIで取得できない例外
    return nil;
}

//ユーザー登録
-(NSString *)registUser{
    site_code = SITE_CODE;
    NSString *date = [self dateWithMyFormat];
    //uuidの取得
    NSString *uuid = [self getUuid];
    NSString *os = @"iOS";
    NSString *term = [NSString stringWithFormat:@"%@ %@",[UIDevice currentDevice].systemName,[UIDevice currentDevice].systemVersion];

    //パラメータの配列を作成
    NSMutableDictionary *param_list = [NSMutableDictionary dictionaryWithObjectsAndKeys:site_code,
                                       @"site_code",uuid,@"uuid",os,@"os",term,@"term",date, @"transaction_date",nil];
    
    NSMutableArray *param_list2 = [[NSMutableArray alloc]init];
    [param_list2 insertObject:[param_list objectForKey:@"site_code"] atIndex:0];
    [param_list2 insertObject:[param_list objectForKey:@"uuid"] atIndex:1];
    [param_list2 insertObject:[param_list objectForKey:@"os"] atIndex:2];
    [param_list2 insertObject:[param_list objectForKey:@"term"] atIndex:3];
    [param_list2 insertObject:[param_list objectForKey:@"transaction_date"] atIndex:4];
    NSString *signature = [self createSignature:param_list2];
    [param_list setObject:signature forKey:@"signature"];
    NSData *json_data = [self createJsonObject:param_list];
    NSDictionary *jsonObj = [self requestApiWithRequestUrl:@"http://pc.flapp.pbase.pocket.ph/api/registUser" json:json_data];
    
    //NSLog(@"registUser: %@",jsonObj);

    NSString *status_code = [jsonObj objectForKey:@"status_code"];
    NSString *detail_code = [jsonObj objectForKey:@"detail_code"];
    if ([status_code isEqualToString:@"OK"]) {
        if ([detail_code isEqualToString:@"00"] || [detail_code isEqualToString:@"10"]) {
            NSString *user_id = [jsonObj objectForKey:@"user_id"];
            NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
            [ud setObject:user_id forKey:@"user_id"];
            [ud synchronize];
            return user_id;
        } else {
            // TODO: OKなのに00じゃない処理
            return nil;
        }
    }
    // TODO: バナー情報取得APIで取得できない例外
    return nil;
}

//ユーザー情報の取得
-(NSDictionary *)getUserInfo{
    site_code = SITE_CODE;
    NSString *date = [self dateWithMyFormat];
    //user_idの取得
    NSString *user_id = [self getUserId];
    //uuidの取得
    NSString *uuid = [self getUuid];
    
    //パラメータの配列を作成
    NSMutableDictionary *param_list = [NSMutableDictionary dictionaryWithObjectsAndKeys:site_code,
                                       @"site_code",user_id,@"user_id",uuid,@"uuid",date, @"transaction_date",nil];
    
    NSMutableArray *param_list2 = [[NSMutableArray alloc]init];
    [param_list2 insertObject:[param_list objectForKey:@"site_code"] atIndex:0];
    [param_list2 insertObject:[param_list objectForKey:@"user_id"] atIndex:1];
    [param_list2 insertObject:[param_list objectForKey:@"uuid"] atIndex:2];
    [param_list2 insertObject:[param_list objectForKey:@"transaction_date"] atIndex:3];
    NSString *signature = [self createSignature:param_list2];
    [param_list setObject:signature forKey:@"signature"];
    NSData *json_data = [self createJsonObject:param_list];
    NSDictionary *jsonObj = [self requestApiWithRequestUrl:@"http://pc.flapp.pbase.pocket.ph/api/getUserInfo" json:json_data];
    
    //NSLog(@"getUserInfo: %@",jsonObj);
    
    NSString *status_code = [jsonObj objectForKey:@"status_code"];
    NSString *detail_code = [jsonObj objectForKey:@"detail_code"];
    if ([status_code isEqualToString:@"OK"]) {
        if ([detail_code isEqualToString:@"00"]) {
            return jsonObj;
        } else {
            // TODO: OKなのに00じゃない処理
            return nil;
        }
    }
    // TODO: バナー情報取得APIで取得できない例外
    return nil;
}
-(NSDictionary *)sendAuthCode:(NSString *)phonenumber{
    site_code = SITE_CODE;
    NSString *date = [self dateWithMyFormat];
    //user_idの取得
    NSString *user_id = [self getUserId];
    
    
    //パラメータの配列を作成
    NSMutableDictionary *param_list = [NSMutableDictionary dictionaryWithObjectsAndKeys:site_code,
                                       @"site_code",user_id,@"user_id",phonenumber,@"phone_number",date, @"transaction_date",nil];
    
    NSMutableArray *param_list2 = [[NSMutableArray alloc]init];
    [param_list2 insertObject:[param_list objectForKey:@"site_code"] atIndex:0];
    [param_list2 insertObject:[param_list objectForKey:@"user_id"] atIndex:1];
    [param_list2 insertObject:[param_list objectForKey:@"phone_number"] atIndex:2];
    [param_list2 insertObject:[param_list objectForKey:@"transaction_date"] atIndex:3];
    NSString *signature = [self createSignature:param_list2];
    [param_list setObject:signature forKey:@"signature"];
    NSData *json_data = [self createJsonObject:param_list];
    NSDictionary *jsonObj = [self requestApiWithRequestUrl:@"http://pc.flapp.pbase.pocket.ph/api/sendAuthCode" json:json_data];
    
    NSLog(@"sendAuthCode: %@",jsonObj);
    
    NSString *status_code = [jsonObj objectForKey:@"status_code"];
    NSString *detail_code = [jsonObj objectForKey:@"detail_code"];
    if ([status_code isEqualToString:@"OK"]) {
        if ([detail_code isEqualToString:@"00"]) {
            return jsonObj;
        } else {
            // TODO: OKなのに00じゃない処理
            return nil;
        }
    }
    // TODO: バナー情報取得APIで取得できない例外
    return nil;


}

//SMS認証承認API
-(NSDictionary *)checkAuthCode:(NSString *)auth_code{
    site_code = SITE_CODE;
    NSString *date = [self dateWithMyFormat];
    //user_idの取得
    NSString *user_id = [self getUserId];
    
    
    //パラメータの配列を作成
    NSMutableDictionary *param_list = [NSMutableDictionary dictionaryWithObjectsAndKeys:site_code,
                                       @"site_code",user_id,@"user_id",auth_code,@"auth_code",date, @"transaction_date",nil];
    
    NSMutableArray *param_list2 = [[NSMutableArray alloc]init];
    [param_list2 insertObject:[param_list objectForKey:@"site_code"] atIndex:0];
    [param_list2 insertObject:[param_list objectForKey:@"user_id"] atIndex:1];
    [param_list2 insertObject:[param_list objectForKey:@"auth_code"] atIndex:2];
    [param_list2 insertObject:[param_list objectForKey:@"transaction_date"] atIndex:3];
    NSString *signature = [self createSignature:param_list2];
    [param_list setObject:signature forKey:@"signature"];
    NSData *json_data = [self createJsonObject:param_list];
    NSDictionary *jsonObj = [self requestApiWithRequestUrl:@"http://pc.flapp.pbase.pocket.ph/api/checkAuthCode" json:json_data];
    
    NSLog(@"checkAuthCode: %@",jsonObj);
    
    NSString *status_code = [jsonObj objectForKey:@"status_code"];
    NSString *detail_code = [jsonObj objectForKey:@"detail_code"];
    if ([status_code isEqualToString:@"OK"]) {
        if ([detail_code isEqualToString:@"00"]) {
            return jsonObj;
        } else {
            // TODO: OKなのに00じゃない処理
            return nil;
        }
    }
    // TODO: バナー情報取得APIで取得できない例外
    return nil;
}

//ギフト交換API
-(NSDictionary *)orderExchange:(NSArray *)order_detail{
    site_code = SITE_CODE;
    NSString *date = [self dateWithMyFormat];
    //user_idの取得
    NSString *user_id = [self getUserId];
    
    
    //パラメータの配列を作成
    NSMutableDictionary *param_list = [NSMutableDictionary dictionaryWithObjectsAndKeys:site_code,
                                       @"site_code",user_id,@"user_id",date, @"transaction_date",nil];
    
    NSMutableArray *param_list2 = [[NSMutableArray alloc]init];
    [param_list2 insertObject:[param_list objectForKey:@"site_code"] atIndex:0];
    [param_list2 insertObject:[param_list objectForKey:@"user_id"] atIndex:1];
    [param_list2 insertObject:[param_list objectForKey:@"transaction_date"] atIndex:2];
    NSString *signature = [self createSignature:param_list2];
    [param_list setObject:signature forKey:@"signature"];
    [param_list setObject:order_detail forKey:@"eme_detail"];
    
    NSData *json_data = [self createJsonObject:param_list];
    NSDictionary *jsonObj = [self requestApiWithRequestUrl:@"http://pc.flapp.pbase.pocket.ph/api/orderExchange" json:json_data];
    
    NSLog(@"orderExchange: %@",jsonObj);
    
    NSString *status_code = [jsonObj objectForKey:@"status_code"];
    NSString *detail_code = [jsonObj objectForKey:@"detail_code"];
    if ([status_code isEqualToString:@"OK"]) {
        if ([detail_code isEqualToString:@"00"]) {
            return jsonObj;
        } else {
            // TODO: OKなのに00じゃない処理
            return nil;
        }
    }
    // TODO: バナー情報取得APIで取得できない例外
    return nil;
}

//ギフト情報取得API
-(NSDictionary *)getGiftInfo{
    site_code = SITE_CODE;
    NSString *date = [self dateWithMyFormat];
    //user_idの取得
    NSString *user_id = [self getUserId];
    
    
    //パラメータの配列を作成
    NSMutableDictionary *param_list = [NSMutableDictionary dictionaryWithObjectsAndKeys:site_code,
                                       @"site_code",user_id,@"user_id",date, @"transaction_date",nil];
    
    NSMutableArray *param_list2 = [[NSMutableArray alloc]init];
    [param_list2 insertObject:[param_list objectForKey:@"site_code"] atIndex:0];
    [param_list2 insertObject:[param_list objectForKey:@"user_id"] atIndex:1];
    [param_list2 insertObject:[param_list objectForKey:@"transaction_date"] atIndex:2];
    NSString *signature = [self createSignature:param_list2];
    [param_list setObject:signature forKey:@"signature"];
    NSData *json_data = [self createJsonObject:param_list];
    NSDictionary *jsonObj = [self requestApiWithRequestUrl:@"http://pc.flapp.pbase.pocket.ph/api/getGiftInfo" json:json_data];
    
    //NSLog(@"checkAuthCode: %@",jsonObj);
    
    NSString *status_code = [jsonObj objectForKey:@"status_code"];
    NSString *detail_code = [jsonObj objectForKey:@"detail_code"];
    if ([status_code isEqualToString:@"OK"]) {
        if ([detail_code isEqualToString:@"00"]) {
            return jsonObj;
        } else {
            // TODO: OKなのに00じゃない処理
            return nil;
        }
    }
    // TODO: バナー情報取得APIで取得できない例外
    return nil;
}

//通知登録API
-(NSDictionary *)registNotification:(NSData *)token{
    site_code = SITE_CODE;
    NSString *date = [self dateWithMyFormat];
    //user_idの取得
    NSString *user_id = [self getUserId];
    NSString *token_str = [[NSString alloc] initWithData:token encoding:NSUTF8StringEncoding];
    
    //パラメータの配列を作成
    NSMutableDictionary *param_list = [NSMutableDictionary dictionaryWithObjectsAndKeys:site_code,
                                       @"site_code",user_id,@"user_id",token_str,@"token",date, @"transaction_date",nil];
    
    NSMutableArray *param_list2 = [[NSMutableArray alloc]init];
    [param_list2 insertObject:[param_list objectForKey:@"site_code"] atIndex:0];
    [param_list2 insertObject:[param_list objectForKey:@"user_id"] atIndex:1];
    [param_list2 insertObject:[param_list objectForKey:@"token"] atIndex:2];
    [param_list2 insertObject:[param_list objectForKey:@"transaction_date"] atIndex:3];
    NSString *signature = [self createSignature:param_list2];
    [param_list setObject:signature forKey:@"signature"];
    
    NSData *json_data = [self createJsonObject:param_list];
    NSDictionary *jsonObj = [self requestApiWithRequestUrl:@"http://pc.flapp.pbase.pocket.ph/api/registNotification" json:json_data];
    
    NSLog(@"registNotification: %@",jsonObj);
    
    NSString *status_code = [jsonObj objectForKey:@"status_code"];
    NSString *detail_code = [jsonObj objectForKey:@"detail_code"];
    if ([status_code isEqualToString:@"OK"]) {
        if ([detail_code isEqualToString:@"00"]) {
            NSString *tokenkey = TOKEN_KEY;
            NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
            [ud setObject:token_str forKey:tokenkey];
            [ud synchronize];
            return jsonObj;
        } else {
            // TODO: OKなのに00じゃない処理
            return nil;
        }
    }
    // TODO: バナー情報取得APIで取得できない例外
    return nil;
}
-(NSDictionary *)checkNewPoint{
    site_code = SITE_CODE;
    NSString *date = [self dateWithMyFormat];
    //user_idの取得
    NSString *user_id = [self getUserId];
    NSString *check_key = CHECK_KEY;
    
    //UserDefaultに最終チェック日時があるか調べる
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *ud_check = [ud stringForKey:check_key];
    NSString *last_check;
    NSLog(@"checkNewPoint ud_check: %@",ud_check);
    if(ud_check){
        last_check = ud_check;
    } else {
        last_check = [self dateWithMyFormat];
    }
    
    //デバッグのため強制的に
    //last_check = @"2014-06-17 19:58:56";
    
    //パラメータの配列を作成
    NSMutableDictionary *param_list = [NSMutableDictionary dictionaryWithObjectsAndKeys:site_code,
                                       @"site_code",user_id,@"user_id",last_check,@"start_date",date, @"transaction_date",nil];
    
    NSMutableArray *param_list2 = [[NSMutableArray alloc]init];
    [param_list2 insertObject:[param_list objectForKey:@"site_code"] atIndex:0];
    [param_list2 insertObject:[param_list objectForKey:@"user_id"] atIndex:1];
    [param_list2 insertObject:[param_list objectForKey:@"start_date"] atIndex:2];
    [param_list2 insertObject:[param_list objectForKey:@"transaction_date"] atIndex:3];
    NSString *signature = [self createSignature:param_list2];
    [param_list setObject:signature forKey:@"signature"];
    NSData *json_data = [self createJsonObject:param_list];
    NSDictionary *jsonObj = [self requestApiWithRequestUrl:@"http://pc.flapp.pbase.pocket.ph/api/checkNewPoint" json:json_data];
    
    NSLog(@"checkNewPoint: %@",jsonObj);
    
    NSString *status_code = [jsonObj objectForKey:@"status_code"];
    NSString *detail_code = [jsonObj objectForKey:@"detail_code"];
    if ([status_code isEqualToString:@"OK"]) {
        if ([detail_code isEqualToString:@"00"]) {
            last_check = [self dateWithMyFormat];
            [ud setObject:last_check forKey:check_key];
            [ud synchronize];
            return jsonObj;
        } else if([detail_code isEqualToString:@"10"]) {
            last_check = [self dateWithMyFormat];
            [ud setObject:last_check forKey:check_key];
            [ud synchronize];
            return nil;
        } else {
            // TODO: OKなのに00じゃない処理
            return nil;
        }
    }
    // TODO: バナー情報取得APIで取得できない例外
    return nil;
}


//getBannerAPIを実行しパース済みの配列を返却する
-(NSArray *)getBanner{
    NSArray *bannerInfo = [self getBanner:@"DL" sort:@"NEW"];
    return bannerInfo;
}

//指定された時刻をYYYY-MM-DD HH:ii:ssフォーマットの文字列を返す
-(NSString *)dateWithMyFormat:(NSDate *)date{
    NSDateFormatter *outFormatter = [[NSDateFormatter alloc] init];
    [outFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *date_string = [outFormatter stringFromDate:date];
    return date_string;
}
//現在の時刻でdateWithFormatを実行する
-(NSString *)dateWithMyFormat{
    NSDate *now = [NSDate date];
    NSString *date_string = [self dateWithMyFormat:now];
    return date_string;
}
//パラメータリストの配列からシグニチャを生成する
-(NSString *)createSignature:(NSMutableArray *)param_list{
    //受け取ったパラメータリストの文字列をすべて連結する
    NSString *signature_str = @"";
    for (int i=0; i < [param_list count]; i++) {
        signature_str = [signature_str stringByAppendingString:[param_list objectAtIndex:i]];
    }
    //連結した文字列の最後にAPIKEYをつける
    signature_str = [signature_str stringByAppendingString:API_KEY];
    //NSLog(@"signature_str: %@",signature_str);
    NSString *signature = [self sha1:signature_str];
    
    return signature;
}
-(NSString *)sha1:(NSString *)str{
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    CC_SHA1(data.bytes,(CC_LONG)data.length,digest);
    NSMutableString *signature = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    for(int i=0;i < CC_SHA1_DIGEST_LENGTH; i++){
        [signature appendFormat:@"%02x",digest[i]];
    }
    //NSLog(@"signature: %@",signature);
    return signature;
}
-(NSData *)createJsonObject:(NSMutableDictionary *)param_list{
    NSError *json_error;
    NSData *json_string_raw = [NSJSONSerialization dataWithJSONObject:param_list options:0 error:&json_error];
    NSString *json_string = [[NSString alloc] initWithData:json_string_raw encoding:NSUTF8StringEncoding];
    NSLog(@"json_string: %@",json_string);
    NSData *json_data = [json_string dataUsingEncoding:NSUTF8StringEncoding];
    return json_data;
}
-(NSDictionary *)requestApiWithRequestUrl:(NSString *)request_url json:(NSData *)json_data{
    NSURL *api_url =[NSURL URLWithString:request_url];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:api_url];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:json_data];
    NSURLResponse *response;
    NSError *error;
    NSData *response_jsondata = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    NSLog(@"request_url: %@ error: %@",request_url,error);
    NSDictionary *jsonObj = [NSJSONSerialization JSONObjectWithData:response_jsondata options:NSJSONReadingAllowFragments error:nil];
    return jsonObj;
}
//UUIDを取得する
-(NSString *)getUuid{
    NSString *g_UUIDKey;
    NSString *uuid_key = UUID_KEY;
    
    //UserDefaultにUUIDがあるか調べる
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *ud_uuid = [ud stringForKey:uuid_key];
    if(ud_uuid){
        //NSLog(@"ud_uuid: %@",ud_uuid);
        g_UUIDKey = ud_uuid;
    } else {
        //キーチェーンの検索
        NSMutableDictionary *query = [NSMutableDictionary dictionary];
        [query setObject:(__bridge id)kSecClassGenericPassword forKey:(__bridge id)kSecClass];
        [query setObject:uuid_key forKey:(__bridge id)kSecAttrService];
        [query setObject:(__bridge id)kSecMatchLimitOne forKey:(__bridge id)kSecMatchLimit];
        [query setObject:(__bridge id)kCFBooleanTrue forKey:(__bridge id)kSecReturnAttributes];
    
        CFTypeRef ref = nil;
        OSStatus res = SecItemCopyMatching((__bridge CFDictionaryRef)query, &ref);
        
        // ある場合、読み込み
        if( res == noErr ){
            NSMutableDictionary *item = [NSMutableDictionary dictionaryWithDictionary:(__bridge NSDictionary *)ref];
            [item setObject:(__bridge id)kSecClassGenericPassword forKey:(__bridge id)kSecClass];
            [item setObject:(__bridge id)kCFBooleanTrue forKey:(__bridge id)kSecReturnData];
            
            CFTypeRef pass = nil;
            res = SecItemCopyMatching((__bridge CFDictionaryRef)item, &pass);
            if( res == noErr ){
                NSData *data = (__bridge NSData *)pass;
                g_UUIDKey = [[NSString alloc] initWithBytes:[data bytes] length:[data length] encoding:NSUTF8StringEncoding];
            }
        }else{
            // ない場合、新規登録
            // 新規作成
            CFUUIDRef uuidRef = CFUUIDCreate( kCFAllocatorDefault );
            CFStringRef uuidStr = CFUUIDCreateString( kCFAllocatorDefault, uuidRef );
            CFRelease( uuidRef );
            
            g_UUIDKey = [NSString stringWithFormat:@"%@", uuidStr];
            
            // キーチェイン登録
            NSMutableDictionary *item = [NSMutableDictionary dictionary];
            [item setObject:(__bridge id)kSecClassGenericPassword forKey:(__bridge id)kSecClass];
            [item setObject:uuid_key forKey:(__bridge id)kSecAttrService];
            [item setObject:[g_UUIDKey dataUsingEncoding:NSUTF8StringEncoding] forKey:(__bridge id)kSecValueData];
            
            SecItemAdd((__bridge CFDictionaryRef)item, nil);
            CFRelease( uuidStr );
        }
        //UserDefaultsに保存
        [ud setObject:g_UUIDKey forKey:uuid_key];
        [ud synchronize];
    }
    //
    //NSLog( @"%@", g_UUIDKey );
    return g_UUIDKey;
}

//user_idを取得する
-(NSString *)getUserId{
    NSString *g_uid;
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    g_uid = [ud stringForKey:@"user_id"];
    if(g_uid){
        return g_uid;
    } else {
        //ユーザーIDがないから新規ユーザー
        //ユーザー登録をする
        g_uid = [self registUser];
    }
    return g_uid;
}
@end

//
//  IssueGiftViewController.m
//  flapp
//
//  Created by 中山桂一 on 2014/03/26.
//  Copyright (c) 2014年 Pocket Solution Inc. All rights reserved.
//

#import "IssueGiftViewController.h"
#import "AppApiUtil.h"
#import "UIImageView+WebCache.h"

@interface IssueGiftViewController ()<UIActionSheetDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation IssueGiftViewController{
    NSDictionary *giftInfo;
    NSArray *giftList;
    NSDictionary *giftDetail;
}
@synthesize exchangeInfo;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"IssueGiftTableViewCell" bundle:nil] forCellReuseIdentifier:@"GiftCodeCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"IssueGiftTableDefaultCell" bundle:nil] forCellReuseIdentifier:@"DefaultCell"];
    
    self.navigationItem.title = @"交換完了";
    
    AppApiUtil *apiUtile = [[AppApiUtil alloc] init];
    giftInfo = [apiUtile getGiftInfo];
    giftList = [giftInfo objectForKey:@"gift_list"];

    NSArray *eme_detail = [exchangeInfo objectForKey:@"eme_detail"];
    NSDictionary *gift_list = [eme_detail objectAtIndex:0];
    
    for (NSDictionary *tmpGift in giftList) {
        for (NSDictionary *tmpGift2 in [tmpGift objectForKey:@"gift_detail"]) {
            if([[tmpGift2 objectForKey:@"gift_name"] isEqualToString:[gift_list objectForKey:@"gift_name"]]){
                giftDetail = tmpGift;
                break;
            }
        }
    }
}

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return [[exchangeInfo objectForKey:@"eme_detail"] count]+1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if(section == 0){
        return 1;
    } else {
        NSArray *eme_detail = [exchangeInfo objectForKey:@"eme_detail"];
        NSDictionary *gift_list = [eme_detail objectAtIndex:section-1];
        return [[gift_list objectForKey:@"gift_num"] intValue];
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *identifier;
    if(indexPath.section == 0){
        identifier = @"DefaultCell";
    } else {
        identifier = @"GiftCodeCell";
    }
    IssueGiftTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if(indexPath.section == 0){

        UIImageView *titleImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 5, 280, 70)];
        NSURL *titleUrl = [NSURL URLWithString:[giftDetail objectForKey:@"title_image"]];
        [titleImageView sd_setImageWithURL:titleUrl];
        titleImageView.contentMode = UIViewContentModeScaleAspectFit;
        [cell.contentView addSubview:titleImageView];
        
    } else {
    
        NSArray *eme_detail = [exchangeInfo objectForKey:@"eme_detail"];
        NSDictionary *gift_list = [eme_detail objectAtIndex:indexPath.section-1];
        NSArray *gift_list2 = [gift_list objectForKey:@"gift_detail"];
        NSDictionary *gift_detail = [gift_list2 objectAtIndex:indexPath.row];
        
        NSString *giftName;
        for (NSDictionary *tmpGift in giftList) {
            for (NSDictionary *tmpGift2 in [tmpGift objectForKey:@"gift_detail"]) {
                if([[tmpGift2 objectForKey:@"gift_name"] isEqualToString:[gift_list objectForKey:@"gift_name"]]){
                    giftName = [tmpGift2 objectForKey:@"gift_desc"];
                    break;
                }
            }
        }
        
        //IssueGiftTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
        //cell.gift_desc_label.text = [gift_list objectForKey:@"gift_code_name"];
        cell.gift_desc_label.text = giftName;
        cell.gift_code_label.text = [gift_detail objectForKey:@"gift_code"];
        NSString *expire_date = @"";
        if([[gift_detail allKeys] containsObject:@"expire_date"]){
            if([gift_detail objectForKey:@"expire_date"] != [NSNull null] && [[gift_detail objectForKey:@"expire_date"] length] > 0){
                if(![[gift_detail objectForKey:@"expire_date"] isEqualToString:@"0000-00-00 00:00:00"]){
                    expire_date = [NSString stringWithFormat:@"有効期限： %@",[gift_detail objectForKey:@"expire_date"]];
                }
            }
        }
        
        NSString *manage_code = @"";
        NSLog(@"allKeys %@",[gift_detail allKeys]);
        if([[gift_detail allKeys] containsObject:@"manage_code"]){
            NSLog(@"manage_code exists");
            if([gift_detail objectForKey:@"manage_code"] != [NSNull null] && [[gift_detail objectForKey:@"manage_code"] length] > 0){
                NSLog(@"gift_detail %@",gift_detail);
                NSLog(@"manage_code %@",[gift_detail objectForKey:@"manage_code"]);
        
            //if([gift_detail objectForKey:@"manage_code"] != [NSNull null]){
                NSLog(@"manage_code not null");
                
                manage_code = [NSString stringWithFormat:@"管理番号： %@",[gift_detail objectForKey:@"manage_code"]];
                NSLog(@"manage_code %@",manage_code);
                
            }
    
        }
        if(expire_date.length > 0 && manage_code.length > 0){
            cell.manage_label.text = [NSString stringWithFormat:@"%@\n%@",expire_date,manage_code];
        } else if(expire_date.length > 0){
            cell.manage_label.text = expire_date;
        } else if(manage_code.length > 0){
            cell.manage_label.text = manage_code;
        }
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] init];
    actionSheet.tag = (indexPath.section * 10) + (indexPath.row);
    actionSheet.delegate = self;
    [actionSheet addButtonWithTitle:@"コードをコピー"];
    [actionSheet addButtonWithTitle:@"コードを登録する"];
    [actionSheet addButtonWithTitle:@"コードをメールで送る"];
    [actionSheet addButtonWithTitle:@"キャンセル"];
    [actionSheet setCancelButtonIndex:3];
    [actionSheet showInView:self.view];
    
    /*
    ExchangeInputViewController *exchangeInputViewController = [[ExchangeInputViewController alloc] init];
    
    [exchangeInputViewController setExchangetype:[row_list objectAtIndex:indexPath.row]];
    [self.navigationController pushViewController:exchangeInputViewController animated:YES];
    */
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSLog(@"actionSheet clicked %@ index: %ld",actionSheet,(long)buttonIndex);
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0){
        return 80;
    }
    return 140;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

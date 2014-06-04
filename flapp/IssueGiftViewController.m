//
//  IssueGiftViewController.m
//  flapp
//
//  Created by 中山桂一 on 2014/03/26.
//  Copyright (c) 2014年 Pocket Solution Inc. All rights reserved.
//

#import "IssueGiftViewController.h"

@interface IssueGiftViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation IssueGiftViewController
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
    [self.tableView registerNib:[UINib nibWithNibName:@"IssueGiftTableViewCell" bundle:nil] forCellReuseIdentifier:@"Cell"];
}

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return [[exchangeInfo objectForKey:@"eme_detail"] count];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    NSArray *eme_detail = [exchangeInfo objectForKey:@"eme_detail"];
    NSDictionary *gift_list = [eme_detail objectAtIndex:section];
    return [[gift_list objectForKey:@"gift_num"] intValue];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *eme_detail = [exchangeInfo objectForKey:@"eme_detail"];
    NSDictionary *gift_list = [eme_detail objectAtIndex:indexPath.section];
    NSArray *gift_list2 = [gift_list objectForKey:@"gift_detail"];
    NSDictionary *gift_detail = [gift_list2 objectAtIndex:indexPath.row];
    
    IssueGiftTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    cell.gift_desc_label.text = [gift_list objectForKey:@"gift_code_name"];
    cell.gift_code_label.text = [gift_detail objectForKey:@"gift_code"];
    NSString *expire_date = @"";
    if([[gift_detail allKeys] containsObject:@"expire_date"]){
        if([gift_detail objectForKey:@"expire_date"] != [NSNull null] && [[gift_detail objectForKey:@"expire_date"] length] > 0){
            expire_date = [NSString stringWithFormat:@"有効期限： %@",[gift_detail objectForKey:@"expire_date"]];
        }
    }
    
    NSString *manage_code = @"";
    if([[gift_detail allKeys] containsObject:@"manager_code"]){
        if([gift_detail objectForKey:@"manage_code"] != [NSNull null] && [[gift_detail objectForKey:@"manage_code"] length] > 0){
            manage_code = [NSString stringWithFormat:@"管理番号： %@",[gift_detail objectForKey:@"manage_code"]];
        }
    }
    cell.manage_label.text = [NSString stringWithFormat:@"%@\n%@",expire_date,manage_code];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    /*
    ExchangeInputViewController *exchangeInputViewController = [[ExchangeInputViewController alloc] init];
    
    [exchangeInputViewController setExchangetype:[row_list objectAtIndex:indexPath.row]];
    [self.navigationController pushViewController:exchangeInputViewController animated:YES];
    */
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 140;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

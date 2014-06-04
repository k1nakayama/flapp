//
//  PointExchangeViewController.m
//  flapp
//
//  Created by 中山桂一 on 2014/03/18.
//  Copyright (c) 2014年 Pocket Solution Inc. All rights reserved.
//

#import "PointExchangeViewController.h"
#import "AppApiUtil.h"

@interface PointExchangeViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation PointExchangeViewController{
    NSDictionary *giftInfo;
    NSArray *gift_list;
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"交換" image:[UIImage imageNamed:@"gift"] tag:2];
        //self.tabBarItem.title = @"交換";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"PointExchangeViewCell" bundle:nil] forCellReuseIdentifier:@"Cell"];
    
    /*
    AppApiUtil *apiUtile = [[AppApiUtil alloc] init];
    giftInfo = [apiUtile getGiftInfo];
    gift_list = [giftInfo objectForKey:@"gift_list"];
    NSLog(@"giftInfo: %@",giftInfo);
    */
}

-(void)viewWillAppear:(BOOL)animated{
    AppApiUtil *apiUtile = [[AppApiUtil alloc] init];
    giftInfo = [apiUtile getGiftInfo];
    gift_list = [giftInfo objectForKey:@"gift_list"];
    [self.tableView reloadData];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //return row_list.count;
    return gift_list.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"gift_list %@",gift_list);
    NSDictionary *gift_detail = [gift_list objectAtIndex:indexPath.row];
    PointExchangeViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSURL *giftThumbnailUrl = [NSURL URLWithString:[gift_detail objectForKey:@"gift_thumbnail"]];
    NSData *giftImgData = [NSData dataWithContentsOfURL:giftThumbnailUrl];
    UIImage *giftImage = [UIImage imageWithData:giftImgData];
    cell.gift_thumbnail.image = giftImage;

    cell.min_point_label.text = [NSString stringWithFormat:@"%@pt〜",[gift_detail objectForKey:@"min_point"]];
    //PointExchangeViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    ExchangeInputViewController *exchangeInputViewController = [[ExchangeInputViewController alloc] init];
    
    [exchangeInputViewController setGiftDetail:[gift_list objectAtIndex:indexPath.row]];
    [self.navigationController pushViewController:exchangeInputViewController animated:YES];

    /*
     NSDictionary *banner = [bannerInfo objectAtIndex:indexPath.row];
     //NSLog(@"selected: %d",indexPath.row);
     //NSLog(@"keys: %@",[banner allKeys]);
     //DetailViewController *detailViewController = [[DetailViewController alloc] init];
     
     [detailViewController setBanner:banner];
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 90;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

//
//  MenuViewController.m
//  flapp
//
//  Created by 中山桂一 on 2014/03/18.
//  Copyright (c) 2014年 Pocket Solution Inc. All rights reserved.
//

#import "MenuViewController.h"

@interface MenuViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation MenuViewController{
    NSArray *section_list;
    NSArray *row_list;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        //self.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"メニュー" image:[UIImage imageNamed:@"setting"] tag:3];
        UIImage *unselectImg = [[UIImage imageNamed:@"footer31"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        UIImage *selectImg = [[UIImage imageNamed:@"footer30"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        self.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"メニュー" image:unselectImg tag:3];
        [self.tabBarItem setSelectedImage:selectImg];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.tableView.dataSource = self;
    self.tableView.delegate = self;

    UIImageView *navigationTitle = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"title_type02_2.png"]];
    self.navigationItem.titleView = navigationTitle;
    self.navigationController.navigationBar.backgroundColor = [UIColor colorWithRed:1.0 green:0.398 blue:0 alpha:1.0];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:1.0 green:0.398 blue:0 alpha:1.0];
    
    //セクションの配列
    section_list = @[@"利用情報",@"引き継ぎ",@"サポート"];
    //各行の配列
    row_list = @[@[@"ポイント履歴"],@[@"引き継ぎコード確認",@"引き継ぎ実行"],@[@"よくある質問",@"このアプリの使い方",@"会社概要",@"利用規約"]];
}
-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return section_list.count;
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return [section_list objectAtIndex:section];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [[row_list objectAtIndex:section] count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    
    cell.textLabel.text = [[row_list objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    return cell;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

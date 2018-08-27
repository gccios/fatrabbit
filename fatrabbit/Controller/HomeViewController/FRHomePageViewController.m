//
//  FRHomePageViewController.m
//  fatrabbit
//
//  Created by 郭春城 on 2018/8/22.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import "FRHomePageViewController.h"
#import <SDCycleScrollView.h>
#import "FRCityViewController.h"
#import "FRNavAutoView.h"
#import "FRTableTabView.h"
#import "FRServiceTableViewCell.h"
#import "FRSearchViewController.h"

@interface FRHomePageViewController () <UICollectionViewDelegate, UICollectionViewDataSource, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UIButton * locationButton;
@property (nonatomic, strong) UITableView * tableView;

@property (nonatomic, strong) SDCycleScrollView * bannerView;
@property (nonatomic, strong) UICollectionView * menuCollectionView;

@property (nonatomic, strong) FRTableTabView * tableTabView;

@end

@implementation FRHomePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self createViews];
}

//选择城市
- (void)locationButtonDicClicked
{
    FRCityViewController * city = [[FRCityViewController alloc] init];
    [self.navigationController pushViewController:city animated:YES];
}

- (void)searchButtonDidClicked
{
    FRSearchViewController * search = [[FRSearchViewController alloc] init];
    [self.navigationController pushViewController:search animated:YES];
}

- (void)createViews
{
    FRNavAutoView * navView = [[FRNavAutoView alloc] initWithFrame:CGRectMake(0, 0, kMainBoundsWidth - 20, kNaviBarHeight)];
    self.navigationItem.titleView = navView;
    
    self.locationButton = [FRCreateViewTool createButtonWithFrame:CGRectZero font:kPingFangRegular(16) titleColor:UIColorFromRGB(0xFFFFFF) title:@"北京"];
    [navView addSubview:self.locationButton];
    [self.locationButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.centerY.mas_equalTo(0);
        make.height.mas_equalTo(40);
    }];
    [self.locationButton addTarget:self action:@selector(locationButtonDicClicked) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton * searchButton = [FRCreateViewTool createButtonWithFrame:CGRectZero font:kPingFangRegular(15) titleColor:UIColorFromRGB(0xFFFFFF) title:@""];
    searchButton.backgroundColor = [UIColorFromRGB(0xFFFFFF) colorWithAlphaComponent:.4f];
    [navView addSubview:searchButton];
    [searchButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.width.mas_equalTo(kMainBoundsWidth / 4.f * 3.f);
        make.height.mas_equalTo(30);
    }];
    [FRCreateViewTool cornerView:searchButton radius:15];
    [searchButton addTarget:self action:@selector(searchButtonDidClicked) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel * searchLabel = [FRCreateViewTool createLabelWithFrame:CGRectZero font:kPingFangRegular(12) textColor:UIColorFromRGB(0x999999) alignment:NSTextAlignmentLeft];
    searchLabel.text = @"搜索企业/服务/案例/分类等，专业团队";
    [searchButton addSubview:searchLabel];
    [searchLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.top.bottom.mas_equalTo(0);
    }];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = UIColorFromRGB(0xEFEFF4);
    self.tableView.rowHeight = 60;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[FRServiceTableViewCell class] forCellReuseIdentifier:@"FRServiceTableViewCell"];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    
    [self createTableHeaderView];
}

- (void)createTableHeaderView
{
    CGFloat scale = kMainBoundsWidth / 375.f;
    
    UIView * headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainBoundsWidth, kMainBoundsWidth * 1.1)];
    
    self.bannerView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, kMainBoundsWidth, kMainBoundsWidth / 7.f * 3) imageURLStringsGroup:@[@"http://a.hiphotos.baidu.com/zhidao/pic/item/cf1b9d16fdfaaf51b3fef0a6805494eef01f7a8d.jpg", @"http://a.hiphotos.baidu.com/zhidao/pic/item/cf1b9d16fdfaaf51b3fef0a6805494eef01f7a8d.jpg", @"http://a.hiphotos.baidu.com/zhidao/pic/item/cf1b9d16fdfaaf51b3fef0a6805494eef01f7a8d.jpg", @"http://a.hiphotos.baidu.com/zhidao/pic/item/cf1b9d16fdfaaf51b3fef0a6805494eef01f7a8d.jpg", @"http://a.hiphotos.baidu.com/zhidao/pic/item/cf1b9d16fdfaaf51b3fef0a6805494eef01f7a8d.jpg"]];
    self.bannerView.autoScrollTimeInterval = 3.f;
    [headerView addSubview:self.bannerView];
    [self.bannerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.height.mas_equalTo(kMainBoundsWidth / 7.f * 3);
    }];
    
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake((kMainBoundsWidth - kMainBoundsWidth / 16.f * 5) / 4.f, kMainBoundsWidth / 8.f + 25 * scale);
    layout.minimumLineSpacing = 5;
    layout.minimumInteritemSpacing = kMainBoundsWidth / 16.f;
    
    self.menuCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    [self.menuCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"UICollectionViewCell"];
    self.menuCollectionView.backgroundColor = UIColorFromRGB(0xEFEFF4);
    self.menuCollectionView.delegate = self;
    self.menuCollectionView.dataSource = self;
    self.menuCollectionView.scrollEnabled = NO;
    self.menuCollectionView.contentInset = UIEdgeInsetsMake(10 * scale, kMainBoundsWidth / 16.f, 0, kMainBoundsWidth / 16.f);
    [headerView addSubview:self.menuCollectionView];
    [self.menuCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.bannerView.mas_bottom);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo((kMainBoundsWidth / 8.f + 25 * scale) * 2 + 10 + 20 * scale);
    }];
    
    UIView * buttonView = [[UIView alloc] initWithFrame:CGRectZero];
    buttonView.backgroundColor = UIColorFromRGB(0xFFFFFF);
    [headerView addSubview:buttonView];
    [buttonView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.menuCollectionView.mas_bottom).offset(0 * scale);
        make.left.mas_equalTo(25 * scale);
        make.width.mas_equalTo(kMainBoundsWidth - 50 * scale);
        make.height.mas_equalTo(kMainBoundsWidth / 10.f);
    }];
    buttonView.layer.cornerRadius = kMainBoundsWidth / 10.f / 2.f;
    buttonView.layer.shadowColor = KThemeColor.CGColor;
    buttonView.layer.shadowOpacity = .3f;
    buttonView.layer.shadowRadius = 6 * scale;
    buttonView.layer.shadowOffset = CGSizeMake(0, 3 * scale);
    
    UIButton * becomeButton = [FRCreateViewTool createButtonWithFrame:CGRectZero font:kPingFangMedium(15 * scale) titleColor:UIColorFromRGB(0xFFFFFF) title:@"申请成为服务商，为5000+餐饮酒店提供服务"];
    becomeButton.backgroundColor = KThemeColor;
    [buttonView addSubview:becomeButton];
    [becomeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    [FRCreateViewTool cornerView:becomeButton radius:kMainBoundsWidth / 10.f / 2.f];
    
    self.tableTabView = [[FRTableTabView alloc] initWithFrame:CGRectZero];
    [headerView addSubview:self.tableTabView];
    [self.tableTabView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.mas_equalTo(0);
        make.top.mas_equalTo(buttonView.mas_bottom).offset(20 * scale);
    }];
    
    self.tableView.tableHeaderView = headerView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FRServiceTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"FRServiceTableViewCell" forIndexPath:indexPath];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120 * kMainBoundsWidth / 375.f;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 8;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"UICollectionViewCell" forIndexPath:indexPath];
    
    cell.backgroundColor = [UIColor greenColor];
    
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
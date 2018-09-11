//
//  FRCatePageDetailViewController.m
//  fatrabbit
//
//  Created by 郭春城 on 2018/9/11.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import "FRCatePageDetailViewController.h"
#import "FRServiceTableViewCell.h"
#import "FRTableTabView.h"
#import "FRNeedListRequest.h"
#import "FRServiceDetailViewController.h"
#import <SDCycleScrollView.h>

@interface FRCatePageDetailViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) NSMutableArray * needSource;

@property (nonatomic, strong) SDCycleScrollView * bannerView;
@property (nonatomic, strong) FRTableTabView * tableTabView;

@end

@implementation FRCatePageDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self createViews];
    [self requestNeedSource];
}

//获取需求列表
- (void)requestNeedSource
{
    FRNeedListRequest * request = [[FRNeedListRequest alloc] init];
    [request sendRequestWithSuccess:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
        
        if (KIsDictionary(response)) {
            NSData * data = [response objectForKey:@"data"];
            [self.needSource removeAllObjects];
            [self.needSource addObjectsFromArray:[FRNeedModel mj_objectArrayWithKeyValuesArray:data]];
            [self.tableView reloadData];
        }
        
    } businessFailure:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
        
    } networkFailure:^(BGNetworkRequest * _Nonnull request, NSError * _Nullable error) {
        
    }];
}

- (void)createViews
{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = UIColorFromRGB(0xf5f5f5);
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
    
    UIView * headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainBoundsWidth, 210 * scale)];
    
    self.bannerView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, kMainBoundsWidth, kMainBoundsWidth / 7.f * 3) imageURLStringsGroup:@[@"http://a.hiphotos.baidu.com/zhidao/pic/item/cf1b9d16fdfaaf51b3fef0a6805494eef01f7a8d.jpg", @"http://a.hiphotos.baidu.com/zhidao/pic/item/cf1b9d16fdfaaf51b3fef0a6805494eef01f7a8d.jpg", @"http://a.hiphotos.baidu.com/zhidao/pic/item/cf1b9d16fdfaaf51b3fef0a6805494eef01f7a8d.jpg", @"http://a.hiphotos.baidu.com/zhidao/pic/item/cf1b9d16fdfaaf51b3fef0a6805494eef01f7a8d.jpg", @"http://a.hiphotos.baidu.com/zhidao/pic/item/cf1b9d16fdfaaf51b3fef0a6805494eef01f7a8d.jpg"]];
    self.bannerView.autoScrollTimeInterval = 3.f;
    [headerView addSubview:self.bannerView];
    [self.bannerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.height.mas_equalTo(160 * scale);
    }];
    
    self.tableTabView = [[FRTableTabView alloc] initWithFrame:CGRectZero];
    [headerView addSubview:self.tableTabView];
    [self.tableTabView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(-10 * scale);
        make.top.mas_equalTo(self.bannerView.mas_bottom).offset(10 * scale);
    }];
    
    self.tableView.tableHeaderView = headerView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.needSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FRServiceTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"FRServiceTableViewCell" forIndexPath:indexPath];
    
    FRNeedModel * model = [self.needSource objectAtIndex:indexPath.row];
    [cell configWithModel:model];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120 * kMainBoundsWidth / 375.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    FRServiceDetailViewController * detail = [[FRServiceDetailViewController alloc] init];
    [self.navigationController pushViewController:detail animated:YES];
}

- (NSMutableArray *)needSource
{
    if (!_needSource) {
        _needSource = [[NSMutableArray alloc] init];
    }
    return _needSource;
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

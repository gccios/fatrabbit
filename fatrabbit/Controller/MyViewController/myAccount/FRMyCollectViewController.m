//
//  FRMyCollectViewController.m
//  fatrabbit
//
//  Created by 郭春城 on 2018/9/13.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import "FRMyCollectViewController.h"
#import "FRMyCollectTableViewCell.h"
#import "FRCollectRequest.h"
#import "MBProgressHUD+FRHUD.h"
#import "FRNeedDetailViewController.h"
#import "FRServiceDetailViewController.h"
#import "FRStoreDetailViewController.h"
#import <MJRefresh.h>

@interface FRMyCollectViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) NSMutableArray * dataSource;

@end

@implementation FRMyCollectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self requestCollectList];
    
    [self createViews];
}

- (void)requestCollectList
{
    FRCollectRequest * request = [[FRCollectRequest alloc] initWithCollectList];
    [request sendRequestWithSuccess:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
        
        if (KIsDictionary(response)) {
            NSDictionary * data = [response objectForKey:@"data"];
            [self.dataSource removeAllObjects];
            [self.dataSource addObjectsFromArray:[FRCollectModel mj_objectArrayWithKeyValuesArray:data]];
            [self.tableView reloadData];
        }
    } businessFailure:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
        
        NSString * msg = [response objectForKey:@"msg"];
        if (!isEmptyString(msg)) {
            [MBProgressHUD showTextHUDWithText:msg];
        }
        
    } networkFailure:^(BGNetworkRequest * _Nonnull request, NSError * _Nullable error) {
        
        [MBProgressHUD showTextHUDWithText:@"网络失去连接"];
        
    }];
}

- (void)createViews
{
    self.navigationItem.title = @"我的收藏";
    CGFloat scale = kMainBoundsWidth / 375.f;
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = UIColorFromRGB(0xffffff);
    self.tableView.rowHeight = 140 * scale;
    [self.tableView registerClass:[FRMyCollectTableViewCell class] forCellReuseIdentifier:@"FRMyCollectTableViewCell"];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.mas_equalTo(0);
    }];
    self.tableView.tableFooterView = [UIView new];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(requestCollectList)];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FRMyCollectTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"FRMyCollectTableViewCell" forIndexPath:indexPath];
    
    FRCollectModel * model = [self.dataSource objectAtIndex:indexPath.row];
    [cell configWithModel:model];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    FRCollectModel * model = [self.dataSource objectAtIndex:indexPath.row];
    if (model.type == 1) {
        
        FRStoreModel * storeModel = [[FRStoreModel alloc] init];
        storeModel.pid = model.cid;
        storeModel.cover = model.cover;
        storeModel.name = model.title;
        FRStoreDetailViewController * detail = [[FRStoreDetailViewController alloc] initWithModel:storeModel];
        [self.navigationController pushViewController:detail animated:YES];
    }else if (model.type == 2) {
        FRMySeriviceModel * serviceModel = [[FRMySeriviceModel alloc] init];
        serviceModel.cid = model.cid;
        serviceModel.cover = model.cover;
        serviceModel.remark = model.desc;
        FRServiceDetailViewController * detail = [[FRServiceDetailViewController alloc] initWithSeriviceModel:serviceModel];
        [self.navigationController pushViewController:detail animated:YES];
    }else if (model.type == 3) {
        FRNeedModel * needModel = [[FRNeedModel alloc] init];
        needModel.cid = model.cid;
        needModel.cover = model.cover;
        needModel.remark = model.desc;
        FRNeedDetailViewController * detail = [[FRNeedDetailViewController alloc] initWithNeedModel:needModel];
        [self.navigationController pushViewController:detail animated:YES];
    }
}

- (NSMutableArray *)dataSource
{
    if (!_dataSource) {
        _dataSource = [[NSMutableArray alloc] init];
    }
    return _dataSource;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
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

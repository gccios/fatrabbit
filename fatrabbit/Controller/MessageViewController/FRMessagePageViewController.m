//
//  FRMessagePageViewController.m
//  fatrabbit
//
//  Created by 郭春城 on 2018/8/26.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import "FRMessagePageViewController.h"
#import "FRMessageNeedCell.h"
#import "FRMessageSystemCell.h"
#import "FRMessageRequest.h"
#import "FROrderRequest.h"
#import "FRNeedDetailViewController.h"
#import "FROrderDetailViewController.h"
#import "MBProgressHUD+FRHUD.h"
#import <MJRefresh.h>

@interface FRMessagePageViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) NSMutableArray * dataSource;
@property (nonatomic, assign) NSInteger page;

@end

@implementation FRMessagePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.dataSource = [[NSMutableArray alloc] init];
    
    [self createViews];
    [self requestMessage];
}

- (void)requestMessage
{
    FRMessageRequest * request = [[FRMessageRequest alloc] initWithMessageListPage:1];
    [request sendRequestWithSuccess:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
        
        NSArray * data = [response objectForKey:@"data"];
        [self.dataSource removeAllObjects];
        [self.dataSource addObjectsFromArray:[FRMessageModel mj_objectArrayWithKeyValuesArray:data]];
        [self.tableView reloadData];
        self.page = 2;
        [self.tableView.mj_header endRefreshing];
        
        if (self.dataSource.count == 0) {
            [MBProgressHUD showTextHUDWithText:@"暂无消息"];
        }
        
    } businessFailure:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
        
        NSString * msg = [response objectForKey:@"msg"];
        if (!isEmptyString(msg)) {
            [MBProgressHUD showTextHUDWithText:msg];
        }
        [self.tableView.mj_header endRefreshing];
        
    } networkFailure:^(BGNetworkRequest * _Nonnull request, NSError * _Nullable error) {
        
        [MBProgressHUD showTextHUDWithText:@"网络失去连接"];
        [self.tableView.mj_header endRefreshing];
        
    }];
}

- (void)loadMoreMessage
{
    FRMessageRequest * request = [[FRMessageRequest alloc] initWithMessageListPage:self.page];
    [request sendRequestWithSuccess:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
        
        NSArray * data = [response objectForKey:@"data"];
        if (data.count > 0) {
            [self.dataSource addObjectsFromArray:[FRMessageModel mj_objectArrayWithKeyValuesArray:data]];
            [self.tableView reloadData];
            self.page++;
        }
        [self.tableView.mj_footer endRefreshing];
        
    } businessFailure:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
        
        NSString * msg = [response objectForKey:@"msg"];
        if (!isEmptyString(msg)) {
            [MBProgressHUD showTextHUDWithText:msg];
        }
        [self.tableView.mj_footer endRefreshing];
        
    } networkFailure:^(BGNetworkRequest * _Nonnull request, NSError * _Nullable error) {
        
        [MBProgressHUD showTextHUDWithText:@"网络失去连接"];
        [self.tableView.mj_footer endRefreshing];
        
    }];
}

- (void)createViews
{
    self.navigationItem.title = @"消息中心";
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = UIColorFromRGB(0xFFFFFF);
    [self.tableView registerClass:[FRMessageSystemCell class] forCellReuseIdentifier:@"FRMessageSystemCell"];
    [self.tableView registerClass:[FRMessageNeedCell class] forCellReuseIdentifier:@"FRMessageNeedCell"];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(requestMessage)];
    self.tableView.mj_footer = [MJRefreshAutoFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreMessage)];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FRMessageModel * model = [self.dataSource objectAtIndex:indexPath.row];
    
    FRMessageNeedCell * cell = [tableView dequeueReusableCellWithIdentifier:@"FRMessageNeedCell" forIndexPath:indexPath];
    [cell configWithModel:model];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger temp = indexPath.row % 2;
    CGFloat scale = kMainBoundsWidth / 375.f;
    if (temp == 1) {
        return 60 * scale;
    }
    return 100 * scale;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    FRMessageModel * model = [self.dataSource objectAtIndex:indexPath.row];
    if (model.type == 1) {
        MBProgressHUD * hud = [MBProgressHUD showLoadingHUDWithText:@"正在加载" inView:self.view];
        FROrderRequest * request = [[FROrderRequest alloc] initStoreDetailWithID:model.target_id];
        [request sendRequestWithSuccess:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
            
            [hud hideAnimated:YES];
            NSDictionary * data = [response objectForKey:@"data"];
            FRMyStoreOrderModel * storeModel = [FRMyStoreOrderModel mj_objectWithKeyValues:data];
            storeModel.cid = model.target_id;
            FROrderDetailViewController * detail = [[FROrderDetailViewController alloc] initWithStoreModel:storeModel];
            [self.navigationController pushViewController:detail animated:YES];
            
        } businessFailure:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
            
            [hud hideAnimated:YES];
            NSString * msg = [response objectForKey:@"msg"];
            if (!isEmptyString(msg)) {
                [MBProgressHUD showTextHUDWithText:msg];
            }
            
        } networkFailure:^(BGNetworkRequest * _Nonnull request, NSError * _Nullable error) {
            
            [hud hideAnimated:YES];
            [MBProgressHUD showTextHUDWithText:@"网络失去连接"];
            
        }];
    }else if (model.type == 2) {
        MBProgressHUD * hud = [MBProgressHUD showLoadingHUDWithText:@"正在加载" inView:self.view];
        FROrderRequest * request = [[FROrderRequest alloc] initServiceDetailWithID:model.target_id];
        [request sendRequestWithSuccess:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
            
            [hud hideAnimated:YES];
            NSDictionary * data = [response objectForKey:@"data"];
            FRMyServiceOrderModel * serviceModel = [FRMyServiceOrderModel mj_objectWithKeyValues:data];
            serviceModel.cid = model.target_id;
            FROrderDetailViewController * detail = [[FROrderDetailViewController alloc] initWithServiceModel:serviceModel];
            [self.navigationController pushViewController:detail animated:YES];
            
        } businessFailure:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
            
            [hud hideAnimated:YES];
            NSString * msg = [response objectForKey:@"msg"];
            if (!isEmptyString(msg)) {
                [MBProgressHUD showTextHUDWithText:msg];
            }
            
        } networkFailure:^(BGNetworkRequest * _Nonnull request, NSError * _Nullable error) {
            
            [hud hideAnimated:YES];
            [MBProgressHUD showTextHUDWithText:@"网络失去连接"];
            
        }];
    }else if (model.type == 3) {
        FRNeedModel * needModel = [[FRNeedModel alloc] init];
        needModel.cid = model.target_id;
        FRNeedDetailViewController * detail = [[FRNeedDetailViewController alloc] initWithNeedModel:needModel];
        [self.navigationController pushViewController:detail animated:YES];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
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

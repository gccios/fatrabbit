//
//  FRGetServiceOrderViewController.m
//  fatrabbit
//
//  Created by 郭春城 on 2018/9/28.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import "FRGetServiceOrderViewController.h"
#import "FRMyGetOrderTableViewCell.h"
#import "FRServiceDetailViewController.h"
#import "FROrderRequest.h"
#import "MBProgressHUD+FRHUD.h"
#import "FRCommentViewController.h"
#import "FROrderDetailViewController.h"

@interface FRGetServiceOrderViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, assign) NSInteger type;

@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) NSMutableArray * dataSource;

@end

@implementation FRGetServiceOrderViewController

- (instancetype)initWithType:(NSInteger)type
{
    if (self = [super init]) {
        self.type = type;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self requesOrderList];
    
    [self createViews];
}

- (void)requesOrderList
{
    FROrderRequest * request = [[FROrderRequest alloc] initMyGetServiceOrderWithType:self.type];
    [request sendRequestWithSuccess:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
        
        if (KIsDictionary(response)) {
            NSArray * data = [response objectForKey:@"data"];
            [self.dataSource removeAllObjects];
            [self.dataSource addObjectsFromArray:[FRMyServiceOrderModel mj_objectArrayWithKeyValuesArray:data]];
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
    CGFloat scale = kMainBoundsWidth / 375.f;
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    //    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = UIColorFromRGB(0xf5f5f5);
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[FRMyGetOrderTableViewCell class] forCellReuseIdentifier:@"FRMyGetOrderTableViewCell"];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    self.tableView.contentInset = UIEdgeInsetsMake(10 * scale, 0, 10 * scale, 0);
    self.tableView.tableFooterView = [UIView new];
}

#pragma mark - UITableViewDelegate && UITableViewDataSource
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    FRMyServiceOrderModel * model = [self.dataSource objectAtIndex:indexPath.row];
    [self showDetailWithModel:model];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FRMyGetOrderTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"FRMyGetOrderTableViewCell" forIndexPath:indexPath];
    
    FRMyServiceOrderModel * model = [self.dataSource objectAtIndex:indexPath.row];
    [cell configWithModel:model];
    
    __weak typeof(self) weakSelf = self;
    cell.leftHandle = ^(FRMyServiceOrderModel *orderModel) {
        [weakSelf leftHandleDidClicked:orderModel];
    };
    cell.rightHandle = ^(FRMyServiceOrderModel *orderModel) {
        [weakSelf rightHandleDidClicked:orderModel];
    };
    
    return cell;
}

- (void)leftHandleDidClicked:(FRMyServiceOrderModel *)model
{
    [self connactUserWithModel:model];
}

- (void)rightHandleDidClicked:(FRMyServiceOrderModel *)model
{
    if (model.type == 1 || model.type == 2) {
        
        UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"完成服务" message:@"确认该服务已经完成？" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction * action1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        
        UIAlertAction * action2 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            MBProgressHUD * hud = [MBProgressHUD showLoadingHUDWithText:@"正在加载" inView:self.view];
            FROrderRequest * request = [[FROrderRequest alloc] initWithCompeleteServiceWithID:model.cid];
            [request sendRequestWithSuccess:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
                
                model.type = 4;
                [self.tableView reloadData];
                [hud hideAnimated:YES];
                
            } businessFailure:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
                
                NSString * msg = [response objectForKey:@"msg"];
                if (!isEmptyString(msg)) {
                    [MBProgressHUD showTextHUDWithText:msg];
                }
                [hud hideAnimated:YES];
            } networkFailure:^(BGNetworkRequest * _Nonnull request, NSError * _Nullable error) {
                
                [MBProgressHUD showTextHUDWithText:@"网络失去连接"];
                [hud hideAnimated:YES];
            }];
            
        }];
        
        [alert addAction:action1];
        [alert addAction:action2];
        [self presentViewController:alert animated:YES completion:nil];
        
    }else if (model.type == 3) {
        [self connactUserWithModel:model];
    }else{
        [self showDetailWithModel:model];
    }
}

- (void)connactUserWithModel:(FRMyServiceOrderModel *)model
{
    if (isEmptyString(model.mobile)) {
        [MBProgressHUD showTextHUDWithText:@"暂无联系方式"];
        return;
    }
    
    NSMutableString  *str = [[NSMutableString alloc] initWithFormat:@"tel:%@", model.mobile];
    
    if (@available(iOS 10.0, *)) {
        /// 大于等于10.0系统使用此openURL方法
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str] options:@{} completionHandler:nil];
    }else{
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    }
}

- (void)showDetailWithModel:(FRMyServiceOrderModel *)model
{
    MBProgressHUD * hud = [MBProgressHUD showLoadingHUDWithText:@"正在加载" inView:self.view];
    FROrderRequest * request = [[FROrderRequest alloc] initServiceDetailWithID:model.cid];
    [request sendRequestWithSuccess:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
        
        [hud hideAnimated:YES];
        NSDictionary * data = [response objectForKey:@"data"];
        FRMyServiceOrderModel * serviceModel = [FRMyServiceOrderModel mj_objectWithKeyValues:data];
        serviceModel.cid = model.cid;
        FROrderDetailViewController * detail = [[FROrderDetailViewController alloc] initWithServiceModel:serviceModel];
        detail.isMyGet = YES;
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
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 140 * kMainBoundsWidth / 375.f;
}

- (NSMutableArray *)dataSource
{
    if (!_dataSource) {
        _dataSource = [[NSMutableArray alloc] init];
    }
    return _dataSource;
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

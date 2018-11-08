//
//  FRMyServiceOrderViewController.m
//  fatrabbit
//
//  Created by 郭春城 on 2018/9/28.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import "FRMyServiceOrderViewController.h"
#import "FRMyServiceOrderTableViewCell.h"
#import "FRServiceDetailViewController.h"
#import "FROrderRequest.h"
#import "MBProgressHUD+FRHUD.h"
#import "FRCommentViewController.h"
#import "FROrderPayRequest.h"
#import <AlipaySDK/AlipaySDK.h>
#import "UserManager.h"
#import "FRChoosePayWayView.h"
#import "FROrderDetailViewController.h"

@interface FRMyServiceOrderViewController ()<UITableViewDelegate, UITableViewDataSource, FRCommentViewControllerDelegate, FROrderDetailViewControllerDelegate>

@property (nonatomic, assign) NSInteger type;

@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) NSMutableArray * dataSource;

@end

@implementation FRMyServiceOrderViewController

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
    FROrderRequest * request = [[FROrderRequest alloc] initMyServiceOrderWithType:self.type];
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
    [self.tableView registerClass:[FRMyServiceOrderTableViewCell class] forCellReuseIdentifier:@"FRMyServiceOrderTableViewCell"];
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
    FRMyServiceOrderTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"FRMyServiceOrderTableViewCell" forIndexPath:indexPath];
    
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
    if (model.type == 1) {
        
        UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"确认要取消该订单吗？" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction * cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        
        UIAlertAction * sureAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            FROrderRequest * request = [[FROrderRequest alloc] initCancleServiceWithID:model.cid];
            [request sendRequestWithSuccess:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
                
                [self.dataSource removeObject:model];
                [self.tableView reloadData];
                
            } businessFailure:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
                
                NSString * msg = [response objectForKey:@"msg"];
                if (!isEmptyString(msg)) {
                    [MBProgressHUD showTextHUDWithText:msg];
                }
                
            } networkFailure:^(BGNetworkRequest * _Nonnull request, NSError * _Nullable error) {
                
                [MBProgressHUD showTextHUDWithText:@"网络失去连接"];
                
            }];
            
        }];
        
        [alert addAction:cancleAction];
        [alert addAction:sureAction];
        [self presentViewController:alert animated:YES completion:nil];
        
    }else{
        NSMutableString  *str = [[NSMutableString alloc] initWithFormat:@"tel:%@",model.mobile];
        
        if (@available(iOS 10.0, *)) {
            /// 大于等于10.0系统使用此openURL方法
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str] options:@{} completionHandler:nil];
        }else{
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
        }
    }
}

- (void)rightHandleDidClicked:(FRMyServiceOrderModel *)model
{
    if (model.paytype == 2) {
        if (model.paystatus == 0 || model.rest_paystatus == 0) {
            [self showDetailWithModel:model];
        }
        return;
    }
    
    if (model.type == 3) {
        FRCommentViewController * comment = [[FRCommentViewController alloc] initWithSeriviceModel:model];
        comment.delegate = self;
        [self.navigationController pushViewController:comment animated:YES];
    }else if (model.type == 1) {
        [self showDetailWithModel:model];
    }else if (model.type == 4 || model.type == 5) {
        [self showDetailWithModel:model];
    }else if (model.type == 2) {
        [self showDetailWithModel:model];
    }
    
//    switch (model.type) {
//        case 1:
//        {
//            //            self.statusLabel.text = @"未付款";
//        }
//            break;
//        case 2:
//        {
//            //            self.statusLabel.text = @"待收货";
//        }
//            break;
//        case 3:
//        {
//            //            self.statusLabel.text = @"待评价";
//            FRCommentViewController * comment = [[FRCommentViewController alloc] initWithSeriviceModel:model];
//            [self.navigationController pushViewController:comment animated:YES];
//
//        }
//            break;
//        case 4:
//        {
//            //            self.statusLabel.text = @"已完成";
//        }
//            break;
//        case 5:
//        {
//            //            self.statusLabel.text = @"已取消";
//        }
//            break;
//
//        default:
//        {
//            //            self.statusLabel.text = @"已完成";
//        }
//            break;
//    }
}

- (void)conmentDidCompelete
{
    [self requesOrderList];
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
        detail.delegate = self;
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

- (void)orderDidNeedUpdate
{
    [self requesOrderList];
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

//
//  FROrderViewController.m
//  fatrabbit
//
//  Created by 郭春城 on 2018/8/27.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import "FROrderViewController.h"
#import "FROrderTableViewCell.h"
#import "FROrderDetailViewController.h"
#import "FROrderRequest.h"
#import "MBProgressHUD+FRHUD.h"
#import "FRCommentViewController.h"
#import "FRStoreOrderViewController.h"

@interface FROrderViewController () <UITableViewDelegate, UITableViewDataSource, FRCommentViewControllerDelegate, FROrderDetailViewControllerDelegate>

@property (nonatomic, assign) NSInteger type;

@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) NSMutableArray * dataSource;

@end

@implementation FROrderViewController

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
    FROrderRequest * request = [[FROrderRequest alloc] initMyStoreOrderWithType:self.type];
    [request sendRequestWithSuccess:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
        
        if (KIsDictionary(response)) {
            NSArray * data = [response objectForKey:@"data"];
            [self.dataSource removeAllObjects];
            [self.dataSource addObjectsFromArray:[FRMyStoreOrderModel mj_objectArrayWithKeyValuesArray:data]];
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
    [self.tableView registerClass:[FROrderTableViewCell class] forCellReuseIdentifier:@"FROrderTableViewCell"];
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
    FRMyStoreOrderModel * model = [self.dataSource objectAtIndex:indexPath.row];
    [self showDetailWithModel:model];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FROrderTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"FROrderTableViewCell" forIndexPath:indexPath];
    
    FRMyStoreOrderModel * model = [self.dataSource objectAtIndex:indexPath.row];
    [cell configWthModel:model];
    
    __weak typeof(self) weakSelf = self;
    cell.leftHandle = ^(FRMyStoreOrderModel *orderModel) {
        [weakSelf leftHandleDidClicked:orderModel];
    };
    cell.rightHandle = ^(FRMyStoreOrderModel *orderModel) {
        [weakSelf rightHandleDidClicked:orderModel];
    };
    
    return cell;
}

- (void)leftHandleDidClicked:(FRMyStoreOrderModel *)model
{
    switch (model.status) {
        case 0:
        {
            UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"确认要取消该订单吗？" preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction * cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            
            UIAlertAction * sureAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                FROrderRequest * request = [[FROrderRequest alloc] initCancleWithID:model.cid];
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
        }
            break;
            
        case 1:
        {
            UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"确认要取消该订单吗？" preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction * cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            
            UIAlertAction * sureAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                FROrderRequest * request = [[FROrderRequest alloc] initCancleWithID:model.cid];
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
        }
            break;
        case 2:
        
            break;
        case 3:
        
            break;
        case 4:
        
            break;
        case 5:
        
            break;
            
        default:
        
            break;
    }
}

- (void)rightHandleDidClicked:(FRMyStoreOrderModel *)model
{
    if (model.status == 4 || model.status == 5) {
        
        [self showDetailWithModel:model];
        
    }else if (model.status == 3) {
        FRCommentViewController * comment = [[FRCommentViewController alloc] initWithStoreModel:model];
        comment.delegate = self;
        [self.navigationController pushViewController:comment animated:YES];

    }else{
        [self showDetailWithModel:model];
    }
}

- (void)conmentDidCompelete
{
    [self requesOrderList];
}

- (void)showDetailWithModel:(FRMyStoreOrderModel *)model
{
    MBProgressHUD * hud = [MBProgressHUD showLoadingHUDWithText:@"正在加载" inView:self.view];
    FROrderRequest * request = [[FROrderRequest alloc] initStoreDetailWithID:model.cid];
    [request sendRequestWithSuccess:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
        
        [hud hideAnimated:YES];
        NSDictionary * data = [response objectForKey:@"data"];
        FRMyStoreOrderModel * storeModel = [FRMyStoreOrderModel mj_objectWithKeyValues:data];
        storeModel.product_name = model.product_name;
        storeModel.cover = model.cover;
        storeModel.cid = model.cid;
        FROrderDetailViewController * detail = [[FROrderDetailViewController alloc] initWithStoreModel:storeModel];
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

//
//  FROrderDetailViewController.m
//  fatrabbit
//
//  Created by 郭春城 on 2018/8/31.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import "FROrderDetailViewController.h"
#import "FRCommentLevelView.h"
#import "FRCommentViewController.h"
#import "FRApplicatinInfoTool.h"
#import "FRStoreOrderRequest.h"
#import "FROrderRequest.h"
#import <UIImageView+WebCache.h>
#import "MBProgressHUD+FRHUD.h"
#import "UserManager.h"
#import "FROrderPayRequest.h"
#import <AlipaySDK/AlipaySDK.h>
#import "FRStoreOrderDetailCell.h"
#import "FRStoreCartOrderDetailController.h"

@interface FROrderDetailViewController () <UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource, FRCommentViewControllerDelegate>

@property (nonatomic, strong) UITableView * tableView;

@property (nonatomic, strong) UIButton * statusButton;

@property (nonatomic, strong) UIView * bottomView;
@property (nonatomic, strong) FRCommentLevelView * commentLevelView;

@property (nonatomic, strong) FRMyStoreOrderModel * storeModel;
@property (nonatomic, strong) FRMyServiceOrderModel * serviceModel;

@end

@implementation FROrderDetailViewController

- (instancetype)initWithStoreModel:(FRMyStoreOrderModel *)model
{
    if (self = [super init]) {
        self.storeModel = model;
    }
    return self;
}

- (instancetype)initWithServiceModel:(FRMyServiceOrderModel *)model
{
    if (self = [super init]) {
        self.serviceModel = model;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self createViews];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(wechatDidPayStatusChange:) name:DDUserWeChatPayNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(alipayDidPayStatusChange:) name:DDUserAlipayPayNotification object:nil];
    
    if (self.isMyGet) {
        self.bottomView.hidden = YES;
    }
}

//微信支付
- (void)wechatDidPayStatusChange:(NSNotification *)notification
{
    PayResp * resp = notification.object;
    
    if (resp.errCode == WXSuccess) {
        
        UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"付款成功" message:@"支付成功，过程中如有任何问题可以联系服务商" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction * action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
            [self.navigationController popViewControllerAnimated:YES];
            
        }];
        [alert addAction:action];
        [self presentViewController:alert animated:YES completion:nil];
    }else{
        [MBProgressHUD showTextHUDWithText:@"支付失败"];
    }
}

//支付宝支付
- (void)alipayDidPayStatusChange:(NSNotification *)notification
{
    NSDictionary * result = notification.object;
    
    NSString * status = [result objectForKey:@"resultStatus"];
    if ([status isEqualToString:@"9000"]) {
        UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"付款成功" message:@"支付成功，过程中如有任何问题可以联系服务商" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction * action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
            [self.navigationController popViewControllerAnimated:YES];
            
        }];
        [alert addAction:action];
        [self presentViewController:alert animated:YES completion:nil];
    }else if ([status isEqualToString:@"8000"]) {
        UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"未知的错误" message:@"请联系服务商以确定是否支付成功" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction * action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
            [self.navigationController popViewControllerAnimated:YES];
            
        }];
        [alert addAction:action];
        [self presentViewController:alert animated:YES completion:nil];
    }else{
        [MBProgressHUD showTextHUDWithText:@"支付失败"];
    }
}

//立即付款
- (void)payButtonDidClicked
{
    if (self.storeModel) {
        if (self.storeModel.pay_method == 1) {
            
            MBProgressHUD * hud = [MBProgressHUD showLoadingHUDWithText:@"发起支付中" inView:self.view];
            FROrderPayRequest * request = [[FROrderPayRequest alloc] initWithStoreWechatOrderID:self.storeModel.cid];
            [request sendRequestWithSuccess:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
                
                NSDictionary * data = [response objectForKey:@"data"];
                if (KIsDictionary(data)) {
                    
                    PayReq *payRequest = [[PayReq alloc] init];
                    
                    NSString * partnerId = [data objectForKey:@"partnerid"];
                    if ([partnerId isKindOfClass:[NSNumber class]]) {
                        NSInteger temppartnerId = [partnerId integerValue];
                        payRequest.partnerId= [NSString stringWithFormat:@"%ld", temppartnerId];
                    }else{
                        payRequest.partnerId= partnerId;
                    }
                    
                    payRequest.prepayId = [data objectForKey:@"prepayid"];
                    payRequest.package = [data objectForKey:@"package"];
                    payRequest.nonceStr= [data objectForKey:@"noncestr"];
                    payRequest.timeStamp= (int)[[data objectForKey:@"timestamp"] integerValue];
                    payRequest.sign= [data objectForKey:@"sign"];
                    [WXApi sendReq:payRequest];
                    
                }
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
            
        }else if (self.storeModel.pay_method == 2) {
            
            MBProgressHUD * hud = [MBProgressHUD showLoadingHUDWithText:@"发起支付中" inView:self.view];
            FROrderPayRequest * request = [[FROrderPayRequest alloc] initWithStoreAlipayOrderID:self.storeModel.cid];
            [request sendRequestWithSuccess:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
                
                NSDictionary * data = [response objectForKey:@"data"];
                if (KIsDictionary(data)) {
                    NSString * order = [data objectForKey:@"order"];
                    if (!isEmptyString(order)) {
                        [[AlipaySDK defaultService] payOrder:order fromScheme:FRURLScheme callback:^(NSDictionary *resultDic) {
                            
                        }];
                    }else{
                        [MBProgressHUD showTextHUDWithText:@"发起支付失败"];
                    }
                }
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
            
        }else if (self.storeModel.pay_method == 3) {
            [MBProgressHUD showTextHUDWithText:@"该订单支付方式为余额支付"];
        }else if (self.storeModel.pay_method == 4) {
            [MBProgressHUD showTextHUDWithText:@"该订单支付方式为线下支付"];
        }else if (self.storeModel.pay_method == 5) {
            [MBProgressHUD showTextHUDWithText:@"该订单支付方式为积分支付"];
        }
    }else if (self.serviceModel) {
        if (self.serviceModel.paymethod == 1) {
            
            MBProgressHUD * hud = [MBProgressHUD showLoadingHUDWithText:@"发起支付中" inView:self.view];
            FROrderPayRequest * request = [[FROrderPayRequest alloc] initWithServiceWechatOrderID:self.serviceModel.cid];
            if (self.serviceModel.paytype == 2) {
                if (self.serviceModel.paystatus == 1) {
                    if (self.serviceModel.rest_paystatus == 0) {
                        [request configPayType:2];
                    }
                }else{
                    [request configPayType:1];
                }
            }
            [request sendRequestWithSuccess:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
                
                NSDictionary * data = [response objectForKey:@"data"];
                if (KIsDictionary(data)) {
                    
                    PayReq *payRequest = [[PayReq alloc] init];
                    
                    NSString * partnerId = [data objectForKey:@"partnerid"];
                    if ([partnerId isKindOfClass:[NSNumber class]]) {
                        NSInteger temppartnerId = [partnerId integerValue];
                        payRequest.partnerId= [NSString stringWithFormat:@"%ld", temppartnerId];
                    }else{
                        payRequest.partnerId= partnerId;
                    }
                    
                    payRequest.prepayId = [data objectForKey:@"prepayid"];
                    payRequest.package = [data objectForKey:@"package"];
                    payRequest.nonceStr= [data objectForKey:@"noncestr"];
                    payRequest.timeStamp= (int)[[data objectForKey:@"timestamp"] integerValue];
                    payRequest.sign= [data objectForKey:@"sign"];
                    [WXApi sendReq:payRequest];
                    
                }
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
            
        }else if (self.serviceModel.paymethod == 2) {
            
            MBProgressHUD * hud = [MBProgressHUD showLoadingHUDWithText:@"发起支付中" inView:self.view];
            FROrderPayRequest * request = [[FROrderPayRequest alloc] initWithServiceAlipayOrderID:self.serviceModel.cid];
            if (self.serviceModel.paytype == 2) {
                if (self.serviceModel.paystatus == 1) {
                    if (self.serviceModel.rest_paystatus == 0) {
                        [request configPayType:2];
                    }
                }else{
                    [request configPayType:1];
                }
            }
            [request sendRequestWithSuccess:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
                
                NSDictionary * data = [response objectForKey:@"data"];
                if (KIsDictionary(data)) {
                    NSString * order = [data objectForKey:@"order"];
                    if (!isEmptyString(order)) {
                        [[AlipaySDK defaultService] payOrder:order fromScheme:FRURLScheme callback:^(NSDictionary *resultDic) {
                            
                        }];
                    }else{
                        [MBProgressHUD showTextHUDWithText:@"发起支付失败"];
                    }
                }
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
            
        }else{
            [MBProgressHUD showTextHUDWithText:@"该订单支付方式为线下付款"];
        }
    }
}

//取消订单
- (void)cancleButtonDidClicked
{
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"确认要取消该订单吗？" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction * cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    UIAlertAction * sureAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        if (self.storeModel) {
            FROrderRequest * request = [[FROrderRequest alloc] initCancleWithID:self.storeModel.cid];
            [request sendRequestWithSuccess:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
                
                self.storeModel.status = 5;
                [self createTableHeaderView];
                [self createBottomView];
                
            } businessFailure:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
                
                NSString * msg = [response objectForKey:@"msg"];
                if (!isEmptyString(msg)) {
                    [MBProgressHUD showTextHUDWithText:msg];
                }
                
            } networkFailure:^(BGNetworkRequest * _Nonnull request, NSError * _Nullable error) {
                
                [MBProgressHUD showTextHUDWithText:@"网络失去连接"];
                
            }];
        }else if(self.serviceModel){
            FROrderRequest * request = [[FROrderRequest alloc] initCancleServiceWithID:self.serviceModel.cid];
            [request sendRequestWithSuccess:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
                
                self.serviceModel.type = 5;
                [self createTableHeaderView];
                [self createBottomView];
                
            } businessFailure:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
                
                NSString * msg = [response objectForKey:@"msg"];
                if (!isEmptyString(msg)) {
                    [MBProgressHUD showTextHUDWithText:msg];
                }
                
            } networkFailure:^(BGNetworkRequest * _Nonnull request, NSError * _Nullable error) {
                
                [MBProgressHUD showTextHUDWithText:@"网络失去连接"];
                
            }];
        }
        
    }];
    
    [alert addAction:cancleAction];
    [alert addAction:sureAction];
    [self presentViewController:alert animated:YES completion:nil];
}

//前去评价
- (void)goToComment
{
    if (self.storeModel) {
        FRCommentViewController * comment = [[FRCommentViewController alloc] initWithStoreModel:self.storeModel];
        comment.delegate = self;
        [self.navigationController pushViewController:comment animated:YES];
    }else if (self.serviceModel) {
        FRCommentViewController * comment = [[FRCommentViewController alloc] initWithSeriviceModel:self.serviceModel];
        comment.delegate = self;
        [self.navigationController pushViewController:comment animated:YES];
    }
}

- (void)conmentDidCompelete
{
    if (self.storeModel) {
        self.storeModel.status = 4;
    }else if (self.serviceModel) {
        self.serviceModel.type = 4;
    }
    [self createBottomView];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(orderDidNeedUpdate)]) {
        [self.delegate orderDidNeedUpdate];
    }
}

- (void)arriveButtonDidClicked
{
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"确认收货" message:@"确认收货前，请确认商品是否存在问题。" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * action1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    UIAlertAction * action2 = [UIAlertAction actionWithTitle:@"确定收货" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        FRStoreOrderRequest * request = [[FRStoreOrderRequest alloc] initSureArriveWithID:self.storeModel.cid];
        [request sendRequestWithSuccess:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
            
            self.storeModel.status = 3;
            [self createTableHeaderView];
            [self createBottomView];
            
        } businessFailure:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
            
            NSString * msg = [response objectForKey:@"msg"];
            if (!isEmptyString(msg)) {
                [MBProgressHUD showTextHUDWithText:msg];
            }
            
        } networkFailure:^(BGNetworkRequest * _Nonnull request, NSError * _Nullable error) {
            
            [MBProgressHUD showTextHUDWithText:@"网络失去连接"];
            
        }];
        
    }];
    
    [alert addAction:action1];
    [alert addAction:action2];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)contactButtonDidClicked
{
    if (self.storeModel) {
        if (isEmptyString(self.storeModel.kfphone)) {
            [MBProgressHUD showTextHUDWithText:@"暂无联系方式"];
            return;
        }
    }else if (self.serviceModel) {
        if (isEmptyString(self.serviceModel.mobile)) {
            [MBProgressHUD showTextHUDWithText:@"暂无联系方式"];
            return;
        }
    }
    
    NSMutableString  *str;
    if (self.storeModel) {
        str = [[NSMutableString alloc] initWithFormat:@"tel:%@",self.storeModel.kfphone];
    }else{
        str = [[NSMutableString alloc] initWithFormat:@"tel:%@",self.serviceModel.mobile];
    }
    
    if (@available(iOS 10.0, *)) {
        /// 大于等于10.0系统使用此openURL方法
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str] options:@{} completionHandler:nil];
    }else{
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    }
}

- (void)createViews
{
    self.navigationItem.title = @"订单详情";
    
    self.view.backgroundColor = UIColorFromRGB(0xFFFFFF);
    
    CGFloat scale = kMainBoundsWidth / 375.f;
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = UIColorFromRGB(0xFFFFFF);
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 60 * scale, 0);
    
    [self createTableHeaderView];
//    [self createTableFooterView];
    [self createBottomView];
}

- (void)createBottomView
{
    CGFloat scale = kMainBoundsWidth / 375.f;
    
    self.bottomView = [[UIView alloc] initWithFrame:CGRectZero];
    self.bottomView.backgroundColor = UIColorFromRGB(0xf5f5f5);
    [self.view addSubview:self.bottomView];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.mas_equalTo(0);
        make.height.mas_equalTo(40 * scale);
    }];
    
    if (self.storeModel) {
        
        if (self.storeModel.status == 1) {
            if (self.storeModel.pay_method == 4) {
                [self bottomViewWithUnderLine];//待付款的线下支付订单
            }else{
                [self bottomViewWithWaitPay];//待付款
            }
        }else if (self.storeModel.status == 2) {
            [self bottomViewWithWaitArrive];//待收货
        }else if (self.storeModel.status == 3) {
            [self bottomViewWithDeal];//待评价
        }else if (self.storeModel.status == 4) {
            [self bottomViewWithHasComplete];//已完成
        }else if (self.storeModel.status == 5) {
            [self bottomViewWithHasCancle];//已取消
        }
    }else if (self.serviceModel) {
        
        if (self.serviceModel.paytype == 2) {
            if (self.serviceModel.paystatus == 0 || self.serviceModel.rest_paystatus == 0) {
                [self bottomViewWithWaitPay];
                return;
            }
        }
        
        if (self.serviceModel.type == 1 || self.serviceModel.type == 0) {
            [self bottomViewWithWaitPay];
        }else if (self.serviceModel.type == 2) {
            [self bottomViewWithWaitArrive];
        }else if (self.serviceModel.type == 3) {
            [self bottomViewWithDeal];
        }else if (self.serviceModel.type == 4) {
            [self bottomViewWithHasComplete];
        }else if (self.serviceModel.type == 5) {
            [self bottomViewWithHasCancle];
        }
    }
}

/**
 等待付款
 */
- (void)bottomViewWithWaitPay
{
    CGFloat scale = kMainBoundsWidth / 375.f;
    
    UILabel * totalTipLabel = [FRCreateViewTool createLabelWithFrame:CGRectZero font:kPingFangRegular(15 * scale) textColor:UIColorFromRGB(0x333333) alignment:NSTextAlignmentRight];
    totalTipLabel.text = @"合计：";
    [self.bottomView addSubview:totalTipLabel];
    [totalTipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.mas_equalTo(0);
        make.width.mas_equalTo(kMainBoundsWidth / 5.f);
    }];
    
    UILabel * priceLabel = [FRCreateViewTool createLabelWithFrame:CGRectZero font:kPingFangRegular(15 * scale) textColor:KThemeColor alignment:NSTextAlignmentLeft];
    
    UIButton * payButton = [FRCreateViewTool createButtonWithFrame:CGRectZero font:kPingFangRegular(15 * scale) titleColor:UIColorFromRGB(0xffffff) title:@"立即付款"];
    
    if (self.storeModel) {
        if (self.storeModel.points > 0) {
            if (self.storeModel.pay_amount > 0) {
                priceLabel.text = [NSString stringWithFormat:@"%.2lf + %.2lf 积分", self.storeModel.pay_amount, self.storeModel.points];
            }else{
                priceLabel.text = [NSString stringWithFormat:@"%.2lf 积分", self.storeModel.points];
            }
        }else{
            priceLabel.text = [NSString stringWithFormat:@"%.2lf", self.storeModel.pay_amount];
        }
    }else if (self.serviceModel){
        priceLabel.text = [NSString stringWithFormat:@"%.2lf", self.serviceModel.amount];
    }
    [self.bottomView addSubview:priceLabel];
    [priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(0);
        make.left.mas_equalTo(totalTipLabel.mas_right);
        make.width.mas_equalTo(kMainBoundsWidth / 2.f - kMainBoundsWidth / 5.f);
    }];
    
    if (self.serviceModel) {
        if (self.serviceModel.paytype == 2) {
            if (self.serviceModel.paystatus == 1) {
                if (self.serviceModel.rest_paystatus == 0) {
                    [payButton setTitle:@"支付尾款" forState:UIControlStateNormal];
                }
            }else{
                [payButton setTitle:@"支付定金" forState:UIControlStateNormal];
            }
        }
    }
    [payButton addTarget:self action:@selector(payButtonDidClicked) forControlEvents:UIControlEventTouchUpInside];
    payButton.backgroundColor = KPriceColor;
    [self.bottomView addSubview:payButton];
    [payButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.bottom.mas_equalTo(0);
        make.width.mas_equalTo(kMainBoundsWidth / 4.f);
    }];
    
    UIButton * cancleButton = [FRCreateViewTool createButtonWithFrame:CGRectZero font:kPingFangRegular(15 * scale) titleColor:UIColorFromRGB(0xffffff) title:@"取消订单"];
    [cancleButton addTarget:self action:@selector(cancleButtonDidClicked) forControlEvents:UIControlEventTouchUpInside];
    cancleButton.backgroundColor = UIColorFromRGB(0x999999);
    [self.bottomView addSubview:cancleButton];
    [cancleButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(0);
        make.right.mas_equalTo(payButton.mas_left);
        make.width.mas_equalTo(kMainBoundsWidth / 4.f);
    }];
    
    [self.statusButton setImage:[UIImage imageNamed:@"orderSmail"] forState:UIControlStateNormal];
    [self.statusButton setTitle:@"  已下单，待付款" forState:UIControlStateNormal];
}

/**
 等待发货
 */
- (void)bottomViewWithWaitSend
{
    CGFloat scale = kMainBoundsWidth / 375.f;
    
    UIButton * contactButton = [FRCreateViewTool createButtonWithFrame:CGRectZero font:kPingFangRegular(15 * scale) titleColor:UIColorFromRGB(0xffffff) title:@"联系他们"];
    if (self.storeModel) {
        [contactButton setTitle:@"联系客服" forState:UIControlStateNormal];
    }
    contactButton.backgroundColor = UIColorFromRGB(0xf8bf44);
    [contactButton addTarget:self action:@selector(contactButtonDidClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomView addSubview:contactButton];
    [contactButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.mas_equalTo(0);
        make.width.mas_equalTo(kMainBoundsWidth / 2.f);
    }];
    
    UIButton * arriveButton = [FRCreateViewTool createButtonWithFrame:CGRectZero font:kPingFangRegular(15 * scale) titleColor:UIColorFromRGB(0xffffff) title:@"确认送达"];
    arriveButton.backgroundColor = KPriceColor;
    [self.bottomView addSubview:arriveButton];
    [arriveButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.bottom.mas_equalTo(0);
        make.width.mas_equalTo(kMainBoundsWidth / 2.f);
    }];
    [arriveButton addTarget:self action:@selector(arriveButtonDidClicked) forControlEvents:UIControlEventTouchUpInside];
    
    [self.statusButton setImage:[UIImage imageNamed:@"orderSmail"] forState:UIControlStateNormal];
    [self.statusButton setTitle:@"  等待发货" forState:UIControlStateNormal];
}

/**
 等待收货
 */
- (void)bottomViewWithWaitArrive
{
    CGFloat scale = kMainBoundsWidth / 375.f;
    
    UIButton * contactButton = [FRCreateViewTool createButtonWithFrame:CGRectZero font:kPingFangRegular(15 * scale) titleColor:UIColorFromRGB(0xffffff) title:@"联系他们"];
    
    if (self.storeModel) {
        [contactButton setTitle:@"联系客服" forState:UIControlStateNormal];
    }
    
    contactButton.backgroundColor = UIColorFromRGB(0xf8bf44);
    [contactButton addTarget:self action:@selector(contactButtonDidClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomView addSubview:contactButton];
    [contactButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.mas_equalTo(0);
        make.width.mas_equalTo(kMainBoundsWidth / 2.f);
    }];
    
    UIButton * arriveButton = [FRCreateViewTool createButtonWithFrame:CGRectZero font:kPingFangRegular(15 * scale) titleColor:UIColorFromRGB(0xffffff) title:@"确认送达"];
    arriveButton.backgroundColor = KPriceColor;
    [self.bottomView addSubview:arriveButton];
    [arriveButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.bottom.mas_equalTo(0);
        make.width.mas_equalTo(kMainBoundsWidth / 2.f);
    }];
    [arriveButton addTarget:self action:@selector(arriveButtonDidClicked) forControlEvents:UIControlEventTouchUpInside];

    
    [self.statusButton setImage:[UIImage imageNamed:@"orderSmail"] forState:UIControlStateNormal];
    [self.statusButton setTitle:@"  等待送达" forState:UIControlStateNormal];
    if (self.serviceModel) {
        [self.statusButton setTitle:@"  等待服务完成" forState:UIControlStateNormal];
        arriveButton.hidden = YES;
        [contactButton mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(kMainBoundsWidth);
        }];
    }
}

/**
 已付款
 */
- (void)bottomViewWithHasPay
{
    CGFloat scale = kMainBoundsWidth / 375.f;
    
    UIButton * contactButton = [FRCreateViewTool createButtonWithFrame:CGRectZero font:kPingFangRegular(15 * scale) titleColor:UIColorFromRGB(0xffffff) title:@"联系他们"];
    if (self.storeModel) {
        [contactButton setTitle:@"联系客服" forState:UIControlStateNormal];
    }
    contactButton.backgroundColor = UIColorFromRGB(0xf8bf44);
    [contactButton addTarget:self action:@selector(contactButtonDidClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomView addSubview:contactButton];
    [contactButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.mas_equalTo(0);
        make.width.mas_equalTo(kMainBoundsWidth / 2.f);
    }];
    
    UIButton * completeButton = [FRCreateViewTool createButtonWithFrame:CGRectZero font:kPingFangRegular(15 * scale) titleColor:UIColorFromRGB(0xffffff) title:@"确认服务完成"];
    completeButton.backgroundColor = KPriceColor;
    [self.bottomView addSubview:completeButton];
    [completeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.bottom.mas_equalTo(0);
        make.width.mas_equalTo(kMainBoundsWidth / 2.f);
    }];
    [self.statusButton setImage:[UIImage imageNamed:@"orderSmail"] forState:UIControlStateNormal];
    [self.statusButton setTitle:@"  已付款，下单成功" forState:UIControlStateNormal];
}

/**
 交易成功
 */
- (void)bottomViewWithDeal
{
    CGFloat scale = kMainBoundsWidth / 375.f;
    
    UIButton * contactButton = [FRCreateViewTool createButtonWithFrame:CGRectZero font:kPingFangRegular(15 * scale) titleColor:UIColorFromRGB(0xffffff) title:@"联系他们"];
    if (self.storeModel) {
        [contactButton setTitle:@"联系客服" forState:UIControlStateNormal];
    }
    contactButton.backgroundColor = UIColorFromRGB(0xf8bf44);
    [contactButton addTarget:self action:@selector(contactButtonDidClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomView addSubview:contactButton];
    [contactButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.mas_equalTo(0);
        make.width.mas_equalTo(kMainBoundsWidth / 2.f);
    }];
    
    UIButton * commentButton = [FRCreateViewTool createButtonWithFrame:CGRectZero font:kPingFangRegular(15 * scale) titleColor:UIColorFromRGB(0xffffff) title:@"评价"];
    commentButton.backgroundColor = KPriceColor;
    [self.bottomView addSubview:commentButton];
    [commentButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.bottom.mas_equalTo(0);
        make.width.mas_equalTo(kMainBoundsWidth / 2.f);
    }];
    [commentButton addTarget:self action:@selector(goToComment) forControlEvents:UIControlEventTouchUpInside];
    
    [self.statusButton setImage:[UIImage imageNamed:@"orderSmail"] forState:UIControlStateNormal];
    [self.statusButton setTitle:@"  交易成功" forState:UIControlStateNormal];
}

/**
 评价成功
 */
- (void)bottomViewWithHasComplete
{
    CGFloat scale = kMainBoundsWidth / 375.f;
    
    UIButton * contactButton = [FRCreateViewTool createButtonWithFrame:CGRectZero font:kPingFangRegular(15 * scale) titleColor:UIColorFromRGB(0xffffff) title:@"联系他们"];
    if (self.storeModel) {
        [contactButton setTitle:@"联系客服" forState:UIControlStateNormal];
    }
    contactButton.backgroundColor = UIColorFromRGB(0xf8bf44);
    [contactButton addTarget:self action:@selector(contactButtonDidClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomView addSubview:contactButton];
    [contactButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.mas_equalTo(0);
        make.width.mas_equalTo(kMainBoundsWidth);
    }];
    
    [self.statusButton setImage:[UIImage imageNamed:@"orderSmail"] forState:UIControlStateNormal];
    [self.statusButton setTitle:@"  交易成功" forState:UIControlStateNormal];
}

/**
 订单取消
 */
- (void)bottomViewWithHasCancle
{
    CGFloat scale = kMainBoundsWidth / 375.f;
    
    UIButton * contactButton = [FRCreateViewTool createButtonWithFrame:CGRectZero font:kPingFangRegular(15 * scale) titleColor:UIColorFromRGB(0xffffff) title:@"联系他们"];
    if (self.storeModel) {
        [contactButton setTitle:@"联系客服" forState:UIControlStateNormal];
    }
    contactButton.backgroundColor = UIColorFromRGB(0xf8bf44);
    [contactButton addTarget:self action:@selector(contactButtonDidClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomView addSubview:contactButton];
    [contactButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.mas_equalTo(0);
        make.width.mas_equalTo(kMainBoundsWidth);
    }];
    
    [self.statusButton setImage:[UIImage imageNamed:@"orderSmail"] forState:UIControlStateNormal];
    [self.statusButton setTitle:@"  订单已取消" forState:UIControlStateNormal];
}

/**
 线下支付
 */
- (void)bottomViewWithUnderLine
{
    CGFloat scale = kMainBoundsWidth / 375.f;
    
    UILabel * totalTipLabel = [FRCreateViewTool createLabelWithFrame:CGRectZero font:kPingFangRegular(15 * scale) textColor:UIColorFromRGB(0x333333) alignment:NSTextAlignmentRight];
    totalTipLabel.text = @"合计：";
    [self.bottomView addSubview:totalTipLabel];
    [totalTipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.mas_equalTo(0);
        make.width.mas_equalTo(kMainBoundsWidth / 5.f);
    }];
    
    UILabel * priceLabel = [FRCreateViewTool createLabelWithFrame:CGRectZero font:kPingFangRegular(15 * scale) textColor:KThemeColor alignment:NSTextAlignmentLeft];
    if (self.storeModel) {
        if (self.storeModel.points > 0) {
            if (self.storeModel.pay_amount > 0) {
                priceLabel.text = [NSString stringWithFormat:@"%.2lf + %.2lf 积分", self.storeModel.pay_amount, self.storeModel.points];
            }else{
                priceLabel.text = [NSString stringWithFormat:@"%.2lf 积分", self.storeModel.points];
            }
        }else{
            priceLabel.text = [NSString stringWithFormat:@"%.2lf", self.storeModel.pay_amount];
        }
    }else if (self.serviceModel){
        priceLabel.text = [NSString stringWithFormat:@"%.2lf", self.serviceModel.amount];
    }
    [self.bottomView addSubview:priceLabel];
    [priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(0);
        make.left.mas_equalTo(totalTipLabel.mas_right);
        make.width.mas_equalTo(kMainBoundsWidth / 4.f * 3 - kMainBoundsWidth / 5.f);
    }];
    
    UIButton * contactButton = [FRCreateViewTool createButtonWithFrame:CGRectZero font:kPingFangRegular(15 * scale) titleColor:UIColorFromRGB(0xffffff) title:@"联系他们"];
    if (self.storeModel) {
        [contactButton setTitle:@"联系客服" forState:UIControlStateNormal];
    }
    contactButton.backgroundColor = UIColorFromRGB(0xf8bf44);
    [contactButton addTarget:self action:@selector(contactButtonDidClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomView addSubview:contactButton];
    [contactButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.bottom.mas_equalTo(0);
        make.width.mas_equalTo(kMainBoundsWidth / 4.f);
    }];
    
    [self.statusButton setImage:[UIImage imageNamed:@"orderSmail"] forState:UIControlStateNormal];
    [self.statusButton setTitle:@"  已下单，线下付款" forState:UIControlStateNormal];
}

- (void)createTableHeaderView
{
    CGFloat scale = kMainBoundsWidth / 375.f;
    
    CGFloat height = 340 * scale;
    if (self.storeModel) {
        height = 500 * scale;
    }
    UIView * headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainBoundsWidth, height)];
    
    UILabel * orderNumberLabel = [FRCreateViewTool createLabelWithFrame:CGRectZero font:kPingFangRegular(13 * scale) textColor:UIColorFromRGB(0x333333) alignment:NSTextAlignmentLeft];
    if (self.storeModel) {
        orderNumberLabel.text = [NSString stringWithFormat:@"订单编号：%@", self.storeModel.sn];
    }else if (self.serviceModel){
        orderNumberLabel.text = [NSString stringWithFormat:@"订单编号：%@", self.serviceModel.sn];
    }
    [headerView addSubview:orderNumberLabel];
    [orderNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(15 * scale);
        make.left.mas_equalTo(15 * scale);
        make.height.mas_equalTo(20 * scale);
    }];
    
    UILabel * creatTimeLabel = [FRCreateViewTool createLabelWithFrame:CGRectZero font:kPingFangRegular(13 * scale) textColor:UIColorFromRGB(0x333333) alignment:NSTextAlignmentLeft];
    if (self.storeModel) {
        creatTimeLabel.text = [NSString stringWithFormat:@"创建时间：%@", [FRApplicatinInfoTool getSecondStrTimeWithTime:self.storeModel.addtime]];
    }else if (self.serviceModel){
        creatTimeLabel.text = [NSString stringWithFormat:@"创建时间：%@", self.serviceModel.addtime];
    }
    [headerView addSubview:creatTimeLabel];
    [creatTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(orderNumberLabel.mas_bottom);
        make.left.mas_equalTo(15 * scale);
        make.height.mas_equalTo(20 * scale);
    }];
    
    UILabel * payTimeLabel = [FRCreateViewTool createLabelWithFrame:CGRectZero font:kPingFangRegular(13 * scale) textColor:UIColorFromRGB(0x333333) alignment:NSTextAlignmentLeft];
    if (self.storeModel) {
        payTimeLabel.text = [NSString stringWithFormat:@"支付时间：%@", [FRApplicatinInfoTool getSecondStrTimeWithTime:self.storeModel.paytime]];
    }else if (self.serviceModel) {
        if (isEmptyString(self.serviceModel.paytime)) {
            payTimeLabel.text = @"支付时间：无";
        }else{
            payTimeLabel.text = [NSString stringWithFormat:@"支付时间：%@", self.serviceModel.paytime];
        }
    }
    [headerView addSubview:payTimeLabel];
    [payTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(creatTimeLabel.mas_bottom);
        make.left.mas_equalTo(15 * scale);
        make.height.mas_equalTo(20 * scale);
    }];
    
    UILabel * sureTimeLabel = [FRCreateViewTool createLabelWithFrame:CGRectZero font:kPingFangRegular(13 * scale) textColor:UIColorFromRGB(0x333333) alignment:NSTextAlignmentLeft];
    if (self.storeModel) {
        sureTimeLabel.text = [NSString stringWithFormat:@"确认支付时间：%@", [FRApplicatinInfoTool getSecondStrTimeWithTime:self.storeModel.paytime]];
    }else if (self.serviceModel) {
        if (isEmptyString(self.serviceModel.paytime)) {
            sureTimeLabel.text = @"确认支付时间：无";
        }else{
            sureTimeLabel.text = [NSString stringWithFormat:@"确认支付时间：%@", self.serviceModel.paytime];
        }
    }
    [headerView addSubview:sureTimeLabel];
    [sureTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(payTimeLabel.mas_bottom);
        make.left.mas_equalTo(15 * scale);
        make.height.mas_equalTo(20 * scale);
    }];
    
    self.statusButton = [FRCreateViewTool createButtonWithFrame:CGRectZero font:kPingFangLight(20 * scale) titleColor:UIColorFromRGB(0x333333) title:@""];
    self.statusButton.enabled = NO;
    [headerView addSubview:self.statusButton];
    [self.statusButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.mas_equalTo(110 * scale);
        make.height.mas_equalTo(40 * scale);
    }];
    
    UIView * lineView = [[UIView alloc] initWithFrame:CGRectZero];
    lineView.backgroundColor = UIColorFromRGB(0xf5f5f5);
    [headerView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.statusButton.mas_bottom).offset(25 * scale);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(10 * scale);
    }];
    
    if (self.serviceModel) {
        
        //创建服务订单UI
        UIImageView * companyImageView = [FRCreateViewTool createImageViewWithFrame:CGRectZero contentModel:UIViewContentModeScaleAspectFill image:[UIImage imageNamed:@"orderStore"]];
        companyImageView.clipsToBounds = YES;
        [headerView addSubview:companyImageView];
        [companyImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(lineView.mas_bottom).offset(15 * scale);
            make.left.mas_equalTo(15 * scale);
            make.width.height.mas_equalTo(25 * scale);
        }];
        
        UILabel * companyLabel = [FRCreateViewTool createLabelWithFrame:CGRectZero font:kPingFangRegular(13 * scale) textColor:UIColorFromRGB(0x333333) alignment:NSTextAlignmentLeft];
        [headerView addSubview:companyLabel];
        [companyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(companyImageView);
            make.left.mas_equalTo(companyImageView.mas_right).offset(10 * scale);
            make.height.mas_equalTo(20 * scale);
        }];
        if (self.storeModel) {
            companyLabel.text = self.storeModel.consignee;
        }else if (self.serviceModel) {
            companyLabel.text = self.serviceModel.provider_name;
        }
        
        UIView * companyLineView = [[UIView alloc] initWithFrame:CGRectZero];
        companyLineView.backgroundColor = UIColorFromRGB(0xCCCCCC);
        [headerView addSubview:companyLineView];
        [companyLineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(companyImageView.mas_bottom).offset(15 * scale);
            make.left.mas_equalTo(15 * scale);
            make.width.mas_equalTo(kMainBoundsWidth - 30 * scale);
            make.height.mas_equalTo(.5f);
        }];
        
        UIImageView * coverImageView = [FRCreateViewTool createImageViewWithFrame:CGRectZero contentModel:UIViewContentModeScaleAspectFill image:[UIImage new]];
        coverImageView.clipsToBounds = YES;
        if (self.storeModel) {
            if (isEmptyString(self.storeModel.cover)) {
                for (FRStoreCartModel * model in self.storeModel.plist) {
                    [coverImageView sd_setImageWithURL:[NSURL URLWithString:model.cover]];
                    break;
                }
            }else{
                [coverImageView sd_setImageWithURL:[NSURL URLWithString:self.storeModel.cover]];
            }
        }else if (self.serviceModel) {
            [coverImageView sd_setImageWithURL:[NSURL URLWithString:self.serviceModel.cover]];
        }
        [headerView addSubview:coverImageView];
        [coverImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(companyLineView.mas_bottom).offset(20 * scale);
            make.left.mas_equalTo(15 * scale);
            make.width.mas_equalTo(120 * scale);
            make.height.mas_equalTo(70 * scale);
        }];
        
        UILabel * nameLabel = [FRCreateViewTool createLabelWithFrame:CGRectZero font:kPingFangMedium(13 * scale) textColor:UIColorFromRGB(0x333333) alignment:NSTextAlignmentLeft];
        [headerView addSubview:nameLabel];
        [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(coverImageView).offset(5 * scale);
            make.left.mas_equalTo(coverImageView.mas_right).offset(10 * scale);
            make.width.mas_equalTo(kMainBoundsWidth - 150 * scale);
            make.height.mas_equalTo(20 * scale);
        }];
        if (self.storeModel) {
            if (isEmptyString(self.storeModel.product_name)) {
                for (FRStoreCartModel * model in self.storeModel.plist) {
                    nameLabel.text = model.pname;
                    break;
                }
            }else{
                nameLabel.text = self.storeModel.product_name;
            }
        }else if (self.serviceModel) {
            nameLabel.text = self.serviceModel.title;
        }
        
        UILabel * numberLabel = [FRCreateViewTool createLabelWithFrame:CGRectZero font:kPingFangRegular(11 * scale) textColor:UIColorFromRGB(0x999999) alignment:NSTextAlignmentLeft];
        if (self.storeModel) {
            numberLabel.text = [NSString stringWithFormat:@"数量：%ld", self.storeModel.num];
        }else if (self.serviceModel) {
            numberLabel.text = [NSString stringWithFormat:@"数量：%ld", self.serviceModel.num];
        }
        [headerView addSubview:numberLabel];
        [numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(coverImageView).offset(-5 * scale);
            make.height.mas_equalTo(20 * scale);
            make.left.mas_equalTo(nameLabel);
        }];
        
        UILabel * totalLabel = [FRCreateViewTool createLabelWithFrame:CGRectZero font:kPingFangRegular(13 * scale) textColor:UIColorFromRGB(0x333333) alignment:NSTextAlignmentLeft];
        totalLabel.text = @"合计：";
        [headerView addSubview:totalLabel];
        [totalLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(numberLabel);
            make.height.mas_equalTo(20 * scale);
            make.left.mas_equalTo(numberLabel.mas_right).offset(30 * scale);
        }];
        
        UILabel * totalPriceLabel = [FRCreateViewTool createLabelWithFrame:CGRectZero font:kPingFangRegular(13 * scale) textColor:KThemeColor alignment:NSTextAlignmentLeft];
        if (self.storeModel) {
            totalPriceLabel.text = [NSString stringWithFormat:@"%.2lf", self.storeModel.pay_amount];
        }else if (self.serviceModel) {
            totalPriceLabel.text = [NSString stringWithFormat:@"%.2lf", self.serviceModel.amount];
        }
        [headerView addSubview:totalPriceLabel];
        [totalPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(totalLabel);
            make.height.mas_equalTo(20 * scale);
            make.left.mas_equalTo(totalLabel.mas_right);
        }];
        
    }else if (self.storeModel) {
        
        //创建商品订单UI
        UILabel * arriveTipLabel = [FRCreateViewTool createLabelWithFrame:CGRectZero font:kPingFangRegular(12 * scale) textColor:UIColorFromRGB(0x333333) alignment:NSTextAlignmentLeft];
        arriveTipLabel.text = @"物流信息";
        [headerView addSubview:arriveTipLabel];
        [arriveTipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(lineView.mas_bottom).offset(15 * scale);
            make.left.mas_equalTo(15 * scale);
            make.height.mas_equalTo(15 * scale);
        }];
        
        UILabel * arriveLabel = [FRCreateViewTool createLabelWithFrame:CGRectZero font:kPingFangRegular(12 * scale) textColor:UIColorFromRGB(0x999999) alignment:NSTextAlignmentLeft];
        arriveLabel.text = @"暂无物流信息";
        [headerView addSubview:arriveLabel];
        if (self.storeModel.shipping_status == 1) {
            arriveLabel.text = @"未发货";
        }else if (self.storeModel.shipping_status == 2) {
            arriveLabel.text = @"已发货";
        }else if (self.storeModel.shipping_status == 3) {
            arriveLabel.text = @"已确认收货";
        }
        [arriveLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(arriveTipLabel);
            make.left.mas_equalTo(arriveTipLabel.mas_right).offset(30 * scale);
            make.height.mas_equalTo(15 * scale);
        }];
        
        UIView * arriveLineView = [[UIView alloc] initWithFrame:CGRectZero];
        arriveLineView.backgroundColor = UIColorFromRGB(0xf5f5f5);
        [headerView addSubview:arriveLineView];
        [arriveLineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(arriveTipLabel.mas_bottom).offset(25 * scale);
            make.left.right.mas_equalTo(0);
            make.height.mas_equalTo(10 * scale);
        }];
        
        UILabel * receTipLabel = [FRCreateViewTool createLabelWithFrame:CGRectZero font:kPingFangRegular(12 * scale) textColor:UIColorFromRGB(0x333333) alignment:NSTextAlignmentLeft];
        receTipLabel.text = @"收货信息";
        [headerView addSubview:receTipLabel];
        [receTipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(arriveLineView.mas_bottom).offset(15 * scale);
            make.left.mas_equalTo(15 * scale);
            make.height.mas_equalTo(15 * scale);
            make.width.mas_equalTo(63 * scale);
        }];
        
        UILabel * receNameLabel = [FRCreateViewTool createLabelWithFrame:CGRectZero font:kPingFangRegular(12 * scale) textColor:UIColorFromRGB(0x999999) alignment:NSTextAlignmentLeft];
        receNameLabel.text = self.storeModel.consignee;
        [headerView addSubview:receNameLabel];
        [receNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(receTipLabel);
            make.left.mas_equalTo(receTipLabel.mas_right).offset(15 * scale);
            make.height.mas_equalTo(15 * scale);
        }];
        
        UILabel * receTelLabel = [FRCreateViewTool createLabelWithFrame:CGRectZero font:kPingFangRegular(12 * scale) textColor:UIColorFromRGB(0x999999) alignment:NSTextAlignmentLeft];
        receTelLabel.text = self.storeModel.mobile;
        [headerView addSubview:receTelLabel];
        [receTelLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(receTipLabel);
            make.left.mas_equalTo(receNameLabel.mas_right).offset(15 * scale);
            make.height.mas_equalTo(15 * scale);
        }];
        
        UILabel * receAddressLabel = [FRCreateViewTool createLabelWithFrame:CGRectZero font:kPingFangRegular(12 * scale) textColor:UIColorFromRGB(0x999999) alignment:NSTextAlignmentLeft];
        receAddressLabel.numberOfLines = 0;
        receAddressLabel.text = self.storeModel.address;
        [headerView addSubview:receAddressLabel];
        [receAddressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(receTipLabel.mas_bottom).offset(10 * scale);
            make.left.mas_equalTo(receTipLabel.mas_right).offset(15 * scale);
            make.right.mas_equalTo(-15 * scale);
            make.height.mas_lessThanOrEqualTo(40 * scale);
        }];
        
        UIView * receLineView = [[UIView alloc] initWithFrame:CGRectZero];
        receLineView.backgroundColor = UIColorFromRGB(0xf5f5f5);
        [headerView addSubview:receLineView];
        [receLineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(receAddressLabel.mas_bottom).offset(10 * scale);
            make.left.right.mas_equalTo(0);
            make.height.mas_equalTo(10 * scale);
        }];
        
        UILabel * orderTipLabel = [FRCreateViewTool createLabelWithFrame:CGRectZero font:kPingFangRegular(12 * scale) textColor:UIColorFromRGB(0x333333) alignment:NSTextAlignmentLeft];
        orderTipLabel.text = @"订单明细";
        [headerView addSubview:orderTipLabel];
        [orderTipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(receLineView.mas_bottom).offset(15 * scale);
            make.left.mas_equalTo(15 * scale);
            make.height.mas_equalTo(20 * scale);
        }];
        
        CGFloat width = (kMainBoundsWidth - 20 * scale) / 5.f;
        UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(width, width);
        layout.minimumLineSpacing = 5 * scale;
        layout.minimumInteritemSpacing = 5 * scale;
        
        UICollectionView * collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        [collectionView registerClass:[FRStoreOrderDetailCell class] forCellWithReuseIdentifier:@"FRStoreOrderDetailCell"];
        collectionView.backgroundColor = UIColorFromRGB(0xffffff);
        collectionView.delegate = self;
        collectionView.dataSource = self;
        collectionView.scrollEnabled = NO;
        [headerView addSubview:collectionView];
        [collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(orderTipLabel.mas_bottom).offset(5 * scale);
            make.left.mas_equalTo(15 * scale);
            make.width.mas_equalTo((width + 10 * scale) * 3);
            make.height.mas_equalTo(width + 10 * scale);
        }];
        
        UIImageView * moreImageView = [FRCreateViewTool createImageViewWithFrame:CGRectZero contentModel:UIViewContentModeScaleAspectFill image:[UIImage imageNamed:@"more"]];
        [headerView addSubview:moreImageView];
        [moreImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(collectionView);
            make.right.mas_equalTo(-15);
            make.width.mas_equalTo(7);
            make.height.mas_equalTo(13);
        }];
        
        UILabel * orderNumberLabel = [FRCreateViewTool createLabelWithFrame:CGRectZero font:kPingFangRegular(10 * scale) textColor:UIColorFromRGB(0x999999) alignment:NSTextAlignmentLeft];
        orderNumberLabel.text = [NSString stringWithFormat:@"共%ld件", self.storeModel.plist.count];
        [headerView addSubview:orderNumberLabel];
        [orderNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(moreImageView);
            make.height.mas_equalTo(20 * scale);
            make.right.mas_equalTo(moreImageView.mas_left).offset(-10 * scale);
        }];
        
        UIButton * moreButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [moreButton addTarget:self action:@selector(moreButtonDidClicked) forControlEvents:UIControlEventTouchUpInside];
        [headerView addSubview:moreButton];
        [moreButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-10 * scale);
            make.width.mas_equalTo(kMainBoundsWidth / 5.f);
            make.height.mas_equalTo(50 * scale);
            make.centerY.mas_equalTo(moreImageView);
        }];
    }
    
    self.tableView.tableHeaderView = headerView;
}

- (void)moreButtonDidClicked
{
    FRStoreCartOrderDetailController * detail = [[FRStoreCartOrderDetailController alloc] initWithDataSource:self.storeModel.plist];
    [self.navigationController pushViewController:detail animated:YES];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (self.storeModel.plist.count > 3) {
        return 3;
    }else{
        return self.storeModel.plist.count;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    FRStoreOrderDetailCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"FRStoreOrderDetailCell" forIndexPath:indexPath];
    
    FRStoreCartModel * model = [self.storeModel.plist objectAtIndex:indexPath.row];
    [cell configWithModel:model];
    
    return cell;
}

- (void)createTableFooterView
{
    CGFloat scale = kMainBoundsWidth / 375.f;
    
    CGFloat height = 200 * scale;
    
    NSString * comment = @"暂无评价内容";
    CGSize size = [comment boundingRectWithSize:CGSizeMake(kMainBoundsWidth - 30 * scale, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:kPingFangRegular(12 * scale)} context:nil].size;
    height += size.height;
    
    UIView * footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainBoundsWidth, height)];
    
    UILabel * commentLabel = [FRCreateViewTool createLabelWithFrame:CGRectZero font:kPingFangRegular(13 * scale) textColor:UIColorFromRGB(0x333333) alignment:NSTextAlignmentLeft];
    commentLabel.text = @"整体评价：";
    [footerView addSubview:commentLabel];
    [commentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10 * scale);
        make.left.mas_equalTo(15 * scale);
        make.height.mas_equalTo(20 * scale);
    }];
    
    UIView * commentLineView = [[UIView alloc] initWithFrame:CGRectZero];
    commentLineView.backgroundColor = UIColorFromRGB(0xCCCCCC);
    [footerView addSubview:commentLineView];
    [commentLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(commentLabel.mas_bottom).mas_equalTo(20 * scale);
        make.left.mas_equalTo(15 * scale);
        make.width.mas_equalTo(kMainBoundsWidth - 30 * scale);
        make.height.mas_equalTo(.5f);
    }];
    
    UILabel * commentDetailLabel = [FRCreateViewTool createLabelWithFrame:CGRectZero font:kPingFangRegular(12 * scale) textColor:UIColorFromRGB(0x999999) alignment:NSTextAlignmentLeft];
    commentDetailLabel.numberOfLines = 0;
    commentDetailLabel.text = comment;
    [footerView addSubview:commentDetailLabel];
    [commentDetailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(commentLineView.mas_bottom).offset(10 * scale);
        make.left.mas_equalTo(15 * scale);
        make.width.mas_equalTo(kMainBoundsWidth - 30 * scale);
    }];
    
    UIView * lineView = [[UIView alloc] initWithFrame:CGRectZero];
    lineView.backgroundColor = UIColorFromRGB(0xf5f5f5);
    [footerView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(commentDetailLabel.mas_bottom).offset(10 * scale);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(10 * scale);
    }];
    
    self.commentLevelView = [[FRCommentLevelView alloc] initWithCommentNormal];
    [self.commentLevelView showWithServiceLevel:2 companyLevel:4 businessLevel:3];
    [footerView addSubview:self.commentLevelView];
    [self.commentLevelView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(lineView.mas_bottom);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(125 * scale);
    }];
    
    self.tableView.tableFooterView = footerView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
    
    cell.backgroundColor = UIColorFromRGB(0xFFFFFF);
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return .1f;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:DDUserWeChatPayNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:DDUserAlipayPayNotification object:nil];
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

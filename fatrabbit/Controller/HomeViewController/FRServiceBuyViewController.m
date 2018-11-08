//
//  FRServiceBuyViewController.m
//  fatrabbit
//
//  Created by 郭春城 on 2018/9/27.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import "FRServiceBuyViewController.h"
#import "FRServicePayWayCell.h"
#import <TZImagePickerController.h>
#import "RDTextView.h"
#import "FRImageCollectionViewCell.h"
#import "LookImageViewController.h"
#import "MBProgressHUD+FRHUD.h"
#import "FRUploadManager.h"
#import "FRServiceRequest.h"
#import "FROrderPayRequest.h"
#import <AlipaySDK/AlipaySDK.h>
#import "FRChoosePayWayView.h"
#import "FRStorePayMenuModel.h"
#import "UserManager.h"
#import "FROrderRequest.h"
#import "FROrderDetailViewController.h"

@interface FRServiceBuyViewController () <UITableViewDelegate, UITableViewDataSource, TZImagePickerControllerDelegate, UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) FRMySeriviceModel * model;

@property (nonatomic, strong) UIView * contentView;
@property (nonatomic, strong) RDTextView * textView;
@property (nonatomic, strong) UICollectionView * imageCollectionView;
@property (nonatomic, strong) NSMutableArray * imageSource;
@property (nonatomic, assign) NSInteger maxCount;
@property (nonatomic, assign) NSInteger number;
@property (nonatomic, strong) UIButton * numberButton;
@property (nonatomic, strong) UIButton * addButton;
@property (nonatomic, strong) UIButton * deleteButton;

@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) NSArray * dataSource;

@property (nonatomic, strong) UILabel * priceLabel;
@property (nonatomic, strong) UIButton * buyButton;

@property (nonatomic, strong) FRServicePayWayModel * chooseModel;
@property (nonatomic, strong) FRStorePayMenuModel * payWayModel;

@property (nonatomic, assign) NSInteger orderID;

@end

@implementation FRServiceBuyViewController

- (instancetype)initWithModel:(FRMySeriviceModel *)model
{
    if (self = [super init]) {
        self.model = model;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.number = 1;
    self.maxCount = 3;
    self.navigationItem.title = @"确认订单";
    self.dataSource = @[[[FRServicePayWayModel alloc] initWithType:FRServicePayWay_All],
                        [[FRServicePayWayModel alloc] initWithType:FRServicePayWay_Half],
                        [[FRServicePayWayModel alloc] initWithType:FRServicePayWay_DownLine]];
    self.chooseModel = self.dataSource.firstObject;
    self.payWayModel = [[FRStorePayMenuModel alloc] initWithType:FRStorePayMenuType_PayWay];
    
    [self createViews];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(wechatDidPayStatusChange:) name:DDUserWeChatPayNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(alipayDidPayStatusChange:) name:DDUserAlipayPayNotification object:nil];
}

- (void)wechatDidPayStatusChange:(NSNotification *)notification
{
    PayResp * resp = notification.object;
    
    if (resp.errCode == WXSuccess) {
        
        [self showDetailWithOrderID:self.orderID];
    }else{
        [MBProgressHUD showTextHUDWithText:@"支付失败"];
        [self showDetailWithOrderID:self.orderID];
    }
}

- (void)alipayDidPayStatusChange:(NSNotification *)notification
{
    NSDictionary * result = notification.object;
    
    NSString * status = [result objectForKey:@"resultStatus"];
    if ([status isEqualToString:@"9000"]) {
        [self showDetailWithOrderID:self.orderID];
    }else if ([status isEqualToString:@"8000"]) {
        UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"未知的错误" message:@"请联系服务商以确定是否支付成功" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction * action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
            [self showDetailWithOrderID:self.orderID];
            
        }];
        [alert addAction:action];
        [self presentViewController:alert animated:YES completion:nil];
    }else{
        [MBProgressHUD showTextHUDWithText:@"支付失败"];
        [self showDetailWithOrderID:self.orderID];
    }
}

- (void)buyButtonDidClicked
{
    if (self.chooseModel.type == 3) {
        UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"购买服务" message:@"确认购买该服务，并使用线下付款方式进行交易吗？" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction * action1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        
        UIAlertAction * action2 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            [self checkUploadImage];
            
        }];
        
        [alert addAction:action1];
        [alert addAction:action2];
        [self presentViewController:alert animated:YES completion:nil];
    }else{
        FRChoosePayWayView * payway = [[FRChoosePayWayView alloc] initServiceChooseWithModel:self.payWayModel.payWay];
        
        payway.chooseDidCompletetHandle = ^(FRPayWayModel *model) {
            self.payWayModel.payWay = model;
            [self checkUploadImage];
        };
        [payway show];
    }
}

- (void)showDetailWithOrderID:(NSInteger)orderID
{
    MBProgressHUD * hud = [MBProgressHUD showLoadingHUDWithText:@"正在加载" inView:self.view];
    FROrderRequest * request = [[FROrderRequest alloc] initServiceDetailWithID:orderID];
    [request sendRequestWithSuccess:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
        
        [hud hideAnimated:YES];
        NSDictionary * data = [response objectForKey:@"data"];
        FRMyServiceOrderModel * serviceModel = [FRMyServiceOrderModel mj_objectWithKeyValues:data];
        serviceModel.cid = orderID;
        FROrderDetailViewController * detail = [[FROrderDetailViewController alloc] initWithServiceModel:serviceModel];
        [self.navigationController popViewControllerAnimated:NO];
        
        UITabBarController * tab = (UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
        UINavigationController * na = tab.selectedViewController;
        [na pushViewController:detail animated:YES];
        
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

- (void)checkUploadImage
{
    if (self.imageSource.count > 0) {
        MBProgressHUD * hud = [MBProgressHUD showLoadingHUDWithText:@"正在上传图片" inView:self.view];
        NSMutableArray * imageList = [[NSMutableArray alloc] init];
        __block NSInteger count = 0;
        
        hud.label.text = [NSString stringWithFormat:@"正在上传图片%ld/%ld", count+1, self.imageSource.count];
        [[FRUploadManager shareManager] uploadImageArray:self.imageSource progress:^(int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend) {
            
        } success:^(NSString *path, NSInteger index) {
            [imageList addObject:path];
            count++;
            if (count == self.imageSource.count) {
                [hud hideAnimated:NO];
                [self addOrderWithImages:imageList];
            }else{
                hud.label.text = [NSString stringWithFormat:@"正在上传图片%ld/%ld", count+1, self.imageSource.count];
            }
            NSLog(@"%@", [NSString stringWithFormat:@"%ld张地址：%@", index, path]);
        } failure:^(NSError *error, NSInteger index) {
            count++;
            if (count == self.imageSource.count) {
                [hud hideAnimated:NO];
                [self addOrderWithImages:imageList];
            }else{
                hud.label.text = [NSString stringWithFormat:@"正在上传图片%ld/%ld", count+1, self.imageSource.count];
            }
            NSLog(@"%@\n%@", [NSString stringWithFormat:@"%ld张上传失败", index], error);
        }];
    }else{
        [self addOrderWithImages:[NSArray new]];
    }
}

- (void)addOrderWithImages:(NSArray *)images
{
    NSString * remark = self.textView.text;
    if (isEmptyString(remark)) {
        remark = @"";
    }
    
    MBProgressHUD * hud = [MBProgressHUD showLoadingHUDWithText:@"正在下单" inView:self.view];
    
    FRServiceRequest * request = [[FRServiceRequest alloc] initWithAddOrderWithID:self.model.cid payWay:self.chooseModel.type number:self.number remark:remark images:images paymethod:self.payWayModel.payWay.type];
    [request sendRequestWithSuccess:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
        
        [hud hideAnimated:YES];
        NSDictionary * dict = [response objectForKey:@"data"];
        NSInteger orderID = [[dict objectForKey:@"id"] integerValue];
        self.orderID = orderID;
        if (self.chooseModel.type == 3) {
            [MBProgressHUD showTextHUDWithText:@"下单成功，请联系服务商进行线下交易"];
            [self.navigationController popViewControllerAnimated:YES];
            [self showDetailWithOrderID:orderID];
        }else{
            [self payWithOrderID:orderID];
        }
        
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

- (void)payWithOrderID:(NSInteger)orderID
{
    if (self.payWayModel.payWay.type == FRPayWayType_Alipay) {
        MBProgressHUD * hud = [MBProgressHUD showLoadingHUDWithText:@"发起支付中" inView:self.view];
        FROrderPayRequest * request = [[FROrderPayRequest alloc] initWithServiceAlipayOrderID:orderID];
        if (self.chooseModel.type == 2) {
            [request configPayType:1];
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
    }else if (self.payWayModel.payWay.type == FRPayWayType_Wechat) {
        MBProgressHUD * hud = [MBProgressHUD showLoadingHUDWithText:@"发起支付中" inView:self.view];
        FROrderPayRequest * request = [[FROrderPayRequest alloc] initWithServiceWechatOrderID:orderID];
        if (self.chooseModel.type == 2) {
            [request configPayType:1];
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
    }
}

- (void)addButtonDidClicked
{
    self.number++;
    [self reloadGoods];
}

- (void)deleteButtonDidClicked
{
    if (self.number > 1) {
        self.number--;
        [self reloadGoods];
    }
}

- (void)reloadGoods
{
    NSString * numberStr = [NSString stringWithFormat:@"%ld", self.number];
    NSString * priceStr = [NSString stringWithFormat:@"￥%.2lf", self.model.amount*self.number];
    [self.numberButton setTitle:numberStr forState:UIControlStateNormal];
    self.priceLabel.text = priceStr;
}

- (void)createViews
{
    CGFloat scale = kMainBoundsWidth / 375.f;
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = UIColorFromRGB(0xffffff);
    self.tableView.rowHeight = 60 * scale;
    [self.tableView registerClass:[FRServicePayWayCell class] forCellReuseIdentifier:@"FRServicePayWayCell"];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    self.tableView.tableFooterView = [UIView new];
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 50, 0);
    
    UIView * bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainBoundsWidth, 45)];
    bottomView.backgroundColor = UIColorFromRGB(0xf5f5f5);
    [self.view addSubview:bottomView];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.mas_equalTo(0);
        make.height.mas_equalTo(45 * scale);
    }];
    
    UILabel * priceTipLabel = [FRCreateViewTool createLabelWithFrame:CGRectZero font:kPingFangRegular(15 * scale) textColor:UIColorFromRGB(0x333333) alignment:NSTextAlignmentLeft];
    priceTipLabel.text = @"合计：";
    [bottomView addSubview:priceTipLabel];
    [priceTipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.left.mas_equalTo(25 * scale);
        make.height.mas_equalTo(20 * scale);
    }];
    
    self.priceLabel = [FRCreateViewTool createLabelWithFrame:CGRectZero font:kPingFangRegular(15 * scale) textColor:UIColorFromRGB(0xE52424) alignment:NSTextAlignmentLeft];
    self.priceLabel.text = [NSString stringWithFormat:@"￥%.2lf", self.model.amount];
    [bottomView addSubview:self.priceLabel];
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(priceTipLabel);
        make.left.mas_equalTo(priceTipLabel.mas_right).offset(0 * scale);
        make.height.mas_equalTo(20 * scale);
    }];
    self.buyButton = [FRCreateViewTool createButtonWithFrame:CGRectZero font:kPingFangRegular(15 * scale) titleColor:UIColorFromRGB(0xffffff) title:@"结算"];
    self.buyButton.backgroundColor = UIColorFromRGB(0xF8BF44);
    [bottomView addSubview:self.buyButton];
    [self.buyButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.bottom.mas_equalTo(0);
        make.width.mas_equalTo(kMainBoundsWidth / 4.f);
    }];
    [self.buyButton addTarget:self action:@selector(buyButtonDidClicked) forControlEvents:UIControlEventTouchUpInside];
    
    [self createTableHeaderView];
}

- (void)createTableHeaderView
{
    CGFloat scale = kMainBoundsWidth / 375.f;
    
    self.contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainBoundsWidth, 350 * scale)];
    self.contentView.backgroundColor = UIColorFromRGB(0xffffff);
    [self.view addSubview:self.contentView];
    
    UIView * lineView = [[UIView alloc] initWithFrame:CGRectZero];
    lineView.backgroundColor = UIColorFromRGB(0xCCCCCC);
    [self.contentView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(85 * scale);
        make.left.mas_equalTo(10 * scale);
        make.width.mas_equalTo(kMainBoundsWidth - 20 * scale);
        make.height.mas_equalTo(.5f);
    }];
    
    UILabel * titleLabel = [FRCreateViewTool createLabelWithFrame:CGRectZero font:kPingFangMedium(15 * scale) textColor:UIColorFromRGB(0x333333) alignment:NSTextAlignmentLeft];
    titleLabel.text = self.model.title;
    [self.contentView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(25 * scale);
        make.left.mas_equalTo(15 * scale);
        make.height.mas_equalTo(20 * scale);
    }];
    
    UILabel * priceTipLabel = [FRCreateViewTool createLabelWithFrame:CGRectZero font:kPingFangRegular(15 * scale) textColor:UIColorFromRGB(0x333333) alignment:NSTextAlignmentLeft];
    priceTipLabel.text = @"服务单价";
    [self.contentView addSubview:priceTipLabel];
    [priceTipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(titleLabel.mas_bottom).offset(5 * scale);
        make.left.mas_equalTo(15 * scale);
        make.height.mas_equalTo(20 * scale);
    }];
    
    UILabel * priceLabel = [FRCreateViewTool createLabelWithFrame:CGRectZero font:kPingFangRegular(15 * scale) textColor:UIColorFromRGB(0xE52424) alignment:NSTextAlignmentLeft];
    priceLabel.text = [NSString stringWithFormat:@"￥%.2lf", self.model.amount];
    [self.contentView addSubview:priceLabel];
    [priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(titleLabel.mas_bottom).offset(5 * scale);
        make.left.mas_equalTo(priceTipLabel.mas_right).offset(10 * scale);
        make.height.mas_equalTo(20 * scale);
    }];
    
    self.numberButton = [FRCreateViewTool createButtonWithFrame:CGRectZero font:kPingFangRegular(15) titleColor:UIColorFromRGB(0x333333) title:@"1"];
    [self.contentView addSubview:self.numberButton];
    [self.numberButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(priceLabel);
        make.right.mas_equalTo(-50);
        make.height.mas_equalTo(20 * scale);
    }];
    
    self.deleteButton = [FRCreateViewTool createButtonWithFrame:CGRectZero font:kPingFangRegular(14 * scale) titleColor:[UIColor whiteColor] title:@""];
    [self.deleteButton setImage:[UIImage imageNamed:@"cartDelete"] forState:UIControlStateNormal];
    [self.contentView addSubview:self.deleteButton];
    [self.deleteButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.numberButton.mas_right);
        make.centerY.mas_equalTo(self.numberButton);
        make.width.height.mas_equalTo(20 * scale);
    }];
    [self.deleteButton addTarget:self action:@selector(deleteButtonDidClicked) forControlEvents:UIControlEventTouchUpInside];
    
    self.addButton = [FRCreateViewTool createButtonWithFrame:CGRectZero font:kPingFangRegular(14 * scale) titleColor:[UIColor whiteColor] title:@""];
    [self.addButton setImage:[UIImage imageNamed:@"cartAdd"] forState:UIControlStateNormal];
    [self.contentView addSubview:self.addButton];
    [self.addButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.numberButton.mas_left);
        make.centerY.mas_equalTo(self.numberButton);
        make.width.height.mas_equalTo(20 * scale);
    }];
    [self.addButton addTarget:self action:@selector(addButtonDidClicked) forControlEvents:UIControlEventTouchUpInside];
    
    self.textView = [[RDTextView alloc] initWithFrame:CGRectZero];
    self.textView.font = kPingFangRegular(10 * scale);
    self.textView.textColor = UIColorFromRGB(0x666666);
    self.textView.placeholder = @"请填写详细需求，以便为您提供更好的服务";
    self.textView.placeholderLabel.textColor = UIColorFromRGB(0x999999);
    self.textView.placeholderLabel.font = kPingFangRegular(10 * scale);
    self.textView.maxSize = 200;
    [self.contentView addSubview:self.textView];
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(lineView.mas_bottom).offset(10 * scale);
        make.left.mas_equalTo(10 * scale);
        make.width.mas_equalTo(kMainBoundsWidth - 20 * scale);
        make.height.mas_equalTo(100 * scale);
    }];
    
    CGFloat width = (kMainBoundsWidth - 20 * scale) / 4.f;
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(width, width);
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    
    self.imageCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    [self.imageCollectionView registerClass:[FRImageCollectionViewCell class] forCellWithReuseIdentifier:@"FRImageCollectionViewCell"];
    self.imageCollectionView.backgroundColor = UIColorFromRGB(0xffffff);
    self.imageCollectionView.delegate = self;
    self.imageCollectionView.dataSource = self;
    self.imageCollectionView.scrollEnabled = NO;
    [self.contentView addSubview:self.imageCollectionView];
    [self.imageCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.textView.mas_bottom);
        make.left.mas_equalTo(10 * scale);
        make.width.mas_equalTo(kMainBoundsWidth - 20 * scale);
        make.height.mas_equalTo(width + 10 * scale);
    }];
    
    UIView * bottomLineView = [[UIView alloc] initWithFrame:CGRectZero];
    bottomLineView.backgroundColor = UIColorFromRGB(0xf5f5f5);
    [self.contentView addSubview:bottomLineView];
    [bottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.imageCollectionView.mas_bottom).offset(5 * scale);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(10 * scale);
    }];
    
    UIView * tipLineView = [[UIView alloc] initWithFrame:CGRectZero];
    tipLineView.backgroundColor = KThemeColor;
    [self.contentView addSubview:tipLineView];
    [tipLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(bottomLineView.mas_bottom).offset(10 * scale);
        make.left.mas_equalTo(15 * scale);
        make.width.mas_equalTo(3 * scale);
        make.height.mas_equalTo(20 * scale);
    }];
    
    UILabel * tipLabel = [FRCreateViewTool createLabelWithFrame:CGRectZero font:kPingFangRegular(14 * scale) textColor:UIColorFromRGB(0x333333) alignment:NSTextAlignmentLeft];
    tipLabel.text = @"支付方式";
    [self.contentView addSubview:tipLabel];
    [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(tipLineView);
        make.height.mas_equalTo(20 * scale);
        make.left.mas_equalTo(tipLineView.mas_right).offset(10 * scale);
    }];
    
    self.tableView.tableHeaderView = self.contentView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FRServicePayWayCell * cell = [tableView dequeueReusableCellWithIdentifier:@"FRServicePayWayCell" forIndexPath:indexPath];
    
    FRServicePayWayModel * model = [self.dataSource objectAtIndex:indexPath.row];
    [cell configWithModel:model];
    
    if (self.chooseModel == model) {
        [cell configChoose:YES];
    }else{
        [cell configChoose:NO];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    FRServicePayWayModel * model = [self.dataSource objectAtIndex:indexPath.row];
    if (self.chooseModel != model) {
        self.chooseModel = model;
        [tableView reloadData];
    }
    
    if (self.chooseModel.type == FRServicePayWay_Half) {
        self.priceLabel.text = [NSString stringWithFormat:@"￥%.2lf", self.model.amount/2.f];
    }else{
        self.priceLabel.text = [NSString stringWithFormat:@"￥%.2lf", self.model.amount];
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.imageSource.count + 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    FRImageCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"FRImageCollectionViewCell" forIndexPath:indexPath];
    
    if (indexPath.row == self.imageSource.count) {
        
        [cell configLastCell];
        
    }else{
        UIImage * image = [self.imageSource objectAtIndex:indexPath.item];
        [cell configWithImage:image];
        
        __weak typeof(self) weakSelf = self;
        cell.imageDeleteHandle = ^{
            [weakSelf.imageSource removeObject:image];
            [weakSelf.imageCollectionView reloadData];
        };
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == self.imageSource.count) {
        
        if (self.imageSource.count == self.maxCount) {
            NSString * title = [NSString stringWithFormat:@"最多只能选择%ld张", self.maxCount];
            [MBProgressHUD showTextHUDWithText:title];
            return;
        }
        
        TZImagePickerController * picker = [[TZImagePickerController alloc] initWithMaxImagesCount:100 delegate:self];
        picker.allowPickingOriginalPhoto = NO;
        picker.allowPickingVideo = NO;
        picker.showSelectedIndex = YES;
        picker.allowCrop = NO;
        picker.maxImagesCount = self.maxCount - self.imageSource.count;
        
        [self presentViewController:picker animated:YES completion:nil];
        
    }else{
        
        UIImage * image = [self.imageSource objectAtIndex:indexPath.item];
        LookImageViewController * look = [[LookImageViewController alloc] initWithImage:image];
        [self presentViewController:look animated:YES completion:nil];
        
    }
}

#pragma mark - 选取照片
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto infos:(NSArray<NSDictionary *> *)infos
{
    [self.imageSource addObjectsFromArray:photos];
    
    [self.imageCollectionView reloadData];
}

- (NSMutableArray *)imageSource
{
    if (!_imageSource) {
        _imageSource = [NSMutableArray new];
    }
    return _imageSource;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
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

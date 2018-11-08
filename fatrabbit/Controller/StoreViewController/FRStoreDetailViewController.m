//
//  FRStoreDetailViewController.m
//  fatrabbit
//
//  Created by 郭春城 on 2018/9/4.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import "FRStoreDetailViewController.h"
#import "LookImageViewController.h"
#import <WebKit/WebKit.h>
#import <SDCycleScrollView.h>
#import "FRStoreDetailRequest.h"
#import "FRStoreModel.h"
#import "FRStorePriceView.h"
#import "LookImageViewController.h"
#import "FRChooseSpecView.h"
#import "UIButton+Badge.h"
#import "UserManager.h"
#import "FRStoreCartViewController.h"
#import "FRStoreCartModel.h"
#import "FRStoreCartRequest.h"
#import "MBProgressHUD+FRHUD.h"
#import "FRCollectRequest.h"
#import "FRLoginViewController.h"

@interface FRStoreDetailViewController () <WKNavigationDelegate, SDCycleScrollViewDelegate>

@property (nonatomic, strong) SDCycleScrollView * bannerView;

@property (nonatomic, strong) UITableView * tableView;

@property (nonatomic, strong) UIView * headerView;
@property (nonatomic, strong) UIView * headerContentView;
@property (nonatomic, strong) FRStorePriceView * priceView;
@property (nonatomic, strong) WKWebView * webView;
@property (nonatomic, assign) BOOL hasFinishedLoad;

@property (nonatomic, strong) UILabel * specLabel;

@property (nonatomic, strong) FRStoreModel * model;
@property (nonatomic, strong) FRStoreSpecModel * specModel;

@property (nonatomic, strong) UIButton * storeCartButton;

@property (nonatomic, strong) UIButton * collectButton;

@end

@implementation FRStoreDetailViewController

- (instancetype)initWithModel:(FRStoreModel *)model
{
    if (self = [super init]) {
        self.model = model;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"商品详情";
    
    [self requestStoreDetails];
}

- (void)requestStoreDetails
{
    FRStoreDetailRequest * request = [[FRStoreDetailRequest alloc] initWithID:self.model.pid];
    [request sendRequestWithSuccess:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
        
        if (KIsDictionary(response)) {
            NSDictionary * data = [response objectForKey:@"data"];
            if (KIsDictionary(data)) {
                [self.model mj_setKeyValues:data];
                if (self.model.spec.count > 0) {
                    self.specModel = [self.model.spec firstObject];
                }
            }
        }
        
        [self createViews];
        
        [self createTableHeaderView];
        
    } businessFailure:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
        
        NSString * msg = [response objectForKey:@"msg"];
        if (!isEmptyString(msg)) {
            [MBProgressHUD showTextHUDWithText:msg];
        }
        
    } networkFailure:^(BGNetworkRequest * _Nonnull request, NSError * _Nullable error) {
        
        [MBProgressHUD showTextHUDWithText:@"网络失去连接"];
        
    }];
}

/**
 选择规格
 */
- (void)stockButtonDidClicked
{
    FRChooseSpecView * choose = [[FRChooseSpecView alloc] initWithSpecList:self.model.spec chooseModel:self.specModel];
    
    __weak typeof(self) weakSelf = self;
    choose.chooseDidCompletetHandle = ^(FRStoreSpecModel *model) {
        weakSelf.specModel = model;
        [weakSelf refreshSpec];
    };
    
    [choose show];
}

/**
 添加至购物车
 */
- (void)addStoreCartButtonDidClicked
{
    if (![UserManager shareManager].isLogin) {
        FRLoginViewController * login = [[FRLoginViewController alloc] init];
        [self.navigationController pushViewController:login animated:YES];
        return;
    }
    [[UserManager shareManager] addStoreCartWithStore:self.specModel];
}

/**
 立即购买
 */
- (void)buyButtonDidClicked
{
    if (![UserManager shareManager].isLogin) {
        FRLoginViewController * login = [[FRLoginViewController alloc] init];
        [self.navigationController pushViewController:login animated:YES];
        return;
    }
    
    MBProgressHUD * hud = [MBProgressHUD showLoadingHUDWithText:@"正在添加商品" inView:self.view];
    FRStoreCartRequest * request = [[FRStoreCartRequest alloc] initAddWithStoreID:self.specModel.cid];
    [request sendRequestWithSuccess:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
        
        [self storeCartUpdate];
        
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

- (void)storeCartUpdate
{
    FRStoreCartRequest * updateRequest = [[FRStoreCartRequest alloc] initWithStoreList];
    [updateRequest sendRequestWithSuccess:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
        
        if (KIsDictionary(response)) {
            NSDictionary * data = [response objectForKey:@"data"];
            if (KIsDictionary(data)) {
                NSArray * list = [data objectForKey:@"list"];
                [UserManager shareManager].storeCart = [FRStoreCartModel mj_objectArrayWithKeyValuesArray:list];
                [[NSNotificationCenter defaultCenter] postNotificationName:FRUserStoreCartStatusDidChange object:nil];
            }
        }
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self storeCartButtonDidClicked];
        
    } businessFailure:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSString * msg = [response objectForKey:@"msg"];
        if (!isEmptyString(msg)) {
            [MBProgressHUD showTextHUDWithText:msg];
        }
        
    } networkFailure:^(BGNetworkRequest * _Nonnull request, NSError * _Nullable error) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [MBProgressHUD showTextHUDWithText:@"网络失去连接"];
        
    }];
}

- (void)storeCartButtonDidClicked
{
    if (![UserManager shareManager].isLogin) {
        FRLoginViewController * login = [[FRLoginViewController alloc] init];
        [self.navigationController pushViewController:login animated:YES];
        return;
    }
    
    FRStoreCartViewController * cart = [[FRStoreCartViewController alloc] init];
    [self.navigationController pushViewController:cart animated:YES];
}

- (void)userStoreCartShouldUpdate
{
    NSInteger count = [UserManager shareManager].storeCart.count;
    
    NSString * badge = [NSString stringWithFormat:@"%ld", count];
    if (count > 99) {
        badge = @"99+";
    }
    [self.storeCartButton setBadgeOriginX:30];
    [self.storeCartButton setBadgeValue:badge];
}

- (void)refreshSpec
{
    [self resetHeaderHeight];
    self.specLabel.text = self.specModel.name;
    [self.priceView configWithSpecModel:self.specModel];
}

- (void)resetHeaderHeight
{
    [self.webView evaluateJavaScript:@"document.body.scrollHeight" completionHandler:^(id _Nullable result, NSError * _Nullable error) {
        
        if (nil == error) {
            CGFloat scale = kMainBoundsWidth / 375.f;
            CGFloat webHeight = [result floatValue];
            
            CGFloat titleHeight = [self.model.name boundingRectWithSize:CGSizeMake(kMainBoundsWidth - 80 * scale, 1000) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:kPingFangRegular(15 * scale)} context:nil].size.height;
            
            self.headerView.frame = CGRectMake(0, 0, kMainBoundsWidth, 490 * scale + webHeight + titleHeight);
            if (!isEmptyString(self.model.subtitle)) {
                CGFloat height = [self.model.subtitle boundingRectWithSize:CGSizeMake(kMainBoundsWidth - 30 * scale, 50 * scale) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:kPingFangRegular(10 * scale)} context:nil].size.height;
                if (self.specModel.price_range && self.specModel.price_range.count > 0) {
                    self.headerView.frame = CGRectMake(0, 0, kMainBoundsWidth, 490 * scale + 50 * scale + height + webHeight + titleHeight);
                    [self.headerContentView mas_updateConstraints:^(MASConstraintMaker *make) {
                        make.height.mas_equalTo(420 * scale + 50 * scale + height + titleHeight);
                    }];
                    [self.priceView mas_updateConstraints:^(MASConstraintMaker *make) {
                        make.height.mas_equalTo(140 * scale + 50 * scale + height + titleHeight);
                    }];
                }else{
                    self.headerView.frame = CGRectMake(0, 0, kMainBoundsWidth, 490 * scale + height + webHeight + titleHeight);
                    [self.headerContentView mas_updateConstraints:^(MASConstraintMaker *make) {
                        make.height.mas_equalTo(420 * scale + height + titleHeight);
                    }];
                    [self.priceView mas_updateConstraints:^(MASConstraintMaker *make) {
                        make.height.mas_equalTo(140 * scale + height + titleHeight);
                    }];
                }
            }else{
                if (self.specModel.price_range && self.specModel.price_range.count > 0) {
                    self.headerView.frame = CGRectMake(0, 0, kMainBoundsWidth, 490 * scale + 50 * scale + webHeight + titleHeight);
                    [self.headerContentView mas_updateConstraints:^(MASConstraintMaker *make) {
                        make.height.mas_equalTo(420 * scale + 50 * scale + titleHeight);
                    }];
                    [self.priceView mas_updateConstraints:^(MASConstraintMaker *make) {
                        make.height.mas_equalTo(140 * scale + 50 * scale + titleHeight);
                    }];
                }else{
                    self.headerView.frame = CGRectMake(0, 0, kMainBoundsWidth, 490 * scale + webHeight + titleHeight);
                    [self.headerContentView mas_updateConstraints:^(MASConstraintMaker *make) {
                        make.height.mas_equalTo(420 * scale + titleHeight);
                    }];
                    [self.priceView mas_updateConstraints:^(MASConstraintMaker *make) {
                        make.height.mas_equalTo(140 * scale + titleHeight);
                    }];
                }
            }
            [self.webView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(webHeight);
            }];
            [self.tableView reloadData];
        }
    }];
}

//收藏
- (void)collectButtonDidClicked
{
    [FRCollectRequest cancelRequest];
    if (self.model.collect_id == 0) {
        FRCollectRequest * request = [[FRCollectRequest alloc] initWithAddStoreID:self.model.pid];
        [request sendRequestWithSuccess:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
            
            if (KIsDictionary(response)) {
                NSDictionary * data = [response objectForKey:@"data"];
                if (KIsDictionary(data)) {
                    self.model.collect_id = [[data objectForKey:@"collect_id"] integerValue];
                }
            }
            [self reloadCollectStatus];
            [MBProgressHUD showTextHUDWithText:@"收藏成功"];
        } businessFailure:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
            [MBProgressHUD showTextHUDWithText:@"操作失败"];
        } networkFailure:^(BGNetworkRequest * _Nonnull request, NSError * _Nullable error) {
            
        }];
    }else{
        FRCollectRequest * request = [[FRCollectRequest alloc] initWithRemoveID:self.model.collect_id];
        [request sendRequestWithSuccess:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
            
            self.model.collect_id = 0;
            [self reloadCollectStatus];
            [MBProgressHUD showTextHUDWithText:@"取消收藏"];
        } businessFailure:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
            [MBProgressHUD showTextHUDWithText:@"操作失败"];
        } networkFailure:^(BGNetworkRequest * _Nonnull request, NSError * _Nullable error) {
            
        }];
    }
}

- (void)reloadCollectStatus
{
    if (self.model.collect_id != 0) {
        [self.collectButton setImage:[UIImage imageNamed:@"xinxinyes"] forState:UIControlStateNormal];
    }else{
        [self.collectButton setImage:[UIImage imageNamed:@"xinxinno"] forState:UIControlStateNormal];
    }
}

#pragma mark - WKNavigationDelegate
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
    //获取网页正文全文高，刷新tableView，以展示最新头视图
    [self resetHeaderHeight];
    self.hasFinishedLoad = YES;
    [self addImageClickedHandler];
}

// 类似 UIWebView 的 -webView: shouldStartLoadWithRequest: navigationType:
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    
    //将url转换为string
    NSString *requestString = [[navigationAction.request URL] absoluteString];
    
    if ([requestString hasPrefix:@"myweb:imageClick:"])
    {
        NSString *imageUrl = [requestString substringFromIndex:@"myweb:imageClick:".length];
        if (![imageUrl hasSuffix:@".jpg"]) {
            
        }
        
        NSLog(@"image url------%@", imageUrl);
        
        LookImageViewController * look = [[LookImageViewController alloc] initWithImageURL:imageUrl];
        [self presentViewController:look animated:YES completion:nil];
    }
    
    decisionHandler(WKNavigationActionPolicyAllow);
}

- (void)addImageClickedHandler
{
    NSString * imageHandlerString = @"function getImages(){\
    var objs = document.getElementsByTagName(\"img\");\
    var imgUrlStr='';\
    for(var i=0;i<objs.length;i++){\
    objs[i].onclick=function(){\
    document.location=\"myweb:imageClick:\"+this.src;\
    };\
    };\
    return imgUrlStr;\
    };";
    
    [self.webView evaluateJavaScript:imageHandlerString completionHandler:nil];
    
    NSString *js2=@"getImages()";
    [self.webView evaluateJavaScript:js2 completionHandler:^(id Result, NSError * error) {
        
    }];
}

- (void)createViews
{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.backgroundColor = self.view.backgroundColor;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    self.tableView.tableFooterView = [UIView new];
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 50, 0);
    
    UIView * bottomHandleView = [[UIView alloc] initWithFrame:CGRectZero];
    bottomHandleView.backgroundColor = UIColorFromRGB(0xffffff);
    [self.view addSubview:bottomHandleView];
    [bottomHandleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.mas_equalTo(0);
        make.height.mas_equalTo(50);
    }];
    
    UIButton * buyButton = [FRCreateViewTool createButtonWithFrame:CGRectZero font:kPingFangRegular(15) titleColor:UIColorFromRGB(0xffffff) title:@"立即购买"];
    [buyButton setBackgroundColor:KPriceColor];
    [bottomHandleView addSubview:buyButton];
    [buyButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.width.mas_equalTo(kMainBoundsWidth / 8.f * 3);
    }];
    [buyButton addTarget:self action:@selector(buyButtonDidClicked) forControlEvents:UIControlEventTouchUpInside];

    UIButton * addStoreCartButton = [FRCreateViewTool createButtonWithFrame:CGRectZero font:kPingFangRegular(15) titleColor:UIColorFromRGB(0xffffff) title:@"加入购物车"];
    [addStoreCartButton setBackgroundColor:UIColorFromRGB(0xf8bf44)];
    [bottomHandleView addSubview:addStoreCartButton];
    [addStoreCartButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(0);
        make.right.mas_equalTo(buyButton.mas_left);
        make.width.mas_equalTo(kMainBoundsWidth / 8.f * 3);
    }];
    [addStoreCartButton addTarget:self action:@selector(addStoreCartButtonDidClicked) forControlEvents:UIControlEventTouchUpInside];
    
    UIView * storeCartView = [[UIView alloc] initWithFrame:CGRectZero];
    [bottomHandleView addSubview:storeCartView];
    [storeCartView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.mas_equalTo(0);
        make.width.mas_equalTo(kMainBoundsWidth / 4.f);
    }];
    
    self.storeCartButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [storeCartView addSubview:self.storeCartButton];
    [self.storeCartButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(0);
        make.height.mas_equalTo(40);
        make.width.mas_equalTo(50);
    }];
    [self.storeCartButton addTarget:self action:@selector(storeCartButtonDidClicked) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView * imageView = [FRCreateViewTool createImageViewWithFrame:CGRectZero contentModel:UIViewContentModeScaleAspectFit image:[UIImage imageNamed:@"storeCart"]];
    [self.storeCartButton addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(0);
        make.width.height.mas_equalTo(25);
    }];
    
    [self.storeCartButton setBadgeBGColor:KPriceColor];
    [self.storeCartButton setBadgeTextColor:UIColorFromRGB(0xffffff)];
    [self.storeCartButton setShouldHideBadgeAtZero:YES];
    
    [self userStoreCartShouldUpdate];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userStoreCartShouldUpdate) name:FRUserStoreCartStatusDidChange object:nil];
}

- (void)createTableHeaderView
{
    CGFloat scale = kMainBoundsWidth / 375.f;
    
    self.headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainBoundsWidth, 425 * scale)];
    self.headerView.backgroundColor = [UIColor whiteColor];
    self.headerContentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainBoundsWidth, 420 * scale)];
    self.headerContentView.backgroundColor = UIColorFromRGB(0xffffff);
    [self.headerView addSubview:self.headerContentView];
    [self.headerContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.height.mas_equalTo(420 * scale);
    }];
    
    UIView * contentLineView = [[UIView alloc] initWithFrame:CGRectZero];
    contentLineView.backgroundColor = UIColorFromRGB(0xf5f5f5);
    [self.headerContentView addSubview:contentLineView];
    [contentLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.mas_equalTo(0);
        make.height.mas_equalTo(10 * scale);
    }];
    
    self.bannerView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, kMainBoundsWidth, 225 * scale) imageURLStringsGroup:self.model.photo];
    self.bannerView.bannerImageViewContentMode = UIViewContentModeScaleAspectFill;
    self.bannerView.placeholderImage = [UIImage imageNamed:@"defaultTopBanner"];
    self.bannerView.autoScrollTimeInterval = 3.f;
    self.bannerView.delegate = self;
    [self.headerContentView addSubview:self.bannerView];
    [self.bannerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.height.mas_equalTo(225 * scale);
    }];
    
    self.priceView = [[FRStorePriceView alloc] initWithModel:self.model];
    [self.priceView configWithSpecModel:self.specModel];
    [self.headerContentView addSubview:self.priceView];
    [self.priceView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.bannerView.mas_bottom);
        make.height.mas_equalTo(140 * scale);
        make.left.right.mas_equalTo(0);
    }];
    
    CGFloat titleHeight = [self.model.name boundingRectWithSize:CGSizeMake(kMainBoundsWidth - 80 * scale, 1000) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:kPingFangRegular(15 * scale)} context:nil].size.height;
    
    if (!isEmptyString(self.model.subtitle)) {
        CGFloat height = [self.model.subtitle boundingRectWithSize:CGSizeMake(kMainBoundsWidth - 30 * scale, 50*scale) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:kPingFangRegular(10 * scale)} context:nil].size.height;
        self.headerView.frame = CGRectMake(0, 0, kMainBoundsWidth, 490 * scale + height + titleHeight);
        if (self.specModel.price_range && self.specModel.price_range.count > 0) {
            [self.headerContentView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(420 * scale + height + 50 * scale + titleHeight);
            }];
            [self.priceView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(140 * scale + height + 50 * scale + titleHeight);
            }];
        }else{
            [self.headerContentView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(420 * scale + height + titleHeight);
            }];
            [self.priceView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(140 * scale + height + titleHeight);
            }];
        }
    }else{
        if (self.specModel.price_range && self.specModel.price_range.count > 0) {
            [self.headerContentView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(420 * scale + 50 * scale + titleHeight);
            }];
            [self.priceView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(140 * scale + 50 * scale + titleHeight);
            }];
        }else{
            [self.headerContentView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(420 * scale + titleHeight);
            }];
            [self.priceView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(140 * scale + titleHeight);
            }];
        }
    }
    
    self.collectButton = [FRCreateViewTool createButtonWithFrame:CGRectZero font:kPingFangRegular(10) titleColor:UIColorFromRGB(0xffffff) title:@""];
    [self.headerContentView addSubview:self.collectButton];
    [self.collectButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.bannerView.mas_bottom).offset(15 * scale);
        make.right.mas_equalTo(-25 * scale);
        make.width.height.mas_equalTo(20 * scale);
    }];
    [self reloadCollectStatus];
    [self.collectButton addTarget:self action:@selector(collectButtonDidClicked) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton * stockButton = [FRCreateViewTool createButtonWithFrame:CGRectZero font:kPingFangRegular(12 * scale) titleColor:UIColorFromRGB(0x333333) title:@""];
    [self.headerContentView addSubview:stockButton];
    [stockButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.priceView.mas_bottom);
        make.left.bottom.right.mas_equalTo(0);
    }];
    [stockButton addTarget:self action:@selector(stockButtonDidClicked) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel * specTipLabel = [FRCreateViewTool createLabelWithFrame:CGRectZero font:kPingFangRegular(10 * scale) textColor:UIColorFromRGB(0x999999) alignment:NSTextAlignmentLeft];
    specTipLabel.text = @"已选择";
    [stockButton addSubview:specTipLabel];
    [specTipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(15 * scale);
        make.bottom.mas_equalTo(contentLineView.mas_top);
    }];
    
    self.specLabel = [FRCreateViewTool createLabelWithFrame:CGRectZero font:kPingFangRegular(12 * scale) textColor:UIColorFromRGB(0x333333) alignment:NSTextAlignmentRight];
    self.specLabel.text = self.specModel.name;
    [stockButton addSubview:self.specLabel];
    [self.specLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.right.mas_equalTo(-50 * scale);
        make.bottom.mas_equalTo(contentLineView.mas_top);
    }];
    
    UIImageView * moreImageView = [FRCreateViewTool createImageViewWithFrame:CGRectZero contentModel:UIViewContentModeScaleAspectFill image:[UIImage imageNamed:@"more"]];
    [stockButton addSubview:moreImageView];
    [moreImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.specLabel);
        make.right.mas_equalTo(-15);
        make.width.mas_equalTo(7);
        make.height.mas_equalTo(13);
    }];
    
    WKWebViewConfiguration * configuration = [[WKWebViewConfiguration alloc] init];
    self.webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, kMainBoundsWidth, 0) configuration:configuration];
    self.webView.navigationDelegate = self;
    self.webView.scrollView.scrollEnabled = NO;
    [self.headerView addSubview:self.webView];
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.headerContentView.mas_bottom);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(0);
    }];
    
    NSString * storeURL = [NSString stringWithFormat:@"%@/product/detail/%ld", HOSTURL, self.model.pid];
    NSURLRequest * request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:storeURL]];
    [self.webView loadRequest:request];
    
//    [self.webView.scrollView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
    
    self.tableView.tableHeaderView = self.headerView;
}

#pragma mark - SDCycleScrollViewDelegate
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    NSString * imageURL = [self.model.photo objectAtIndex:index];
    LookImageViewController * look = [[LookImageViewController alloc] initWithImageURL:imageURL];
    [self presentViewController:look animated:NO completion:nil];
}

//- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
//{
//    if ([keyPath isEqualToString:@"contentSize"]) {
//
//        CGFloat scale = kMainBoundsWidth / 375.f;
//        CGFloat webHeight = self.webView.scrollView.contentSize.height;
//        self.headerView.frame = CGRectMake(0, 0, kMainBoundsWidth, 405 * scale + webHeight);
//        [self.webView mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.height.mas_equalTo(webHeight);
//        }];
//        [self.tableView reloadData];
//
//        NSLog(@"%lf", self.webView.scrollView.contentSize.height);
//    }
//}

//- (void)dealloc
//{
//    [self.webView.scrollView removeObserver:self forKeyPath:@"contentSize"];
//}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:FRUserStoreCartStatusDidChange object:nil];
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

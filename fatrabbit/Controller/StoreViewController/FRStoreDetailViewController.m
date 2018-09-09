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

@interface FRStoreDetailViewController () <WKNavigationDelegate, SDCycleScrollViewDelegate>

@property (nonatomic, strong) SDCycleScrollView * bannerView;

@property (nonatomic, strong) UITableView * tableView;

@property (nonatomic, strong) UIView * headerView;
@property (nonatomic, strong) UIView * headerContentView;
@property (nonatomic, strong) FRStorePriceView * priceView;
@property (nonatomic, strong) WKWebView * webView;

@property (nonatomic, strong) UIButton * collectButton;
@property (nonatomic, strong) UILabel * specLabel;

@property (nonatomic, strong) FRStoreModel * model;
@property (nonatomic, strong) FRStoreSpecModel * specModel;

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
    FRStoreDetailRequest * request = [[FRStoreDetailRequest alloc] initWithID:self.model.cid];
    [request sendRequestWithSuccess:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
        
        if (KIsDictionary(response)) {
            NSDictionary * data = [response objectForKey:@"data"];
            if (KIsDictionary(data)) {
                [self.model mj_setKeyValues:data];
            }
        }
        
        [self createViews];
        
        [self createTableHeaderView];
        
    } businessFailure:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
        
    } networkFailure:^(BGNetworkRequest * _Nonnull request, NSError * _Nullable error) {
        
    }];
}

#pragma mark - WKNavigationDelegate
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
    //获取网页正文全文高，刷新tableView，以展示最新头视图
    [webView evaluateJavaScript:@"document.body.scrollHeight" completionHandler:^(id _Nullable result, NSError * _Nullable error) {

        if (nil == error) {
            CGFloat scale = kMainBoundsWidth / 375.f;
            CGFloat webHeight = [result floatValue];
            self.headerView.frame = CGRectMake(0, 0, kMainBoundsWidth, 405 * scale + webHeight);
            [self.webView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(webHeight);
            }];
            [self.tableView reloadData];
        }

    }];
    
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
    if(this.alt==''){\
    document.location=\"myweb:imageClick:\"+this.src;\
    }\
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
}

- (void)createTableHeaderView
{
    CGFloat scale = kMainBoundsWidth / 375.f;
    
    if (self.model.spec.count > 0) {
        self.specModel = [self.model.spec firstObject];
        for (FRStoreSpecModel * model in self.model.spec) {
            if (model.isdefault == 1) {
                self.specModel = model;
                break;
            }
        }
    }
    
    self.headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainBoundsWidth, 405 * scale)];
    self.headerView.backgroundColor = [UIColor whiteColor];
    
    self.headerContentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainBoundsWidth, 405 * scale)];
    self.headerContentView.backgroundColor = UIColorFromRGB(0xffffff);
    [self.headerView addSubview:self.headerContentView];
    [self.headerContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.height.mas_equalTo(405 * scale);
    }];
    
    UIView * contentLineView = [[UIView alloc] initWithFrame:CGRectZero];
    contentLineView.backgroundColor = UIColorFromRGB(0xf5f5f5);
    [self.headerContentView addSubview:contentLineView];
    [contentLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.mas_equalTo(0);
        make.height.mas_equalTo(10 * scale);
    }];
    
    self.bannerView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, kMainBoundsWidth, 200 * scale) imageURLStringsGroup:self.model.photo];
    self.bannerView.bannerImageViewContentMode = UIViewContentModeScaleAspectFill;
    self.bannerView.autoScrollTimeInterval = 3.f;
    self.bannerView.delegate = self;
    [self.headerContentView addSubview:self.bannerView];
    [self.bannerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.height.mas_equalTo(200 * scale);
    }];
    
    self.priceView = [[FRStorePriceView alloc] initWithModel:self.model];
    [self.priceView configWithSpecModel:self.specModel];
    [self.headerContentView addSubview:self.priceView];
    [self.priceView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.bannerView.mas_bottom);
        make.height.mas_equalTo(150 * scale);
        make.left.right.mas_equalTo(0);
    }];
    
    UIButton * stockButton = [FRCreateViewTool createButtonWithFrame:CGRectZero font:kPingFangRegular(12 * scale) titleColor:UIColorFromRGB(0x333333) title:@""];
    [self.headerContentView addSubview:stockButton];
    [stockButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.priceView.mas_bottom);
        make.left.bottom.right.mas_equalTo(0);
    }];
    
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
    
    NSString * storeURL = [NSString stringWithFormat:@"%@/product/detai/%ld", HOSTURL, self.model.cid];
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

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

@interface FRStoreDetailViewController () <WKNavigationDelegate>

@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) UIView * headerView;
@property (nonatomic, strong) UIView * headerContentView;
@property (nonatomic, strong) WKWebView * webView;

@end

@implementation FRStoreDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"商品详情";
    [self createViews];
    
    [self createTableHeaderView];
}

#pragma mark - WKNavigationDelegate
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
    //获取网页正文全文高，刷新tableView，以展示最新头视图
    [webView evaluateJavaScript:@"document.body.scrollHeight" completionHandler:^(id _Nullable result, NSError * _Nullable error) {

        if (nil == error) {
            CGFloat scale = kMainBoundsWidth / 375.f;
            CGFloat webHeight = [result floatValue];
            self.headerView.frame = CGRectMake(0, 0, kMainBoundsWidth, 370 * scale + webHeight);
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
}

- (void)createTableHeaderView
{
    CGFloat scale = kMainBoundsWidth / 375.f;
    
    self.headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainBoundsWidth, 370 * scale)];
    self.headerView.backgroundColor = [UIColor whiteColor];
    
    self.headerContentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainBoundsWidth, 370 * scale)];
    self.headerContentView.backgroundColor = [UIColor greenColor];
    [self.headerView addSubview:self.headerContentView];
    [self.headerContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.height.mas_equalTo(370 * scale);
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
    
    NSURLRequest * request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://test.deedao.com/Agreement.html"]];
    [self.webView loadRequest:request];
    
//    [self.webView.scrollView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
    
    self.tableView.tableHeaderView = self.headerView;
}

//- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
//{
//    if ([keyPath isEqualToString:@"contentSize"]) {
//
//        CGFloat scale = kMainBoundsWidth / 375.f;
//        CGFloat webHeight = self.webView.scrollView.contentSize.height;
//        self.headerView.frame = CGRectMake(0, 0, kMainBoundsWidth, 370 * scale + webHeight);
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

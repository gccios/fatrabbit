//
//  FRMyServiceViewController.m
//  fatrabbit
//
//  Created by 郭春城 on 2018/9/12.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import "FRMyServiceViewController.h"
#import "FRMyServiceTableViewCell.h"
#import "FRCateListViewController.h"
#import "FRPublishServiceViewController.h"
#import "FRServiceRequest.h"
#import "MBProgressHUD+FRHUD.h"

@interface FRMyServiceViewController () <UITableViewDelegate, UITableViewDataSource, FRCateListViewControllerDelegate>

@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) NSMutableArray * dataSource;

@end

@implementation FRMyServiceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self requestMyService];
}

- (void)requestMyService
{
    FRServiceRequest * request = [[FRServiceRequest alloc] initWithMySerivice];
    [request sendRequestWithSuccess:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
        
        if (KIsDictionary(response)) {
            NSArray * data = [response objectForKey:@"data"];
            if (KIsArray(data)) {
                self.dataSource = [FRMySeriviceModel mj_objectArrayWithKeyValuesArray:data];
                [self createViews];
            }
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

- (void)publishButtonDidClicked
{
    FRCateListViewController * vc = [[FRCateListViewController alloc] initWithType:FRCateListType_Publish];
    vc.delegate = self;
    [self presentViewController:vc animated:YES completion:nil];
}

#pragma mark - FRCateListViewControllerDelegate
- (void)FRcateListViewCongtrollerDidChoose:(FRCateModel *)model type:(FRCateListType)type
{
    FRPublishServiceViewController * need = [[FRPublishServiceViewController alloc] initWithFRCateModel:model];
    [self.navigationController pushViewController:need animated:YES];
}

- (void)createViews
{
    CGFloat scale = kMainBoundsWidth / 375.f;
    
    self.navigationItem.title = @"我的服务";
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    //    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = UIColorFromRGB(0xf5f5f5);
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[FRMyServiceTableViewCell class] forCellReuseIdentifier:@"FRMyServiceTableViewCell"];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    self.tableView.contentInset = UIEdgeInsetsMake(10 * scale, 0, 60 * scale, 0);
    self.tableView.tableFooterView = [UIView new];
    
    UIButton * pulishButton = [FRCreateViewTool createButtonWithFrame:CGRectZero font:kPingFangRegular(15 * scale) titleColor:UIColorFromRGB(0xffffff) title:@"发布新服务"];
    pulishButton.backgroundColor = KPriceColor;
    [self.view addSubview:pulishButton];
    [pulishButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.height.mas_equalTo(40 * scale);
    }];
    [pulishButton addTarget:self action:@selector(publishButtonDidClicked) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - UITableViewDelegate && UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FRMyServiceTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"FRMyServiceTableViewCell" forIndexPath:indexPath];
    
    FRMySeriviceModel * model = [self.dataSource objectAtIndex:indexPath.row];
    [cell configWithModel:model];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 140 * kMainBoundsWidth / 375.f;
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

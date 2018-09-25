//
//  FRStoreListViewController.m
//  fatrabbit
//
//  Created by 郭春城 on 2018/8/30.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import "FRStoreListViewController.h"
#import "FRStoreTableViewCell.h"
#import "FRStoreSearchRequest.h"
#import "FRChooseSpecView.h"
#import "MBProgressHUD+FRHUD.h"
#import "FRStoreDetailRequest.h"
#import "FRStoreDetailViewController.h"
#import "UserManager.h"

@interface FRStoreListViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView * tableView;

@property (nonatomic, strong) NSMutableArray * dataSource;

@property (nonatomic, assign) FRStoreSearchType type;
@property (nonatomic, strong) FRCateModel * model;
@property (nonatomic, copy) NSString * keyWord;

@end

@implementation FRStoreListViewController

- (instancetype)initWithType:(FRStoreSearchType)type
{
    if (self = [super init]) {
        self.type = type;
    }
    return self;
}

- (void)configWithModel:(FRCateModel *)model
{
    self.model = model;
}

- (void)searchWithKeyWord:(NSString *)keyWord
{
    self.keyWord = keyWord;
    [self search];
}

- (void)search
{
    FRStoreSearchRequest * request = [[FRStoreSearchRequest alloc] init];
    if (self.model) {
        [request configWithCateID:self.model.cid];
    }
    if (!isEmptyString(self.keyWord)) {
        [request configWithKeyWord:self.keyWord];
    }
    [self.dataSource removeAllObjects];
    [self.tableView reloadData];
    [request sendRequestWithSuccess:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
        
        if (KIsDictionary(response)) {
            NSArray * data = [response objectForKey:@"data"];
            if (KIsArray(data)) {
                [self.dataSource addObjectsFromArray:[FRStoreModel mj_objectArrayWithKeyValuesArray:data]];
            }
        }
        [self.tableView reloadData];
        
    } businessFailure:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
        
    } networkFailure:^(BGNetworkRequest * _Nonnull request, NSError * _Nullable error) {
        
    }];
}

- (void)showChooseSpecWith:(FRStoreModel *)model
{
    if (model.spec) {
        FRChooseSpecView * spec = [[FRChooseSpecView alloc] initWithSpecList:model.spec chooseModel:model.spec.firstObject];
        spec.chooseDidCompletetHandle = ^(FRStoreSpecModel *model) {
            [[UserManager shareManager] addStoreCartWithStore:model];
        };
        [spec show];
    }else{
        MBProgressHUD * hud = [MBProgressHUD showLoadingHUDWithText:@"正在获取商品详情" inView:self.view];
        FRStoreDetailRequest * request = [[FRStoreDetailRequest alloc] initWithID:model.pid];
        [request sendRequestWithSuccess:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
            
            [hud hideAnimated:YES];
            if (KIsDictionary(response)) {
                NSDictionary * data = [response objectForKey:@"data"];
                if (KIsDictionary(data)) {
                    [model mj_setKeyValues:data];
                    [self showChooseSpecWith:model];
                }
            }
            
        } businessFailure:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
            [hud hideAnimated:YES];
            [MBProgressHUD showTextHUDWithText:@"获取商品失败"];
        } networkFailure:^(BGNetworkRequest * _Nonnull request, NSError * _Nullable error) {
            [hud hideAnimated:YES];
            [MBProgressHUD showTextHUDWithText:@"网络失去连接"];
        }];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self createViews];
}

- (void)createViews
{
    CGFloat scale = kMainBoundsWidth / 375.f;
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
//    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = UIColorFromRGB(0xf5f5f5);
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[FRStoreTableViewCell class] forCellReuseIdentifier:@"FRStoreTableViewCell"];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    self.tableView.tableFooterView = [UIView new];
    self.tableView.contentInset = UIEdgeInsetsMake(10 * scale, 0, 10 * scale, 0);
}

#pragma mark - UITableViewDelegate && UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FRStoreTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"FRStoreTableViewCell" forIndexPath:indexPath];
    
    FRStoreModel * model = [self.dataSource objectAtIndex:indexPath.row];
    [cell configWithModel:model];
    
    __weak typeof(self) weakSelf = self;
    cell.storeCartHandle = ^{
        [weakSelf showChooseSpecWith:model];
    };
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 110 * kMainBoundsWidth / 375.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    FRStoreModel * model = [self.dataSource objectAtIndex:indexPath.row];
    FRStoreDetailViewController * detail = [[FRStoreDetailViewController alloc] initWithModel:model];
    [self.navigationController pushViewController:detail animated:YES];
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

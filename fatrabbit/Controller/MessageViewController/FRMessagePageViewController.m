//
//  FRMessagePageViewController.m
//  fatrabbit
//
//  Created by 郭春城 on 2018/8/26.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import "FRMessagePageViewController.h"
#import "FRMessageNeedCell.h"
#import "FRMessageSystemCell.h"

@interface FRMessagePageViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView * tableView;

@end

@implementation FRMessagePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self createViews];
}

- (void)createViews
{
    self.navigationItem.title = @"消息中心";
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = UIColorFromRGB(0xFFFFFF);
    [self.tableView registerClass:[FRMessageSystemCell class] forCellReuseIdentifier:@"FRMessageSystemCell"];
    [self.tableView registerClass:[FRMessageNeedCell class] forCellReuseIdentifier:@"FRMessageNeedCell"];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger temp = indexPath.row % 2;
    if (temp == 1) {
        FRMessageSystemCell * cell = [tableView dequeueReusableCellWithIdentifier:@"FRMessageSystemCell" forIndexPath:indexPath];
        
        return cell;
    }
    
    FRMessageNeedCell * cell = [tableView dequeueReusableCellWithIdentifier:@"FRMessageNeedCell" forIndexPath:indexPath];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger temp = indexPath.row % 2;
    CGFloat scale = kMainBoundsWidth / 375.f;
    if (temp == 1) {
        return 60 * scale;
    }
    return 100 * scale;
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

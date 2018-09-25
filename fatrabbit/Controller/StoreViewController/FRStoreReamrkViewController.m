//
//  FRStoreReamrkViewController.m
//  fatrabbit
//
//  Created by 郭春城 on 2018/9/19.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import "FRStoreReamrkViewController.h"
#import "RDTextView.h"

@interface FRStoreReamrkViewController ()

@property (nonatomic, strong) RDTextView * textView;

@end

@implementation FRStoreReamrkViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self createViews];
}

- (void)saveButtonDidClicked
{
    NSString * remark = self.textView.text;
    if (self.remarkDidCompletetHandle) {
        self.remarkDidCompletetHandle(remark);
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)createViews
{
    self.navigationItem.title = @"填写备注";
    
    self.textView = [[RDTextView alloc] initWithFrame:CGRectZero];
    self.textView.font = kPingFangRegular(14);
    self.textView.textColor = UIColorFromRGB(0x666666);
    self.textView.placeholder = @"请填写您的备注信息";
    self.textView.placeholderLabel.textColor = UIColorFromRGB(0x999999);
    self.textView.placeholderLabel.font = kPingFangRegular(12);
    self.textView.maxSize = 200;
    [self.view addSubview:self.textView];
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(20);
        make.left.mas_equalTo(12);
        make.right.mas_equalTo(-20);
        make.height.mas_equalTo(150);
    }];
    [FRCreateViewTool cornerView:self.textView radius:5];
    self.textView.layer.borderColor = UIColorFromRGB(0x999999).CGColor;
    self.textView.layer.borderWidth = .5f;
    
    UIButton * saveButton = [FRCreateViewTool createButtonWithFrame:CGRectZero font:kPingFangRegular(12) titleColor:UIColorFromRGB(0xFFFFFF) title:@"保存"];
    saveButton.frame = CGRectMake(0, 0, 40, 30);
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:saveButton];
    [saveButton addTarget:self action:@selector(saveButtonDidClicked) forControlEvents:UIControlEventTouchUpInside];
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

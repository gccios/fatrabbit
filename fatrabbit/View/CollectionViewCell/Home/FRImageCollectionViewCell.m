//
//  FRImageCollectionViewCell.m
//  fatrabbit
//
//  Created by 郭春城 on 2018/9/3.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import "FRImageCollectionViewCell.h"
#import <Masonry.h>

@interface FRImageCollectionViewCell ()

@property (nonatomic, strong) UIImageView * baseImageView;

@property (nonatomic, strong) UIButton * deleteButton;

@end

@implementation FRImageCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self createImageCollectionViewCell];
    }
    return self;
}

- (void)configLastCell
{
    self.deleteButton.hidden = YES;
    [self.baseImageView setImage:[UIImage new]];
}

- (void)configWithImage:(UIImage *)image
{
    self.deleteButton.hidden = NO;
    [self.baseImageView setImage:image];
}

- (void)createImageCollectionViewCell
{
    CGFloat scale = kMainBoundsWidth / 375.f;
    
    self.baseImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    self.baseImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.baseImageView.clipsToBounds = YES;
    self.baseImageView.backgroundColor = [UIColor greenColor];
    [self.contentView addSubview:self.baseImageView];
    [self.baseImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10 * scale);
        make.left.mas_equalTo(10 * scale);
        make.right.mas_equalTo(-10 * scale);
        make.bottom.mas_equalTo(-10 * scale);
    }];
    
    self.deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.deleteButton.backgroundColor = [UIColor redColor];
    [self.contentView addSubview:self.deleteButton];
    [self.deleteButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.baseImageView.mas_right);
        make.centerY.mas_equalTo(self.baseImageView.mas_top);
        make.width.height.mas_equalTo(15 * scale);
    }];
    [self.deleteButton addTarget:self action:@selector(deleteButtonDidClicked) forControlEvents:UIControlEventTouchUpInside];
}

- (void)deleteButtonDidClicked
{
    if (self.imageDeleteHandle) {
        self.imageDeleteHandle();
    }
}

@end

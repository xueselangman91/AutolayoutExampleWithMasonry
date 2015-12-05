//
//  Case8Cell.m
//  MasonryExample
//
//  Created by zorro on 15/12/5.
//  Copyright © 2015年 tutuge. All rights reserved.
//

#import "Case8Cell.h"
#import "Case8DataEntity.h"
#import "Masonry.h"

@interface Case8Cell ()
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *contentLabel;
@property (strong, nonatomic) UIButton *moreButton;

@property (strong, nonatomic) MASConstraint *contentHeightConstraint;

@property (weak, nonatomic) Case8DataEntity *entity;
@property (strong, nonatomic) NSIndexPath *indexPath;
@end

@implementation Case8Cell

#pragma mark - Init

// 调用UITableView的dequeueReusableCellWithIdentifier方法时会通过这个方法初始化Cell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initView];
    }
    return self;
}

#pragma mark - Public method

- (void)setEntity:(Case8DataEntity *)entity indexPath:(NSIndexPath *)indexPath {
    _entity = entity;
    _indexPath = indexPath;
    _titleLabel.text = [NSString stringWithFormat:@"index: %d, address: %p", indexPath.row, (__bridge void*)self];
    _contentLabel.text = entity.content;

    if (_entity.expanded) {
        [_contentHeightConstraint uninstall];
    } else {
        [_contentHeightConstraint install];
    }
}

#pragma mark - Actions

- (void)switchExpandedState:(UIButton *)button {
    [_delegate case8Cell:self switchExpandedStateWithIndexPath:_indexPath];
}

#pragma mark - Private method

- (void)initView {
    // Title
    _titleLabel = [UILabel new];
    [self.contentView addSubview:_titleLabel];

    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@21);
        make.left.and.right.and.top.equalTo(self.contentView).with.insets(UIEdgeInsetsMake(4, 8, 4, 8));
    }];

    // More button
    _moreButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [_moreButton setTitle:@"More" forState:UIControlStateNormal];
    [_moreButton addTarget:self action:@selector(switchExpandedState:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_moreButton];

    [_moreButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@32);
        make.left.and.right.and.bottom.equalTo(self.contentView);
    }];

    // Content
    // 计算UILabel的preferredMaxLayoutWidth值，多行时必须设置这个值，否则系统无法决定Label的宽度
    CGFloat preferredMaxWidth = [UIScreen mainScreen].bounds.size.width - 16;

    // Content - 多行
    _contentLabel = [UILabel new];
    _contentLabel.numberOfLines = 0;
    _contentLabel.lineBreakMode = NSLineBreakByCharWrapping;
    _contentLabel.clipsToBounds = YES;
    _contentLabel.preferredMaxLayoutWidth = preferredMaxWidth; // 多行时必须设置
    [self.contentView addSubview:_contentLabel];

    [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.contentView).with.insets(UIEdgeInsetsMake(4, 8, 4, 8));
        make.top.equalTo(_titleLabel.mas_bottom).with.offset(4);
        make.bottom.equalTo(_moreButton.mas_top).with.offset(-4);
        // 先加上高度的限制
        _contentHeightConstraint = make.height.equalTo(@64).with.priorityHigh(); // 优先级只设置成High,比正常的高度约束低一些,防止冲突
    }];
}

@end
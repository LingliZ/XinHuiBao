//
//  GXEmotionCollectionView.m
//  GXEmotionKeyboard
//
//  Created by zhudong on 16/7/11.
//  Copyright © 2016年 zhudong. All rights reserved.
//

#import "GXEmotionCollectionView.h"
#import "GXEmotionCell.h"
#import "GXEmotionPackage.h"
#define toobarHeight 40
#define keyboardViewHeight 216
#define screenSize [UIScreen mainScreen].bounds.size

@interface GXEmotionCollectionView ()<UICollectionViewDelegate,UICollectionViewDataSource>

@end
@implementation GXEmotionCollectionView

- (instancetype)initWithFrame:(CGRect)frame{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = CGSizeMake(screenSize.width, keyboardViewHeight - toobarHeight);
    flowLayout.minimumLineSpacing = 0;
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self = [super initWithFrame:frame collectionViewLayout:flowLayout];
    if (self) {
        [self registerClass:[GXEmotionCell class] forCellWithReuseIdentifier:@"GXEmotionCell"];
        self.dataSource = self;
        self.delegate = self;
        self.pagingEnabled = YES;
        self.showsVerticalScrollIndicator = NO;
        self.showsHorizontalScrollIndicator = NO;
        self.bounces = NO;
    }
    return self;
}
- (void)setPackages:(NSArray *)packages{
    _packages = packages;
    [self reloadData];
}
#pragma mark - UICollectionViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    CGFloat index = scrollView.contentOffset.x / screenSize.width;
    if (self.scroolDelegate) {
        self.scroolDelegate((NSInteger)index);
    }
    
}
#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.packages.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    GXEmotionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"GXEmotionCell" forIndexPath:indexPath];
    cell.contentView.backgroundColor = [UIColor getColor:@"F8F8F8"];
    NSArray *sectionEmotion = self.packages[indexPath.item];
    cell.sectionEmotion = sectionEmotion;
    return cell;
}
@end

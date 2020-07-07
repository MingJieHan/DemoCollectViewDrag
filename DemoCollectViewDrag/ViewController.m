//
//  ViewController.m
//  DemoCollectViewDrag
//
//  Created by Han Mingjie on 2020/7/8.
//  Copyright © 2020 MingJie Han. All rights reserved.
//

#import "DemoCollectionViewDrag.h"

@interface DemoCollectionViewDrag ()<UICollectionViewDataSource,UICollectionViewDelegate>{
    UICollectionView *my_CollectionView;
}

@end

@implementation DemoCollectionViewDrag

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UICollectionViewFlowLayout *collectionFlowLayout = [[UICollectionViewFlowLayout alloc] init];
    collectionFlowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    my_CollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, 375, 667) collectionViewLayout:collectionFlowLayout];
    my_CollectionView.backgroundColor = [UIColor whiteColor];
    [my_CollectionView registerClass:[CollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    my_CollectionView.dataSource = self;
    my_CollectionView.delegate = self;
    [self.view addSubview:my_CollectionView];
}


@end

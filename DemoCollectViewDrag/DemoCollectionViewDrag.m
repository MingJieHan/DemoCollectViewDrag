//
//  ViewController.m
//  DemoCollectViewDrag
//
//  Created by Han Mingjie on 2020/7/8.
//  Copyright © 2020 MingJie Han. All rights reserved.
//

#import "DemoCollectionViewDrag.h"
#import "CollectionViewCell.h"

@interface DemoCollectionViewDrag ()<UICollectionViewDataSource,UICollectionViewDelegate>{
    NSMutableArray <NSString *>*sources_array;
    NSMutableArray *colorArray;
    UILongPressGestureRecognizer *gesture;
}
@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic,assign) BOOL isItemShake;
@end

@implementation DemoCollectionViewDrag

-(void)start_drag{
    _isItemShake = YES;
    [self.collectionView reloadData];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(end_drag)];
    if (nil == gesture){
        gesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handlelongGesture:)];
        gesture.minimumPressDuration = 0;
    }
    [self.collectionView addGestureRecognizer:gesture];
    return;
}

-(void)end_drag{
    [self.collectionView endInteractiveMovement];
    [self.collectionView removeGestureRecognizer:gesture];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Drag" style:UIBarButtonItemStylePlain target:self action:@selector(start_drag)];
    _isItemShake = NO;
    [self.collectionView reloadData];
    return;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"UICollectionView Moving Demo";
    colorArray = [[NSMutableArray alloc] init];
    sources_array = [[NSMutableArray alloc] init];
    for (int i = 0; i < 20; i ++) {
        int R = (arc4random() % 256);
        int G = (arc4random() % 256);
        int B = (arc4random() % 256) ;
        NSDictionary *dic = @{@"color":[UIColor colorWithRed:R/255.0f green:G/255.0f blue:B/255.0f alpha:1]};
        [colorArray addObject:dic];
        [sources_array addObject:[NSString stringWithFormat:@"Block %d\nRed:%d\nGreen:%d\nBlue:%d",i,R,G,B]];
    }
    
    UICollectionViewFlowLayout *collectionFlowLayout = [[UICollectionViewFlowLayout alloc] init];
    collectionFlowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, 375, 667) collectionViewLayout:collectionFlowLayout];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self.collectionView registerClass:[CollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:self.collectionView];
    
    [self end_drag];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.collectionView setFrame:CGRectMake(0.f, 0.f, self.view.frame.size.width, self.view.frame.size.height)];
}

// 拖动手势事件
- (void)handlelongGesture:(UILongPressGestureRecognizer *)longGesture {
    switch (longGesture.state) {
        case UIGestureRecognizerStateBegan:{
            // 通过手势获取点，通过点获取点击的indexPath， 移动该cell
            NSIndexPath *aIndexPath = [self.collectionView indexPathForItemAtPoint:[longGesture locationInView:self.collectionView]];
            [self.collectionView beginInteractiveMovementForItemAtIndexPath:aIndexPath];
        }
            break;
        case UIGestureRecognizerStateChanged:{
            [self.collectionView updateInteractiveMovementTargetPosition:[longGesture locationInView:self.collectionView]];
        }
            break;
        case UIGestureRecognizerStateEnded:
            [self.collectionView endInteractiveMovement];
            break;
        default:
            [self.collectionView endInteractiveMovement];
            break;
    }
}


#pragma mark -- UICollectionView / DataSource Delegate
- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

- (void)collectionView:(UICollectionView *)collectionView moveItemAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath{
    id objc = [colorArray objectAtIndex:sourceIndexPath.item];
    [colorArray removeObject:objc];
    [colorArray insertObject:objc atIndex:destinationIndexPath.item];
    
    objc = [sources_array objectAtIndex:sourceIndexPath.item];
    [sources_array removeObject:objc];
    [sources_array insertObject:objc atIndex:destinationIndexPath.item];
}

//配置item大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(167, 167);
}

//配置行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 15;
}

//配置每组上下左右的间距
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, 13, 15, 13);
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

//配置每个组里面有多少个item
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return colorArray.count;
}
//配置cell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    [cell loadWithModel:colorArray[indexPath.row]];
    if (_isItemShake) {
        [cell beginShake];
    }else{
        [cell stopShake];
    }
    cell.name = [sources_array objectAtIndex:indexPath.row];
    return cell;
}



@end

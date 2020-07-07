//
//  CollectionViewCell.m
//  DemoCollectViewDrag
//
//  Created by Han Mingjie on 2020/7/8.
//  Copyright © 2020 MingJie Han. All rights reserved.
//

#import "CollectionViewCell.h"

@interface CollectionViewCell(){
    UIImageView *img;
    UILabel *label;
}

@end
@implementation CollectionViewCell
@synthesize name;

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.contentView.backgroundColor = [UIColor clearColor];
        
        img = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 167, 167)];
        img.contentMode = UIViewContentModeScaleAspectFill;
        img.layer.masksToBounds = YES;
        [img.layer setCornerRadius:5];
        [self.contentView addSubview:img];
        
        label = [[UILabel alloc] initWithFrame:CGRectMake(5.f, 5.f, 160.f, 100.f)];
        label.numberOfLines = 4;
        label.lineBreakMode = NSLineBreakByWordWrapping;
        [self.contentView addSubview:label];
    }
    return self;
}

-(void)setName:(NSString *)_name{
    name = _name;
    label.text = name;
}

- (void)loadWithModel:(NSDictionary *)model{
    img.backgroundColor = model[@"color"];
}

- (void)beginShake{
    CAKeyframeAnimation *anim = [CAKeyframeAnimation animation];
    anim.keyPath = @"transform.rotation";
    anim.duration = 0.2;
    anim.repeatCount = MAXFLOAT;
    anim.values = @[@(-0.03),@(0.03),@(-0.03)];
    anim.removedOnCompletion = NO;
    anim.fillMode = kCAFillModeForwards;
    [self.layer addAnimation:anim forKey:@"shake"];
}

- (void)stopShake{
    [self.layer removeAllAnimations];
}
@end

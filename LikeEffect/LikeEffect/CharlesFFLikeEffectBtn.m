//
//  CharlesFFLikeEffectBtn.m
//  LikeEffect
//
//  Created by zhao shun on 2020/8/11.
//  Copyright © 2020 CharesFly. All rights reserved.
//

#import "CharlesFFLikeEffectBtn.h"

@interface CharlesFFLikeEffectBtn ()

@property(nonatomic,strong) CAEmitterLayer *explosionLayer;

@end

@implementation CharlesFFLikeEffectBtn

- (void)awakeFromNib{
    [super awakeFromNib];
    
    //设置粒子效果
    [self setupExplosion];
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupExplosion];
    }
    return self;
}

- (void)setupExplosion{
    
    //1.粒子
    CAEmitterCell *emitterCell = [CAEmitterCell emitterCell];
    emitterCell.name = @"explosionCell";
    
    //透明值变化度
    emitterCell.alphaSpeed = - 1.f;
    
    //透明度范围
    emitterCell.alphaRange = 0.10;
    
    //生命周期
    emitterCell.lifetime = 1;
    
    //生命周期range
    emitterCell.lifetimeRange = 0.1;
    
    //粒子速度
    emitterCell.velocity = 40.f;
    
    //粒子速度范围
    emitterCell.velocityRange = 10.f;
    
    //缩放比例
    emitterCell.scale = 0.08;
    
    //缩放比例range
    emitterCell.scaleRange = 0.02;
    //粒子图片
    emitterCell.contents = (id)[[UIImage imageNamed:@"spark_red"] CGImage];
    
    // 2.发射源
    CAEmitterLayer * explosionLayer = [CAEmitterLayer layer];
    [self.layer addSublayer:explosionLayer];
    
    self.explosionLayer = explosionLayer;
    //发射院尺寸大小
    self.explosionLayer.emitterSize = CGSizeMake(self.bounds.size.width + 40, self.bounds.size.height + 40);
    //emitterShape表示粒子从什么形状发射出来,圆形形状
    explosionLayer.emitterShape = kCAEmitterLayerCircle;
    //emitterMode发射模型,轮廓模式,从形状的边界上发射粒子
    explosionLayer.emitterMode = kCAEmitterLayerOutline;
    //renderMode:渲染模式
    explosionLayer.renderMode = kCAEmitterLayerOldestFirst;
    //粒子cell 数组
    explosionLayer.emitterCells = @[emitterCell];
    
}

- (void)layoutSubviews{
    [super layoutSubviews];
    //发射源位置
    self.explosionLayer.position = CGPointMake(self.bounds.size.width * 0.5, self.bounds.size.height * 0.5);
    
}

#pragma mark - 选中状态 实现缩放
- (void)setSelected:(BOOL)selected{
    [super setSelected:selected];
    
    // 通过关键帧动画实现缩放
    CAKeyframeAnimation * animation = [CAKeyframeAnimation animation];
    // 设置动画路径
    animation.keyPath = @"transform.scale";
    
    if (selected) {
        // 从没有点击到点击状态 会有爆炸的动画效果
        animation.values = @[@1.5,@2.0, @0.8, @1.0];
        animation.duration = 0.5;
        //计算关键帧方式:
        animation.calculationMode = kCAAnimationCubic;
        //为图层添加动画
        [self.layer addAnimation:animation forKey:nil];
        
        // 让放大动画先执行完毕 再执行爆炸动画
        [self performSelector:@selector(startAnimation) withObject:nil afterDelay:0.25];
    }else{
        // 从点击状态normal状态 无动画效果 如果点赞之后马上取消 那么也立马停止动画
        [self stopAnimation];
    }
}

#pragma mark - 没有高亮状态
- (void)setHighlighted:(BOOL)highlighted{
    
    [super setHighlighted:highlighted];
}

#pragma mark - 开始动画
- (void)startAnimation{
    
    // 用KVC设置颗粒个数
    [self.explosionLayer setValue:@1000 forKeyPath:@"emitterCells.explosionCell.birthRate"];
    
    // 开始动画
    self.explosionLayer.beginTime = CACurrentMediaTime();
    
    // 延迟停止动画
    [self performSelector:@selector(stopAnimation) withObject:nil afterDelay:0.15];
}

#pragma mark - 动画结束
- (void)stopAnimation{
    // 用KVC设置颗粒个数
    [self.explosionLayer setValue:@0 forKeyPath:@"emitterCells.explosionCell.birthRate"];
    //移除动画
    [self.explosionLayer removeAllAnimations];
}

- (void)drawRect:(CGRect)rect {
    
}

@end

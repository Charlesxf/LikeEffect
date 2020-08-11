//
//  ViewController.m
//  LikeEffect
//
//  Created by zhao shun on 2020/8/11.
//  Copyright © 2020 CharesFly. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)likeClick:(UIButton *)sender {
    if (!sender.selected) { // 点赞
        sender.selected = !sender.selected;
        NSLog(@"点赞");
    }else{ // 取消点赞
        sender.selected = !sender.selected;
        NSLog(@"取消赞");
    }
}

@end

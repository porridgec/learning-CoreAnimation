//
//  MainViewController.m
//  learning-CoreAnimation
//
//  tutorial url : http://www.cnblogs.com/kenshincui/p/3972100.html
//  Created by Hahn.Chan on 3/28/16.
//  Copyright © 2016 Hahn Chan. All rights reserved.
//

#import "MainViewController.h"

#define WIDTH 50
#define SCREENSIZE [UIScreen mainScreen].bounds.size

@interface MainViewController ()

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self drawMyLayer];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - draw layer

- (void)drawMyLayer {
    CALayer *layer = [[CALayer alloc] init];
    layer.backgroundColor = [UIColor purpleColor].CGColor;
    layer.position = CGPointMake(SCREENSIZE.width / 2, SCREENSIZE.height / 2);
    layer.bounds = CGRectMake(0, 0, WIDTH, WIDTH);
    layer.cornerRadius = WIDTH / 2;
    [self.view.layer addSublayer:layer];
}

#pragma mark - actions

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CALayer *layer = self.view.layer.sublayers[0];
    CGFloat width = layer.bounds.size.width;
    if (width == WIDTH) {
        width = WIDTH * 4;
    } else {
        width = WIDTH;
    }
    layer.bounds = CGRectMake(0, 0, width, width);
    layer.cornerRadius = width / 2;
    layer.position = [touch locationInView:self.view];
}

@end

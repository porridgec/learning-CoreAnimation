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
#define PHOTO_HEIGHT 100

@interface MainViewController ()

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
//    [self drawMyLayer];
    [self drawAnotherLayer];
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

- (void)drawAnotherLayer {
    CALayer *layer=[[CALayer alloc]init];
    layer.bounds=CGRectMake(0, 0, PHOTO_HEIGHT, PHOTO_HEIGHT);
    layer.position=CGPointMake(160, 200);
    layer.backgroundColor=[UIColor redColor].CGColor;
    layer.cornerRadius=PHOTO_HEIGHT/2;
    //注意仅仅设置圆角，对于图形而言可以正常显示，但是对于图层中绘制的图片无法正确显示
    //如果想要正确显示则必须设置masksToBounds=YES，剪切子图层
    layer.masksToBounds=YES;
    //阴影效果无法和masksToBounds同时使用，因为masksToBounds的目的就是剪切外边框，
    //而阴影效果刚好在外边框
        layer.shadowColor=[UIColor grayColor].CGColor;
        layer.shadowOffset=CGSizeMake(2, 2);
        layer.shadowOpacity=1;
    //设置边框
    layer.borderColor=[UIColor purpleColor].CGColor;
    layer.borderWidth=2;
    
    //设置图层代理
    layer.delegate=self;
    
    //添加图层到根图层
    [self.view.layer addSublayer:layer];
    
    //调用图层setNeedDisplay,否则代理方法不会被调用
    [layer setNeedsDisplay];
}

#pragma mark - actions

//- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    UITouch *touch = [touches anyObject];
//    CALayer *layer = self.view.layer.sublayers[0];
//    CGFloat width = layer.bounds.size.width;
//    if (width == WIDTH) {
//        width = WIDTH * 4;
//    } else {
//        width = WIDTH;
//    }
//    layer.bounds = CGRectMake(0, 0, width, width);
//    layer.cornerRadius = width / 2;
//    layer.position = [touch locationInView:self.view];
//}

#pragma mark - CALayer Delegate

- (void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx {
    CGContextSaveGState(ctx);
    
    CGContextScaleCTM(ctx, 1, -1);
    CGContextTranslateCTM(ctx, 0, -PHOTO_HEIGHT);
    
    UIImage *image = [UIImage imageNamed:@"boob.gif"];
    CGContextDrawImage(ctx, CGRectMake(0, 0, PHOTO_HEIGHT, PHOTO_HEIGHT), image.CGImage);
    
    CGContextRestoreGState(ctx);
}

@end

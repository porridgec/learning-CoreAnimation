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
#define POSITION CGPointMake(160, 200);
#define BOUNDS CGRectMake(0, 0, PHOTO_HEIGHT, PHOTO_HEIGHT);
#define CORNERRADIUS PHOTO_HEIGHT/2;
#define BORDERWIDTH 2;

@interface MainViewController ()

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
//    [self drawMyLayer];
    [self drawShadowLayer];
    [self drawPictureLayer];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - draw layer

- (void)drawShadowLayer {
    CALayer *shadowLayer = [[CALayer alloc] init];
    shadowLayer.bounds = BOUNDS;
    shadowLayer.position = POSITION;
    shadowLayer.cornerRadius = CORNERRADIUS;
    shadowLayer.shadowColor = [UIColor grayColor].CGColor;
    shadowLayer.shadowOffset = CGSizeMake(2,2);
    shadowLayer.shadowOpacity = 1;
    shadowLayer.borderColor = [UIColor whiteColor].CGColor;
    shadowLayer.borderWidth = BORDERWIDTH;
    //shadowLayer.delegate = self;
    [self.view.layer addSublayer:shadowLayer];
    [shadowLayer setNeedsDisplay];
}

- (void)drawPictureLayer {
    CALayer *pictureLayer = [[CALayer alloc] init];
    pictureLayer.bounds = BOUNDS;
    pictureLayer.position = POSITION;
    pictureLayer.cornerRadius = CORNERRADIUS;
    pictureLayer.borderColor = [UIColor whiteColor].CGColor;
    pictureLayer.borderWidth = BORDERWIDTH;
    pictureLayer.delegate = self;
    pictureLayer.masksToBounds = YES;
    [self.view.layer addSublayer:pictureLayer];
    [pictureLayer setNeedsDisplay];
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

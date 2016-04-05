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

@property (nonatomic, strong) CALayer *shadowLayer;
@property (nonatomic, strong) CALayer *pictureLayer;
@property (nonatomic, assign) BOOL flag;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
//    [self drawMyLayer];
    //[self drawShadowLayer];
    [self drawPictureLayer];
    
    _flag = YES;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake(SCREENSIZE.width / 2 - 25, 50, 50, 50);
    [button setTitle:@"续" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(transform:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - draw layer

- (void)drawShadowLayer {
    _shadowLayer = [[CALayer alloc] init];
    _shadowLayer.bounds = BOUNDS;
    _shadowLayer.position = POSITION;
    _shadowLayer.cornerRadius = CORNERRADIUS;
    _shadowLayer.shadowColor = [UIColor grayColor].CGColor;
    _shadowLayer.shadowOffset = CGSizeMake(2,2);
    _shadowLayer.shadowOpacity = 1;
    _shadowLayer.borderColor = [UIColor whiteColor].CGColor;
    _shadowLayer.borderWidth = BORDERWIDTH;
    //_shadowLayer.delegate = self;
    [self.view.layer addSublayer:_shadowLayer];
    [_shadowLayer setNeedsDisplay];
}

- (void)drawPictureLayer {
    _pictureLayer = [[CALayer alloc] init];
    _pictureLayer.bounds = BOUNDS;
    _pictureLayer.position = POSITION;
    _pictureLayer.cornerRadius = CORNERRADIUS;
    _pictureLayer.borderColor = [UIColor purpleColor].CGColor;
    _pictureLayer.borderWidth = BORDERWIDTH;
    _pictureLayer.delegate = self;
    _pictureLayer.masksToBounds = YES;
    
    [self.view.layer addSublayer:_pictureLayer];
    [_pictureLayer setNeedsDisplay];
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

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInView:self.view];
    CAAnimation *animation = [_pictureLayer animationForKey:@"elder_move"];
    if (animation) {
        if (_pictureLayer.speed == 0) {
            [self resumeAnimation];
        } else {
            [self pauseAnimation];
        }
    } else {
        [self translationAnimationToPoint:location];
        [self rotationAnimation];
    }
}

//- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    UITouch *touch = [touches anyObject];
//    CGPoint location = [touch locationInView:self.view];
//    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(translationAnimationToPoint:) object:nil];
//    [self translationAnimationToPoint:location];
//    [self rotationAnimation];
//}

- (void)transform:(id)sender {
    id value = @(M_PI*_flag);
    _flag = !_flag;
    [_pictureLayer setValue:value forKeyPath:@"transform.rotation.x"];
}

#pragma mark - CALayer Delegate

- (void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx {
    CGContextSaveGState(ctx);
    
    CGContextScaleCTM(ctx, 1, -1);
    CGContextTranslateCTM(ctx, 0, -PHOTO_HEIGHT);
    
    UIImage *image = [UIImage imageNamed:@"elder.jpg"];
    CGContextDrawImage(ctx, CGRectMake(0, 0, PHOTO_HEIGHT, PHOTO_HEIGHT), image.CGImage);
    
    CGContextRestoreGState(ctx);
}

#pragma mark - animation

- (void)translationAnimationToPoint:(CGPoint)location {
    CABasicAnimation *basicAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
    basicAnimation.toValue = [NSValue valueWithCGPoint:location];
    basicAnimation.duration = 1.5;
    basicAnimation.delegate = self;
    basicAnimation.removedOnCompletion = NO;
    [basicAnimation setValue:[NSValue valueWithCGPoint:location] forKey:@"EndPoint"];
    [_pictureLayer addAnimation:basicAnimation forKey:@"elder_move"];
}

- (void)rotationAnimation {
    CABasicAnimation *basicAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    basicAnimation.toValue = [NSNumber numberWithFloat:M_PI_2*4];
    basicAnimation.duration = 2.5;
    basicAnimation.repeatDuration = HUGE_VALF;
    basicAnimation.removedOnCompletion = NO;
    basicAnimation.autoreverses = NO;
    [_pictureLayer addAnimation:basicAnimation forKey:@"elder_rotation"];
}

- (void)pauseAnimation {
    CFTimeInterval interval = [_pictureLayer convertTime:CACurrentMediaTime() fromLayer:nil];
    _pictureLayer.timeOffset = interval;
    _pictureLayer.speed = 0;
}

- (void)resumeAnimation {
    CFTimeInterval beginTime = CACurrentMediaTime() - _pictureLayer.timeOffset;
    _pictureLayer.timeOffset = 0;
    _pictureLayer.beginTime = beginTime;
    _pictureLayer.speed = 1;
}

#pragma mark - animation delegate

- (void)animationDidStart:(CAAnimation *)anim {
    
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    
    _pictureLayer.position = [[anim valueForKey:@"EndPoint"] CGPointValue];
    
    [CATransaction commit];
    [self pauseAnimation];
}

@end

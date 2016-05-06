//
//  ViewController.m
//  circleProgress
//
//  Created by lizq on 16/4/8.
//  Copyright (c) 2016年 w jf. All rights reserved.
//

#import "ViewController.h"
#import "OutsideView.h"

@interface ViewController ()<OutSideProtocol>
@property (strong, nonatomic) OutsideView *outsideView;
@property (strong, nonatomic) OutsideView *leftView;
@property (strong, nonatomic) OutsideView *rightView;
@property (strong, nonatomic) OutsideView *centerView;



@property (copy, nonatomic) NSString *centerPoint;

@property (strong, nonatomic) CAShapeLayer *maskLayer;
@property (assign, nonatomic) float progress;
@property (strong, nonatomic) UIBezierPath *path;
@property (assign, nonatomic) BOOL isTimerFire;
@property (strong, nonatomic) NSTimer * timer;

@property (strong, nonatomic) NSMutableArray *viewArray;



@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.viewArray = [NSMutableArray arrayWithCapacity:0];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 50, 80, 40);
    [button setTitle:@"开始" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [button addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    self.outsideView = [[OutsideView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
    self.outsideView.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2 + 100);
    self.outsideView.delegate = self;
    [self.view addSubview:self.outsideView];
    [self.viewArray addObject:self.outsideView];
    
    self.leftView = [[OutsideView alloc] initWithFrame:CGRectMake(0, 0, 120, 120)];
    self.leftView.center = CGPointMake(self.view.frame.size.width/2 - 100, self.view.frame.size.height/2 - 100);
    self.leftView.delegate = self;
    [self.view addSubview:self.leftView];
    [self.viewArray addObject:self.leftView];

    
    
    self.rightView = [[OutsideView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    self.rightView.center = CGPointMake(self.view.frame.size.width/2 + 100, self.view.frame.size.height/2 - 100);
    self.rightView.delegate = self;
    [self.view addSubview:self.rightView];
    [self.viewArray addObject:self.rightView];
    
    self.centerView = self.outsideView;
    self.centerPoint = NSStringFromCGPoint(self.centerView.center);

    
}


- (void)buttonClick {
    
    if (!self.isTimerFire) {
        self.progress = 0;
        self.isTimerFire = YES;
        NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:0.3 target:self selector:@selector(changeProgress) userInfo:nil repeats:YES];
        [timer fire];
        self.timer = timer;
    }else {
        self.isTimerFire = NO;
        self.outsideView.progress = 0;
        self.leftView.progress = 0;
        self.rightView.progress = 0;

        [self.timer invalidate];
    }
}


- (void)changeProgress {
    
    if (self.outsideView.progress + 3 > 100) {
        self.outsideView.progress = 100;
        self.leftView.progress = 100;
        self.rightView.progress = 100;

    }else {
        self.outsideView.progress = self.outsideView.progress + 3;
        self.leftView.progress = self.leftView.progress + 3;
        self.rightView.progress = self.rightView.progress + 3;

    }
}



- (BOOL)isChanePosition:(CGPoint)point toView:(OutsideView *)view {
    
    return (view.oldCenter.x - point.x)*(view.oldCenter.x - point.x) + (view.oldCenter.y - point.y)*(view.oldCenter.y - point.y) <= view.radius*view.radius;;
}


- (void)changeView:(OutsideView *)view toView:(OutsideView *)toView {
    
    OutsideView *otherView;
    for (OutsideView*subView in self.viewArray) {
        if (subView != view&&subView != toView) {
            otherView = subView;
            break;
        }
    }
    
    float scale = toView.radius/view.radius;
    
    float toScale = otherView.radius/toView.radius;

    float otherScale = view.radius/otherView.radius;
    
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.6 initialSpringVelocity:0.5 options:UIViewAnimationOptionLayoutSubviews animations:^{
        view.center = toView.center;
        toView.center = otherView.center;
        otherView.center = view.oldCenter;
        
        view.transform = CGAffineTransformScale(view.transform, scale, scale);
        toView.transform = CGAffineTransformScale(toView.transform,toScale, toScale);
        otherView.transform = CGAffineTransformScale(otherView.transform,otherScale, otherScale);

    } completion:^(BOOL finished) {
        
        view.oldCenter = view.center;
        toView.oldCenter = toView.center;
        otherView.oldCenter = otherView.center;

        view.radius = view.radius*scale;
        toView.radius = toView.radius*toScale;
        otherView.radius = otherView.radius*otherScale;
        
        for (OutsideView *subview in self.viewArray) {
            NSString *string = NSStringFromCGPoint(subview.center);
            if ([self.centerPoint isEqualToString:string]) {
                self.centerView = subview;
                self.centerPoint = string.copy;
                break;
            }
        }

        
    }];
    
}


-(void)outSideView:(OutsideView *)view changeCenterToPoint:(CGPoint )centerPoint {
    
    
    if ([self isChanePosition:centerPoint toView:self.outsideView]) {
        
        [self changeView:view toView:self.outsideView];
        NSLog(@"交换到self.outsideView");
        
    }else if ([self isChanePosition:centerPoint toView:self.leftView]){
        
        NSLog(@"交换到self.leftView");
        [self changeView:view toView:self.leftView];

    
    }else if ([self isChanePosition:centerPoint toView:self.rightView]){
        
        NSLog(@"交换到self.rightView");
        [self changeView:view toView:self.rightView];

    }else {
        
        NSLog(@"还原");
        [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.6 initialSpringVelocity:0.5 options:UIViewAnimationOptionLayoutSubviews animations:^{
            view.center = view.oldCenter;
        } completion:nil];


    }
}

-(void)didClickedOutSideView:(OutsideView *)view {
    
    if (view != self.centerView) {
        float scale = self.centerView.radius/view.radius;
        float toScale = view.radius/self.centerView.radius;
        [UIView animateWithDuration:0.4 delay:0 usingSpringWithDamping:0.6 initialSpringVelocity:0.5 options:UIViewAnimationOptionLayoutSubviews animations:^{
            
            view.center = self.centerView.center;
            self.centerView.center = view.oldCenter;
            view.transform = CGAffineTransformScale(view.transform, scale, scale);
            self.centerView.transform = CGAffineTransformScale(self.centerView.transform,toScale, toScale);
        } completion:^(BOOL finished) {
            
            view.oldCenter = view.center;
            view.radius = view.radius*scale;
            
            self.centerView.oldCenter = self.centerView.center;
            self.centerView.radius = self.centerView.radius*toScale;

            self.centerView = view;
            self.centerPoint = NSStringFromCGPoint(self.centerView.center);
            
        }];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

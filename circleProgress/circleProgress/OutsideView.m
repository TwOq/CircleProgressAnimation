//
//  OutsideView.m
//  circleProgress
//
//  Created by lizq on 16/4/8.
//  Copyright (c) 2016年 w jf. All rights reserved.
//

#import "OutsideView.h"
#import "ProgressView.h"

#define WIDTH (self.frame.size.width - 5)
#define HEIGHT (self.frame.size.height - 5)
#define LINECOUNT 80   //线的根数
#define LINEWIDTH 2  //线宽

@interface OutsideView ()

@property (strong, nonatomic) UIView *progressView;
@property (strong, nonatomic) UIView *backProgressView;

@property (strong, nonatomic) CAShapeLayer *maskLayer;
@property (strong, nonatomic) UIBezierPath *path;
@property (strong, nonatomic) ProgressView *progressCirleView;

@property (assign, nonatomic) CGPoint stratPoint;
@property (assign, nonatomic) CGPoint selfOldCenter;


@end

@implementation OutsideView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor colorWithRed:12/255.0 green:32/255.0 blue:46/255.0 alpha:1];
        self.layer.borderWidth = 1;
        self.layer.borderColor = [UIColor blackColor].CGColor;
        self.layer.cornerRadius = WIDTH/2;

        [self initBackProgress];
        [self initProgressView];
        [self initProgressCircle];

        
        UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureActiving:)];
        [self addGestureRecognizer:panGesture];
        
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapCestureActiving:)];
        [self addGestureRecognizer:tapGesture];
        
        
    }
    

    return self;
}

//-(void)layoutUI {
//    
//    for (id view in self.subviews) {
//        [view removeFromSuperview];
//    }
//    self.layer.cornerRadius = WIDTH/2;
//
//    [self initBackProgress];
//    [self initProgressView];
//    [self initProgressCircle];
//
//}

-(void)setDelegate:(id<OutSideProtocol>)delegate{
    _delegate = delegate;
    
    self.oldFrame = self.frame;
    self.oldCenter = self.center;
    self.radius = self.frame.size.width/2;
}

-(void)panGestureActiving:(UIPanGestureRecognizer *)gesture {
    
    CGPoint point = [gesture translationInView:self.superview];
    CGFloat x = gesture.view.center.x + point.x;
    CGFloat y = gesture.view.center.y + point.y;

    if (gesture.state == UIGestureRecognizerStateBegan) {
        [self.superview bringSubviewToFront:gesture.view];
        self.stratPoint = point;
        
    }else if(gesture.state == UIGestureRecognizerStateChanged ) {
        
        gesture.view.center = CGPointMake(x, y);
        [gesture setTranslation:CGPointMake(0, 0) inView:self];
        
    }else if(gesture.state == UIGestureRecognizerStateEnded) {
        if ([self.delegate respondsToSelector:@selector(outSideView:changeCenterToPoint:)]) {
            [self.delegate outSideView:self changeCenterToPoint:CGPointMake(x, y)];
        }
    }

}


- (void)tapCestureActiving:(UITapGestureRecognizer *)gesture {

    if ([self.delegate respondsToSelector:@selector(didClickedOutSideView:)]) {
        [self.delegate didClickedOutSideView:self];
    }
}


- (void)initBackProgress{
    
    self.backProgressView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
    self.backProgressView.backgroundColor = self.backgroundColor;
    self.backProgressView.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    self.backProgressView.layer.cornerRadius = self.layer.cornerRadius;
    [self addSubview:self.backProgressView];

    CAReplicatorLayer *replicator = [CAReplicatorLayer layer];
    replicator.position = CGPointMake(WIDTH/2, HEIGHT/2);
    [self.backProgressView.layer addSublayer:replicator];
    
    [replicator addSublayer:[self lineLayer]];
    //容器中的对象复制次数
    replicator.instanceCount = LINECOUNT;
    //此处的3d变换是相对前一个复制对象的位置
    CATransform3D transform = CATransform3DIdentity;
    transform = CATransform3DRotate(transform, M_PI*2/LINECOUNT, 0, 0, 1);
    replicator.instanceTransform = transform;


}


- (void)initProgressView {

    self.progressView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
    self.progressView.layer.cornerRadius = self.layer.cornerRadius;
    self.progressView.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    self.progressView.backgroundColor = self.backgroundColor;

    [self addSubview:self.progressView];
    
    
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.cornerRadius = self.layer.cornerRadius;
    gradientLayer.frame = CGRectMake(0, 0, WIDTH, HEIGHT);
    [self.progressView.layer addSublayer:gradientLayer];
    
    gradientLayer.colors = @[(__bridge id)[UIColor redColor].CGColor,
                             (__bridge id)[UIColor greenColor].CGColor,
                             (__bridge id)[UIColor purpleColor].CGColor,
                             (__bridge id)[UIColor orangeColor].CGColor];
    
    gradientLayer.locations  = @[@(1/6.0), @(0.5), @(1 - 1/6.0)];
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint   = CGPointMake(0, 1);
    
    
    CAReplicatorLayer *replicator = [CAReplicatorLayer layer];
    replicator.position = gradientLayer.position;
    [self.progressView.layer addSublayer:replicator];
    
    [replicator addSublayer:[self lineLayer]];
    //容器中的对象复制次数
    replicator.instanceCount = LINECOUNT;
    //此处的3d变换是相对前一个复制对象的位置
    CATransform3D transform = CATransform3DIdentity;
    transform = CATransform3DRotate(transform, M_PI*2/LINECOUNT, 0, 0, 1);
    replicator.instanceTransform = transform;
    gradientLayer.mask = replicator;
    self.progressView.layer.mask = self.maskLayer;
}

- (void)initProgressCircle {
    
    self.progressCirleView = [[ProgressView alloc] initWithFrame:CGRectMake(0, 0, WIDTH - 20,HEIGHT - 20)];
    self.progressCirleView.layer.cornerRadius = (WIDTH - 20)/2;
    self.progressCirleView.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    self.progressCirleView.backgroundColor = self.backgroundColor;
    [self addSubview:self.progressCirleView];


}


- (CALayer *)lineLayer {
    CALayer *layer = [CALayer layer];
    layer.frame = CGRectMake(0, 0, LINEWIDTH, HEIGHT/2);
    layer.backgroundColor = [UIColor colorWithWhite:0.85 alpha:1].CGColor;
    layer.anchorPoint = CGPointMake(0, 0.5);
    return layer;
}


-(void)setProgress:(float)progress {
    _progress = progress;
    self.maskLayer.path = [self maskPthWithProgress:self.progress].CGPath;
    
}


- (CAShapeLayer *)maskLayer{
    
    if (_maskLayer == nil) {
        _maskLayer = [CAShapeLayer layer];
        _maskLayer.fillColor = [UIColor redColor].CGColor;
        _maskLayer.strokeColor = [UIColor redColor].CGColor;
        _maskLayer.path = [self maskPthWithProgress:self.progress].CGPath;
    }
    return  _maskLayer;
}



- (UIBezierPath *)maskPthWithProgress:(float )progress {
    
    float toAngel = progress/100.0*M_PI*2 + 1.5*M_PI;
    
    self.progressCirleView.progress = progress;

    if (self.path == nil) {
        self.path = [UIBezierPath bezierPath];
        [self.path moveToPoint:CGPointMake(self.frame.size.width/2, self.frame.size.height/2)];
    }
    [self.path addArcWithCenter:CGPointMake(self.frame.size.width/2, self.frame.size.height/2)
                         radius:self.frame.size.height/2
                     startAngle:1.5*M_PI
                       endAngle:toAngel
                      clockwise:YES];
    
    [self.path moveToPoint:CGPointMake(self.frame.size.width/2, self.frame.size.height/2)];
    
    return self.path;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

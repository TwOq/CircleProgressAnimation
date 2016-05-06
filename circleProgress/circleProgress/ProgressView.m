//
//  ProgressView.m
//  circleProgress
//
//  Created by lizq on 16/4/12.
//  Copyright © 2016年 w jf. All rights reserved.
//

#import "ProgressView.h"

@interface ProgressView ()
@property (strong, nonatomic) CAShapeLayer *animalayer;
@property (strong, nonatomic) CAShapeLayer *cirleLayer;
@property (assign, nonatomic) float startAngle;
@property (assign, nonatomic) float endAngle;


@end

@implementation ProgressView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self drawBackCircle];
        self.startAngle = 0;
        self.endAngle = 0;
    }
    return self;
}

- (void)drawBackCircle {

    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithArcCenter:self.center
                                                              radius:self.frame.size.width/2 - 6
                                                          startAngle:0
                                                            endAngle:2*M_PI
                                                           clockwise:YES];
    
    CAShapeLayer *cirleBigLayer = [CAShapeLayer layer];
    cirleBigLayer.strokeColor = [UIColor lightGrayColor].CGColor;
    cirleBigLayer.fillColor = self.backgroundColor.CGColor;
    cirleBigLayer.lineWidth = 3;
    cirleBigLayer.path = bezierPath.CGPath;
    [self.layer addSublayer:cirleBigLayer];
    
    UIBezierPath *bezierSmallPath = [UIBezierPath bezierPathWithArcCenter:self.center
                                                                   radius:self.frame.size.width/2 - 12
                                                               startAngle:0
                                                                 endAngle:2*M_PI
                                                                clockwise:YES];
    CAShapeLayer *cirleSmallLayer = [CAShapeLayer layer];
    cirleSmallLayer.strokeColor = [UIColor redColor].CGColor;
    cirleSmallLayer.fillColor = self.backgroundColor.CGColor;
    cirleSmallLayer.lineWidth = 1.5;
    cirleSmallLayer.path = bezierSmallPath.CGPath;
    [cirleSmallLayer setLineDashPattern:
        [NSArray arrayWithObjects:[NSNumber numberWithInt:3],
         [NSNumber numberWithInt:3],nil]];
    [self.layer addSublayer:cirleSmallLayer];
    
    UIBezierPath *progressPath = [UIBezierPath bezierPathWithArcCenter:self.center
                                                                   radius:self.frame.size.width/2 - 24
                                                               startAngle:0
                                                                 endAngle:2*M_PI
                                                                clockwise:YES];
    CAShapeLayer *progressLayer = [CAShapeLayer layer];
    progressLayer.strokeColor = [UIColor colorWithWhite:0.2 alpha:1].CGColor;
    progressLayer.fillColor = self.backgroundColor.CGColor;
    progressLayer.lineWidth = 7;
    progressLayer.path = progressPath.CGPath;
    [self.layer addSublayer:progressLayer];
    
}


-(CAShapeLayer *)cirleLayer {
    
    if (_cirleLayer == nil) {
        _cirleLayer = [CAShapeLayer layer];
        _cirleLayer.frame = CGRectMake(0, 0, (self.frame.size.width/2 - 24)*2, (self.frame.size.width/2 - 24)*2);
        _cirleLayer.position = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
        _cirleLayer.backgroundColor = [UIColor clearColor].CGColor;
        _cirleLayer.cornerRadius = self.frame.size.width/2 - 24;
        
        CAShapeLayer *roundLayer = [CAShapeLayer layer];
        roundLayer.frame = CGRectMake(0, 0, 20, 20);
        roundLayer.position = CGPointMake(_cirleLayer.frame.size.width/2, _cirleLayer.frame.size.height/2);
        roundLayer.cornerRadius = 10;
        roundLayer.backgroundColor = [UIColor redColor].CGColor;

        roundLayer.transform = CATransform3DMakeTranslation(0, -_cirleLayer.frame.size.height/2, 0);
        [_cirleLayer addSublayer:roundLayer];
    }
    [self.layer addSublayer:_cirleLayer];

    return _cirleLayer;
}


-(void)setProgress:(float)progress {
    
    _progress = progress/100.0*M_PI*2;
    self.endAngle = progress/100.0;
    [self addMakeAnimation:self.animalayer];
    [self addCirleAnimation:self.cirleLayer];
    self.startAngle = progress/100.0;
}

- (void)addCirleAnimation:(CAShapeLayer *)shapelayer {
    
    self.cirleLayer.transform = CATransform3DMakeRotation(self.progress, 0, 0, 1);
    CABasicAnimation *rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.duration = 0.25;
    rotationAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    rotationAnimation.fromValue = @(self.startAngle*2*M_PI);
    rotationAnimation.toValue = @(self.endAngle*2*M_PI);
    [shapelayer addAnimation:rotationAnimation forKey:@"rotationAnimation"];

}


//动画
-(void)addMakeAnimation:(CAShapeLayer *)shapeLayer{
    
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.frame.size.width/2, self.frame.size.height/2)
                                                        radius:self.frame.size.width/2 - 24
                                                    startAngle:1.5*M_PI
                                                      endAngle:self.endAngle*2*M_PI + 1.5*M_PI
                                                     clockwise:YES];

    
    shapeLayer.path = path.CGPath;
    
    CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
    pathAnimation.duration = 0.25;
    pathAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [shapeLayer addAnimation:pathAnimation forKey:@"strokeEndAnimation"];

    
}

-(CAShapeLayer *)animalayer {
    
    if (_animalayer == nil) {
        _animalayer = [CAShapeLayer layer];
        _animalayer.strokeColor = [UIColor colorWithRed:28/255.0
                                                  green:176/255.0
                                                   blue:225/255.0
                                                  alpha:1
                                   ].CGColor;
        
        _animalayer.fillColor = [UIColor clearColor].CGColor;
        _animalayer.lineWidth = 9;
        [_animalayer setLineCap:kCALineCapRound];
        [self.layer addSublayer:_animalayer];
    }
    return _animalayer;
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

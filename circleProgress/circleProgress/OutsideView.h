//
//  OutsideView.h
//  circleProgress
//
//  Created by lizq on 16/4/8.
//  Copyright (c) 2016年 w jf. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol OutSideProtocol;

@interface OutsideView : UIView
@property (assign, nonatomic) float progress;
@property (assign, nonatomic) id<OutSideProtocol> delegate;
@property (assign, nonatomic) CGPoint oldCenter;
@property (assign, nonatomic) CGRect oldFrame;

@property (assign, nonatomic) float radius;

//- (void)layoutUI;
@end

@protocol OutSideProtocol <NSObject>

- (void)outSideView:(OutsideView *)view changeCenterToPoint:(CGPoint)centerPoint;

- (void)didClickedOutSideView:(OutsideView *)view;


@end

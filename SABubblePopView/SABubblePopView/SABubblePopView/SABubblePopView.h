//
//  SABubblePopView.h
//  SAKitDemo
//
//  Created by 李磊 on 26/6/17.
//  Copyright © 2017年 李磊. All rights reserved.
//

#import <UIKit/UIKit.h>

/**  三角的方向 */
typedef enum :NSInteger{
    SATriangleDicrectionUp,       // 向上，默认
    SATriangleDicrectionLeft,     // 向左
    SATriangleDicrectionDown,     // 向下
    SATriangleDicrectionRight     // 向右
} SATriangleDicrection;

/** 气泡的样式 */
typedef enum :NSInteger{
    SABubbleTypeNormal, //全部都是文字,默认
    SABubbleTypeButton, //button
    SABubbleTypeView //view
} SABubbleViewType;


@class SABubblePopView;
/** SABubbleTypeView类型的代理,主要实现返回代理 */
@protocol SABubbleTypeViewProtocol <NSObject>

/** cell的行数 */
- (NSInteger)saBubblePopTypeView:(SABubblePopView *)saBubblePopView numberOfCellInSection:(NSInteger)section;

/** 给cell上赋值代理 */
- (NSString *)saBubblePopTypeView:(SABubblePopView *)saBubblePopView textAtIndexPath:(NSIndexPath *)indexPath;

/** 选择了之后,返回代理 */
- (void)saBubblePopTypeViewComplteAction:(SABubblePopView *)saBubblePopView selectIndex:(NSIndexPath *)indexPath;


@end


@interface SABubblePopView : UIView


/** SABubbleTypeView实现代理,其他实现其，并无作用 */
@property (nonatomic, weak) id <SABubbleTypeViewProtocol> delegate;


/** 文字显示的Lab */
@property (nonatomic, strong) UILabel *label;

/** 三角的方向,默认SATriangleDicrectionUp  */
@property (nonatomic, assign) SATriangleDicrection triangleDicrection;

/** 类型选择,默认SABubbleTypeNormal */
@property (nonatomic, assign) SABubbleViewType bubbleViewType;

/** 三角位置的比例,默认0.5 */
@property (nonatomic, assign) CGFloat triangleSeatScale;

/** 三角形坐标 */
@property (nonatomic, assign) CGPoint trianglePoint;


/**
 构造方法
 
 @param point 三角形坐标的点
 @return 弹出气泡
 */
- (instancetype)initWithTrianglePoint:(CGPoint)point ;


/**
 在蒙版上显示弹出框
 
 @param maskSuperView 蒙版父视图
 */
- (void)show:(UIView *)maskSuperView;


/**
 弹框消失
 */
- (void)dismiss;

@end

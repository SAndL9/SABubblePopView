//
//  SABubblePopView.m
//  SAKitDemo
//
//  Created by 李磊 on 26/6/17.
//  Copyright © 2017年 李磊. All rights reserved.
//

#import "SABubblePopView.h"


/** 文字距离上下间隔 */
static NSInteger const  kTopDownSpace = 8;

/** 文字距离左右间隔 */
static NSInteger const kLeftRightSpace = 13;

@interface SABubblePopView () <UIGestureRecognizerDelegate, UITableViewDelegate,UITableViewDataSource>

/** 点击蒙层的时候，是否使弹出框消失 */
@property (nonatomic,assign) BOOL dismissWhenClickMaskView;

/**是否需要蒙层，默认有*/
@property (nonatomic,assign) BOOL haveMaskView;

/**  我知道了 按钮 */
@property (nonatomic, strong) UIButton * sureButton;

/**蒙层透明度，默认是0.3*/
@property (nonatomic,assign) CGFloat maskAlpha;

/**蒙层*/
@property (nonatomic,strong) UIView *maskView;

/** 三角形边长，默认是10 */
@property (nonatomic,assign) CGFloat triangleSide;

/** 弹出框圆角，默认是5. */
@property (nonatomic,assign) CGFloat cornerRadius;

/** 弹出框背景颜色，默认是白  */
@property (nonatomic,strong) UIColor *popupBackgroundColor;

@property (nonatomic, strong) UITableView *tabelView;

/** 我知道了 上面的横线 */
@property (nonatomic, strong) UIView *lineView;

/** 实际界面的View */
@property (nonatomic, strong) UIView *realView;

/** 用于记录cell的个数,实现布局cell高度 */
@property (nonatomic, assign) NSInteger cellRowIndex;

@end


@implementation SABubblePopView

#pragma mark-
#pragma mark- View Life Cycle

- (instancetype)initWithFrame:(CGRect)frame{

    if (self = [super initWithFrame:frame]) {
         [self addInitMethods];
    }
    return self;
}

- (instancetype)initWithTrianglePoint:(CGPoint)point {
    
    self.trianglePoint = point;
    
    [self addInitMethods];
    return self;
}

/** 根据三角的方向和类型进行页面上的布局 */
- (void)layoutSubviews{
    [super layoutSubviews];
         switch (self.triangleDicrection) {
             case SATriangleDicrectionUp:
        
              self.frame = CGRectMake(self.trianglePoint.x - self.triangleSeatScale*self.frame.size.width, self.trianglePoint.y, self.frame.size.width, self.frame.size.height);
        
              self.realView.frame = CGRectMake(self.realView.frame.origin.x, self.realView.frame.origin.y+self.triangleSide*2*cos(M_PI/3), self.realView.frame.size.width, self.realView.frame.size.height-self.triangleSide*2*cos(M_PI/3));
             break;
                 
             case SATriangleDicrectionLeft:
        
               self.frame = CGRectMake(self.trianglePoint.x, self.trianglePoint.y-self.triangleSeatScale*self.frame.size.height, self.frame.size.width, self.frame.size.height);
        
               self.realView.frame = CGRectMake(self.realView.frame.origin.x+self.triangleSide*2*cos(M_PI/3), self.realView.frame.origin.y, self.realView.frame.size.width-self.triangleSide*2*cos(M_PI/3), self.realView.frame.size.height);
              break;
                 
             case SATriangleDicrectionDown:
        
               self.frame = CGRectMake(self.trianglePoint.x - self.triangleSeatScale*self.frame.size.width, self.trianglePoint.y-self.frame.size.height, self.frame.size.width, self.frame.size.height);
        
               self.realView.frame = CGRectMake(self.realView.frame.origin.x, self.realView.frame.origin.y, self.realView.frame.size.width, self.realView.frame.size.height-self.triangleSide*2*cos(M_PI/3));
             break;
          case SATriangleDicrectionRight:
        
             self.frame = CGRectMake(self.trianglePoint.x-self.frame.size.width, self.trianglePoint.y-self.triangleSeatScale*self.frame.size.height, self.frame.size.width, self.frame.size.height);
        
             self.realView.frame = CGRectMake(0, 0, self.realView.frame.size.width-self.triangleSide*2*cos(M_PI/3) , self.realView.frame.size.height);
        
         break;
         default:
            return;
          }

    switch (self.bubbleViewType) {
        case SABubbleTypeNormal:{
            //先算宽度是否大于180,大于就使用多行显示,少于就单行显示
            CGRect rect = self.frame;
            CGSize textSize = [self.label.text boundingRectWithSize:CGSizeMake(MAXFLOAT, 20.3) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]}context:nil].size;
            if (self.triangleDicrection == SATriangleDicrectionDown ||
                self.triangleDicrection == SATriangleDicrectionUp) {
                if (textSize.width > 180) {
                    rect.size.width = 180;
                    CGSize titleSize = [self.label.text boundingRectWithSize:CGSizeMake(154, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]} context:nil].size;
                    rect.size.height = titleSize.height + 2 * kTopDownSpace + self.triangleSide*2*cos(M_PI/3);
                    self.frame = rect;
                    self.label.frame = CGRectMake(kLeftRightSpace, kTopDownSpace, titleSize.width , titleSize.height);
                }else{
                    rect.size.width = textSize.width + 2*kLeftRightSpace;
                    rect.size.height = textSize.height + self.triangleSide*2*cos(M_PI/3) + 2*kTopDownSpace;
                    self.frame = rect;
                    self.label.frame = CGRectMake(kLeftRightSpace, kTopDownSpace, textSize.width , textSize.height);
                }
            }else{
                if (textSize.width > 180) {
                    rect.size.width = 180;
                    CGSize titleSize = [self.label.text boundingRectWithSize:CGSizeMake(144, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]} context:nil].size;
                    rect.size.height = titleSize.height + 2*kTopDownSpace;
                    self.frame = rect;
                    self.label.frame = CGRectMake(kLeftRightSpace, kTopDownSpace, self.frame.size.width - 26 - self.triangleSide*2*cos(M_PI/3) , titleSize.height);
                }else{
                    rect.size.width = textSize.width + 2*kLeftRightSpace;
                    rect.size.height = textSize.height + 2* kTopDownSpace ;
                    self.frame = rect;
                    self.label.frame = CGRectMake(kLeftRightSpace, kTopDownSpace, textSize.width , textSize.height);
                }
            }
        }
            break;
        case SABubbleTypeButton: {
            
            CGRect rect = self.frame;
            
            if (self.triangleDicrection == SATriangleDicrectionDown ||
                self.triangleDicrection == SATriangleDicrectionUp) {
                 CGSize textSize = [self.label.text boundingRectWithSize:CGSizeMake(MAXFLOAT, 20.3) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]} context:nil].size;
                if (textSize.width > 180) {
                    CGSize titleSize = [self.label.text boundingRectWithSize:CGSizeMake(154, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]} context:nil].size;
                    rect.size.width = 180;
                    rect.size.height = titleSize.height + self.triangleSide*2*cos(M_PI/3) + 35 + 2*kTopDownSpace;
                    self.frame = rect;
                    self.label.frame = CGRectMake(kLeftRightSpace, kTopDownSpace, titleSize.width , titleSize.height);
                    self.lineView.frame = CGRectMake(0, titleSize.height + 2*kTopDownSpace, self.frame.size.width, 1);
                    self.sureButton.frame = CGRectMake(0, titleSize.height + 2*kTopDownSpace + 2, self.frame.size.width , 35);
  
                }else{
                    rect.size.width = textSize.width + 2*kLeftRightSpace  + self.triangleSide *2*cos(M_PI/3);
                    rect.size.height = textSize.height  + 2*kTopDownSpace + 35;
                    self.frame = rect;
                    self.label.frame = CGRectMake(kLeftRightSpace, kTopDownSpace, textSize.width , textSize.height);
                    self.lineView.frame = CGRectMake(0, textSize.height + 2*kTopDownSpace , self.frame.size.width, 1);
                    self.sureButton.frame = CGRectMake(0, textSize.height + 2 + 2*kTopDownSpace, self.frame.size.width , 35);
                }
            }else{
                
                CGSize textSize = [self.label.text boundingRectWithSize:CGSizeMake(MAXFLOAT, 20.3) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]} context:nil].size;
                _sureButton.titleEdgeInsets = UIEdgeInsetsMake(-2, -10, 0, 0);
                if (textSize.width > 180) {
                    CGSize titleSize = [self.label.text boundingRectWithSize:CGSizeMake(144, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]} context:nil].size;
                    rect.size.width = 180;
                    rect.size.height = titleSize.height + 35 + 2*kTopDownSpace;
                    self.frame = rect;
                    self.label.frame = CGRectMake(kLeftRightSpace, kTopDownSpace, self.frame.size.width - 2*kLeftRightSpace - self.triangleSide*2*cos(M_PI/3) , titleSize.height);
                    self.lineView.frame = CGRectMake(0, titleSize.height + 2*kTopDownSpace , self.frame.size.width, 1);
                    self.sureButton.frame = CGRectMake(0, titleSize.height + 2 +2*kTopDownSpace, self.frame.size.width , 35);
                }else{
                    rect.size.width = textSize.width + 2*kLeftRightSpace + self.triangleSide *2*cos(M_PI/3);
                    rect.size.height = textSize.height + 2*kTopDownSpace + 35;
                    self.frame = rect;
                    self.label.frame = CGRectMake(kLeftRightSpace, kTopDownSpace, textSize.width , textSize.height);
                    self.lineView.frame = CGRectMake(0, textSize.height + 2*kTopDownSpace , self.frame.size.width, 1);
                    self.sureButton.frame = CGRectMake(0, textSize.height + 2 + 2*kTopDownSpace, self.frame.size.width , 35);
                }

            }
            
        }
            break;
        case SABubbleTypeView:
        {
            CGRect rect = self.frame;
              rect.size.width = 120;
            if (self.triangleDicrection == SATriangleDicrectionDown ||
                self.triangleDicrection == SATriangleDicrectionUp) {
            
                rect.size.height = self.cellRowIndex * self.tabelView.rowHeight + 10;
                self.frame = rect;
                self.tabelView.frame = CGRectMake(0, 0, self.frame.size.width  , self.frame.size.height );
            }else{
                
                rect.size.height = self.cellRowIndex * self.tabelView.rowHeight;
                self.frame = rect;
                self.tabelView.frame = CGRectMake(0, 0, self.frame.size.width  , self.frame.size.height );
            }
            
            
        }
            break;
            
        default:
            break;
    }
    
}
/** 根据三角方向绘制三角 */
#pragma mark - drawRect
- (void)drawRect:(CGRect)rect {
    
    // 设置背景色
    [self.realView.backgroundColor set];
    //拿到当前视图准备好的画板
    
    CGContextRef  context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    //利用path进行绘制三角形
    CGContextBeginPath(context);//标记
    
    CGPoint startPoint;
    CGPoint middlePoint;
    CGPoint endPoint;
    
    
    switch (self.triangleDicrection) {
        case SATriangleDicrectionUp:
        
            startPoint  = CGPointMake(self.triangleSeatScale*self.frame.size.width-self.triangleSide, self.triangleSide*2*cos(M_PI/3));
            middlePoint = CGPointMake(self.triangleSeatScale*self.frame.size.width,0);
            endPoint    = CGPointMake(self.triangleSeatScale*self.frame.size.width+self.triangleSide,self.triangleSide*2*cos(M_PI/3));
            
            break;
        case SATriangleDicrectionLeft:
            
            startPoint  = CGPointMake(self.triangleSide*2*cos(M_PI/3), self.triangleSeatScale*self.frame.size.height-self.triangleSide);
            middlePoint = CGPointMake(self.triangleSide*2*cos(M_PI/3), self.triangleSeatScale*self.frame.size.height+self.triangleSide);
            endPoint    = CGPointMake(0,self.triangleSeatScale*self.frame.size.height);
            
            break;
        case SATriangleDicrectionDown:
         
            
            startPoint  = CGPointMake(self.triangleSeatScale*self.frame.size.width-self.triangleSide,self.frame.size.height-self.triangleSide*2*cos(M_PI/3));
            middlePoint = CGPointMake(self.triangleSeatScale*self.frame.size.width, self.frame.size.height);
            endPoint    = CGPointMake(self.triangleSeatScale*self.frame.size.width+self.triangleSide, self.frame.size.height-self.triangleSide*2*cos(M_PI/3));
            
            break;
        case SATriangleDicrectionRight:
            startPoint  = CGPointMake(self.frame.size.width-self.triangleSide*2*cos(M_PI/3), self.triangleSeatScale*self.frame.size.height-self.triangleSide);
            middlePoint = CGPointMake(self.frame.size.width, self.triangleSeatScale*self.frame.size.height);
            endPoint    = CGPointMake(self.frame.size.width-self.triangleSide*2*cos(M_PI/3),self.triangleSeatScale*self.frame.size.height+self.triangleSide);
            
            break;
        default:
            return;
    }
    
    CGContextMoveToPoint(context, startPoint. x, startPoint. y);
    CGContextAddLineToPoint(context, middlePoint. x, middlePoint. y);
    CGContextAddLineToPoint(context, endPoint. x, endPoint. y);
    CGContextSetRGBStrokeColor(context, 9/255.0, 113/255.0, 206/255.0, 1.0);
    CGContextDrawPath(context, kCGPathFillStroke);
    CGContextClosePath(context);

}


#pragma mark-
#pragma mark - UIGestureRecognizerDelegate
/** 解决gestureRecognizerTap点击手势和tableView cell点击手势的冲突 */
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {
        return NO;
    }
    return YES;
}

#pragma mark-
#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    self.cellRowIndex = [self.delegate  saBubblePopTypeView:self numberOfCellInSection:section];
    
     return [self.delegate  saBubblePopTypeView:self numberOfCellInSection:section];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
 
    cell.textLabel.font = [UIFont systemFontOfSize:17];
    cell.textLabel.textColor = [UIColor whiteColor];
    
    cell.textLabel.text = [self.delegate saBubblePopTypeView:self textAtIndexPath:indexPath];
    
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    
    if([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]){
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [self.delegate saBubblePopTypeViewComplteAction:self selectIndex:indexPath];
    [self dismiss];
}



#pragma mark-
#pragma mark- Event response

- (void)addInitMethods {
    self.backgroundColor = [UIColor clearColor];
    [self setDefault];
    [self addSubview:self.realView];
    self.cellRowIndex = 0;
    [self.realView addSubview:self.label];
    self.lineView = [[UIView alloc]init];
    self.lineView.backgroundColor = [UIColor redColor];
    self.lineView.alpha = 0.2;
    [self.realView addSubview:self.lineView];
    [self.realView addSubview:self.sureButton];
    [self.realView addSubview:self.tabelView];
    
    
}

- (void)setDefault {
    
    self.cornerRadius = 5.f;
    self.triangleSide = 10.f;
    self.triangleSeatScale = 0.5f;
    self.triangleDicrection = SATriangleDicrectionUp;
    self.bubbleViewType = SABubbleTypeButton;
    self.trianglePoint = CGPointMake(self.frame.origin.x+self.frame.size.width/2.0, self.frame.origin.y);
    self.popupBackgroundColor = [UIColor blueColor];
    self.dismissWhenClickMaskView = YES;
    self.haveMaskView = YES;
    self.maskAlpha = 0.3;
}

- (void)pressSureButtonAction:(UIButton *)sender{

    [self dismiss];
}

- (void)pressMaskViewAction{
    if (!self.dismissWhenClickMaskView) {
        return;
    }
    [self dismiss];
}


- (void)show:(UIView *)maskSuperView{
    if (!self.haveMaskView) {
        [maskSuperView addSubview:self];
        return;
    }
    
    self.maskView.frame = maskSuperView.bounds;
    [maskSuperView addSubview:self.maskView];
    [UIView animateWithDuration:0.3f animations:^{
        self.maskView.backgroundColor = [UIColor colorWithWhite:0 alpha:self.maskAlpha];
    }];
    
    [self.maskView addSubview:self];
    
}

- (void)dismiss{
    [self removeFromSuperview];
    [UIView animateWithDuration:0.3f animations:^{
        self.maskView.backgroundColor = [UIColor clearColor];
    } completion:^(BOOL finished) {
        [self.maskView removeFromSuperview];
    }];
}

#pragma mark-
#pragma mark- Private Methods


#pragma mark-
#pragma mark- Getters && Setters

- (UILabel *)label{
    if (!_label) {
        _label = [[UILabel alloc] init];
        _label.font = [UIFont systemFontOfSize:17];
        _label.textAlignment = NSTextAlignmentLeft;
        _label.numberOfLines = 0;
        _label.textColor = [UIColor whiteColor];
    }
    return _label;
}

- (UIButton *)sureButton{
    if (!_sureButton) {
        _sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_sureButton setTitle:@"我知道了" forState:UIControlStateNormal];
        _sureButton.titleLabel.font = [UIFont systemFontOfSize:17];
        _sureButton.titleLabel.textColor = [UIColor whiteColor];
        _sureButton.titleLabel.alpha = 0.6;
        [_sureButton addTarget:self action:@selector(pressSureButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sureButton;
}

- (UITableView *)tabelView{
    if (!_tabelView) {
        _tabelView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tabelView.backgroundColor = [UIColor clearColor];
        _tabelView.rowHeight = 44;
        _tabelView.dataSource = self;
        _tabelView.scrollEnabled = NO;
        _tabelView.delegate = self;
        _tabelView.tableFooterView = [[UIView alloc]init];
        [_tabelView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    }
    return _tabelView;
}

- (UIView *)realView{
    if (!_realView) {
        _realView = [[UIView alloc]init];
        _realView.clipsToBounds = YES;
    }
    _realView.layer.cornerRadius = self.cornerRadius;
    _realView.backgroundColor = [UIColor blueColor];
    _realView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    return _realView;
}

- (UIView *)maskView{
    if (!_maskView) {
        _maskView = [[UIView alloc]init];
        _maskView.backgroundColor = [UIColor clearColor];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(pressMaskViewAction)];
        [_maskView addGestureRecognizer:tap];
        _maskView.userInteractionEnabled = YES;
        tap.delegate = self;
    }
    return _maskView;
}



#pragma mark-
#pragma mark-

@end

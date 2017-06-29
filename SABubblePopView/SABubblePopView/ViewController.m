//
//  ViewController.m
//  SABubblePopView
//
//  Created by 李磊 on 29/6/17.
//  Copyright © 2017年 李磊. All rights reserved.
//

#import "ViewController.h"
#import "SABubblePopView.h"


@interface ViewController () <SABubbleTypeViewProtocol>

@property (nonatomic,strong) SABubblePopView *popupView;
@property (nonatomic,strong) SABubblePopView *popupView2;
@property (nonatomic,strong) SABubblePopView *popupView3;

/** 暂定数据源 */
@property (nonatomic, strong) NSMutableArray *dataSourceArray;

@end

@implementation ViewController

#pragma mark-
#pragma mark- View Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.dataSourceArray =  [NSMutableArray arrayWithObjects:@"选项0",@"选项1",@"选项2",@"选项3", nil];
    
    UIButton *button = [UIButton buttonWithType:(UIButtonTypeSystem)];
    button.frame = CGRectMake(10, 120, 100, 44.f);
    [button setTitle:@"显示弹出框1" forState:(UIControlStateNormal)];
    [button setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    button.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:button];
    [button addTarget:self action:@selector(buttonAAction:) forControlEvents:(UIControlEventTouchUpInside)];
    
    
    
    
    UIButton *button2 = [UIButton buttonWithType:(UIButtonTypeSystem)];
    button2.frame = CGRectMake(60, 250, 100, 44.f);
    [button2 setTitle:@"显示弹出框2" forState:(UIControlStateNormal)];
    [button2 setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    button2.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:button2];
    [button2 addTarget:self action:@selector(button2Action:) forControlEvents:(UIControlEventTouchUpInside)];
    
    
    UIButton *button3 = [UIButton buttonWithType:(UIButtonTypeSystem)];
    button3.frame = CGRectMake(60, self.view.frame.size.height - 230, 100, 44.f);
    [button3 setTitle:@"显示弹出框3" forState:(UIControlStateNormal)];
    [button3 setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    button3.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:button3];
    [button3 addTarget:self action:@selector(button3Action:) forControlEvents:(UIControlEventTouchUpInside)];
}

#pragma mark-
#pragma mark- Request


#pragma mark-
#pragma mark- SABubbleTypeViewProtocol

/** cell的行数 */
- (NSInteger)saBubblePopTypeView:(SABubblePopView *)saBubblePopView numberOfCellInSection:(NSInteger)section{
    return self.dataSourceArray.count;
}

/** 给cell上赋值代理 */
- (NSString *)saBubblePopTypeView:(SABubblePopView *)saBubblePopView textAtIndexPath:(NSIndexPath *)indexPath{
    return self.dataSourceArray[indexPath.row];
}

/** 选择了之后,返回代理 */
- (void)saBubblePopTypeViewComplteAction:(SABubblePopView *)saBubblePopView selectIndex:(NSIndexPath *)indexPath{
    NSLog(@"给外界返回的是---%ld",(long)indexPath.row);
}

#pragma mark-
#pragma mark- SACardViewDataSource

#pragma mark-
#pragma mark- 代理类名 delegate

#pragma mark-
#pragma mark- Event response

- (void)buttonAAction:(UIButton *)button {
    
    
    self.popupView.trianglePoint = CGPointMake(button.frame.origin.x+ button.frame.size.width/2.0, button.frame.origin.y+button.frame.size.height);
    self.popupView.bubbleViewType = SABubbleTypeView;
    self.popupView.delegate = self;
    self.popupView.triangleSeatScale = 0.5;
    [self.popupView show:self.view];
}

- (void)button2Action:(UIButton *)button {
    
    
    
    self.popupView2.label.text = @"家基督家的萨德家阿爱的萨德家阿爱的萨德";
    self.popupView2.trianglePoint = CGPointMake(button.frame.origin.x +button.frame.size.width / 2.0 , button.frame.origin.y + button.frame.size.height);
    self.popupView2.triangleSeatScale = 0.5;
    self.popupView2.bubbleViewType = SABubbleTypeNormal;
    self.popupView2.triangleDicrection = SATriangleDicrectionUp;
    
    [self.popupView2 show:self.view];
}

- (void)button3Action:(UIButton*)button{
    
    
    self.popupView3.label.text = @"家阿爱家阿爱家爱家阿爱家阿爱家阿爱";
    self.popupView3.trianglePoint = CGPointMake(button.frame.origin.x+button.frame.size.width, button.frame.origin.y + button.frame.size.height / 2.0);
    self.popupView3.triangleSeatScale = 0.5;
    self.popupView3.triangleDicrection = SATriangleDicrectionLeft;
    self.popupView3.bubbleViewType = SABubbleTypeButton;
    [self.popupView3 show:self.view];
}



- (SABubblePopView *)popupView {
    if (!_popupView) {
        _popupView = [[SABubblePopView alloc] init];
    }
    return _popupView;
}

- (SABubblePopView *)popupView2 {
    if (!_popupView2) {
        _popupView2 = [[SABubblePopView alloc] init];
    }
    return _popupView2;
}


- (SABubblePopView *)popupView3 {
    if (!_popupView3) {
        _popupView3 = [[SABubblePopView alloc] init];
    }
    return _popupView3;
}


@end

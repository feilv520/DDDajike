//
//  PayPopView.m
//  kyboard_pay
//
//  Created by swb on 15/6/11.
//  Copyright (c) 2015年 swb. All rights reserved.
//

#import "PayPopView.h"
#import "PayKeyBoardView.h"
#import "defines.h"
#import "MyClickLb.h"

#define tf_width ((_popView.frame.size.width-20)/6)
#define tf_heighth tf_width

@implementation PayPopView
{
    UIView  *_popView;
    int btnTag ;
    
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self layoutPayView];
        btnTag = 5;
    }
    return self;
}

- (void)layoutPayView
{
    //充当半透明背景
    UIView *viewBg          =   [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH_CONTROLLER_DEFAULT, HEIGHT_CONTROLLER_DEFAULT)];
    viewBg.backgroundColor  =   [UIColor blackColor];
    viewBg.alpha            =   0.5f;

    [self addSubview:viewBg];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick:)];
    [viewBg addGestureRecognizer:tap];
    
    
    
    //支付输入框的弹出框
    _popView                =   [[UIView alloc]initWithFrame:CGRectMake(20, 500, WIDTH_CONTROLLER_DEFAULT-40, 200)];
    _popView.backgroundColor=   [UIColor whiteColor];
    
    [self addSubview:_popView];
    
    
    //标题
    UILabel *lb             =   [[UILabel alloc]initWithFrame:CGRectMake(0, 5, _popView.frame.size.width, 30)];
    lb.text                 =   @"请输入大集客支付密码";
    lb.textAlignment        =   NSTextAlignmentCenter;
    [_popView addSubview:lb];
    
    UIView *lineV1 = [[UIView alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(lb.frame), CGRectGetWidth(_popView.frame)-20, 0.5)];
    lineV1.backgroundColor = Color_line_bg;
    [_popView addSubview:lineV1];
    
    
    
    
    //支付金额
    self.jineLb             =   [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(lb.frame)+10, CGRectGetWidth(lb.frame), 30)];
    self.jineLb.text                =   @"¥300元";
    self.jineLb.textAlignment       =   NSTextAlignmentCenter;
    self.jineLb.textColor           =   Color_mainColor;
    self.jineLb.font                =   [UIFont systemFontOfSize:30.0f];
    [_popView addSubview:self.jineLb];
    
//    UIView *lineV22 = [[UIView alloc]initWithFrame:CGRectMake(10, 100, CGRectGetWidth(_popView.frame)-20, 0.5)];
//    lineV1.backgroundColor = [UIColor redColor];
//    [_popView addSubview:lineV22];
    
    
    //支付密码输入框
    UIView *vv              =   [[UIView alloc]initWithFrame:CGRectMake(5, CGRectGetMaxY(self.jineLb.frame)+15, tf_width*6+3.5, tf_heighth+1)];
    vv.backgroundColor      =   Color_line_bg;
    [_popView addSubview:vv];
    
    
    
    
    //忘记密码Lb
    _mimaLb = [[MyClickLb alloc]initWithFrame:CGRectMake(CGRectGetMaxX(vv.frame)-80, CGRectGetMaxY(vv.frame)+5, 80, 30)];
    _mimaLb.text = @"忘记密码";
    _mimaLb.font = [UIFont systemFontOfSize:16.0f];
    _mimaLb.textColor = Color_mainColor;
    _mimaLb.textAlignment = NSTextAlignmentRight;
    [_popView addSubview:_mimaLb];
    
    
    
    
    //创建输入小方框
    for (int i=0; i<6; i++) {
        
        UITextField *tf = [[UITextField alloc]initWithFrame:CGRectMake(0.5*(i+1)+tf_width*i, 0.5, tf_width, tf_heighth)];
        tf.backgroundColor = [UIColor whiteColor];
        tf.enabled = NO;
        tf.tag = i+5;
        tf.secureTextEntry = YES;
        tf.textAlignment = NSTextAlignmentCenter;
        if (i == 0) {
            [tf becomeFirstResponder];
        }
        
        [vv addSubview:tf];
    }
    
    PayKeyBoardView *keyBV = [[PayKeyBoardView alloc]init];
    keyBV.frame = CGRectMake(0, HEIGHT_CONTROLLER_DEFAULT, WIDTH_CONTROLLER_DEFAULT, (WIDTH_CONTROLLER_DEFAULT-1)/3/2*4+1.5);
    [UIView animateWithDuration:0.5f animations:^{
        [keyBV setFrame:CGRectMake(0, self.frame.size.height-(WIDTH_CONTROLLER_DEFAULT-1)/3/2*4+1.5-64, WIDTH_CONTROLLER_DEFAULT, (WIDTH_CONTROLLER_DEFAULT-1)/3/2*4+1.5)];
    } completion:^(BOOL finished) {
        
    }];
    
    [UIView animateWithDuration:0.3f animations:^{
        [_popView setFrame:CGRectMake(20, CGRectGetMinY(keyBV.frame)-180, WIDTH_CONTROLLER_DEFAULT-40, CGRectGetHeight(lb.frame)+CGRectGetHeight(self.jineLb.frame)+CGRectGetHeight(vv.frame)+CGRectGetHeight(_mimaLb.frame)+35)];
    } completion:^(BOOL finished) {
        
    }];
    
    
    
    [keyBV callBackNumClicked:^(NSString *num) {
        
        
        if ([num isEqualToString:@""]) {
            NSLog(@"呵呵呵呵呵呵呵呵呵恶化😄");
        }else if ([num isEqualToString:@"回格"]) {
            NSLog(@"回个回个回个回个");
            if (btnTag == 5) {
                return;
            }
            UITextField *tf1 = (UITextField *)[self viewWithTag:btnTag-1];
            tf1.text = @"";
            btnTag--;
        }else {
            if (btnTag > 10) {
                return;
            }
            UITextField *tf = (UITextField *)[self viewWithTag:btnTag];
            tf.text = num;
            
            if (btnTag == 10) {
                NSLog(@"支付成功了");
                NSMutableString *passStr = nil;
                for (int i=5; i<=10; i++) {
                    UITextField *ff = (UITextField *)[self viewWithTag:i];
                    if (i==5) {
                        passStr = [ff.text mutableCopy];
                    }else
                        [passStr appendFormat:@"%@",ff.text];
                }
                self.block(1,passStr);
                
            }
            btnTag++;
        }
        
    }];
    [self addSubview:keyBV];
    
    //角标小叉号
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_popView.frame)-60, 0, 40, 40)];
    [btn setImage:[UIImage imageNamed:@"chacha"] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"img_cha"] forState:UIControlStateHighlighted];
    [btn setImageEdgeInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
    [btn addTarget:self action:@selector(chaBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_popView addSubview:btn];
}

- (void)chaBtnClicked:(UIButton *)btn
{
    self.block(0,nil);
}

- (void)tapClick:(UITapGestureRecognizer *)tap
{
    self.block(0,nil);
}

- (void)callbackHidden:(HiddenPayViewBlock)block
{
    self.block = [block copy];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

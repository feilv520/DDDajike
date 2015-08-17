//
//  SelectCityView.m
//  jibaobao
//
//  Created by dajike on 15/5/18.
//  Copyright (c) 2015年 dajike. All rights reserved.
//

#import "SelectCityView.h"
#import "defines.h"
#import "UIView+MyView.h"

@interface SelectCityView()
{
    NSMutableArray *cityArr;
}
@property (retain, nonatomic) UIScrollView *scrollVIew;
@property (retain, nonatomic) UILabel *cityNameKabel;
@end
@implementation SelectCityView
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = Color_gray1;
        
        self.scrollVIew = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, WIDTH_CONTROLLER_DEFAULT, 160)];
        self.scrollVIew.backgroundColor = Color_gray1;
        [self.scrollVIew setScrollEnabled:YES];
        [self addSubview:self.scrollVIew];
        
        self.cityNameKabel = [[UILabel alloc]
                              creatLabelWithFrame:CGRectMake(10, 160+10, WIDTH_CONTROLLER_DEFAULT-20, 30) AndFont:14 AndBackgroundColor:Color_White AndText:@"上海" AndTextAlignment:NSTextAlignmentLeft AndTextColor:Color_Black andCornerRadius:2.0];
        [self addSubview:self.cityNameKabel];
        
        UIButton *btn = [[UIButton alloc]createButtonWithFrame:CGRectMake(WIDTH_CONTROLLER_DEFAULT-20-50-20-10, 5+170, 70, 20) andBackImageName:nil andTarget:self andAction:@selector(toBtn:) andTitle:@"切换城市" andTag:0];

        [btn setTitleColor:Color_mainColor forState:UIControlStateNormal];
        [self addSubview:btn];
        
        UIImageView *imageVIew = [[UIImageView alloc]createImageViewWithFrame:CGRectMake(WIDTH_CONTROLLER_DEFAULT-20-10, 10, 10, 10) andImageName:@"img_arrow_03_right"];
        [self.cityNameKabel addSubview:imageVIew];
        self.selectCityTag = 0;
        [FileOperation getAllPlaces:^(BOOL finish) {
            
        }];
    }
    
    return self;
}

- (void) addSubViewsWithCity:(NSString *)cityname
{
    for (UIView *v in self.scrollVIew.subviews) {
        [v removeFromSuperview];
    }
    NSDictionary *dic;
    if ([FileOperation getCurrentCityId] != nil) {
        cityArr = [NSMutableArray arrayWithArray:[FileOperation getobjectForKey:kCurrentCityArr ofFilePath:[FileOperation creatPlistIfNotExist:SET_PLIST]]];
        //当前城市所有的区县
        NSInteger count = cityArr.count;
        for (int i = 0; i < count; i ++) {
            UIButton *btn = [[UIButton alloc]createButtonWithFrame:CGRectMake(10+(i%3)*96+(i%3)*6, 8+(i/3)*38, 96, 30) andBackImageName:nil andTarget:self andAction:@selector(toselectQuXian:) andTitle:((i == 0)?@"全城":[[cityArr objectAtIndex:i] objectForKey:@"regionName"]) andTag:200+i];
            
            btn.backgroundColor = Color_White;
            if (i == self.selectCityTag) {
                btn.layer.borderColor = [Color_mainColor CGColor];
                btn.layer.borderWidth = 0.5;
                [btn setTitleColor:Color_mainColor forState:UIControlStateNormal];
            }else{
                btn.layer.borderColor = [Color_White CGColor];
                btn.layer.borderWidth = 0.5;
                [btn setTitleColor:Color_Black forState:UIControlStateNormal];
            }
            
            [self.scrollVIew addSubview:btn];
        }
        
        if (count > 12) {
            [self.scrollVIew setContentSize:CGSizeMake(WIDTH_CONTROLLER_DEFAULT, (count/3+1)*38+8)];
        }

        
    }else{
        
        dic = @{@"latitude":@"",@"longitude":@""};
        //获取定位城市  和对应区县
        [[MyAfHTTPClient sharedClient] postPathWithMethod:@"Regions.locationCity" parameters:dic ifAddActivityIndicator:NO success:^(AFHTTPRequestOperation *operation, PostData *responseObject) {
            if (responseObject.succeed) {
                NSLog(@"responseObject.result = %@",responseObject.result);
                cityArr = [[NSMutableArray alloc]init];
                NSDictionary *cityDic = @{@"regionName":@"全城",@"regionId":[responseObject.result objectForKey:@"regionId"]};
                [cityArr addObject:cityDic];
                for (NSArray *arr in [responseObject.result objectForKey:@"subRegions"]) {
                    NSDictionary *dic = @{@"regionName":[arr objectAtIndex:1],@"regionId":[arr objectAtIndex:0]};
                    [cityArr addObject:dic];
                }
                
                [FileOperation setPlistObject:cityArr forKey:kCurrentCityArr ofFilePath:[FileOperation creatPlistIfNotExist:SET_PLIST]];
                //存储定位城市信息
                 [FileOperation writeDingweiCityWithCityName:[responseObject.result objectForKey:@"regionName"] andCityId:[NSString stringWithFormat:@"%@",[responseObject.result objectForKey:@"regionId"]]];
                //写进最近城市列表
                [FileOperation writeCurrentCityWithCityName:[responseObject.result objectForKey:@"regionName"] andCityId:[NSString stringWithFormat:@"%@",[responseObject.result objectForKey:@"regionId"]]];
                
                //当前城市所有的区县
                NSInteger count = cityArr.count;
                for (int i = 0; i < count; i ++) {
                    UIButton *btn = [[UIButton alloc]createButtonWithFrame:CGRectMake(10+(i%3)*96+(i%3)*6, 8+(i/3)*38, 96, 30) andBackImageName:nil andTarget:self andAction:@selector(toselectQuXian:) andTitle:[[cityArr objectAtIndex:i] objectAtIndex:1] andTag:200+i];
                    
                    btn.backgroundColor = Color_White;
                    if (i == 0) {
                        btn.layer.borderColor = [Color_mainColor CGColor];
                        btn.layer.borderWidth = 0.5;
                        [btn setTitleColor:Color_mainColor forState:UIControlStateNormal];
                    }else{
                        btn.layer.borderColor = [Color_White CGColor];
                        btn.layer.borderWidth = 0.5;
                        [btn setTitleColor:Color_Black forState:UIControlStateNormal];
                    }
                    
                    [self.scrollVIew addSubview:btn];
                }
                
                if (count > 12) {
                    [self.scrollVIew setContentSize:CGSizeMake(WIDTH_CONTROLLER_DEFAULT, (count/3+1)*38+8)];
                }
                
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"error = %@",error);
        }];
        

    }
        self.cityNameKabel.text = cityname;
    
    
   
}

- (void) toBtn:(id) sender
{
    if (self.myDelegate) {
        [self.myDelegate  changeCity];
    }
}

- (void) toselectQuXian:(id) sender
{
    UIButton *btn = (UIButton*) sender;
    NSInteger count = cityArr.count;
    for (int i = 0; i < count; i ++) {
        UIButton *button = (UIButton *)[self viewWithTag:i+200];
        button.layer.borderColor = [Color_White CGColor];
        button.layer.borderWidth = 0.5;
        [button setTitleColor:Color_Black forState:UIControlStateNormal];
    }
   
    btn.layer.borderColor = [Color_mainColor CGColor];
    btn.layer.borderWidth = 0.5;
    [btn setTitleColor:Color_mainColor forState:UIControlStateNormal];
    self.selectCityTag = btn.tag-200;
    if (self.myDelegate) {
        [self.myDelegate selectView:self selectedIndex:btn.tag-200];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

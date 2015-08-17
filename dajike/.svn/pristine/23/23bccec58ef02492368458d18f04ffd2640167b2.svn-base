//
//  BunessList1Cell.m
//  jibaobao
//
//  Created by dajike on 15/5/4.
//  Copyright (c) 2015年 dajike. All rights reserved.
//

#import "BunessList1Cell.h"
#import "UIImageView+WebCache.h"
#import "CommentStarView.h"
#import "defines.h"
@implementation BunessList1Cell


- (void)config:(BunessList1Model *)model
{
    
    self.titleLabel.text = model.store_name;//店面
    self.title1LAbel.hidden = YES;
    CommentStarView *tmpView = [[CommentStarView alloc]init];
    tmpView.frame = CGRectMake(80, 30, 110, 20);
    [tmpView layoutCommentStar:[NSString stringWithFormat:@"%@",model.avgxingji]];
    [self.contentView addSubview:tmpView];
    if ([model.avgxingji isEqualToString:@"<null>"]) {
        self.fenLabel.text = @"0分";//评星
    }else{
        self.fenLabel.text = [NSString stringWithFormat:@"%@分",model.avgxingji];//评星
    }
    
    self.commentLabel.text = [NSString stringWithFormat:@"%@人评价",model.commentCount];//;//评价个数；
    
    self.placeLabel.text = model.address;//归属地
    if ([model.distance intValue] < 500) {
        self.distenceLabel.text = @"<500m";//距离
    }else if ([model.distance intValue] < 1000){
        self.distenceLabel.text = @"<1km";
    }else if ([model.distance intValue] < 2000){
        self.distenceLabel.text = @"<2km";
    }else if ([model.distance intValue] < 5000){
        self.distenceLabel.text = @"<5km";
    }else if ([model.distance intValue] < 10000){
        self.distenceLabel.text = @"<10km";
    }else{
        self.distenceLabel.text = @">10km";
    }
    if ([model.tag isEqualToString:@"<null>"]||
        [model.tag isEqualToString:@""]) {
        self.title1LAbel.text = @"0元";
    }else{
        self.title1LAbel.text = [NSString stringWithFormat:@"%@元",model.tag];
    }
    if ([model.couponNum intValue]==0) {
        self.quanImageView.hidden = YES;
    }
    [self.headImageView setImageWithURL:[commonTools getImgURL:model.store_logo] placeholderImage:PlaceholderImage];
}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(ShopListModel *)model
{
    NSLog(@"%@--%@",[commonTools getImgURL:model.store_logo],model.store_logo);
    if ([model.store_logo isEqualToString:@"<null>"]) {
        self.headImageView.image = PlaceholderImage;
    }else
        [self.headImageView setImageWithURL:[commonTools getImgURL:model.store_logo] placeholderImage:PlaceholderImage];
    self.titleLabel.text    = model.store_name;
    
    if ([model.couponCounts intValue] == 0) {
        [self.quanImageView setHidden:YES];
    }else
        [self.quanImageView setHidden:NO];
    
    CGRect rect1 = [self contentAdaptionLabel:model.store_name withSize:CGSizeMake(WIDTH_CONTROLLER_DEFAULT-180, 26) withTextFont:16.0f];
    self.nameWidthCon.constant = rect1.size.width+5;
    self.quanImageView.frame = CGRectMake(CGRectGetMaxX(self.titleLabel.frame)+2, 9, 20, 17);
    
    CommentStarView *tmpView = [[CommentStarView alloc]init];
    tmpView.frame = CGRectMake(75, 28,110, 20);
    [tmpView layoutCommentStar:[NSString stringWithFormat:@"%@",model.avgxingji]];
    [self.contentView addSubview:tmpView];
    
    self.fenLabel.text = [NSString stringWithFormat:@"%.1f分",[model.avgxingji floatValue]];//评星
    
    self.commentLabel.hidden = YES;
    
//    self.distenceLabel.text = [NSString stringWithFormat:@"<%.1f米",[model.distance floatValue]];
    self.title1LAbel.text   = [NSString stringWithFormat:@"%d人评价",[model.commentCount intValue]];
    CGRect rect2 = [self contentAdaptionLabel:self.title1LAbel.text withSize:CGSizeMake(100, 21) withTextFont:13.0f];
    self.commentWidthCon.constant = rect2.size.width+5;
    
    self.placeLabel.text    = model.address;
    self.placeLabel.frame   = CGRectMake(CGRectGetMaxX(self.title1LAbel.frame)+5, 57, WIDTH_CONTROLLER_DEFAULT-CGRectGetMaxX(self.title1LAbel.frame)-13, 21);
    CGFloat distance = [model.distance floatValue];
    
    if (distance == 0) {
        NSString *oreillyAddress = model.address;  //测试使用中文也可以找到经纬度具体的可以多尝试看看~
        CLGeocoder *myGeocoder = [[CLGeocoder alloc] init];
        [myGeocoder geocodeAddressString:oreillyAddress completionHandler:^(NSArray *placemarks, NSError *error) {
            if ([placemarks count] > 0 && error == nil)
            {
                NSLog(@"Found %lu placemark(s).", (unsigned long)[placemarks count]);
                CLPlacemark *firstPlacemark = [placemarks objectAtIndex:0];
                NSLog(@"Longitude = %f", firstPlacemark.location.coordinate.longitude);
                NSLog(@"Latitude = %f", firstPlacemark.location.coordinate.latitude);
                //第一个坐标
                CLLocation *current=[[CLLocation alloc] initWithLatitude:[[FileOperation getLatitude] floatValue] longitude:[[FileOperation getLongitude] floatValue]];
                //第二个坐标
                CLLocation *before=[[CLLocation alloc] initWithLatitude:firstPlacemark.location.coordinate.longitude longitude:firstPlacemark.location.coordinate.latitude];
                // 计算距离
                CLLocationDistance meters=[current distanceFromLocation:before];
                CGFloat sd = [[NSString stringWithFormat:@"%f",meters] floatValue];
                if (sd < 500.0) {
                    self.distenceLabel.text     = @"<500m";
                    return;
                }
                if (sd < 1000.0) {
                    self.distenceLabel.text     = @"<1km";
                    return;
                }
                if (sd < 2000.0) {
                    self.distenceLabel.text     = @"<2km";
                    return;
                }
                if (sd < 5000.0) {
                    self.distenceLabel.text     = @"<5km";
                    return;
                }
                if (sd < 10000.0) {
                    self.distenceLabel.text     = @"<10km";
                    return;
                }
                if (sd >= 10000.0) {
                    self.distenceLabel.text     = @">10km";
                }

                
            }
            else if ([placemarks count] == 0 && error == nil)
            {
                NSLog(@"Found no placemarks.");
                self.distenceLabel.text = @"";
            }
            else if (error != nil)
            {
                NSLog(@"An error occurred = %@", error);
                self.distenceLabel.text = @"";
            }
        }];

    }else{
        if (distance < 500.0) {
            self.distenceLabel.text     = @"<500m";
            return;
        }
        if (distance < 1000.0) {
            self.distenceLabel.text     = @"<1km";
            return;
        }
        if (distance < 2000.0) {
            self.distenceLabel.text     = @"<2km";
            return;
        }
        if (distance < 5000.0) {
            self.distenceLabel.text     = @"<5km";
            return;
        }
        if (distance < 10000.0) {
            self.distenceLabel.text     = @"<10km";
            return;
        }
        if (distance >= 10000.0) {
            self.distenceLabel.text     = @">10km";
        }

    }
    
    
}


- (void) setCheckImageViewCenter:(CGPoint)pt alpha:(CGFloat)alpha animated:(BOOL)animated
{
    if (animated)
    {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationDuration:0.3];
        
        m_checkImageView.center = pt;
        m_checkImageView.alpha = alpha;
        
        [UIView commitAnimations];
    }
    else
    {
        m_checkImageView.center = pt;
        m_checkImageView.alpha = alpha;
    }
}

- (void) setEditing:(BOOL)editting animated:(BOOL)animated
{
    if (self.editing == editting)
    {
        return;
    }
    
    [super setEditing:editting animated:animated];
    
    if (editting)
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundView = [[UIView alloc] init];
        self.backgroundView.backgroundColor = [UIColor whiteColor];
        self.textLabel.backgroundColor = [UIColor clearColor];
        self.detailTextLabel.backgroundColor = [UIColor clearColor];
        
        if (m_checkImageView == nil)
        {
            m_checkImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_no_selected.png"]];
            [self addSubview:m_checkImageView];
        }
        
        [self setChecked:m_checked];
        m_checkImageView.center = CGPointMake(-CGRectGetWidth(m_checkImageView.frame) * 0.5,
                                              CGRectGetHeight(self.bounds) * 0.5);
        m_checkImageView.alpha = 0.0;
        CGRect frame = m_checkImageView.frame;
        frame.size.width = 16;
        frame.size.height = 15;
        m_checkImageView.frame = frame;
        [self setCheckImageViewCenter:CGPointMake(20.5, CGRectGetHeight(self.bounds) * 0.5)
                                alpha:1.0 animated:animated];
    }
    else
    {
        m_checked = NO;
        self.selectionStyle = UITableViewCellSelectionStyleBlue;
        self.backgroundView = nil;
        
        if (m_checkImageView)
        {
            [self setCheckImageViewCenter:CGPointMake(-CGRectGetWidth(m_checkImageView.frame) * 0.5,
                                                      CGRectGetHeight(self.bounds) * 0.5)
                                    alpha:0.0
                                 animated:animated];
        }
    }
}


- (void) setChecked:(BOOL)checked
{
    if (checked)
    {
        m_checkImageView.image = [UIImage imageNamed:@"img_selected.png"];
        self.backgroundView.backgroundColor = [UIColor colorWithRed:223.0/255.0 green:230.0/255.0 blue:250.0/255.0 alpha:1.0];
    }
    else
    {
        m_checkImageView.image = [UIImage imageNamed:@"img_no_selected.png"];
        self.backgroundView.backgroundColor = [UIColor whiteColor];
    }
    m_checked = checked;
}



@end

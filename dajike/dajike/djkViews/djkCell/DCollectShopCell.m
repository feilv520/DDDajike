//
//  DCollectShopCell.m
//  dajike
//
//  Created by songjw on 15/7/17.
//  Copyright (c) 2015年 haixia. All rights reserved.
//

#import "DCollectShopCell.h"
#import "dDefine.h"
#import "commonTools.h"

@implementation DCollectShopCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setShopModel:(BunessList1Model *)shopModel{
    self.shopNameLab.text = shopModel.store_name;
    self.fenNumLab.text = [NSString stringWithFormat:@"%@个",shopModel.collectCount];
    [self.headImgV.layer setMasksToBounds:YES];
    [self.headImgV.layer setCornerRadius:4.0];
    [self.headImgV setImageWithURL:[commonTools getImgURL:shopModel.store_logo] placeholderImage:DPlaceholderImage];
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

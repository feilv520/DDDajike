//
//  EnvironmentCollectionCell.m
//  jibaobao
//
//  Created by swb on 15/5/30.
//  Copyright (c) 2015年 dajike. All rights reserved.
//

#import "EnvironmentCollectionCell.h"
#import "defines.h"

@implementation EnvironmentCollectionCell

- (void)awakeFromNib {
    // Initialization code
    self.backgroundColor = Color_White;
}

- (void)setModel:(PhotoAlbumModel *)model
{
    [self.imgView setImageWithURL:[commonTools getImgURL:model.file_path] placeholderImage:PlaceholderImage];
    self.nameLb.text = model.image_name;
}

@end

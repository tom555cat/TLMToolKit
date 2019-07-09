//
//  TLMUILageTableViewCell.m
//  TLMToolKit
//
//  Created by tongleiming on 2019/7/8.
//  Copyright © 2019 tongleiming1989@sina.com. All rights reserved.
//

#import "TLMUILageTableViewCell.h"

@interface TLMUILageTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *image1;

@property (weak, nonatomic) IBOutlet UIImageView *image2;

@property (weak, nonatomic) IBOutlet UIImageView *image3;


@end

@implementation TLMUILageTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configImage1:(UIImage *)image1 {
    self.image1.image = image1;
}

- (void)configImage2:(UIImage *)image2 {
    self.image2.image = image2;
}

- (void)configImage3:(UIImage *)image3 {
    self.image3.image = image3;
}

@end

//
//  AOFavoriteTableViewCell.m
//  LuizaHeyTable
//
//  Created by admin on 3/12/16.
//  Copyright © 2016 admin. All rights reserved.
//

#import "AOFavoriteTableViewCell.h"

@implementation AOFavoriteTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (CGFloat) heightForText:(NSString*) text {
    
    CGFloat offset = 8.0;
    
    UIFont* font = [UIFont systemFontOfSize:30.f];
    /*
    NSShadow* shadow = [[NSShadow alloc] init];
    shadow.shadowOffset = CGSizeMake(0, -1);
    shadow.shadowBlurRadius = 0.5;
    
    NSMutableParagraphStyle* paragraph = [[NSMutableParagraphStyle alloc] init];
    [paragraph setLineBreakMode:NSLineBreakByWordWrapping];
    [paragraph setAlignment:NSTextAlignmentCenter];
    */
    NSDictionary* attributes = [NSDictionary
                                dictionaryWithObjectsAndKeys:
                                font, NSFontAttributeName,
                                //paragraph, NSParagraphStyleAttributeName,
                                //shadow, NSShadowAttributeName,
                                nil];
    
    CGRect rect = [text boundingRectWithSize:
                   CGSizeMake(320 / 2 * offset, CGFLOAT_MAX)
                                     options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                  attributes:attributes
                                     context:nil];
    
    CGFloat height = CGRectGetHeight(rect) + 2 * offset;

    
    return height;
    
    
}




@end

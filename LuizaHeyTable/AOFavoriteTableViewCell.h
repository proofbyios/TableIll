//
//  AOFavoriteTableViewCell.h
//  LuizaHeyTable
//
//  Created by admin on 3/12/16.
//  Copyright © 2016 admin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AOFavoriteTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *illnessNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *illnessSolutionLabel;


+ (CGFloat) heightForText:(NSString*) text;


@end

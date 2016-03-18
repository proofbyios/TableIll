//
//  AODetailViewController.h
//  LuizaHeyTable
//
//  Created by admin on 3/8/16.
//  Copyright © 2016 admin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AOUpdateFavoriteListDelegate.h"

@class AOIllness;

@interface AODetailViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *moreIllnessLabel;
@property (weak, nonatomic) IBOutlet UILabel *reasonIllnessLabel;
@property (weak, nonatomic) IBOutlet UILabel *solutionIllnesLabel;

@property (strong, nonatomic) AOIllness* currentObject;

@property (weak, nonatomic) id <AOUpdateFavoriteListDelegate> delegate;


@end

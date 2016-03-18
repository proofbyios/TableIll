//
//  AOFavoriteTableViewController.h
//  LuizaHeyTable
//
//  Created by admin on 3/12/16.
//  Copyright © 2016 admin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AOUpdateFavoriteListDelegate.h"

@interface AOFavoriteTableViewController : UITableViewController <AOUpdateFavoriteListDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;


@end

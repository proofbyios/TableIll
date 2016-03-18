//
//  AODetailViewController.m
//  LuizaHeyTable
//
//  Created by admin on 3/8/16.
//  Copyright © 2016 admin. All rights reserved.
//

#import "AODetailViewController.h"
#import "AOIllness.h"
#import "AOKeyClass.h"
#import "AOFavoriteTableViewController.h"

@interface AODetailViewController ()

@property (strong, nonatomic) NSMutableArray* illnessObjectsArray;

@property (assign, nonatomic) NSInteger countIllnessToFavorite;

@property (strong, nonatomic) UIColor* bgColor UI_APPEARANCE_SELECTOR;

@property (weak, nonatomic) IBOutlet UIView *mainView;

@property (strong, nonatomic) Class mainClass;
@property (strong, nonatomic) NSMutableArray *invocations;



@end

static NSMutableDictionary *dictionaryOfClasses = nil;

@implementation AODetailViewController


- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg"]];
    
    NSUserDefaults* us = [NSUserDefaults standardUserDefaults];
    
    AOIllness* illness = (AOIllness*)[us objectForKey:kAllFavoritIllness];
    
    if (!illness) {
        
        self.illnessObjectsArray = [NSMutableArray array];
        
        [us setObject:[NSKeyedArchiver archivedDataWithRootObject:self.illnessObjectsArray] forKey:kAllFavoritIllness];
        [us synchronize];
        
    } else {
        
        NSData* objectData = [us objectForKey:kAllFavoritIllness];
        self.illnessObjectsArray = [NSKeyedUnarchiver unarchiveObjectWithData:objectData];

    }
    
    self.navigationItem.rightBarButtonItem = [self checkFavoriteOnCurrentObject:self.currentObject andFavorite:self.illnessObjectsArray];
    self.navigationItem.title = self.currentObject.illnessName;
    
    if ([self.currentObject.illnessMore length] > 3) {
        self.moreIllnessLabel.text = [NSString stringWithFormat:@"См. так же: %@", self.currentObject.illnessMore];
    }
    
    self.reasonIllnessLabel.text = self.currentObject.illnessReason;
    self.solutionIllnesLabel.text = self.currentObject.illnessSolution;
    
    
}

- (void) viewWillDisappear:(BOOL)animated {
    
    if ([self.tabBarController.tabBar.items objectAtIndex:1].badgeValue == nil) {
        self.countIllnessToFavorite = 0;
    }
    
}

#pragma mark - Add To Favorite

- (void) addIllnessToFavorit:(UIBarButtonItem*) item {
    
    static NSInteger count = 0;
    
    if ([self.tabBarController.tabBar.items objectAtIndex:1].badgeValue == nil) {
        count = 0;
    }

    count++;
    self.countIllnessToFavorite = count;
    [[self.tabBarController.tabBar.items objectAtIndex:1] setBadgeValue:[NSString stringWithFormat:@"%ld", (long)self.countIllnessToFavorite]];
    
    [self banTouches];
    
    [self.illnessObjectsArray addObject:self.currentObject];
    
    [self updateFavoriteArray];
    
    [self.navigationItem setRightBarButtonItem:[self checkFavoriteOnCurrentObject:self.currentObject andFavorite:self.illnessObjectsArray] animated:YES];
    
}

#pragma mark - Delete From Favorite

- (void) deleteIllnessFromFavorit:(UIBarButtonItem*) item {
    
    [self banTouches];
    
    for (AOIllness* ill in self.illnessObjectsArray) {
        
        if (ill.illnessId == self.currentObject.illnessId) {
            
            NSMutableArray* tempArray = [NSMutableArray arrayWithArray:self.illnessObjectsArray];
            [tempArray removeObject:ill];
            
            self.illnessObjectsArray = tempArray;
            
            [self updateFavoriteArray];
            
            UIBarButtonItem* add = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addIllnessToFavorit:)];
            [self.navigationItem setRightBarButtonItem:add animated:YES];
            
        }
    }
    
}

#pragma mark - Chek in Favorite and switch item

- (UIBarButtonItem*) checkFavoriteOnCurrentObject:(AOIllness*) ill andFavorite:(NSMutableArray*) favorite {
    
    for (AOIllness* ill in favorite) {
        
        if (self.currentObject.illnessId == ill.illnessId) {
            
            UIBarButtonItem* del = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(deleteIllnessFromFavorit:)];
            
            return del;
            
        }
    }
    
    UIBarButtonItem* add = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addIllnessToFavorit:)];
    
    return add;
}

#pragma mark - Ignore Touch

- (void) banTouches {
    
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[UIApplication sharedApplication] endIgnoringInteractionEvents];
    });
    
}

#pragma mark - Update Array 

- (void) updateFavoriteArray {
    
    NSUserDefaults* us = [NSUserDefaults standardUserDefaults];
    [us removeObjectForKey:kAllFavoritIllness];
    [us setObject:[NSKeyedArchiver archivedDataWithRootObject:self.illnessObjectsArray] forKey:kAllFavoritIllness];
    [us synchronize];
    
    UINavigationController *navigation = (UINavigationController *)self.tabBarController.viewControllers[1];
    AOFavoriteTableViewController *fvc = navigation.viewControllers[0];
    self.delegate = fvc;
        
    if ([self.delegate respondsToSelector:@selector(reloadTableView)]) {
        [self.delegate reloadTableView];
    }
    
    
}

#pragma mark - didReceiveMemoryWarning

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end



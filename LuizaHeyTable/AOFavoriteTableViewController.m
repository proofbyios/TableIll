//
//  AOFavoriteTableViewController.m
//  LuizaHeyTable
//
//  Created by admin on 3/12/16.
//  Copyright © 2016 admin. All rights reserved.
//

#import "AOFavoriteTableViewController.h"
#import "AOFavoriteTableViewCell.h"
#import "AOKeyClass.h"
#import "AOIllness.h"
#import "AODetailViewController.h"


@protocol AOUpdateFavoriteListDelegate;

@interface AOFavoriteTableViewController () 

@property (strong, nonatomic) NSMutableArray* illnessFavoriteArray;
@property (strong, nonatomic) NSMutableDictionary* offscreenCells;

@end

@implementation AOFavoriteTableViewController

@dynamic tableView;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self getFavoriteIllnessToArray];
    
    UIBarButtonItem* edit = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(addButtonOnNavigationBar:)];
    self.navigationItem.rightBarButtonItem = edit;
    
    self.tableView.estimatedRowHeight = 30;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
}

- (void) viewWillAppear:(BOOL)animated {
    
    [[self.tabBarController.tabBar.items objectAtIndex:1] setBadgeValue:nil];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return [self.illnessFavoriteArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString* identifier = @"Cell";
    
    AOFavoriteTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    AOIllness* illness = [self.illnessFavoriteArray objectAtIndex:indexPath.row];
    
    cell.illnessNameLabel.text = illness.illnessName;
    cell.illnessSolutionLabel.text = illness.illnessSolution;
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    
    AOIllness* currentObject = [self.illnessFavoriteArray  objectAtIndex:sourceIndexPath.row];
    
    NSMutableArray* tempArray = [NSMutableArray arrayWithArray:self.illnessFavoriteArray];
    
    [tempArray removeObject:currentObject];
    [tempArray insertObject:currentObject atIndex:destinationIndexPath.row];
    
    self.illnessFavoriteArray = tempArray;
    
    [self updateFavoriteArrayWithArray:self.illnessFavoriteArray andKey:kAllFavoritIllness];
    
    [self.tableView reloadData];
    
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    AOIllness* illness = [self.illnessFavoriteArray objectAtIndex:indexPath.row];
    
    CGFloat part = [AOFavoriteTableViewCell heightForText:illness.illnessName];
    CGFloat part2 = [AOFavoriteTableViewCell heightForText:illness.illnessSolution];
    CGFloat part3 = part + part2;
    
    return part3;

}

- (nullable NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return @"Удалить";
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self banTouches];
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        AOIllness* currentObject = [self.illnessFavoriteArray  objectAtIndex:indexPath.row];
        
        for (AOIllness* ill in self.illnessFavoriteArray) {
            
            if (ill.illnessId == currentObject.illnessId) {
                
                NSMutableArray* tempArray = [NSMutableArray arrayWithArray:self.illnessFavoriteArray];
                
                [tempArray removeObject:ill];
                
                self.illnessFavoriteArray = tempArray;
                
                [self updateFavoriteArrayWithArray:self.illnessFavoriteArray andKey:kAllFavoritIllness];
                
                [self.tableView beginUpdates];
                [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
                [self.tableView endUpdates];
                
            }
        }
    }
}

#pragma mark - AOUpdateFavoriteListDelegate

- (void) reloadTableView {
    
    [self getFavoriteIllnessToArray];
    
    [self.tableView reloadData];
    
}

#pragma mark - Methods

- (void) getFavoriteIllnessToArray {
    
    self.illnessFavoriteArray = [NSMutableArray array];
    
    NSUserDefaults* us = [NSUserDefaults standardUserDefaults];
    NSData* objectData = [us objectForKey:kAllFavoritIllness];
    self.illnessFavoriteArray = [NSKeyedUnarchiver unarchiveObjectWithData:objectData];
    
}

- (void) banTouches {
    
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[UIApplication sharedApplication] endIgnoringInteractionEvents];
    });
    
}

- (void) addButtonOnNavigationBar:(UIBarButtonItem*) sender {
    
    [self banTouches];
    
    BOOL isEditing = self.tableView.editing;
    
    [self.tableView setEditing:!isEditing animated:YES];
    
    UIBarButtonSystemItem item = UIBarButtonSystemItemEdit;
    
    if (self.tableView.isEditing) {
        item = UIBarButtonSystemItemDone;
    }

    UIBarButtonItem* button = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:item target:self action:@selector(addButtonOnNavigationBar:)];
    [self.navigationItem setRightBarButtonItem:button animated:YES];
}

- (void) updateFavoriteArrayWithArray:(NSMutableArray*) array andKey:(NSString*) key {
    
    NSUserDefaults* us = [NSUserDefaults standardUserDefaults];
    [us removeObjectForKey:kAllFavoritIllness];
    [us setObject:[NSKeyedArchiver archivedDataWithRootObject:array] forKey:key];
    [us synchronize];
    
}

#pragma mark - didReceiveMemoryWarning

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

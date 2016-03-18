//
//  AOTableViewController.m
//  LuizaHeyTable
//
//  Created by admin on 3/7/16.
//  Copyright © 2016 admin. All rights reserved.
//

#import "AOTableViewController.h"
#import "AOIllness.h"
#import "AOServerManager.h"
#import "UIKit+AFNetworking/UIImageView+AFNetworking.h"
#import "AOListTableViewCell.h"
#import "AODetailViewController.h"
#import "AOSection.h"



@interface AOTableViewController () <NSXMLParserDelegate, UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSMutableArray* illnessArray;
@property (strong, nonatomic) NSMutableArray* sectionArray;

@property (strong, nonatomic) NSString* element;

@property(strong, nonatomic) NSString* currentName;
@property(strong, nonatomic) NSString* currentMore;
@property(strong, nonatomic) NSString* currentReason;
@property(strong, nonatomic) NSString* currentSolution;
@property(assign, nonatomic) NSInteger currentId;

@property (strong, nonatomic) AOIllness* currentObject;

@property (strong, nonatomic) NSMutableArray* illnessObjectsArray;

@end

@implementation AOTableViewController

@dynamic tableView;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[UITableView appearance] setBackgroundView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg"]]];
    //[[UIView appearanceWhenContainedIn:[AODetailViewController class], nil] setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg"]]];
    
    self.tableView.backgroundView.contentMode = UIViewContentModeScaleAspectFill;
    //self.tableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg"]];
    
    self.sectionArray = [NSMutableArray array];
    self.illnessArray = [NSMutableArray array];
    
    NSString* path = [[NSBundle mainBundle] pathForResource:@"example.xml" ofType:nil];
    
    NSData* dataOfFile = [NSData dataWithContentsOfFile:path];
    
    NSXMLParser* parserXML = [[NSXMLParser alloc] initWithData:dataOfFile];
    parserXML.delegate = self;
    [parserXML parse];
    
    /*
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        if (![self connectedToInternet]) {
            
            [[AOServerManager sharedManager] getPictureFromServerOnSuccess:^(NSDictionary *response) {
                
                if (response) {
                    
                    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
                    
                    NSLog(@"response = %@", response);
                    
                    CGFloat statusBar = 20;
                    
                    NSURL* imageUrl = [NSURL URLWithString:[response objectForKey:@"img"]];
                    NSURLRequest* request = [NSURLRequest requestWithURL:imageUrl];
                    
                    UIImageView* advertisingImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, statusBar, CGRectGetMaxX(self.view.bounds), CGRectGetMaxY(self.view.bounds))];
                    
                    UIView* advertisingView = [[UIView alloc] initWithFrame:CGRectMake(0, statusBar, CGRectGetMaxX(self.view.bounds), CGRectGetMaxY(self.view.bounds))];
                    advertisingView.backgroundColor = [UIColor whiteColor];
                    [advertisingView addSubview:advertisingImageView];
                    
                    __weak UIImageView *advertisingImageViewWeak = advertisingImageView;
                    
                    [advertisingImageView setImageWithURLRequest:request placeholderImage:nil success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull image) {
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            advertisingImageViewWeak.image = image;
                            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                        });
                        
                    } failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
                        
                        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                        NSLog(@"Image Error: %@", [error localizedDescription]);
                        
                    }];
                    
                    UIImage* closeImage = [UIImage imageNamed:@"close.png"];
                    
                    UIButton* closeButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 25, 25, 25)];
                    [closeButton setBackgroundImage:closeImage forState:UIControlStateNormal];
                    [closeButton addTarget:self action:@selector(closeView:) forControlEvents:UIControlEventTouchUpInside];
                    [advertisingView addSubview:closeButton];
                    
                    UITapGestureRecognizer* tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
                    [advertisingView addGestureRecognizer:tapGesture];
                    
                    UIViewController* advertisingViewController = [[UIViewController alloc] init];
                    advertisingViewController.view = advertisingView;
                    
                    [self presentViewController:advertisingViewController animated:YES completion:^{
                        
                    }];
                }
                
            } orFailure:^(NSError *error) {
                
                NSLog(@"Error: %@", [error localizedDescription]);
                
            }]; //AOServerManager close here
        } // if close here
    }); //dispatch close here
    */
    
    NSString* currentLetter = @"";
    
    for (AOIllness* ill in self.illnessArray) {
        
        NSString* fierstLetter = [ill.illnessName substringToIndex:1];
        
        AOSection* section = nil;
        
        if (![fierstLetter isEqualToString:currentLetter]) {
            
            section = [[AOSection alloc] init];
            section.sectionName = fierstLetter;
            section.itemsArray = [NSMutableArray array];
            currentLetter = fierstLetter;
            
            [self.sectionArray addObject:section];
            
        } else {
            
            section = [self.sectionArray lastObject];
        }
        
        [section.itemsArray addObject:ill];
        
    }
    
}

#pragma mark - Gestures

- (void) handleTap:(UITapGestureRecognizer*) tap {
    
    //[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://itunes.com/apps/DevelopmentCompanyLLC"]];
    
}

#pragma mark - Close Ads View

- (void) closeView:(UIButton*) sender {
    
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
    
}

#pragma mark - ConnectedToInternet

- (BOOL)connectedToInternet
{
    NSString *urlString = @"http://www.google.com/";
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"HEAD"];
    NSHTTPURLResponse *response;
    
    [NSURLConnection sendSynchronousRequest:request returningResponse:&response error: NULL];
    
    return ([response statusCode] == 200) ? YES : NO;
}



#pragma mark - NSXMLParserDelegate

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(nullable NSString *)namespaceURI qualifiedName:(nullable NSString *)qName attributes:(NSDictionary<NSString *, NSString *> *)attributeDict {
    
    self.element = elementName;
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    
    if ([self.element isEqualToString:@"name"]) {
        self.currentName = string;
    } else if ([self.element isEqualToString:@"reason"]) {
        self.currentReason = string;
    } else if ([self.element isEqualToString:@"solution"]) {
        self.currentSolution = string;
    } else if ([self.element isEqualToString:@"id"]) {
        self.currentId = string.intValue;
    } else if ([self.element isEqualToString:@"continue"]) {
        self.currentMore = string;
    }
    
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(nullable NSString *)namespaceURI qualifiedName:(nullable NSString *)qName {
    
    if ([elementName isEqualToString:@"illness"]) {
        AOIllness* ill = [[AOIllness alloc] init];
        ill.illnessId = self.currentId;
        ill.illnessName = self.currentName;
        ill.illnessReason = self.currentReason;
        ill.illnessSolution = self.currentSolution;
        ill.illnessMore = self.currentMore;
        
        [self.illnessArray addObject:ill];
        
        self.currentMore = nil;
    }
    
    self.element = nil;
}


#pragma mark - UITableViewDataSource

- (nullable NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    
    NSMutableArray* array = [NSMutableArray array];
    
    for (AOSection* section in self.sectionArray) {
        
        [array addObject:section.sectionName];
        
    }
    
    tableView.sectionIndexBackgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.50];
    //tableView.sectionIndexTrackingBackgroundColor = [UIColor colorWithRed:0.00 green:0.45 blue:0.93 alpha:1];
    
    return array;
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    return [[self.sectionArray objectAtIndex:section] sectionName];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return [self.sectionArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    AOSection* sect = [self.sectionArray objectAtIndex:section];
    
    return [sect.itemsArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString* identifier = @"Cell";
    NSString* identifier2 = @"Cell2";
    
    AOListTableViewCell *cell = nil;
    UITableViewCell* cell2 = nil;
    
    AOSection* sect = [self.sectionArray objectAtIndex:indexPath.section];
    AOIllness* ill = [sect.itemsArray objectAtIndex:indexPath.row];
    
    if ([ill.illnessMore length] > 2) {
        
        cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        cell.illnessLabel.text = ill.illnessName;
        cell.moreIllnessLabel.text = [NSString stringWithFormat:@"%@", ill.illnessMore];
        cell.backgroundColor = [self colorForCellWithIndexPath:indexPath];
        
        return cell;
        
    } else {
        
        cell2 = [tableView dequeueReusableCellWithIdentifier:identifier2];
        cell2.textLabel.text = ill.illnessName;
        cell2.backgroundColor = [self colorForCellWithIndexPath:indexPath];
        
        return cell2;
    }
    
    return nil;
}

#pragma mark - Cell Color

- (UIColor*) colorForCellWithIndexPath:(NSIndexPath*) indexPath {
    
    if (indexPath.row % 2 == 1) {
        return [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.10];
    } else {
        return [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.18];
    }
    
    return nil;
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

- (nullable NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    AOSection* sect = [self.sectionArray objectAtIndex:indexPath.section];
    
    AOIllness* ill = [sect.itemsArray objectAtIndex:indexPath.row];
    
    self.currentObject = ill;
    
    return indexPath;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 55.f;
    
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    // Background color
    view.tintColor = [UIColor colorWithRed:0.00 green:0.45 blue:0.93 alpha:1];
    
    // Text Color
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    [header.textLabel setTextColor:[UIColor whiteColor]];
}


#pragma mark - Navigation


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    AODetailViewController* dvc = [segue destinationViewController];
    [dvc setCurrentObject:self.currentObject];
    
}


#pragma mark - didReceiveMemoryWarning

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

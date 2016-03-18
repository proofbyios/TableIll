//
//  AOIllness.h
//  testParsXML
//
//  Created by admin on 3/6/16.
//  Copyright © 2016 admin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AOIllness : NSObject <NSCoding>

@property (assign, nonatomic) NSInteger illnessId;
@property (strong, nonatomic) NSString* illnessName;
@property (strong, nonatomic) NSString* illnessMore;
@property (strong, nonatomic) NSString* illnessReason;
@property (strong, nonatomic) NSString* illnessSolution;

@end

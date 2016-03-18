//
//  AOIllness.m
//  testParsXML
//
//  Created by admin on 3/6/16.
//  Copyright © 2016 admin. All rights reserved.
//

#import "AOIllness.h"

@implementation AOIllness


- (void)encodeWithCoder:(NSCoder *)coder;
{
    [coder encodeInteger:self.illnessId forKey:@"id"];
    [coder encodeObject:self.illnessMore forKey:@"more"];
    [coder encodeObject:self.illnessName forKey:@"name"];
    [coder encodeObject:self.illnessReason forKey:@"reason"];
    [coder encodeObject:self.illnessSolution forKey:@"solution"];
    
}

- (id)initWithCoder:(NSCoder *)coder;
{
    self = [[AOIllness alloc] init];
    if (self != nil)
    {
        self.illnessId = [coder decodeIntegerForKey:@"id"];
        self.illnessMore = [coder decodeObjectForKey:@"more"];
        self.illnessName = [coder decodeObjectForKey:@"name"];
        self.illnessReason = [coder decodeObjectForKey:@"reason"];
        self.illnessSolution = [coder decodeObjectForKey:@"solution"];
        
    }
    return self;
}



@end

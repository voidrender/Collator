//
//  OCProperty.m
//  Collator
//
//  Created by Isaac Overacker on 1/28/15.
//
//

#import "OCProperty.h"

@implementation OCProperty

- (instancetype)init
{
    if (self = [super init]) {
        _comments = [[NSMutableArray alloc] init];
    }

    return self;
}

- (NSString *)description
{
    NSMutableString *mutableString = [[NSMutableString alloc] init];

    for (NSString *comment in self.comments) {
        [mutableString appendFormat:@"%@\n", comment];
    }

    [mutableString appendFormat:@"%@", self.propertyLine];

    return mutableString;
}

@end

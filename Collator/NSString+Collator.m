//
//  NSString+Collator.m
//  Collator
//
//  Created by Isaac Overacker on 1/22/15.
//
//

#import "NSString+Collator.h"

@implementation NSString (Collator)

- (NSString *)stringBySortingPropertyDeclarations
{
    NSArray *lines = [self componentsSeparatedByString:@"\n"];

    NSMutableDictionary *nameToLineMap = [[NSMutableDictionary alloc] init];

    for (NSString *line in lines) {
        NSRange rangeOfProperty = [line rangeOfString:@"@property"];
        if (rangeOfProperty.location != NSNotFound) {
            // This is a property, so let's get the property name.
            NSString *trimmedLine = [line stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            NSArray *tokens = [trimmedLine componentsSeparatedByString:@" "]; // TODO: Support tokens separated by arbitrary whitespace.
            NSString *propertyName = [tokens.lastObject stringByReplacingOccurrencesOfString:@"*" withString:@""];
            NSString *lineWithoutLF = [line stringByReplacingOccurrencesOfString:@"\n" withString:@""];
            [nameToLineMap setObject:lineWithoutLF forKey:propertyName];
        }
    }

    if (nameToLineMap.count == 0) {
        return self;
    }

    NSArray *sortedKeys = [[nameToLineMap allKeys] sortedArrayUsingComparator:^NSComparisonResult(NSString *key1, NSString *key2) {
        return [key1 compare:key2];
    }];

    NSMutableString *sortedLines = [[NSMutableString alloc] init];

    for (NSString *key in sortedKeys) {
        if (sortedLines.length > 0) {
            [sortedLines appendString:@"\n"];
        }
        [sortedLines appendString:[nameToLineMap valueForKey:key]];
    }

    return sortedLines;
}

@end

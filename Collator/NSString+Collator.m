//
//  NSString+Collator.m
//  Collator
//
//  Created by Isaac Overacker on 1/22/15.
//
//

#import "NSString+Collator.h"
#import "OCProperty.h"

@implementation NSString (Collator)

- (NSString *)stringBySortingPropertyDeclarations
{
    NSArray *lines = [self componentsSeparatedByString:@"\n"];

    NSMutableArray *properties = [[NSMutableArray alloc] init];

    OCProperty *currentProperty;
    for (NSString *line in lines) {
        if (!currentProperty) {
            currentProperty = [[OCProperty alloc] init];
        }

        NSString *lineWithoutLF = [line stringByReplacingOccurrencesOfString:@"\n" withString:@""];

        NSRange rangeOfProperty = [line rangeOfString:@"@property"];
        if (rangeOfProperty.location == NSNotFound) {
            [currentProperty.comments addObject:lineWithoutLF];
        }
        else { // We found the property declaration.
            currentProperty.propertyLine = lineWithoutLF;

            NSString *trimmedLine = [lineWithoutLF stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            NSArray *tokens = [trimmedLine componentsSeparatedByString:@" "]; // TODO: Support tokens separated by arbitrary whitespace.

            NSString *propertyName = [tokens.lastObject stringByReplacingOccurrencesOfString:@"*" withString:@""];
            currentProperty.name = propertyName;

            [properties addObject:currentProperty];
            currentProperty = nil;
        }
    }

    if (properties.count == 0) {
        return self;
    }

    [properties sortUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]]];

    NSMutableString *sortedLines = [[NSMutableString alloc] init];

    for (OCProperty *property in properties) {
        if (sortedLines.length > 0) {
            [sortedLines appendString:@"\n"];
        }
        [sortedLines appendString:property.description];
    }

    return sortedLines;
}

@end

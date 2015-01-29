//
//  OCProperty.h
//  Collator
//
//  Created by Isaac Overacker on 1/28/15.
//
//

#import <Foundation/Foundation.h>

/**
 *  A model of an Objective-C property.
 */
@interface OCProperty : NSObject

/**
 *  The comments, pragma directives, and whitespace above this property declaration.
 */
@property (nonatomic, strong, readonly) NSMutableArray *comments;

/**
 *  The name of this property declaration, exposed to ease sorting.
 */
@property (nonatomic, strong) NSString *name;

/**
 *  The property declaration.
 */
@property (nonatomic, strong) NSString *propertyLine;

@end

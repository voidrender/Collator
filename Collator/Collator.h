//
//  Collator.h
//  Collator
//
//  Created by Isaac Overacker on 1/22/15.
//
//

#import <AppKit/AppKit.h>

@interface Collator : NSObject

+ (instancetype)sharedPlugin;

@property (nonatomic, strong, readonly) NSBundle* bundle;

@end
//
//  Collator.m
//  Collator
//
//  Created by Isaac Overacker on 1/22/15.
//
//

#import "Collator.h"
#import "DTXcodeUtils.h"
#import "DTXcodeHeaders.h"
#import "NSString+Collator.h"

static Collator *sharedPlugin;

@interface Collator()

@property (nonatomic, strong, readwrite) NSBundle *bundle;
@end

@implementation Collator

#pragma mark Lifecycle

+ (void)pluginDidLoad:(NSBundle *)plugin
{
    static dispatch_once_t onceToken;
    NSString *currentApplicationName = [[NSBundle mainBundle] infoDictionary][@"CFBundleName"];
    if ([currentApplicationName isEqual:@"Xcode"]) {
        dispatch_once(&onceToken, ^{
            sharedPlugin = [[self alloc] initWithBundle:plugin];
        });
    }
}

+ (instancetype)sharedPlugin
{
    return sharedPlugin;
}

- (id)initWithBundle:(NSBundle *)plugin
{
    if (self = [super init]) {
        self.bundle = plugin;

        NSMenuItem *menuItem = [[NSApp mainMenu] itemWithTitle:@"Edit"];
        if (menuItem) {
            [[menuItem submenu] addItem:[NSMenuItem separatorItem]];
            NSMenuItem *actionMenuItem = [[NSMenuItem alloc] initWithTitle:@"Alphabetize Selection"
                                                                    action:@selector(alphabetizeSelection)
                                                             keyEquivalent:@""];
            [actionMenuItem setTarget:self];
            [actionMenuItem setKeyEquivalent:@"a"];
            [actionMenuItem setKeyEquivalentModifierMask:NSControlKeyMask | NSCommandKeyMask];
            [[menuItem submenu] addItem:actionMenuItem];
        }
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark Actions

- (void)alphabetizeSelection
{
    DVTSourceTextView *sourceTextView = [DTXcodeUtils currentSourceTextView];
    NSRange selectedTextRange = [sourceTextView selectedRange];
    NSString *selectedString = [sourceTextView.textStorage.string substringWithRange:selectedTextRange];
    if (selectedString) {
        [sourceTextView replaceCharactersInRange:selectedTextRange withString:[selectedString stringBySortingPropertyDeclarations]];
    }
}

@end

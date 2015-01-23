//
//  CollatorTests.m
//  CollatorTests
//
//  Created by Isaac Overacker on 1/22/15.
//
//

#import <Cocoa/Cocoa.h>
#import <XCTest/XCTest.h>
#import "NSString+Collator.h"

@interface NSString_CollatorTests : XCTestCase

@property (nonatomic) BOOL uhoh;
@property NSInteger a;
@property NSString *b;
@property BOOL ba;

@end

@implementation NSString_CollatorTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testStringBySortingPropertyDeclarations_EmptyString
{
    NSString *string = @"";
    NSString *sorted = [string stringBySortingPropertyDeclarations];

    XCTAssertEqualObjects(sorted, string);
}

- (void)testStringBySortingPropertyDeclarations_NoProperties
{
    NSString *string = @"@implementation SomeClass\n@end";
    NSString *sorted = [string stringBySortingPropertyDeclarations];

    XCTAssertEqualObjects(sorted, string);
}

- (void)testStringBySortingPropertyDeclarations_BasicProperties
{
    NSString *string = @"    @property NSInteger b;\n    @property CustomType *a;";
    NSString *expected = @"    @property CustomType *a;\n\    @property NSInteger b;";
    NSString *actual = [string stringBySortingPropertyDeclarations];

    XCTAssertEqualObjects(expected, actual);
}

@end

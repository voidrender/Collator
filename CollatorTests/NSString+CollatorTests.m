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

#pragma mark Basic Tests

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
    NSString *expected = @"    @property CustomType *a;\n    @property NSInteger b;";
    NSString *actual = [string stringBySortingPropertyDeclarations];

    XCTAssertEqualObjects(expected, actual);
}

#pragma mark IBOutlets

- (void)testStringBySortingPropertyDeclarations_IBOutletProperties
{
    NSString *string = @"    @property IBOutlet NSString *c;\n    @property NSInteger b;\n    @property IBOutlet CustomType *a;";
    NSString *expected = @"    @property IBOutlet CustomType *a;\n    @property NSInteger b;\n    @property IBOutlet NSString *c;";
    NSString *actual = [string stringBySortingPropertyDeclarations];

    XCTAssertEqualObjects(expected, actual);
}

#pragma mark Attributes

- (void)testStringBySortingPropertyDeclarations_Attributes
{
    NSString *string = @"    @property (nonatomic, strong) NSString *c;\n    @property (nonatomic) NSInteger b;\n    @property (nonatomic, weak, readonly) CustomType *a;";
    NSString *expected = @"    @property (nonatomic, weak, readonly) CustomType *a;\n    @property (nonatomic) NSInteger b;\n    @property (nonatomic, strong) NSString *c;";
    NSString *actual = [string stringBySortingPropertyDeclarations];

    XCTAssertEqualObjects(expected, actual);
}

- (void)testStringBySortingPropertyDeclarations_AttributesWithIBOutlet
{
    NSString *string = @"    @property (nonatomic, weak) IBOutlet NSString *c;\n    @property NSInteger b;\n    @property CustomType *a;";
    NSString *expected = @"    @property CustomType *a;\n    @property NSInteger b;\n    @property (nonatomic, weak) IBOutlet NSString *c;";
    NSString *actual = [string stringBySortingPropertyDeclarations];

    XCTAssertEqualObjects(expected, actual);
}

#pragma mark Comments

- (void)testStringBySortingPropertyDeclarations_BasicComment
{
    NSString *string = @"    @property IBOutlet NSString *c;\n    @property NSInteger b;\n    // A is for awesome!\n    @property CustomType *a;";
    NSString *expected = @"    // A is for awesome!\n    @property CustomType *a;\n    @property NSInteger b;\n    @property IBOutlet NSString *c;";
    NSString *actual = [string stringBySortingPropertyDeclarations];

    XCTAssertEqualObjects(expected, actual);
}

- (void)testStringBySortingPropertyDeclarations_CStyleComment
{
    NSString *string = @"    @property IBOutlet NSString *c;\n    @property NSInteger b;\n    /* A is for awesome! */\n    @property CustomType *a;";
    NSString *expected = @"    /* A is for awesome! */\n    @property CustomType *a;\n    @property NSInteger b;\n    @property IBOutlet NSString *c;";
    NSString *actual = [string stringBySortingPropertyDeclarations];

    XCTAssertEqualObjects(expected, actual);
}

- (void)testStringBySortingPropertyDeclarations_Pragma
{
    NSString *string = @"    @property IBOutlet NSString *c;\n    @property NSInteger b;\n    #pragma mark A\n    @property CustomType *a;";
    NSString *expected = @"    #pragma mark A\n    @property CustomType *a;\n    @property NSInteger b;\n    @property IBOutlet NSString *c;";
    NSString *actual = [string stringBySortingPropertyDeclarations];

    XCTAssertEqualObjects(expected, actual);
}

- (void)testStringBySortingPropertyDeclarations_ExtraWhitespace
{
    NSString *string = @"    @property IBOutlet NSString *c;\n\n\n    @property NSInteger b;\n    @property CustomType *a;";
    NSString *expected = @"    @property CustomType *a;\n\n\n    @property NSInteger b;\n    @property IBOutlet NSString *c;";
    NSString *actual = [string stringBySortingPropertyDeclarations];

    XCTAssertEqualObjects(expected, actual);
}

@end

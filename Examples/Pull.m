/**
 * COPYRIGHT LICENSE: This information contains sample code provided in source code form. You may copy, modify, and distribute
 * these sample programs in any form without payment to IBM® for the purposes of developing, using, marketing or distributing
 * application programs conforming to the application programming interface for the operating platform for which the sample code is written.
 * Notwithstanding anything to the contrary, IBM PROVIDES THE SAMPLE SOURCE CODE ON AN "AS IS" BASIS AND IBM DISCLAIMS ALL WARRANTIES,
 * EXPRESS OR IMPLIED, INCLUDING, BUT NOT LIMITED TO, ANY IMPLIED WARRANTIES OR CONDITIONS OF MERCHANTABILITY, SATISFACTORY QUALITY,
 * FITNESS FOR A PARTICULAR PURPOSE, TITLE, AND ANY WARRANTY OR CONDITION OF NON-INFRINGEMENT. IBM SHALL NOT BE LIABLE FOR ANY DIRECT,
 * INDIRECT, INCIDENTAL, SPECIAL OR CONSEQUENTIAL DAMAGES ARISING OUT OF THE USE OR OPERATION OF THE SAMPLE SOURCE CODE.
 * IBM HAS NO OBLIGATION TO PROVIDE MAINTENANCE, SUPPORT, UPDATES, ENHANCEMENTS OR MODIFICATIONS TO THE SAMPLE SOURCE CODE.
 */

#import <XCTest/XCTest.h>
#import <IBMMobileFirstPlatformFoundation/IBMMobileFirstPlatformFoundation.h>

@interface Pull : XCTestCase

@end

@implementation Pull

- (void)testPull
{
    //This object will point to an error if one occurs.
    NSError* error = nil;
    
    //Destroy first to start with no data and get predictable results in the test.
    [[JSONStore sharedInstance] destroyDataAndReturnError:&error];
    
    //Create the collections objects that will be initialized.
    JSONStoreCollection* people = [[JSONStoreCollection alloc] initWithName:@"people"];
    [people setSearchField:@"id" withType:JSONStore_Integer];
    [people setSearchField:@"ssn" withType:JSONStore_String];
    [people setSearchField:@"name" withType:JSONStore_String];
    
    //Open the collections.
    [[JSONStore sharedInstance] openCollections:@[people] withOptions:nil error:nil];
    
    //TIP: Get data from somewhere (e.g. Adapter). For this example, it is hardcoded.
    NSArray* data = @[ @{@"id" : @1, @"ssn": @"111-22-3333", @"name": @"carlos"},
                       @{@"id" : @2, @"ssn": @"444-55-6666", @"name": @"mike"} ];

    //Add data if it doesn't exist, otherwise use the replace criteria to update existing data.
    int dataChanged = [[people changeData:data withReplaceCriteria:@[@"id", @"ssn"] addNew:YES markDirty:NO error:nil] intValue];
    
    XCTAssertTrue(dataChanged == 2, @"check number of documents changed");
}

@end
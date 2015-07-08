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

@interface Remove : XCTestCase

@end

@implementation Remove

- (void)testRemove
{
    //This object will point to an error if one occurs.
    NSError* error = nil;
    
    //Destroy first to start with no data and get predictable results in the test.
    [[JSONStore sharedInstance] destroyDataAndReturnError:&error];
    
    //Create the collections objects that will be initialized.
    JSONStoreCollection* people = [[JSONStoreCollection alloc] initWithName:@"people"];
    [people setSearchField:@"name" withType:JSONStore_String];
    [people setSearchField:@"age" withType:JSONStore_Integer];
    
    //Open the collections.
    [[JSONStore sharedInstance] openCollections:@[people] withOptions:nil error:nil];
    
    //Add data.
    [[people addData:@[@{@"name" : @"carlos", @"age" : @20}, @{@"name" : @"mike", @"age" : @30}] andMarkDirty:YES withOptions:nil error:nil] intValue];
    
    //Remove document with _id equal to 1.
    int removeResult = [[people removeWithIds:@[@1] andMarkDirty:NO error:nil] intValue];
    
    XCTAssertTrue(removeResult == 1, @"check amount of documents remuved result");
}

@end

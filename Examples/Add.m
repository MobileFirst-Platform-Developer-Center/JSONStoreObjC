/**
* Copyright 2015 IBM Corp.
*
* Licensed under the Apache License, Version 2.0 (the "License");
* you may not use this file except in compliance with the License.
* You may obtain a copy of the License at
*
* http://www.apache.org/licenses/LICENSE-2.0
*
* Unless required by applicable law or agreed to in writing, software
* distributed under the License is distributed on an "AS IS" BASIS,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the License for the specific language governing permissions and
* limitations under the License.
*/

#import <XCTest/XCTest.h>
#import <IBMMobileFirstPlatformFoundation/IBMMobileFirstPlatformFoundation.h>

@interface Add : XCTestCase

@end

@implementation Add

- (void)testAdd
{
    //This object will point to an error if one occurs.
    NSError* error = nil;
    
    //Destroy first to start with no data and get predictable results in the test.
    [[JSONStore sharedInstance] destroyDataAndReturnError:&error];
    
    //Create the collections objects that will be initialized.
    JSONStoreCollection* people = [[JSONStoreCollection alloc] initWithName:@"people"];
    [people setSearchField:@"name" withType:JSONStore_String];
    [people setSearchField:@"age" withType:JSONStore_Integer];
    
    JSONStoreCollection* orders = [[JSONStoreCollection alloc] initWithName:@"orders"];
    [people setSearchField:@"item" withType:JSONStore_String];
    
    //Open the collections.
    [[JSONStore sharedInstance] openCollections:@[people, orders] withOptions:nil error:nil];
    
    //Add data.
    int dataAddedToThePeopleCollection = [[people addData:@[@{@"name" : @"carlos", @"age" : @20}] andMarkDirty:YES withOptions:nil error:nil] intValue];
    int dataAddedToTheOrdersCollection = [[orders addData:@[@{@"item" : @"candy"}] andMarkDirty:YES withOptions:nil error:nil] intValue];

    XCTAssertEqual(dataAddedToThePeopleCollection, 1, @"check data added to the people collection");
    XCTAssertEqual(dataAddedToTheOrdersCollection, 1, @"check data added to the orders collection");
}

@end

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

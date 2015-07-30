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

@interface Clear : XCTestCase

@end

@implementation Clear

- (void)testClear
{
    //This object will point to an error if one occurs.
    NSError* error = nil;
    
    //Destroy first to start with no data and get predictable results in the test.
    [[JSONStore sharedInstance] destroyDataAndReturnError:&error];
    
    //Create the collection object that will be initialized.
    JSONStoreCollection* people = [[JSONStoreCollection alloc] initWithName:@"people"];
    [people setSearchField:@"name" withType:JSONStore_String];
    [people setSearchField:@"age" withType:JSONStore_Integer];
    
    //Open the collections.
    [[JSONStore sharedInstance] openCollections:@[people] withOptions:nil error:nil];
    
    //Add data
    [[people addData:@[@{@"name" : @"carlos", @"age" : @20}] andMarkDirty:YES withOptions:nil error:nil] intValue];
    
    //Clear all data inside the collection.
    BOOL worked = [people clearCollectionWithError:nil];
    
    XCTAssertTrue(worked, @"check clear collection worked");
    
    //Find all documents inside the collection.
    NSArray* results = [people findAllWithOptions:nil error:nil];
    
    XCTAssertEqualObjects(results, @[], @"check find all results");
    
}

@end

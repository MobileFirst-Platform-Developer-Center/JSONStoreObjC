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

@interface Find : XCTestCase

@end

@implementation Find

- (void)testFind
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
    
    //Build a query part.
    JSONStoreQueryPart* queryPart1 = [[JSONStoreQueryPart alloc] init];
    [queryPart1 searchField:@"name" equal:@"carlos"];
    [queryPart1 searchField:@"age" lessOrEqualThan:@20];
    
    //Build the find options.
    JSONStoreQueryOptions* options = [[JSONStoreQueryOptions alloc] init];
    [options sortBySearchFieldAscending:@"name"];
    [options sortBySearchFieldDescending:@"age"];
    [options filterSearchField:@"_id"];
    [options filterSearchField:@"json"];
    [options setLimit:@10];
    [options setOffset:@0];
    
    //Count using the query part built above.
    NSArray* findWithQueryPartResult = [people findWithQueryParts:@[queryPart1] andOptions:options error:nil];
    
    XCTAssertEqualObjects([findWithQueryPartResult[0] valueForKeyPath:@"json.name"], @"carlos", @"check find result");
}

@end

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

@interface Basic : XCTestCase

@end

@implementation Basic

- (void)testBasicScenario
{
    NSError* error = nil;
    
    [[JSONStore sharedInstance] destroyDataAndReturnError:&error];
    
    JSONStoreCollection* people = [[JSONStoreCollection alloc]
                                   initWithName:@"people"];
    
    [people setSearchField:@"name"
                  withType:JSONStore_String];
    
    [people setSearchField:@"age"
                  withType:JSONStore_Integer];
    
    
    [[JSONStore sharedInstance] openCollections:@[people]
                                    withOptions:nil
                                          error:nil];
    
    NSArray* data = @[@{@"name" : @"carlos", @"age" : @20},
                      @{@"name" : @"mike", @"age" : @30}];
    
    [people addData:data andMarkDirty:NO
        withOptions:nil
              error:nil];
    
    NSArray *actualResults = [people findAllWithOptions:nil
                                                  error:nil];
    
    NSArray* expectedResults =
    @[@{ @"_id" : @1,
         @"json" : @{@"name" : @"carlos", @"age" : @20}},
      
      @{ @"_id" : @2,
         @"json" : @{@"name" : @"mike",   @"age" : @30}}];
    
    XCTAssertEqualObjects(actualResults, expectedResults);
}

@end

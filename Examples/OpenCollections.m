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

@interface OpenCollections : XCTestCase

@end

@implementation OpenCollections

- (void)testOpen
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
    
    //Optional options object.
    JSONStoreOpenOptions* options = [JSONStoreOpenOptions new];
    [options setUsername:@"carlos"]; //Optional username, default 'jsonstore'
    [options setPassword:@"123"]; //Optional password, default no password
    
    //Open the collections.
    [[JSONStore sharedInstance] openCollections:@[people, orders] withOptions:options error:nil];
    
    //Get collection accessors.
    NSString* peopleCollectionName = [[JSONStore sharedInstance] getCollectionWithName:@"people"].collectionName;
    NSString* ordersCollectionName = [[JSONStore sharedInstance] getCollectionWithName:@"orders"].collectionName;

    XCTAssertEqualObjects(peopleCollectionName, @"people", @"check people collection name");
    XCTAssertEqualObjects(ordersCollectionName, @"orders", @"check orders collection name");
}

@end

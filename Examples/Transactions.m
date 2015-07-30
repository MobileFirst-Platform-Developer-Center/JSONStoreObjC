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

@interface Transactions : XCTestCase

@end

@implementation Transactions

- (void)testTransactions
{
    //Destroy first to start with no data and get predictable results in the test.
    [[JSONStore sharedInstance] destroyDataAndReturnError:nil];
    
    //Create the collections objects that will be initialized.
    JSONStoreCollection* people = [[JSONStoreCollection alloc] initWithName:@"people"];
    [people setSearchField:@"name" withType:JSONStore_String];
    [people setSearchField:@"age" withType:JSONStore_Integer];
    
    //Open the collections.
    [[JSONStore sharedInstance] openCollections:@[people] withOptions:nil error:nil];
    
    //Start a transaction.
    [[JSONStore sharedInstance] startTransactionAndReturnError:nil];
    
    //This object will point to an error if one occurs.
    NSError* error = nil;
    
    //Add data.
    [[people addData:@[@{@"name" : @"carlos", @"age" : @20}, @{@"name" : @"mike", @"age" : @30}] andMarkDirty:YES withOptions:nil error:&error] intValue];
    
    //Remove data.
    [people removeWithIds:@[@1] andMarkDirty:YES error:&error];
    
    if (error == nil) {
        //Commit the transaction if add and remove did not return an error.
        [[JSONStore sharedInstance] commitTransactionAndReturnError:nil];
    } else {
        //Rollback if add or removed returned an error.
        [[JSONStore sharedInstance] rollbackTransactionAndReturnError:nil];
    }
    
    //Count all documents.
    int countResult = [[people countAllDocumentsAndReturnError:nil] intValue];
    
    XCTAssertTrue(countResult == 1, @"check amount of documents removed result");
}

@end

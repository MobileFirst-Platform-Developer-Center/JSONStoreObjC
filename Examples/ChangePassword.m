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

@interface ChangePassword : XCTestCase

@end

@implementation ChangePassword

- (void)testChangePassword
{
    //This object will point to an error if one occurs.
    NSError* error = nil;
    
    //Destroy first to start with no data and get predictable results in the test.
    [[JSONStore sharedInstance] destroyDataAndReturnError:&error];
    
    //The password should be user input.
    //It is hardcoded in the example for brevity.
    NSString* oldPassword = @"123";
    NSString* newPassword = @"456";
    NSString* username = @"carlos";
    
    //Create the collection object that will be initialized.
    JSONStoreCollection* people = [[JSONStoreCollection alloc] initWithName:@"people"];
    [people setSearchField:@"name" withType:JSONStore_String];
    [people setSearchField:@"age" withType:JSONStore_Integer];
    
    //Optional options object.
    JSONStoreOpenOptions* options = [JSONStoreOpenOptions new];
    [options setUsername:username]; //Optional username, default 'jsonstore'
    [options setPassword:oldPassword]; //Optional password, default no password
    
    //Open the collections.
    [[JSONStore sharedInstance] openCollections:@[people] withOptions:options error:nil];
    
    //Perform the change password operation.
    BOOL worked = [[JSONStore sharedInstance] changeCurrentPassword:oldPassword withNewPassword:newPassword forUsername:username error:nil];
    
    XCTAssertTrue(worked, @"check change password worked");
    
    //Remove the passwords from memory.
    oldPassword = nil;
    newPassword = nil;
}

@end

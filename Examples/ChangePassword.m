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

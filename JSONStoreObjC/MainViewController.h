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

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

#import <IBMMobileFirstPlatformFoundation/IBMMobileFirstPlatformFoundation.h>

static NSString *DEFAULT_USERNAME = @"jsonstore";


static NSString *INIT_FIRST_MESSAGE = @"PERSISTENT_STORE_NOT_OPEN";
static NSString *INIT_MESSAGE = @"Collection initialized";
static NSString *DESTROY_MESSAGE = @"Destroy finished successfully";
static NSString *CLOSE_MESSAGE = @"JSONStore closed";
static NSString *REMOVE_COLLECTION_MESSAGE = @"Removed all data in the collection";
static NSString *ADD_MESSAGE = @"Data added to the collection";

static NSString *REMOVE_MESSAGE = @"Document with id:%d removed";
static NSString *REPLACE_MESSAGE = @"Document with id:%d replaced successfully";
static NSString *NOT_FOUND_MESSAGE = @"Document with id:%d NOT FOUND";


static NSString *LOAD_FROM_ADAPTER_MESSAGE = @"New documents loaded from adapter: %d";
static NSString *PUSH_FINISH_MESSAGE = @"Push finished";
static NSString *COUNT_ALL_MESSAGE = @"Documents in the collection: %d";
static NSString *DORTY_DOCS_MESSAGE = @"Dirty Documents in the collection: %d";
static NSString *DOCS_FOUND_MESSAGE = @"Documents found: %d";
static NSString *UPDATE_DOCS_MESSAGE = @"Documents updated: %d";
static NSString *COUNT_ALL_BY_NAME_MESSAGE = @"Documents in the collection with name(%@) : %d";
static NSString *PASSWORD_CHANGE_MESSAGE = @"Password changed successfully";


@interface MainViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIScrollView *consoleScrollView;


@property (weak, nonatomic) IBOutlet UIButton *mainButton;
@property (weak, nonatomic) IBOutlet UITextView *consoleTextView;

@property (weak, nonatomic) IBOutlet UITextField *userTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *enterNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *enterAgeTextField;
@property (weak, nonatomic) IBOutlet UITextField *searchTextField;
@property (weak, nonatomic) IBOutlet UITextField *limitTextField;
@property (weak, nonatomic) IBOutlet UITextField *offsetTextField;
@property (weak, nonatomic) IBOutlet UITextField *findByIdTextField;
@property (weak, nonatomic) IBOutlet UITextField *replaceNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *replaceAgeTextField;
@property (weak, nonatomic) IBOutlet UITextField *replaceIdTextField;
@property (weak, nonatomic) IBOutlet UITextField *removeByIdTextField;
@property (weak, nonatomic) IBOutlet UITextField *countByNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *changePasswordOldTextField;
@property (weak, nonatomic) IBOutlet UITextField *changePasswordNewTextField;
@property (weak, nonatomic) IBOutlet UITextField *changePasswordUserTextField;


- (IBAction)initButtonClick:(id)sender;
- (IBAction)closeButtonClick:(id)sender;
- (IBAction)destroyButtonClick:(id)sender;
- (IBAction)removeCollectionButtonClick:(id)sender;
- (IBAction)addDataButtonClick:(id)sender;
- (IBAction)findByNameButtonClick:(id)sender;
- (IBAction)findByAgeButtonClick:(id)sender;
- (IBAction)findAllButtonClick:(id)sender;
- (IBAction)findByIdButtonClick:(id)sender;
- (IBAction)replaceByIdButtonClick:(id)sender;
- (IBAction)removeByIdButtonClick:(id)sender;
- (IBAction)loadDataFromAdapterButtonClick:(id)sender;
- (IBAction)getDirtyDocumentsButtonClick:(id)sender;
- (IBAction)pushChangesToAdapterButtonClick:(id)sender;
- (IBAction)countAllButtonClick:(id)sender;
- (IBAction)countByNameButtonClick:(id)sender;
- (IBAction)changePasswordButtonClick:(id)sender;
- (IBAction)getFileInfoButtonClick:(id)sender;

- (void) loadPeopleIntoCollection:(NSArray*) data;
- (void) logResults:(NSArray*) results;
- (void) logResults:(NSArray*) results withMessage:(NSString*) withMessage;
- (void) logMessage:(NSString*) message;
- (void) logError:(NSString*) error;

@end

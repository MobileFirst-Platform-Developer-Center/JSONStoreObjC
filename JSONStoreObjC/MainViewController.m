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
#import "MainViewController.h"


// load data from adapter
@interface LoadFromAdapter : NSObject<WLDelegate>
@end

@implementation LoadFromAdapter {
    MainViewController *viewController;
}
-(void)setViewController:(MainViewController *)controller {
    viewController = controller;
}
-(void)onSuccess:(WLResponse *)response {
    NSDictionary *dictionaryResponse = [response getResponseJson];
    
    NSArray *people = [dictionaryResponse objectForKey:@"peopleList"];
    
    [viewController loadPeopleIntoCollection:people];
}
-(void)onFailure:(WLFailResponse *)response {
    [viewController logError:[response description]];
}
@end


// push data to adapter
@interface PushToAdapter :NSObject<WLDelegate>
@end

@implementation PushToAdapter {
    MainViewController *viewController;
    JSONStoreCollection *dataCollection;
    NSArray *dataList;
}
-(void)setDataList:(NSArray *)list {
    dataList = list;
}
-(void)setCollection:(JSONStoreCollection *)collection {
    dataCollection = collection;
}
-(void)setViewController:(MainViewController *)controller {
    viewController = controller;
}
-(void)onSuccess:(WLResponse *)response {
    [viewController logMessage:PUSH_FINISH_MESSAGE];
    
    [dataCollection markDocumentsClean:dataList error:nil];
}
-(void)onFailure:(WLFailResponse *)response {
    [viewController logError:[response description]];
}
@end


@interface MainViewController ()

@end


@implementation MainViewController {
    JSONStoreCollection *people;
    WLClient *client;
}

-(void)loadPeopleIntoCollection:(NSArray*) data {
    NSError* error = nil;
    
    int dataChanged = [[people changeData:data withReplaceCriteria:nil addNew:YES markDirty:NO error:&error] intValue];
    
    
    [self logMessage:[[NSString alloc] initWithFormat:LOAD_FROM_ADAPTER_MESSAGE, dataChanged]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    client = [[WLClient sharedInstance] init];
    
    [[self consoleTextView] sizeToFit];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


-(void)viewDidAppear:(BOOL)animated
{
    [[self scrollView] setContentSize:CGSizeMake(0, 1088)];
    [[self scrollView] setTranslatesAutoresizingMaskIntoConstraints:YES];
    
    
//    [[self consoleScrollView] setContentSize:CGSizeMake(0, 5)];
//    [[self consoleScrollView] setContentOffset:CGPointZero];
//    [[self consoleScrollView] setTranslatesAutoresizingMaskIntoConstraints:YES];
    
//    [self consoleScrollView].scrollEnabled = YES;
    
    [[self consoleTextView] setBackgroundColor:[UIColor blackColor]];
    [[self consoleTextView] setScrollEnabled:YES];
    
//    [[self consoleTextView] setContentSize:CGSizeMake(0, 5)];
    [[self consoleTextView] setUserInteractionEnabled:YES];
    [[self consoleTextView] setEditable:NO];
}


-(void)resetFieldError:(UITextField*) textField {
    textField.layer.cornerRadius=5.0f;
    textField.layer.masksToBounds=YES;
    textField.layer.borderColor=[[UIColor grayColor]CGColor];
    textField.layer.borderWidth= 0.5f;
}

-(void)setTextFieldError:(UITextField*) textField {
    textField.layer.cornerRadius=5.0f;
    textField.layer.masksToBounds=YES;
    textField.layer.borderColor=[[UIColor redColor]CGColor];
    textField.layer.borderWidth= 1.0f;
}

-(void) logResults:(NSArray*) results {
    [self logResults:results withMessage:nil];
}

-(void) logResults:(NSArray*) results withMessage:(NSString*) withMessage {
    
    NSString *message = nil;
    
    if(withMessage != nil) {
        message = [[NSString alloc] initWithFormat:@"%@:\n", withMessage];
    }
    else {
        message = [[NSString alloc] initWithFormat:@"Results: %d\n", [results count]];
    }
    
    for(id object in results) {
        message = [message stringByAppendingFormat:@" %@", object];
    }
    
    
    [[self consoleTextView] setTextColor:[[UIColor alloc] initWithRed:1 green:1 blue:1 alpha:1]];
    [[self consoleTextView] setText:message];
    
    [self.view endEditing:YES];
}

-(void) logMessage:(NSString*) message {
    [[self consoleTextView] setTextColor:[[UIColor alloc] initWithRed:1 green:1 blue:1 alpha:1]];
    [[self consoleTextView] setText:message];
    
    [self.view endEditing:YES];
}

-(void) logError:(NSString*) error {
    [[self consoleTextView] setTextColor:[[UIColor alloc] initWithRed:0.8 green:0 blue:0 alpha:1]];
    [[self consoleTextView] setText:error];
}

- (IBAction)initButtonClick:(id)sender {
    
    NSError* error = nil;
    
    people = [[JSONStoreCollection alloc] initWithName:@"people"];
    [people setSearchField:@"name" withType:JSONStore_String];
    [people setSearchField:@"age" withType:JSONStore_Integer];
    
    JSONStoreOpenOptions* options = [JSONStoreOpenOptions new];
    
    NSString *usernameText = [[self userTextField] text];
    NSString *passwordText = [[self passwordTextField] text];
    
    if(usernameText.length == 0 ) {
        usernameText = DEFAULT_USERNAME;
    }
    
    [options setUsername:usernameText];
    
    if(passwordText.length > 0) {
        [options setPassword:passwordText];
    }
    
    BOOL openCollections = [[JSONStore sharedInstance] openCollections:@[people] withOptions:options error:&error];
    
    if(openCollections) {
        [self logMessage:INIT_MESSAGE];
        
        [[self userTextField] setText:nil];
        [[self passwordTextField] setText:nil];
    }
    else {
        [self logError:[error description]];
    }
    
    
}

- (IBAction)closeButtonClick:(id)sender {
    NSError* error = nil;
    
    BOOL closeCollection = [[JSONStore sharedInstance] closeAllCollectionsAndReturnError:&error];
    
    if(closeCollection) {
        [self logMessage:CLOSE_MESSAGE];
    }
    else {
        [self logError:[error description]];
    }
}

- (IBAction)destroyButtonClick:(id)sender {
    
    NSError* error = nil;
    
    BOOL destroyCollection = [[JSONStore sharedInstance] destroyDataAndReturnError:&error];
    
    
    if(destroyCollection) {
        [self logMessage:DESTROY_MESSAGE];
    }
    else {
        [self logError:[error description]];
    }
    
}

- (IBAction)removeCollectionButtonClick:(id)sender {

    if(!people) {
        [self logError:INIT_FIRST_MESSAGE];
        return;
    }

    NSError* error = nil;
    
    BOOL removeCollection = [people removeCollectionWithError:&error];
    
    if(removeCollection) {
        [self logMessage:REMOVE_COLLECTION_MESSAGE];
    }
    else {
        [self logError:[error description]];
    }
}

- (IBAction)addDataButtonClick:(id)sender {
    
    if(!people) {
        [self logError:INIT_FIRST_MESSAGE];
        return;
    }
    
    [self resetFieldError:[self enterNameTextField]];
    [self resetFieldError:[self enterAgeTextField]];
    
    NSString *nameText = [[self enterNameTextField] text];
    NSString *ageString = [[self enterAgeTextField] text];
    
    NSNumber *age = [[NSNumber alloc] initWithInteger:[ageString integerValue]];
    
    if(nameText.length == 0 || [age intValue] == 0) {
        
        if(nameText.length == 0){
            [self setTextFieldError:[self enterNameTextField]];
        }
        
        if([age intValue] == 0) {
            [self setTextFieldError:[self enterAgeTextField]];
        }
        
        return;
    }
    
    NSError* error = nil;
    
    NSDictionary *data = @{@"name" : nameText, @"age" : age};

    int added = [[people addData:@[data] andMarkDirty:YES withOptions:nil error:&error] intValue];
    
    if(added == 1) {
        [self logMessage:ADD_MESSAGE];
        
        [[self enterNameTextField] setText:nil];
        [[self enterAgeTextField] setText:nil];
    }
    else {
        [self logError:[error description]];
    }
    
}

- (IBAction)findByNameButtonClick:(id)sender {
    
    if(!people) {
        [self logError:INIT_FIRST_MESSAGE];
        return;
    }
    
    [self resetFieldError:[self searchTextField]];
    
    NSString *searchKeyword = [[self searchTextField] text];
    NSString *limitText = [[self limitTextField] text];
    NSString *offsetText = [[self offsetTextField] text];
    
    if(searchKeyword.length == 0) {
        [self setTextFieldError:[self searchTextField]];
        
        return;
    }
    
    JSONStoreQueryOptions* options = [[JSONStoreQueryOptions alloc] init];
    [options sortBySearchFieldAscending:@"name"];
    [options sortBySearchFieldDescending:@"age"];
    [options filterSearchField:@"_id"];
    [options filterSearchField:@"json"];
    
    if(limitText.length > 0 && [limitText intValue] > 0) {
        [options setLimit:[[NSNumber alloc] initWithInteger:[limitText integerValue]]];
    }
    
    if (offsetText.length > 0) {
        [options setOffset:[[NSNumber alloc] initWithInteger:[offsetText integerValue]]];
    }
    
    NSError* error = nil;
    
    JSONStoreQueryPart* query = [[JSONStoreQueryPart alloc] init];
    [query searchField:@"name" like:searchKeyword];
    
    NSArray* findWithQueryPartResult = [people findWithQueryParts:@[query] andOptions:options error:&error];
    
    if(error) {
        [self logError:[error description]];
        return;
    }
    
    [self logResults:findWithQueryPartResult];
}

- (IBAction)findByAgeButtonClick:(id)sender {
    
    if(!people) {
        [self logError:INIT_FIRST_MESSAGE];
        return;
    }
    
    [self resetFieldError:[self searchTextField]];
    
    NSError* error = nil;
    
    NSString *searchKeyword = [[self searchTextField] text];
    NSString *limitText = [[self limitTextField] text];
    NSString *offsetText = [[self offsetTextField] text];
    
    NSNumber *age = [[NSNumber alloc] initWithInteger:[searchKeyword integerValue]];
    
    if([age intValue] == 0) {
        [self setTextFieldError:[self searchTextField]];
        
        return;
    }
    

    JSONStoreQueryPart* query = [[JSONStoreQueryPart alloc] init];
    [query searchField:@"age" equal:[age stringValue]];
    
    JSONStoreQueryOptions* options = [[JSONStoreQueryOptions alloc] init];
    [options sortBySearchFieldAscending:@"name"];
    [options sortBySearchFieldDescending:@"age"];
    [options filterSearchField:@"_id"];
    [options filterSearchField:@"json"];
    
    if(limitText.length > 0 && [limitText intValue] > 0) {
        [options setLimit:[[NSNumber alloc] initWithInteger:[limitText integerValue]]];
    }
    
    if (offsetText.length > 0) {
        [options setOffset:[[NSNumber alloc] initWithInteger:[offsetText integerValue]]];
    }
    

    NSArray* findWithQueryPartResult = [people findWithQueryParts:@[query] andOptions:options error:&error];
    
    if(error) {
        [self logError:[error description]];
        return;
    }
    
    [self logResults:findWithQueryPartResult];
    
}

- (IBAction)findAllButtonClick:(id)sender {
    
    if(!people) {
        [self logError:INIT_FIRST_MESSAGE];
        return;
    }

    NSError* error = nil;
    
    NSString *limitText = [[self limitTextField] text];
    NSString *offsetText = [[self offsetTextField] text];
    
    JSONStoreQueryOptions* options = [[JSONStoreQueryOptions alloc] init];
    [options sortBySearchFieldAscending:@"name"];
    [options sortBySearchFieldDescending:@"age"];
    [options filterSearchField:@"_id"];
    [options filterSearchField:@"json"];
    
    if(limitText.length > 0 && [limitText intValue] > 0) {
        [options setLimit:[[NSNumber alloc] initWithInteger:[limitText integerValue]]];
    }
    
    if (offsetText.length > 0) {
        [options setOffset:[[NSNumber alloc] initWithInteger:[offsetText integerValue]]];
    }
    
    NSArray* findWithQueryPartResult = [people findAllWithOptions:options error:&error];
    
    if(error) {
        [self logError:[error description]];
        return;
    }
    
    [self logResults:findWithQueryPartResult];
}

- (IBAction)findByIdButtonClick:(id)sender {
    
    if(!people) {
        [self logError:INIT_FIRST_MESSAGE];
        return;
    }

    [self resetFieldError:[self findByIdTextField]];
    
    NSError* error = nil;
    
    NSString *idText = [[self findByIdTextField] text];
    
    NSNumber *userId = [[NSNumber alloc] initWithInteger:[idText integerValue]];
    
    if([userId intValue] == 0) {
        [self setTextFieldError:[self findByIdTextField]];
        
        return;
    }
    
    JSONStoreQueryPart* query = [[JSONStoreQueryPart alloc] init];
    [query searchField:@"age" equal:[userId stringValue]];
    
    JSONStoreQueryOptions* options = [[JSONStoreQueryOptions alloc] init];
    [options sortBySearchFieldAscending:@"name"];
    [options sortBySearchFieldDescending:@"age"];
    [options filterSearchField:@"_id"];
    [options filterSearchField:@"json"];
    

    NSArray* findWithQueryPartResult = [people findWithIds:@[userId] andOptions:options error:&error];
    
    if(error) {
        [self logError:[error description]];
        return;
    }
    
    [self logResults:findWithQueryPartResult];
}

- (IBAction)replaceByIdButtonClick:(id)sender {
    
    if(!people) {
        [self logError:INIT_FIRST_MESSAGE];
        return;
    }
    
    NSString *nameText = [[self replaceNameTextField] text];
    NSString *ageString = [[self replaceAgeTextField] text];
    NSString *idText = [[self replaceIdTextField] text];
    
    NSNumber *userAge = [[NSNumber alloc] initWithInteger:[ageString integerValue]];
    NSNumber *userId = [[NSNumber alloc] initWithInteger:[idText integerValue]];
    
    if([nameText length] == 0) {
        [self setTextFieldError:[self replaceNameTextField]];
        
        return;
    }
    
    if([userAge intValue] == 0) {
        [self setTextFieldError:[self replaceAgeTextField]];
        
        return;
    }
    
    if([userId intValue] == 0) {
        [self setTextFieldError:[self replaceIdTextField]];
        
        return;
    }
    
    NSError* error = nil;
    
    [[JSONStore sharedInstance] openCollections:@[people] withOptions:nil error:nil];
    
    NSDictionary *replacementDoc = @{@"_id": userId, @"json" : @{@"name" : nameText, @"age" : userAge}};
    
    int replaceResult = [[people replaceDocuments:@[replacementDoc] andMarkDirty:YES error:&error] intValue];
    
    if(error) {
        [self logError:[error description]];
        return;
    }
    
    if(replaceResult == 1) {
        [[self replaceNameTextField] setText:nil];
        [[self replaceAgeTextField] setText:nil];
        [[self replaceIdTextField] setText:nil];
        
        [self logMessage:[[NSString alloc] initWithFormat:@"Document with id:%d replaced successfully.", [userId intValue]]];
    }
    
    
}

- (IBAction)removeByIdButtonClick:(id)sender {
    
    if(!people) {
        [self logError:INIT_FIRST_MESSAGE];
        return;
    }
    
    NSString *userIdText = [[self removeByIdTextField] text];
    
    NSNumber *userId = [[NSNumber alloc] initWithInt:[userIdText intValue]];
    
    
    if([userId intValue] == 0) {
        [self setTextFieldError:[self removeByIdTextField]];
        return;
    }
    
    NSError *error = nil;
    
    int removeResult = [[people removeWithIds:@[userId] andMarkDirty:YES error:&error] intValue];
    
    if(removeResult == 1) {
        [self logMessage:[[NSString alloc] initWithFormat:REMOVE_MESSAGE, userId]];
    }
    else {
        [self logError:[error description]];
    }
}

- (IBAction)loadDataFromAdapterButtonClick:(id)sender {
    
    if(!people) {
        [self logError:INIT_FIRST_MESSAGE];
        return;
    }
    
    WLProcedureInvocationData *invocationData = [[WLProcedureInvocationData alloc] initWithAdapterName:@"People" procedureName:@"getPeople"];
    
    LoadFromAdapter *loadDelegate =  [[LoadFromAdapter alloc] init];
    [loadDelegate setViewController:self];
    
    [client invokeProcedure:invocationData withDelegate:loadDelegate];
}

- (IBAction)getDirtyDocumentsButtonClick:(id)sender {
    
    if(!people) {
        [self logError:INIT_FIRST_MESSAGE];
        return;
    }

    NSError* error = nil;
    
    NSArray *dirtyDocs = [people allDirtyAndReturnError:&error];
    
    if(error) {
        [self logError:[error description]];
        return;
    }
    
    [self logResults:dirtyDocs];
    
}
- (IBAction)pushChangesToAdapterButtonClick:(id)sender {
    
    if(!people) {
        [self logError:INIT_FIRST_MESSAGE];
        return;
    }
    
    NSError* error = nil;
    
    NSArray *dirtyDocs = [people allDirtyAndReturnError:&error];

    WLProcedureInvocationData *invocationData = [[WLProcedureInvocationData alloc] initWithAdapterName:@"People" procedureName:@"pushPeople"];

    [invocationData setParameters:@[dirtyDocs]];
    
    PushToAdapter *pushDelegate =  [[PushToAdapter alloc] init];
    [pushDelegate setCollection:people];
    [pushDelegate setDataList:dirtyDocs];

    [pushDelegate setViewController:self];
    
    
    [client invokeProcedure:invocationData withDelegate:pushDelegate];
}

- (IBAction)countAllButtonClick:(id)sender {
    
    if(!people) {
        [self logError:INIT_FIRST_MESSAGE];
        return;
    }
    
    NSError* error = nil;
    
    int countAllResult = [[people countAllDocumentsAndReturnError:&error] intValue];
    
    if(error) {
        [self logError:[error description]];
        return;
    }
    
    [self logMessage:[[NSString alloc] initWithFormat:COUNT_ALL_MESSAGE, countAllResult]];
}

- (IBAction)countByNameButtonClick:(id)sender {
    
    if(!people) {
        [self logError:INIT_FIRST_MESSAGE];
        return;
    }

    [self resetFieldError:[self countByNameTextField]];
    
    NSError* error = nil;
    
    NSString *nameString = [[self countByNameTextField] text];
    
    if([nameString length] == 0) {
        [self setTextFieldError:[self countByNameTextField]];
        
        return;
    }
    
    JSONStoreQueryPart* query = [[JSONStoreQueryPart alloc] init];
    [query searchField:@"name" equal:nameString];
    
    int countAllByName = [[people countWithQueryParts:@[query] error:&error] intValue];
    
    if(error) {
        [self logError:[error description]];
        return;
    }
    
    [self logMessage:[[NSString alloc] initWithFormat:COUNT_ALL_BY_NAME_MESSAGE, nameString, countAllByName]];
    
}

- (IBAction)changePasswordButtonClick:(id)sender {
    
    if(!people) {
        [self logError:INIT_FIRST_MESSAGE];
        return;
    }
    
    NSString *oldPassword = [[self changePasswordOldTextField] text];
    NSString *newPassword = [[self changePasswordNewTextField] text];
    
    NSString *username = [[self changePasswordUserTextField] text];
    
    
    NSError* error = nil;
    
    
    JSONStoreCollection* peopleCollection = [[JSONStoreCollection alloc] initWithName:@"people"];
    [peopleCollection setSearchField:@"name" withType:JSONStore_String];
    [peopleCollection setSearchField:@"age" withType:JSONStore_Integer];
    
    JSONStoreOpenOptions* options = [JSONStoreOpenOptions new];
    
    if([username length] == 0) {
        username = DEFAULT_USERNAME;
    }
    
    [options setUsername:username];
    
    [options setPassword:oldPassword];
    
    [[JSONStore sharedInstance] openCollections:@[peopleCollection] withOptions:options error:&error];
    
    if(error) {
        [self logError:[error description]];
        return;
    }
    
    error = nil;
    
    BOOL passwordChanged = [[JSONStore sharedInstance] changeCurrentPassword:oldPassword withNewPassword:newPassword forUsername:username error:&error];
    
    if(passwordChanged) {
        [self logMessage:PASSWORD_CHANGE_MESSAGE];
    }
    else {
        [self logError:[error description]];
    }
}

- (IBAction)getFileInfoButtonClick:(id)sender {
    
    NSError *error = nil;

    NSArray* results = [[JSONStore sharedInstance] fileInfoAndReturnError:&error];
    
    if(error) {
        [self logError:[error description]];
        return;
    }
    
    [self logResults:results withMessage:@"FileInfo"];
    
}
@end

//
//  ListPeopleViewController.m
//  LoginGooglePlus
//
//  Created by Duong Nguyen on 7/15/14.
//  Copyright (c) 2014 ivc. All rights reserved.
//

#import "ListPeopleViewController.h"
#import <GoogleOpenSource/GoogleOpenSource.h>
#import <GooglePlus/GooglePlus.h>

@interface ListPeopleViewController ()

@end

@implementation ListPeopleViewController
{
    UIImage *_placeholderAvatar;
    NSArray *_peopleList;
    NSMutableArray *_selectedPeopleList;
    NSMutableArray *_peopleImageList;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    self.mTableView.delegate = self;
    self.mTableView.dataSource = self;
    _selectedPeopleList = [NSMutableArray array];
    _placeholderAvatar = [UIImage imageNamed:@"PlaceholderAvatar.png"];
    self.status = @"Loading people...";
    
    [self logInGooglePlus];
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDelegate/UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _peopleList.count;
}

- (NSString *)tableView:(UITableView *)tableView
titleForHeaderInSection:(NSInteger)section {
    return self.status;
}

//- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
//    return self.allowSelection;
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * const kCellIdentifier = @"Cell";
    UITableViewCell *cell =
    [tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:kCellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    // Configure the cell by extracting a person's name and image from the list
    // of people.
    if ((NSUInteger)indexPath.row < _peopleList.count) {
        GTLPlusPerson *person = _peopleList[indexPath.row];
        if ([person.displayName isEqualToString:@"Hung Cao"]) {
            NSString *birthDay = person.birthday;
            NSLog(@"");
        }
        NSString *name = person.displayName;
        cell.textLabel.text = name;
        
        if ((NSUInteger)indexPath.row < [_peopleImageList count] &&
            ![[_peopleImageList objectAtIndex:indexPath.row]
              isEqual:[NSNull null]]) {
                cell.imageView.image =
                [[UIImage alloc]
                 initWithData:[_peopleImageList objectAtIndex:indexPath.row]];
            } else {
                 cell.imageView.image = _placeholderAvatar;
            }
        if (self.allowSelection && [_selectedPeopleList containsObject:person.identifier]) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        } else {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    GTLPlusPerson *person = _peopleList[indexPath.row];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell.accessoryType == UITableViewCellAccessoryNone) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        [_selectedPeopleList addObject:person.identifier];
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
        [_selectedPeopleList removeObject:person.identifier];
    }
}

- (void)logInGooglePlus
{
    GPPSignIn *signIn = [GPPSignIn sharedInstance];
    signIn.shouldFetchGooglePlusUser = YES;
    //signIn.shouldFetchGoogleUserID = YES;
    //signIn.shouldFetchGoogleUserEmail = YES;  // Uncomment to get the user's email
    
    // You previously set kClientId in the "Initialize the Google+ client" step
    signIn.clientID = @"165392416687-t78t889dki4htr5li8qkgb7b8jqqbulo.apps.googleusercontent.com";
    
    // Uncomment one of these two statements for the scope you chose in the previous step
    signIn.scopes = @[ kGTLAuthScopePlusLogin ];  // "https://www.googleapis.com/auth/plus.login" scope
    //signIn.scopes = @[ @"profile" ];            // "profile" scope
    
    // Optional: declare signIn.actions, see "app activities"
    signIn.delegate = self;
    
    [signIn authenticate];
}

-(void)finishedWithAuth: (GTMOAuth2Authentication *)auth
                  error: (NSError *) error {
    [self listPeople:kGTLPlusCollectionVisible];
}

#pragma mark - Helper methods

- (void)listPeople:(NSString *)collection {
    _peopleList = nil;
    _peopleImageList = nil;
    [self.mTableView reloadData];
    
    // 1. Create a |GTLQuery| object to list people that are visible to this
    // sample app.
    GTLQueryPlus *query =
    [GTLQueryPlus queryForPeopleListWithUserId:@"me"
                                    collection:collection];
    
    // 2. Execute the query.
    [[[GPPSignIn sharedInstance] plusService] executeQuery:query
                                         completionHandler:^(GTLServiceTicket *ticket,
                                                             GTLPlusPeopleFeed *peopleFeed,
                                                             NSError *error) {
                                             if (error) {
                                                 GTMLoggerError(@"Error: %@", error);
                                                 self.status = [NSString stringWithFormat:@"Error: %@", error];
                                                 [self.mTableView reloadData];
                                             } else {
                                                 // Get an array of people from |GTLPlusPeopleFeed| and reload
                                                 // the table view.
                                                 _peopleList = peopleFeed.items;
                                                 
                                                 // Render the status of the Google+ request.
                                                 NSNumber *count = peopleFeed.totalItems;
                                                 if (count.intValue == 1) {
                                                     self.status = @"1 person in your circles";
                                                 } else {
                                                     self.status = [NSString stringWithFormat:
                                                                    @"%@ people in your circles", count];
                                                 }
                                                 [self.mTableView reloadData];
                                                 
                                                 dispatch_queue_t backgroundQueue =
                                                 dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,
                                                                           0);
                                                 dispatch_async(backgroundQueue, ^{
                                                     [self fetchPeopleImages];
                                                 });
                                             }
                                         }];
}

- (void)fetchPeopleImages {
    NSInteger index = 0;
    _peopleImageList =
    [[NSMutableArray alloc] initWithCapacity:[_peopleList count]];
    for (GTLPlusPerson *person in _peopleList) {
        NSData *imageData = nil;
        NSString *imageURLString = person.image.url;
        if (imageURLString) {
            NSURL *imageURL = [NSURL URLWithString:imageURLString];
            imageData = [NSData dataWithContentsOfURL:imageURL];
        }
        if (imageData) {
            [_peopleImageList setObject:imageData atIndexedSubscript:index];
            
            NSIndexPath *path = [NSIndexPath indexPathForItem:index inSection:0];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.mTableView reloadRowsAtIndexPaths:@[path]
                                       withRowAnimation:UITableViewRowAnimationNone];
            });
        } else {
            [_peopleImageList setObject:[NSNull null] atIndexedSubscript:index];
        }
        ++index;
    }
}

- (IBAction) didTapShare: (id)sender {
    id<GPPNativeShareBuilder> shareBuilder = [[GPPShare sharedInstance] nativeShareDialog];
    
    // Set any prefilled text that you might want to suggest
    [shareBuilder setPrefillText:@"Achievement unlocked! I just scored 99 points. Can you beat me?"];
    
    NSString *fileName = @"food.jpeg";
    UIImage *img = [UIImage imageNamed:fileName];
    [shareBuilder attachImage:img];
     
     [shareBuilder open];
}

@end

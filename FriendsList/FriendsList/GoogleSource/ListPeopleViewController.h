//
//  ListPeopleViewController.h
//  LoginGooglePlus
//
//  Created by Duong Nguyen on 7/15/14.
//  Copyright (c) 2014 ivc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GooglePlus/GooglePlus.h>

@class GPPSignInButton;

@interface ListPeopleViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, GPPSignInDelegate>

@property(copy, nonatomic) NSString *status;
@property (strong, nonatomic) IBOutlet UITableView *mTableView;

@property (strong, nonatomic) IBOutlet GPPSignInButton *signInButton;
// Whether or not the view controller allow people selection.
@property (nonatomic, assign) BOOL allowSelection;

@end

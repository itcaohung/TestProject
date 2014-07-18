//
//  HomeViewController.m
//  FriendsList
//
//  Created by Duong Nguyen on 7/17/14.
//  Copyright (c) 2014 Home. All rights reserved.
//

#import "HomeViewController.h"
#import <GoogleOpenSource/GoogleOpenSource.h>
#import <GooglePlus/GooglePlus.h>
#import "ListPeopleViewController.h"

@interface HomeViewController ()

@end

@implementation HomeViewController

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
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (IBAction)showActionSheet:(id)sender {
    UIActionSheet *popup = [[UIActionSheet alloc] initWithTitle:@"Select Sharing option:" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:
                            @"Abc",
                            @"LINE",
                            @"Facebook",
                            @"Google+",
                            @"Twitter",
                            nil];
    popup.tag = 1;
    [popup showInView:[UIApplication sharedApplication].keyWindow];
}

- (void)actionSheet:(UIActionSheet *)popup clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    switch (popup.tag) {
        case 1: {
            switch (buttonIndex) {
                case 0:
                    break;
                case 1:
                    break;
                case 2:
                    break;
                case 3:
                    [self goToFriendsListGoogleplus];
                    break;
                case 4:
                    break;
                default:
                    break;
            }
            break;
        }
        default:
            break;
    }
}

- (void)goToFriendsListGoogleplus
{
    ListPeopleViewController *viewController = [[ListPeopleViewController alloc]init];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)presentSignInViewController:(UIViewController *)viewController {
    // This is an example of how you can implement it if your app is navigation-based.
    [[self navigationController] pushViewController:viewController animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

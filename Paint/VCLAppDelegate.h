//
//  VCLAppDelegate.h
//  Paint
//
//  Created by Victor de Lima on 29/07/14.
//  Copyright (c) 2014 Victor de Lima. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VCLMainViewController.h"
#import "VCLMainView.h"
@interface VCLAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic) VCLMainView *mainView;
@end

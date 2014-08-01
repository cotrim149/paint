//
//  VCLMainViewController.m
//  Paint
//
//  Created by Victor de Lima on 29/07/14.
//  Copyright (c) 2014 Victor de Lima. All rights reserved.
//

#import "VCLMainViewController.h"

@interface VCLMainViewController ()

@end

@implementation VCLMainViewController

//- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
//{
//    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
//    if (self) {
//        // Custom initialization
//    }
//    return self;
//}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view = [[VCLMainView alloc] initWithFrame:CGRectZero];
}


@end

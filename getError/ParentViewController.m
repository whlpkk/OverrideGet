//
//  ParentViewController.m
//  getError
//
//  Created by YZK on 2018/10/24.
//  Copyright © 2018 YZK. All rights reserved.
//

#import "ParentViewController.h"
#import "MyViewController.h"

@interface ParentViewController ()

@end

@implementation ParentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    MyViewController *vc = [[MyViewController alloc] init];
    [vc setLabelText:@"123"];
    [self.view addSubview:vc.view];
    [self addChildViewController:vc];
    [vc didMoveToParentViewController:self];
}


@end

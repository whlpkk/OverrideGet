//
//  ViewController.m
//  getError
//
//  Created by YZK on 2018/10/24.
//  Copyright © 2018 YZK. All rights reserved.
//

#import "ViewController.h"
#import "ParentViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gotoNext)];
    [self.view addGestureRecognizer:tap];
}

- (void)gotoNext {
    ParentViewController *vc = [[ParentViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}


@end

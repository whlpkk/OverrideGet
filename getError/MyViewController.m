//
//  MyViewController.m
//  getError
//
//  Created by YZK on 2018/10/24.
//  Copyright © 2018 YZK. All rights reserved.
//

#import "MyViewController.h"

@interface MyViewController ()
@property (nonatomic, strong) UILabel *label;
@end

@implementation MyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:self.label];
//    [self.view addSubview:[self setupLabel]];
}

- (void)setLabelText:(NSString *)text {
    self.label.text = text;
}

- (UILabel *)label {
    if (!_label) {
        _label = [[UILabel alloc] initWithFrame:self.view.bounds];
        _label.backgroundColor = [UIColor redColor];
    }
    return _label;
}

- (UILabel *)setupLabel {
    if (!_label) {
        _label = [[UILabel alloc] initWithFrame:self.view.bounds];
        _label.backgroundColor = [UIColor redColor];
    }
    return _label;
}

@end

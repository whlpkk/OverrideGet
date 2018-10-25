# UIViewController中使用get方法创建view的弊端

日常的iOS开发过程中，创建ViewController，经常通过重写get方法创建视图，以使`viewDidLoad`方法里面的代码更简洁，看上去条理更清晰。但是实际上这种方法是存在隐患的，看下面的代码例子：

``` objc
// MyViewController.h
@interface MyViewController : UIViewController
- (void)setLabelText:(NSString *)text;
@end
```

``` objc
// MyViewController.m
#import "MyViewController.h"

@interface MyViewController ()
@property (nonatomic, strong) UILabel *label;
@end

@implementation MyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:self.label];
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
@end
```

``` objc
// ParentViewController.h
@interface ParentViewController : UIViewController
@end
``` 

``` objc
// ParentViewController.m 
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
```

如上所示，现在定义了2个controller:`ParentViewController`和`MyViewController`。其中`MyViewController`作为一个子controller被`ParentViewController`显示。`MyViewController`，重写get方法来创建一个全屏的label，显示文案。

现在创建`ParentViewController`并且push显示出来，代码如下：

``` objc
- (void)gotoNext {
    ParentViewController *vc = [[ParentViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
```

到此主要代码全部完成了，程序想要实现的功能：新push出来的页面会显示一个红色的label，文案为123。

#####分析一下，这个程序能够实现我们想要的功能吗？如果不能，界面会展示为什么样？

#####给出答案：并不能实现功能，界面会展示位label的背景色(红色)，但是没有文案。

原因如下：  

当调用`[vc setLabelText:@"123"]`，执行`self.label.text = text;`，触发label属性的get方法，进入创建label的逻辑，调用`_label = [[UILabel alloc] initWithFrame:self.view.bounds];`**这行代码的执行顺序为`[UILabel alloc]` -> `self.view.bounds` -> `initWithFrame:` -> \_label变量赋值。**  

当执行到`self.view.bounds`时，因为controller的view并没有创建，所以`self.view`会触发controller的`loadView`及`viewDidLoad`等相关方法。在`viewDidLoad`方法中，又调用到`[self.view addSubview:self.label];`再次触发label属性的get方法。**因为此时的调用栈是 self.view -> viewDidLoad -> get方法，所以上面提及的`_label = [[UILabel alloc] initWithFrame:self.view.bounds]`代码，并没有执行`initWithFrame:`方法，也没有完成\_label的赋值操作，所以这里调用的get方法，`if (!_label)`语句依然通过，再次创建一个label的实例出来，返回该实例，被add到controller.view上，到此viewDidLoad执行完毕。返回到self.view，继续执行`self.view.bounds` -> `initWithFrame:` -> \_label变量赋值。**

到这里基本已经分析完成了，上面提到，程序后面又给\_label变量赋值了新的实例，返回到`self.label.text = text;`此时self.label指向的是新的实例，该实例和controller.view上粘贴的label是不同的2个实例。所以给self.label赋值文字，并没有任何作用，因为这个label根本就没有被显示出来。被显示出来的是另一个不相干的label。

###总结
这里的问题，主要就是controller的视图并没有被创建，然后get方法中用到了self.view，导致了viewDidLoad的调用时机混乱。

所以有以下几种改法：  

1. get方法设置frame时尽量不要使用self.view。
2. 不要重写get方法来创建。

第一种改法的弊端：如果视图确实依赖self.view，则没法使用。这里提倡第2中改法：

``` objc 
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor orangeColor];
    //[self.view addSubview:self.label];
    [self.view addSubview:[self setupLabel]];
}

- (void)setLabelText:(NSString *)text {
    self.label.text = text;
}

//- (UILabel *)label {
- (UILabel *)setupLabel {
    if (!_label) {
        _label = [[UILabel alloc] initWithFrame:self.view.bounds];
        _label.backgroundColor = [UIColor redColor];
    }
    return _label;
}
```

实际上只需要改下方法名，实现不需要任何改动，即可。

最后附上示例代码的[demo](https://github.com/whlpkk/EqualDemo)
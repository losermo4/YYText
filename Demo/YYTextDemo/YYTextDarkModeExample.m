//
//  YYTextDarkModeExample.m
//  YYTextDemo
//
//  Created by losermo4 on 2023/11/22.
//  Copyright © 2023 ibireme. All rights reserved.
//

#import "YYTextDarkModeExample.h"
#import "YYText.h"


@interface DarkModeManager : NSObject

@property UIUserInterfaceStyle userInterfaceStyle;

@end

@implementation DarkModeManager

+ (instancetype)shared {
    static DarkModeManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[DarkModeManager alloc] init];
    });
    return  manager;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _userInterfaceStyle = UIApplication.sharedApplication.windows.firstObject.overrideUserInterfaceStyle;
    }
    return self;
}


@end



@interface YYTextDarkModeExample ()
@property (nonatomic, strong) YYLabel *label;
@property (nonatomic, strong) UILabel *commonLabel;
@property (nonatomic, strong) NSMutableAttributedString *attributeText;
@property (nonatomic, strong) NSMutableAttributedString *yyattributeText;

@end

@implementation YYTextDarkModeExample

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorNamed:@"bg1"];
    // Do any additional setup after loading the view.
    YYLabel *label = [[YYLabel alloc] initWithFrame:CGRectMake(20, 160, UIScreen.mainScreen.bounds.size.width-20, 100)];
    label.numberOfLines = 0;
    [self.view addSubview:label];
    self.label = label;
    
    
    UILabel *commonLabel =  [[UILabel alloc] initWithFrame:CGRectMake(20, 280, UIScreen.mainScreen.bounds.size.width-20, 100)];
    commonLabel.numberOfLines = 0;
    [self.view addSubview:commonLabel];
    self.commonLabel = commonLabel;
    
    
    UISegmentedControl *segement = [[UISegmentedControl alloc] initWithItems:@[@"夜间模式", @"日间模式"]];
    segement.frame = CGRectMake(100, 400, UIScreen.mainScreen.bounds.size.width-200, 40);
    [self.view addSubview:segement];
    segement.backgroundColor = UIColor.greenColor;
    [segement addTarget:self action:@selector(segementChanged:) forControlEvents:UIControlEventValueChanged];
    
    [self updateWhileThemeChanged];
}

- (void)setupAttributeText {
    
    
//    UIColor *textColor = [UIColor colorWithDynamicProvider:^UIColor * _Nonnull(UITraitCollection * _Nonnull traitCollection) {
//        return traitCollection.userInterfaceStyle == UIUserInterfaceStyleLight ? UIColor.redColor : UIColor.blueColor;
//    }];
//
//    UIColor *textColor2 = [UIColor colorWithDynamicProvider:^UIColor * _Nonnull(UITraitCollection * _Nonnull traitCollection) {
//        return traitCollection.userInterfaceStyle == UIUserInterfaceStyleLight ? UIColor.orangeColor : UIColor.yellowColor;
//    }];
    

    UIColor *textColor = [UIColor colorNamed:@"textYellow"];
    UIColor *textColor2 = [UIColor colorNamed:@"text1"];
    NSString *text = @"如果我们使用drawRect绘制属性字符串时，没有指定颜色，系统会默认为文字颜色为黑色。或者之前我们设置的是较暗的一个颜色。相关情况在Dark模式下，相应文字基本会看不清楚使用到CGColor的部分，如设置Layer颜色，border颜色。设置Layer颜色会发现在亮、暗模式切换的时候，不能顺利地得以切换，可以在适当的时机进行颜色设置，可以在traitCollectionDidChange的时候多设置一次相应的颜色以避免某些切换不流畅现象";
    NSMutableAttributedString *attributeText = [[NSMutableAttributedString alloc] initWithString:text attributes:@{ NSFontAttributeName: [UIFont systemFontOfSize:18]}];
    [attributeText addAttributes:@{NSForegroundColorAttributeName: textColor} range:NSMakeRange(0, text.length)];
    [attributeText addAttributes:@{NSForegroundColorAttributeName: textColor2} range:NSMakeRange(0, 20)];
    self.attributeText = attributeText;
    NSMutableAttributedString *yyattributeText = attributeText.mutableCopy;
    self.yyattributeText = yyattributeText;
}


- (void)updateWhileThemeChanged {
    [self setupAttributeText];
    self.label.attributedText = self.yyattributeText;
    self.commonLabel.attributedText = self.attributeText;
}


- (void)segementChanged:(UISegmentedControl *)segement {
    NSInteger index = segement.selectedSegmentIndex;
    NSString *desc = index == 0 ? @"夜间模式" : @"日间模式";
    NSLog(@"%@", desc);
    UIUserInterfaceStyle style = index == 0 ? UIUserInterfaceStyleDark : UIUserInterfaceStyleLight;
    
    for (UIWindow *window in UIApplication.sharedApplication.windows) {
        window.overrideUserInterfaceStyle = style;
    }
    [DarkModeManager shared].userInterfaceStyle = style;
    
    
//    UIApplication.sharedApplication.windows[0].overrideUserInterfaceStyle = style;
}


- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection {
    [super traitCollectionDidChange:previousTraitCollection];
//    [self updateWhileThemeChanged];
}


@end





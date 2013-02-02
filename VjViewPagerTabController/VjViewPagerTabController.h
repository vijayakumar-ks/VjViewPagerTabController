//
//  VjViewPagerTabController.h
//  TestVJUI
//
//  Created by  on 15/01/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VjViewPagerTabController : UIViewController

// Settings for ActionBarTab
@property (nonatomic, strong) UIFont *font; // default Verdana bold with size 16
@property (nonatomic, strong) UIColor *textColor; // default  white color
@property (nonatomic, strong) UIColor *backgroundColor; // default black color
@property (nonatomic, strong) UIColor *selectionIndicatorColor; // default cyan color

- (void)setActionBarImage:(UIImage*)image withTitle:(NSString *)title forViewController:(UIViewController *)viewController;
@end

//
//  VjActionBar.h
//  TestVJUI
//
//  Created by  on 16/01/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

//Reference 
//https://github.com/HeshamMegid/HMSegmentedControl/blob/master/HMSegmentedControl/HMSegmentedControl.h

#import <UIKit/UIKit.h>


#define MAX_TITLE 4
#define IMG_WIDTH 20
#define IMG_HEIGHT 20
#define PAD 3
typedef void (^actionBarSelectionBlock)(NSUInteger index); 

@interface VjActionBar : UIControl
@property (nonatomic, strong) NSMutableDictionary *images;
@property (nonatomic, strong) NSArray *titles;
@property (nonatomic, strong) UIFont *font; 
@property (nonatomic, strong) UIColor *textColor;  
@property (nonatomic, strong) UIColor *backgroundColor; 
@property (nonatomic, strong) UIColor *selectionIndicatorColor; 
@property (nonatomic, readwrite) CGFloat selectionIndicatorHeight;
@property (nonatomic, copy) actionBarSelectionBlock indexHandler;
- (void)setSelectedIndex:(NSUInteger)index iscallBackRequired:(BOOL)iscallBackRequired animated:(BOOL)animated;
@end



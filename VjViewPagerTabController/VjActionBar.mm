//
//  VjActionBar.m
//  TestVJUI
//
//  Created by  on 16/01/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "VjActionBar.h"
#import <QuartzCore/QuartzCore.h>

//Reference 
//https://github.com/HeshamMegid/HMSegmentedControl/blob/master/HMSegmentedControl/HMSegmentedControl.m

@interface VjActionBar ()
@property (nonatomic, strong) CALayer *selectedSegmentLayer;
@property (nonatomic, assign) NSInteger selectedIndex;
@property (nonatomic, readwrite) CGFloat segmentWidth;
@end

@implementation VjActionBar
@synthesize images,titles,font,textColor,backgroundColor,selectionIndicatorColor,selectedIndex,selectionIndicatorHeight,segmentWidth,selectedSegmentLayer,indexHandler;

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.selectedSegmentLayer = [CALayer layer];
        self.selectedIndex = 0;
    }
    return self;
}

#pragma mark - Drawing
- (void)drawRect:(CGRect)rect
{
    [self.backgroundColor set];
    UIRectFill([self bounds]);
    
    [self.textColor set];

    [self.titles enumerateObjectsUsingBlock:^(id titleString, NSUInteger idx, BOOL *stop) {
       
        CGFloat stringHeight = [titleString sizeWithFont:self.font].height;
        CGFloat y = ((self.frame.size.height - self.selectionIndicatorHeight) / 2) + (self.selectionIndicatorHeight - stringHeight / 2);
        
        CGRect imgRect = CGRectMake(self.segmentWidth * idx, y, IMG_WIDTH, IMG_HEIGHT);
        UIImage * imgItem = [images objectForKey:titleString];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:imgItem];
        imageView.frame = imgRect;
        [self addSubview:imageView];
        
        CGFloat actualFontSize;;
        [titleString drawAtPoint:CGPointMake(self.segmentWidth * idx + IMG_WIDTH + PAD, y) forWidth:self.segmentWidth - IMG_WIDTH - PAD withFont:self.font minFontSize:10 actualFontSize:&actualFontSize lineBreakMode:UILineBreakModeClip baselineAdjustment:UIBaselineAdjustmentAlignCenters];

        self.selectedSegmentLayer.frame = [self frameForSelectionIndicator];
        self.selectedSegmentLayer.backgroundColor = self.selectionIndicatorColor.CGColor;
        [self.layer addSublayer:self.selectedSegmentLayer];
        
        if(MAX_TITLE < idx)
            *stop = TRUE;
    }];
    
    CALayer *border = [CALayer layer];
    border.frame = CGRectMake(0.0, self.frame.size.height-2.0, self.frame.size.width, 2.0);
    border.backgroundColor = self.selectionIndicatorColor.CGColor;
    [self.layer addSublayer:border];
}

- (CGRect)frameForSelectionIndicator {
    return CGRectMake(self.segmentWidth * self.selectedIndex, (self.frame.size.height-self.selectionIndicatorHeight), self.segmentWidth, self.selectionIndicatorHeight);
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    // Control is being removed
    if (newSuperview == nil)
        return;
    
    NSInteger count =  MIN(titles.count, MAX_TITLE);
    self.segmentWidth = self.frame.size.width / count;
}

#pragma mark - Touch
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint touchLocation = [touch locationInView:self];
    
    if (CGRectContainsPoint(self.bounds, touchLocation)) {
        NSInteger segment = touchLocation.x / self.segmentWidth;
        
        if (segment != self.selectedIndex) {
            [self setSelectedIndex:segment iscallBackRequired:YES animated:YES];
        }
    }
}

- (void)setSelectedIndex:(NSUInteger)index iscallBackRequired:(BOOL)iscallBackRequired animated:(BOOL)animated {
    selectedIndex = index;
    
    if (animated) {
        // Restore CALayer animations
        self.selectedSegmentLayer.actions = nil;
        
        [CATransaction begin];
        [CATransaction setAnimationDuration:0.15f];
        
        if(iscallBackRequired)
        {
            [CATransaction setCompletionBlock:^{
                if (self.superview)
                    [self sendActionsForControlEvents:UIControlEventValueChanged];
                
                if (self.indexHandler)
                    self.indexHandler(index);
                
            }];
        }
        self.selectedSegmentLayer.frame = [self frameForSelectionIndicator];
        [CATransaction commit];
    } else {
        // Disable CALayer animations
        NSMutableDictionary *newActions = [[NSMutableDictionary alloc] initWithObjectsAndKeys:[NSNull null], @"position", [NSNull null], @"bounds", nil];
        self.selectedSegmentLayer.actions = newActions;
        
        self.selectedSegmentLayer.frame = [self frameForSelectionIndicator];
        
        if (self.superview)
            [self sendActionsForControlEvents:UIControlEventValueChanged];
        
        if (self.indexHandler)
            self.indexHandler(index);
    }    
}

@end

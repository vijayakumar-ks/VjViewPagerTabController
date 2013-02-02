//
//  VjViewPagerTabController.m
//  TestVJUI
//
//  Created by  on 15/01/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "VjViewPagerTabController.h"
#import "VjActionBar.h"

#define ACTIONBAR_FRAMEHEIGHT 44.0
#define ACTIONBAR_INDICATORHEIGHT 6.0

typedef enum 
{
   LEFT,
   RIGHT
}DIRECTIONS;

@interface VjViewPagerTabController ()
{
    @private
    VjActionBar *actionbarTab;
}
@property (nonatomic, strong) NSMutableArray *viewControllers;
@property (nonatomic, strong) NSMutableDictionary *images;
@property (nonatomic, strong) NSMutableArray *titles;
@property (nonatomic, retain) UIView *containerView;
@property (nonatomic, retain) UIViewController *currentViewController;
-(void)setupActionbarTab;
- (void)transitionViewController:(UIViewController *)fromViewController toViewController:(UIViewController *)toViewController direction:(DIRECTIONS)direction;
@end

@implementation VjViewPagerTabController

@synthesize viewControllers;
@synthesize containerView,currentViewController;
@synthesize images,titles;

@synthesize font,selectionIndicatorColor,textColor,backgroundColor;

- (id)init {
    if (self = [super init]) {
        self.viewControllers = [NSMutableArray array];
        self.titles = [NSMutableArray array];
        self.images  = [NSMutableDictionary dictionary];
        
        //Default parameter settings for ActionBarTab
        font = [UIFont fontWithName:@"Verdana-Bold" size:16.0f];  
        textColor =  [UIColor whiteColor];  
        backgroundColor = [UIColor blackColor]; 
        selectionIndicatorColor = [UIColor cyanColor];
    }
    return self;
}

- (void)loadView
{
	// Setting up the default base view
	CGRect frame = [[UIScreen mainScreen] applicationFrame];
	UIView *view = [[UIView alloc] initWithFrame:frame];
	view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	view.backgroundColor = [UIColor whiteColor];

    // Setting up parent view controller.
	self.containerView = [[UIView alloc] initWithFrame:CGRectMake(0, ACTIONBAR_FRAMEHEIGHT, view.frame.size.width, view.frame.size.height-ACTIONBAR_FRAMEHEIGHT)];
	self.containerView.backgroundColor = [UIColor lightTextColor];
	self.containerView.autoresizingMask = view.autoresizingMask;
	[view addSubview:self.containerView];
	
	self.view = view;
	
	UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(onefingerSwipeLeft:)];
	swipeLeft.direction = UISwipeGestureRecognizerDirectionLeft;
	[view addGestureRecognizer:swipeLeft];
    
	UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(onefingerSwipeRight:)];
	swipeRight.direction = UISwipeGestureRecognizerDirectionRight;
	[view addGestureRecognizer:swipeRight];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    __block UIViewController *tempController = nil;
    // Adding the child controllers to parent controller
    if(viewControllers)
    {
        [self.viewControllers enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            
            tempController = [self.viewControllers objectAtIndex:idx];
           
            tempController.view.frame = containerView.bounds;
        
            tempController.view.autoresizingMask = containerView.autoresizingMask;
            
            if(idx ==0)
            {
                currentViewController = tempController;       //Make 1st viewController as defualt 
                [self addChildViewController:tempController];
                [self.containerView addSubview:currentViewController.view];
                [tempController didMoveToParentViewController:self]; 
            }
            [self addChildViewController:tempController];
            [tempController didMoveToParentViewController:self];
        }];
    }
    // Setting up segmentation action tabs
    [self setupActionbarTab];
} 

-(void)setupActionbarTab
{
    actionbarTab = [[VjActionBar alloc] initWithFrame:CGRectMake(0,0, self.view.frame.size.width, ACTIONBAR_FRAMEHEIGHT)];
    [actionbarTab setSelectionIndicatorHeight:ACTIONBAR_INDICATORHEIGHT];
    [actionbarTab setBackgroundColor:backgroundColor];
    [actionbarTab setTextColor:textColor];
    [actionbarTab setSelectionIndicatorColor:selectionIndicatorColor];
    [actionbarTab setFont:font];
    [actionbarTab setImages:images];
    [actionbarTab setTitles:[NSArray arrayWithArray:titles]];
    [self.view addSubview:actionbarTab];
    
    // Call back for view transition
    [actionbarTab setIndexHandler:^(NSUInteger index) {
        NSInteger viewindex = [viewControllers indexOfObject:currentViewController];
        if(index!= viewindex)
        {
            UIViewController *newSubViewController = [viewControllers objectAtIndex:index];
            if(index> viewindex)
                [self transitionViewController:currentViewController toViewController:newSubViewController direction:RIGHT];
            else 
                [self transitionViewController:currentViewController toViewController:newSubViewController direction:LEFT]; 
        }
    }];
}
- (void)setActionBarImage:(UIImage*)image withTitle:(NSString *)title forViewController:(UIViewController *)viewController
{
    if(viewController!=nil)
    [viewControllers addObject:viewController];
     if(title!= nil)
    [titles addObject:title];
    if(image!= nil)
    [images setObject:image forKey:title]; 
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
}

- (BOOL)automaticallyForwardAppearanceAndRotationMethodsToChildViewControllers{
    return YES;
}

- (void)transitionViewController:(UIViewController *)fromViewController toViewController:(UIViewController *)toViewController direction:(DIRECTIONS)direction
{
    if (fromViewController == toViewController)
		return;
    
    CGRect toRect;
    
    if(direction == LEFT)
        toRect = CGRectMake(self.containerView.frame.size.width, 0.0f, self.containerView.frame.size.width, self.containerView.frame.size.height);
    else
        toRect = CGRectMake(-self.containerView.frame.size.width, 0.0f, self.containerView.frame.size.width, self.containerView.frame.size.height);
    
    toViewController.view.frame = toRect;
    
    [self transitionFromViewController:fromViewController 
                      toViewController:toViewController
                              duration:0.15f
                               options:UIViewAnimationOptionCurveEaseInOut
                            animations:^{
                                toViewController.view.frame = containerView.bounds;
                            }
                            completion:^(BOOL finished){
                                currentViewController = toViewController;
    }];
}

- (void)onefingerSwipeLeft:(UISwipeGestureRecognizer *)gesture
{
	if (gesture.state == UIGestureRecognizerStateRecognized)
	{
		NSInteger index = [viewControllers indexOfObject:currentViewController];
		index = MIN(index+1, [viewControllers count]-1);
		
        [actionbarTab setSelectedIndex:index iscallBackRequired:NO animated:YES];
        
		UIViewController *newSubViewController = [viewControllers objectAtIndex:index];
		
        [self transitionViewController:currentViewController toViewController:newSubViewController direction:LEFT];
	}
}

- (void)onefingerSwipeRight:(UISwipeGestureRecognizer *)gesture
{
	if (gesture.state == UIGestureRecognizerStateRecognized)
	{
		NSInteger index = [viewControllers indexOfObject:currentViewController];
		index = MAX(index-1, 0);
    
        [actionbarTab setSelectedIndex:index iscallBackRequired:NO animated:YES];
        
		UIViewController *newSubViewController = [viewControllers objectAtIndex:index];
		
        [self transitionViewController:currentViewController toViewController:newSubViewController direction:RIGHT];
	}
}

@end

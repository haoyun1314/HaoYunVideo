 //
//  TPCTabBarController.m
//  PecoCommunity
//
//  Created by caixun on 2016/10/9.
//  Copyright © 2016年 Peco. All rights reserved.
//


#import "TPCTabBarController.h"
#import "TPCTabBarItem.h"
#import <objc/runtime.h>
#import "AppDelegate.h"


@interface MPBNavigationController (TPCTabBarControllerItemInternal)

- (void)tpc_setTabBarController:(TPCTabBarController *)tabBarController;

@end


@interface TPCTabBarController ()
{
    MPCView *_contentView;
}


@property (nonatomic, readwrite) TPCTabBar *tabBar;


@end


@implementation TPCTabBarController


#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.view addSubview:[self contentView]];
    [self.view addSubview:[self tabBar]];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self setSelectedIndex:[self selectedIndex]];
    
    [self setTabBarHidden:self.isTabBarHidden animated:NO];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    [self setTabBarHidden:self.isTabBarHidden animated:NO];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return self.selectedViewController.preferredStatusBarStyle;
}

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation
{
    return self.selectedViewController.preferredStatusBarUpdateAnimation;
}


#pragma mark - Methods

- (MPBNavigationController *)selectedViewController
{
    return [[self viewControllers] objectAtIndex:[self selectedIndex]];
}

- (void)setSelectedIndex:(NSUInteger)selectedIndex
{
    if (selectedIndex >= self.viewControllers.count)
    {
        return;
    }
    
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if (self.selectIndexBlock)
    {
       UINavigationController *nav = self.selectIndexBlock(selectedIndex);
        if (nav)
        {
//            app.currentMainNav = nav;
            return;
        }
        else
        {
//            app.currentMainNav = nil;
        }
    }
        
    if ([self selectedViewController])
    {
        [[self selectedViewController] willMoveToParentViewController:nil];
        [[[self selectedViewController] view] removeFromSuperview];
        [[self selectedViewController] removeFromParentViewController];
    }
    
    _selectedIndex = selectedIndex;
    [[self tabBar] setSelectedItem:[[self tabBar] items][selectedIndex]];
    
    [self setSelectedViewController:[[self viewControllers] objectAtIndex:selectedIndex]];
    [self addChildViewController:[self selectedViewController]];
    [[[self selectedViewController] view] setFrame:[[self contentView] bounds]];
    [[self contentView] addSubview:[[self selectedViewController] view]];
    [[self selectedViewController] didMoveToParentViewController:self];
    
    [self setNeedsStatusBarAppearanceUpdate];
    
}

- (void)setViewControllers:(NSArray *)viewControllers
{
    if (_viewControllers && _viewControllers.count)
    {
        for (MPBNavigationController *viewController in _viewControllers)
        {
            [viewController willMoveToParentViewController:nil];
            [viewController.view removeFromSuperview];
            [viewController removeFromParentViewController];
        }
    }
    
    if (viewControllers && [viewControllers isKindOfClass:[NSArray class]])
    {
        _viewControllers = [viewControllers copy];
        
        NSMutableArray *tabBarItems = [[NSMutableArray alloc] init];
        
        for (MPBNavigationController *viewController in viewControllers)
        {
            TPCTabBarItem *tabBarItem = [[TPCTabBarItem alloc] init];
            [tabBarItem setTitle:viewController.title];
            [tabBarItems addObject:tabBarItem];
            [viewController tpc_setTabBarController:self];
        }
        
        [[self tabBar] setItems:tabBarItems];
    }
    else
    {
        for (MPBNavigationController *viewController in _viewControllers)
        {
            [viewController tpc_setTabBarController:nil];
        }
        
        _viewControllers = nil;
    }
}

- (NSInteger)indexForViewController:(MPBNavigationController *)viewController
{
    MPBNavigationController *searchedController = viewController;
    if ([searchedController navigationController])
    {
        searchedController = (MPBNavigationController *)[searchedController navigationController];
    }
    
    return [[self viewControllers] indexOfObject:searchedController];
}

- (TPCTabBar *)tabBar
{
    if (!_tabBar)
    {
        _tabBar = [[TPCTabBar alloc] init];
        [_tabBar setBackgroundColor:[UIColor clearColor]];
        _tabBar.contentEdgeInsets = UIEdgeInsetsMake(MPT_Device_Is_iPhoneX?34/2.0:0, 0, 0, 0);
        [_tabBar setAutoresizingMask:(UIViewAutoresizingFlexibleWidth|
                                      UIViewAutoresizingFlexibleTopMargin|
                                      UIViewAutoresizingFlexibleLeftMargin|
                                      UIViewAutoresizingFlexibleRightMargin|
                                      UIViewAutoresizingFlexibleBottomMargin)];
        [_tabBar setDelegate:self];
    }
    
    return _tabBar;
}

- (MPCView *)contentView
{
    if (!_contentView)
    {
        _contentView = [[MPCView alloc] init];
        [_contentView setBackgroundColor:[UIColor whiteColor]];
        [_contentView setAutoresizingMask:(UIViewAutoresizingFlexibleWidth|
                                           UIViewAutoresizingFlexibleHeight)];
    }
    
    return _contentView;
}

- (void)setTabBarHidden:(BOOL)hidden animated:(BOOL)animated
{
    _tabBarHidden = hidden;
    
    __weak TPCTabBarController *weakSelf = self;
    
    void (^block)() = ^{
        CGSize viewSize = weakSelf.view.bounds.size;
        CGFloat tabBarStartingY = viewSize.height;
        CGFloat contentViewHeight = viewSize.height;
        CGFloat tabBarHeight = CGRectGetHeight([[weakSelf tabBar] frame]);
        
        if (!tabBarHeight) {
            tabBarHeight = TP_Tabbar_H;
        }
        
        if (!weakSelf.tabBarHidden) {
            tabBarStartingY = viewSize.height - tabBarHeight;
            if (![[weakSelf tabBar] isTranslucent]) {
                contentViewHeight -= ([[weakSelf tabBar] minimumContentHeight] ?: tabBarHeight);
            }
            [[weakSelf tabBar] setHidden:NO];
        }
        
        [[weakSelf tabBar] setFrame:CGRectMake(0, tabBarStartingY, viewSize.width, tabBarHeight)];
        [[weakSelf contentView] setFrame:CGRectMake(0, 0, viewSize.width, contentViewHeight)];
    };
    
    void (^completion)(BOOL) = ^(BOOL finished){
        if (weakSelf.tabBarHidden) {
            [[weakSelf tabBar] setHidden:YES];
        }
    };
    
    if (animated)
    {
        [UIView animateWithDuration:0.24 animations:block completion:completion];
    }
    else
    {
        block();
        completion(YES);
    }
}

- (void)setTabBarHidden:(BOOL)hidden
{
    [self setTabBarHidden:hidden animated:NO];
}

#pragma mark - TPCTabBarDelegate

- (BOOL)tabBar:(TPCTabBar *)tabBar shouldSelectItemAtIndex:(NSInteger)index
{
    if ([[self delegate] respondsToSelector:@selector(tabBarController:shouldSelectViewController:index:)])
    {
        if (![[self delegate] tabBarController:self shouldSelectViewController:[self viewControllers][index] index:index])
        {
            return NO;
        }
    }
    
    if ([self selectedViewController] == [self viewControllers][index])
    {
        if ([[self selectedViewController] isKindOfClass:[MPBNavigationController class]])
        {
            MPBNavigationController *selectedController = (MPBNavigationController *)[self selectedViewController];
            
            if ([selectedController topViewController] != [selectedController viewControllers][0])
            {
                [selectedController popToRootViewControllerAnimated:YES];
            }
        }
        
        return NO;
    }
    
    return YES;
}

- (void)tabBar:(TPCTabBar *)tabBar didSelectItemAtIndex:(NSInteger)index
{
    if (index < 0 || index >= [[self viewControllers] count])
    {
        return;
    }
    
    [self setSelectedIndex:index];
    
    if ([[self delegate] respondsToSelector:@selector(tabBarController:didSelectViewController:)])
    {
        [[self delegate] tabBarController:self didSelectViewController:[self viewControllers][index]];
    }
}

@end


#pragma mark - UIViewController+TPCTabBarControllerItem

@implementation MPBNavigationController (TPCTabBarControllerItemInternal)

- (void)tpc_setTabBarController:(TPCTabBarController *)tabBarController
{
    objc_setAssociatedObject(self, @selector(tpc_tabBarController), tabBarController, OBJC_ASSOCIATION_ASSIGN);
}

@end


@implementation MPBNavigationController (TPCTabBarControllerItem)

- (TPCTabBarController *)tpc_tabBarController
{
    TPCTabBarController *tabBarController = objc_getAssociatedObject(self, @selector(tpc_tabBarController));
    
    if (!tabBarController && self.parentViewController)
    {
        tabBarController = [(MPBNavigationController *)self.parentViewController tpc_tabBarController];
    }
    
    return tabBarController;
}

- (TPCTabBarItem *)tpc_tabBarItem
{
    TPCTabBarController *tabBarController = [self tpc_tabBarController];
    NSInteger index = [tabBarController indexForViewController:self];
    
    return [[[tabBarController tabBar] items] objectAtIndex:index];
}

- (void)tpc_setTabBarItem:(TPCTabBarItem *)tabBarItem
{
    TPCTabBarController *tabBarController = [self tpc_tabBarController];
    
    if (!tabBarController)
    {
        return;
    }
    
    TPCTabBar *tabBar = [tabBarController tabBar];
    NSInteger index = [tabBarController indexForViewController:self];
    
    NSMutableArray *tabBarItems = [[NSMutableArray alloc] initWithArray:[tabBar items]];
    [tabBarItems replaceObjectAtIndex:index withObject:tabBarItem];
    [tabBar setItems:tabBarItems];
}


@end

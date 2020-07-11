//
//  TPCTabBarController.h
//  PecoCommunity
//
//  Created by caixun on 2016/10/9.
//  Copyright © 2016年 Peco. All rights reserved.
//


#import "TPCTabBar.h"
#import "TPCTabBarItem.h"
#import "MPBNavigationController.h"

#define TP_Tabbar_H (49.0f+(MPT_Device_Is_iPhoneX?34:0))

@protocol TPCTabBarControllerDelegate;


@interface TPCTabBarController : MPBViewController<TPCTabBarDelegate>


/**
 * The tab bar controller’s delegate object.
 */
@property (nonatomic, weak) id<TPCTabBarControllerDelegate> delegate;

/**
 * An array of the root view controllers displayed by the tab bar interface.
 */
@property (nonatomic, copy) IBOutletCollection(MPBNavigationController) NSArray *viewControllers;

/**
 * The tab bar view associated with this controller. (read-only)
 */
@property (nonatomic, readonly) TPCTabBar *tabBar;

/**
 * The view controller associated with the currently selected tab item.
 */
@property (nonatomic, weak) MPBNavigationController *selectedViewController;

/**
 * The index of the view controller associated with the currently selected tab item.
 */
@property (nonatomic) NSUInteger selectedIndex;

/**
 * A Boolean value that determines whether the tab bar is hidden.
 */
@property (nonatomic, getter=isTabBarHidden) BOOL tabBarHidden;

@property (nonatomic, copy) MPBNavigationController *(^selectIndexBlock)(NSInteger index);

/**
 * Changes the visibility of the tab bar.
 */
- (void)setTabBarHidden:(BOOL)hidden animated:(BOOL)animated;

@end


@protocol TPCTabBarControllerDelegate <NSObject>

@optional
/**
 * Asks the delegate whether the specified view controller should be made active.
 */
- (BOOL)tabBarController:(TPCTabBarController *)tabBarController shouldSelectViewController:(MPBNavigationController *)viewController index:(NSInteger)index;

/**
 * Tells the delegate that the user selected an item in the tab bar.
 */
- (void)tabBarController:(TPCTabBarController *)tabBarController didSelectViewController:(MPBNavigationController *)viewController;


@end


@interface MPBNavigationController (TPCTabBarControllerItem)

/**
 * The tab bar item that represents the view controller when added to a tab bar controller.
 */
@property(nonatomic, setter = tpc_setTabBarItem:) TPCTabBarItem *tpc_tabBarItem;

/**
 * The nearest ancestor in the view controller hierarchy that is a tab bar controller. (read-only)
 */
@property(nonatomic, readonly) TPCTabBarController *tpc_tabBarController;


@end

//
//  JDONavigationController.h
//  JiaodongOnlineNews
//
//  Created by zhang yi on 13-6-19.
//  Copyright (c) 2013年 胶东在线. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JDONavigationController : UIViewController <JDONavigationView>

@property (strong,nonatomic) JDONavigationView *navigationView;
@property (strong,nonatomic) UIViewController *stackViewController; /* 类似UINavigationController 在rightViewController多级导航中使用 */

- (void) setupNavigationView;

@end

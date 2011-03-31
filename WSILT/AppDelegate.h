//
//  AppDelegate.h
//  IndigoProject
//
//  Created by Felipe Sabino on 3/28/11.
//  Copyright 2011 USP. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface AppDelegate : NSObject <UIApplicationDelegate> {

    UIWindow *_window;
    UINavigationController *root;
    
}

@property (nonatomic, retain) UIWindow *window;

@end

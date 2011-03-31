/*
 *  Constants.h
 *  NBC
 *
 *  Created by Edmar Miyake on 2/16/11.
 *  Copyright 2011 __MyCompanyName__. All rights reserved.
 *
 */

#define RGB(r, g, b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]
#define RGBA(r, g, b, a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]

#define SCREEN_HEIGHT() UIInterfaceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation]) ? (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? 768.0 : 320.0) : (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? 1024.0 : 480.0)

#define SCREEN_WIDTH() UIInterfaceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation]) ? (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? 1024.0 : 480.0) : (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? 768.0 : 320.0)
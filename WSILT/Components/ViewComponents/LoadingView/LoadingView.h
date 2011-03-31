//
//  LoadingViewController.h
//  NBC
//
//  Created by Renato Tano on 12/03/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@class LoadingView;

@protocol LoadingViewDelegate<NSObject>

-(void) loadingViewCancelled;

@end


@interface LoadingView : UIView {
	UIActivityIndicatorView * _activityIndicator;
	id<LoadingViewDelegate> _delegate;
}

@property (nonatomic, assign) id<LoadingViewDelegate> delegate;

-(void) setText: (NSString *) newText;

@end

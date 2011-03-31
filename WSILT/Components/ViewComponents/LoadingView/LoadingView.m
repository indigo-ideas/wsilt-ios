    //
//  LoadingViewController.m
//  NBC
//
//  Created by Renato Tano on 12/03/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "LoadingView.h"


@implementation LoadingView

@synthesize delegate = _delegate;

-(id) init {

	self =[super initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH(), SCREEN_HEIGHT())];
	if (self) {
		
		UIView *background = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH(), SCREEN_HEIGHT())];
		background.backgroundColor = [UIColor blackColor];
		background.alpha = 0.6;
		
		UIView *box = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 160)];
		box.center = CGPointMake(SCREEN_WIDTH()/2, SCREEN_HEIGHT()/2-50.0);
		box.userInteractionEnabled = YES;
		[box setBackgroundColor:RGBA(0x55,0x55,0x55, 0.7)];
		box.layer.cornerRadius = 10.0;
		box.layer.borderColor = RGB(0x77,0x77,0x77).CGColor ;
		box.layer.borderWidth = 1.0;
		
		UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 10.0, 200, 50)];
		[lbl setFont:[UIFont fontWithName:@"Helvetica" size:16]];
		[lbl setTextAlignment:UITextAlignmentCenter];
		[lbl setBackgroundColor:[UIColor clearColor]];
		[lbl setTextColor:[UIColor whiteColor]];
		[lbl setNumberOfLines: 2];
		lbl.tag = 999;
		
		lbl.text = @"Checking updates";
		
		
		[box addSubview:lbl];
		[lbl release];
		
		_activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(80.0, 60, 20.0, 20.0)];
		_activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
		[_activityIndicator startAnimating];
		[_activityIndicator sizeToFit];
		[box addSubview:_activityIndicator];
		
		//[activityIndicator release];
		
		UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
		[cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
		[[cancelButton titleLabel] setFont:[UIFont fontWithName:@"Helvetica" size:14]];
		[cancelButton setBackgroundColor:RGB(0x11,0x11,0x11)];
		cancelButton.layer.cornerRadius = 5;
		cancelButton.layer.borderColor = RGB(0x55,0x55,0x55).CGColor;
		cancelButton.layer.borderWidth = 1.0;
		cancelButton.frame = CGRectMake(55, 120.0, 90.0, 30.0);
		[cancelButton addTarget:self action:@selector(cancelTapped:) forControlEvents:UIControlEventTouchUpInside];
		[box addSubview:cancelButton];
		
		[background addSubview:box];
		[self addSubview:background];
		
        self.center = CGPointMake(SCREEN_WIDTH()/2, SCREEN_HEIGHT()/2);
		
	}
	
	return self;
}

-(void) setText:(NSString *)newText {

	UILabel *lbl = (UILabel *)[self viewWithTag:999];
	
	lbl.text = newText;
	
}

-(void)cancelTapped:(UIButton *)sender{
	if (self.delegate) {
		[self.delegate loadingViewCancelled];
	}
}

- (void)dealloc {
	[_activityIndicator release];
    [super dealloc];
}


@end

//
//  UIThumbnailView.m
//  NBC
//
//  Created by Edmar Miyake on 3/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "UIThumbnailView.h"


@implementation UIThumbnailView


- (id)initWithFrame:(CGRect)frame andText:(NSString *) text {
    
    self = [super initWithFrame:frame];
    if (self) {
		
		float fontSize, indicatorSize, offset;
		if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
			fontSize = 10.0;
			indicatorSize = 20.0;
			offset = 15.0;
		}
		else {
			fontSize = 40.0;
			indicatorSize = 20.0;
			offset = 0.0;
		}

        
		UILabel *lblNoImage = [[UILabel alloc] initWithFrame:frame];
		lblNoImage.textAlignment = UITextAlignmentCenter;
		
		[lblNoImage setText:text];
		[lblNoImage setTextColor:RGB(0xff, 0xff, 0xff)];
		[lblNoImage setAlpha:0.2];
		[lblNoImage setFont:[UIFont systemFontOfSize:fontSize]];
		[lblNoImage setNumberOfLines:0];
		[lblNoImage setLineBreakMode:UILineBreakModeWordWrap];
		[lblNoImage setBackgroundColor:[UIColor clearColor]];
		
		[self addSubview:lblNoImage];
		[lblNoImage release];
		
		[self setBackgroundColor:[UIColor clearColor]];
		
		
		
		
		UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, indicatorSize, indicatorSize)];
		if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
			activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
		else 
			activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;

		[activityIndicator sizeToFit];
		activityIndicator.center = CGPointMake(frame.size.width/2, frame.size.height/2 - offset);
		[self addSubview:activityIndicator];
		[self bringSubviewToFront:activityIndicator];
		[activityIndicator startAnimating];
		
		[activityIndicator release];
		
		
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code.
}
*/

- (void)dealloc {
    [super dealloc];
}


@end

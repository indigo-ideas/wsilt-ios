//
//  HomeController_iPad.m
//  IndigoProject
//
//  Created by Felipe Sabino on 3/28/11.
//  Copyright 2011 I.ndigo. All rights reserved.
//

#import "HomeController_iPad.h"
#import "TCImageView.h"

@implementation HomeController_iPad


-(void)setupElements {
    
    
    CGRect rect = CGRectNull;
    rect.size.width = 400.0;
    rect.size.height = 60.0;
    rect.origin.x = SCREEN_WIDTH()/2.0 - 200.0;
    rect.origin.y = SCREEN_HEIGHT()/2.0 - 30.0;
    
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame = rect;
    [button setTitle:@"Where should I lunch today?" forState:UIControlStateNormal];
    [[button titleLabel] setFont:[UIFont systemFontOfSize:14.0]];
    [[button titleLabel] setTextColor:[UIColor redColor]];
    [button addTarget:self action:@selector(buttonSearchTapped) forControlEvents:UIControlEventTouchUpInside];    
    [self.view  addSubview:button];    
    
    rect.size.width = 400.0;
    rect.size.height = 60.0;
    rect.origin.x = SCREEN_WIDTH()/2.0 - 200.0;
    rect.origin.y = SCREEN_HEIGHT()/2.0 - 370.0;
    
    _venueNameLabel = [[UILabel alloc] init];
    _venueNameLabel.frame = rect;
    [_venueNameLabel setFont:[UIFont systemFontOfSize:18.0]];
    [_venueNameLabel setTextColor:[UIColor whiteColor]];
    _venueNameLabel.backgroundColor = [UIColor clearColor];
    _venueNameLabel.text = @"teste";
    _venueNameLabel.textAlignment = UITextAlignmentCenter;
    //_venueNameLabel.alpha = 0.0;
    
    [self.view  addSubview:_venueNameLabel];  
    
}


-(void) didFindVenue:(NSDictionary *)venue {
    
    _venueNameLabel.text = [venue objectForKey:@"name"];
    
    
    [UIView beginAnimations:@"loadingview_show" context:nil];
    [UIView setAnimationDuration:0.3];
    
    _venueNameLabel.alpha = 1.0;
    
    [UIView commitAnimations];
}

#pragma mark - View lifecycle


// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
    
    [super loadView];
    

    
}


- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}


#pragma -
#pragma Memory

- (void)dealloc
{
    
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}


@end

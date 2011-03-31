//
//  HomeController_iPad.m
//  IndigoProject
//
//  Created by Felipe Sabino on 3/28/11.
//  Copyright 2011 USP. All rights reserved.
//

#import "HomeController_iPad.h"
#import "TCImageView.h"

@implementation HomeController_iPad





#pragma mark - View lifecycle


// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
    
    [super loadView];
    
    CGRect rect = CGRectNull;
    rect.size.width = 100.0;
    rect.size.height = 30.0;
    rect.origin.x = 100.0;
    rect.origin.y = 100.0;

    
    UILabel *label = [[UILabel alloc] init];
    label.frame = rect;
    label.text = @"iPad label";
    label.font = [UIFont systemFontOfSize:14.0];
    label.textColor = [UIColor redColor];
    
    [self.view  addSubview:label];
    
    [label release];
    
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

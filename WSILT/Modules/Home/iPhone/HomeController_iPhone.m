//
//  HomeController_iPhone.m
//  IndigoProject
//
//  Created by Felipe Sabino on 3/28/11.
//  Copyright 2011 I.ndigo. All rights reserved.
//

#import "HomeController_iPhone.h"


@implementation HomeController_iPhone



#pragma mark - View lifecycle


// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
    
    [super loadView];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    CGRect rect = CGRectNull;
    rect.size.width = 300.0;
    rect.size.height = 100.0;
    rect.origin.x = 20.0;
    rect.origin.y = 50.0;
    
    
    UILabel *label = [[UILabel alloc] init];
    label.frame = rect;
    label.text = NSLocalizedString(@"homeQuestion", @"Testing the multi-language");
    label.font = [UIFont systemFontOfSize:21.0];
    label.textColor = [UIColor redColor];
    
    [self.view  addSubview:label];
    
    [label release];
    
    UIButton *btnWhere = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnWhere setImage:[UIImage imageNamed: @"interrogacao.jpg"] forState:UIControlStateNormal];
    [btnWhere addTarget:self action:@selector(btnQuestionTapped:) forControlEvents:UIControlEventTouchUpInside];
    btnWhere.frame = CGRectMake(100.0, 200.0, 118.0, 120.0);
    [self.view addSubview:btnWhere];
        
}

-(void)btnQuestionTapped: (UIButton *) sender{
    UIAlertView *msgFeijao = [[UIAlertView alloc]  initWithTitle:NSLocalizedString(@"msgFeijaoTitle", @"Testing the multi-language") message:NSLocalizedString(@"msgFeijaoText", @"Testing the multi-language") delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK",nil];
    [msgFeijao show];
}


/*
 // Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
 - (void)viewDidLoad
 {
 [super viewDidLoad];
 }
 */

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    //return (interfaceOrientation == UIInterfaceOrientationPortrait);
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

//
//  HomeController.m
//  IndigoProject
//
//  Created by Felipe Sabino on 3/28/11.
//  Copyright 2011 USP. All rights reserved.
//

#import "HomeController.h"


@implementation HomeController


-(void) didFindVenue: (NSDictionary *) venue {}
-(void) setupElements {}

-(void)buttonSearchTapped {
    
    _loadingView.alpha = 0.0;
    
    [self.view addSubview:_loadingView];

    [UIView beginAnimations:@"loadingview_show" context:nil];
    [UIView setAnimationDuration:0.3];
    
    _loadingView.alpha = 1.0;
    
    [UIView commitAnimations];
    
    if (_didFindLocation) {
        [_foursquare searchVenuesForLocation:_currentLocation];
    } else {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Could not get your current position" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil]; //TODO: load alert text from resources
        
        [alert show];
        
        [alert release];
        
    }
    
}

-(int) randomIntBetween:(int) smallNumber andBigNumber:(int) bigNumber {
    int diff = bigNumber - smallNumber;
    int iReturn = (((float) rand() / RAND_MAX) * diff) + smallNumber;
	return iReturn;
}

#pragma -
#pragma UIAlertViewDelegate

-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    
    [self loadingViewCancelled];
    
}

#pragma -
#pragma LoadingViewDelegate

-(void)loadingViewCancelled {
    
    [_loadingView removeFromSuperview];
    
}

#pragma -
#pragma CLLocationManagerDelegate

-(void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    
    _didFindLocation = NO;
    
    [_currentLocation release];
    _currentLocation = nil;
    _currentLocation = [newLocation retain];
    
    NSLog(@"didUpdateToLocation: (%1.5f, %1.5f)", newLocation.coordinate.latitude, newLocation.coordinate.longitude);
    
    _didFindLocation = YES;
}


#pragma -
#pragma FoursquareVenueSearchDelegate

-(void)foursquareVenueSearch:(FoursquareVenueSearch *)sender ErrorWhileFindingVenues:(NSError *)error {
    
    NSLog(@"%@", error);
    
}

-(void)foursquareVenueSearch:(FoursquareVenueSearch *)sender DidFindVenues:(NSArray *)venues {
    
    int venueIndex = [self randomIntBetween:0 andBigNumber:[venues count]];
    
    NSDictionary *venue = [venues objectAtIndex:venueIndex];
    
    [self didFindVenue:venue];

    
}


#pragma mark - View lifecycle


// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
    
    [super loadView];
    
    self.view.backgroundColor = [UIColor clearColor];
    
    [self setupElements];
    
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.delegate = self;
    [_locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
    [_locationManager startUpdatingLocation];
    
    _foursquare = [[FoursquareVenueSearch alloc] init];
    _foursquare.delegate = self;

    _loadingView = [[LoadingView alloc] init];
    _loadingView.delegate = self;
    [_loadingView setText:@"Loading places"]; //TODO: get from localized resources
    
    
    
    
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
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma -
#pragma Memory


- (void)dealloc
{
    [_locationManager release];
    [_currentLocation release];
    [_loadingView release];
    [_foursquare release];
    
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

@end

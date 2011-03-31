//
//  HomeController.h
//  IndigoProject
//
//  Created by Felipe Sabino on 3/28/11.
//  Copyright 2011 USP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FoursquareVenueSearch.h"
#import "LoadingView.h"

@interface HomeController : UIViewController <FoursquareVenueSearchDelegate, CLLocationManagerDelegate, LoadingViewDelegate, UIAlertViewDelegate> {
    
    CLLocationManager *_locationManager;
    CLLocation *_currentLocation;
    FoursquareVenueSearch *_foursquare;
    LoadingView *_loadingView;
    
    BOOL _didFindLocation;
    BOOL _isSearchCancelled;

}

-(void) setupElements;

-(void) buttonSearchTapped;
-(void) didFindVenue: (NSDictionary *) venue;

-(int) randomIntBetween:(int) smallNumber andBigNumber:(int) bigNumber;


@end

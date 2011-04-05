//
//  HomeController.h
//  IndigoProject
//
//  Created by Felipe Sabino on 3/28/11.
//  Copyright 2011 I.ndigo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoadingView.h"
#import <CoreLocation/CoreLocation.h>

@interface HomeController : UIViewController <CLLocationManagerDelegate, LoadingViewDelegate, UIAlertViewDelegate> {
    
    CLLocationManager *_locationManager;
    CLLocation *_currentLocation;
    LoadingView *_loadingView;
    
    BOOL _didFindLocation;
    BOOL _isSearchCancelled;

}

-(void) setupElements;

-(void) buttonSearchTapped;
-(void) didFindVenue: (NSDictionary *) venue;

-(int) randomIntBetween:(int) smallNumber andBigNumber:(int) bigNumber;


@end

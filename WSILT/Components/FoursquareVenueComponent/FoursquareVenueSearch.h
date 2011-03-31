//
//  FoursquareVenueSearch.h
//  WSILT
//
//  Created by Felipe Sabino on 3/30/11.
//  Copyright 2011 USP. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "JSONFramework.h"

#define FoursquareVenueSearch_ClientId @"RRD5OY4BFZBTN5HV1W33VGTCXY45FYPOQIFBYLQFJ5KTY3I3"
#define FoursquareVenueSearch_ClientSecret @"HGKCD4JPM0L0UAYIR2H42YUKRBJPGAGD4WBCIL5WQEALQBHQ"
#define FoursquareVenueSearch_APIURL @"https://api.foursquare.com/v2/"


@class FoursquareVenueSearch;

@protocol FoursquareVenueSearchDelegate <NSObject>

-(void) foursquareVenueSearch: (FoursquareVenueSearch *) sender DidFindVenues: (NSArray *) venues;

-(void) foursquareVenueSearch: (FoursquareVenueSearch *) sender ErrorWhileFindingVenues: (NSError *) error;


@end


@interface FoursquareVenueSearch : NSObject {
    
    id<FoursquareVenueSearchDelegate> _delegate;
    
    @private
    
    NSMutableData *_data;
    NSURLConnection *_connection;
    CLLocation *_currentLocation;
    BOOL _isLoadingData;
    
}

@property (nonatomic, assign) id<FoursquareVenueSearchDelegate> delegate;
@property (nonatomic, retain) CLLocation *currentLocation;

-(void) searchVenuesForLocation: (CLLocation *) location;

- (void) dispatchSelector:(SEL)selector
				   target:(id)target
				  objects:(NSArray*)objects
			 onMainThread:(BOOL)onMainThread
            waitUntilDone:(BOOL)waitUntilDone;
@end

//
//  FoursquareVenueSearch.m
//  WSILT
//
//  Created by Felipe Sabino on 3/30/11.
//  Copyright 2011 USP. All rights reserved.
//

#import "FoursquareVenueSearch.h"

@interface FoursquareVenueSearch (Private) 

//-(void) foursquareVenueSearchError


@end

@implementation FoursquareVenueSearch

@synthesize delegate = _delegate;
@synthesize currentLocation = _currentLocation;

-(void)searchVenuesForLocation:(CLLocation *) location {
    
    if (_delegate && !_isLoadingData) {

        _isLoadingData = YES;
        
        [_delegate retain];
        self.currentLocation = location;
        
        NSString *url = [FoursquareVenueSearch_APIURL stringByAppendingFormat:@"venues/search?ll=%1.6f,%1.6f&client_id=%@&client_secret=%@", location.coordinate.latitude, location.coordinate.longitude, FoursquareVenueSearch_ClientId, FoursquareVenueSearch_ClientSecret];
        
        NSLog(@"requesto to FS url: %@", url);

        
        // Loads image from network if no "return;" is triggered (no cache file found)
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[url stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding]  ] cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:30.0];
        _connection = [[NSURLConnection alloc] initWithRequest:request delegate:self  ];
    }
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    
    if (_delegate && [_delegate respondsToSelector:@selector(foursquareVenueSearch:ErrorWhileFindingVenues:ForLocation:)]) {
        [self dispatchSelector:@selector(foursquareVenueSearch:ErrorWhileFindingVenue:) target:self objects:[NSArray arrayWithObjects:self, error, nil] onMainThread:YES waitUntilDone:YES];
    }
    
    if (_delegate) {
        [_delegate release];
    }
    
    _isLoadingData = NO;

}


-(void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)incrementalData {
    
    if (_data == nil)
        _data = [[NSMutableData alloc] initWithCapacity:2048];
    
    [_data appendData:incrementalData];

    
}


-(void)connectionDidFinishLoading:(NSURLConnection *)connection {
    
    NSString *apiJSONData = [[[NSString alloc] initWithData:_data encoding:NSStringEnumerationByComposedCharacterSequences] autorelease]; 
    
    NSDictionary *apiData = [apiJSONData JSONValue];
    

    //TODO: handle api errors here
    NSMutableArray *venues = [[NSMutableArray alloc] init];

    
    NSArray *responseGroups = (NSArray *)[apiData valueForKeyPath:@"response.groups"];
    NSDictionary *itemGroup = (NSDictionary *)[responseGroups objectAtIndex:0];
    NSArray * items = [itemGroup objectForKey:@"items"];
    
    
    NSPredicate *filterFoodVenuesPredicate = [NSPredicate predicateWithFormat:@"ANY categories.parents == 'Food'"];
    
    NSArray *tempVenues = [items filteredArrayUsingPredicate:filterFoodVenuesPredicate];
    
//    NSLog(@"items before predicate: %@", items);
//    NSLog(@"items after predicate: %@", tempVenues);

    for (NSDictionary*item in tempVenues) {
        NSMutableDictionary *venue = [[NSMutableDictionary alloc] init];
        
        NSString *name = [item objectForKey:@"name"];
        if (name) {
            [venue setObject:name forKey:@"name"];
        }
              
        [venues addObject:venue];
        [venue release];
    }
    
    [venues release];

    [_delegate release];
    
    _isLoadingData = NO;

}

- (void) dispatchSelector:(SEL)selector
				   target:(id)target
				  objects:(NSArray*)objects
			 onMainThread:(BOOL)onMainThread
            waitUntilDone:(BOOL)waitUntilDone {
    
    if(target && [target respondsToSelector:selector]) {
        NSMethodSignature* signature = [target methodSignatureForSelector:selector];
        if(signature) {
            NSInvocation* invocation = [NSInvocation invocationWithMethodSignature:signature];
            
            @try {
                [invocation setTarget:target];
                [invocation setSelector:selector];
                
                if(objects) {
                    NSInteger objectsCount = [objects count];
                    
                    for(NSInteger i=0; i < objectsCount; i++) {
                        NSObject* obj = [objects objectAtIndex:i];
                        [invocation setArgument:&obj atIndex:i+2];
                    }
                }
                
                [invocation retainArguments];
                
                if(onMainThread) {
                    [invocation performSelectorOnMainThread:@selector(invoke)
                                                 withObject:nil
                                              waitUntilDone:waitUntilDone];
                }
                else {
                    [invocation performSelector:@selector(invoke)
                                       onThread:[NSThread currentThread]
                                     withObject:nil
                                  waitUntilDone:waitUntilDone];
                }
            }
            @catch (NSException * e) {
                //LOGEXCEPTION(e)
            }
            @finally {
                [signature release];
                [invocation release];
            }
        }
    }
}


#pragma -
#pragma Memory


-(void)dealloc {
    
    self.currentLocation = nil;
    [_connection release];
    
    [super dealloc];
    
    
}

@end

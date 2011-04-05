//
//  PlaceDetailController.m
//  WSILT
//
//  Created by Felipe Sabino on 4/4/11.
//  Copyright 2011 I.ndigo. All rights reserved.
//

#import "PlaceDetailController.h"


@implementation PlaceDetailController

-(void)loadView {
    
    [super loadView];
    
    
#ifdef DISABLE_GOOGLE_ANALYTICS
    
    if (![[GANTracker sharedTracker] trackPageview:@"/place_detail"
                                         withError:&error]) {
        NSLog(@"error in trackPageview");
    }
    
    
#endif    
    
    
}

@end

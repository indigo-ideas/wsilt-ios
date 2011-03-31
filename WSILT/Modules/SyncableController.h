//
//  SyncableController.h
//  IndigoProject
//
//  Created by Felipe Sabino on 3/29/11.
//  Copyright 2011 USP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FSFileSync.h"

@interface SyncableController : UIViewController <FSFileSyncDelegate> {
    
	UIActivityIndicatorView * _activityIndicator;
	int _filesToSync;
	NSArray *_toSync;
	NSMutableArray *_fileSyncArray;
	
	BOOL _showSyncActivityIndicator;
}

@property(nonatomic, retain) NSArray *toSync;


- (void) commitSync;

@end

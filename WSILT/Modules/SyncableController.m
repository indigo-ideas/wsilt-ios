//
//  SyncableController.m
//  IndigoProject
//
//  Created by Felipe Sabino on 3/29/11.
//  Copyright 2011 I.ndigo. All rights reserved.
//

#import "SyncableController.h"


@implementation SyncableController

- (void) syncFinished { }

@synthesize toSync = _toSync;


-(id)init
{
    self = [super init];
	if (self)
	{
		_fileSyncArray = [[NSMutableArray alloc] init];
		_showSyncActivityIndicator = YES;
		
	}
	return self;
}


// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
	[super loadView];
	
	_activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0.0, 20.0, 20.0f, 20.0f)];
	_activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
	[_activityIndicator sizeToFit];
	[self.view addSubview:_activityIndicator];
    
}

- (void) commitSync
{
	_filesToSync = 0;
	
	
	if (_toSync)
	{
		_filesToSync += [_toSync count];
        
        //Configuring slideshows
		for (int i = 0; i < [_toSync count]; i++) {
			
			NSString *string = [_toSync objectAtIndex:i];
			
			// start sync
			FSFileSync *fileSync = [[FSFileSync alloc] initWithResourceServerUrl:@"http://royalwedding.heroku.com"];
			fileSync.delegate = self;
			fileSync.versionControlFileName = [NSString stringWithFormat:@"version_control_%@.plist", string];
			[fileSync startSyncWithSyncServer:[NSString stringWithFormat:@"http://royalwedding.heroku.com/slideshow/versions/%@", string]];
			
			[_fileSyncArray addObject:fileSync];
			[fileSync release];
		}
	}
	
	
	if (_filesToSync > 0)
	{
		[NSThread detachNewThreadSelector:@selector(startLoadingAnimation) toTarget:self withObject:nil];
	}
	
    

    

}
    





#pragma mark -
#pragma mark Loading

- (void) startLoadingAnimation {
	
	NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
	if (_showSyncActivityIndicator) {
		[_activityIndicator startAnimating];
	}
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
	[pool release];
	
}

- (void) stopLoadingAnimation {
	NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
	
	if (_showSyncActivityIndicator) {
		[_activityIndicator stopAnimating];
	}
	
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
	[pool release];
}

#pragma mark -
#pragma mark File Sync Events

// Error in check with sync server
-(void) fileSync: (FSFileSync *) sync didReceiveErrorChecking: (NSError *)error {
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
	_filesToSync--;
	if (_filesToSync == 0) {
		[NSThread detachNewThreadSelector:@selector(stopLoadingAnimation) toTarget:self withObject:nil];
		[self performSelectorOnMainThread:@selector(syncFinished) withObject:nil waitUntilDone:YES];
	}
	
	[pool release];
}

// End checking with requests
-(void) fileSync: (FSFileSync *) sync didEndCheckWith: (NSNumber *) requests{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	if ([requests intValue] == 0) {
		_filesToSync--;
		if (_filesToSync == 0) {
			[NSThread detachNewThreadSelector:@selector(stopLoadingAnimation) toTarget:self withObject:nil];
			[self performSelectorOnMainThread:@selector(syncFinished) withObject:nil waitUntilDone:YES];
		}
	}
	[pool release];
}

// After synchronization with sync server is done
-(void) fileSync: (FSFileSync *) sync didFinishSyncWithPlist: (NSDictionary *) versions {
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
	_filesToSync--;
	
	if (_filesToSync == 0) {
		[NSThread detachNewThreadSelector:@selector(stopLoadingAnimation) toTarget:self withObject:nil];
		[self performSelectorOnMainThread:@selector(syncFinished) withObject:nil waitUntilDone:YES];
	}
	[pool release];
}



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}



#pragma mark -
#pragma mark Orientation
// Override to allow orientations other than the default portrait orientation. 
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
	NSLog(@"syncable controller dealloc");
	[_toSync release];
	[_fileSyncArray release];
    [super dealloc];
}



@end

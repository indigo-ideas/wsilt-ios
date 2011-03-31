//
//  FSFileSync.m
//  POC_SaveFile
//
//  Created by Bruno Toshio Sugano on 10/5/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "FSFileSync.h"


@implementation FSFileSync

@synthesize resourceServerUrl;
@synthesize delegate;
@synthesize versionControlFileName;
@synthesize plist;

#pragma mark -
#pragma mark Init

-(id) initWithResourceServerUrl: (NSString *) url{
	if ((self = [super init])) {
		progressIndicator = nil;
		self.resourceServerUrl = url;
		documentDir = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] retain];
	}
	return self;
}

#pragma mark -
#pragma mark Functions

-(void) didStartCheck
{
	//NSLog(@"didStartCheck will use delegate: %@", self);
	NSAutoreleasePool *p = [[NSAutoreleasePool alloc] init];
	if ([delegate respondsToSelector:@selector(fileSync:didStartCheckWithPlist:)]) {
		[delegate fileSync:self didStartCheckWithPlist:plist];
	}
	[p release];
}

-(void) didFailOnCheck: (NSError *)error {
	NSAutoreleasePool *p = [[NSAutoreleasePool alloc] init];
	
	//NSLog(@"didFailOnCheck will use delegate: %@", self);
	if ([delegate respondsToSelector:@selector(fileSync:didReceiveErrorChecking:)]) {
		[delegate fileSync:self didReceiveErrorChecking:error];
	}
	//NSLog(@"didFailOnCheck; delegate %@ released: %@", delegate, self);
	[delegate release]; //was retained on start sync
	delegate = nil;
	[p release];
}

-(void) didEndCheck {
	NSAutoreleasePool *p = [[NSAutoreleasePool alloc] init];
	
	//NSLog(@"didEndCheck will use delegate: %@", self);
	if ([delegate respondsToSelector:@selector(fileSync:didEndCheckWith:)]) {
		[delegate fileSync:self didEndCheckWith:[NSNumber numberWithInt:requestsTotal]];
	}
	if (requestsTotal == 0) {
		//NSLog(@"prepareSync request count 0; delegate %@ released: %@", delegate, self);
		[delegate release];
		delegate = nil;
	}
	
	[p release];
}

-(void) didStartSync
{
	NSAutoreleasePool *p = [[NSAutoreleasePool alloc] init];
	
	//NSLog(@"didStartSync will use delegate: %@", self);
	if ([delegate respondsToSelector:@selector(fileSync:didStartSyncWith:)]) {
		[delegate fileSync:self didStartSyncWith:[NSNumber numberWithInt:requestsTotal]];
	}
	[p release];
}

-(void) didFinishSyncFileX:(NSArray *)args
{
	NSAutoreleasePool *p = [[NSAutoreleasePool alloc] init];
	
	//NSLog(@"didFinishSyncFileX will use delegate: %@", self);
	if ([delegate respondsToSelector:@selector(fileSync:didFinishSyncFile:duringSyncType:)]) {
		[delegate fileSync:self didFinishSyncFile:[args objectAtIndex:0] duringSyncType:(FSFileSyncType)[[args objectAtIndex:1] intValue]];
	}
	[p release];
}

-(void) didFailWithError: (NSArray *) args {
	NSAutoreleasePool *p = [[NSAutoreleasePool alloc] init];
	
	//NSLog(@"didFailWithError will use delegate: %@", self);
	if ([delegate respondsToSelector:@selector(fileSync:didReceiveError:inFile:duringSyncType:)]) {
		[delegate fileSync:self didReceiveError:[args objectAtIndex:0] inFile:[args objectAtIndex:1] duringSyncType:(FSFileSyncType)[[args objectAtIndex:2] intValue]];
	}
	[p release];
}

-(void) didFinishSync
{
	NSAutoreleasePool *p = [[NSAutoreleasePool alloc] init];
	
	//NSLog(@"didFinishSync will use delegate: %@", self);
	
	if ([delegate respondsToSelector:@selector(fileSync:didFinishSyncWithPlist:)]) {
		[delegate fileSync:self didFinishSyncWithPlist:plist];
	}
	
	//NSLog(@"didFinishSync; delegate %@ released: %@", delegate, self);
	
	[delegate release]; //was retained on start sync
	delegate = nil;
	[p release];
}

-(void) changeRequestCount {
	@synchronized(self) {
		requestCount--;
		[self requestCountChangedWithNewValue: requestCount];
	}
}

-(void) setProgressIndicator: (UIProgressView *)indicator {
	progressIndicator = [indicator retain];
}

#pragma mark -
#pragma mark Checking process

-(void) startSyncWithSyncServer: (NSString *)syncServerUrl {
	[delegate retain]; //will be relased only after sync finishes or fails
	
	//NSLog(@"startSyncWithSyncServer; delegate %@ retained: %@", delegate, self);
	
	//Send Device ID
	UIDevice *myDevice = [UIDevice currentDevice];
	NSString *deviceUDID = [myDevice uniqueIdentifier];

	NSMutableString *syncServerMutableUrl = [[NSMutableString alloc] initWithString:syncServerUrl];
	
	[syncServerMutableUrl appendString:[NSString stringWithFormat:@"?deviceID=%@", deviceUDID]];
	
	
    //NSLog([NSString stringWithFormat:@"after: %@", syncServerMutableUrl ]);
	
	NSURL *url = [NSURL URLWithString:syncServerMutableUrl];
	
	[syncServerMutableUrl release];
	
	// Building pList
	BOOL isFolder = NO;
	NSFileManager *fileManager = [NSFileManager defaultManager];
	if (![fileManager fileExistsAtPath:[NSString stringWithFormat:@"%@/%@", documentDir, versionControlFileName] isDirectory:&isFolder]) {
		NSDictionary *initialPlist = [NSDictionary dictionary];
		[initialPlist writeToFile:[NSString stringWithFormat:@"%@/%@", documentDir, versionControlFileName] atomically:YES];
	}
	self.plist = [NSMutableDictionary dictionaryWithContentsOfFile:[NSString stringWithFormat:@"%@/%@", documentDir, versionControlFileName]];
	NSDictionary *versionControl = [NSDictionary dictionaryWithDictionary:plist];
	
	// Setting request count
	requestCount = 0;

	[NSThread detachNewThreadSelector:@selector(didStartCheck) toTarget:self withObject:nil];
	
	
	
	// Start Checking with sync server
	ASIFormDataRequest *syncRequest = [[[ASIFormDataRequest alloc] initWithURL:url] autorelease];

	[syncRequest setPostValue:[versionControl JSONRepresentation] forKey:@"versions"];
	[syncRequest setDidFinishSelector:@selector(prepareSync:)];
	[syncRequest setDidFailSelector:@selector(checkFailed:)];
	[syncRequest setDelegate:self];
	
	[syncRequest startAsynchronous];
	
	//NSLog(@"sync request started: %@", self);
	
}	 

-(void) checkFailed: (ASIHTTPRequest *) request {
	[NSThread detachNewThreadSelector:@selector(didFailOnCheck:) toTarget:self withObject:[request error]];
}


#pragma mark -
#pragma mark Synchronization process

-(void) prepareSync: (ASIHTTPRequest *)request {
	NSString *json = [request responseString];
	NSArray *fileInfos = [json JSONValue];
	NSString *status;
	ASIHTTPRequest *req;
	NSString *resourceUrl;
	NSString *url;
	
	requestCount = [fileInfos count];
	requestsTotal = requestCount;

	[NSThread detachNewThreadSelector:@selector(didEndCheck) toTarget:self withObject:nil];
	if (requestCount > 0) {
		
		[NSThread detachNewThreadSelector:@selector(didStartSync) toTarget:self withObject:nil];

	}


	queue = [[ASINetworkQueue alloc] init];
	[queue setMaxConcurrentOperationCount:1]; //if changed please review the delegate retain/release rule!!!
	
	if (progressIndicator != nil) {
		//[queue setDownloadProgressDelegate:progressIndicator];
	}
	
	for (NSDictionary *fileInfo in fileInfos){
		
		status = [fileInfo objectForKey:@"status"];
		if ([status isEqualToString:@"A"]) {
			
			
			url = [self urlEncodeValue:[fileInfo objectForKey:@"file"]];
			
			//http://192.168.1.158:3000/path/to/resource/aaa.png -> path/to/resource/aaa.png
			url = [url stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@/", resourceServerUrl] withString:@""];
			
			//path/to/resource
			int p = [url rangeOfString:@"/" options:NSBackwardsSearch].location;
			NSString *partDir = [url substringToIndex:p];
			
			//Directory part
			NSString *dirs = [NSString stringWithFormat:@"%@/Source/%@", documentDir, partDir];
			BOOL isDirectory = YES;
			NSFileManager *fileManager = [NSFileManager defaultManager];
			NSError *error = nil;
			if (![fileManager fileExistsAtPath:dirs isDirectory:&isDirectory]) {
				[fileManager createDirectoryAtPath:dirs withIntermediateDirectories:YES attributes:nil error:&error];
				if (error != nil) {
					//NSLog(@"%@", [error description]);
				}
			}
			
			
			// Added -> Send Request to add new file
			resourceUrl = [NSString stringWithFormat:@"%@/%@", resourceServerUrl, [self urlEncodeValue:[fileInfo objectForKey:@"file"]]];
			req = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:resourceUrl]];
			[req setDidFinishSelector:@selector(addFile:)];
			[req setDidFailSelector:@selector(errorOnAddFile:)];
			[req setDownloadDestinationPath:[NSString stringWithFormat:@"%@/Source/%@", documentDir, url]];
			[req setDelegate:self];
			[req setUserInfo:fileInfo];
			
			[queue addOperation:req];
		}
		else if([status isEqualToString:@"M"]){
			
			url = [self urlEncodeValue:[fileInfo objectForKey:@"file"]];
			
			//http://192.168.1.158:3000/path/to/resource/aaa.png -> path/to/resource/aaa.png
			url = [url stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@/", resourceServerUrl] withString:@""];
			
			
			// Modified -> Send Request to update file
			resourceUrl = [NSString stringWithFormat:@"%@/%@", resourceServerUrl, [self urlEncodeValue:[fileInfo objectForKey:@"file"]]];
			req = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:resourceUrl]];
			[req setDidFinishSelector:@selector(updateFile:)];
			[req setDidFailSelector:@selector(errorOnUpdateFile:)];
			[req setDownloadDestinationPath:[NSString stringWithFormat:@"%@/Source/%@", documentDir, url]];
			[req setDelegate:self];
			[req setUserInfo:fileInfo];
			
			[queue addOperation:req];
		}
		else {
			
			// Deleted -> Delete file
			NSFileManager *fMan = [NSFileManager defaultManager];
			[fMan removeItemAtPath:[NSString stringWithFormat:@"%@/Source/%@",documentDir, [fileInfo objectForKey:@"file"]] error:nil];
			
			[plist removeObjectForKey:[fileInfo objectForKey:@"file"]];
			[self changeRequestCount];
			[NSThread detachNewThreadSelector:@selector(didFinishSyncFileX:) toTarget:self withObject:[NSArray arrayWithObjects:[fileInfo objectForKey:@"file"], [NSNumber numberWithInt:FSFileSyncTypeRemove], nil]];
			
		}
		
		
	}
	
	[queue go];
}


- (void) errorOnAddFile: (ASIHTTPRequest *)request {
	[self changeRequestCount];
	[NSThread detachNewThreadSelector:@selector(didFailWithError:) toTarget:self withObject:[NSArray arrayWithObjects:[request error], [[request userInfo] objectForKey:@"file"], [NSNumber numberWithInt:FSFileSyncTypeAdd], nil]];
}

- (void) errorOnUpdateFile: (ASIHTTPRequest *)request {
	[self changeRequestCount];
	[NSThread detachNewThreadSelector:@selector(didFailWithError:) toTarget:self withObject:[NSArray arrayWithObjects:[request error], [[request userInfo] objectForKey:@"file"], [NSNumber numberWithInt:FSFileSyncTypeUpdate], nil]];
	
}


- (void) addFile:(ASIHTTPRequest *)request {
	
	NSString *url = [self stringFromURL:[[request originalURL] absoluteString]];
	
	//http://192.168.1.158:3000/path/to/resource/aaa.png -> path/to/resource/aaa.png
	url = [url stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@/", resourceServerUrl] withString:@""];

	
	/*
	NSData *data = [request responseData];
	NSString *contentType = [[request responseHeaders] valueForKey:@"Content-Type"];
	UIImage *image = nil;
	
	
	//path/to/resource and aaa.png
	int p = [url rangeOfString:@"/" options:NSBackwardsSearch].location;
	NSString *partDir = [url substringToIndex:p];
	NSString *partFile = [url substringFromIndex:(p+1)];

	//Directory part
	NSString *dirs = [NSString stringWithFormat:@"%@/Source/%@", documentDir, partDir];
	BOOL isDirectory = YES;
	NSFileManager *fileManager = [NSFileManager defaultManager];
	NSError *error = nil;
	if (![fileManager fileExistsAtPath:dirs isDirectory:&isDirectory]) {
		[fileManager createDirectoryAtPath:dirs withIntermediateDirectories:YES attributes:nil error:&error];
		if (error != nil) {
			NSLog(@"%@", [error description]);
		}
	}
	
	//File part
	NSString *filePath = [NSString stringWithFormat:@"%@/%@", dirs, partFile];
	NSData *data1 = nil;
	if ([contentType isEqualToString:@"image/png"]) {
		image = [[UIImage alloc] initWithData:data];
		data1 = [NSData dataWithData:UIImagePNGRepresentation(image)];
	}
	else if ([contentType isEqualToString:@"image/jpeg"]){
		image = [[UIImage alloc] initWithData:data];
		data1 = [NSData dataWithData:UIImageJPEGRepresentation(image, 0.0)];
	}
	else if ([contentType isEqualToString:@"text/plain"]){
		data1 = [NSData dataWithData:data];
	}
	else {
		data1 = [NSData dataWithData:data];
	}

	
	[data1 writeToFile:filePath atomically:YES];
	
	[image release];
	*/
	
	
	// Add pList -> must be thread-safe
	NSString *hash = [[request userInfo] objectForKey:@"hash"];
	NSDictionary *fileInfo = [[NSDictionary alloc] initWithObjects:[NSArray arrayWithObjects:[url stringByReplacingPercentEscapesUsingEncoding:NSASCIIStringEncoding], hash, nil] forKeys:[NSArray arrayWithObjects:@"file", @"hash", nil]];
	
	[self addItem:fileInfo ForKey:[url stringByReplacingPercentEscapesUsingEncoding:NSASCIIStringEncoding]];
	[fileInfo release];
	
	[self changeRequestCount];
	
	[NSThread detachNewThreadSelector:@selector(didFinishSyncFileX:) toTarget:self withObject:[NSArray arrayWithObjects:[[request userInfo] objectForKey:@"file"], [NSNumber numberWithInt:FSFileSyncTypeAdd], nil]];
	
}

- (void) updateFile:(ASIHTTPRequest *)request {
	
	NSString *url = [self stringFromURL:[[request originalURL] absoluteString]];
	
	//http://192.168.1.158:3000/path/to/resource/aaa.png -> path/to/resource/aaa.png
	url = [url stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@/", resourceServerUrl] withString:@""];
	
	
	/*
	NSData *data = [request responseData];
	NSString *contentType = [[request responseHeaders] valueForKey:@"Content-Type"];
	UIImage *image = nil;
	
	//path/to/resource and aaa.png
	int p = [url rangeOfString:@"/" options:NSBackwardsSearch].location;
	NSString *partDir = [url substringToIndex:p];
	NSString *partFile = [url substringFromIndex:(p+1)];
	
	//Directory part
	NSString *dirs = [NSString stringWithFormat:@"%@/Source/%@", documentDir, partDir];
	BOOL isDirectory = YES;
	NSFileManager *fileManager = [NSFileManager defaultManager];
	NSError *error = nil;
	if (![fileManager fileExistsAtPath:dirs isDirectory:&isDirectory]) {
		[fileManager createDirectoryAtPath:dirs withIntermediateDirectories:YES attributes:nil error:&error];
		if (error != nil) {
			NSLog(@"%@", [error description]);
		}
	}
	
	//File part
	NSString *filePath = [NSString stringWithFormat:@"%@/%@", dirs, partFile];
	NSData *data1 = nil;
	if ([contentType isEqualToString:@"image/png"]) {
		image = [[UIImage alloc] initWithData:data];
		data1 = [NSData dataWithData:UIImagePNGRepresentation(image)];
	}
	else if ([contentType isEqualToString:@"image/jpeg"]){
		image = [[UIImage alloc] initWithData:data];
		data1 = [NSData dataWithData:UIImageJPEGRepresentation(image, 0.0)];
	}
	else if ([contentType isEqualToString:@"text/plain"]){
		data1 = [NSData dataWithData:data];
	}
	else {
		data1 = [NSData dataWithData:data];
	}
	
	
	[data1 writeToFile:filePath atomically:YES];
	
	[image release];
	
	*/ 
	 
	// Add pList -> must be thread-safe
	NSString *hash = [[request userInfo] objectForKey:@"hash"];
	NSDictionary *fileInfo = [[NSDictionary alloc] initWithObjects:[NSArray arrayWithObjects:[url stringByReplacingPercentEscapesUsingEncoding:NSASCIIStringEncoding], hash, nil] forKeys:[NSArray arrayWithObjects:@"file", @"hash", nil]];
	
	[self addItem:fileInfo ForKey:[url stringByReplacingPercentEscapesUsingEncoding:NSASCIIStringEncoding]];
	
	[self changeRequestCount];
	[NSThread detachNewThreadSelector:@selector(didFinishSyncFileX:) toTarget:self withObject:[NSArray arrayWithObjects:[[request userInfo] objectForKey:@"file"], [NSNumber numberWithInt:FSFileSyncTypeUpdate], nil]];
	
	[fileInfo release];
}

-(void) addItem: (NSDictionary *)item ForKey:(NSString *)key {
	@synchronized(self){
		[plist setValue:item forKey:key];	
	}
}


- (void) requestCountChangedWithNewValue: (int) newValue {
	[plist writeToFile:[NSString stringWithFormat:@"%@/%@", documentDir, versionControlFileName] atomically:YES];
	if (newValue == 0) {
		[NSThread detachNewThreadSelector:@selector(didFinishSync) toTarget:self withObject:nil];
	}
}
				   

#pragma mark -
#pragma mark URL helper

- (NSString *)urlEncodeValue:(NSString *)str
{
	NSString *result = (NSString *) CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)str, NULL, CFSTR(":?#[]@!$&’()*+,;="), kCFStringEncodingUTF8);
	return [result autorelease];
	
}

- (NSString *)stringFromURL: (NSString *) encodedUrl 
{
	NSString *result = (NSString *) CFURLCreateStringByReplacingPercentEscapesUsingEncoding(kCFAllocatorDefault, (CFStringRef)encodedUrl, CFSTR(":?#[]@!$&’()*+,;="), kCFStringEncodingUTF8);
	return [result autorelease];
}

#pragma mark -
#pragma mark Dealloc

-(void) dealloc {
	//NSLog(@"Fylesync dealloc");
	[versionControlFileName release];
	[plist release];
	[documentDir release];
	[resourceServerUrl release];
	[progressIndicator release];
	[queue release];
	[super dealloc];
}

@end


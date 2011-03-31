//
//  FSFileSync.h
//  POC_SaveFile
//
//  Created by Bruno Toshio Sugano on 10/5/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "ASINetworkQueue.h"
#import "JSONFramework.h"

@protocol FSFileSyncDelegate;

typedef enum
{
	FSFileSyncTypeAdd,
	FSFileSyncTypeUpdate,
	FSFileSyncTypeRemove
} FSFileSyncType;

@interface FSFileSync : NSObject {
	int requestCount;
	int requestsTotal;
	NSString *resourceServerUrl;
	NSString *documentDir;
	NSMutableDictionary *plist;
	ASINetworkQueue *queue;
	id delegate;
	UIProgressView *progressIndicator;
	NSString * versionControlFileName;
}

@property (nonatomic,retain) NSString* versionControlFileName;
@property (nonatomic,retain) NSString* resourceServerUrl;
@property (nonatomic, retain) NSMutableDictionary *plist;
@property (assign) id<FSFileSyncDelegate> delegate;

-(id) initWithResourceServerUrl: (NSString *) url;
-(void) addItem: (NSDictionary *)item ForKey:(NSString *)key;
-(void) startSyncWithSyncServer: (NSString *)syncServerUrl;
- (void) requestCountChangedWithNewValue: (int) newValue;
- (NSString *)urlEncodeValue:(NSString *)str;
- (NSString *)stringFromURL: (NSString *) encodedUrl;
-(void) setProgressIndicator: (UIProgressView *)indicator;

@end

@protocol FSFileSyncDelegate<NSObject>

@optional
// Before sending request to sync server
-(void) fileSync: (FSFileSync *) sync didStartCheckWithPlist: (NSDictionary *) versions;

// Error in check with sync server
-(void) fileSync: (FSFileSync *) sync didReceiveErrorChecking: (NSError *)error;

// End checking with requests
-(void) fileSync: (FSFileSync *) sync didEndCheckWith: (NSNumber *) requests;

// Before synchronization with sync server
-(void) fileSync: (FSFileSync *) sync didStartSyncWith: (NSNumber *) requests;

// Error in synchronization of file
-(void) fileSync: (FSFileSync *) sync didReceiveError: (NSError *)error inFile: (NSString *)file duringSyncType: (FSFileSyncType)syncType;

// After synchronization with sync server is done
-(void) fileSync: (FSFileSync *) sync didFinishSyncWithPlist: (NSDictionary *) versions;

// After synchronization of each file
-(void) fileSync: (FSFileSync *) sync didFinishSyncFile: (NSString *)fileName duringSyncType: (FSFileSyncType)syncType;

@end


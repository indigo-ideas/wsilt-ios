//
//  PCPushClient.m
//  POCPushNotification
//
//  Created by Bruno Toshio Sugano on 3/18/11.
//  Copyright 2011 I.ndigo. All rights reserved.
//

#import "PCPushClient.h"
#import "ASIFormDataRequest.h"
#import "ASINetworkQueue.h"
#import "SPSimplePersisterComponent.h"

#define PUSH_CLIENT_COMPONENT_RegisterPath @"register"
#define PUSH_CLIENT_COMPONENT_Persist_TokenIdKey @"PushClient_TokenId"
#define PUSH_CLIENT_COMPONENT_Persist_ServerUrlKey @"PushClient_ServerUrl"
#define PUSH_CLIENT_COMPONENT_Persist_PendingRegisterKey @"PushClient_pendingRegister"

@interface PCPushClient (Private)

-(void) clearQueue;
-(BOOL) hasPendingRegistration;

@end



@implementation PCPushClient

@synthesize deviceId = _deviceId;
@synthesize delegate = _del;


+(id) pushClientForPendingRegistrationWithPersister: (SPSimplePersisterComponent *)persister {
	
	if ([persister containsKey:PUSH_CLIENT_COMPONENT_Persist_TokenIdKey] && [persister containsKey:PUSH_CLIENT_COMPONENT_Persist_ServerUrlKey]) {
		PCPushClient *client = [[PCPushClient alloc] initWithDeviceToken:[persister objectForKey:PUSH_CLIENT_COMPONENT_Persist_TokenIdKey] 
															AndServerUrl:[persister objectForKey:PUSH_CLIENT_COMPONENT_Persist_ServerUrlKey] 
															AndPersister:persister];
		return [client autorelease];
	}
	else {
		return nil;
	}

}

-(id) initWithDeviceToken: (NSData *)token AndServerUrl: (NSString *)url AndPersister: (SPSimplePersisterComponent *)persister{
	if ((self = [super init])) {
		_deviceId = [token retain];
		_serverUrl = [url retain];
		_persister = [persister retain];
		
		[_persister setObject:_deviceId ForKey:PUSH_CLIENT_COMPONENT_Persist_TokenIdKey WriteToFile:NO];
		[_persister setObject:_serverUrl ForKey:PUSH_CLIENT_COMPONENT_Persist_ServerUrlKey WriteToFile:YES];
		
	}
	return self;
}

-(void) registerDevice {
	if (_queue == nil) {
		_queue = [[ASINetworkQueue alloc] init];
		[_queue setMaxConcurrentOperationCount:1];
	}
	
	ASIFormDataRequest *req = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", [_serverUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding], PUSH_CLIENT_COMPONENT_RegisterPath]]];
	[req setPostValue:_deviceId forKey:@"id"];
	[req setDelegate:self];
	
	[_queue addOperation:req];
	[_queue go];
}

-(void) clearQueue {
	for (ASIHTTPRequest *req in [_queue operations]) {
		[req clearDelegatesAndCancel];
	}
}

-(void) processPendingRegistration {
	if ([self hasPendingRegistration]) {
		[self registerDevice];
	}
}

-(BOOL) hasPendingRegistration {
	
	if ([_persister containsKey:PUSH_CLIENT_COMPONENT_Persist_PendingRegisterKey]) {
		return [_persister boolForKey:PUSH_CLIENT_COMPONENT_Persist_PendingRegisterKey];
	}
	else {
		return NO;
	}

}

#pragma mark -
#pragma mark ASIHTTPRequestDelegate

- (void)requestFinished:(ASIHTTPRequest *)request
{
	
	[_persister setBool:NO ForKey:PUSH_CLIENT_COMPONENT_Persist_PendingRegisterKey WriteToFile:YES];
	
	if ([_del respondsToSelector:@selector(pushClientDidFinish:)]) {
		[_del pushClientDidFinish:self];
	}
}

- (void)requestFailed:(ASIHTTPRequest *)request
{

#ifdef COMPONENT_PCPushClient_DEBUG_MODE
	NSLog(@"PCPushClient: %@, received error: %@", self, [[request error] description]);
#endif
	
	[_persister setBool:YES ForKey:PUSH_CLIENT_COMPONENT_Persist_PendingRegisterKey WriteToFile:YES];
	
	if ([_del respondsToSelector:@selector(pushClient:FailedWithError:)]) {
		[_del pushClient:self FailedWithError:[request error]];
	}
}

#pragma mark -
#pragma mark Dealloc

-(void) dealloc {
	[self clearQueue];
	[_queue release];
	[_deviceId release];
	[_serverUrl release];
	[_persister release];
	
	[super dealloc];
}


@end

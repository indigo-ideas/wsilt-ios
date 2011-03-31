//
//  PCPushClient.h
//  POCPushNotification
//
//  Created by Bruno Toshio Sugano on 3/18/11.
//  Copyright 2011 I.ndigo. All rights reserved.
//

#import <Foundation/Foundation.h>

#define COMPONENT_PCPushClient_DEBUG_MODE 1


@class ASINetworkQueue;
@class PCPushClient;
@class SPSimplePersisterComponent;

@protocol PCPushClientDelegate<NSObject>

-(void) pushClientDidFinish: (PCPushClient *)client;
-(void) pushClient: (PCPushClient *)client FailedWithError: (NSError *) error;

@end



@interface PCPushClient : NSObject {
	NSData * _deviceId;
	NSString * _serverUrl;
	ASINetworkQueue *_queue;
	id<PCPushClientDelegate> _del;
	SPSimplePersisterComponent *_persister;
}

@property(nonatomic, readonly) NSData *deviceId;
@property(assign) id<PCPushClientDelegate> delegate;

-(id) initWithDeviceToken: (NSData *)token AndServerUrl: (NSString *)url AndPersister: (SPSimplePersisterComponent *)persister;
-(void) registerDevice;
-(void) processPendingRegistration;

+(id) pushClientForPendingRegistrationWithPersister: (SPSimplePersisterComponent *)persister;

@end

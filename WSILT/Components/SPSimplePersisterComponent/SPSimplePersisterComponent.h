//
//  SPSimplePersisterComponent.h
//  POCPushNotification
//
//  Created by Bruno Toshio Sugano on 3/22/11.
//  Copyright 2011 I.ndigo. All rights reserved.
//

#import <Foundation/Foundation.h>

#define COMPONENT_SPSimplePersister_DEBUG_MODE 1

@interface SPSimplePersisterComponent : NSObject {
	NSString *_key;
	NSMutableDictionary *_plist;
}

-(id) initWithKeyFile: (NSString *)key;
-(NSString *) getKey;
-(BOOL) containsKey: (NSString *)key;
-(id) objectForKey: (NSString *)key;
-(int) intForKey: (NSString *)key;
-(BOOL) boolForKey: (NSString *)key;
-(void) setObject: (id)obj ForKey: (NSString *)key WriteToFile: (BOOL)now;
-(void) setInt: (int)obj ForKey: (NSString *)key WriteToFile: (BOOL)now;
-(void) setBool: (BOOL)obj ForKey: (NSString *)key WriteToFile: (BOOL)now;

-(void) save;

+(void) deleteFileWithKey: (NSString *)key;

@end

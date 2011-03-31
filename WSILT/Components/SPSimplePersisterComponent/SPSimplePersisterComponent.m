//
//  SPSimplePersisterComponent.m
//  POCPushNotification
//
//  Created by Bruno Toshio Sugano on 3/22/11.
//  Copyright 2011 I.ndigo. All rights reserved.
//

#import "SPSimplePersisterComponent.h"

#define SIMPLE_PERSISTER_COMPONENT_FileName @"sp_simple_persister"

@implementation SPSimplePersisterComponent


#pragma mark -
#pragma mark Instance Methods

-(id) initWithKeyFile: (NSString *)key {
	if ((self = [super init])) {
		_key = [key retain];
		
		NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
		NSFileManager *man = [NSFileManager defaultManager];
		if ([man fileExistsAtPath:[NSString stringWithFormat:@"%@/%@%@.plist", docDir, SIMPLE_PERSISTER_COMPONENT_FileName, _key]]) {
			_plist = [[NSMutableDictionary dictionaryWithContentsOfFile:[NSString stringWithFormat:@"%@/%@%@.plist", docDir, SIMPLE_PERSISTER_COMPONENT_FileName, _key]] retain];
		}
		else {
			_plist = [[NSMutableDictionary alloc] init];
			[_plist writeToFile:[NSString stringWithFormat:@"%@/%@%@.plist", docDir, SIMPLE_PERSISTER_COMPONENT_FileName, _key] atomically:YES];
		}

	}
	
	return self;
}


-(NSString *) getKey {
	return [[_key retain] autorelease];
}


-(BOOL) containsKey: (NSString *)key {
	if ([_plist objectForKey:key] == nil) {
		return NO;
	}
	else {
		return YES;
	}

}


-(id) objectForKey: (NSString *)key {
	return [_plist objectForKey:key];
}


-(int) intForKey: (NSString *)key {
	return [(NSNumber *)[_plist objectForKey:key] intValue];
}

-(BOOL) boolForKey: (NSString *)key {
	return [(NSNumber *)[_plist objectForKey:key] boolValue];
}

-(void) setObject: (id)obj ForKey: (NSString *)key  WriteToFile: (BOOL)now {
	[_plist setObject:obj forKey:key];
	if (now) {
		[self save];
	}
}

-(void) setInt: (int)obj ForKey: (NSString *)key WriteToFile: (BOOL)now {
	[_plist setObject:[NSNumber numberWithInt:obj] forKey:key];
	if (now) {
		[self save];
	}
}

-(void) setBool: (BOOL)obj ForKey: (NSString *)key WriteToFile: (BOOL)now {
	[_plist setObject:[NSNumber numberWithBool:obj] forKey:key];
	if (now) {
		[self save];
	}
}


-(void) save {
	NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
	[_plist writeToFile:[NSString stringWithFormat:@"%@/%@%@.plist", docDir, SIMPLE_PERSISTER_COMPONENT_FileName, _key] atomically:YES];
}


#pragma mark -
#pragma mark Class Methods

+(void) deleteFileWithKey: (NSString *)key {
	NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
	NSFileManager *man = [NSFileManager defaultManager];
	NSError *error = nil;
	[man removeItemAtPath:[NSString stringWithFormat:@"%@/%@%@.plist", docDir, SIMPLE_PERSISTER_COMPONENT_FileName, key] error:&error];
	
#ifdef COMPONENT_SPSimplePersister_DEBUG_MODE
	if (error != nil) {
		NSLog(@"SPSimplePersister - Delete file with key: %@, raised an error: %@", key, [error description]);
	}
#endif
	
}


#pragma mark -
#pragma mark Dealloc

-(void) dealloc {
	[_key release];
	[_plist release];
	[super dealloc];
}

@end

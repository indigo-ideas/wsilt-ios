//
//  NSString+DateParse.m
//  NBC
//
//  Created by Felipe Sabino on 11-03-03.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NSString+DateParse.h"


@implementation NSString (DateParse) 

-(NSDate *) dateFromISO8601 {
		
	NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];
	NSString *format = ([self hasSuffix:@"Z"]) ? @"yyyy-MM-dd'T'HH:mm:ss'Z'" : @"yyyy-MM-dd'T'HH:mm:ssz";
	[formatter setFormatterBehavior:NSDateFormatterBehavior10_4];
	[formatter setDateFormat:format];
	[formatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"GMT"]];
	return [formatter dateFromString:self];

}

@end

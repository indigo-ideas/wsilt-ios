//
//  NSData+Base64.h
//  NBC
//
//  Created by Raphael Petegrosso on 23/02/11.
//  Copyright 2011 I.ndigo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Base64)

- (NSData *)decodeBase64WithString;

@end

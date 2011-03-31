//
//  UILabel+CharLimit.m
//  NBC
//
//  Created by Felipe Sabino on 11-02-28.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "UILabel+CharLimit.h"


@implementation UILabel (UILabel_CharLimit)

-(void) formatTextWithMaxNumberOfLines: (int) maxNumberOfLines {
	
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
	if (self.text == nil || 
		self.font == nil ||
		maxNumberOfLines <= 0 || 
		maxNumberOfLines >= 99999) {
		return;
	}
		
	float lineHeight = self.font.lineHeight;// + self.font.pointSize;
	int currentTotalChars = [self.text length];
	NSString *textString  = self.text;
	
	UILabel *labelToMeasure = [[UILabel alloc] initWithFrame:self.frame];
	[labelToMeasure setFont:self.font];
	[labelToMeasure setText: textString];
	[labelToMeasure setNumberOfLines:0];
	[labelToMeasure setLineBreakMode:self.lineBreakMode];
	[labelToMeasure sizeToFit];
	
	int currentNumberOfLines = ceil(labelToMeasure.frame.size.height / lineHeight);
	[labelToMeasure release];
	labelToMeasure = nil;
	
	
	if (currentNumberOfLines > 0 && currentNumberOfLines > maxNumberOfLines) {

		int charPerLineRatio = floorf(currentTotalChars / currentNumberOfLines);
		
		while (currentNumberOfLines > maxNumberOfLines && currentTotalChars > 2) {
			
			if (currentNumberOfLines >= maxNumberOfLines + 5) {
				currentTotalChars-= 3*charPerLineRatio;
			} else {
				currentTotalChars--;
			}

			textString = [[textString substringToIndex:currentTotalChars] stringByAppendingString:@"..."];
			
			UILabel *label = [[UILabel alloc] initWithFrame:self.frame];
			[label setFont:self.font];
			[label setText: textString];
			[label setNumberOfLines:0];
			[label setLineBreakMode:self.lineBreakMode];
			[label sizeToFit];
			
			currentNumberOfLines = ceil(label.frame.size.height / lineHeight);
			//NSLog(@"text: %@; lines: %d; label frame: %@", textString, currentNumberOfLines, label);
			
			[label release];
			label = nil;
		}
		
	}
	
	self.text = textString;	
		

	[pool release];
}

@end

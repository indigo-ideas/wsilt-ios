//
//  TCImageView.h
//  TCImageViewDemo
//


#import <Foundation/Foundation.h>
#import "UIThumbnailView.h"

#define CACHED_IMAGE_JPEG_QUALITY 1.0


@class TCImageView;

@protocol TCImageViewDelegate<NSObject>

-(void) TCImageView:(TCImageView *) view WillUpdateImage:(UIImage *)image;
-(void) TCImageView:(TCImageView *) view FinisehdImage:(UIImage *)image;

@end



@interface TCImageView : UIImageView {
    
    // Default
    NSString* _url;
    UIView* _placeholder;
    
    // Networking
    NSURLConnection *_connection;
    NSMutableData *_data;

    // Caching
    BOOL _caching;
    NSTimeInterval _cacheTime;
	
	id<TCImageViewDelegate> _delegate;
    
}
@property (readonly) NSString* url;
@property (readonly) UIView* placeholder;
@property (assign,readwrite,getter = isCaching) BOOL caching;
@property (assign,readwrite) NSTimeInterval cacheTime;

@property (assign) id<TCImageViewDelegate> delegate;

+ (void)resetGlobalCache; // This will remove all cached images managed by any TCImageView instatces
+ (NSString*)cacheDirectoryAddress;

- (id)initWithURL:(NSString *)url placeholder:(UIView *)placeholderView;

- (void)loadImage;

- (NSString*)cachedImageSystemName;

- (void)resetCache;


#pragma Delegate Methods

-(void) willUpdateImage: (UIImage *) image;
-(void) finishedImage: (UIImage *) image;

@end

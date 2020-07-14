//
//  PortImgView.m
//  Thali&Pickles
//
//  Created by Emon on 11/25/19.
//  Copyright © 2019 Emon. All rights reserved.
//

#import "PortImgView.h"

@implementation PortImgView
- (void)setUp
{
    self.showActivityIndicator = NO;
    self.activityIndicatorStyle = UIActivityIndicatorViewStyleWhite;
    self.activityIndicatorColor = [UIColor lightGrayColor];
    self.crossfadeDuration = 1.5;//0.4
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame]))
    {
        [self setUp];
    }
    return self;
}

- (void)setActivityIndicatorStyle:(UIActivityIndicatorViewStyle)style
{
    _activityIndicatorStyle = style;
    [self.activityView removeFromSuperview];
    self.activityView = nil;
}

- (void)setActivityIndicatorColor:(UIColor *)activityIndicatorColor
{
    _activityIndicatorColor = activityIndicatorColor;
    self.activityView.color = activityIndicatorColor;
}


- (void)setImgWithURL:(nullable NSURL *)url
     placeholderImage:(nullable UIImage *)placeholder{
    super.image = placeholder;
    if (self.showActivityIndicator)
    {
        if (self.activityView == nil)
        {
            self.activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:self.activityIndicatorStyle];
            self.activityView.color = self.activityIndicatorColor;
            self.activityView.hidesWhenStopped = YES;
            self.activityView.center = CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2);
            self.activityView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
            [self addSubview:self.activityView];
        }
        [self.activityView startAnimating];
    }
    //[NSURL URLWithString:@"https://images.pexels.com/photos/459225/pexels-photo-459225.jpeg"]
    [self sd_setImageWithURL:url placeholderImage:placeholder options:SDWebImageContinueInBackground progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL)
     {
//         CGFloat domandeFloat = [[NSNumber numberWithInteger: receivedSize] floatValue];
//         CGFloat corretteFloat = [[NSNumber numberWithInteger: expectedSize] floatValue];
//         float currentProgress = (domandeFloat/corretteFloat)*100;
         //NSLog(@"progress %.f%%",currentProgress);
         //DBG(@"%li, %li", receivedSize, expectedSize);
         //[_progress setValue:currentProgress];
     } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
         //[_progress setHidden:YES];
         //NSLog(@"absoluteString  %@",imageURL.absoluteString);
         if (self.activityView){
             [self.activityView stopAnimating];
     }
         if (image) {
             if (image != self.image && self.crossfadeDuration > 0)
                 {
                     CATransition *animation = [CATransition animation];
                     animation.type = kCATransitionFade;
                     animation.duration = self.crossfadeDuration;
                     [self.layer addAnimation:animation forKey:nil];
                 }
             super.image = image;
         }else{
             NSLog(@"IMAGE NOT LOADED");
         }
     }];
    
}
@end

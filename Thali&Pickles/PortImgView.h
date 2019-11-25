//
//  PortImgView.h
//  Thali&Pickles
//
//  Created by Emon on 11/25/19.
//  Copyright © 2019 Emon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageView+WebCache.h"
#import "UIView+WebCache.h"
#import "SDWebImageTransition.h"


NS_ASSUME_NONNULL_BEGIN

@interface PortImgView : UIImageView
@property (nonatomic, assign) BOOL showActivityIndicator;
@property (nonatomic, assign) NSTimeInterval crossfadeDuration;
@property (nonatomic, strong) UIActivityIndicatorView * _Nullable activityView;
@property (nonatomic, assign) UIActivityIndicatorViewStyle activityIndicatorStyle;
@property (nonatomic, strong, nullable) UIColor *activityIndicatorColor;
- (void)setImgWithURL:(nullable NSURL *)url placeholderImage:(nullable UIImage *)placeholder;
@end

NS_ASSUME_NONNULL_END

//
//  TPCTabBarItem.m
//  PecoCommunity
//
//  Created by caixun on 2016/10/9.
//  Copyright © 2016年 Peco. All rights reserved.
//

#import "TPCTabBarItem.h"


@interface TPCTabBarItem ()
{
    NSString *_title;
    UIOffset _imagePositionAdjustment;
    NSDictionary *_unselectedTitleAttributes;
    NSDictionary *_selectedTitleAttributes;
}


@property UIImage *unselectedBackgroundImage;
@property UIImage *selectedBackgroundImage;
@property UIImage *unselectedImage;
@property UIImage *selectedImage;


@end


@implementation TPCTabBarItem

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInitialization];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self commonInitialization];
    }
    return self;
}

- (id)init {
    return [self initWithFrame:CGRectZero];
}

- (void)commonInitialization {
    // Setup defaults
    
    [self setBackgroundColor:[UIColor clearColor]];
    
    _title = @"";
    _titlePositionAdjustment = UIOffsetZero;
    
    if (NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_6_1) {
        _unselectedTitleAttributes = @{
                                       NSFontAttributeName: [UIFont systemFontOfSize:12.0f],
                                       NSForegroundColorAttributeName: [UIColor blackColor],
                                       };
    } else {
#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_7_0
        _unselectedTitleAttributes = @{
                                       UITextAttributeFont: [TPToolsManager getCurrentCustomFont:12.0f],
                                       UITextAttributeTextColor: [UIColor blackColor],
                                       };
#endif
    }
    
    _selectedTitleAttributes = [_unselectedTitleAttributes copy];
//    _badgeBackgroundColor = MPT_RGBAAllColor(0xfc5c63, 1.0f);
//    _badgeTextColor = [UIColor whiteColor];
//    _badgeTextFont = [UIFont systemFontOfSize:12.0f];
    _badgePositionAdjustment = UIOffsetZero;
}

- (void)drawRect:(CGRect)rect {
    CGSize frameSize = self.frame.size;
    CGSize imageSize = CGSizeZero;
    CGSize titleSize = CGSizeZero;
    NSDictionary *titleAttributes = nil;
    UIImage *backgroundImage = nil;
    UIImage *image = nil;
    CGFloat imageStartingY = 0.0f;
    CGFloat titleAndImageMaxY = 0; // 图片和标题的最大Y,主要用于在标题下方(有标题)或者图片下面(没有标题)展示小红点
    
    if ([self isSelected]) {
        image = [self selectedImage];
        backgroundImage = [self selectedBackgroundImage];
        titleAttributes = [self selectedTitleAttributes];
        
        if (!titleAttributes) {
            titleAttributes = [self unselectedTitleAttributes];
        }
    } else {
        image = [self unselectedImage];
        backgroundImage = [self unselectedBackgroundImage];
        titleAttributes = [self unselectedTitleAttributes];
    }
    
    imageSize = [image size];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    
    [backgroundImage drawInRect:self.bounds];
    
    // Draw image and title
    
    if (![_title length]) {
        CGFloat imageStartY = roundf(frameSize.height / 2 - imageSize.height / 2) + _imagePositionAdjustment.vertical;
        [image drawInRect:CGRectMake(roundf(frameSize.width / 2 - imageSize.width / 2) +
                                     _imagePositionAdjustment.horizontal,
                                     imageStartY,
                                     imageSize.width, imageSize.height)];
        titleAndImageMaxY = imageStartY + imageSize.height;
    } else {
        
        if (NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_6_1) {
            titleSize = [_title boundingRectWithSize:CGSizeMake(frameSize.width, 20)
                                             options:NSStringDrawingUsesLineFragmentOrigin
                                          attributes:titleAttributes
                                             context:nil].size;
            
            imageStartingY = roundf((frameSize.height - imageSize.height - titleSize.height) / 2);
            
            [image drawInRect:CGRectMake(roundf(frameSize.width / 2 - imageSize.width / 2) +
                                         _imagePositionAdjustment.horizontal,
                                         imageStartingY + _imagePositionAdjustment.vertical,
                                         imageSize.width, imageSize.height)];
            
            CGContextSetFillColorWithColor(context, [titleAttributes[NSForegroundColorAttributeName] CGColor]);
            
            CGFloat titleStartY = imageStartingY + imageSize.height + _titlePositionAdjustment.vertical;
            [_title drawInRect:CGRectMake(roundf(frameSize.width / 2 - titleSize.width / 2) +
                                          _titlePositionAdjustment.horizontal,
                                          titleStartY,
                                          titleSize.width, titleSize.height)
                withAttributes:titleAttributes];
            
            titleAndImageMaxY = titleStartY + titleSize.height;
        } else {
#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_7_0
            titleSize = [_title sizeWithFont:titleAttributes[UITextAttributeFont]
                           constrainedToSize:CGSizeMake(frameSize.width, 20)];
            UIOffset titleShadowOffset = [titleAttributes[UITextAttributeTextShadowOffset] UIOffsetValue];
            imageStartingY = roundf((frameSize.height - imageSize.height - titleSize.height) / 2);
            
            [image drawInRect:CGRectMake(roundf(frameSize.width / 2 - imageSize.width / 2) +
                                         _imagePositionAdjustment.horizontal,
                                         imageStartingY + _imagePositionAdjustment.vertical,
                                         imageSize.width, imageSize.height)];
            
            CGContextSetFillColorWithColor(context, [titleAttributes[UITextAttributeTextColor] CGColor]);
            
            UIColor *shadowColor = titleAttributes[UITextAttributeTextShadowColor];
            
            if (shadowColor) {
                CGContextSetShadowWithColor(context, CGSizeMake(titleShadowOffset.horizontal, titleShadowOffset.vertical),
                                            1.0, [shadowColor CGColor]);
            }
            
            [_title drawInRect:CGRectMake(roundf(frameSize.width / 2 - titleSize.width / 2) +
                                          _titlePositionAdjustment.horizontal,
                                          imageStartingY + imageSize.height + _titlePositionAdjustment.vertical,
                                          titleSize.width, titleSize.height)
                      withFont:titleAttributes[UITextAttributeFont]
                 lineBreakMode:NSLineBreakByTruncatingTail];
#endif
        }
    }
    
    // Draw badges
    
//    if ([[self badgeValue] integerValue] != 0)
//    {
//        CGSize badgeSize = CGSizeZero;
//
//        if (NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_6_1) {
//            badgeSize = [_badgeValue boundingRectWithSize:CGSizeMake(frameSize.width, 20)
//                                                  options:NSStringDrawingUsesLineFragmentOrigin
//                                               attributes:@{NSFontAttributeName: [self badgeTextFont]}
//                                                  context:nil].size;
//        } else {
//#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_7_0
//            badgeSize = [_badgeValue sizeWithFont:[self badgeTextFont]
//                                constrainedToSize:CGSizeMake(frameSize.width, 20)];
//#endif
//        }
//
//        CGFloat textOffset = 2.0f;
//
//        if (badgeSize.width < badgeSize.height) {
//            badgeSize = CGSizeMake(badgeSize.height, badgeSize.height);
//        }
//
//        CGRect badgeBackgroundFrame = CGRectMake(roundf(frameSize.width / 2 + (image.size.width / 2) * 0.9) +
//                                                 [self badgePositionAdjustment].horizontal-5,
//                                                 textOffset + [self badgePositionAdjustment].vertical,
//                                                 badgeSize.width + 2 * textOffset, badgeSize.height + 2 * textOffset);
//
//        if ([self badgeBackgroundColor]) {
//            CGContextSetFillColorWithColor(context, [[self badgeBackgroundColor] CGColor]);
//
//            CGContextFillEllipseInRect(context, badgeBackgroundFrame);
//        } else if ([self badgeBackgroundImage]) {
//            [[self badgeBackgroundImage] drawInRect:badgeBackgroundFrame];
//        }
//
//        CGContextSetFillColorWithColor(context, [[self badgeTextColor] CGColor]);
//
//        if (NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_6_1) {
//            NSMutableParagraphStyle *badgeTextStyle = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
//            [badgeTextStyle setLineBreakMode:NSLineBreakByWordWrapping];
//            [badgeTextStyle setAlignment:NSTextAlignmentCenter];
//
//            NSDictionary *badgeTextAttributes = @{
//                                                  NSFontAttributeName: [self badgeTextFont],
//                                                  NSForegroundColorAttributeName: [self badgeTextColor],
//                                                  NSParagraphStyleAttributeName: badgeTextStyle,
//                                                  };
//
//            [[self badgeValue] drawInRect:CGRectMake(CGRectGetMinX(badgeBackgroundFrame) + textOffset,
//                                                     CGRectGetMinY(badgeBackgroundFrame) + textOffset,
//                                                     badgeSize.width, badgeSize.height)
//                           withAttributes:badgeTextAttributes];
//
//
//            // 椭圆
//            CGRect rect = CGRectMake(badgeBackgroundFrame.origin.x,
//                                     badgeBackgroundFrame.origin.y,
//                                     badgeBackgroundFrame.size.width,
//                                     badgeBackgroundFrame.size.height);
//            CGContextSetRGBStrokeColor(context, 1, 1, 1, 1.0);
//            CGContextSetLineWidth(context, 1.0);
//            CGContextAddEllipseInRect(context, rect);
//            CGContextDrawPath(context, kCGPathStroke);
//
//
//        } else {
//#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_7_0
//            [[self badgeValue] drawInRect:CGRectMake(CGRectGetMinX(badgeBackgroundFrame) + textOffset,
//                                                     CGRectGetMinY(badgeBackgroundFrame) + textOffset,
//                                                     badgeSize.width, badgeSize.height)
//                                 withFont:[self badgeTextFont]
//                            lineBreakMode:NSLineBreakByTruncatingTail
//                                alignment:NSTextAlignmentCenter];
//#endif
//        }
//    }
    
    if (self.isShowBadge)
    {
        CGRect badgeBackgroundFrame = CGRectMake((frameSize.width - 5.) / 2,
                                                 titleAndImageMaxY,
                                                 5,
                                                 5);
        
        CGContextSetFillColorWithColor(context, [[UIColor redColor] CGColor]);
        
        CGContextFillEllipseInRect(context, badgeBackgroundFrame);
    }
    CGContextRestoreGState(context);
}

#pragma mark - Image configuration

- (UIImage *)finishedSelectedImage {
    return [self selectedImage];
}

- (UIImage *)finishedUnselectedImage {
    return [self unselectedImage];
}

- (void)setFinishedSelectedImage:(UIImage *)selectedImage withFinishedUnselectedImage:(UIImage *)unselectedImage {
    if (selectedImage && (selectedImage != [self selectedImage])) {
        [self setSelectedImage:selectedImage];
    }
    
    if (unselectedImage && (unselectedImage != [self unselectedImage])) {
        [self setUnselectedImage:unselectedImage];
    }
}

//- (void)setBadgeValue:(NSString *)badgeValue {
//    _badgeValue = badgeValue;
//
//    [self setNeedsDisplay];
//}

- (void)setIsShowBadge:(BOOL)isShowBadge
{
    _isShowBadge  = isShowBadge;
    [self setNeedsDisplay];
}

#pragma mark - Background configuration

- (UIImage *)backgroundSelectedImage {
    return [self selectedBackgroundImage];
}

- (UIImage *)backgroundUnselectedImage {
    return [self unselectedBackgroundImage];
}

- (void)setBackgroundSelectedImage:(UIImage *)selectedImage withUnselectedImage:(UIImage *)unselectedImage  {
    if (selectedImage && (selectedImage != [self selectedBackgroundImage])) {
        [self setSelectedBackgroundImage:selectedImage];
    }
    
    if (unselectedImage && (unselectedImage != [self unselectedBackgroundImage])) {
        [self setUnselectedBackgroundImage:unselectedImage];
    }
}

#pragma mark - Accessibility

- (NSString *)accessibilityLabel{
    return @"tabbarItem";
}

- (BOOL)isAccessibilityElement
{
    return YES;
}


@end

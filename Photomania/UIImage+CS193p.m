//
//  UIImage+CS193p.m
//  Photomania
//
//  Created by 1000653 on 2014. 8. 1..
//  Copyright (c) 2014년 house. All rights reserved.
//

#import "UIImage+CS193p.h"

@implementation UIImage (CS193p)

- (UIImage *)imageByScalingToSize:(CGSize)size
{
    UIGraphicsBeginImageContextWithOptions(size, YES, 0.0);
    [self drawInRect:CGRectMake(0,0, size.width, size.height)];
    UIImage *resizedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resizedImage;
}
-(UIImage *)imageByApplyingFilterNamed:(NSString *)filterName
{

    return nil;
}
@end

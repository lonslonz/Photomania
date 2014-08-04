//
//  UIImage+CS193p.h
//  Photomania
//
//  Created by 1000653 on 2014. 8. 1..
//  Copyright (c) 2014년 house. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (CS193p)


- (UIImage *)imageByScalingToSize:(CGSize)size;
- (UIImage *)imageByApplyingFilterNamed:(NSString *)filterName;
@end

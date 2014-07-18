//
//  PhotosByPhotographerImageViewController.h
//  Photomania
//
//  Created by 이종민 on 2014. 6. 7..
//  Copyright (c) 2014년 house. All rights reserved.
//

#import "ImageViewController.h"
#import "Photographer.h"
@interface PhotosByPhotographerImageViewController : ImageViewController
@property(nonatomic, strong) Photographer *photographer;
@end

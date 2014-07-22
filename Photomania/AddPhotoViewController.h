//
//  AddPhotoViewController.h
//  Photomania
//
//  Created by 1000653 on 2014. 7. 18..
//  Copyright (c) 2014년 house. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Photo.h"
#import "Photographer.h"

@interface AddPhotoViewController : UIViewController

@property (nonatomic, strong) Photographer *photographerTakingPhoto;

@property (nonatomic, strong) Photo *addedPhoto;
@end

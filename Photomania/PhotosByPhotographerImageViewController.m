//
//  PhotosByPhotographerImageViewController.m
//  Photomania
//
//  Created by 이종민 on 2014. 6. 7..
//  Copyright (c) 2014년 house. All rights reserved.
//

#import "PhotosByPhotographerImageViewController.h"
#import "PhotosByPhotographerMapViewController.h"

@interface PhotosByPhotographerImageViewController ()
@property (nonatomic, strong) PhotosByPhotographerMapViewController *mapvc;
@end

@implementation PhotosByPhotographerImageViewController
- (void) setPhotographer:(Photographer *)photographer
{
    _photographer = photographer;
    self.title = photographer.name;
    self.mapvc.photographer = self.photographer;

}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.destinationViewController isKindOfClass:[PhotosByPhotographerMapViewController class]]) {
        PhotosByPhotographerMapViewController *pbpmapvc = (PhotosByPhotographerMapViewController *)segue.destinationViewController;
        pbpmapvc.photographer = self.photographer;
        self.mapvc = pbpmapvc;
        
    } else {
        [super prepareForSegue:segue sender:sender];
    }
}


@end

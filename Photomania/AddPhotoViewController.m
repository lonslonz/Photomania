//
//  AddPhotoViewController.m
//  Photomania
//
//  Created by 1000653 on 2014. 7. 18..
//  Copyright (c) 2014년 house. All rights reserved.
//

#import "AddPhotoViewController.h"

@interface AddPhotoViewController () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *titleTextField;
@property (weak, nonatomic) IBOutlet UITextField *subtitleTextField;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (nonatomic, strong) UIImage *image;
@end

@implementation AddPhotoViewController

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
    
}

- (void)setImage:(UIImage *)image
{
    self.imageView.image = image;
}

- (IBAction)cacel {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:NULL];
}

- (IBAction)takePhoto {
}


@end

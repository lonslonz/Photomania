//
//  AddPhotoViewController.m
//  Photomania
//
//  Created by 1000653 on 2014. 7. 18..
//  Copyright (c) 2014년 house. All rights reserved.
//

#import "AddPhotoViewController.h"
#import "Photo.h"
#import <CoreLocation/CoreLocation.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "UIImage+CS193p.h"

@interface AddPhotoViewController () <UITextFieldDelegate, UIAlertViewDelegate, CLLocationManagerDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate>
@property (weak, nonatomic) IBOutlet UITextField *titleTextField;
@property (weak, nonatomic) IBOutlet UITextField *subtitleTextField;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (nonatomic, strong) UIImage *image;
@property (strong, nonatomic) CLLocation *location;
@property (strong, nonatomic) NSURL *imageURL;
@property (strong, nonatomic) NSURL *thumnailURL;
@property (strong, nonatomic, readwrite) Photo *addedPhoto;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (nonatomic) NSInteger locationErrorCode;

@end

@implementation AddPhotoViewController

+ (BOOL)canAddPhoto
{
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        NSArray *availableMediaType = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
        if([availableMediaType containsObject:(NSString *)kUTTypeImage]) {
            if([CLLocationManager authorizationStatus] != kCLAuthorizationStatusRestricted) {
                return YES;
            }
        }
    }
    return NO;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if(![[self class] canAddPhoto]) {
        [self fatalAlert:@"Sorry, this device cannot add a photo"];
    } else {
        [self.locationManager startUpdatingLocation];
    }
}
-(void)viewDidLoad
{
    [super viewDidLoad];
    self.image = [UIImage imageNamed:@"flower.jpg"];
    
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.locationManager stopUpdatingHeading];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
    
}
#define UNWIND_SEGUE_IDENTIFIER @"Do Add Photo"
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:UNWIND_SEGUE_IDENTIFIER]) {
        NSManagedObjectContext *context = self.photographerTakingPhoto.managedObjectContext;
        if(context) {
            Photo *photo = [NSEntityDescription insertNewObjectForEntityForName:@"Photo" inManagedObjectContext:context];
            photo.title = self.titleTextField.text;
            photo.subtitle = self.subtitleTextField.text;
            photo.whoTook = self.photographerTakingPhoto;
            photo.latitude = @(self.location.coordinate.latitude);
            photo.longitude = @(self.location.coordinate.longitude);
            photo.imageURL = [self.imageURL absoluteString];
            photo.thumbnailURL = [self.thumnailURL absoluteString];
            self.addedPhoto = photo;
            
//            // add later
            self.imageURL = nil;
            self.thumnailURL = nil;

        }
    }
    
}
- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    if([identifier isEqualToString:UNWIND_SEGUE_IDENTIFIER]) {
        if(!self.image) {
            [self alert:@"No photo taken"];
        } else if(![self.titleTextField.text length]) {
            [self alert:@"Title required"];
        } else if(!self.location) {
            switch(self.locationErrorCode) {
                case kCLErrorLocationUnknown:
                    [self alert:@"Couldn't figure out where this photo was taken yes."]; break;
                case kCLErrorDenied:
                    [self alert:@"Location Services disabled under Privacy in Settings app."]; break;
                case kCLErrorNetwork:
                    [self alert:@"Can't figure out where this photo is being taken. verify your connection to network"]; break;
                default:
                    [self alert:@"Cant figure out where this photo is begin taken, sorry"]; break;
            }
            return NO;
        } else {
            return YES;
        }
    } else {
        return [super shouldPerformSegueWithIdentifier:identifier
                                                sender:sender];
    }
    return YES;
}
- (void)fatalAlert:(NSString *)msg
{
    [[[UIAlertView alloc] initWithTitle:@"Add Photo"
                                message:msg
                               delegate:self
                      cancelButtonTitle:nil
                      otherButtonTitles:@"Ok", nil] show];}
- (void)alert:(NSString *)msg
{
    [[[UIAlertView alloc] initWithTitle:@"Add Photo"
                               message:msg
                              delegate:nil
                     cancelButtonTitle:nil
                      otherButtonTitles:@"Ok", nil] show];
}
- (CLLocationManager *)locationManager
{
    if(!_locationManager) {
        CLLocationManager *locationManager = [[CLLocationManager alloc] init];
        locationManager.delegate = self;
        locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        _locationManager = locationManager;
    }
    return _locationManager;
    
}
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    self.location = [locations lastObject];
}
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    self.locationErrorCode = error.code;
}
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    [self cancel];
}
- (NSURL *)uniqueDocumentURL
{
    NSArray *documentDirectories = [[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask];
    NSString *unique = [NSString stringWithFormat:@"%.0f", floor([NSDate timeIntervalSinceReferenceDate])];
    return [[documentDirectories firstObject] URLByAppendingPathComponent:unique];
}
- (NSURL *)imageURL
{
    if(!_imageURL && self.image) {
        NSURL *url = [self uniqueDocumentURL];
        if(url) {
            NSData *imageData = UIImageJPEGRepresentation(self.image, 1.0);
            if([imageData writeToURL:url atomically:YES]) {
                _imageURL = url;
            }
        }
    }
    return _imageURL;
}



- (NSURL *)thumnailURL
{
    NSURL *url = [self.imageURL URLByAppendingPathComponent:@"thumbnail"];
    if(![_thumnailURL isEqual:url]) {
        _thumnailURL = nil;
        if(url) {
            UIImage *thumbnail = [self.image imageByScalingToSize:CGSizeMake(75, 75)];
            NSData *imageData = UIImageJPEGRepresentation(thumbnail, 0.5);
            if([imageData writeToURL:url atomically:YES]) {
                _thumnailURL = url;
            }
        }
    }
    return _thumnailURL;
}

- (void)setImage:(UIImage *)image
{
    self.imageView.image = image;
   // _image = image;
    [[NSFileManager defaultManager] removeItemAtURL:_imageURL
                                               error:NULL];
    [[NSFileManager defaultManager] removeItemAtURL:_thumnailURL
                                              error:NULL];
    self.imageURL = nil;
    self.thumnailURL = nil;
}

- (UIImage *)image
{
    return self.imageView.image;
}
- (IBAction)cancel {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:NULL];
}

- (IBAction)takePhoto {
    UIImagePickerController *uiipc = [[UIImagePickerController alloc] init];
    uiipc.delegate = self;
    uiipc.mediaTypes = @[(NSString *)kUTTypeImage];
    uiipc.sourceType = UIImagePickerControllerSourceTypeCamera;
    uiipc.allowsEditing = YES;
    [self presentViewController:uiipc animated:YES completion:NULL];
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = info[UIImagePickerControllerEditedImage];
    if(!image) image = info[UIImagePickerControllerOriginalImage];
    self.image = image;
    [self dismissViewControllerAnimated:YES completion:NULL];

}


@end

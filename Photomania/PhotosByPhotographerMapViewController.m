//
//  PhotosByPhotographerMapViewController.m
//  Photomania
//
//  Created by 이종민 on 2014. 6. 7..
//  Copyright (c) 2014년 house. All rights reserved.
//

#import "PhotosByPhotographerMapViewController.h"
#import <MapKit/MapKit.h>
#import "Photo+Annotation.h"
#import "ImageViewController.h"
#import "Photographer+Create.h"

@interface PhotosByPhotographerMapViewController () <MKMapViewDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (nonatomic, strong) NSArray *photosByPhotographer;
@property (nonatomic, strong) ImageViewController * imageViewController;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *addPhotoBarButtonItem;
@end

@implementation PhotosByPhotographerMapViewController

- (ImageViewController *)imageViewController
{
    id detailvc = [self.splitViewController.viewControllers lastObject];
    if([detailvc isKindOfClass:[UINavigationController class]]) {
        detailvc = [((UINavigationController *)detailvc).viewControllers firstObject];
    }
    return [detailvc isKindOfClass:[ImageViewController class]] ? detailvc : nil;
}

-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    static NSString *reuseId = @"PhotosByPhotographerMapViewController";
    MKAnnotationView *view = [mapView dequeueReusableAnnotationViewWithIdentifier:reuseId];
    if(!view) {
        if(!self.imageViewController) {
            view = [[MKPinAnnotationView alloc] initWithAnnotation:annotation
                                                   reuseIdentifier:reuseId];
            view.canShowCallout = YES;
            UIImageView *imageView = [[UIImageView alloc]
                                      initWithFrame:CGRectMake(0,0,46,46)];
            view.leftCalloutAccessoryView = imageView;
            
            UIButton *disclosureButton = [[UIButton alloc] init];
            [disclosureButton setBackgroundImage:[UIImage imageNamed:@"disclosure"] forState:UIControlStateNormal ];
            [disclosureButton sizeToFit];
            
            view.rightCalloutAccessoryView = disclosureButton;
        }
    }
    view.annotation = annotation;
    return view;
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
    
    if(self.imageViewController) {
       // [self updateLeftCalloutAccessoryViewInAnnotationView:view];
        [self prepareViewContoller:self.imageViewController
                          forSegue:nil
                  toShowAnnotation:view.annotation];
    } else {
        [self updateLeftCalloutAccessoryViewInAnnotationView:view];
    }
}

-(void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    [self performSegueWithIdentifier:@"Show Photo" sender:view];
}

- (void)prepareViewContoller:(id)vc
                    forSegue:(NSString *)segueIdentifier
            toShowAnnotation:(id <MKAnnotation>)annotation
{
    Photo *photo = nil;
    if([annotation isKindOfClass:[Photo class]]) {
        photo = (Photo *)annotation;
    }
    if(photo) {
        if(![segueIdentifier length] || [segueIdentifier isEqualToString:@"Show Photo"]) {
            if([vc isKindOfClass:[ImageViewController class]]) {
                ImageViewController *ivc = (ImageViewController *)vc;
                ivc.imageURL = [NSURL URLWithString:photo.imageURL];
                ivc.title = photo.title;
            }
        }
    }
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([sender isKindOfClass:[MKAnnotationView class]]) {
        [self prepareViewContoller:segue.destinationViewController
                          forSegue:segue.identifier
                  toShowAnnotation:((MKAnnotationView *)sender).annotation];
    }
}




- (void)updateLeftCalloutAccessoryViewInAnnotationView:(MKAnnotationView *)annotationView
{
    UIImageView *imageView = nil;
    if([annotationView.leftCalloutAccessoryView isKindOfClass:[UIImageView class]]) {
        imageView = (UIImageView *)annotationView.leftCalloutAccessoryView;
    }
    if(imageView) {
        Photo *photo = nil;
        if([annotationView.annotation isKindOfClass:[Photo class]]) {
            photo = (Photo *)annotationView.annotation;
        }
        if(photo) {

            imageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:photo.thumbnailURL]]];
        }
    }
}

- (void) updateMapViewAnnotations
{
    [self.mapView removeAnnotations:self.mapView.annotations];
    [self.mapView addAnnotations:self.photosByPhotographer];
    [self.mapView showAnnotations:self.photosByPhotographer animated:YES];
    
    if(self.imageViewController) {
        Photo *autoselectedPhoto = [self.photosByPhotographer firstObject];
        if(autoselectedPhoto) {
            [self.mapView selectAnnotation:autoselectedPhoto animated:YES];
            [self prepareViewContoller:self.imageViewController
                              forSegue:nil
                      toShowAnnotation:autoselectedPhoto];
        }
    }
}
- (void) setMapView:(MKMapView *)mapView
{
    _mapView = mapView;
    self.mapView.delegate = self;
    [self updateMapViewAnnotations];
    
}

-(void)setPhotographer:(Photographer *)photographer
{
    _photographer = photographer;
    self.title = photographer.name;
    self.photosByPhotographer = nil;
    [self updateMapViewAnnotations];
    [self updateAddPhotoBarButtonItem];
}

- (void)updateAddPhotoBarButtonItem
{
    if(self.addPhotoBarButtonItem) {
        BOOL canAddPhoto = self.photographer.isUser;
        NSMutableArray *rightBarButtonItems = [self.navigationItem.rightBarButtonItems mutableCopy];
        if(!rightBarButtonItems) {
            rightBarButtonItems = [[NSMutableArray alloc] init];
        }
        
        NSUInteger addPhotoBarButtonItemIndex = [rightBarButtonItems indexOfObject:self.addPhotoBarButtonItem];
        if(addPhotoBarButtonItemIndex == NSNotFound) {
            if(canAddPhoto) {
                [rightBarButtonItems addObject:self.addPhotoBarButtonItem];
            }
        } else {
            if(!canAddPhoto) {
                [rightBarButtonItems removeObjectAtIndex:addPhotoBarButtonItemIndex];
            }
        }
        self.navigationItem.rightBarButtonItems = rightBarButtonItems;
    }
}


-(NSArray *)photosByPhotographer
{
    if(!_photosByPhotographer) {
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Photo"];
        request.predicate = [NSPredicate predicateWithFormat:@"whoTook = %@", self.photographer];
        _photosByPhotographer = [self.photographer.managedObjectContext executeFetchRequest:request
                                                                                      error:NULL];
    }
    return _photosByPhotographer;
}

@end

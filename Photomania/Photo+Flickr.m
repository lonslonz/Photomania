//
//  Photo+Flickr.m
//  Photomania
//
//  Created by 이종민 on 2014. 5. 23..
//  Copyright (c) 2014년 house. All rights reserved.
//

#import "Photo+Flickr.h"
#import "FlickrFetcher.h"
#import "Photographer+Create.h"

@implementation Photo (Flickr)

+ (Photo *)photoWithFlickrInfo:(NSDictionary *)photoDictionary
         inMangedObjectContext:(NSManagedObjectContext *)context;
{
    Photo *photo = nil;
    
    NSString *unique = photoDictionary[FLICKR_PHOTO_ID];
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Photo"];
    request.predicate = [NSPredicate predicateWithFormat:@"unique = %@", unique];
    NSError *error;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    if(!matches || error || ([matches count] > 1)) {
        
    } else if([matches count]) {
        photo = [matches firstObject];
    } else {
        photo = [NSEntityDescription insertNewObjectForEntityForName:@"Photo"
                                              inManagedObjectContext:context];
        photo.unique = unique;
        photo.title = [photoDictionary valueForKeyPath:FLICKR_PHOTO_TITLE];
        photo.subtitle = [photoDictionary valueForKeyPath:FLICKR_PHOTO_DESCRIPTION];
        photo.imageURL = [[FlickrFetcher URLforPhoto:photoDictionary
                                              format:FlickrPhotoFormatLarge ] absoluteString];
        photo.latitude = @([photoDictionary[FLICKR_LATITUDE] doubleValue]);
        photo.longitude = @([photoDictionary[FLICKR_LONGITUDE] doubleValue]);
        photo.thumbnailURL = [[FlickrFetcher URLforPhoto:photoDictionary format:FlickrPhotoFormatSquare] absoluteString];
        
        NSString *photographerName = [photoDictionary valueForKeyPath:FLICKR_PHOTO_OWNER];
        photo.whoTook = [Photographer photographerWithName:photographerName
                                    inManagedObjectContext:context];
    }
    
    return photo;
}
+(void)loadPhotosFromFlickrArray:(NSArray *)photos
        intoManagedObjectContext:(NSManagedObjectContext *)context
{
    for(NSDictionary *photo in photos) {
        [self photoWithFlickrInfo:photo inMangedObjectContext:context];
    }
}

@end

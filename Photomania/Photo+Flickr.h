//
//  Photo+Flickr.h
//  Photomania
//
//  Created by 이종민 on 2014. 5. 23..
//  Copyright (c) 2014년 house. All rights reserved.
//

#import "Photo.h"

@interface Photo (Flickr)

+ (Photo *)photoWithFlickrInfo:(NSDictionary *)photoDictionary
          inMangedObjectContext:(NSManagedObjectContext *)context;

+(void)loadPhotosFromFlickrArray:(NSArray *)photos
        intoManagedObjectContext:(NSManagedObjectContext *)context;

@end

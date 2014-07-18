//
//  Photo.h
//  Photomania
//
//  Created by 이종민 on 2014. 6. 7..
//  Copyright (c) 2014년 house. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Photographer;

@interface Photo : NSManagedObject

@property (nonatomic, retain) NSString * imageURL;
@property (nonatomic, retain) NSString * subtitle;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * unique;
@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, retain) NSNumber * longitude;
@property (nonatomic, retain) NSString * thumbnailURL;
@property (nonatomic, retain) Photographer *whoTook;

@end

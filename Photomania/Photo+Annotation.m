//
//  Photo+Annotation.m
//  Photomania
//
//  Created by 이종민 on 2014. 6. 7..
//  Copyright (c) 2014년 house. All rights reserved.
//

#import "Photo+Annotation.h"

@implementation Photo (Annotation)

- (CLLocationCoordinate2D) coordinate
{
    CLLocationCoordinate2D coordinate;
    coordinate.latitude = [self.latitude doubleValue];
    coordinate.longitude = [self.longitude doubleValue];
    
    return coordinate;
}

@end

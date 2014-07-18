//
//  Photographer+Create.h
//  Photomania
//
//  Created by 이종민 on 2014. 5. 23..
//  Copyright (c) 2014년 house. All rights reserved.
//

#import "Photographer.h"

@interface Photographer (Create)
+ (Photographer *)userInManagedObjectContext:(NSManagedObjectContext *)context;

- (BOOL)isUser;

+ (Photographer *)photographerWithName:(NSString *)name
                inManagedObjectContext:(NSManagedObjectContext *)context;
@end

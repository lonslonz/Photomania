//
//  Photographer+Create.m
//  Photomania
//
//  Created by 이종민 on 2014. 5. 23..
//  Copyright (c) 2014년 house. All rights reserved.
//

#import "Photographer+Create.h"

@implementation Photographer (Create)

+ (Photographer *)userInManagedObjectContext:(NSManagedObjectContext *)context
{
    return [self photographerWithName:@" My Photos" inManagedObjectContext:context];
}

- (BOOL)isUser
{
    return self == [[self class] userInManagedObjectContext:self.managedObjectContext];
}

+ (Photographer *)photographerWithName:(NSString *)name
                inManagedObjectContext:(NSManagedObjectContext *)context
{
    Photographer *photographer = nil;
    
    if([name length]) {
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Photographer"];
        request.predicate = [NSPredicate predicateWithFormat:@"name = %@", name];
        
        NSError *error;
        NSArray *matches = [context executeFetchRequest:request  error:&error ];
        if(!matches || ([matches count] > 1)) {
            
        } else if(![matches count]) {
            photographer  = [NSEntityDescription insertNewObjectForEntityForName:@"Photographer" inManagedObjectContext:context];
            photographer.name = name;
        } else {
            photographer = [matches lastObject];
        }
    }
    return photographer;
}
@end

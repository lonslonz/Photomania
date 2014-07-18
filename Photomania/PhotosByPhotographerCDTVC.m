//
//  PhotosByPhotographerCDTVC.m
//  Photomania
//
//  Created by 이종민 on 2014. 5. 31..
//  Copyright (c) 2014년 house. All rights reserved.
//

#import "PhotosByPhotographerCDTVC.h"


@implementation PhotosByPhotographerCDTVC

- (void)setPhotographer:(Photographer *)photographer
{
    _photographer = photographer;
    self.title = photographer.name;
    [self setupFetchedResultController];
    
}
- (void)setupFetchedResultController
{
    NSManagedObjectContext *context = self.photographer.managedObjectContext;
    
    if(context) {
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Photo"];
        request.predicate = [NSPredicate predicateWithFormat:@"whoTook = %@", self.photographer];
        request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"title"
                                                                  ascending:YES
                                                                   selector:@selector(localizedStandardCompare:)]];
        self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                            managedObjectContext:context
                                                                              sectionNameKeyPath:nil cacheName:nil];
    } else {
        self.fetchedResultsController = nil;
    }
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

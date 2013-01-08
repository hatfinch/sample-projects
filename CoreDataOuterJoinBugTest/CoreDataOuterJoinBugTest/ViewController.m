//
//  ViewController.m
//  CoreDataOuterJoinBugTest
//
//  Created by Hamish Allan on 07/01/2013.
//  Copyright (c) 2013 Hamish Allan. All rights reserved.
//

#import <CoreData/CoreData.h>

#import "AppDelegate.h"
#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];

    NSFetchRequest *f2 = [[NSFetchRequest alloc] initWithEntityName:@"Entity2"];
    NSArray *e2s = [context executeFetchRequest:f2 error:nil];
    NSManagedObject *e2 = [e2s lastObject];

    if (!e2)
    {
        NSEntityDescription *desc1 = [NSEntityDescription entityForName:@"Entity1" inManagedObjectContext:context];
        NSManagedObject *e1x = [[NSManagedObject alloc] initWithEntity:desc1 insertIntoManagedObjectContext:context];
        NSManagedObject *e1y = [[NSManagedObject alloc] initWithEntity:desc1 insertIntoManagedObjectContext:context];

        NSEntityDescription *desc2 = [NSEntityDescription entityForName:@"Entity2" inManagedObjectContext:context];
        NSManagedObject *e2x = [[NSManagedObject alloc] initWithEntity:desc2 insertIntoManagedObjectContext:context];
        NSManagedObject *e2y = [[NSManagedObject alloc] initWithEntity:desc2 insertIntoManagedObjectContext:context];

        [e1x setValue:[NSSet setWithObjects:e2x, e2y, nil] forKey:@"e2a"];
        [e1x setValue:[NSSet setWithObjects:e2x, e2y, nil] forKey:@"e2b"];

        [e1y setValue:[NSSet setWithObjects:e2x, e2y, nil] forKey:@"e2a"];
        [e1y setValue:[NSSet setWithObjects:e2x, e2y, nil] forKey:@"e2b"];

        [context save:NULL];

        e2 = e2x;
    }

    NSFetchRequest *f1 = [[NSFetchRequest alloc] initWithEntityName:@"Entity1"];

    NSPredicate *predicateA = [NSPredicate predicateWithFormat:@"%@ in e2a", e2];
    NSPredicate *predicateB = [NSPredicate predicateWithFormat:@"%@ in e2b", e2];

    NSArray *orPredicates = [NSArray arrayWithObjects:predicateA, predicateB, nil];

    f1.predicate = [NSCompoundPredicate orPredicateWithSubpredicates:orPredicates];

    NSArray *arrayWithDuplicates = [context executeFetchRequest:f1 error:nil];

    NSLog(@"%@", arrayWithDuplicates);
}

@end

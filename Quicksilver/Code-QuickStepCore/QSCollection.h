//
//  QSCollection.h
//  Quicksilver
//
//  Created by Alcor on 8/6/04.
//  Copyright 2004 Blacktree. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "QSObject.h"

@interface QSCollection : QSObject
+ (id)collectionWithObjects:(NSArray *)objects;
+ (id)collectionWithObject:(QSBasicObject *)object;

/* NSArray */
- (NSUInteger)count;
- (id)objectAtIndex:(NSUInteger)index;
- (BOOL)containsObject:(id)anObject;

/* NSMutableArray */
- (void)addObject:(id)anObject;
- (void)insertObject:(id)anObject atIndex:(NSUInteger)index;
- (void)removeLastObject;
- (void)removeObjectAtIndex:(NSUInteger)index;
- (void)replaceObjectAtIndex:(NSUInteger)index withObject:(id)anObject;

- (void)removeAllObjects;
- (void)removeObject:(id)anObject;
@end

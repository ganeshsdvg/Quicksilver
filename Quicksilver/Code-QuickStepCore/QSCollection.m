//
// QSCollection.m
// Quicksilver
//
// Created by Alcor on 8/6/04.
// Copyright 2004 Blacktree. All rights reserved.
//

#import "QSCollection.h"

@implementation QSCollection
+ (id)collectionWithObjects:(NSArray *)objects {
    id obj = [[[self alloc] init] autorelease];
    [obj addObjectsFromArray:objects];
    return obj;
}

+ (id)collectionWithObject:(QSBasicObject *)object {
    id obj = [[[self alloc] init] autorelease];
    [obj addObject:object];
    return obj;
}

- (id)init {
	if (self = [super init]) {
        [self setPrimaryType:QSCollectionType];
        [self setObject:[NSMutableArray arrayWithCapacity:1] forType:QSCollectionType];
	}
	return self;
}

- (NSString *)singleFilePath {
    return [self count] == 1 ? [self objectForType:QSFilePathType] : nil;
}

- (id)objectForType:(id)type {
    NSArray *objects = [self arrayForType:type];
    return [[objects lastObject] objectForType:type];
}

- (id)arrayForType:(id)type {
    NSArray *objects = [super arrayForType:type];
    NSMutableArray *dataObjects = [NSMutableArray arrayWithCapacity:[objects count]];
    for (id object in objects) {
        [dataObjects addObject:[object objectForType:type]];
    }
    return dataObjects;
}

- (NSString *)primaryType {
    NSString *type = [super primaryType];
    return type;
}

- (NSArray *)types {
    NSArray *types = [[self dataDictionary] allKeys];
    return types;
}

- (NSMutableArray *)collectionArray {
    return [[self dataDictionary] objectForKey:QSCollectionType];
}

- (NSUInteger)count {
	return [[self collectionArray] count];
}

- (QSBasicObject *)objectAtIndex:(NSUInteger)index {
    return [[self collectionArray] objectAtIndex:index];
}

- (BOOL)containsObject:(id)anObject {
    return [[self collectionArray] containsObject:anObject];
}

- (void)_addObjectToTypeCache:(QSBasicObject *)anObject {
    for (NSString *type in [anObject types]) {
        NSMutableArray *typeArray = (NSMutableArray *)[self arrayForType:type];
        if (!typeArray) {
            typeArray = [NSMutableArray arrayWithCapacity:[[anObject types] count]];
            [self setObject:typeArray forType:type];
        }
        [typeArray addObject:anObject];
    }
}

- (void)_removeObjectFromTypeCache:(QSBasicObject *)anObject {
    for (NSString *type in [anObject types]) {
        NSMutableArray *typeArray = (NSMutableArray *)[self arrayForType:type];
        if (!typeArray) {
            typeArray = [NSMutableArray arrayWithCapacity:[[anObject types] count]];
            [self setObject:typeArray forType:type];
        }
        [typeArray removeObject:anObject];
    }
}

- (void)addObject:(QSBasicObject *)anObject {
    NSMutableArray *objects = [self collectionArray];
    if ([objects containsObject:anObject])
        return;
    
    [objects addObject:anObject];
    [self _addObjectToTypeCache:anObject];
}

- (void)insertObject:(id)anObject atIndex:(NSUInteger)index {
    NSMutableArray *objects = [self collectionArray];
    [objects insertObject:anObject atIndex:index];
    [self _addObjectToTypeCache:anObject];
}

- (void)removeLastObject {
    NSMutableArray *objects = [self collectionArray];
    id obj = [objects lastObject];
    [objects removeObject:obj];
    [self _removeObjectFromTypeCache:obj];
}

- (void)removeObjectAtIndex:(NSUInteger)index {
    NSMutableArray *objects = [self collectionArray];
    id obj = [objects objectAtIndex:index];
    [objects removeObjectAtIndex:index];
    [self _removeObjectFromTypeCache:obj];
}

- (void)replaceObjectAtIndex:(NSUInteger)index withObject:(id)anObject {
    [self removeObjectAtIndex:index];
    [self insertObject:anObject atIndex:index];
}

- (void)removeAllObjects {
    NSMutableArray *objects = [self collectionArray];
    for (id obj in objects) {
        [self _removeObjectFromTypeCache:obj];
    }
    [objects removeAllObjects];
}

- (void)removeObject:(id)anObject {
    NSMutableArray *objects = [self collectionArray];
    NSUInteger index = [objects indexOfObject:anObject];
    [self removeObjectAtIndex:index];
}

@end

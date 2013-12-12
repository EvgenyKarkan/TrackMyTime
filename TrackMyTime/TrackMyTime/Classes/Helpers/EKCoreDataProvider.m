//
//  EKCoreDataProvider.m
//  TrackMyTime
//
//  Created by Evgeny Karkan on 11.12.13.
//  Copyright (c) 2013 EvgenyKarkan. All rights reserved.
//

#import "EKCoreDataProvider.h"
#import "Record.h"

static NSString * const kEKRecord = @"Record";

@interface EKCoreDataProvider ()

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, strong) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@end


@implementation EKCoreDataProvider;

#pragma mark Singleton stuff

static id _sharedInstance;

+ (EKCoreDataProvider *)sharedInstance
{
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
	    _sharedInstance = [[EKCoreDataProvider alloc] init];
	});
	return _sharedInstance;
}

+ (id)allocWithZone:(NSZone *)zone
{
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
	    _sharedInstance = nil;
	    _sharedInstance = [super allocWithZone:zone];
	});
	return _sharedInstance;
}

- (id)copyWithZone:(NSZone *)zone
{
	return self;
}

+ (id)new
{
	NSException *exception = [[NSException alloc] initWithName:kEKException
	                                                    reason:kEKExceptionReason
	                                                  userInfo:nil];
	[exception raise];
    
	return nil;
}

#pragma mark - Core Data stack

- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"TrackMyTime" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"TrackMyTime.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
             NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

#pragma mark - Public API

- (void)saveRecord:(EKRecordModel *)recordModel withCompletionBlock:(void (^)(NSString *status))block
{
	NSAssert(recordModel != nil, @"Error with nil record as parameter");
    
	Record *newRecord = [NSEntityDescription insertNewObjectForEntityForName:kEKRecord inManagedObjectContext:self.managedObjectContext];
    
	if (newRecord != nil) {
        [self mapRecordModel:recordModel toCoreDataRecordModel:newRecord];
		NSError *errorOnAdd = nil;
		[self.managedObjectContext save:&errorOnAdd];
        
		NSAssert(errorOnAdd == nil, @"Error occurs during saving to context %@", [errorOnAdd localizedDescription]);
        
        block(kEKSavedWithSuccess);
	}
	else {
		block (kEKErrorOnSaving);
	}
}

- (NSArray *)allRecords
{
    NSMutableArray *bufferArray = [@[] mutableCopy];
    
	for (NSUInteger i = 0; i < [[self fetchedEntitiesForEntityName:kEKRecord] count]; i++) {
		EKRecordModel *recordModel = [[EKRecordModel alloc] init];
		[self mapCoreDataRecord:[self fetchedEntitiesForEntityName:kEKRecord][i] toRecordModel:recordModel];
		[bufferArray addObject:recordModel];
	}
	NSAssert(bufferArray != nil, @"Buffer array should be not nil");
    
	return [bufferArray copy];
}

#pragma mark - Private API
#pragma mark - Models mapping

- (void)mapRecordModel:(EKRecordModel *)recordModel toCoreDataRecordModel:(Record *)record
{
	if ((recordModel != nil) && (record != nil)) {
        record.activity = recordModel.activity;
        record.duration = recordModel.duration;
	}
	else {
		NSAssert(recordModel != nil, @"Record model should be not nil");
		NSAssert(record != nil, @"Core Data record model should be not nil");
	}
}

- (void)mapCoreDataRecord:(Record *)record toRecordModel:(EKRecordModel *)recordModel
{
	if ((recordModel != nil) && (record != nil)) {
		recordModel.activity = record.activity;
		recordModel.duration = record.duration;
	}
	else {
		NSAssert(recordModel != nil, @"Record model should be not nil");
		NSAssert(record != nil, @"Core Data record model should be not nil");
	}
}

#pragma mark - Fetch stuff 

- (NSArray *)fetchedEntitiesForEntityName:(NSString *)name
{
	NSError *error = nil;
	NSArray *entities = [self.managedObjectContext executeFetchRequest:[self requestWithEntityName:name]
	                                                             error:&error];
	NSAssert(entities != nil, @"Fetched array should not be nil");
    
	return entities;
}

- (NSFetchRequest *)requestWithEntityName:(NSString *)entityName
{
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	NSEntityDescription *entityDescription = [NSEntityDescription entityForName:entityName
	                                                     inManagedObjectContext:self.managedObjectContext];
	if (entityDescription != nil) {
		[fetchRequest setEntity:entityDescription];
	}
	else {
		NSAssert(entityDescription != nil, @"EntityDescription should not be nil");
	}
    
	return fetchRequest;
}

#pragma mark - Application's Documents directory

- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

@end

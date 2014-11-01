//
//  EKFileSystemUtil.m
//  TrackMyTime
//
//  Created by Evgeny Karkan on 28.12.13.
//  Copyright (c) 2013 EvgenyKarkan. All rights reserved.
//

#import "EKFileSystemUtil.h"
#import "SSZipArchive.h"


@implementation EKFileSystemUtil

+ (NSString *)documentDirectoryPath
{
    return NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
}

+ (NSString *)pathForFileName:(NSString *)fileName
{
    NSParameterAssert(fileName);
    return [[self documentDirectoryPath] stringByAppendingPathComponent:fileName];
}

+ (void)removeFileWithName:(NSString *)fileName
{
    NSParameterAssert(fileName);
    
    NSString *filePath = [[self documentDirectoryPath] stringByAppendingPathComponent:fileName];
    NSParameterAssert(filePath);
    
    NSError *error = nil;
    NSParameterAssert([[NSFileManager defaultManager] fileExistsAtPath:filePath]);
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        [[NSFileManager defaultManager] removeItemAtPath:filePath error:&error];
    }
    
    NSParameterAssert(![[NSFileManager defaultManager] fileExistsAtPath:filePath]);
}

#pragma mark - Public API

+ (NSData *)zippedSQLiteDatabase
{
    NSArray *SQLiteFilesPaths = @[[self pathForFileName:@"TrackMyTime.sqlite"],
                                  [self pathForFileName:@"TrackMyTime.sqlite-shm"],
                                  [self pathForFileName:@"TrackMyTime.sqlite-wal"]];
    
    NSString *archivePath = [[self documentDirectoryPath] stringByAppendingPathComponent:@"CreatedArchive.zip"];
    NSParameterAssert(archivePath);
    
    [SSZipArchive createZipFileAtPath:archivePath withFilesAtPaths:SQLiteFilesPaths];
    
    return [NSData dataWithContentsOfFile:[self pathForFileName:@"CreatedArchive.zip"]];
}

+ (void)removeZippedSQLiteDatabase
{
    [self removeFileWithName:@"CreatedArchive.zip"];
}

@end

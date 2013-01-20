//
//  KHContentBuilder.m
//  PDFFiller
//
//  Created by Kim Hunter on 20/01/13.
//  Copyright (c) 2013 Kim Hunter. All rights reserved.
//

#import "KHContentBuilder.h"
#import "KHPDFMaker.h"
#import "KHContent.h"
#import "KHPDFContent.h"
#import "KHTextContent.h"

NSString *const kKHContentTypePDF = @"kKHContentTypePDF";
NSString *const kKHContentTypeText = @"kKHContentTypeText";
NSString *const kKHContentTypeJpeg = @"kKHContentTypeJpeg";
NSString *const kKHContentTypePNG = @"kKHContentTypeJpeg";
NSString *const kKHContentTypeDir = @"kKHContentTypeDir";

@interface KHContentBuilder ()
@property (nonatomic, retain) NSDictionary *contentTypeMap;
@property (nonatomic, retain) NSDictionary *contentClassMap;
@property (nonatomic, retain) KHPDFMaker *pdfMaker;
@end

@implementation KHContentBuilder

- (void)dealloc
{
    self.fm = nil;
    self.pdfMaker = nil;
    self.contentTypeMap = nil;
    self.contentClassMap = nil;
    [super dealloc];
}

- (id)init
{
    self = [super init];
    if (self)
	{
        
        self.contentClassMap = @{
                                 kKHContentTypePDF : [KHPDFContent class],
                                 kKHContentTypeText: [KHTextContent class],
                                };
        self.contentTypeMap = @{
                                @"txt": kKHContentTypeText,
                                @"pdf": kKHContentTypePDF,
                                };
        
        _pdfMaker = [[KHPDFMaker alloc] init];
		_fm = [[NSFileManager alloc] init];
    }
    return self;
}

- (id)initWithBasePath:(NSString *)path
{
    if ([self init])
    {
        self.basePath = path;
        [self createBasePath];
    }
    return self;
}

- (void)createBasePath
{
    //TODO: Add error logging
	[_fm createDirectoryAtPath:self.basePath withIntermediateDirectories:YES attributes:nil error:NULL];
}

- (NSString *)contentTypeForFileName:(NSString *)path
{
    // path should only be the relative to basepath, as appending to basepath will strip trailing slash.
    if ([path hasSuffix:@"/"])
    {
        return kKHContentTypeDir;
    }
    NSString *ext = [[path pathExtension] lowercaseString];
    return self.contentTypeMap[ext];
}

- (id<KHContent>)contentForPath:(NSString *)path withInfo:(NSArray *)info
{
    NSString *contentType = [self contentTypeForFileName:path];
    if (contentType)
    {
        return [self.contentClassMap[contentType] contentWithArray:(info)];
    }
    return nil;
}

- (void)makeContentFile:(NSString *)filePath withArrayInfo:(NSArray *)info
{
    id<KHContent> content = [self contentForPath:filePath withInfo:info];

    if ([content respondsToSelector:@selector(setPdfMaker:)])
    {
        [content setPdfMaker:self.pdfMaker];
    }
    
    NSString *fullPath = [self.basePath stringByAppendingPathComponent:filePath];
    [content writeToFile:fullPath];

}

- (void)buildContent:(NSDictionary *)fileDict
{
    for (NSString *key in [fileDict allKeys])
    {
        NSString *file = key;
        NSArray *info = fileDict[key];
        [self makeContentFile:file withArrayInfo:info];
    }
}

@end

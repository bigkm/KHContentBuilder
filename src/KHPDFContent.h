//
//  KHPDFContent.h
//  PDFFiller
//
//  Created by Kim Hunter on 20/01/13.
//  Copyright (c) 2013 Kim Hunter. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KHContent.h"
#import "KHContentBuilder.h"

NSArray *KHPDFContentInfoMake(CGSize size, NSInteger noOfPages, NSArray *hotspots);

@interface KHPDFContent : NSObject<KHContent>
@property (retain, nonatomic) KHPDFMaker *pdfMaker;
@end

//
//  MyAnnotation.m
//  GuidePost
//
//  Created by Masahiro MIYAJI on 3/27/13.
//  Copyright (c) 2013 Masahiro MIYAJI. All rights reserved.
//

#import "MyAnnotation.h"

@implementation MyAnnotation

- (id)initWithCoordinate:(CLLocationCoordinate2D)co
{
    self.coordinate = co;
    self.title = @"";
    return self;
}

@end

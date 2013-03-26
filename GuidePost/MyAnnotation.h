//
//  MyAnnotation.h
//  GuidePost
//
//  Created by Masahiro MIYAJI on 3/27/13.
//  Copyright (c) 2013 Masahiro MIYAJI. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface MyAnnotation : NSObject <MKAnnotation>


@property (nonatomic) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;

- (id)initWithCoordinate:(CLLocationCoordinate2D)co;

@end

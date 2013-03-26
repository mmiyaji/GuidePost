//
//  ViewController.h
//  GuidePost
//
//  Created by Masahiro MIYAJI on 3/27/13.
//  Copyright (c) 2013 Masahiro MIYAJI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface ViewController : UIViewController <CLLocationManagerDelegate, UISearchBarDelegate>{
    IBOutlet MKMapView *mapView;
    IBOutlet UISearchBar *searchBar;
    CLLocationManager *locationManager;
}
-(IBAction)toggleSearch:        (id)sender;
-(IBAction)refreshCurrentLocation:        (id)sender;
@property (nonatomic, strong) MKMapView *mapView;
@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) CLLocation *currentLocation;
@property (nonatomic, strong) CLGeocoder *geocoder;
@end

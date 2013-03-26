//
//  ViewController.m
//  GuidePost
//
//  Created by Masahiro MIYAJI on 3/27/13.
//  Copyright (c) 2013 Masahiro MIYAJI. All rights reserved.
//

#import "ViewController.h"
#import "MyAnnotation.h"

@interface ViewController ()
@property (nonatomic, strong) MyAnnotation *myAnnotation;
@end

@implementation ViewController
@synthesize locationManager;
@synthesize mapView;
@synthesize searchBar;
-(IBAction)toggleSearch:(id)sender{
    searchBar.hidden = !searchBar.hidden;
}
-(IBAction)refreshCurrentLocation:(id)sender{
    [self startReceiveLocation];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    searchBar.delegate = self;
    mapView.showsUserLocation = YES;
    [self startReceiveLocation];
}

#pragma mark -- move pin to location you want  --
- (void)movePinLocationTo:(CLLocationCoordinate2D)coord {
    if (!self.myAnnotation) {
        self.myAnnotation = [[MyAnnotation alloc] initWithCoordinate:coord];
        [self.mapView addAnnotation:self.myAnnotation];
    }
    self.myAnnotation.coordinate = coord;
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(coord, 200.0f, 200.0f);
    [self.mapView setRegion:region animated:YES];
}

#pragma mark --  get the current location --
- (void)startReceiveLocation {
    if (nil == self.locationManager) {
        self.locationManager = [[CLLocationManager alloc] init];
    }
    self.locationManager.delegate = self;
    [self.locationManager startUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    self.currentLocation = newLocation;
    [self movePinLocationTo:self.currentLocation.coordinate];
    [self.locationManager stopUpdatingLocation];
    [self reverseGeocodeLocation:newLocation];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    [[[UIAlertView alloc] initWithTitle:@"エラー"
                               message:@"位置情報が取得できませんでした。"
                              delegate:nil
                     cancelButtonTitle:@"OK"
                     otherButtonTitles: nil]show];
}

#pragma mark --  search location by location name --
- (void) searchBarSearchButtonClicked: (UISearchBar *) _searchBar {
    [_searchBar resignFirstResponder];
    if ([[_searchBar.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] isEqualToString:@""]) {
        [[[UIAlertView alloc] initWithTitle:@"エラー"
                                    message:@"住所を入力してください。"
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles: nil]show];
        return;
    }    
//    __weak
    ViewController *weak_self = self;
    self.geocoder = [[CLGeocoder alloc] init];
    [self.geocoder geocodeAddressString:searchBar.text completionHandler:^(NSArray * placemarks, NSError * error) {
        if (error) {
            NSLog(@"Geocode failed with error: %@", error); return;
        }
        if (error) {
            [[[UIAlertView alloc] initWithTitle:@"エラー"
                                        message:@"場所が取得できませんでした。"
                                       delegate:nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles: nil]show];
            return;
        }
        [self printPlaceMarks:placemarks];
        CLPlacemark *placemark = [placemarks objectAtIndex:0];
        CLLocationCoordinate2D coord = placemark.location.coordinate;
        [weak_self movePinLocationTo:coord];
     }
     ];
}
- (void)reverseGeocodeLocation:(CLLocation *)location
{
    NSLog(@"didUpdateToLocation latitude=%f, longitude=%f",
          [location coordinate].latitude,
          [location coordinate].longitude);
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:location completionHandler:
     ^(NSArray* placemarks, NSError* error) {
         if (error) {
             NSLog(@"Geocode failed with error: %@", error); return;
         }
         if (error) {
             [[[UIAlertView alloc] initWithTitle:@"エラー"
                                         message:@"場所が取得できませんでした。"
                                        delegate:nil
                               cancelButtonTitle:@"OK"
                               otherButtonTitles: nil]show];
             return;
         }
         [self printPlaceMarks:placemarks];
     }];
}
- (void)printPlaceMarks:(NSArray*) placemarks{
    if ([placemarks count] == 0) {
        [[[UIAlertView alloc] initWithTitle:@"エラー"
                                    message:@"該当する場所がありません。"
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles: nil]show];
        return;
    }
    CLPlacemark* placemark;
    for(placemark in placemarks) {
        NSLog(@"\n");
        NSLog(@"name : %@", placemark.name);
        NSLog(@"ocean : %@", placemark.ocean);
        NSLog(@"postalCode : %@", placemark.postalCode);
        NSLog(@"subAdministrativeArea : %@", placemark.subAdministrativeArea);
        NSLog(@"subLocality : %@", placemark.subLocality);
        NSLog(@"subThoroughfare : %@", placemark.subThoroughfare);
        NSLog(@"thoroughfare : %@", placemark.thoroughfare);
        NSLog(@"administrativeArea : %@", placemark.administrativeArea);
        NSLog(@"inlandWater : %@", placemark.inlandWater);
        NSLog(@"ISOcountryCode : %@", placemark.ISOcountryCode);
        NSLog(@"locality : %@", placemark.locality);
        NSLog(@"addressDictionary CountryCode : %@", [placemark.addressDictionary objectForKey:@"CountryCode"]);
        NSLog(@"addressDictionary Country : %@", [placemark.addressDictionary objectForKey:@"Country"]);
        NSLog(@"addressDictionary ZIP : %@", [placemark.addressDictionary objectForKey:@"ZIP"]);
        NSLog(@"addressDictionary State : %@", [placemark.addressDictionary objectForKey:@"State"]);
        NSLog(@"addressDictionary SubLocality : %@", [placemark.addressDictionary objectForKey:@"SubLocality"]);
//        NSString* name; name = ABCreateStringWithAddressDictionary(placemark.addressDictionary, YES); NSLog(@"%@", name);
    }
}
@end

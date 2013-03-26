//
//  ViewController.m
//  GuidePost
//
//  Created by Masahiro MIYAJI on 3/27/13.
//  Copyright (c) 2013 Masahiro MIYAJI. All rights reserved.
//

#import "ViewController.h"
#import "MyAnnotation.h"

static const CGRect kNavigationBarFrame = {
    .origin = { .x = 0.f, .y = 0.f }, .size = { .width = 320.f, .height = 44.f }
};

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
    
//    searchBar = [[UISearchBar alloc] initWithFrame:kNavigationBarFrame];
    searchBar.delegate = self;
//    [self.view addSubview:searchBar];
//    searchBar.hidden = YES;
//    self.mapView = [[MKMapView alloc] initWithFrame:CGRectMake(0,kNavigationBarFrame.size.height,self.view.frame.size.width,self.view.frame.size.height - kNavigationBarFrame.size.height)];
    mapView.showsUserLocation = YES;
//    [self.view addSubview:self.mapView];
    
    [self startReceiveLocation];
}

#pragma mark -- move pin to location you want  --
- (void)movePinLocationTo:(CLLocationCoordinate2D)coord {
    if (!self.myAnnotation) {
        self.myAnnotation = [[MyAnnotation alloc] initWithCoordinate:coord];
        [self.mapView addAnnotation:self.myAnnotation];
    }
    
    // (*・∀・).｡oO(set a coordinate of the specific location)
    self.myAnnotation.coordinate = coord;
    
    // (*・∀・).｡oO(Specify the position of the center of the map and the display area)
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(coord, 200.0f, 200.0f);
    [self.mapView setRegion:region animated:YES];
}

#pragma mark --  get the current location --
- (void)startReceiveLocation {
    if (nil == self.locationManager) {
        self.locationManager = [[CLLocationManager alloc] init];
    }
    self.locationManager.delegate = self;
    
    // (*・∀・).｡oO(start receiving the current Location)
    [self.locationManager startUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    // (*・∀・).｡oO(get the current location)
    self.currentLocation = newLocation;
    
    // (*・∀・).｡oO(move a pin to the currentLocation)
    [self movePinLocationTo:self.currentLocation.coordinate];
    
    // (*・∀・).｡oO(stop receiving the current Location)
    [self.locationManager stopUpdatingLocation];
    //緯度・経度を出力
    NSLog(@"didUpdateToLocation latitude=%f, longitude=%f",
          [newLocation coordinate].latitude,
          [newLocation coordinate].longitude);
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
- (void) searchBarSearchButtonClicked: (UISearchBar *) searchBar {
    [searchBar resignFirstResponder];
    
    // (*・∀・).｡oO(show error message if there is only blank)
    if ([[searchBar.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] isEqualToString:@""]) {
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
        //             NSString* name;
        //             name = ABCreateStringWithAddressDictionary(placemark.addressDictionary, YES);
        //             NSLog(@"%@", name);
    }
}
@end

/*
//  DataCollectionVC.h
//  DataCollection
//
//  Created by Jeff Behrbaum on 10/5/15.
//  Copyright © 2015 Apio Systems. All rights reserved.
*/

#import <CoreLocation/CoreLocation.h>
#import <UIKit/UIKit.h>

@interface DataCollectionVC : UIViewController<CLLocationManagerDelegate, UITextViewDelegate>
	@property(nonatomic, weak) IBOutlet UILabel *lblAppInfo;
@end

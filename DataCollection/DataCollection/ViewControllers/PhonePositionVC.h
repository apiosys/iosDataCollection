//
//  PhonePositionVC.h
//  DataCollection
//
//  Created by Brandon Bodnar on 10/15/15.
//  Copyright © 2015 Apio Systems. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhonePositionVC : UITableViewController<UITableViewDelegate>

- (IBAction)setLoggingForWalkingPosition:(id)sender;
- (IBAction)setLoggingForVehiclePosition:(id)sender;
- (IBAction)setLoggingForVehicleEntryInformation:(id)sender;

@end

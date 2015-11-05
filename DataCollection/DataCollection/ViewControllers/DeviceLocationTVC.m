//
//  WalkingDeviceLocationTVC.m
//  DataCollection
//
//  Created by Brandon Bodnar on 10/27/15.
//  Copyright © 2015 Apio Systems. All rights reserved.
//

#import "DeviceLocationTVC.h"
#import "CPhoneInformationManager.h"

@interface DeviceLocationTVC ()
	@property NSIndexPath * selectedLocationIndex;
@end

@implementation DeviceLocationTVC

-(void)setSelectedLocation:(NSString *)selectedLocation
{
	if (_selectedLocation != selectedLocation) {
		NSUInteger row = [self.deviceLocations indexOfObject:selectedLocation];
		self.selectedLocationIndex = [NSIndexPath indexPathForRow:row inSection:0];
		_selectedLocation = selectedLocation;
	}
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return self.deviceLocations.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"DeviceLocationCell" forIndexPath:indexPath];

	if (cell && cell.textLabel)
	{
		cell.textLabel.text = self.deviceLocations[indexPath.row];
	}

	if( indexPath == self.selectedLocationIndex)
	{
		cell.accessoryType = UITableViewCellAccessoryCheckmark;
	}
	else
	{
		cell.accessoryType = UITableViewCellAccessoryNone;
	}

	return cell;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	if([sender isKindOfClass:[UITableViewCell class]])
	{
		UITableViewCell * cell = (UITableViewCell*) sender;
		NSInteger row = [self.tableView indexPathForCell:cell].row;
		self.selectedLocation = self.deviceLocations[row];
	}
}

@end

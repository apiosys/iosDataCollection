//
//  PhonePositionVC.m
//  DataCollection
//
//  Created by Brandon Bodnar on 10/15/15.
//  Copyright © 2015 Apio Systems. All rights reserved.
//

#import "PhonePositionVC.h"
#import "CPhoneInformationManager.h"
#import "DeviceLocationTVC.h"

@interface PhonePositionVC ()
	@property (weak, nonatomic) IBOutlet UISwitch *logWalkingSwitch;
	@property (weak, nonatomic) IBOutlet UISegmentedControl *walkingSideControl;
	@property (weak, nonatomic) IBOutlet UILabel *walkingLocationDetailLabel;


	@property (weak, nonatomic) IBOutlet UISwitch *logVehicleSwitch;
	@property (weak, nonatomic) IBOutlet UISegmentedControl *vehicleSideControl;
	@property (weak, nonatomic) IBOutlet UILabel *vehicleLocationDetailLabel;
	
	@property (weak, nonatomic) IBOutlet UISwitch *logVehicleEntrySwitch;
	@property (weak, nonatomic) IBOutlet UISegmentedControl *vehicleEntrySideControl;
	@property (weak, nonatomic) IBOutlet UISegmentedControl *vehicleEntryEndControl;
@end

@implementation PhonePositionVC

- (void)viewDidLoad
{
    [super viewDidLoad];
}

-(void)viewWillAppear:(BOOL)animated
{
	CPhoneInformationManager * manager = [CPhoneInformationManager thePhoneInformationManager];
	self.logWalkingSwitch.on = manager.walkingDevicePositionIncludeInLog;

	NSUInteger walkingSideIndex;
	switch (manager.walkingDevicePositionSide)
	{
		case WalkingSideLeft:
			walkingSideIndex = 0;
			break;
		case WalkingSideRight:
			walkingSideIndex = 1;
			break;
		case WalkingSideNotApplicable:
			walkingSideIndex = 2;
			break;
	}

	self.walkingSideControl.selectedSegmentIndex = walkingSideIndex;
	self.walkingLocationDetailLabel.text = manager.walkingDevicePositionLocation;

	self.logVehicleSwitch.on = manager.vehicleDevicePositionIncludeInLog;

	NSUInteger vehicleSideIndex;
	switch (manager.vehicleDevicePositionSide)
	{
		case VehicleSideLeft:
			vehicleSideIndex = 0;
			break;
		case VehicleSideCenter:
			vehicleSideIndex = 1;
			break;
		case VehicleSideRight:
			vehicleSideIndex = 2;
			break;
	}
	self.vehicleSideControl.selectedSegmentIndex = vehicleSideIndex;

	self.vehicleLocationDetailLabel.text = manager.vehicleDevicePositionLocation;

	self.logVehicleEntrySwitch.on = manager.vehicleEntryInformationIncludeInLog;

	NSUInteger vehicleEntrySide;
	switch (manager.vehicleEntryInformationVehicleSide)
	{
		case VehicleSideLeft:
			vehicleEntrySide = 0;
			break;
		case VehicleSideRight:
			vehicleSideIndex = 1;
			break;
		default:
			vehicleSideIndex = 0;
			break;
	}
	self.vehicleEntrySideControl.selectedSegmentIndex = vehicleEntrySide;

	NSUInteger vehicleEntryEnd;
	switch (manager.vehicleEntryInformationVehicleEnd)
	{
		case VehicleEndFront:
			vehicleEntryEnd = 0;
			break;
		case VehicleEndRear:
			vehicleEntryEnd = 1;
			break;
		default:
			vehicleEntryEnd = 0;
			break;
	}
	self.vehicleEntryEndControl.selectedSegmentIndex = vehicleEntryEnd;

	[super viewDidAppear:animated];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)viewDidDisappear:(BOOL)animated
{
	[[CPhoneInformationManager thePhoneInformationManager] saveData];
}

- (IBAction)setLoggingForWalkingPosition:(UISwitch*)sender
{
	[self.tableView beginUpdates];
	[CPhoneInformationManager thePhoneInformationManager].walkingDevicePositionIncludeInLog = sender.on;
	[self.tableView endUpdates];
}

- (IBAction)setWalkingDevicePositionSide:(UISegmentedControl *)sender
{
	WalkingSide side;
	switch (sender.selectedSegmentIndex)
	{
		case 0:
			side = WalkingSideLeft;
			break;
		case 1:
			side = WalkingSideRight;
			break;
		case 2:
		default:
			side = WalkingSideNotApplicable;
			break;
	}

	[CPhoneInformationManager thePhoneInformationManager].walkingDevicePositionSide = side;
}

- (IBAction)setLoggingForVehiclePosition:(UISwitch*)sender
{
	[self.tableView beginUpdates];
	[CPhoneInformationManager thePhoneInformationManager].vehicleDevicePositionIncludeInLog = sender.on;
	[self.tableView endUpdates];
}
- (IBAction)setVehicleDevicePositionSide:(UISegmentedControl *)sender
{
	VehicleSide side;
	switch (sender.selectedSegmentIndex)
	{
		case 0:
			side = VehicleSideLeft;
			break;
		case 1:
			side = VehicleSideCenter;
			break;
		case 2:
		default:
			side = VehicleSideRight;
			break;
	}
	[CPhoneInformationManager thePhoneInformationManager].vehicleDevicePositionSide = side;
}

- (IBAction)setLoggingForVehicleEntryInformation:(UISwitch*)sender
{
	[self.tableView beginUpdates];
	[CPhoneInformationManager thePhoneInformationManager].vehicleEntryInformationIncludeInLog = sender.on;
	[self.tableView endUpdates];
}

- (IBAction)setVehicleEntryVehicleEnd:(UISegmentedControl *)sender
{
	VehicleEnd end;
	switch (sender.selectedSegmentIndex)
	{
		case 0:
			end = VehicleEndFront;
			break;
		case 1:
			end = VehicleEndRear;
			break;
		default:
			end = VehicleEndFront;
			break;
	}
	[CPhoneInformationManager thePhoneInformationManager].vehicleEntryInformationVehicleEnd = end;
}

- (IBAction)setVehicleEntryVehicleSide:(UISegmentedControl *)sender
{
	VehicleSide side;
	switch (sender.selectedSegmentIndex)
	{
		case 0:
			side = VehicleSideLeft;
			break;
		case 1:
		default:
			side = VehicleSideRight;
			break;
	}

	[CPhoneInformationManager thePhoneInformationManager].vehicleEntryInformationVehicleSide = side;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - UIPickerView DataSource methods

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
	return 1;
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	if ([segue.identifier isEqualToString:@"WalkingDeviceLocationSegue"])
	{
		DeviceLocationTVC * deviceLocationController = segue.destinationViewController;
		deviceLocationController.deviceLocations = [CPhoneInformationManager thePhoneInformationManager].allWalkingDevicePositionLocations;
		deviceLocationController.selectedLocation =[CPhoneInformationManager thePhoneInformationManager].walkingDevicePositionLocation;
	}
	else if ([segue.identifier isEqualToString:@"VehicleDeviceLocationSegue"])
	{
		DeviceLocationTVC * deviceLocationController = segue.destinationViewController;
		deviceLocationController.deviceLocations = [CPhoneInformationManager thePhoneInformationManager].allVehicleDevicePositionLocations;
		deviceLocationController.selectedLocation =[CPhoneInformationManager thePhoneInformationManager].vehicleDevicePositionLocation;
	}
}

-(IBAction) unwindFromDeviceLocationSegue:(UIStoryboardSegue *)segue
{
	if ([segue.identifier isEqualToString:@"WalkingDeviceLocationUnwindSegue"])
	{
		DeviceLocationTVC * deviceLocationController = segue.sourceViewController;
		NSString * selectedLocation = deviceLocationController.selectedLocation;
		[CPhoneInformationManager thePhoneInformationManager].walkingDevicePositionLocation = selectedLocation;
		self.walkingLocationDetailLabel.text = selectedLocation;
	}
	else if ([segue.identifier isEqualToString:@"VehicleDeviceLocationUnwindSegue"])
	{
		DeviceLocationTVC * deviceLocationController = segue.sourceViewController;
		NSString * selectedLocation = deviceLocationController.selectedLocation;
		[CPhoneInformationManager thePhoneInformationManager].vehicleDevicePositionLocation = selectedLocation;
		self.vehicleLocationDetailLabel.text = selectedLocation;
	}
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (indexPath.section == 0 && indexPath.row != 0 && self.logWalkingSwitch.on == FALSE)
		return 0;

	if (indexPath.section == 1 && indexPath.row != 0 && self.logVehicleSwitch.on == FALSE)
		return 0;

	if (indexPath.section == 2 && indexPath.row != 0 && self.logVehicleEntrySwitch.on == FALSE)
		return 0;

	return [super tableView:tableView heightForRowAtIndexPath:indexPath];
}

@end

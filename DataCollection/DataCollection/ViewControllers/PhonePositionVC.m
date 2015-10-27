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
#import "CMotionLogger.h"

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
	self.logWalkingSwitch.on = manager.enableLoggingOfWalkingDevicePosition;

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

	self.logVehicleSwitch.on = manager.enableLoggingOfVehicleDevicePosition;

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

	self.logVehicleEntrySwitch.on = manager.enableLoggingOfVehicleEntryInformation;

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
	CPhoneInformationManager * manager = [CPhoneInformationManager thePhoneInformationManager];
	manager.enableLoggingOfWalkingDevicePosition = sender.on;

	if (sender.on)
	{
		CMotionLogger * logger = [CMotionLogger theLogger];
		if ([logger isLogging])
		{
			[logger logWalkingDeviceSide:manager.walkingDevicePositionSide];
			[logger logWalkingDeviceLocation:manager.walkingDevicePositionLocation];
		}
	}
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

	CPhoneInformationManager * manager = [CPhoneInformationManager thePhoneInformationManager];
	manager.walkingDevicePositionSide = side;
	if(manager.enableLoggingOfWalkingDevicePosition)
	{
		CMotionLogger * logger = [CMotionLogger theLogger];
		if ([logger isLogging])
		{
			[logger logWalkingDeviceSide:side];
		}
	}

}

- (IBAction)setLoggingForVehiclePosition:(UISwitch*)sender
{
	CPhoneInformationManager * manager = [CPhoneInformationManager thePhoneInformationManager];
	manager.enableLoggingOfVehicleDevicePosition = sender.on;

	if (sender.on)
	{
		CMotionLogger * logger = [CMotionLogger theLogger];
		if ([logger isLogging])
		{
			[logger logVehicleDeviceSide:manager.vehicleDevicePositionSide];
			[logger logVehicleDeviceLocation:manager.vehicleDevicePositionLocation];
		}
	}
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
	CPhoneInformationManager * manager = [CPhoneInformationManager thePhoneInformationManager];
	manager.vehicleDevicePositionSide = side;
	if (manager.enableLoggingOfVehicleDevicePosition)
	{
		CMotionLogger * logger = [CMotionLogger theLogger];
		if ([logger isLogging])
		{
			[logger logVehicleDeviceSide:side];
		}
	}
}

- (IBAction)setLoggingForVehicleEntryInformation:(UISwitch*)sender
{
	CPhoneInformationManager * manager = [CPhoneInformationManager thePhoneInformationManager ];
	manager.enableLoggingOfVehicleEntryInformation = sender.on;

	if (sender.on)
	{
		CMotionLogger * logger = [CMotionLogger theLogger];
		if ([logger isLogging])
		{
			[logger logVehicleEntryVehicleEnd:manager.vehicleEntryInformationVehicleEnd];
			[logger logVehicleEntryVehicleSide:manager.vehicleEntryInformationVehicleSide];
		}
	}

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
	CPhoneInformationManager * manager = [CPhoneInformationManager thePhoneInformationManager];
	manager.vehicleEntryInformationVehicleEnd = end;

	if (manager.enableLoggingOfVehicleEntryInformation)
	{
		CMotionLogger * logger = [CMotionLogger theLogger];
		if ([logger isLogging])
		{
			[logger logVehicleEntryVehicleEnd:end];
		}
	}
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

	CPhoneInformationManager * manager = [CPhoneInformationManager thePhoneInformationManager];
	manager.vehicleEntryInformationVehicleSide = side;

	if (manager.enableLoggingOfVehicleEntryInformation)
	{
		CMotionLogger * logger = [CMotionLogger theLogger];
		if ([logger isLogging])
		{
			[logger logVehicleEntryVehicleSide:side];
		}
	}
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
	CPhoneInformationManager * manager = [CPhoneInformationManager thePhoneInformationManager];
	CMotionLogger * logger = [CMotionLogger theLogger];

	if ([segue.identifier isEqualToString:@"WalkingDeviceLocationUnwindSegue"])
	{
		DeviceLocationTVC * deviceLocationController = segue.sourceViewController;
		NSString * selectedLocation = deviceLocationController.selectedLocation;
		manager.walkingDevicePositionLocation = selectedLocation;
		self.walkingLocationDetailLabel.text = selectedLocation;
		if (manager.enableLoggingOfWalkingDevicePosition && logger.isLogging) {
			[logger logWalkingDeviceLocation:selectedLocation];
		}
	}
	else if ([segue.identifier isEqualToString:@"VehicleDeviceLocationUnwindSegue"])
	{
		DeviceLocationTVC * deviceLocationController = segue.sourceViewController;
		NSString * selectedLocation = deviceLocationController.selectedLocation;
		manager.vehicleDevicePositionLocation = selectedLocation;
		self.vehicleLocationDetailLabel.text = selectedLocation;
		if (manager.enableLoggingOfVehicleDevicePosition && logger.isLogging) {
			[logger logVehicleDeviceLocation:selectedLocation];
		}
	}
}

@end

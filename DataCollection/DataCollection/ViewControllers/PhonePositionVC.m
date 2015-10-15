//
//  PhonePositionVC.m
//  DataCollection
//
//  Created by Brandon Bodnar on 10/15/15.
//  Copyright © 2015 Apio Systems. All rights reserved.
//

#import "PhonePositionVC.h"
#import "CPhoneInformationManager.h"

@interface PhonePositionVC ()
	@property (weak, nonatomic) IBOutlet UISwitch *logWalkingSwitch;
	@property (weak, nonatomic) IBOutlet UISegmentedControl *walkingSideControl;
	@property (weak, nonatomic) IBOutlet UIPickerView *walkingDeviceLocationPicker;
	@property (weak, nonatomic) IBOutlet UISwitch *logVehicleSwitch;
	@property (weak, nonatomic) IBOutlet UISegmentedControl *vehicleSideControl;
	@property (weak, nonatomic) IBOutlet UIPickerView *vehicleDeviceLocationPicker;
	@property (weak, nonatomic) IBOutlet UISwitch *logVehicleEntrySwitch;
	@property (weak, nonatomic) IBOutlet UISegmentedControl *vehicleEntrySideControl;
	@property (weak, nonatomic) IBOutlet UISegmentedControl *vehicleEntryEndControl;
@end

@implementation PhonePositionVC

- (void)viewDidLoad
{
    [super viewDidLoad];
}

-(void)viewDidAppear:(BOOL)animated
{
	CPhoneInformationManager * manager = [CPhoneInformationManager thePhoneInformationManager];
	self.logWalkingSwitch.on = manager.walkingDevicePositionIncludeInLog;

	NSUInteger walkingSideIndex;
	switch (manager.walkingDevicePositionSide)
	{
		case VehicleSideLeft:
			walkingSideIndex = 0;
			break;
		case VehicleSideRight:
			walkingSideIndex = 1;
			break;
		case VehicleSideNotApplicable:
			walkingSideIndex = 2;
			break;
		default:
			walkingSideIndex = 0;
			break;
	}
	self.walkingSideControl.selectedSegmentIndex = walkingSideIndex;

	NSUInteger index = [manager.allWalkingDevicePositionLocations indexOfObject:manager.walkingDevicePositionLocation];
	[self.walkingDeviceLocationPicker selectRow:index inComponent:0 animated:animated];

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
		default:
			vehicleSideIndex = 0;
			break;
	}
	self.vehicleSideControl.selectedSegmentIndex = vehicleSideIndex;

	index = [manager .allVehicleDevicePositionLocations indexOfObject:manager.vehicleDevicePositionLocation];
	[self.vehicleDeviceLocationPicker selectRow:index inComponent:0 animated:animated];

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
	[CPhoneInformationManager thePhoneInformationManager].walkingDevicePositionIncludeInLog = sender.on;
}

- (IBAction)setWalkingDevicePositionSide:(UISegmentedControl *)sender
{
	VehicleSide side;
	switch (sender.selectedSegmentIndex)
	{
		case 0:
			side = VehicleSideLeft;
			break;
		case 1:
			side = VehicleSideRight;
			break;
		case 2:
		default:
			side = VehicleSideNotApplicable;
			break;
	}
	[CPhoneInformationManager thePhoneInformationManager].walkingDevicePositionSide = side;
}

- (IBAction)setLoggingForVehiclePosition:(UISwitch*)sender
{
	[CPhoneInformationManager thePhoneInformationManager].vehicleDevicePositionIncludeInLog = sender.on;
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
			side = VehicleSideRight;
			break;
		default:
			side = VehicleSideNotApplicable;
			break;
	}
	[CPhoneInformationManager thePhoneInformationManager].vehicleDevicePositionSide = side;
}

- (IBAction)setLoggingForVehicleEntryInformation:(UISwitch*)sender
{
	[CPhoneInformationManager thePhoneInformationManager].vehicleEntryInformationIncludeInLog = sender.on;
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
			side = VehicleSideRight;
			break;
		default:
			side = VehicleSideNotApplicable;
			break;
	}

	[CPhoneInformationManager thePhoneInformationManager].vehicleEntryInformationVehicleSide = side;
}

#pragma mark - UIPickerView DataSource methods

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
	return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
	if (pickerView == self.walkingDeviceLocationPicker)
	{
		return [CPhoneInformationManager thePhoneInformationManager].allWalkingDevicePositionLocations.count;
	}
	else if (pickerView == self.vehicleDeviceLocationPicker)
	{
		return [CPhoneInformationManager thePhoneInformationManager].allVehicleDevicePositionLocations.count;
	}
	else
	{
		return 0;
	}
}

#pragma mark - UIPickerViewDelegate methods

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
	if (pickerView == self.walkingDeviceLocationPicker)
	{
		return [[CPhoneInformationManager thePhoneInformationManager].allWalkingDevicePositionLocations objectAtIndex:row];
	}
	else if (pickerView == self.vehicleDeviceLocationPicker)
	{
		return [[CPhoneInformationManager thePhoneInformationManager].allVehicleDevicePositionLocations objectAtIndex:row];
	}

	return nil;
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
	CPhoneInformationManager* manager = [CPhoneInformationManager thePhoneInformationManager];

	if (pickerView == self.walkingDeviceLocationPicker)
	{
		manager.walkingDevicePositionLocation = [manager.allWalkingDevicePositionLocations objectAtIndex:row];
	}
	else if (pickerView == self.vehicleDeviceLocationPicker)
	{
		manager.vehicleDevicePositionLocation = [manager.allVehicleDevicePositionLocations objectAtIndex:row];
	}
}
@end

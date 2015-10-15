#import "CMotionLogger.h"
#import "CSensorSampleInfoContainer.h"
#import "STSensorManager.h"

typedef enum
{
	INVALID_FD,
	NATIVE_FD,
	NS_FD//If you're using NSFileHandle
}FD_TYPE;


@interface CMotionLogger()
	@property(nonatomic) int nativeFileDescriptor;
	@property(nonatomic, strong) NSDateFormatter *dtFmtr;
	@property(nonatomic, strong) NSFileHandle *fileHandle;
	@property(nonatomic, strong) NSString *deviceNameStr;

	@property(nonatomic, readonly) FD_TYPE eLoggingType;

	-(NSString*) stringFromVehicleSide:(VehicleSide)side;
	-(NSString*) stringFromVehicleEnd:(VehicleEnd)end;
@end

@implementation CMotionLogger

@synthesize fileHandle = _fileHandle;
@synthesize nativeFileDescriptor = _nativeFileDescriptor;

-(FD_TYPE)eLoggingType
{
	//return NS_FD;
	return NATIVE_FD;
}

-(NSDateFormatter *)dtFmtr
{
	if(_dtFmtr == nil)
	{
		_dtFmtr = [[NSDateFormatter alloc]init];
		[_dtFmtr setDateFormat:@"yyyyMMdd HHmmss.SSS"];
	}
	
	return _dtFmtr;
}

-(NSString *)deviceNameStr
{
	if(_deviceNameStr == nil)
	{
		NSCharacterSet *unallowedFileNameCharacters = [NSCharacterSet characterSetWithCharactersInString:@"_'\":*&^%$#@!~`<>?/\\{}[]=+ "];
		_deviceNameStr = [[[UIDevice currentDevice].name componentsSeparatedByCharactersInSet:unallowedFileNameCharacters] componentsJoinedByString:@""];
	}

	return _deviceNameStr;
}

+(CMotionLogger *)theLogger
{
	static CMotionLogger *loggerMgr;
	
	static dispatch_once_t onceToken;
	
	dispatch_once(&onceToken, ^{
		loggerMgr = [[CMotionLogger alloc] init];
	});
	
	return loggerMgr;
}


-(void)closeFileDescriptor
{
	if(self.fileHandle != nil)
		[self.fileHandle closeFile];
	if(self.nativeFileDescriptor > 0)
		close(_nativeFileDescriptor);
	
	self.fileHandle = nil;
	_nativeFileDescriptor = -1;
}

-(void)markAsStartDataCaptureTime
{
	FD_TYPE eFdType = [self logFileHandleIsValid];

	if(eFdType != INVALID_FD)
		return;//Don't try to open if you already have a valid file descriptor

	if(self.fileHandle != nil)
		[self.fileHandle closeFile];
	if(self.nativeFileDescriptor > 0)
		close(_nativeFileDescriptor);

	if(self.eLoggingType == NS_FD)
	{
		if([self createAndOpenFileAtPath:[self retreiveCurrentFilePathAndName]] == FALSE)
			NSLog(@"Unable to open the file at path: %@", [self retreiveCurrentFilePathAndName]);
	}
	else if(self.eLoggingType == NATIVE_FD)
	{
		if([self nativeCreateAndOpenFileAtPath:[self retreiveCurrentFilePathAndName]] == FALSE)
			NSLog(@"Unable to open the file at path: %@", [self retreiveCurrentFilePathAndName]);
	}
}

-(void)logTexting:(BOOL)bIsStarting
{
	NSString *eventStr = [NSString stringWithFormat:@"%@:Texting\n", (bIsStarting == TRUE) ? @"SE" : @"EE"];
	
	@try
	{
		if([self writeCurrentData:eventStr] == FALSE)
			NSLog(@"Error writing the texting information");
	}
	@catch (NSException *exception)
	{
		NSLog(@"Execption on write attempt: %@", exception.debugDescription);
	}
}

-(void)logPhoneCall:(BOOL)bIsStarting
{
	NSString *eventStr = [NSString stringWithFormat:@"%@:PhoneCall\n", (bIsStarting == TRUE) ? @"SE" : @"EE"];

	@try
	{
		if([self writeCurrentData:eventStr] == FALSE)
			NSLog(@"Error writing the Phone Call information");
	}
	@catch (NSException *exception)
	{
		NSLog(@"Execption on write attempt: %@", exception.debugDescription);
	}
}

-(void)logGeneralHandling:(BOOL)bIsStarting
{
	NSString *eventStr = [NSString stringWithFormat:@"%@:GeneralHandling\n", (bIsStarting == TRUE) ? @"SE" : @"EE"];
	
	@try
	{
		if([self writeCurrentData:eventStr] == FALSE)
			NSLog(@"Error writing the Phone Call information");
	}
	@catch (NSException *exception)
	{
		NSLog(@"Execption on write attempt: %@", exception.debugDescription);
	}
}

-(void)logUserIsDriver:(BOOL)bUserIsDriver
{
	NSString *eventStr = @"NOTICE:UserIsTheDriver:";
	eventStr = [eventStr stringByAppendingString:[NSString stringWithFormat:@"%@\n", (bUserIsDriver == TRUE) ? @"YES" : @"NO"]];
	
	@try
	{
		if([self writeCurrentData:eventStr] == FALSE)
			NSLog(@"Error writing the User Is Driver information");
	}
	@catch (NSException *exception)
	{
		NSLog(@"Execption on write attempt: %@", exception.debugDescription);
	}
}

-(NSString*) stringFromVehicleSide:(VehicleSide)side
{
	switch (side)
	{
		case VehicleSideLeft:
			return @"Left";
		case VehicleSideCenter:
			return @"Center";
		case VehicleSideRight:
			return @"Right";
		case VehicleSideNotApplicable:
			return @"N/A";
	}
}
-(NSString*) stringFromVehicleEnd:(VehicleEnd)end
{
	switch (end)
	{
		case VehicleEndFront:
			return @"Front";
		case VehicleEndRear:
			return @"Rear";
	}
}

-(void)logWalkingDevicePositionWithSide:(VehicleSide)side andLocation:(NSString*) location
{
	NSString *eventStr = [NSString stringWithFormat:@"NOTICE:WalkingDeviceSide:%@\nNOTICE:WalkingDeviceLocation:%@\n", [self stringFromVehicleSide:side], location];
	@try
	{
		if([self writeCurrentData:eventStr] == FALSE)
			NSLog(@"Error writing the Walking Device Position information");
	}
	@catch (NSException *exception)
	{
		NSLog(@"Exception on write attempt: %@", exception.debugDescription);
	}
}

-(void)logVehicleDevicePositionWithSide:(VehicleSide)side andLocation:(NSString*) location
{
	NSString *eventStr = [NSString stringWithFormat:@"NOTICE:VehicleDeviceSide:%@\nNOTICE:VehicleDeviceLocation:%@\n", [self stringFromVehicleSide:side], location];
	@try
	{
		if([self writeCurrentData:eventStr] == FALSE)
			NSLog(@"Error writing the Vehicle Device Position information");
	}
	@catch (NSException *exception)
	{
		NSLog(@"Exception on write attempt: %@", exception.debugDescription);
	}

}

-(void)logVehicleEntryInformationWithVehicleEnd:(VehicleEnd)end andVehicleSide:(VehicleSide)side
{
	NSString *eventStr = [NSString stringWithFormat:@"NOTICE:VehicleEntrySide:%@\nNOTICE:VehicleEntryEnd:%@\n", [self stringFromVehicleSide:side], [self stringFromVehicleEnd:end]];
	@try
	{
		if([self writeCurrentData:eventStr] == FALSE)
			NSLog(@"Error writing the Vehicle Entry information");
	}
	@catch (NSException *exception)
	{
		NSLog(@"Exception on write attempt: %@", exception.debugDescription);
	}

}

-(void)writeCurrentSamplesToLogFile
{
	STSensorManager *sensorMgr = [STSensorManager theSensorManager];

	@try
	{
		double timestamp = [[NSDate date] timeIntervalSince1970];
		int64_t timeInMilisInt64 = (int64_t)(timestamp * 1000);
		
		NSString *timestampString = [NSString stringWithFormat:@"%lld", timeInMilisInt64];
		
		[self writeCurrentData:[sensorMgr printableString:timestampString]];
	}
	@catch (NSException *exception)
	{
		NSLog(@"Execption on write attempt: %@", exception.debugDescription);
	}
}

-(void)writeLineToLog:(NSString *)lineEntry
{
	if([self writeCurrentData:lineEntry] == FALSE)
		NSLog(@"Failed to write out the data entry");
}

-(BOOL)writeCurrentData:(NSString *)sensorInfo
{
	BOOL bRetStat = FALSE;

	FD_TYPE fdType = [self logFileHandleIsValid];

	if( (fdType == INVALID_FD) || (sensorInfo == nil) )
		return FALSE;

	if(fdType == NS_FD)
	{
		NSData *fileData = [self dataForFileWrite:sensorInfo];

		if(self.fileHandle != nil)
		{
			[self.fileHandle writeData:fileData];
			bRetStat = TRUE;
		}
	}
	else
	{
		bRetStat = [self nativeDataFileWrite:sensorInfo];
	}

	return bRetStat;
}

-(NSString *)retreiveCurrentFilePathAndName
{
	//get the documents directory:
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);

	NSString *documentsDirectory = [paths objectAtIndex:0];

	NSLocale *usLocal = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
	NSDateFormatter *fmtr = [[NSDateFormatter alloc]init];
	[fmtr setDateFormat:@"yyyy-MM-dd-HHmmss"];
	[fmtr setLocale:usLocal];

	//make a file name to write the data to using the documents directory:
	NSString *fileName = [NSString stringWithFormat:@"%@_%@_log.txt", self.deviceNameStr, [fmtr stringFromDate:[NSDate date]]];
	fileName = [documentsDirectory stringByAppendingPathComponent:fileName];

	return fileName;
}

-(NSData *)dataForFileWrite:(NSString *)dataString
{
	NSData *fileData;

	@try
	{
		//Making a copy of the string because there were several instances of
		//"writeData" exceptions with the data string.
		NSString *strDataCopy = [NSString stringWithFormat:@"%@", dataString];
	
		if([strDataCopy canBeConvertedToEncoding:NSUTF8StringEncoding] == TRUE)
			fileData = [strDataCopy dataUsingEncoding:NSUTF8StringEncoding];
		else if([strDataCopy canBeConvertedToEncoding:NSASCIIStringEncoding] == TRUE)
			fileData = [strDataCopy dataUsingEncoding:NSASCIIStringEncoding];
		else if([strDataCopy canBeConvertedToEncoding:NSISOLatin1StringEncoding] == TRUE)
			fileData = [strDataCopy dataUsingEncoding:NSISOLatin1StringEncoding];
		else if([strDataCopy canBeConvertedToEncoding:NSUnicodeStringEncoding] == TRUE)
			fileData = [strDataCopy dataUsingEncoding:NSUnicodeStringEncoding];
		else if([strDataCopy canBeConvertedToEncoding:NSUTF16BigEndianStringEncoding] == TRUE)
			fileData = [strDataCopy dataUsingEncoding:NSUTF16BigEndianStringEncoding];
		else if([strDataCopy canBeConvertedToEncoding:NSUTF16LittleEndianStringEncoding] == TRUE)
			fileData = [strDataCopy dataUsingEncoding:NSUTF16LittleEndianStringEncoding];
		else if([strDataCopy canBeConvertedToEncoding:NSUTF32StringEncoding] == TRUE)
			fileData = [strDataCopy dataUsingEncoding:NSUTF32StringEncoding];
		else if([strDataCopy canBeConvertedToEncoding:NSUnicodeStringEncoding] == TRUE)
			fileData = [strDataCopy dataUsingEncoding:NSUnicodeStringEncoding];
		else if([strDataCopy canBeConvertedToEncoding:NSUTF32BigEndianStringEncoding] == TRUE)
			fileData = [strDataCopy dataUsingEncoding:NSUTF32BigEndianStringEncoding];
		else if([strDataCopy canBeConvertedToEncoding:NSUTF32LittleEndianStringEncoding] == TRUE)
			fileData = [strDataCopy dataUsingEncoding:NSUTF32LittleEndianStringEncoding];
		else
			fileData = nil;
	}
	@catch (NSException *exception)
	{
		fileData = nil;
		NSLog(@"Failed to write");
	}
	@finally
	{}
	
	return fileData;
}

-(BOOL)nativeDataFileWrite:(NSString *)dataString
{
	BOOL bRetStat = FALSE;

	if( (fcntl(_nativeFileDescriptor, F_GETFD) == -1) || (dataString.length <= 0) )
		return bRetStat;
	
	const char *logBuffer = [dataString UTF8String];
	
	ssize_t numBytesWritten = write(_nativeFileDescriptor, logBuffer, dataString.length);

	if( (numBytesWritten > 0) && (numBytesWritten == dataString.length) )
		bRetStat = TRUE;
	else
		NSLog(@"Failed to write natvie");
		
	return bRetStat;
}

-(BOOL)createAndOpenFileAtPath:(NSString *)path
{
	BOOL fileCreated = FALSE;

	if(self.eLoggingType == NS_FD)
	{
		fileCreated = [[NSFileManager defaultManager] createFileAtPath:path contents:nil attributes:nil];

		if (! fileCreated)
		{
			NSLog(@"Path: %@", path);
			NSLog(@"Error was code: %d - message: %s", errno, strerror(errno));
			return FALSE;
		}
	
		NSFileHandle * fileHandle = [NSFileHandle fileHandleForWritingAtPath:path];
	
		if(fileHandle == nil)
			return FALSE;
	
		self.fileHandle = fileHandle;
		fileCreated = (self.fileHandle != nil);
	}
	else
	{
		fileCreated = [self nativeFileDescriptor];
	}
	
	return fileCreated;
}

-(BOOL)nativeCreateAndOpenFileAtPath:(NSString *)path
{
	BOOL bRetStat = FALSE;
	
	if(path.length <= 0)
		return bRetStat;

	_nativeFileDescriptor = open([path UTF8String] , O_WRONLY | O_CREAT, S_IRWXU);

	if(_nativeFileDescriptor > 0)
		bRetStat = TRUE;
	
	return bRetStat;
}

-(FD_TYPE)logFileHandleIsValid
{
	FD_TYPE eRetStat = INVALID_FD;

	if(_nativeFileDescriptor <= 0)
	{
		if(self.fileHandle != nil)
			eRetStat = NS_FD;
	}
	else if(_nativeFileDescriptor > 0)
	{
		if(fcntl(_nativeFileDescriptor, F_GETFD) != -1)
			eRetStat = NATIVE_FD;

	}

	return eRetStat;
}

@end

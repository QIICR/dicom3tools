BinaryValues="Zero" {
	0x0000
}

BinaryValues="One" {
	0x0001
}

BinaryValues="Three" {
	0x0003
}

BinaryValues="FFFF" {
	0xffff = Inconsistencies may be present
}

BinaryValues="PregnancyStatus" {
	0x0001 = Not Pregnant,
	0x0002 = Possibly Pregnant,
	0x0003 = Definitely Pregnant,
	0x0004 = Unknown
}

BinaryValues="RegionSpatialFormat" {
	0x0000 = None,
	0x0001 = 2D (Tissue or Flow),
	0x0002 = M-Mode (Tissue or Flow),
	0x0003 = Spectral (Tissue or Flow),
	0x0004 = Wave Form,
	0x0005 = Graphics
}

BinaryValues="RegionDataType" {
	0x0000 = None,
	0x0001 = Tissue,
	0x0002 = Color Flow,
	0x0003 = PW Spectral Doppler,
	0x0004 = CW Spectral Doppler,
	0x0005 = Doppler Mean Trace,
	0x0006 = Doppler Mode Trace,
	0x0007 = Doppler Max Trace,
	0x0008 = Volume Trace,
	0x0009 = d(volume)/dt Trace,
	0x000a = ECG Trace,
	0x000b = Pulse Trace,
	0x000c = Phonocardiogram Trace,
	0x000d = Gray Bar,
	0x000e = Color Bar,
	0x000f = Integrated Backscatter,
	0x0010 = Area Trace,
	0x0011 = d(area)/dt,
	0x0012 = Other Physiological Amplitude vs. Time Input
}

BinaryBitMap="RegionFlags" {
	0 = Priority       : High,Low;
	1 = Scaling Protection : Not Protected,Protected;
	2 = Doppler Scale Type : Velocity,Frequency;
	3 = Scrolling Region : Not Scrolling,Scrolling;
	4 = Sweeping Region : Not Sweeping,Sweeping;
}

BinaryValues="PixelComponentOrganization" {
	0x0000 = Bit Aligned Positions,
	0x0001 = Ranges,
	0x0002 = Table Look Up
	0x0003 = Code Sequence Look Up
}

BinaryValues="PixelComponentPhysicalUnits" {
	0x0000 = None,
	0x0001 = Percent,
	0x0002 = dB,
	0x0003 = cm,
	0x0004 = seconds,
	0x0005 = hertz(seconds-1),
	0x0006 = dB/seconds,
	0x0007 = cm/sec,
	0x0008 = cm2,
	0x0009 = cm2/sec,
	0x000a = cm3,
	0x000b = cm3/sec,
	0x000c = degrees
}

BinaryValues="PixelComponentDataType" {
	0x0000 = None,
	0x0001 = Tissue,
	0x0002 = Spectral Doppler,
	0x0003 = Color Flow Velocity,
	0x0004 = Color Flow Variance,
	0x0005 = Color Flow Intensity,
	0x0006 = Gray Bar,
	0x0007 = Color Bar,
	0x0008 = Integrated Backscatter,
	0x0009 = Computed Border,
	0x000A = Tissue Classification
}

BinaryValues="PixelRepresentation" {
	0x0000 = unsigned,
	0x0001 = signed
}

BinaryValues="PixelRepresentationUnsigned" {
	0x0000 = unsigned
}

BinaryValues="PlanarConfiguration" {
	0x0000 = sequential planes,
	0x0001 = contiguous planes
}

BinaryValues="USPlanarConfiguration" {
	0x0000 = sequential planes,
	0x0001 = contiguous planes
}

BinaryValues="SamplesPerPixelIsOne" {
	0x0001
}

BinaryValues="SamplesPerPixelIsThree" {
	0x0003
}

BinaryValues="SamplesPerPixelIsOneOrThree" {
	0x0001,
	0x0003
}

BinaryValues="SamplesPerPixelUsedIsTwo" {
	0x0002
}

BinaryValues="PlanarConfigurationIsColorByPlane" {
	0x0001
}

BinaryValues="PlanarConfigurationIsColorByPixel" {
	0x0000
}

BinaryValues="PlanarConfigurationIsColorByPlaneOrPixel" {
	0x0000,
	0x0001
}

BinaryValues="BitsAre32" {
	32
}

BinaryValues="BitsAre64" {
	64
}

BinaryValues="BitsAre16" {
	0x0010
}

BinaryValues="BitsAre15" {
	0x000f
}

BinaryValues="BitsAre8" {
	0x0008
}

BinaryValues="BitsAre7" {
	0x0007,
}

BinaryValues="BitsAre12Or16" {
	0x000c,
	0x0010
}

BinaryValues="BitsAre11Or15" {
	0x000b,
	0x000f
}

BinaryValues="BitsAre8Or16" {
	0x0008,
	0x0010
}

BinaryValues="BitsAre16Or32" {
	0x0010,
	0x0020
}

BinaryValues="BitsAre7Or15" {
	0x0007,
	0x000f
}

BinaryValues="BitsAre15Or31" {
	0x000f,
	0x001f
}

BinaryValues="BitsAre8Or10Or12Or16" {
	0x0008,
	0x000a,
	0x000c,
	0x0010
}

BinaryValues="BitsAre7Or9Or11Or15" {
	0x0007,
	0x0009,
	0x000b,
	0x000f
}

BinaryValues="BitsAre8Or12To16" {
	0x0008,
	0x000c,
	0x000d,
	0x000e,
	0x000f,
	0x0010
}

BinaryValues="BitsAre7Or11To15" {
	0x0007,
	0x000a,
	0x000b,
	0x000c,
	0x000d,
	0x000e,
	0x000f
}

BinaryValues="BitsAre8Or12Or16" {
	0x0008,
	0x000c,
	0x0010
}

BinaryValues="BitsAre7Or11Or15" {
	0x0007,
	0x000b,
	0x000f
}

BinaryValues="BitsAre6To16" {
	0x0006,
	0x0007,
	0x0008,
	0x0009,
	0x000a,
	0x000b,
	0x000c,
	0x000d,
	0x000e,
	0x000f,
	0x0010
}

BinaryValues="BitsAre5To15" {
	0x0005,
	0x0006,
	0x0007,
	0x0008,
	0x0009,
	0x000a,
	0x000b,
	0x000c,
	0x000d,
	0x000e,
	0x000f
}

BinaryValues="BitsAre8To15" {
	0x0008,
	0x0009,
	0x000A,
	0x000B,
	0x000C,
	0x000D,
	0x000E,
	0x000F
}

BinaryValues="BitsAre7To15" {
	0x0007,
	0x0008,
	0x0009,
	0x000A,
	0x000B,
	0x000C,
	0x000D,
	0x000E,
	0x000F
}

BinaryValues="BitsAre8To16" {
	0x0008,
	0x0009,
	0x000A,
	0x000B,
	0x000C,
	0x000D,
	0x000E,
	0x000F,
	0x0010
}

BinaryValues="BitsAre9To16" {
	0x0009,
	0x000A,
	0x000B,
	0x000C,
	0x000D,
	0x000E,
	0x000F,
	0x0010
}

BinaryValues="BitsAre10To16" {
	0x000A,
	0x000B,
	0x000C,
	0x000D,
	0x000E,
	0x000F,
	0x0010
}

BinaryValues="BitsAre12To16" {
	0x000C,
	0x000D,
	0x000E,
	0x000F,
	0x0010
}

BinaryValues="BitsAre11To15" {
	0x000B,
	0x000C,
	0x000D,
	0x000E,
	0x000F
}

BinaryValues="BitsAre1Or8" {
	0x0001,
	0x0008
}

BinaryValues="BitsAre0Or7" {
	0x0001,
	0x0007
}

BinaryValues="CurveDataValueRepresentation" {
	0x0000 = Unsigned Short(US),
	0x0001 = Signed Short(SS),
	0x0002 = Floating Point Single(FL),
	0x0003 = Floating Point Double(FD),
	0x0004 = Signed Long(SL)
}

BinaryValues="CurveDataDescriptor" {
	0x0000 = Interval Spacing,
	0x0001 = Values
}

BinaryValues="AudioType" {
	0x0000 = None,
	0x0001 = Doppler Audio,
	0x0002 = Voice Audio,
	0x0003 = Phono Audio
}

BinaryValues="AudioSampleFormat" {
	0x0000 = 16 Bit Signed LSB First Interleaved Per Channel,
	0x0001 = 8 bit Signed Interleaved Per Channel
}

BinaryValues="NumberOfChannels" {
	0x0000 = Mono,
	0x0001 = Stereo
}

BinaryValues="UltrasoundColorDataPresent" {
	0x0000 = Ultrasound color data not present in image,
	0x0001 = Ultrasound color data is present in image
}

BinaryValues="PreferredPlaybackSequencing" {
	0x0000 = Looping,
	0x0001 = Sweeping
}

BinaryValues="PreferredPlaybackSequencingForHangingProtocol" {
	0x0000 = Looping,
	0x0001 = Sweeping
	0x0002 = Stop
}

BinaryValues="PreferredPlaybackSequencingForStructuredDisplay" {
	0x0000 = Looping,
	0x0001 = Sweeping
	0x0002 = Stop
}

BinaryValues="FileSetConsistencyFlag" {
	0x0000 = No known inconsistencies,
	0xffff = Inconsistencies may be present
}

BinaryValues="RecordInUseFlag" {
	0x0000 = Record is inactive,
	0xffff = Record is in use
}

BinaryValues="PixelIntensityRelationshipSign" {
	0x0001 = Lower pixel values correspond to lower X-Ray intensity,
	0xffff = Higher pixel values correspond to lower X-Ray intensity
}

BinaryValues="AllPossibleOverlayGroups" {
	0x6000,
	0x6002,
	0x6004,
	0x6006,
	0x6008,
	0x600a,
	0x600c,
	0x600e,
	0x6010,
	0x6012,
	0x6014,
	0x6016,
	0x6018,
	0x601a,
	0x601c,
	0x601e
}

BinaryValues="Two" {
	2
}

BinaryValues="ImageRotationValues" {
	0,
	90,
	180,
	270
}

BinaryValues="ExposureProgram" {
	0 = Not defined,
	1 = Manual,
	2 = Normal program,
	3 = Aperture priority,
	4 = Shutter priority,
	5 = Creative program,
	6 = Action program,
	7 = Portrait mode,
	8 = Landscape mode
}

BinaryValues="SensitivityType" {
	0 = Unknown,
	1 = Standard output sensitivity,
	2 = Recommended exposure index,
	3 = ISO speed,
	4 = Standard output sensitivity and recommended exposure index,
	5 = Standard output sensitivity and ISO speed,
	6 = Recommended exposure index and ISO speed,
	7 = Standard output sensitivity and recommended exposure index and ISO speed
}

BinaryValues="MeteringMode" {
	0 = Unknown,
	1 = Average,
	2 = CenterWeightedAverage,
	3 = Spot,
	4 = MultiSpot,
	5 = Pattern,
	6 = Partial,
	255 = Other
}

BinaryValues="LightSource" {
	0 = Unknown,
	1 = Daylight,
	2 = Fluorescent,
	3 = Tungsten (incandescent light),
	4 = Flash,
	9 = Fine weather,
	10 = Cloudy weather,
	11 = Shade,
	12 = Daylight fluorescent (D 5700 - 7100K),
	13 = Day white fluorescent (N 4600 - 5500K),
	14 = Cool white fluorescent (W 3800 - 4500K),
	15 = White fluorescent (WW 3250 - 3800K),
	16 = Warm white fluorescent (L 2600 - 3250K),
	17 = Standard light A,
	18 = Standard light B,
	19 = Standard light C,
	20 = D55,
	21 = D65,
	22 = D75,
	23 = D50,
	24 = ISO studio tungsten,
	255 = other light source
}

BinaryValues="FlashFiringStatus" {
	0 = Flash did not fire,
	1 = Flash fired
}

BinaryValues="FlashReturnStatus" {
	0 = No strobe return detection function,
	1 = Reserved,
	2 = Strobe return light not detected,
	3 = Strobe return light detected
}

BinaryValues="FlashMode" {
	0 = Unknown,
	1 = Compulsory flash firing,
	2 = Compulsory flash suppression,
	3 = Auto mode
}

BinaryValues="FlashFunctionPresent" {
	0 = Flash function present,
	1 = No flash function
}

BinaryValues="FlashRedEyeMode" {
	0 = No red-eye reduction mode or unknown,
	1 = Red-eye reduction supported
}

BinaryValues="SensingMethod" {
	1 = Not defined,
	2 = One-chip color area sensor,
	3 = Two-chip color area sensor,
	4 = Three-chip color area sensor,
	5 = Color sequential area sensor,
	7 = Trilinear sensor,
	8 = Color sequential linear sensor
}

BinaryValues="FileSource" {
	0 = others,
	1 = scanner of transparent type,
	2 = scanner of reflex type,
	3 = digital still camera
}

BinaryValues="SceneType" {
	1 = A directly photographed image
}

BinaryValues="CustomRendered" {
	0 = Normal process,
	1 = Custom process
}

BinaryValues="ExposureMode" {
	0 = Auto exposure,
	1 = Manual exposure,
	2 = Auto bracket
}

BinaryValues="WhiteBalance" {
	0 = Auto white balance,
	1 = Manual white balance
}

BinaryValues="SceneCaptureType" {
	0 = Standard,
	1 = Landscape,
	2 = Portrait,
	3 = Night scene
}

BinaryValues="GainControl" {
	0 = None,
	1 = Low gain up,
	2 = High gain up,
	3 = Low gain down,
	4 = High gain down
}

BinaryValues="Contrast" {
	0 = Normal,
	1 = Soft,
	2 = Hard
}

BinaryValues="Saturation" {
	0 = Normal,
	1 = Low saturation,
	2 = High saturation
}

BinaryValues="Sharpness" {
	0 = Normal,
	1 = Soft,
	2 = Hard
}

BinaryValues="SubjectDistanceRange" {
	0 = unknown,
	1 = Macro,
	2 = Close view,
	3 = Distant view
}

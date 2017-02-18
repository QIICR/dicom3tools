StringValues="VLEndoscopyModality" {
	ES
}

StringValues="VLMicroscopyModality" {
	GM
}

StringValues="VLSlideCoordinatesMicroscopyModality" {
	SM
}

StringValues="VLWholeSlideMicroscopyModality" {
	SM
}

StringValues="VLPhotographyModality" {
	XC
}

StringValues="VLImageType3" {
	STEREO L,
	STEREO R,
	***EMPTYVALUE***
}

StringValues="PhotometricInterpretationMonochrome2OrRGBorYBRFULL422orYBRPARTIAL420orYBRRCTorYBRICT" {
	MONOCHROME2,
	YBR_PARTIAL_420,
	YBR_FULL_422,
	RGB,
	YBR_RCT,
	YBR_ICT
}

StringValues="PhotometricInterpretationMonochrome2OrRGBorYBRFULL422orYBRRCTorYBRICT" {
	MONOCHROME2,
	YBR_FULL_422,
	RGB,
	YBR_RCT,
	YBR_ICT
}

StringValues="AcquisitionContextValueTypes" {
	TEXT,
	NUM,
	CODE,
	DATE,
	TIME,
	PNAME
}

StringValues="OphthalmologyModality" {
	OP
}

StringValues="OphthalmologyImageType2" {
	PRIMARY
}

StringValues="OphthalmologyImageType3IfDerived" {
	MONTAGE
}

StringValues="OphthalmologyImageType4" {
	COLOR,
	REDFREE,
	RED,
	BLUE,
	FA,
	ICG
}

StringValues="OphthalmologyImageLaterality"	{
	R = Right,
	L = Left,
	B = Both left and right
}

StringValues="OphthalmicRefractiveMeasurementLaterality"	{
	R = Right,
	L = Left,
	B = Both left and right
}

StringValues="OphthalmologyDetectorType"	{
	CCD,
	CMOS
}

StringValues="StereometricModality" {
	SMR
}

StringValues="OphthalmicTomographyModality" {
	OPT
}

StringValues="OphthalmicTomographyDetectorType" {
	CCD = Charge Coupled Device,
	CMOS = Complementary Metal Oxide Semiconductor,
	PHOTO = Photodetector,
	INT = Interferometer
}

StringValues="OphthalmicImageOrientation" {
	LINEAR,
	NONLINEAR,
	TRANSVERSE
}


StringValues="WholeSlideImageType1" {
	ORIGINAL,
	DERIVED
}

StringValues="WholeSlideImageType3" {
	LOCALIZER,
	VOLUME,
	LABEL
}

StringValues="WholeSlideImageType4" {
	NONE,
	RESAMPLED
}

StringValues="VolumetricPropertiesVolume" {
	VOLUME
}

StringValues="WholeSlideFocusMethod" {
	AUTO,
	MANUAL
}

StringValues="LocalizerDCMCodeValue" {
	121311
}

StringValues="LensometryModality" {
	LEN
}

StringValues="AutorefractionModality" {
	AR
}

StringValues="SubjectiveRefractionModality" {
	SRF
}

StringValues="VisualAcuityModality" {
	VA
}

StringValues="OphthalmicAxialMeasurementsModality" {
	OAM
}

StringValues="IntraocularLensCalculationsModality" {
	IOL
}

StringValues="KeratometryModality" {
	KER
}

StringValues="LensSegmentType" {
	PROGRESSIVE,
	NONPROGRESSIVE
}

StringValues="ViewingDistanceType" {
	DISTANCE,
	NEAR,
	INTERMEDIATE,
	OTHER
}

StringValues="VisualAcuityMeasurementsBackgroundColor" {
	RED,
	GREEN,
	WHITE,
	REDGREENSPLIT
}

StringValues="Optotype" {
	LETTERS,
	NUMBERS,
	PICTURES,
	TUMBLING E,
	LANDOLT C
}

StringValues="OptotypePresentation" {
	SINGLE,
	MULTIPLE
}

StringValues="OphthalmicAxialMeasurementsDeviceType" {
	ULTRASOUND,
	OPTICAL
}

StringValues="OphthalmicAxialLengthMeasurementsType" {
	TOTAL LENGTH = the total axial length was taken withone measurement,
	LENGTH SUMMATION = a summation of segmental lengthsthat determine the total axial length,
	SEGMENTAL LENGTH = a segmental axial length
}

StringValues="OphthalmicAxialMeasurementsObserverType" {
	PSN = Person; manually selected,
	DEV = Device; automatically selected
}

StringValues="OphthalmicAxialMeasurementsQualityImageSOPClassUIDs" {
	1.2.840.10008.5.1.4.1.1.7.2 = Multi-frame Grayscale ByteSecondary Capture Image Storage,
	1.2.840.10008.5.1.4.1.1.7.4 = Multi-frame True Color SecondaryCapture Image Storage
}



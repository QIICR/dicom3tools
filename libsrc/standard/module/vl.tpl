Module="VLImage"
	Name="ImageType"									Type="1"	ValueSelector="0"	StringEnumValues="ImageType1"
	Verify="ImageType"									Type="1"	ValueSelector="1"	StringEnumValues="ImageType2"
	Verify="ImageType"									Type="1"	ValueSelector="2"	StringEnumValues="VLImageType3"
	Name="PhotometricInterpretation"					Type="1"	StringEnumValues="PhotometricInterpretationMonochrome2OrRGBorYBRFULL422orYBRPARTIAL420orYBRRCTorYBRICT"

	Verify="PhotometricInterpretation"				Condition="UncompressedTransferSyntaxAndThreeSamples"					StringEnumValues="PhotometricInterpretationRGB"
	Verify="PhotometricInterpretation"				Condition="JPEGLSLosslessTransferSyntaxAndThreeSamples"					StringEnumValues="PhotometricInterpretationRGB"
	Verify="PhotometricInterpretation"				Condition="JPEG2000TransferSyntaxAndThreeSamples"						StringEnumValues="PhotometricInterpretationYBRRCTOrICT"
	Verify="PhotometricInterpretation"				Condition="JPEG2000LosslessTransferSyntaxAndThreeSamples"				StringEnumValues="PhotometricInterpretationYBRRCT"
	Verify="PhotometricInterpretation"				Condition="MPEG2TransferSyntax"											StringEnumValues="PhotometricInterpretationYBRPartial420"	# regardless of number of samples (required to be 3 by PS 3.5)
	Verify="PhotometricInterpretation"				Condition="JPEGLossyTransferSyntaxAndThreeSamples"						StringEnumValues="PhotometricInterpretationYBRFull422"

	Name="BitsAllocated"								Type="1"	BinaryEnumValues="BitsAre8"
	Name="BitsStored"									Type="1"	BinaryEnumValues="BitsAre8"
	Name="HighBit"										Type="1"	BinaryEnumValues="BitsAre7"
	Name="PixelRepresentation"							Type="1"	BinaryEnumValues="PixelRepresentationUnsigned"
	Name="SamplesPerPixel"								Type="1"	BinaryEnumValues="SamplesPerPixelIsOneOrThree"
	Verify="SamplesPerPixel"										Condition="PhotometricInterpretationNeedsOneSample"	BinaryEnumValues="One"
	Verify="SamplesPerPixel"										Condition="PhotometricInterpretationNeedsThreeSamples"	BinaryEnumValues="Three"
	Name="PlanarConfiguration"							Type="1C"	BinaryEnumValues="PlanarConfigurationIsColorByPixel"	Condition="SamplesPerPixelGreaterThanOne"
	Name="ContentTime"									Type="1C"	NoCondition=""	# "if temporally related" ... real world
	Name="LossyImageCompression"						Type="2"	StringEnumValues="LossyImageCompression"
	Sequence="ReferencedImageSequence"					Type="1C"	VM="1-n"	Condition="ImageTypeValue3StereoLOrR" mbpo="true"
		InvokeMacro="ImageSOPInstanceReferenceMacro"
		Sequence="PurposeOfReferenceCodeSequence"		Type="2"	VM="0-1"
			InvokeMacro="CodeSequenceMacro"							DefinedContextID="7201"
		SequenceEnd
	SequenceEnd
	Name="WindowCenter"									Type="3C"	Condition="PhotometricInterpretationIsMonochrome2"
	Name="WindowWidth"									Type="1C"	Condition="WindowCenterPresent" 	NotZeroError=""
	Verify="WindowWidth"											Condition="WindowWidthIsNegative"	ThenErrorMessage="Not permitted to be negative" ShowValueWithMessage="true"
	Name="ImageLaterality"								Type="3"	StringEnumValues="ImageLaterality"
	Sequence="AnatomicRegionSequence"					Type="1C"	VM="1"	Condition="MultiFrameIODAndNotSpecimen" mbpo="true"
		InvokeMacro="CodeSequenceMacro"
		Sequence="AnatomicRegionModifierSequence"		Type="3"	VM="1-n"
			InvokeMacro="CodeSequenceMacro"							BaselineContextID="2"
		SequenceEnd
	SequenceEnd
	InvokeMacro="PrimaryAnatomicStructureMacro"
	Sequence="ChannelDescriptionCodeSequence"			Type="3"	VM="1-3"
		InvokeMacro="CodeSequenceMacro"								BaselineContextID="4206"
	SequenceEnd
	Name="PixelSpacing"									Type="3"	NotZeroError=""
	Name="ImagerPixelSpacing"							Type="3"	NotZeroError=""
ModuleEnd

Module="VLEndoscopicSeriesPseudo"
	Name="Modality"										Type="1"	StringEnumValues="VLEndoscopyModality"
ModuleEnd

Module="VLMicroscopicSeriesPseudo"
	Name="Modality"										Type="1"	StringEnumValues="VLMicroscopyModality"
ModuleEnd

Module="VLSlideCoordinatesMicroscopicSeriesPseudo"
	Name="Modality"										Type="1"	StringEnumValues="VLSlideCoordinatesMicroscopyModality"
ModuleEnd

Module="VLPhotographicSeriesPseudo"
	Name="Modality"										Type="1"	StringEnumValues="VLPhotographyModality"
ModuleEnd

Module="DermoscopyPhotographySeriesPseudo"
	Name="Modality"										Type="1"	StringEnumValues="DermoscopyPhotographyModality"
ModuleEnd

Module="SlideCoordinates"
	Sequence="ImageCenterPointCoordinatesSequence"		Type="2"	VM="0-1"
		Name="XOffsetInSlideCoordinateSystem"			Type="1"
		Name="YOffsetInSlideCoordinateSystem"			Type="1"
		Name="ZOffsetInSlideCoordinateSystem"			Type="2"
	SequenceEnd
ModuleEnd

Module="OphthalmicPhotographySeries"
	Name="Modality"										Type="1"	StringEnumValues="OphthalmologyModality"
ModuleEnd

Module="OphthalmicPhotography8BitImagePseudo"
	Name="BitsAllocated"								Type="1"	BinaryEnumValues="BitsAre8"
	Name="BitsStored"									Type="1"	BinaryEnumValues="BitsAre8"
	Name="HighBit"										Type="1"	BinaryEnumValues="BitsAre7"
ModuleEnd

Module="OphthalmicPhotography16BitImagePseudo"
	Name="BitsAllocated"								Type="1"	BinaryEnumValues="BitsAre16"
	Name="BitsStored"									Type="1"	BinaryEnumValues="BitsAre16"
	Name="HighBit"										Type="1"	BinaryEnumValues="BitsAre15"
ModuleEnd

Module="OphthalmicPhotographyImage"
	Name="ImageType"									Type="1"	ValueSelector="0"	StringEnumValues="ImageType1"
	Verify="ImageType"									Type="1"	ValueSelector="1"	StringEnumValues="OphthalmologyImageType2"
	
	Verify="ImageType"									Type="1"	Condition="ImageTypeValue1Derived" ValueSelector="2"	StringDefinedTerms="OphthalmologyImageType3IfDerived"
	Verify="ImageType"												Condition="ImageTypeValue1DerivedAndImageTypeValue3MissingOrEmpty"	ThenErrorMessage="A value for Value 3 is required for DERIVED images"
	Verify="ImageType"												Condition="ImageTypeValue1NotDerivedAndImageTypeValueNotMissingOrEmpty"	ThenErrorMessage="A value for Value 3 may not be present for non-DERIVED images"
	
	Verify="ImageType"									Type="1"	ValueSelector="3"	StringDefinedTerms="OphthalmologyImageType4"

	Name="InstanceNumber"								Type="1"
	Name="SamplesPerPixel"								Type="1"	BinaryEnumValues="SamplesPerPixelIsOneOrThree"
	Verify="SamplesPerPixel"										Condition="PhotometricInterpretationNeedsOneSample"	BinaryEnumValues="One"
	Verify="SamplesPerPixel"										Condition="PhotometricInterpretationNeedsThreeSamples"	BinaryEnumValues="Three"
	Name="SamplesPerPixelUsed"							Type="1C"	NoCondition="" BinaryEnumValues="SamplesPerPixelUsedIsTwo"		# condition is real world
	Name="PhotometricInterpretation"					Type="1"	StringEnumValues="PhotometricInterpretationMonochrome2OrRGBorYBRFULL422orYBRPARTIAL420orYBRRCTorYBRICT"

	Verify="PhotometricInterpretation"				Condition="UncompressedTransferSyntaxAndThreeSamples"					StringEnumValues="PhotometricInterpretationRGB"
	Verify="PhotometricInterpretation"				Condition="JPEGLSLosslessTransferSyntaxAndThreeSamples"					StringEnumValues="PhotometricInterpretationRGB"
	Verify="PhotometricInterpretation"				Condition="JPEG2000TransferSyntaxAndThreeSamples"						StringEnumValues="PhotometricInterpretationYBRRCTOrICT"
	Verify="PhotometricInterpretation"				Condition="JPEG2000LosslessTransferSyntaxAndThreeSamples"				StringEnumValues="PhotometricInterpretationYBRRCT"
	Verify="PhotometricInterpretation"				Condition="MPEG2TransferSyntax"											StringEnumValues="PhotometricInterpretationYBRPartial420"	# regardless of number of samples (required to be 3 by PS 3.5)
	Verify="PhotometricInterpretation"				Condition="JPEGLossyTransferSyntaxAndThreeSamples"						StringEnumValues="PhotometricInterpretationYBRFull422"

	Name="PixelRepresentation"							Type="1"	BinaryEnumValues="PixelRepresentationUnsigned"
	Name="PlanarConfiguration"							Type="1C"	BinaryEnumValues="PlanarConfigurationIsColorByPixel"	Condition="SamplesPerPixelGreaterThanOne"
	Name="PixelSpacing"									Type="1C"	NotZeroError=""	NoCondition=""		# too hard to check code in Acquisition Device Type Code Sequence :(
	Name="ContentDate"									Type="1"
	Name="ContentTime"									Type="1"
	Name="AcquisitionDateTime"							Type="1C"	Condition="ImageTypeValue1Original" mbpo="true"
	Sequence="SourceImageSequence"						Type="2C"	VM="0-n"	Condition="ImageTypeValue1Derived"
		InvokeMacro="ImageSOPInstanceReferenceMacro"
		Sequence="PurposeOfReferenceCodeSequence"		Type="1"	VM="1"
			InvokeMacro="CodeSequenceMacro"							DefinedContextID="7202"
		SequenceEnd
	SequenceEnd
	Name="LossyImageCompression"						Type="1"	StringEnumValues="LossyImageCompression"
	Name="LossyImageCompressionRatio"					Type="1C"	Condition="LossyImageCompressionIs01"	NotZeroError=""
	Name="LossyImageCompressionMethod"					Type="1C"	StringDefinedTerms="LossyImageCompressionMethod"	Condition="LossyImageCompressionIs01"
	Verify="LossyImageCompressionMethod"							Condition="LossyImageCompressionMethodInconsistentWithTransferSyntax"	ThenWarningMessage="method inconsistent with Transfer Syntax" ShowValueWithMessage="true"
	Name="PresentationLUTShape"							Type="1C"	Condition="PhotometricInterpretationIsMonochrome2"	StringEnumValues="IdentityPresentationLUTShape"
	Name="CalibrationImage"								Type="3"	StringEnumValues="YesNoFull"
	Name="BurnedInAnnotation"							Type="1"	StringEnumValues="YesNoFull"
	Name="RecognizableVisualFeatures"					Type="3"	StringEnumValues="YesNoFull"
ModuleEnd

Module="OphthalmicPhotographicParameters"
	Sequence="AcquisitionDeviceTypeCodeSequence"		Type="1"	VM="1"
		InvokeMacro="CodeSequenceMacro"								BaselineContextID="4202"
	SequenceEnd
	Sequence="IlluminationTypeCodeSequence"				Type="2"	VM="0-1"
		InvokeMacro="CodeSequenceMacro"								BaselineContextID="4203"
	SequenceEnd
	Sequence="LightPathFilterTypeStackCodeSequence"		Type="2"	VM="0-n"
		InvokeMacro="CodeSequenceMacro"								BaselineContextID="4204"
	SequenceEnd
	Name="LightPathFilterPassThroughWavelength"			Type="3"
	Name="LightPathFilterPassBand"						Type="3"
	Sequence="ImagePathFilterTypeStackCodeSequence"		Type="2"	VM="0-n"
		InvokeMacro="CodeSequenceMacro"								BaselineContextID="4204"
	SequenceEnd
	Name="ImagePathFilterPassThroughWavelength"			Type="3"
	Name="ImagePathFilterPassBand"						Type="3"
	Sequence="LensesCodeSequence"						Type="2"	VM="0-n"
		InvokeMacro="CodeSequenceMacro"								BaselineContextID="4205"
	SequenceEnd
	Name="DetectorType"									Type="2"	StringDefinedTerms="OphthalmologyDetectorType"
	Sequence="ChannelDescriptionCodeSequence"			Type="1C"	VM="1-3"	NoCondition=""
		InvokeMacro="CodeSequenceMacro"								BaselineContextID="4206"
	SequenceEnd
	Name="CameraAngleOfView"							Type="3"
ModuleEnd

DefineMacro="OphthalmicAcquisitionParametersMacro" InformationEntity="Image"
	Sequence="RefractiveStateSequence"					Type="2"	VM="0-1"
		Name="SphericalLensPower"						Type="1"	NotZeroWarning=""
		Name="CylinderLensPower"						Type="1"	NotZeroWarning=""
		Name="CylinderAxis"								Type="1"	NotZeroWarning=""
	SequenceEnd
	Name="EmmetropicMagnification"						Type="2"	NotZeroWarning=""
	Name="IntraOcularPressure"							Type="2"	NotZeroWarning=""
	Name="PupilDilated"									Type="2"	StringEnumValues="YesNoFull"
	Sequence="MydriaticAgentSequence"					Type="2C"	VM="0-n"	Condition="PupilDilatedIsYes"
		Sequence="MydriaticAgentCodeSequence"			Type="1"	VM="1"
			InvokeMacro="CodeSequenceMacro"							BaselineContextID="4208"
		SequenceEnd
		Name="MydriaticAgentConcentration"				Type="3"	NotZeroWarning=""
		Sequence="MydriaticAgentConcentrationUnitsSequence"	Type="1C"	VM="1" Condition="MydriaticAgentConcentrationIsPresent"
			InvokeMacro="CodeSequenceMacro"							BaselineContextID="3082"
		SequenceEnd
	SequenceEnd
	Name="DegreeOfDilation"								Type="2C"	Condition="PupilDilatedIsYes"
MacroEnd

Module="OphthalmicPhotographyAcquisitionParameters"
	Name="PatientEyeMovementCommanded"					Type="2"	StringEnumValues="YesNoFull"
	Sequence="PatientEyeMovementCommandCodeSequence"	Type="1C"	VM="1"	Condition="PatientEyeMovementCommandedIsYes"
		InvokeMacro="CodeSequenceMacro"								BaselineContextID="4201"
	SequenceEnd
	Name="HorizontalFieldOfView"						Type="2"	NotZeroWarning=""
	InvokeMacro="OphthalmicAcquisitionParametersMacro"
ModuleEnd

Module="OcularRegionImaged"
	Name="ImageLaterality"								Type="1"	StringEnumValues="OphthalmologyImageLaterality"
	Sequence="RelativeImagePositionCodeSequence"		Type="3"	VM="1"
		InvokeMacro="CodeSequenceMacro"								BaselineContextID="4207"
	SequenceEnd
	Name="OphthalmicAnatomicReferencePointXCoordinate"	Type="2C"	Condition="OphthalmicVolumetricPropertiesFlagIsYes" mbpo="true"
	Name="OphthalmicAnatomicReferencePointYCoordinate"	Type="2C"	Condition="OphthalmicVolumetricPropertiesFlagIsYes" mbpo="true"
	InvokeMacro="GeneralAnatomyMandatoryMacro"
ModuleEnd

Module="StereometricSeries"
	Name="Modality"										Type="1"	StringEnumValues="StereometricModality"
ModuleEnd

Module="StereometricRelationship"
	Sequence="StereoPairsSequence"						Type="1"	VM="1-n"
		Name="StereoBaselineAngle"						Type="3"
		Name="StereoBaselineDisplacement"				Type="3"
		Name="StereoHorizontalPixelOffset"				Type="3"
		Name="StereoVerticalPixelOffset"				Type="3"
		Name="StereoRotation"							Type="3"
		Sequence="LeftImageSequence"					Type="1"	VM="1"
			InvokeMacro="ImageSOPInstanceReferenceMacro"
		SequenceEnd
		Sequence="RightImageSequence"					Type="1"	VM="1"
			InvokeMacro="ImageSOPInstanceReferenceMacro"
		SequenceEnd
	SequenceEnd
ModuleEnd

Module="OphthalmicTomographySeries"
	Name="Modality"										Type="1"	StringEnumValues="OphthalmicTomographyModality"
	Name="SeriesNumber"									Type="1"
	Sequence="ReferencedPerformedProcedureStepSequence"	Type="1C"	VM="0-1"	Condition="SeriesNeedReferencedPerformedProcedureStepSequence"
		InvokeMacro="SOPInstanceReferenceMacro"
	SequenceEnd
ModuleEnd

Module="OphthalmicTomographyImage"
	Name="OphthalmicVolumetricPropertiesFlag"			Type="1C"	NoCondition=""
	Name="ImageType"									Type="1"	ValueSelector="0"	StringEnumValues="ImageType1"
	Verify="ImageType"									Type="1"	ValueSelector="1"	StringEnumValues="ImageType2"
	Name="SamplesPerPixel"								Type="1"	BinaryEnumValues="SamplesPerPixelIsOne"
	Name="AcquisitionDateTime"							Type="1"
	Name="AcquisitionDuration"							Type="1C"	Condition="ImageTypeValue1Original" mbpo="true"
	Name="AcquisitionNumber"							Type="1"
	Name="PhotometricInterpretation"					Type="1"	StringEnumValues="PhotometricInterpretationMonochrome2"
	Name="PixelRepresentation"							Type="1"	BinaryEnumValues="PixelRepresentationUnsigned"
	Name="BitsAllocated"								Type="1"	BinaryEnumValues="BitsAre8Or16"
	Name="BitsStored"									Type="1"	BinaryEnumValues="BitsAre8Or12Or16"
	Name="HighBit"										Type="1"	BinaryEnumValues="BitsAre7Or11Or15"
	Name="PresentationLUTShape"							Type="1"	StringEnumValues="IdentityPresentationLUTShape"
	Name="LossyImageCompression"						Type="1"	StringEnumValues="LossyImageCompression"
	Name="LossyImageCompressionRatio"					Type="1C"	Condition="LossyImageCompressionIs01"	NotZeroError=""
	Name="LossyImageCompressionMethod"					Type="1C"	StringDefinedTerms="LossyImageCompressionMethod"	Condition="LossyImageCompressionIs01"
	Verify="LossyImageCompressionMethod"							Condition="LossyImageCompressionMethodInconsistentWithTransferSyntax"	ThenWarningMessage="method inconsistent with Transfer Syntax" ShowValueWithMessage="true"
	Name="BurnedInAnnotation"							Type="1"	StringEnumValues="NoFull"
	Name="RecognizableVisualFeatures"					Type="3"	StringEnumValues="YesNoFull"
	Name="ConcatenationFrameOffsetNumber"				Type="1"	BinaryEnumValues="Zero"
	Name="InConcatenationNumber"						Type="1"	BinaryEnumValues="One"
	Name="InConcatenationTotalNumber"					Type="1"	BinaryEnumValues="One"
	Name="ImageComments"								Type="3"
ModuleEnd

Module="OphthalmicTomographyAcquisitionParameters"
	Name="AxialLengthOfTheEye"							Type="2"	NotZeroWarning=""
	Name="HorizontalFieldOfView"						Type="2"	NotZeroWarning=""
	InvokeMacro="OphthalmicAcquisitionParametersMacro"
ModuleEnd

Module="OphthalmicTomographyParameters"
	Sequence="AcquisitionDeviceTypeCodeSequence"		Type="1"	VM="1"
		InvokeMacro="CodeSequenceMacro"								BaselineContextID="4210"
	SequenceEnd
	Sequence="LightPathFilterTypeStackCodeSequence"		Type="2"	VM="0-n"
		InvokeMacro="CodeSequenceMacro"								BaselineContextID="4204"
	SequenceEnd
	Name="LightPathFilterPassThroughWavelength"			Type="3"
	Name="LightPathFilterPassBand"						Type="3"
	Name="DetectorType"									Type="1"	StringDefinedTerms="OphthalmicTomographyDetectorType"
	Sequence="ScanPatternTypeCodeSequence"				Type="3"	VM="1"
		InvokeMacro="CodeSequenceMacro"								BaselineContextID="4272"
	SequenceEnd
	Name="IlluminationWaveLength"						Type="1C"	Condition="AcquisitionDeviceTypeCodeSequenceIsOpticalCoherenceTomographyScanner" mbpo="true"
	Name="IlluminationPower"							Type="1C"	Condition="AcquisitionDeviceTypeCodeSequenceIsOpticalCoherenceTomographyScanner" mbpo="true"
	Name="IlluminationBandwidth"						Type="1C"	Condition="AcquisitionDeviceTypeCodeSequenceIsOpticalCoherenceTomographyScanner" mbpo="true"
	Name="DepthSpatialResolution"						Type="1C"	Condition="AcquisitionDeviceTypeCodeSequenceIsOpticalCoherenceTomographyScanner" mbpo="true"
	Name="MaximumDepthDistortion"						Type="1C"	Condition="AcquisitionDeviceTypeCodeSequenceIsOpticalCoherenceTomographyScanner" mbpo="true"
	Name="AlongScanSpatialResolution"					Type="1C"	Condition="AcquisitionDeviceTypeCodeSequenceIsOpticalCoherenceTomographyScanner" mbpo="true"
	Name="MaximumAlongScanDistortion"					Type="1C"	Condition="AcquisitionDeviceTypeCodeSequenceIsOpticalCoherenceTomographyScanner" mbpo="true"
	Name="AcrossScanSpatialResolution"					Type="1C"	Condition="AcquisitionDeviceTypeCodeSequenceIsOpticalCoherenceTomographyScanner" mbpo="true"
	Name="MaximumAcrossScanDistortion"					Type="1C"	Condition="AcquisitionDeviceTypeCodeSequenceIsOpticalCoherenceTomographyScanner" mbpo="true"
ModuleEnd

DefineMacro="OphthalmicFrameLocationMacro" InformationEntity="Frame"
	Sequence="OphthalmicFrameLocationSequence"			Type="1"	VM="1-n"
		InvokeMacro="ImageSOPInstanceReferenceMacro"
		Sequence="PurposeOfReferenceCodeSequence"		Type="3"	VM="1"
			InvokeMacro="CodeSequenceMacro"
			Name="CodeValue"							Type="1"	VM="1" StringDefinedTerms="LocalizerDCMCodeValue"		# this is a bit hokey, but cannot parametrize invocation yet, and macro as nested as if modules not inline :(
		SequenceEnd
		Name="ReferenceCoordinates"						Type="1"
		Name="DepthOfTransverseImage"					Type="2C"	Condition="OphthalmicImageOrientationIsTransverse"
		Name="OphthalmicImageOrientation"				Type="1"	StringEnumValues="OphthalmicImageOrientation"
	SequenceEnd
MacroEnd

Module="WideFieldOphthalmicPhotographyStereographicProjection"
	InvokeMacro="GeneralAnatomyMandatoryMacro"
	Sequence="TransformationAlgorithmSequence"			Type="1"	VM="1"
		InvokeMacro="AlgorithmIdentificationMacro"
	SequenceEnd
	Name="OphthalmicAxialLength"						Type="1"
	Name="OphthalmicAxialLengthMethod"					Type="1"	StringEnumValues="OphthalmicAxialLengthMethod"
	Name="XCoordinatesCenterPixelViewAngle"				Type="1"
	Name="YCoordinatesCenterPixelViewAngle"				Type="1"
	Name="OphthalmicFOV"								Type="3"
ModuleEnd

Module="WideFieldOphthalmicPhotography3DCoordinates"
	InvokeMacro="GeneralAnatomyMandatoryMacro"
	Sequence="TransformationMethodCodeSequence"				Type="1"	VM="1"
		InvokeMacro="CodeSequenceMacro"									BaselineContextID="4245"
	SequenceEnd
	Sequence="TransformationAlgorithmSequence"				Type="1"	VM="1"
		InvokeMacro="AlgorithmIdentificationMacro"
	SequenceEnd
	Name="OphthalmicAxialLength"							Type="1"
	Name="OphthalmicAxialLengthMethod"						Type="1"	StringEnumValues="OphthalmicAxialLengthMethod"
	Name="OphthalmicFOV"									Type="3"
	Sequence="TwoDimensionalToThreeDimensionalMapSequence"	Type="1"	VM="1"
		Name="ReferencedFrameNumber"						Type="1"
		Name="NumberOfMapPoints"							Type="1"
		Name="TwoDimensionalToThreeDimensionalMapData"		Type="1"
	SequenceEnd
ModuleEnd

Module="WideFieldOphthalmicPhotographyQualityRating"
	Sequence="WideFieldOphthalmicPhotographyQualityRatingSequence"			Type="1"	VM="1"
		InvokeMacro="NumericValueMacro"
		Sequence="WideFieldOphthalmicPhotographyQualityThresholdSequence"	Type="1"	VM="1"
			Name="WideFieldOphthalmicPhotographyThresholdQualityRating"		Type="1"
		SequenceEnd
		InvokeMacro="AlgorithmIdentificationMacro"
	SequenceEnd
ModuleEnd

Module="OphthalmicOpticalCoherenceTomographyEnFaceImage"
	Name="ImageType"									Type="1"	ValueSelector="0"	StringEnumValues="ImageType1DerivedOnly"
	Verify="ImageType"									Type="1"	ValueSelector="1"	StringEnumValues="ImageType2PrimaryOnly"
	Verify="ImageType"									Type="1"	ValueSelector="2"	StringEnumValues="ImageType3MontageOnly"
	Name="InstanceNumber"								Type="1"
	Name="BitsAllocated"								Type="1"	BinaryEnumValues="BitsAre8Or16"
	Name="BitsStored"									Type="1"	BinaryEnumValues="BitsAre8Or12Or16"
	Name="HighBit"										Type="1"	BinaryEnumValues="BitsAre7Or11Or15"
	Name="SamplesPerPixel"								Type="1"	BinaryEnumValues="SamplesPerPixelIsOne"
	Name="PhotometricInterpretation"					Type="1"	StringEnumValues="PhotometricInterpretationMonochrome2OrPaletteColor"
	Name="PixelRepresentation"							Type="1"	BinaryEnumValues="PixelRepresentationUnsigned"
	Name="PixelSpacing"									Type="1"
	Name="ContentTime"									Type="1"
	Name="ContentDate"									Type="1"
	Sequence="SourceImageSequence"						Type="3"	VM="1-n"
		InvokeMacro="ImageSOPInstanceReferenceMacro"
		Sequence="PurposeOfReferenceCodeSequence"		Type="3"	VM="1"
			InvokeMacro="CodeSequenceMacro"							DefinedContextID="7202"
		SequenceEnd
	SequenceEnd
	Sequence="DerivationAlgorithmSequence"				Type="3"	VM="1"
		InvokeMacro="AlgorithmIdentificationMacro"
	SequenceEnd
	Sequence="OphthalmicImageTypeCodeSequence"			Type="1"	VM="1"
		InvokeMacro="CodeSequenceMacro"								DefinedContextID="4271"
	SequenceEnd
	Name="OphthalmicImageTypeDescription"				Type="3"
	Name="WindowCenter"									Type="1"
	Name="WindowWidth"									Type="1"	NotZeroError=""
	Verify="WindowWidth"											Condition="WindowWidthIsNegative"	ThenErrorMessage="Not permitted to be negative" ShowValueWithMessage="true"
	Name="OphthalmicFOV"								Type="3"
	Sequence="ReferencedSurfaceMeshIdentificationSequence"	Type="1"	VM="1-n"
		Name="ReferencedSOPInstanceUID"					Type="1"
		Name="ReferencedSurfaceNumber"					Type="1"
		Sequence="SegmentedPropertyTypeCodeSequence"	Type="1"	VM="1"
			InvokeMacro="CodeSequenceMacro"							DefinedContextID="4273"
		SequenceEnd
		Name="SurfaceMeshZPixelOffset"					Type="1"
	SequenceEnd
	Name="OphthalmicAxialLength"						Type="3"
	Name="OphthalmicAxialLengthMethod"					Type="3"	StringEnumValues="OphthalmicAxialLengthMethod"
	Name="LossyImageCompression"						Type="1"	StringEnumValues="LossyImageCompression"
	Name="LossyImageCompressionRatio"					Type="1C"	Condition="LossyImageCompressionIs01"	NotZeroError=""
	Name="LossyImageCompressionMethod"					Type="1C"	StringDefinedTerms="LossyImageCompressionMethod"	Condition="LossyImageCompressionIs01"
	Verify="LossyImageCompressionMethod"							Condition="LossyImageCompressionMethodInconsistentWithTransferSyntax"	ThenWarningMessage="method inconsistent with Transfer Syntax" ShowValueWithMessage="true"
	Name="PresentationLUTShape"							Type="1C"	Condition="PhotometricInterpretationIsMonochrome2"	StringEnumValues="IdentityPresentationLUTShape"
	Name="CalibrationImage"								Type="3"	StringEnumValues="YesNoFull"
	Name="BurnedInAnnotation"							Type="1"	StringEnumValues="NoFull"
	Name="RecognizableVisualFeatures"					Type="1"	StringEnumValues="YesNoFull"
ModuleEnd

Module="OphthalmicOpticalCoherenceTomographyEnFaceImageQualityRating"
	Sequence="OphthalmicEnFaceImageQualityRatingSequence"	Type="1"	VM="1"
		InvokeMacro="NumericValueMacro"
		Name="QualityThreshold"								Type="1"
		InvokeMacro="AlgorithmIdentificationMacro"
	SequenceEnd
ModuleEnd

Module="OphthalmicOpticalCoherenceTomographyBscanVolumeAnalysisImage"
	Name="ImageType"									Type="1"	ValueSelector="0"	StringEnumValues="ImageType1OriginalOnly"
	Verify="ImageType"									Type="1"	ValueSelector="1"	StringEnumValues="ImageType2PrimaryOnly"
	Name="InstanceNumber"								Type="1"
	Name="ContentTime"									Type="1"
	Name="ContentDate"									Type="1"
	Name="BitsAllocated"								Type="1"	BinaryEnumValues="BitsAre8Or16"
	Name="BitsStored"									Type="1"
	Name="HighBit"										Type="1"
	Name="SamplesPerPixel"								Type="1"	BinaryEnumValues="SamplesPerPixelIsOne"
	Name="PhotometricInterpretation"					Type="1"	StringEnumValues="PhotometricInterpretationMonochrome2"
	Name="PixelRepresentation"							Type="1"	BinaryEnumValues="PixelRepresentationUnsigned"
	Name="PresentationLUTShape"							Type="1"	StringEnumValues="IdentityPresentationLUTShape"
	Name="LossyImageCompression"						Type="1"	StringEnumValues="LossyImageCompression"
	Name="LossyImageCompressionRatio"					Type="1C"	Condition="LossyImageCompressionIs01"	NotZeroError=""
	Name="LossyImageCompressionMethod"					Type="1C"	StringDefinedTerms="LossyImageCompressionMethod"	Condition="LossyImageCompressionIs01"
	Verify="LossyImageCompressionMethod"							Condition="LossyImageCompressionMethodInconsistentWithTransferSyntax"	ThenWarningMessage="method inconsistent with Transfer Syntax" ShowValueWithMessage="true"
	Name="BurnedInAnnotation"							Type="1"	StringEnumValues="NoFull"
	Name="RecognizableVisualFeatures"					Type="1"	StringEnumValues="YesNoFull"
	Sequence="AcquisitionMethodAlgorithmSequence"		Type="1"	VM="1"
		InvokeMacro="AlgorithmIdentificationMacro"
	SequenceEnd
	Sequence="OCTBscanAnalysisAcquisitionParametersSequence"	Type="1"	VM="1"
		Sequence="ScanPatternTypeCodeSequence"			Type="1"	VM="1"
			InvokeMacro="CodeSequenceMacro"							DefinedContextID="4272"
		SequenceEnd
		Name="NumberOfBscansPerFrame"					Type="1"
		Name="BscanSlabThickness"						Type="1"
		Name="DistanceBetweenBscanSlabs"				Type="1"
		Name="BscanCycleTime"							Type="1C"	Condition="BscanCycleTimeVectorIsAbsent"
		Name="BscanCycleTimeVector"						Type="1C"	Condition="BscanCycleTimeIsAbsent"
		Name="AscanRate"								Type="3"
		Name="BscanRate"								Type="3"
	SequenceEnd
	Name="ConcatenationFrameOffsetNumber"				Type="1"	BinaryEnumValues="Zero"
	Name="InConcatenationNumber"						Type="1"	BinaryEnumValues="One"
	Name="InConcatenationTotalNumber"					Type="1"	BinaryEnumValues="One"
	Name="ImageComments"								Type="3"
ModuleEnd

Module="OphthalmicTomographyEnFaceSeries"
	Name="Modality"										Type="1"
	Name="SeriesNumber"									Type="1"
	Sequence="ReferencedPerformedProcedureStepSequence"	Type="1C"	VM="1"	Condition="SeriesNeedReferencedPerformedProcedureStepSequence"
		InvokeMacro="SOPInstanceReferenceMacro"
	SequenceEnd
ModuleEnd

Module="OphthalmicTomographyBscanVolumeAnalysisSeries"
	Name="Modality"										Type="1"
	Name="SeriesNumber"									Type="1"
	Sequence="ReferencedPerformedProcedureStepSequence"	Type="1C"	VM="1"	Condition="SeriesNeedReferencedPerformedProcedureStepSequence"
		InvokeMacro="SOPInstanceReferenceMacro"
	SequenceEnd
ModuleEnd

Module="MultiFrameFunctionalGroupsForOphthalmicTomography"
	Sequence="SharedFunctionalGroupsSequence"	Type="1"	VM="1"
		InvokeMacro="PixelMeasuresMacro"			Condition="PixelMeasuresSequenceNotInPerFrameFunctionalGroupSequence"
		InvokeMacro="PlanePositionMacro"			Condition="PlanePositionSequenceNotInPerFrameFunctionalGroupSequence"
		InvokeMacro="PlaneOrientationMacro"			Condition="PlaneOrientationSequenceNotInPerFrameFunctionalGroupSequence"
		InvokeMacro="ReferencedImageMacro"			Condition="ReferencedImageMacroOKInSharedFunctionalGroupSequence"
		InvokeMacro="DerivationImageMacro"			Condition="DerivationImageMacroOKInSharedFunctionalGroupSequence"
		InvokeMacro="FrameAnatomyMacro"				Condition="FrameAnatomySequenceNotInPerFrameFunctionalGroupSequence"
		InvokeMacro="CardiacSynchronizationMacro"	Condition="NeedCardiacSynchronizationMacroInSharedFunctionalGroupSequence"
		InvokeMacro="ContrastBolusUsageMacro"		Condition="NeedContrastBolusUsageMacroInSharedFunctionalGroupSequence"
		InvokeMacro="OphthalmicFrameLocationMacro"	Condition="NeedOphthalmicFrameLocationMacroInSharedFunctionalGroupSequence"
	SequenceEnd

	Sequence="PerFrameFunctionalGroupsSequence"	Type="1"	VM="1-n"
		InvokeMacro="PixelMeasuresMacro"			Condition="PixelMeasuresSequenceNotInSharedFunctionalGroupSequence"
		InvokeMacro="FrameContentMacro"
		InvokeMacro="PlanePositionMacro"			Condition="PlanePositionSequenceNotInSharedFunctionalGroupSequence"
		InvokeMacro="PlaneOrientationMacro"			Condition="PlaneOrientationSequenceNotInSharedFunctionalGroupSequence"
		InvokeMacro="ReferencedImageMacro"			Condition="ReferencedImageMacroOKInPerFrameFunctionalGroupSequence"
		InvokeMacro="DerivationImageMacro"			Condition="DerivationImageMacroOKInPerFrameFunctionalGroupSequence"
		InvokeMacro="FrameAnatomyMacro"				Condition="FrameAnatomySequenceNotInSharedFunctionalGroupSequence"
		InvokeMacro="CardiacSynchronizationMacro"	Condition="NeedCardiacSynchronizationMacroInPerFrameFunctionalGroupSequence"
		InvokeMacro="ContrastBolusUsageMacro"		Condition="NeedContrastBolusUsageMacroInPerFrameFunctionalGroupSequence"
		InvokeMacro="OphthalmicFrameLocationMacro"	Condition="NeedOphthalmicFrameLocationMacroInPerFrameFunctionalGroupSequence"
	SequenceEnd
ModuleEnd

Module="MultiFrameFunctionalGroupsForOphthalmicOpticalCoherenceTomographyBscanVolumeAnalysis"
	Sequence="SharedFunctionalGroupsSequence"	Type="1"	VM="1"
		InvokeMacro="PixelMeasuresMacro"			Condition="PixelMeasuresSequenceNotInPerFrameFunctionalGroupSequence"
		InvokeMacro="PlanePositionMacro"			Condition="PlanePositionSequenceNotInPerFrameFunctionalGroupSequence"
		InvokeMacro="PlaneOrientationMacro"			Condition="PlaneOrientationSequenceNotInPerFrameFunctionalGroupSequence"
		InvokeMacro="ReferencedImageMacro"			Condition="ReferencedImageMacroOKInSharedFunctionalGroupSequence"
		InvokeMacro="FrameAnatomyMacro"				Condition="FrameAnatomySequenceNotInPerFrameFunctionalGroupSequence"
		InvokeMacro="FrameVOILUTWithLUTMacro"		Condition="FrameVOILUTSequenceNotInPerFrameFunctionalGroupSequence"
		InvokeMacro="RealWorldValueMappingMacro"	Condition="RealWorldValueMappingMacroOKInSharedFunctionalGroupSequence"
	SequenceEnd

	Sequence="PerFrameFunctionalGroupsSequence"	Type="1"	VM="1-n"
		InvokeMacro="PixelMeasuresMacro"			Condition="PixelMeasuresSequenceNotInSharedFunctionalGroupSequence"
		InvokeMacro="PlanePositionMacro"			Condition="PlanePositionSequenceNotInSharedFunctionalGroupSequence"
		InvokeMacro="PlaneOrientationMacro"			Condition="PlaneOrientationSequenceNotInSharedFunctionalGroupSequence"
		InvokeMacro="FrameContentMacro"
		InvokeMacro="ReferencedImageMacro"			Condition="ReferencedImageMacroOKInPerFrameFunctionalGroupSequence"
		InvokeMacro="DerivationImageMacro"
		InvokeMacro="FrameAnatomyMacro"				Condition="FrameAnatomySequenceNotInSharedFunctionalGroupSequence"
		InvokeMacro="FrameVOILUTWithLUTMacro"		Condition="FrameVOILUTSequenceNotInSharedFunctionalGroupSequence"
		InvokeMacro="RealWorldValueMappingMacro"	Condition="RealWorldValueMappingMacroOKInPerFrameFunctionalGroupSequence"
	SequenceEnd
ModuleEnd

Module="WholeSlideMicroscopySeries"
	Name="Modality"										Type="1"	StringEnumValues="VLWholeSlideMicroscopyModality"
	Sequence="ReferencedPerformedProcedureStepSequence"	Type="1C"	VM="1"	Condition="SeriesNeedReferencedPerformedProcedureStepSequence"
		InvokeMacro="SOPInstanceReferenceMacro"
	SequenceEnd
ModuleEnd

Module="WholeSlideMicroscopyImage"
	Name="ImageType"									Type="1"	VM="4"
	Verify="ImageType"									Type="1"	ValueSelector="0"	StringEnumValues="WholeSlideImageType1"
	Verify="ImageType"									Type="1"	ValueSelector="1"	StringEnumValues="CommonEnhancedImageAndFrameType2"
	Verify="ImageType"									Type="1"	ValueSelector="2"	StringDefinedTerms="WholeSlideImageType3"
	Verify="ImageType"									Type="1"	ValueSelector="3"	StringDefinedTerms="WholeSlideImageType4"
	Name="ImagedVolumeWidth"							Type="1"	NotZeroError=""
	Name="ImagedVolumeHeight"							Type="1"	NotZeroError=""
	Name="ImagedVolumeDepth"							Type="1"	NotZeroError=""
	Name="TotalPixelMatrixColumns"						Type="1"	NotZeroError=""
	Name="TotalPixelMatrixRows"							Type="1"	NotZeroError=""
	Name="TotalPixelMatrixFocalPlanes"					Type="1C"	Condition="DimensionOrganizationTypeIsTILED_FULL"	mbpo="true"	NotZeroError=""
	Sequence="TotalPixelMatrixOriginSequence"			Type="1"	VM="1"
		Name="XOffsetInSlideCoordinateSystem"			Type="1"
		Name="YOffsetInSlideCoordinateSystem"			Type="1"
	SequenceEnd
	Name="ImageOrientationSlide"						Type="1"
	Name="SamplesPerPixel"								Type="1"	BinaryEnumValues="SamplesPerPixelIsOneOrThree"
	Verify="SamplesPerPixel"										Condition="PhotometricInterpretationNeedsOneSample"	BinaryEnumValues="One"
	Verify="SamplesPerPixel"										Condition="PhotometricInterpretationNeedsThreeSamples"	BinaryEnumValues="Three"
	Name="PhotometricInterpretation"					Type="1"	StringEnumValues="PhotometricInterpretationMonochrome2OrRGBorYBRFULL422orYBRRCTorYBRICT"

	Verify="PhotometricInterpretation"								Condition="UncompressedTransferSyntaxAndOneSample"			StringEnumValues="PhotometricInterpretationMonochrome2"
	# it probably isn't intended, but current text actually prohibits compression of monochrome WSI
	Verify="PhotometricInterpretation"								Condition="UncompressedTransferSyntaxAndThreeSamples"		StringEnumValues="PhotometricInterpretationRGB"
	Verify="PhotometricInterpretation"								Condition="JPEGLSLosslessTransferSyntaxAndThreeSamples"		StringEnumValues="PhotometricInterpretationRGB"
	Verify="PhotometricInterpretation"								Condition="JPEG2000LosslessTransferSyntaxAndThreeSamples"	StringEnumValues="PhotometricInterpretationYBRRCTOrRGB"
	Verify="PhotometricInterpretation"								Condition="JPEG2000TransferSyntaxAndThreeSamples"			StringEnumValues="PhotometricInterpretationYBRRCTOrICTOrRGB"
	Verify="PhotometricInterpretation"								Condition="JPEGLossyTransferSyntaxAndThreeSamples"			StringEnumValues="PhotometricInterpretationYBRFull422OrRGB"

	Name="PlanarConfiguration"							Type="1C"	BinaryEnumValues="PlanarConfigurationIsColorByPixel"	Condition="SamplesPerPixelGreaterThanOne"
	Name="NumberOfFrames"								Type="1"
	Verify="NumberOfFrames"											Condition="ImageTypeValue3LocalizerThumbnailLabelOrOverview"	BinaryEnumValues="One"
	Name="BitsAllocated"								Type="1"	BinaryEnumValues="BitsAre8Or16"
	Name="BitsStored"									Type="1"	BinaryEnumValues="BitsAre8Or16"
	Name="HighBit"										Type="1"	BinaryEnumValues="BitsAre7Or15"
	Name="PixelRepresentation"							Type="1"	BinaryEnumValues="PixelRepresentationUnsigned"
	Name="AcquisitionDateTime"							Type="1"
	Name="AcquisitionDuration"							Type="3"
	Name="LossyImageCompression"						Type="1"	StringEnumValues="LossyImageCompression"
	Name="LossyImageCompressionRatio"					Type="1C"	Condition="LossyImageCompressionIs01"	NotZeroError=""
	Name="LossyImageCompressionMethod"					Type="1C"	StringDefinedTerms="LossyImageCompressionMethod"	Condition="LossyImageCompressionIs01"
	Verify="LossyImageCompressionMethod"							Condition="LossyImageCompressionMethodInconsistentWithTransferSyntax"	ThenWarningMessage="method inconsistent with Transfer Syntax" ShowValueWithMessage="true"
	Name="PresentationLUTShape"							Type="1C"	Condition="PhotometricInterpretationIsMonochrome2"	StringEnumValues="IdentityPresentationLUTShape"
	Name="RescaleSlope"									Type="1C"	Condition="PhotometricInterpretationIsMonochrome2"	BinaryEnumValues="One"
	Name="RescaleIntercept"								Type="1C"	Condition="PhotometricInterpretationIsMonochrome2"	BinaryEnumValues="Zero"
	Name="VolumetricProperties"							Type="1"	StringEnumValues="VolumetricPropertiesVolume"
	Name="SpecimenLabelInImage"							Type="1"	StringEnumValues="YesNoFull"
	Verify="SpecimenLabelInImage"									Condition="SpecimenLabelInImageNotYesForOverviewOrLabel"	ThenErrorMessage="required to be YES for OVERVIEW or LABEL image" ShowValueWithMessage="true"
	Verify="SpecimenLabelInImage"									Condition="SpecimenLabelInImageNotNoForThumbnailOrVolume"	ThenErrorMessage="required to be NO for THUMBNAIL or VOLUME image" ShowValueWithMessage="true"
	Name="BurnedInAnnotation"							Type="1"	StringEnumValues="YesNoFull"
	Name="FocusMethod"									Type="1"	StringEnumValues="WholeSlideFocusMethod"
	Name="ExtendedDepthOfField"							Type="1"	StringEnumValues="YesNoFull"
	Name="NumberOfFocalPlanes"							Type="1C"	Condition="ExtendedDepthOfFieldIsYes"	NotZeroError=""
	Name="DistanceBetweenFocalPlanes"					Type="1C"	Condition="ExtendedDepthOfFieldIsYes"	NotZeroError=""
	Name="AcquisitionDeviceProcessingDescription"		Type="3"
	Name="ConvolutionKernel"							Type="3"
	Name="RecommendedAbsentPixelCIELabValue"			Type="3"
ModuleEnd

Module="OpticalPath"
	Name="NumberOfOpticalPaths"							Type="1C"	Condition="DimensionOrganizationTypeIsTILED_FULL"	mbpo="true"
	Sequence="OpticalPathSequence"						Type="1"	VM="1-n"
		Name="OpticalPathIdentifier"					Type="1"
		Name="OpticalPathDescription"					Type="3"
		Sequence="IlluminatorTypeCodeSequence"			Type="3"	VM="1"
			InvokeMacro="CodeSequenceMacro"
		SequenceEnd
		Name="IlluminationWaveLength"					Type="1C"	Condition="IlluminationColorCodeSequenceNotPresent"	mbpo="true"
		Verify="IlluminationWaveLength"								Condition="IlluminationWaveLengthInvalid"	ThenErrorMessage="Invalid value - required to be greater than zero"
		Sequence="IlluminationColorCodeSequence"		Type="1C"	VM="1"	Condition="IlluminationWaveLengthNotPresent"	mbpo="true"
			InvokeMacro="CodeSequenceMacro"
		SequenceEnd
		Sequence="IlluminationTypeCodeSequence"			Type="1"	VM="1-n"
			InvokeMacro="CodeSequenceMacro"
		SequenceEnd
		Sequence="LightPathFilterTypeStackCodeSequence"	Type="3"	VM="1-n"
			InvokeMacro="CodeSequenceMacro"
		SequenceEnd
		Name="LightPathFilterPassThroughWavelength"		Type="3"	NotZeroWarning=""
		Name="LightPathFilterPassBand"					Type="3"	NotZeroWarning=""	# one of the two value may be zero length, but not zero
		Sequence="ImagePathFilterTypeStackCodeSequence"	Type="3"	VM="1-n"
			InvokeMacro="CodeSequenceMacro"
		SequenceEnd
		Name="ImagePathFilterPassThroughWavelength"		Type="3"	NotZeroWarning=""
		Name="ImagePathFilterPassBand"					Type="3"	NotZeroWarning=""	# one of the two value may be zero length, but not zero
		Sequence="LensesCodeSequence"					Type="3"	VM="1-n"
			InvokeMacro="CodeSequenceMacro"
		SequenceEnd
		Name="CondenserLensPower"						Type="3"	NotZeroWarning=""
		Name="ObjectiveLensPower"						Type="3"	NotZeroWarning=""
		Name="ObjectiveLensNumericalAperture"			Type="3"	NotZeroWarning=""
		Sequence="ChannelDescriptionCodeSequence"		Type="1C"	NoCondition=""	VM="1-3"			# real-world condition but should check number of items matches Samples per Pixel Used or Samples per Pixel :(
			InvokeMacro="CodeSequenceMacro"
		SequenceEnd
		Sequence="PaletteColorLookupTableSequence"		Type="3"	VM="1"
			InvokeMacro="PaletteColorLookupTableMacro"
		SequenceEnd
		Name="ICCProfile"								Type="1C"	Condition="NeedICCProfileInOpticalPathSequence"
		Name="ColorSpace"								Type="3"
	SequenceEnd
ModuleEnd

DefineMacro="PlanePositionSlideMacro" InformationEntity="FunctionalGroup"
	Sequence="PlanePositionSlideSequence"				Type="1"	VM="1"
		Name="ColumnPositionInTotalImagePixelMatrix"	Type="1"	NotZeroError=""
		Name="RowPositionInTotalImagePixelMatrix"		Type="1"	NotZeroError=""
		Name="XOffsetInSlideCoordinateSystem"			Type="1"
		Name="YOffsetInSlideCoordinateSystem"			Type="1"
		Name="ZOffsetInSlideCoordinateSystem"			Type="1"
	SequenceEnd
MacroEnd

DefineMacro="OpticalPathIdentificationMacro" InformationEntity="FunctionalGroup"
	Sequence="OpticalPathIdentificationSequence"		Type="1"	VM="1"
		Name="OpticalPathIdentifier"					Type="1"
	SequenceEnd
MacroEnd

DefineMacro="SpecimenReferenceMacro" InformationEntity="FunctionalGroup"
	Sequence="SpecimenReferenceSequence"				Type="2"	VM="0-1"
		Name="SpecimenUID"								Type="1"
	SequenceEnd
MacroEnd

DefineMacro="WholeSlideMicroscopyImageFrameTypeMacro" InformationEntity="FunctionalGroup"
	Sequence="WholeSlideMicroscopyImageFrameTypeSequence"	Type="1"	VM="1"
		Name="FrameType"									Type="1"	VM="4"
		Verify="FrameType"												ValueSelector="0"	StringEnumValues="WholeSlideImageType1"
		Verify="FrameType"												ValueSelector="1"	StringEnumValues="CommonEnhancedImageAndFrameType2"
		Verify="FrameType"												ValueSelector="2"	StringDefinedTerms="WholeSlideImageType3"
		Verify="FrameType"												ValueSelector="3"	StringDefinedTerms="WholeSlideImageType4"
	SequenceEnd
MacroEnd

Module="SlideLabel"
	Name="BarcodeValue"									Type="2"
	Name="LabelText"									Type="2"
ModuleEnd

Module="MultiFrameFunctionalGroupsForWholeSlideMicroscopy"
	Sequence="SharedFunctionalGroupsSequence"	Type="1"	VM="1"
		InvokeMacro="PixelMeasuresMacro"
		InvokeMacro="ReferencedImageMacro"				Condition="ReferencedImageMacroOKInSharedFunctionalGroupSequence"
		InvokeMacro="DerivationImageMacro"				Condition="DerivationImageMacroOKInSharedFunctionalGroupSequence"
		InvokeMacro="RealWorldValueMappingMacro"		Condition="RealWorldValueMappingMacroOKInSharedFunctionalGroupSequenceAndPhotometricInterpretationIsMonochrome2"
		InvokeMacro="PlanePositionSlideMacro"			Condition="NeedPlanePositionSlideMacroInSharedFunctionalGroupSequenceForWholeSlideMicroscopy"
		InvokeMacro="OpticalPathIdentificationMacro"	Condition="NeedOpticalPathIdentificationMacroInSharedFunctionalGroupSequenceForWholeSlideMicroscopy"
		InvokeMacro="SpecimenReferenceMacro"			Condition="SpecimenReferenceMacroOKInSharedFunctionalGroupSequence"
		InvokeMacro="WholeSlideMicroscopyImageFrameTypeMacro"
	SequenceEnd

	Sequence="PerFrameFunctionalGroupsSequence"	Type="1C"	VM="1-n"	Condition="PerFrameFunctionalGroupsSequencePresent"
		InvokeMacro="FrameContentMacro"					Condition="FrameContentMacroPresent"
		InvokeMacro="ReferencedImageMacro"				Condition="ReferencedImageMacroOKInPerFrameFunctionalGroupSequence"
		InvokeMacro="DerivationImageMacro"				Condition="DerivationImageMacroOKInPerFrameFunctionalGroupSequence"
		InvokeMacro="RealWorldValueMappingMacro"		Condition="RealWorldValueMappingMacroOKInPerFrameFunctionalGroupSequenceAndPhotometricInterpretationIsMonochrome2"
		InvokeMacro="PlanePositionSlideMacro"			Condition="NeedPlanePositionSlideMacroInPerFrameFunctionalGroupSequenceForWholeSlideMicroscopy"
		InvokeMacro="OpticalPathIdentificationMacro"	Condition="NeedOpticalPathIdentificationMacroInPerFrameFunctionalGroupSequenceForWholeSlideMicroscopy"
		InvokeMacro="SpecimenReferenceMacro"			Condition="SpecimenReferenceMacroOKInPerFrameFunctionalGroupSequence"
	SequenceEnd
ModuleEnd

Module="LensometryMeasurementsSeries"
	Name="Modality"										Type="1"			StringEnumValues="LensometryModality"
	Sequence="ReferencedPerformedProcedureStepSequence"	Type="1C"	VM="1"	Condition="SeriesNeedReferencedPerformedProcedureStepSequence"
		InvokeMacro="SOPInstanceReferenceMacro"
	SequenceEnd
ModuleEnd

Module="AutorefractionMeasurementsSeries"
	Name="Modality"										Type="1"			StringEnumValues="AutorefractionModality"
	Sequence="ReferencedPerformedProcedureStepSequence"	Type="1C"	VM="1"	Condition="SeriesNeedReferencedPerformedProcedureStepSequence"
		InvokeMacro="SOPInstanceReferenceMacro"
	SequenceEnd
ModuleEnd

Module="KeratometryMeasurementsSeries"
	Name="Modality"										Type="1"			StringEnumValues="KeratometryModality"
	Sequence="ReferencedPerformedProcedureStepSequence"	Type="1C"	VM="1"	Condition="SeriesNeedReferencedPerformedProcedureStepSequence"
		InvokeMacro="SOPInstanceReferenceMacro"
	SequenceEnd
ModuleEnd

Module="SubjectiveRefractionMeasurementsSeries"
	Name="Modality"										Type="1"			StringEnumValues="SubjectiveRefractionModality"
	Sequence="ReferencedPerformedProcedureStepSequence"	Type="1C"	VM="1"	Condition="SeriesNeedReferencedPerformedProcedureStepSequence"
		InvokeMacro="SOPInstanceReferenceMacro"
	SequenceEnd
ModuleEnd

Module="VisualAcuityMeasurementsSeries"
	Name="Modality"										Type="1"			StringEnumValues="VisualAcuityModality"
	Sequence="ReferencedPerformedProcedureStepSequence"	Type="1C"	VM="1"	Condition="SeriesNeedReferencedPerformedProcedureStepSequence"
		InvokeMacro="SOPInstanceReferenceMacro"
	SequenceEnd
ModuleEnd

DefineMacro="CylinderSequenceMacro"
	Sequence="CylinderSequence"							Type="1C"	VM="1"	NoCondition=""
		Name="CylinderPower"							Type="1"		
		Name="CylinderAxis"								Type="1"		
	SequenceEnd
MacroEnd

DefineMacro="PrismSequenceMacro"
	Sequence="PrismSequence"							Type="1C"	VM="1"	NoCondition=""
		Name="HorizontalPrismPower"						Type="1"		
		Name="HorizontalPrismBase"						Type="1"		
		Name="VerticalPrismPower"						Type="1"		
		Name="VerticalPrismBase"						Type="1"		
	SequenceEnd
MacroEnd

Module="GeneralOphthalmicRefractiveMeasurements"
	Name="InstanceNumber"								Type="1"		
	Name="ContentDate"									Type="1"		
	Name="ContentTime"									Type="1"		
	Name="MeasurementLaterality"						Type="3"			StringEnumValues="OphthalmicRefractiveMeasurementLaterality"
	Name="ImageComments"								Type="3"		
	Sequence="ReferencedRefractiveMeasurementsSequence"	Type="2C"	VM="0-n"	Condition="VisualAcuityTypeCodeSequencePresent"
		InvokeMacro="SOPInstanceReferenceMacro"
	SequenceEnd
ModuleEnd

Module="LensometryMeasurements"
	Name="LensDescription"								Type="2"		
	Sequence="RightLensSequence"						Type="1C"	VM="1"	NoCondition=""
		InvokeMacro="LensometryMeasurementsMacro"
	SequenceEnd
	Sequence="LeftLensSequence"							Type="1C"	VM="1"	NoCondition=""
		InvokeMacro="LensometryMeasurementsMacro"
	SequenceEnd
	Sequence="UnspecifiedLateralityLensSequence"		Type="1C"	VM="1"	Condition="RightLensSequenceAndLeftLensSequenceAbsent"
		InvokeMacro="LensometryMeasurementsMacro"
	SequenceEnd
ModuleEnd

DefineMacro="LensometryMeasurementsMacro"
	Name="SpherePower"									Type="1"		
	InvokeMacro="CylinderSequenceMacro"
	Sequence="AddNearSequence"							Type="1C"	VM="1"	NoCondition=""
		Name="AddPower"									Type="1"		
		Name="ViewingDistance"							Type="3"		
	SequenceEnd
	Sequence="AddIntermediateSequence"					Type="1C"	VM="1"	NoCondition=""
		Name="AddPower"									Type="1"		
		Name="ViewingDistance"							Type="3"		
	SequenceEnd
	InvokeMacro="PrismSequenceMacro"
	Name="LensSegmentType"								Type="3"	VM="1"	StringEnumValues="LensSegmentType"
	Name="OpticalTransmittance"							Type="3"		
	Name="ChannelWidth"									Type="3"		
MacroEnd

Module="AutorefractionMeasurements"
	Sequence="AutorefractionRightEyeSequence"			Type="1C"	VM="1"	NoCondition=""
		Name="SpherePower"								Type="1"		
		InvokeMacro="CylinderSequenceMacro"
		Name="PupilSize"								Type="3"		
		Name="CornealSize"								Type="3"		
	SequenceEnd
	Sequence="AutorefractionLeftEyeSequence"			Type="1C"	VM="1"	NoCondition=""
		Name="SpherePower"								Type="1"		
		InvokeMacro="CylinderSequenceMacro"
		Name="PupilSize"								Type="3"		
		Name="CornealSize"								Type="3"		
	SequenceEnd
	Name="DistancePupillaryDistance"					Type="3"		
	Name="NearPupillaryDistance"						Type="3"		
ModuleEnd

Module="KeratometryMeasurements"
	Sequence="KeratometryRightEyeSequence"				Type="1C"	VM="1"	NoCondition=""
		InvokeMacro="KeratometricMeasurementsMacro"
	SequenceEnd
	Sequence="KeratometryLeftEyeSequence"				Type="1C"	VM="1"	NoCondition=""
		InvokeMacro="KeratometricMeasurementsMacro"
	SequenceEnd
ModuleEnd

DefineMacro="KeratometricMeasurementsMacro"
	Sequence="SteepKeratometricAxisSequence"			Type="1"	VM="1"
		Name="RadiusOfCurvature"						Type="1"
		Name="KeratometricPower"						Type="1"
		Name="KeratometricAxis"							Type="1"
	SequenceEnd
	Sequence="FlatKeratometricAxisSequence"				Type="1"	VM="1"
		Name="RadiusOfCurvature"						Type="1"
		Name="KeratometricPower"						Type="1"
		Name="KeratometricAxis"							Type="1"
	SequenceEnd
MacroEnd

Module="SubjectiveRefractionMeasurements"
	Sequence="SubjectiveRefractionRightEyeSequence"		Type="1C"	VM="1"	NoCondition=""
		InvokeMacro="SubjectiveRefractionMeasurementsMacro"
	SequenceEnd
	Sequence="SubjectiveRefractionLeftEyeSequence"		Type="1C"	VM="1"	NoCondition=""
		InvokeMacro="SubjectiveRefractionMeasurementsMacro"
	SequenceEnd
	Name="DistancePupillaryDistance"					Type="3"
	Name="NearPupillaryDistance"						Type="3"
	Name="IntermediatePupillaryDistance"				Type="3"
	Name="OtherPupillaryDistance"						Type="3"
ModuleEnd

DefineMacro="SubjectiveRefractionMeasurementsMacro"
	Name="SpherePower"									Type="1"
	InvokeMacro="CylinderSequenceMacro"
	InvokeMacro="PrismSequenceMacro"
	Sequence="AddNearSequence"							Type="1C"	VM="1"	NoCondition=""
		Name="AddPower"									Type="1"
		Name="ViewingDistance"							Type="3"
	SequenceEnd
	Sequence="AddIntermediateSequence"					Type="1C"	VM="1"	NoCondition=""
		Name="AddPower"									Type="1"
		Name="ViewingDistance"							Type="3"
	SequenceEnd
	Sequence="AddOtherSequence"							Type="1C"	VM="1"	NoCondition=""
		Name="AddPower"									Type="1"
		Name="ViewingDistance"							Type="3"
	SequenceEnd
MacroEnd

Module="VisualAcuityMeasurements"
	Name="ViewingDistanceType"							Type="1"	StringEnumValues="ViewingDistanceType"
	Sequence="VisualAcuityTypeCodeSequence"				Type="1"	VM="1"
		InvokeMacro="CodeSequenceMacro"					DefinedContextID="4216"
	SequenceEnd
	Name="BackgroundColor"								Type="1"	StringDefinedTerms="VisualAcuityMeasurementsBackgroundColor"
	Name="Optotype"										Type="1"	StringDefinedTerms="Optotype"
	Name="OptotypeDetailedDefinition"					Type="1C"	Condition="OptotypeIsLettersNumbersOrPictures"
	Name="OptotypePresentation"							Type="1"	StringEnumValues="OptotypePresentation"
	Sequence="VisualAcuityRightEyeSequence"				Type="1C"	VM="1"	NoCondition=""
		InvokeMacro="VisualAcuityMeasurementsMacro"
	SequenceEnd
	Sequence="VisualAcuityLeftEyeSequence"				Type="1C"	VM="1"	NoCondition=""
		InvokeMacro="VisualAcuityMeasurementsMacro"
	SequenceEnd
	Sequence="VisualAcuityBothEyesOpenSequence"			Type="3"	VM="1"
		InvokeMacro="VisualAcuityMeasurementsMacro"
	SequenceEnd
ModuleEnd

DefineMacro="VisualAcuityMeasurementsMacro"
	Name="DecimalVisualAcuity"							Type="1"
	Name="VisualAcuityModifiers"						Type="3"
MacroEnd

Module="OphthalmicAxialMeasurementsSeries"
	Name="Modality"										Type="1"			StringEnumValues="OphthalmicAxialMeasurementsModality"
	Sequence="ReferencedPerformedProcedureStepSequence"	Type="1C"	VM="1"	Condition="SeriesNeedReferencedPerformedProcedureStepSequence"
		InvokeMacro="SOPInstanceReferenceMacro"
	SequenceEnd
ModuleEnd

Module="OphthalmicAxialMeasurements"
	Name="OphthalmicAxialMeasurementsDeviceType"			Type="1"			StringDefinedTerms="OphthalmicAxialMeasurementsDeviceType"
	Sequence="OphthalmicUltrasoundMethodCodeSequence"		Type="1C"	VM="1"	Condition="OphthalmicAxialMeasurementsDeviceTypeIsUltrasound"
		InvokeMacro="CodeSequenceMacro"
	SequenceEnd
	Sequence="AnteriorChamberDepthDefinitionCodeSequence"	Type="3"	VM="1"
		InvokeMacro="CodeSequenceMacro"
	SequenceEnd
	Sequence="OphthalmicAxialMeasurementsRightEyeSequence"	Type="1C"	VM="1"	NoCondition=""
		InvokeMacro="OphthalmicAxialMeasurementsMacro"
		InvokeMacro="OphthalmicAxialMeasurementsSelectedMacro"
	SequenceEnd
	Sequence="OphthalmicAxialMeasurementsLeftEyeSequence"	Type="1C"	VM="1"	NoCondition=""
		InvokeMacro="OphthalmicAxialMeasurementsMacro"
		InvokeMacro="OphthalmicAxialMeasurementsSelectedMacro"
	SequenceEnd
ModuleEnd

DefineMacro="OphthalmicAxialMeasurementsMacro"
	Sequence="LensStatusCodeSequence"												Type="1"	VM="1"
		InvokeMacro="CodeSequenceMacro"																		DefinedContextID="4231"
	SequenceEnd
	Name="LensStatusDescription"													Type="3"
	Sequence="VitreousStatusCodeSequence"											Type="1"	VM="1"
		InvokeMacro="CodeSequenceMacro"																		DefinedContextID="4232"
	SequenceEnd
	Name="VitreousStatusDescription"												Type="3"
	Name="PupilDilated"																Type="2"				StringEnumValues="YesNoFull"
	Name="DegreeOfDilation"															Type="2C"				Condition="PupilDilatedIsYes"
	Sequence="MydriaticAgentSequence"												Type="2C"	VM="0-n"	Condition="PupilDilatedIsYes"
		Sequence="MydriaticAgentCodeSequence"										Type="1"	VM="1"
			InvokeMacro="CodeSequenceMacro"																	DefinedContextID="4208"
		SequenceEnd
		Name="MydriaticAgentConcentration"											Type="3"
		Sequence="MydriaticAgentConcentrationUnitsSequence"							Type="1C"	VM="1"		Condition="MydriaticAgentConcentrationPresent"
			InvokeMacro="CodeSequenceMacro"																	DefinedContextID="4244"
		SequenceEnd
	SequenceEnd
	Sequence="OphthalmicAxialLengthMeasurementsSequence"							Type="1"	VM="1-n"
		Name="OphthalmicAxialLengthMeasurementsType"								Type="1"				StringEnumValues="OphthalmicAxialLengthMeasurementsType"
		Sequence="OphthalmicAxialLengthMeasurementsTotalLengthSequence"				Type="1C"	VM="1-n"	Condition="OphthalmicAxialLengthMeasurementsTypeIsTotalLength"
			Name="OphthalmicAxialLength"											Type="1"
			Name="OphthalmicAxialLengthMeasurementModified"							Type="1"				StringEnumValues="YesNoFull"
			Sequence="ReferencedOphthalmicAxialLengthMeasurementQCImageSequence"	Type="1"	VM="1"
				InvokeMacro="OphthalmicAxialMeasurementsQualityImageSOPInstanceReferenceMacro"
			SequenceEnd
			InvokeMacro="OphthalmicAxialMeasurementsRelatedInformationMacro"
		SequenceEnd
		Sequence="OphthalmicAxialLengthMeasurementsLengthSummationSequence"			Type="1C"	VM="1-n"	Condition="OphthalmicAxialLengthMeasurementsTypeIsLengthSummation"
			Name="OphthalmicAxialLength"											Type="1"
			Name="OphthalmicAxialLengthMeasurementModified"							Type="1"				StringEnumValues="YesNoFull"
			Sequence="ReferencedOphthalmicAxialLengthMeasurementQCImageSequence"	Type="1"	VM="1"
				InvokeMacro="OphthalmicAxialMeasurementsQualityImageSOPInstanceReferenceMacro"
			SequenceEnd
			Sequence="OphthalmicAxialLengthMeasurementsSegmentalLengthSequence"		Type="1"	VM="1-n"
				InvokeMacro="OphthalmicAxialLengthSegmentalMeasurementsMacro"
			SequenceEnd
		SequenceEnd
		Sequence="OphthalmicAxialLengthMeasurementsSegmentalLengthSequence"			Type="1C"	VM="1-n"	Condition="OphthalmicAxialLengthMeasurementsTypeIsSegmentalLength"
			InvokeMacro="OphthalmicAxialLengthSegmentalMeasurementsMacro"
		SequenceEnd
	SequenceEnd
MacroEnd

DefineMacro="OphthalmicAxialLengthSegmentalMeasurementsMacro"
	Name="OphthalmicAxialLength"										Type="1"
	Name="OphthalmicAxialLengthMeasurementModified"						Type="1"				StringEnumValues="YesNoFull"
	Sequence="OphthalmicAxialLengthMeasurementsSegmentNameCodeSequence"	Type="1"	VM="1"
		InvokeMacro="CodeSequenceMacro"
	SequenceEnd
	InvokeMacro="OphthalmicAxialMeasurementsRelatedInformationMacro"
MacroEnd

DefineMacro="OphthalmicAxialMeasurementsRelatedInformationMacro"
	Sequence="UltrasoundOphthalmicAxialLengthMeasurementsSequence"		Type="1C"	VM="1"		Condition="OphthalmicAxialMeasurementsDeviceTypeIsUltrasound"
		Name="OphthalmicAxialLengthVelocity"							Type="1"
		Name="ObserverType"												Type="1"				StringEnumValues="OphthalmicAxialMeasurementsObserverType"
		Sequence="OphthalmicAxialLengthDataSourceCodeSequence"			Type="1"	VM="1"
			InvokeMacro="CodeSequenceMacro"														DefinedContextID="4240"
		SequenceEnd
		Name="OphthalmicAxialLengthDataSourceDescription"				Type="3"
	SequenceEnd
	Sequence="OpticalOphthalmicAxialLengthMeasurementsSequence"			Type="1C"	VM="1"		Condition="OphthalmicAxialMeasurementsDeviceTypeIsOptical"
		Name="SignalToNoiseRatio"										Type="3"
		Sequence="OphthalmicAxialLengthDataSourceCodeSequence"			Type="1"	VM="1"
			InvokeMacro="CodeSequenceMacro"														DefinedContextID="4240"
		SequenceEnd
		Name="OphthalmicAxialLengthDataSourceDescription"				Type="3"
	SequenceEnd
MacroEnd

DefineMacro="OphthalmicAxialMeasurementsSelectedMacro"
	Sequence="UltrasoundSelectedOphthalmicAxialLengthSequence"						Type="1C"	VM="1"		Condition="OphthalmicAxialMeasurementsDeviceTypeIsUltrasound"
		Name="OphthalmicAxialLength"												Type="1"
		Sequence="OphthalmicAxialLengthSelectionMethodCodeSequence"					Type="1"	VM="1"
			InvokeMacro="CodeSequenceMacro"																	DefinedContextID="4241"
		SequenceEnd
		Sequence="ReferencedOphthalmicAxialLengthMeasurementQCImageSequence"		Type="1"	VM="1"
			InvokeMacro="OphthalmicAxialMeasurementsQualityImageSOPInstanceReferenceMacro"
		SequenceEnd
		Sequence="OphthalmicAxialLengthQualityMetricSequence"						Type="1"	VM="1"
			InvokeMacro="OphthalmicAxialLengthQualityMetricMacro"
		SequenceEnd
		Sequence="SelectedSegmentalOphthalmicAxialLengthSequence"					Type="1C"	VM="1"		Condition="OphthalmicAxialLengthMeasurementsTypeAboveIsLengthSummation"
			Name=OphthalmicAxialLength"												Type="1"
			Sequence="OphthalmicAxialLengthMeasurementsSegmentNameCodeSequence"		Type="1"	VM="1"
				InvokeMacro="CodeSequenceMacro"																DefinedContextID="4233"
			SequenceEnd
		SequenceEnd
	SequenceEnd
	Sequence="OpticalSelectedOphthalmicAxialLengthSequence"							Type="1C"	VM="1-n"	Condition="OphthalmicAxialMeasurementsDeviceTypeIsOptical"
		Sequence="SelectedTotalOphthalmicAxialLengthSequence"						Type="1C"	VM="1"		Condition="OphthalmicAxialLengthMeasurementsTypeAboveIsTotalLength"
			Name="OphthalmicAxialLength"											Type="1"
			Sequence="ReferencedOphthalmicAxialLengthMeasurementQCImageSequence"	Type="1"	VM="1"
				InvokeMacro="OphthalmicAxialMeasurementsQualityImageSOPInstanceReferenceMacro"
			SequenceEnd
			Sequence="OphthalmicAxialLengthQualityMetricSequence"					Type="1"	VM="1"
				InvokeMacro="OphthalmicAxialLengthQualityMetricMacro"
			SequenceEnd
		SequenceEnd
		Sequence="SelectedSegmentalOphthalmicAxialLengthSequence"					Type="1C"	VM="1-n"	Condition="OphthalmicAxialLengthMeasurementsTypeAboveIsSegmentalLength"
			Sequence="OphthalmicAxialLengthMeasurementsSegmentNameCodeSequence"		Type="1"	VM="1"
				InvokeMacro="CodeSequenceMacro"																DefinedContextID="4233"
			SequenceEnd
			Name="OphthalmicAxialLength"											Type="1"
			Sequence="ReferencedOphthalmicAxialLengthMeasurementQCImageSequence"	Type="3"	VM="1"
				InvokeMacro="OphthalmicAxialMeasurementsQualityImageSOPInstanceReferenceMacro"
			SequenceEnd
			Sequence="OphthalmicAxialLengthQualityMetricSequence"					Type="3"	VM="1"
				InvokeMacro="OphthalmicAxialLengthQualityMetricMacro"
			SequenceEnd
		SequenceEnd
	SequenceEnd
MacroEnd

DefineMacro="OphthalmicAxialLengthQualityMetricMacro"
	Sequence="ConceptNameCodeSequence"					Type="1"	VM="1"
		InvokeMacro="CodeSequenceMacro"										DefinedContextID="4243"
	SequenceEnd
	Name="NumericValue"									Type="1"
	Sequence="MeasurementUnitsCodeSequence"				Type="1"	VM="1"
		InvokeMacro="CodeSequenceMacro"										DefinedContextID="82"
	SequenceEnd
MacroEnd

Module="IntraocularLensCalculationsSeries"
	Name="Modality"										Type="1"			StringEnumValues="IntraocularLensCalculationsModality"
	Sequence="ReferencedPerformedProcedureStepSequence"	Type="1C"	VM="1"	Condition="SeriesNeedReferencedPerformedProcedureStepSequence"
		InvokeMacro="SOPInstanceReferenceMacro"
	SequenceEnd
ModuleEnd

Module="IntraocularLensCalculations"
	Sequence="IntraocularLensCalculationsRightEyeSequence"	Type="1C"	VM="1-n"	NoCondition=""
		InvokeMacro="IntraocularLensCalculationsMacro"
	SequenceEnd
	Sequence="IntraocularLensCalculationsLeftEyeSequence"	Type="1C"	VM="1-n"	NoCondition=""
		InvokeMacro="IntraocularLensCalculationsMacro"
	SequenceEnd
ModuleEnd

DefineMacro="IntraocularLensCalculationsMacro"
	Name="TargetRefraction"											Type="1"
	Name="RefractiveProcedureOccurred"								Type="2"				StringEnumValues="YesNoFull"
	Sequence="RefractiveSurgeryTypeCodeSequence"					Type="2C"	VM="0-n"	Condition="RefractiveProcedureOccurredIsYes"
		InvokeMacro="CodeSequenceMacro"														DefinedContextID="4234"
	SequenceEnd
	Sequence="RefractiveErrorBeforeRefractiveSurgeryCodeSequence"	Type="2C"	VM="0-1"	Condition="RefractiveProcedureOccurredIsYes"
		InvokeMacro="CodeSequenceMacro"														DefinedContextID="4238"
	SequenceEnd
	Sequence="CornealSizeSequence"									Type="3"	VM="1"
		Name="CornealSize"											Type="1"
		Sequence="SourceOfCornealSizeDataCodeSequence"				Type="1"	VM="1"
			InvokeMacro="CodeSequenceMacro"													DefinedContextID="4240"
		SequenceEnd
		Sequence="ReferencedSOPSequence"							Type="1C"	VM="1"		NoCondition="" # too hard to check that SourceOfLensThicknessDataCodeSequence contains (111784, DCM, "Autorefraction Measurements SOP Instance")
			InvokeMacro="SOPInstanceReferenceMacro"
		SequenceEnd
	SequenceEnd
	Sequence="LensThicknessSequence"								Type="3"	VM="1"
		Name="LensThickness"										Type="1"
		Sequence="SourceOfLensThicknessDataCodeSequence"			Type="1"	VM="1"
			InvokeMacro="CodeSequenceMacro"													DefinedContextID="4240"
		SequenceEnd
		Sequence="ReferencedSOPSequence"							Type="1C"	VM="1"		NoCondition="" # too hard to check that SourceOfLensThicknessDataCodeSequence contains (111782, DCM, "Axial Measurements SOP Instance")
			InvokeMacro="SOPInstanceReferenceMacro"
		SequenceEnd
	SequenceEnd
	Sequence="AnteriorChamberDepthSequence"							Type="3"	VM="1"
		Name="AnteriorChamberDepth"	Type="1"
		Sequence="SourceOfAnteriorChamberDepthDataCodeSequence"		Type="1"	VM="1"
			InvokeMacro="CodeSequenceMacro"
		SequenceEnd
		Sequence="ReferencedSOPSequence"							Type="1C"	VM="1"		NoCondition="" # too hard to check that SourceOfAnteriorChamberDepthDataCodeSequence contains (111782, DCM, "Axial Measurements SOP Instance")
			InvokeMacro="SOPInstanceReferenceMacro"
		SequenceEnd
	SequenceEnd
	Sequence="RefractiveStateSequence"								Type="2"	VM="0-1"
		Name="SphericalLensPower"									Type="1"
		Name="CylinderLensPower"									Type="1"
		Name="CylinderAxis"											Type="1"
		Sequence="SourceOfRefractiveMeasurementsSequence"			Type="1"	VM="1"
			Sequence="SourceOfRefractiveMeasurementsCodeSequence"	Type="1"	VM="1"
				InvokeMacro="CodeSequenceMacro"												DefinedContextID="4240"
			SequenceEnd
			Sequence="ReferencedSOPSequence"						Type="1C"	VM="1"		NoCondition="" # too hard to check that SourceOfRefractiveMeasurementsCodeSequence contains (111783, DCM, "Refractive Measurements SOP Instance")
				InvokeMacro="SOPInstanceReferenceMacro"
			SequenceEnd
		SequenceEnd
	SequenceEnd
	InvokeMacro="KeratometryMacro"
	Sequence="CorneaMeasurementsSequence"							Type="3"	VM="1"
		InvokeMacro="CorneaMeasurementMacro"
		Sequence="SourceOfCorneaMeasurementDataCodeSequence"		Type="1"	VM="1"
			InvokeMacro="CodeSequenceMacro"													DefinedContextID="4240"
		SequenceEnd
		Sequence="ReferencedSOPSequence"							Type="1C"	VM="1"		NoCondition="" # too hard to check that SourceOfCorneaMeasurementDataCodeSequence contains (111757, DCM, "Keratometry Measurements SOP Instance") :(
			InvokeMacro="SOPInstanceReferenceMacro"
		SequenceEnd
	SequenceEnd
	Sequence="IOLFormulaCodeSequence"								Type="1"	VM="1"
		InvokeMacro="CodeSequenceMacro"														DefinedContextID="4236"
	SequenceEnd
	Name="IOLFormulaDetail"											Type="3"
	InvokeMacro="IOLOphthalmicAxialLengthMacro"
	Sequence="SurgicallyInducedAstigmatismSequence"					Type="3"	VM="1"
		Name="CylinderPower"										Type="1"
		Name="CylinderAxis"											Type="1"
	SequenceEnd
	InvokeMacro="CalculatedIOLMacro"
MacroEnd

DefineMacro="KeratometryMacro"
	Sequence="SteepKeratometricAxisSequence"						Type="1"	VM="1"
		Name="RadiusOfCurvature"									Type="1"
		Name="KeratometricPower"									Type="2"
		Name="KeratometricAxis"										Type="2"
	SequenceEnd
	Sequence="FlatKeratometricAxisSequence"							Type="1"	VM="1"
		Name="RadiusOfCurvature"									Type="1"
		Name="KeratometricPower"									Type="2"
		Name="KeratometricAxis"										Type="2"
	SequenceEnd
	Sequence="KeratometryMeasurementTypeCodeSequence"				Type="2"	VM="1"
		InvokeMacro="CodeSequenceMacro"														DefinedContextID="4235"
	SequenceEnd
	Name="KeratometerIndex"											Type="2"
MacroEnd

DefineMacro="IOLOphthalmicAxialLengthMacro"
	Sequence="OphthalmicAxialLengthSequence"						Type="1"	VM="1"
		Name="OphthalmicAxialLength"								Type="1"
		Sequence="OphthalmicAxialLengthSelectionMethodCodeSequence"	Type="1"	VM="1"
			InvokeMacro="CodeSequenceMacro"													DefinedContextID="4241"
		SequenceEnd
		Sequence="SourceOfOphthalmicAxialLengthCodeSequence"		Type="1"	VM="1"
			InvokeMacro="CodeSequenceMacro"													DefinedContextID="4240"
		SequenceEnd
		Sequence="ReferencedSOPSequence"							Type="1C"	VM="1"		NoCondition="" # too hard to check that SourceOfOphthalmicAxialLengthCodeSequence contains (111782, DCM, "Axial Measurements SOP Instance")
			InvokeMacro="SOPInstanceReferenceMacro"
		SequenceEnd
		Sequence="OphthalmicUltrasoundMethodCodeSequence"			Type="1C"	VM="1"		Condition="OphthalmicAxialMeasurementsDeviceTypeIsUltrasound"
			InvokeMacro="CodeSequenceMacro"													DefinedContextID="4230"
		SequenceEnd
	SequenceEnd
MacroEnd

DefineMacro="CalculatedIOLMacro"
	Name="IOLManufacturer"										Type="1"
	Name="ImplantName"											Type="1"
	Name="TypeOfOpticalCorrection"								Type="3"				StringEnumValues="TypeOfOpticalCorrection"
	Sequence="LensConstantSequence"								Type="1"	VM="1-n"
		Sequence="ConceptNameCodeSequence"						Type="1"	VM="1"
			InvokeMacro="CodeSequenceMacro"												DefinedContextID="4237"
		SequenceEnd
		Name="NumericValue"	Type="1"
	SequenceEnd
	Sequence="IOLPowerSequence"									Type="1"	VM="1-n"
		Name="IOLPower"											Type="1"
		Sequence="ToricIOLPowerSequence"						Type="1C"	VM="1"		Condition="TypeOfOpticalCorrectionAboveIsToric"
			InvokeMacro="CalculatedToricPowerMacro"
		SequenceEnd
		Name="PredictedRefractiveError"							Type="1"
		Sequence="PredictedToricErrorSequence"					Type="1C"	VM="1"		Condition="TypeOfOpticalCorrectionAboveIsToric"
			InvokeMacro="CalculatedToricPowerMacro"
		SequenceEnd
		Name="ImplantPartNumber"								Type="2"
		Name="PreSelectedForImplantation"						Type="3"				StringEnumValues="YesNoFull"
	SequenceEnd
	Name="IOLPowerForExactEmmetropia"							Type="2"
	Sequence="ToricIOLPowerForExactEmmetropiaSequence"			Type="2C"	VM="0-1"	Condition="TypeOfOpticalCorrectionIsToric"
		InvokeMacro="CalculatedToricPowerMacro"
	SequenceEnd
	Name="IOLPowerForExactTargetRefraction"						Type="2"
	Sequence="ToricIOLPowerForExactTargetRefractionSequence"	Type="2C"	VM="0-1"	Condition="TypeOfOpticalCorrectionIsToric"
		InvokeMacro="CalculatedToricPowerMacro"
	SequenceEnd
	Sequence="CalculationCommentSequence"						Type="3"	VM="1"
		Name="CalculationCommentType"							Type="1"				StringDefinedTerms="CalculationCommentType"
		Name="CalculationComment"								Type="1"
	SequenceEnd
MacroEnd

DefineMacro="CalculatedToricPowerMacro"
	Name="SpherePower"					Type="3"
	Name="CylinderPower"				Type="1"
	Name="CylinderAxis"					Type="1"
MacroEnd

DefineMacro="CorneaMeasurementMacro"
	Sequence="SteepCornealAxisSequence"				Type="1"	VM="1"
		Name="RadiusOfCurvature"					Type="1"
		Name="CornealPower"							Type="2"
		Name="CornealAxis"							Type="2"
	SequenceEnd
	Sequence="FlatCornealAxisSequence"				Type="1"	VM="1"
		Name="RadiusOfCurvature"					Type="1"
		Name="CornealPower"							Type="2"
		Name="CornealAxis"							Type="2"
	SequenceEnd
	Sequence="CorneaMeasurementMethodCodeSequence"	Type="1"	VM="1"
			InvokeMacro="CodeSequenceMacro"									DefinedContextID="4242"
	SequenceEnd
	Name="KeratometerIndex"							Type="2"
	Name="RefractiveIndexOfCornea"					Type="1C"	NoCondition=""	# need to check code in CorneaMeasurementMethodCodeSequence :(
	Name="RefractiveIndexOfAqueousHumor"			Type="1C"	NoCondition=""	# need to check code in CorneaMeasurementMethodCodeSequence :(
MacroEnd

DefineMacro="OphthalmicAxialMeasurementsQualityImageSOPInstanceReferenceMacro"
	Name="ReferencedSOPClassUID"	Type="1"	StringEnumValues="OphthalmicAxialMeasurementsQualityImageSOPClassUIDs"
	Name="ReferencedSOPInstanceUID"	Type="1"
	Name="ReferencedFrameNumber"	Type="1"
MacroEnd

Module="VisualFieldStaticPerimetryMeasurementsSeries"
	Name="Modality"										Type="1"	StringEnumValues="OphthalmicVisualFieldModality"
	Sequence="ReferencedPerformedProcedureStepSequence"	Type="1C"	VM="1"	Condition="SeriesNeedReferencedPerformedProcedureStepSequence"
		InvokeMacro="SOPInstanceReferenceMacro"
	SequenceEnd
	Sequence="RequestAttributesSequence"				Type="3"	VM="1-n"
		InvokeMacro="RequestAttributesMacro"
	SequenceEnd
	InvokeMacro="PerformedProcedureStepSummaryMacro"
ModuleEnd

Module="VisualFieldStaticPerimetryTestParameters"
	Name="VisualFieldHorizontalExtent"						Type="1"
	Name="VisualFieldVerticalExtent"						Type="1"
	Name="VisualFieldShape"									Type="1"	StringEnumValues="VisualFieldShape"
	Sequence="ScreeningTestModeCodeSequence"				Type="1C"	VM="1"	NoCondition="" mbpo="true"
		InvokeMacro="CodeSequenceMacro"
	SequenceEnd
	Name="MaximumStimulusLuminance"							Type="1"
	Name="BackgroundLuminance"								Type="1"
	Sequence="StimulusColorCodeSequence"					Type="1"	VM="1"
		InvokeMacro="CodeSequenceMacro"
	SequenceEnd
	Sequence="BackgroundIlluminationColorCodeSequence"		Type="1"	VM="1"
	InvokeMacro="CodeSequenceMacro"
	SequenceEnd
	Name="StimulusArea"										Type="1"
	Name="StimulusPresentationTime"							Type="1"
ModuleEnd

Module="VisualFieldStaticPerimetryTestReliability"
	Sequence="FixationSequence"									Type="1"	VM="1"
		Sequence="FixationMonitoringCodeSequence"				Type="1"	VM="1-n"
			InvokeMacro="CodeSequenceMacro"
		SequenceEnd
		Name="FixationCheckedQuantity"							Type="1C"	NoCondition="" mbpo="true"
		Name="PatientNotProperlyFixatedQuantity"				Type="1C"	NoCondition="" mbpo="true"
		Name="ExcessiveFixationLossesDataFlag"					Type="1"	StringEnumValues="YesNoFull"
		Name="ExcessiveFixationLosses"							Type="1C"	Condition="ExcessiveFixationLossesDataFlagIsYes"
	SequenceEnd
	Sequence="VisualFieldCatchTrialSequence"					Type="1"	VM="1"
		Name="CatchTrialsDataFlag"								Type="1"	StringEnumValues="YesNoFull"
		Name="NegativeCatchTrialsQuantity"						Type="1C"	Condition="CatchTrialsDataFlagIsYes"
		Name="FalseNegativesQuantity"							Type="1C"	Condition="CatchTrialsDataFlagIsYes"
		Name="FalseNegativesEstimateFlag"						Type="1"	StringEnumValues="YesNoFull"
		Name="FalseNegativesEstimate"							Type="1C"	Condition="FalseNegativesEstimateFlagIsYes"
		Name="ExcessiveFalseNegativesDataFlag"					Type="1"	StringEnumValues="YesNoFull"
		Name="ExcessiveFalseNegatives"							Type="1C"	StringEnumValues="YesNoFull" Condition="ExcessiveFalseNegativesDataFlagIsYes"
		Name="PositiveCatchTrialsQuantity"						Type="1C"	Condition="CatchTrialsDataFlagIsYes"
		Name="FalsePositivesQuantity"							Type="1C"	Condition="CatchTrialsDataFlagIsYes"
		Name="FalsePositivesEstimateFlag"						Type="1"	StringEnumValues="YesNoFull"
		Name="FalsePositivesEstimate"							Type="1C"	Condition="FalsePositivesEstimateFlagIsYes"
		Name="ExcessiveFalsePositivesDataFlag"					Type="1"	StringEnumValues="YesNoFull"
		Name="ExcessiveFalsePositives"							Type="1C"	StringEnumValues="YesNoFull" Condition="ExcessiveFalsePositivesDataFlagIsYes"
	SequenceEnd
	Name="StimuliRetestingQuantity"								Type="3"
	Name="PatientReliabilityIndicator"							Type="3"
	Name="CommentsOnPatientPerformanceOfVisualField"			Type="3"
	Sequence="VisualFieldTestReliabilityGlobalIndexSequence"	Type="3"	VM="1-n"
		InvokeMacro="OphthalmicVisualFieldGlobalIndexMacro"
	SequenceEnd
ModuleEnd

DefineMacro="OphthalmicVisualFieldGlobalIndexMacro"
	Sequence="DataObservationSequence"						Type="1"	VM="1"
		InvokeMacro="ContentItemMacro"
	SequenceEnd
	Name="IndexNormalsFlag"									Type="1"	StringEnumValues="YesNoFull"
	Sequence="IndexProbabilitySequence"						Type="1C"	VM="1" Condition="IndexNormalsFlagIsYes"
		Name="IndexProbability"								Type="1"
		InvokeMacro="AlgorithmIdentificationMacro"
	SequenceEnd
MacroEnd

Module="VisualFieldStaticPerimetryTestMeasurements"
	Name="MeasurementLaterality"											Type="1"	StringEnumValues="VisualFieldStaticPerimetryTestMeasurementLaterality"
	Name="PresentedVisualStimuliDataFlag"									Type="1"	StringEnumValues="YesNoFull"
	Name="NumberOfVisualStimuli"											Type="1C"	Condition="PresentedVisualStimuliDataFlagIsYes"
	Name="VisualFieldTestDuration"											Type="1"
	Name="FovealSensitivityMeasured"										Type="1"	StringEnumValues="YesNoFull"
	Name="FovealSensitivity"												Type="1C"	Condition="FovealSensitivityMeasuredIsYes"
	Name="FovealPointNormativeDataFlag"										Type="1"	StringEnumValues="YesNoFull"
	Name="FovealPointProbabilityValue"										Type="1C"	Condition="FovealPointNormativeDataFlagIsYes"
	Name="ScreeningBaselineMeasured"										Type="1"	StringEnumValues="YesNoFull"
	Sequence="ScreeningBaselineMeasuredSequence"							Type="1C"	VM="1-n"	Condition="ScreeningBaselineMeasuredIsYes"
		Name="ScreeningBaselineType"										Type="1"	StringEnumValues="VisualFieldStaticPerimetryTestMeasurementsScreeningBaselineType"
		Name="ScreeningBaselineValue"										Type="1"
	SequenceEnd
	Name="BlindSpotLocalized"												Type="1"	StringEnumValues="YesNoFull"
	Name="BlindSpotXCoordinate"												Type="1C"	Condition="BlindSpotLocalizedIsYes"
	Name="BlindSpotYCoordinate"												Type="1C"	Condition="BlindSpotLocalizedIsYes"
	Name="MinimumSensitivityValue"											Type="1"
	Name="TestPointNormalsDataFlag"											Type="1"	StringEnumValues="YesNoFull"
	Sequence="TestPointNormalsSequence"										Type="1C"	VM="1" Condition="TestPointNormalsDataFlagIsYes"
		InvokeMacro="ExternallySourcedDataSetIdentificationMacro"
	SequenceEnd
	Sequence="AgeCorrectedSensitivityDeviationAlgorithmSequence"			Type="1C"	VM="1" Condition="TestPointNormalsDataFlagIsYes"
		InvokeMacro="AlgorithmIdentificationMacro"
	SequenceEnd
	Sequence="GeneralizedDefectSensitivityDeviationAlgorithmSequence"		Type="1C"	VM="1" Condition="TestPointNormalsDataFlagIsYes"
		InvokeMacro="AlgorithmIdentificationMacro"
	SequenceEnd
	Sequence="VisualFieldTestPointSequence"									Type="1"	VM="1-n"
		Name="VisualFieldTestPointXCoordinate"								Type="1"
		Name="VisualFieldTestPointYCoordinate"								Type="1"
		Name="StimulusResults"												Type="1"	StringEnumValues="VisualFieldStaticPerimetryTestMeasurementsStimulusResults"
		Name="SensitivityValue"												Type="1C"	NoCondition="" mbpo="true""
		Name="RetestStimulusSeen"											Type="3"	StringEnumValues="YesNoFull"
		Name="RetestSensitivityValue"										Type="3"
		Name="QuantifiedDefect"												Type="3"
		Sequence="VisualFieldTestPointNormalsSequence"								Type="1C"	VM="1-n" Condition="TestPointNormalsDataFlagIsYes"
			Name="AgeCorrectedSensitivityDeviationValue"							Type="1"
			Name="AgeCorrectedSensitivityDeviationProbabilityValue"					Type="1"
			Name="GeneralizedDefectCorrectedSensitivityDeviationFlag"				Type="1"	StringEnumValues="YesNoFull"
			Name="GeneralizedDefectCorrectedSensitivityDeviationValue"				Type="1C"	Condition="GeneralizedDefectCorrectedSensitivityDeviationFlagIsYes"
			Name="GeneralizedDefectCorrectedSensitivityDeviationProbabilityValue"	Type="1C"	Condition="GeneralizedDefectCorrectedSensitivityDeviationFlagIsYes"
		SequenceEnd
	SequenceEnd
ModuleEnd

Module="VisualFieldStaticPerimetryTestResults"
	Name="VisualFieldMeanSensitivity"									Type="1C"	NoCondition="" mbpo="true"
	Name="VisualFieldTestNormalsFlag"									Type="1"	StringEnumValues="YesNoFull"
	Sequence="ResultsNormalsSequence"									Type="1C"	VM="1"	Condition="VisualFieldTestNormalsFlagIsYes"
		InvokeMacro="ExternallySourcedDataSetIdentificationMacro"
		Name="GlobalDeviationFromNormal"								Type="1"
		Name="GlobalDeviationProbabilityNormalsFlag"					Type="1"	StringEnumValues="YesNoFull"
		Sequence="GlobalDeviationProbabilitySequence"					Type="1C"	VM="1"	Condition="GlobalDeviationProbabilityNormalsFlagIsYes"
			Name="GlobalDeviationProbability"							Type="1"
			InvokeMacro="AlgorithmIdentificationMacro"
		SequenceEnd
		Name="LocalizedDeviationFromNormal"								Type="1"
		Name="LocalDeviationProbabilityNormalsFlag"						Type="1"	StringEnumValues="YesNoFull"
		Sequence="LocalizedDeviationProbabilitySequence"				Type="1C"	VM="1"	Condition="LocalDeviationProbabilityNormalsFlagIsYes"
			Name="LocalizedDeviationProbability"						Type="1"
			InvokeMacro="AlgorithmIdentificationMacro"
		SequenceEnd
	SequenceEnd
	Name="ShortTermFluctuationCalculated"								Type="1"	StringEnumValues="YesNoFull"
	Name="ShortTermFluctuation"											Type="1C"	Condition="ShortTermFluctuationCalculatedIsYes"
	Name="ShortTermFluctuationProbabilityCalculated"					Type="1"	StringEnumValues="YesNoFull"
	Name="ShortTermFluctuationProbability"								Type="1C"	Condition="ShortTermFluctuationProbabilityCalculatedIsYes"
	Name="CorrectedLocalizedDeviationFromNormalCalculated"				Type="1"	StringEnumValues="YesNoFull"
	Name="CorrectedLocalizedDeviationFromNormal"						Type="1C"	Condition="CorrectedLocalizedDeviationFromNormalCalculatedIsYes"
	Name="CorrectedLocalizedDeviationFromNormalProbabilityCalculated"	Type="1"	StringEnumValues="YesNoFull"
	Name="CorrectedLocalizedDeviationFromNormalProbability"				Type="1C"	Condition="CorrectedLocalizedDeviationFromNormalProbabilityCalculatedIsYes"
	Sequence="VisualFieldGlobalResultsIndexSequence"					Type="3"	VM="1-n"
		InvokeMacro="OphthalmicVisualFieldGlobalIndexMacro"
	SequenceEnd
ModuleEnd

Module="OphthalmicPatientClinicalInformationandTestLensParameters"
	Sequence="OphthalmicPatientClinicalInformationLeftEyeSequence"	Type="1C"	VM="1"	Condition="MeasurementLateralityLeftOrBoth"
		InvokeMacro="OphthalmicPatientClinicalInformationandTestLensParametersMacro"
	SequenceEnd
	Sequence="OphthalmicPatientClinicalInformationRightEyeSequence"	Type="1C"	VM="1"	Condition="MeasurementLateralityRightOrBoth"
		InvokeMacro="OphthalmicPatientClinicalInformationandTestLensParametersMacro"
	SequenceEnd
ModuleEnd

DefineMacro="OphthalmicPatientClinicalInformationandTestLensParametersMacro"
	Sequence="RefractiveParametersUsedOnPatientSequence"	Type="2"	VM="0-1"
		Name="SphericalLensPower"							Type="1"
		Name="CylinderLensPower"							Type="1"
		Name="CylinderAxis"									Type="1"
	SequenceEnd
	Name="PupilSize"										Type="2"
	Name="PupilDilated"										Type="2"	StringEnumValues="YesNoFull"
	Name="IntraOcularPressure"								Type="3"
	Sequence="VisualAcuityMeasurementSequence"				Type="3"	VM="1"
		InvokeMacro="VisualAcuityMeasurementsMacro"
	SequenceEnd
MacroEnd

Module="VLPhotographicEquipment"
	Name="CameraOwnerName"		Type="3"
	Name="LensSpecification"	Type="3"
	Name="LensMake"				Type="3"
	Name="LensModel"			Type="3"
	Name="LensSerialNumber"		Type="3"
ModuleEnd

Module="VLPhotographicAcquisition"
	Name="WhitePoint"							Type="3"
	Name="PrimaryChromaticities"				Type="3"
	Name="BatteryLevel"							Type="3"
	Name="ExposureTimeInSeconds"				Type="3"
	Name="FNumber"								Type="3"
	Name="OECFRows"								Type="3"
	Name="OECFColumns"							Type="3"
	Name="OECFColumnNames"						Type="3"
	Name="OECFValues"							Type="3"
	Name="SpatialFrequencyResponseRows"			Type="3"
	Name="SpatialFrequencyResponseColumns"		Type="3"
	Name="SpatialFrequencyResponseColumnNames"	Type="3"
	Name="SpatialFrequencyResponseValues"		Type="3"
	Name="ColorFilterArrayPatternRows"			Type="3"
	Name="ColorFilterArrayPatternColumns"		Type="3"
	Name="ColorFilterArrayPatternValues"		Type="3"
	Name="ExposureProgram"						Type="3"	BinaryEnumValues="ExposureProgram"
	Name="SpectralSensitivity"					Type="3"
	Name="PhotographicSensitivity"				Type="3"
	Name="SensitivityType"						Type="3"	BinaryEnumValues="SensitivityType"
	Name="StandardOutputSensitivity"			Type="3"
	Name="RecommendedExposureIndex"				Type="3"
	Name="ISOSpeed"								Type="3"
	Name="ISOSpeedLatitudeyyy"					Type="3"
	Name="ISOSpeedLatitudezzz"					Type="3"
	Name="EXIFVersion"							Type="3"
	Name="ShutterSpeedValue"					Type="3"
	Name="ApertureValue"						Type="3"
	Name="BrightnessValue"						Type="3"
	Name="ExposureBiasValue"					Type="3"
	Name="MaxApertureValue"						Type="3"
	Name="SubjectDistance"						Type="3"
	Name="MeteringMode"							Type="3"	BinaryEnumValues="MeteringMode"
	Name="LightSource"							Type="3"	BinaryEnumValues="LightSource"
	Name="FlashFiringStatus"					Type="3"	BinaryEnumValues="FlashFiringStatus"
	Name="FlashReturnStatus"					Type="3"	BinaryEnumValues="FlashReturnStatus"
	Name="FlashMode"							Type="3"	BinaryEnumValues="FlashMode"
	Name="FlashFunctionPresent"					Type="3"	BinaryEnumValues="FlashFunctionPresent"
	Name="FlashRedEyeMode"						Type="3"	BinaryEnumValues="FlashRedEyeMode"
	Name="FocalLength"							Type="3"
	Name="SubjectArea"							Type="3"
	Name="MakerNote"							Type="3"
	Name="Temperature"							Type="3"
	Name="Humidity"								Type="3"
	Name="Pressure"								Type="3"
	Name="WaterDepth"							Type="3"
	Name="Acceleration"							Type="3"
	Name="CameraElevationAngle"					Type="3"
	Name="FlashEnergy"							Type="3"
	Name="SubjectLocation"						Type="3"
	Name="PhotographicExposureIndex"			Type="3"
	Name="SensingMethod"						Type="3"	BinaryEnumValues="SensingMethod"
	Name="FileSource"							Type="3"	BinaryEnumValues="FileSource"
	Name="SceneType"							Type="3"	BinaryEnumValues="SceneType"
	Name="CustomRendered"						Type="3"	BinaryEnumValues="CustomRendered"
	Name="ExposureMode"							Type="3"	BinaryEnumValues="ExposureMode"
	Name="WhiteBalance"							Type="3"	BinaryEnumValues="WhiteBalance"
	Name="DigitalZoomRatio"						Type="3"
	Name="FocalLengthIn35mmFilm"				Type="3"
	Name="SceneCaptureType"						Type="3"	BinaryEnumValues="SceneCaptureType"
	Name="GainControl"							Type="3"	BinaryEnumValues="GainControl"
	Name="Contrast"								Type="3"	BinaryEnumValues="Contrast"
	Name="Saturation"							Type="3"	BinaryEnumValues="Saturation"
	Name="Sharpness"							Type="3"	BinaryEnumValues="Sharpness"
	Name="DeviceSettingDescription"				Type="3"
	Name="SubjectDistanceRange"					Type="3"	BinaryEnumValues="SubjectDistanceRange"
	Name="SelfTimerMode"						Type="3"
	Name="InteroperabilityIndex"				Type="3"	StringDefinedTerms="InteroperabilityIndex"
	Name="InteroperabilityVersion"				Type="3"
ModuleEnd

Module="VLPhotographicGeolocation"
	Name="GPSVersionID"			Type="3"
	Name="GPSLatitudeRef"		Type="3"	StringEnumValues="LatitudeRef"
	Name="GPSLatitude"			Type="3"
	Name="GPSLongitudeRef"		Type="3"	StringEnumValues="LongitudeRef"
	Name="GPSLongitude"			Type="3"
	Name="GPSAltitudeRef"		Type="3"
	Name="GPSAltitude"			Type="3"
	Name="GPSTimeStamp"			Type="3"
	Name="GPSSatellites"		Type="3"
	Name="GPSStatus"			Type="3"	StringEnumValues="GPSStatus"
	Name="GPSMeasureMode"		Type="3"	StringEnumValues="GPSMeasureMode"
	Name="GPSDOP"				Type="3"
	Name="GPSSpeedRef"			Type="3"	StringEnumValues="GPSSpeedUnits"
	Name="GPSSpeed"				Type="3"
	Name="GPSTrackRef"			Type="3"	StringEnumValues="GPSDirection"
	Name="GPSTrack"				Type="3"
	Name="GPSImgDirectionRef"	Type="3"	StringEnumValues="GPSDirection"
	Name="GPSImgDirection"		Type="3"
	Name="GPSMapDatum"			Type="3"
	Name="GPSDestLatitudeRef"	Type="3"	StringEnumValues="LatitudeRef"
	Name="GPSDestLatitude"		Type="3"
	Name="GPSDestLongitudeRef"	Type="3"	StringEnumValues="LongitudeRef"
	Name="GPSDestLongitude"		Type="3"
	Name="GPSDestBearingRef"	Type="3"	StringEnumValues="GPSDirection"
	Name="GPSDestBearing"		Type="3"
	Name="GPSDestDistanceRef"	Type="3"	StringEnumValues="GPSDistanceUnits"
	Name="GPSDestDistance"		Type="3"
	Name="GPSProcessingMethod"	Type="3"
	Name="GPSAreaInformation"	Type="3"
	Name="GPSDateStamp"			Type="3"
	Name="GPSDifferential"		Type="3"
ModuleEnd

Module="DermoscopicImage"
	Name="RecognizableVisualFeatures"					Type="1"	StringEnumValues="YesNoFull"
	Name="LightSourcePolarization"						Type="2"	StringEnumValues="LightSourcePolarization"
	Name="EmitterColorTemperature"						Type="2"
	Name="ContactMethod"								Type="2"	StringEnumValues="ContactMethod"
	Name="ImmersionMedia"								Type="2C"	Condition="ContactMethodIsContact"	StringEnumValues="ImmersionMedia"
	Name="OpticalMagnificationFactor"					Type="2"
	Name="PartialView"									Type="3"	StringEnumValues="YesNoFull"
	Name="PartialViewDescription"						Type="3"
	Name="TrackingID"									Type="1C"	Condition="TrackingUIDIsPresent"
	Name="TrackingUID"									Type="1C"	Condition="TrackingIDIsPresent"
ModuleEnd

Module="MicroscopyBulkSimpleAnnotationsSeries"
	Name="Modality"												Type="1"			StringEnumValues="AnnotationModality"
	Name="SeriesNumber"											Type="1"
	Sequence="ReferencedPerformedProcedureStepSequence"			Type="1C"	VM="1"	Condition="SeriesNeedReferencedPerformedProcedureStepSequence"
		InvokeMacro="SOPInstanceReferenceMacro"
	SequenceEnd
ModuleEnd

Module="MicroscopyBulkSimpleAnnotations"
	InvokeMacro="ContentIdentificationMacro"
	Name="ContentDate"													Type="1"
	Name="ContentTime"													Type="1"
	Name="AnnotationCoordinateType"										Type="1"															StringEnumValues="AnnotationCoordinateType"
	Name="PixelOriginInterpretation"									Type="1C"				Condition="AnnotationCoordinateTypeIs2D"	StringEnumValues="PixelOriginInterpretation"
	Sequence="ReferencedImageSequence"									Type="1C"	VM="1"		Condition="AnnotationCoordinateTypeIs2D"	mbpo="true"
		InvokeMacro="ImageSOPInstanceReferenceMacro"
	SequenceEnd
	Sequence="AnnotationGroupSequence"									Type="1"	VM="1-n"
		Name="AnnotationGroupNumber"									Type="1"
		Name="AnnotationGroupUID"										Type="1"
		Name="AnnotationGroupLabel"										Type="1"
		Name="AnnotationGroupDescription"								Type="3"
		Name="AnnotationGroupGenerationType"							Type="1"				StringEnumValues="AnnotationGroupGenerationType"
		Sequence="AnnotationGroupAlgorithmIdentificationSequence"		Type="1C"	VM="1-n"	Condition="AnnotationGroupGenerationTypeIsAutomaticOrSemiautomatic"
			InvokeMacro="AlgorithmIdentificationMacro"
		SequenceEnd
		Sequence="AnnotationPropertyCategoryCodeSequence"				Type="1"	VM="1"
			InvokeMacro="CodeSequenceMacro"
		SequenceEnd
		Sequence="AnnotationPropertyTypeCodeSequence"					Type="1"	VM="1"
			InvokeMacro="CodeSequenceMacro"
			Sequence="AnnotationPropertyTypeModifierCodeSequence"		Type="3"	VM="1"
				InvokeMacro="CodeSequenceMacro"
			SequenceEnd
		SequenceEnd
		Name="NumberOfAnnotations"										Type="1"
		Name="GraphicType"												Type="1"				StringEnumValues="GraphicTypeForMicroscopyBulkSimpleAnnotations"
		Name="AnnotationAppliesToAllOpticalPaths"						Type="1"				StringEnumValues="YesNoFull"
		Name="ReferencedOpticalPathIdentifier"							Type="1C"				Condition="AnnotationAppliesToAllOpticalPathsIsNo"
		Name="AnnotationAppliesToAllZPlanes"							Type="1C"				Condition="AnnotationCoordinateTypeIs3D"	StringEnumValues="YesNoFull"
		Name="CommonZCoordinateValue"									Type="1C"				NoCondition=""	# whether all Z coordinates same is real world
		Verify="CommonZCoordinateValue"															Condition="AnnotationCoordinateTypeIsNot3D"	ThenErrorMessage="Only valid for AnnotationCoordinateType of 3D" ShowValueWithMessage="true"
		Name="PointCoordinatesData"										Type="1C"				Condition="DoublePointCoordinatesDataNotPresent"
		Name="DoublePointCoordinatesData"								Type="1C"				Condition="PointCoordinatesDataNotPresent"
		Name="LongPrimitivePointIndexList"								Type="1C"				Condition="GraphicTypeIsPOLYLINEOrPOLYGON"
		Name="RecommendedDisplayCIELabValue"							Type="3"
		Sequence="MeasurementsSequence"									Type="3"	VM="1-n"
			Sequence="ConceptNameCodeSequence"							Type="1"	VM="1"
				InvokeMacro="CodeSequenceMacro"
			SequenceEnd
			Sequence="MeasurementUnitsCodeSequence"						Type="1"	VM="1"
				InvokeMacro="CodeSequenceMacro"
			SequenceEnd
			Sequence="MeasurementValuesSequence"						Type="1"	VM="1-n"
				Name="FloatingPointValues"								Type="1"
				Name="AnnotationIndexList"								Type="1C"				NoCondition=""	# whether only subset of annotations rather than all is real world
			SequenceEnd
		SequenceEnd
	SequenceEnd
ModuleEnd

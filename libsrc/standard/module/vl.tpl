Module="VLImage"
	Name="ImageType"									Type="1"	ValueSelector="0"	StringEnumValues="ImageType1"
	Verify="ImageType"									Type="1"	ValueSelector="1"	StringEnumValues="ImageType2"
	Verify="ImageType"									Type="1"	ValueSelector="2"	StringEnumValues="VLImageType3"
	Name="PhotometricInterpretation"					Type="1"	StringEnumValues="PhotometricInterpretationMonochrome2OrRGBorYBRFULL422orYBRPARTIAL420orYBRRCTorYBRICT"
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
	Sequence="AnatomicRegionSequence"					Type="1C"	VM="1"	Condition="MultiFrameIODAndNotSpecimen" mbpo="true"
		InvokeMacro="CodeSequenceMacro"
		Sequence="AnatomicRegionModifierSequence"		Type="3"	VM="1-n"
			InvokeMacro="CodeSequenceMacro"							BaselineContextID="2"
		SequenceEnd
	SequenceEnd
	InvokeMacro="PrimaryAnatomicStructureMacro"
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
	Name="PixelRepresentation"							Type="1"	BinaryEnumValues="PixelRepresentationUnsigned"
	Name="PlanarConfiguration"							Type="1C"	BinaryEnumValues="PlanarConfigurationIsColorByPixel"	Condition="SamplesPerPixelGreaterThanOne"
	Name="PixelSpacing"									Type="1C"	NoCondition=""		# too hard to check code in Acquisition Device Type Code Sequence :(
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
	Verify="LossyImageCompressionMethod"							Condition="LossyImageCompressionMethodInconsistentWithTransferSyntax"	ThenWarningMessage="method inconsistent with transfer syntax" ShowValueWithMessage="true"
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
	Name="HorizontalFieldOfView"						Type="2"	NotZeroWarning=""
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
	InvokeMacro="OphthalmicAcquisitionParametersMacro"
ModuleEnd

Module="OcularRegionImaged"
	Name="ImageLaterality"								Type="1"	StringEnumValues="OphthalmologyImageLaterality"
	Sequence="RelativeImagePositionCodeSequence"		Type="3"	VM="1"
		InvokeMacro="CodeSequenceMacro"								BaselineContextID="4207"
	SequenceEnd
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
	Verify="LossyImageCompressionMethod"							Condition="LossyImageCompressionMethodInconsistentWithTransferSyntax"	ThenWarningMessage="method inconsistent with transfer syntax" ShowValueWithMessage="true"
	Name="BurnedInAnnotation"							Type="1"	StringEnumValues="NoFull"
	Name="RecognizableVisualFeatures"					Type="3"	StringEnumValues="YesNoFull"
	Name="ConcatenationFrameOffsetNumber"				Type="1"	BinaryEnumValues="Zero"
	Name="InConcatenationNumber"						Type="1"	BinaryEnumValues="One"
	Name="InConcatenationTotalNumber"					Type="1"	BinaryEnumValues="One"
	Name="ImageComments"								Type="3"
ModuleEnd

Module="OphthalmicTomographyAcquisitionParameters"
	Name="AxialLengthOfTheEye"								Type="2"
	Name="HorizontalFieldOfView"						Type="2"
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
	Verify="ImageType"									Type="1"	ValueSelector="2"	StringEnumValues="WholeSlideImageType3"
	Verify="ImageType"									Type="1"	ValueSelector="3"	StringEnumValues="WholeSlideImageType4"
	Name="ImagedVolumeWidth"							Type="1"	NotZeroError=""
	Name="ImagedVolumeHeight"							Type="1"	NotZeroError=""
	Name="ImagedVolumeDepth"							Type="1"	NotZeroError=""
	Name="TotalPixelMatrixColumns"						Type="1"	NotZeroError=""
	Name="TotalPixelMatrixRows"							Type="1"	NotZeroError=""
	Sequence="TotalPixelMatrixOriginSequence"			Type="1"	VM="1"
		Name="XOffsetInSlideCoordinateSystem"			Type="1"
		Name="YOffsetInSlideCoordinateSystem"			Type="1"
	SequenceEnd
	Name="ImageOrientationSlide"						Type="1"
	Name="SamplesPerPixel"								Type="1"	BinaryEnumValues="SamplesPerPixelIsOneOrThree"
	Verify="SamplesPerPixel"										Condition="PhotometricInterpretationNeedsOneSample"	BinaryEnumValues="One"
	Verify="SamplesPerPixel"										Condition="PhotometricInterpretationNeedsThreeSamples"	BinaryEnumValues="Three"
	Name="PhotometricInterpretation"					Type="1"	StringEnumValues="PhotometricInterpretationMonochrome2OrRGBorYBRFULL422orYBRRCTorYBRICT"
	Name="PlanarConfiguration"							Type="1C"	BinaryEnumValues="PlanarConfigurationIsColorByPixel"	Condition="SamplesPerPixelGreaterThanOne"
	Name="NumberOfFrames"								Type="1"
	Verify="NumberOfFrames"											Condition="ImageTypeValue3LocalizerOrLabel"	BinaryEnumValues="One"
	Name="BitsAllocated"								Type="1"	BinaryEnumValues="BitsAre8Or16"
	Name="BitsStored"									Type="1"	BinaryEnumValues="BitsAre8Or16"
	Name="HighBit"										Type="1"	BinaryEnumValues="BitsAre7Or15"
	Name="PixelRepresentation"							Type="1"	BinaryEnumValues="PixelRepresentationUnsigned"
	Name="AcquisitionDateTime"							Type="1"
	Name="AcquisitionDuration"							Type="1"
	Name="LossyImageCompression"						Type="1"	StringEnumValues="LossyImageCompression"
	Name="LossyImageCompressionRatio"					Type="1C"	Condition="LossyImageCompressionIs01"	NotZeroError=""
	Name="LossyImageCompressionMethod"					Type="1C"	StringDefinedTerms="LossyImageCompressionMethod"	Condition="LossyImageCompressionIs01"
	Verify="LossyImageCompressionMethod"							Condition="LossyImageCompressionMethodInconsistentWithTransferSyntax"	ThenWarningMessage="method inconsistent with transfer syntax" ShowValueWithMessage="true"
	Name="PresentationLUTShape"							Type="1C"	Condition="PhotometricInterpretationIsMonochrome2"	StringEnumValues="IdentityPresentationLUTShape"
	Name="RescaleSlope"									Type="1C"	Condition="PhotometricInterpretationIsMonochrome2"	BinaryEnumValues="One"
	Name="RescaleIntercept"								Type="1C"	Condition="PhotometricInterpretationIsMonochrome2"	BinaryEnumValues="Zero"
	Name="VolumetricProperties"							Type="1"	StringEnumValues="VolumetricPropertiesVolume"
	Name="SpecimenLabelInImage"							Type="1"	StringEnumValues="YesNoFull"
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
	Sequence="OpticalPathSequence"						Type="1"	VM="1-n"
		Name="OpticalPathIdentifier"					Type="1"
		Name="OpticalPathDescription"					Type="3"
		Sequence="IlluminatorTypeCodeSequence"			Type="3"	VM="1"
			InvokeMacro="CodeSequenceMacro"
		SequenceEnd
		Name="IlluminationWaveLength"					Type="1C"	Condition="IlluminationColorCodeSequenceNotPresent"	mbpo="true"
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

Module="MultiResolutionNavigation"
	Sequence="ReferencedImageNavigationSequence"		Type="1"	VM="1-n"
		InvokeMacro="SOPInstanceReferenceMacro"
		Name="ReferencedFrameNumber"					Type="1"	VM="1"	NotZeroError=""
		Name="TopLeftHandCornerOfLocalizerArea"			Type="1"
		Name="BottomRightHandCornerOfLocalizerArea"		Type="1"
		Name="PixelSpacing"								Type="1"
		Name="ZOffsetInSlideCoordinateSystem"			Type="1"
		Name="SamplesPerPixel"							Type="1"
		Name="OpticalPathIdentifier"					Type="1"
	SequenceEnd
ModuleEnd

Module="SlideLabel"
	Name="BarcodeValue"									Type="2"
	Name="LabelText"									Type="2"
ModuleEnd

Module="MultiFrameFunctionalGroupsForWholeSlideMicroscopy"
	Sequence="SharedFunctionalGroupsSequence"	Type="1"	VM="1"
		InvokeMacro="PixelMeasuresMacro"
		InvokeMacro="ReferencedImageMacro"				Condition="ReferencedImageMacroOKInSharedFunctionalGroupSequence"
		InvokeMacro="DerivationImageMacro"				Condition="DerivationImageMacroOKInSharedFunctionalGroupSequence"
		InvokeMacro="RealWorldValueMappingMacro"		Condition="RealWorldValueMappingMacroOKInSharedFunctionalGroupSequence"
		InvokeMacro="PlanePositionSlideMacro"			Condition="PlanePositionSlideSequenceNotInPerFrameFunctionalGroupSequence"
		InvokeMacro="OpticalPathIdentificationMacro"	Condition="OpticalPathIdentificationSequenceNotInPerFrameFunctionalGroupSequence"
		InvokeMacro="SpecimenReferenceMacro"			Condition="SpecimenReferenceMacroOKInSharedFunctionalGroupSequence"
	SequenceEnd

	Sequence="PerFrameFunctionalGroupsSequence"	Type="1"	VM="1-n"
		InvokeMacro="FrameContentMacro"
		InvokeMacro="ReferencedImageMacro"				Condition="ReferencedImageMacroOKInPerFrameFunctionalGroupSequence"
		InvokeMacro="DerivationImageMacro"				Condition="DerivationImageMacroOKInPerFrameFunctionalGroupSequence"
		InvokeMacro="RealWorldValueMappingMacro"		Condition="RealWorldValueMappingMacroOKInPerFrameFunctionalGroupSequence"
		InvokeMacro="PlanePositionSlideMacro"			Condition="PlanePositionSlideSequenceNotInSharedFunctionalGroupSequence"
		InvokeMacro="OpticalPathIdentificationMacro"	Condition="OpticalPathIdentificationSequenceNotInSharedFunctionalGroupSequence"
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
		Sequence="OphthalmicAxialLengthMeasurementsSegmentalLengthSequence"			Type="1C"	VM="1"		Condition="OphthalmicAxialLengthMeasurementsTypeIsSegmentalLength"
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
		Name="SignalToNoiseRatio"										Type="1C"				Condition="OphthalmicAxialLengthMeasurementsTypeAboveIsTotalLength"
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
	Name="CornealSize"												Type="3"
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
	Sequence="IOLFormulaCodeSequence"								Type="1"	VM="1"
		InvokeMacro="CodeSequenceMacro"														DefinedContextID="4236"
	SequenceEnd
	Name="IOLFormulaDetail"											Type="3"
	InvokeMacro="IOLOphthalmicAxialLengthMacro"
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
	Name="IOLManufacturer"							Type="1"
	Name="ImplantName"								Type="1"
	Sequence="LensConstantSequence"					Type="1"	VM="1-n"
		Sequence="ConceptNameCodeSequence"			Type="1"	VM="1"
			InvokeMacro="CodeSequenceMacro"									DefinedContextID="4237"
		SequenceEnd
		Name="NumericValue"	Type="1"
	SequenceEnd
	Sequence="IOLPowerSequence"						Type="1"	VM="1-n"
		Name="IOLPower"								Type="1"
		Name="PredictedRefractiveError"				Type="1"
		Name="ImplantPartNumber"					Type="2"
	SequenceEnd
	Name="IOLPowerForExactEmmetropia"				Type="2"
	Name="IOLPowerForExactTargetRefraction"			Type="2"
MacroEnd

DefineMacro="OphthalmicAxialMeasurementsQualityImageSOPInstanceReferenceMacro"
	Name="ReferencedSOPClassUID"	Type="1"	StringEnumValues="OphthalmicAxialMeasurementsQualityImageSOPClassUIDs"
	Name="ReferencedSOPInstanceUID"	Type="1"
	Name="ReferencedFrameNumber"	Type="1"
MacroEnd


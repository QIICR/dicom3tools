Module="XRayAcquisitionDose"
	Name="KVP"									Type="3"	NotZeroWarning=""
	
	Name="XRayTubeCurrent"						Type="3"	NotZeroWarning=""
	Name="XRayTubeCurrentInuA"					Type="3"	NotZeroWarning=""
	Verify="XRayTubeCurrentInmA"							Condition="XRayTubeCurrentInmAIsPresentAndOthersAreNot" ThenErrorMessage="Attribute should not be used with Module <XRayAcquisitionDose> - use XRayTubeCurrent and/or XRayTubeCurrentInuA instead of"
	
	Name="ExposureTime"							Type="3"	NotZeroWarning=""
	Name="ExposureTimeInuS"						Type="3"	NotZeroWarning=""
	Verify="ExposureTimeInms"								Condition="ExposureTimeInmsIsPresentAndOthersAreNot" ThenErrorMessage="Attribute should not be used with Module <XRayAcquisitionDose> - use ExposureTime and/or ExposureTimeInuS instead of"
	
	Name="Exposure"								Type="3"	NotZeroWarning=""
	Name="ExposureInuAs"						Type="3"	NotZeroWarning=""
	Verify="ExposureInmAs"									Condition="ExposureInmAsIsPresentAndOthersAreNot" ThenErrorMessage="Attribute should not be used with Module <XRayAcquisitionDose> - use Exposure and/or ExposureInuAs instead of"
	
	Name="DistanceSourceToDetector"				Type="3"	NotZeroWarning=""
	Name="DistanceSourceToPatient"				Type="3"	NotZeroWarning=""
	Name="ImageAndFluoroscopyAreaDoseProduct"	Type="3"	NotZeroWarning=""
	Name="BodyPartThickness"					Type="3"	NotZeroWarning=""
	Name="RelativeXRayExposure"					Type="3"	NotZeroWarning=""
	Name="EntranceDose"							Type="3"	NotZeroWarning=""
	Name="EntranceDoseInmGy"					Type="3"	NotZeroWarning=""
	Name="ExposedArea"							Type="3"
	Name="DistanceSourceToEntrance"				Type="3"	NotZeroWarning=""
	Name="CommentsOnRadiationDose"				Type="3"
	Name="XRayOutput"							Type="3"	NotZeroWarning=""
	Name="HalfValueLayer"						Type="3"	NotZeroWarning=""
	Name="OrganDose"							Type="3"	NotZeroWarning=""
	Name="OrganExposed"							Type="3"	StringDefinedTerms="OrganExposed"
	Name="AnodeTargetMaterial"					Type="3"	StringDefinedTerms="AnodeTargetMaterial"
	InvokeMacro="XRayFiltrationMacro"
	Name="RectificationType"					Type="3"	StringDefinedTerms="RectificationType"
	InvokeMacro="ExposureIndexMacro"
ModuleEnd

Module="XRayGeneration"
	Name="KVP"									Type="3"	NotZeroWarning=""
	
	Name="XRayTubeCurrent"						Type="3"	NotZeroWarning=""
	Name="XRayTubeCurrentInuA"					Type="3"	NotZeroWarning=""
	Verify="XRayTubeCurrentInmA"							Condition="XRayTubeCurrentInmAIsPresentAndOthersAreNot" ThenErrorMessage="Attribute should not be used with Module <XRayGeneration> - use XRayTubeCurrent and/or XRayTubeCurrentInuA instead of"
	
	Name="ExposureTime"							Type="3"	NotZeroWarning=""
	Name="ExposureTimeInuS"						Type="3"	NotZeroWarning=""
	Verify="ExposureTimeInms"								Condition="ExposureTimeInmsIsPresentAndOthersAreNot" ThenErrorMessage="Attribute should not be used with Module <XRayGeneration> - use ExposureTime and/or ExposureTimeInuS instead of"
	
	Name="Exposure"								Type="3"	NotZeroWarning=""
	Name="ExposureInuAs"						Type="3"	NotZeroWarning=""
	Verify="ExposureInmAs"									Condition="ExposureInmAsIsPresentAndOthersAreNot" ThenErrorMessage="Attribute should not be used with Module <XRayGeneration> - use Exposure and/or ExposureInuAs instead of"
	
	Name="ExposureControlMode"					Type="3"	StringDefinedTerms="ExposureControlMode"
	Name="ExposureControlModeDescription"		Type="3"
	Name="ExposureStatus"						Type="3"	StringDefinedTerms="ExposureStatus"
	Name="PhototimerSetting"					Type="3"
	Name="FocalSpots"							Type="3"
	Name="AnodeTargetMaterial"					Type="3"	StringDefinedTerms="AnodeTargetMaterial"
	Name="RectificationType"					Type="3"	StringDefinedTerms="RectificationType"
	Name="GeneratorID"							Type="3"
ModuleEnd

DefineMacro="XRayFiltrationMacro"
	Name="FilterType"							Type="3"	StringDefinedTerms="DXFilterType"
	Name="FilterMaterial"						Type="3"	StringDefinedTerms="DXFilterMaterial"
	Name="FilterThicknessMaximum"				Type="3"	NotZeroWarning=""
	Name="FilterThicknessMinimum"				Type="3"	NotZeroWarning=""
	Name="FilterBeamPathLengthMinimum"			Type="3"	NotZeroWarning=""
	Name="FilterBeamPathLengthMaximum"			Type="3"	NotZeroWarning=""
MacroEnd

Module="XRayFiltration"
	InvokeMacro="XRayFiltrationMacro"
ModuleEnd

DefineMacro="XRayGridDescriptionMacro" InformationEntity="Image"
	Name="GridAbsorbingMaterial"				Type="3"
	Name="GridSpacingMaterial"					Type="3"
	Name="GridThickness"						Type="3"	NotZeroWarning=""
	Name="GridPitch"							Type="3"	NotZeroWarning=""
	Name="GridAspectRatio"						Type="3"	NotZeroWarning=""
	Name="GridPeriod"							Type="3"	NotZeroWarning=""
	Name="GridFocalDistance"					Type="3"	NotZeroWarning=""
	Name="GridID"								Type="3"
MacroEnd

Module="XRayGrid"
	Name="Grid"									Type="3"	StringDefinedTerms="XRayGrid"
	InvokeMacro="XRayGridDescriptionMacro"
ModuleEnd

Module="DXSeries"
	Name="Modality"										Type="1"	StringEnumValues="DXModality"
	Sequence="ReferencedPerformedProcedureStepSequence"	Type="1C"	VM="1"	Condition="SeriesNeedReferencedPerformedProcedureStepSequence"
		InvokeMacro="SOPInstanceReferenceMacro"
	SequenceEnd
	Name="PresentationIntentType"						Type="1"	StringEnumValues="PresentationIntentType"
	Verify="PresentationIntentType"									Condition="IsForProcessingSOPClass"	StringEnumValues="ForProcessing"
	Verify="PresentationIntentType"									Condition="IsForPresentationSOPClass"	StringEnumValues="ForPresentation"
ModuleEnd

Module="DXAnatomyImaged"
	Name="ImageLaterality"								Type="1"	StringEnumValues="ImageLaterality"
	InvokeMacro="GeneralAnatomyRequiredMacro"
ModuleEnd

Module="DXImage"
	Name="ImageType"									Type="1"	ValueSelector="0"	StringEnumValues="ImageType1"
	Verify="ImageType"												ValueSelector="1"	StringEnumValues="ImageType2"
	Verify="ImageType"												ValueSelector="2"	StringEnumValues="DXImageType3"
	Name="SamplesPerPixel"								Type="1"	BinaryEnumValues="SamplesPerPixelIsOne"
	Name="PhotometricInterpretation"					Type="1"	StringEnumValues="PhotometricInterpretationMonochrome"
	Name="BitsAllocated"								Type="1"	BinaryEnumValues="BitsAre8Or16"
	Name="BitsStored"									Type="1"	BinaryEnumValues="BitsAre6To16"
	Name="HighBit"										Type="1"	BinaryEnumValues="BitsAre5To15"
	Name="PixelRepresentation"							Type="1"	BinaryEnumValues="PixelRepresentationUnsigned"
	Name="PixelIntensityRelationship"					Type="1"	StringEnumValues="DXPixelIntensityRelationship"
	Name="PixelIntensityRelationshipSign"				Type="1"	BinaryEnumValues="PixelIntensityRelationshipSign"
	Name="RescaleIntercept"								Type="1"	BinaryEnumValues="Zero"
	Name="RescaleSlope"									Type="1"	BinaryEnumValues="One"
	Name="RescaleType"									Type="1"	StringEnumValues="ModalityLUTTypeUnspecified"
	Name="PresentationLUTShape"							Type="1"	StringEnumValues="DXPresentationLUTShape"
	Name="LossyImageCompression"						Type="1"	StringEnumValues="LossyImageCompression"
	Name="LossyImageCompressionRatio"					Type="1C"	NoCondition=""	NotZeroError=""
	Name="DerivationDescription"						Type="3"
	Name="AcquisitionDeviceProcessingDescription"		Type="3"
	Name="AcquisitionDeviceProcessingCode"				Type="3"
	Name="PatientOrientation"							Type="1C"	Condition="DXPatientOrientationRequired" mbpo="true"
	Name="CalibrationImage"								Type="3"	StringEnumValues="YesNoFull"
	Name="BurnedInAnnotation"							Type="1"	StringEnumValues="YesNoFull"
	Name="RecognizableVisualFeatures"					Type="3"	StringEnumValues="YesNoFull"
	Sequence="VOILUTSequence"							Type="1C"	VM="1-n"	Condition="ForPresentationAndWindowCenterNotPresent" mbpo="true"
		Name="LUTDescriptor"							Type="1"
		Verify="LUTDescriptor"										ValueSelector="2"	BinaryEnumValues="BitsAre10To16"
		Name="LUTExplanation"							Type="3"
		Name="LUTData"									Type="1"
	SequenceEnd
	Verify="VOILUTSequence"											Condition="VOILUTSequencePresentAndPresentationIntentTypeIsNotForPresentation" ThenErrorMessage="May only be present in For Presentation images"
	Name="WindowCenter"									Type="1C"	Condition="ForPresentationAndVOILUTSequenceNotPresent" mbpo="true"
	Verify="WindowCenter"											Condition="WindowCenterPresentAndPresentationIntentTypeIsNotForPresentation" ThenErrorMessage="May only be present in For Presentation images"
	Name="WindowWidth"									Type="1C"	Condition="WindowCenterPresent"	NotZeroError=""
	Verify="WindowWidth"											Condition="WindowWidthIsNegative"	ThenErrorMessage="Not permitted to be negative" ShowValueWithMessage="true"
	Name="WindowCenterWidthExplanation"					Type="3"
ModuleEnd

DefineMacro="DigitalXRayDetectorMacro" InformationEntity="Image"
	Name="DetectorType"									Type="2"	StringDefinedTerms="DetectorType"
	Name="DetectorConfiguration"						Type="3"	StringDefinedTerms="DetectorConfiguration"
	Name="DetectorDescription"							Type="3"
	Name="DetectorMode"									Type="3"
	Name="DetectorID"									Type="3"
	Name="DateOfLastDetectorCalibration"				Type="3"
	Name="TimeOfLastDetectorCalibration"				Type="3"
	Name="ExposuresOnDetectorSinceLastCalibration"		Type="3"
	Name="ExposuresOnDetectorSinceManufactured"			Type="3"
	Name="DetectorTimeSinceLastExposure"				Type="3"
	Name="DetectorBinning"								Type="3"
	Name="DetectorManufacturerName"						Type="3"
	Name="DetectorManufacturerModelName"				Type="3"
	Name="DetectorConditionsNominalFlag"				Type="3"	StringEnumValues="YesNoFull"
	Name="DetectorTemperature"							Type="3"
	Name="Sensitivity"									Type="3"	NotZeroWarning=""
	Name="DetectorElementPhysicalSize"					Type="3"	NotZeroError=""
	Name="DetectorElementSpacing"						Type="3"	NotZeroError=""
	Name="DetectorActiveShape"							Type="3"	StringEnumValues="DXShape"
	Name="DetectorActiveDimensions"						Type="3"
	Name="DetectorActiveOrigin"							Type="3"
	InvokeMacro="ExposureIndexMacro"
MacroEnd

Module="DXDetector"
	InvokeMacro="DigitalXRayDetectorMacro"
	Name="DetectorActiveTime"							Type="3"
	Name="DetectorActivationOffsetFromExposure"			Type="3"
	Name="FieldOfViewShape"								Type="3"	StringEnumValues="DXShape"
	Name="FieldOfViewDimensions"						Type="3"	NotZeroError=""
	Name="FieldOfViewOrigin"							Type="1C"	Condition="FieldOfViewRotationOrFieldOfViewHorizontalFlipPresent"
	Name="FieldOfViewRotation"							Type="1C"	Condition="FieldOfViewHorizontalFlipPresent"	StringEnumValues="DXFieldOfViewRotation"
	Name="FieldOfViewHorizontalFlip"					Type="1C"	Condition="FieldOfViewRotationPresent"		StringEnumValues="YesNoFull"
	Name="ImagerPixelSpacing"							Type="1"	NotZeroError=""
	InvokeMacro="BasicPixelSpacingCalibrationMacro"
	Name="CassetteID"									Type="3"
	Name="PlateID"										Type="3"
ModuleEnd

Module="DXPositioning"
	Sequence="ProjectionEponymousNameCodeSequence"		Type="3"	VM="1"
		InvokeMacro="CodeSequenceMacro"								BaselineContextID="4012"
	SequenceEnd
	Name="PatientPosition"								Type="3"	StringDefinedTerms="PatientPosition"
	Name="ViewPosition"									Type="3"
	Verify="ViewPosition"											Condition="IsHuman"		StringDefinedTerms="ViewPositionHuman"
	Verify="ViewPosition"											Condition="IsAnimal"	StringDefinedTerms="ViewPositionAnimal"
	Sequence="ViewCodeSequence"							Type="3"	VM="1"
		InvokeMacro="CodeSequenceMacro"								BaselineContextID="4010"
		Sequence="ViewModifierCodeSequence"				Type="3"	VM="1-n"
			InvokeMacro="CodeSequenceMacro"							BaselineContextID="4011"
		SequenceEnd
	SequenceEnd
	Verify="ViewCodeSequence"										Condition="ViewCodeSequenceAbsentOrEmptyButViewPositionHasValue"	ThenWarningMessage="ViewCodeSequence is empty or absent, but view is known since ViewPosition has a value"
	Sequence="ViewModifierCodeSequence"					Type="1C"	VM="1-n"	Condition="Never"
	SequenceEnd
	Sequence="PatientOrientationCodeSequence"			Type="3"	VM="1"
		InvokeMacro="CodeSequenceMacro"								BaselineContextID="19"
		Sequence="PatientOrientationModifierCodeSequence"	Type="3"	VM="1"
			InvokeMacro="CodeSequenceMacro"							BaselineContextID="20"
		SequenceEnd
	SequenceEnd
	Sequence="PatientOrientationModifierCodeSequence"	Type="1C"	VM="1"	Condition="Never"
	SequenceEnd
	Sequence="PatientGantryRelationshipCodeSequence"	Type="3"	VM="1"
		InvokeMacro="CodeSequenceMacro"								BaselineContextID="21"
	SequenceEnd
	Name="DistanceSourceToPatient"						Type="3"	NotZeroWarning=""
	Name="DistanceSourceToDetector"						Type="3"	NotZeroWarning=""
	Name="EstimatedRadiographicMagnificationFactor"		Type="3"
	Name="PositionerType"								Type="2"	StringDefinedTerms="DXPositionerType"
	Name="PositionerPrimaryAngle"						Type="3"
	Name="PositionerSecondaryAngle"						Type="3"
	Name="DetectorPrimaryAngle"							Type="3"
	Name="DetectorSecondaryAngle"						Type="3"
	Name="ColumnAngulation"								Type="3"
	Name="TableType"									Type="3"	StringDefinedTerms="DXTableType"
	Name="TableAngle"									Type="3"
	Name="BodyPartThickness"							Type="3"	NotZeroWarning=""
	Name="CompressionForce"								Type="3"
	Name="PaddleDescription"							Type="3"
ModuleEnd

Module="MammographySeries"
	Name="Modality"										Type="1"	StringEnumValues="MammographyModality"
	Sequence="RequestAttributesSequence"				Type="3"	VM="1-n"
		InvokeMacro="RequestAttributesMacro"
	SequenceEnd
ModuleEnd

Module="MammographyImage"
	Name="ImageType"									Type="1"	ValueSelector="2"	StringEnumValues="MammoImageType3"
	Verify="ImageType"												ValueSelector="3"	StringDefinedTerms="MammoImageType4"
	Verify="ImageType"												ValueSelector="4"	StringDefinedTerms="MammoImageType5"
	Name="PositionerType"								Type="1"	StringEnumValues="MammographyPositionerType"
	Name="DistanceSourceToPatient"						Type="3"	NotZeroWarning=""
	Name="DistanceSourceToDetector"						Type="3"	NotZeroWarning=""
	Name="PositionerPrimaryAngle"						Type="3"
	Name="PositionerPrimaryAngleDirection"				Type="3"	StringEnumValues="PositionerPrimaryAngleDirection"
	Name="PositionerSecondaryAngle"						Type="3"
	Name="ImageLaterality"								Type="1"	StringEnumValues="MammographyImageLaterality"
	Name="OrganExposed"									Type="1"	StringDefinedTerms="MammographyOrganExposed"
	Name="BreastImplantPresent"							Type="3"	StringEnumValues="YesNoFull"
	Name="PartialView"									Type="3"	StringEnumValues="YesNoFull"
	Name="PartialViewDescription"						Type="3"
	Sequence="PartialViewCodeSequence"					Type="3"	VM="1-2"
		InvokeMacro="CodeSequenceMacro"								DefinedContextID="4005"
	SequenceEnd
	InvokeMacro="GeneralAnatomyMandatoryMacro"
	Sequence="ViewCodeSequence"							Type="1"	VM="1"
		InvokeMacro="CodeSequenceMacro"								EnmeratedContextID="4014"
		Sequence="ViewModifierCodeSequence"				Type="2"	VM="0-n"
			InvokeMacro="CodeSequenceMacro"							EnmeratedContextID="4015"
		SequenceEnd
	SequenceEnd
	Sequence="BiopsyTargetSequence"						Type="3"	VM="1-n"
		Name="TargetUID"								Type="1"
		Name="LocalizingCursorPosition"					Type="1"
		Name="CalculatedTargetPosition"					Type="1"
		Name="DisplayedZValue"							Type="1"
		Name="TargetLabel"								Type="3"
	SequenceEnd
ModuleEnd

Module="IntraoralSeries"
	Name="Modality"										Type="1"	StringEnumValues="IntraoralModality"
ModuleEnd

Module="IntraoralImage"
	Name="PositionerType"								Type="1"	StringEnumValues="IntraoralPositionerType"
	Name="ImageLaterality"								Type="1"	StringEnumValues="IntraoralImageLaterality"
	Sequence="AnatomicRegionSequence"					Type="1"	VM="1"
		InvokeMacro="CodeSequenceMacro"								DefinedContextID="4016"
		Sequence="AnatomicRegionModifierSequence"		Type="1C"	VM="1"	Condition="NoPrimaryAnatomicStructureSequence"
			InvokeMacro="CodeSequenceMacro"							DefinedContextID="4017"
		SequenceEnd
	SequenceEnd
	Sequence="PrimaryAnatomicStructureSequence"			Type="1C"	VM="1-n"	Condition="NoAnatomicRegionModifierSequence"
		InvokeMacro="CodeSequenceMacro"								DefinedContextID="4018 or 4019"
	SequenceEnd
ModuleEnd

Module="ImageHistogram"
	Sequence="HistogramSequence"						Type="1"	VM="1-n"
		Name="HistogramNumberOfBins"					Type="1"
		Name="HistogramFirstBinValue"					Type="1"
		Name="HistogramLastBinValue"					Type="1"
		Name="HistogramBinWidth"						Type="1"
		Name="HistogramExplanation"						Type="3"
		Name="HistogramData"							Type="1"
	SequenceEnd
ModuleEnd

Module="IHEDBTProfile"
	Name="PatientName"						Type="1"
	Name="PatientID"						Type="1"
	Name="PatientBirthDate"					Type="1"
	Name="PatientAge"						Type="1"
	Name="OperatorsName"					Type="1"
	Name="Manufacturer"						Type="1"
	Name="InstitutionName"					Type="1"
	Name="InstitutionAddress"				Type="1"
	Name="ManufacturerModelName"			Type="1"
	Name="DeviceSerialNumber"				Type="1"
	Name="StationName"						Type="1"
	Sequence="ContributingSourcesSequence"	Type="1"	VM="1-n"
		Name="AcquisitionDateTime"			Type="1"
	SequenceEnd
	Sequence="XRay3DAcquisitionSequence"	Type="1"	VM="1-n"
		Name="OrganDose"					Type="1"
		Name="EntranceDoseInmGy"			Type="1"
	SequenceEnd
	Verify="ImageType"								Condition="ImageTypeValuesNotDBTThinThickGenerated2D"	ThenErrorMessage="Values not those required for thin or thick slices or generated 2D image by IHE DBT Rad TF Vol 2 Table 4.8.4.1.2.7-1"
ModuleEnd

Module="IHEMammoProfile"
	Name="PatientName"						Type="1"
	Name="PatientID"						Type="1"
	Name="PatientBirthDate"					Type="1"
	Name="PatientAge"						Type="1"
	Name="AcquisitionDate"					Type="1"
	Name="AcquisitionTime"					Type="1"
	Name="OperatorsName"					Type="1"
	Name="Manufacturer"						Type="1"
	Name="InstitutionName"					Type="1"
	Name="InstitutionAddress"				Type="1"
	Name="ManufacturerModelName"			Type="1"
	Name="DeviceSerialNumber"				Type="1"
	Name="DetectorID"						Type="1"
	Name="SoftwareVersions"					Type="1"
	Name="StationName"						Type="1"
	Name="GantryID"							Type="1C"	Condition="DetectorTypeIsStorage" mbpo="true"
	Name="KVP"								Type="1"	NotZeroWarning=""
	Name="Exposure"							Type="1"	NotZeroWarning=""
	Name="ExposureTime"						Type="1"	NotZeroWarning=""
	Name="FilterMaterial"					Type="1"
	Name="AnodeTargetMaterial"				Type="1"
	Name="CompressionForce"					Type="1"
	Name="BodyPartThickness"				Type="1"	NotZeroWarning=""
	Name="PositionerPrimaryAngle"			Type="1"
	Name="RelativeXRayExposure"				Type="1"	NotZeroWarning=""
	Name="EntranceDoseInmGy"				Type="1"	NotZeroWarning=""
	Name="OrganDose"						Type="1"	NotZeroWarning=""
	Name="BurnedInAnnotation"				Type="1"	StringEnumValues="NoFull"
	Name="BreastImplantPresent"				Type="1"
	Name="PixelPaddingValue"				Type="1"	# really only required if skin edge detected, but cannot check the real world intent
	Name="EstimatedRadiographicMagnificationFactor"	Type="1"
	Name="DateOfLastDetectorCalibration"	Type="1C"	Condition="DetectorTypeIsNotStorage" mbpo="true"
	Verify="PixelSpacing"								Condition="PixelSpacingIsPresent" ThenWarningMessage="Attribute present but not used in IHE Mammo Profile"
ModuleEnd

Module="IHEMammoProfileWithoutPartialViewOption"
	Verify="PartialView"								Condition="PartialViewNotPresent"	ThenWarningMessage="IHE Mammo Profile Partial View Option not supported"
ModuleEnd

Module="IHEMammoProfileWithPartialViewOption"
	Name="PartialView"						Type="1"	# really only required for partial view named option
	Sequence="PartialViewCodeSequence"		Type="1C"	VM="1-2"	Condition="PartialViewIsYes"
	SequenceEnd
ModuleEnd

Module="IHEMammoProfileForPresentationOnly"
	Sequence="SourceImageSequence"			Type="1"	VM="1"
		Name="SpatialLocationsPreserved"	Type="1"
	SequenceEnd
	Sequence="VOILUTSequence"				Type="3"	VM="1-n"
		Name="LUTExplanation"				Type="1"	# really only required if number of items > 1, but cannot check this
	SequenceEnd
	Name="WindowCenterWidthExplanation"		Type="1C"	Condition="WindowCenterPresent"	# really only required if number of values > 1, but cannot check this
	Name="VOILUTFunction"					Type="1"	# really only required if not linear, but cannot check the real world intent
ModuleEnd

Module="DentalImageOnMediaProfile"
	Name="BitsAllocated"					Type="1"	BinaryEnumValues="BitsAre8Or16"
	Verify="BitsAllocated"								Condition="BitsStoredIs8"			BinaryEnumValues="BitsAre8"
	Verify="BitsAllocated"								Condition="BitsStoredGreaterThan8"	BinaryEnumValues="BitsAre16"
	Name="BitsStored"						Type="1"	BinaryEnumValues="BitsAre8Or10Or12Or16"
	Name="InstitutionName"					Type="2"
	Name="ManufacturerModelName"			Type="2"
	Name="DetectorID"						Type="2"
	Name="DetectorManufacturerName"			Type="2"
	Name="DetectorManufacturerModelName"	Type="2"
ModuleEnd

Module="MultiFrameFunctionalGroupsForBreastTomosynthesisImage"
	Sequence="SharedFunctionalGroupsSequence"	Type="1"	VM="1"
		InvokeMacro="PixelMeasuresMacro"					Condition="PixelMeasuresSequenceNotInPerFrameFunctionalGroupSequence"
		InvokeMacro="PlanePositionMacro"					Condition="PlanePositionSequenceNotInPerFrameFunctionalGroupSequence"
		InvokeMacro="PlaneOrientationMacro"					Condition="PlaneOrientationSequenceNotInPerFrameFunctionalGroupSequence"
		InvokeMacro="ReferencedImageMacro"					Condition="ReferencedImageMacroOKInSharedFunctionalGroupSequence"
		InvokeMacro="DerivationImageMacro"					Condition="DerivationImageMacroOKInSharedFunctionalGroupSequence"
		InvokeMacro="FrameAnatomyMacro"						Condition="FrameAnatomySequenceNotInPerFrameFunctionalGroupSequence"
		InvokeMacro="IdentityPixelValueTransformationMacro"	Condition="PixelValueTransformationSequenceNotInPerFrameFunctionalGroupSequence"
		InvokeMacro="FrameVOILUTWithLUTMacro"				Condition="FrameVOILUTMacroOKInSharedFunctionalGroupSequence"
		InvokeMacro="RealWorldValueMappingMacro"			Condition="RealWorldValueMappingMacroOKInSharedFunctionalGroupSequence"
		InvokeMacro="ContrastBolusUsageMacro"				Condition="NeedContrastBolusUsageMacroInSharedFunctionalGroupSequence"
	SequenceEnd

	Sequence="PerFrameFunctionalGroupsSequence"	Type="1"	VM="1-n"
		InvokeMacro="PixelMeasuresMacro"					Condition="PixelMeasuresSequenceNotInSharedFunctionalGroupSequence"
		InvokeMacro="FrameContentMacro"
		InvokeMacro="PlanePositionMacro"					Condition="PlanePositionSequenceNotInSharedFunctionalGroupSequence"
		InvokeMacro="PlaneOrientationMacro"					Condition="PlaneOrientationSequenceNotInSharedFunctionalGroupSequence"
		InvokeMacro="ReferencedImageMacro"					Condition="ReferencedImageMacroOKInPerFrameFunctionalGroupSequence"
		InvokeMacro="DerivationImageMacro"					Condition="DerivationImageMacroOKInPerFrameFunctionalGroupSequence"
		InvokeMacro="FrameAnatomyMacro"						Condition="FrameAnatomySequenceNotInSharedFunctionalGroupSequence"
		InvokeMacro="IdentityPixelValueTransformationMacro"	Condition="PixelValueTransformationSequenceNotInSharedFunctionalGroupSequence"
		InvokeMacro="FrameVOILUTWithLUTMacro"				Condition="FrameVOILUTMacroOKInPerFrameFunctionalGroupSequence"
		InvokeMacro="RealWorldValueMappingMacro"			Condition="RealWorldValueMappingMacroOKInPerFrameFunctionalGroupSequence"
		InvokeMacro="ContrastBolusUsageMacro"				Condition="NeedContrastBolusUsageMacroInPerFrameFunctionalGroupSequence"
		InvokeMacro="XRay3DFrameTypeMacro"
	SequenceEnd
ModuleEnd

DefineMacro="IdentityPixelValueTransformationMacro" InformationEntity="FunctionalGroup"
	Sequence="PixelValueTransformationSequence"		Type="1"	VM="1"
		Name="RescaleIntercept"						Type="1"	BinaryEnumValues="Zero"
		Name="RescaleSlope"							Type="1"	BinaryEnumValues="One"
		Name="RescaleType"							Type="1"	StringEnumValues="ModalityLUTTypeUnspecified"
	SequenceEnd
MacroEnd

DefineMacro="FrameVOILUTWithLUTMacro" InformationEntity="FunctionalGroup"
	Sequence="FrameVOILUTSequence"					Type="1"	VM="1"
		InvokeMacro="VOILUTMacro"
	SequenceEnd
MacroEnd

Module="BreastTomosynthesisContributingSources"
	Sequence="ContributingSourcesSequence"					Type="1"	VM="1-n"
		InvokeMacro="GeneralContributingSourcesMacro"
		InvokeMacro="ContributingImageSourcesMacro"
		Name="DetectorType"									Type="1"	StringDefinedTerms="DetectorTypeExcludingFilm"
		Name="DetectorID"									Type="1"
		Name="DateOfLastDetectorCalibration"				Type="1"
		Name="TimeOfLastDetectorCalibration"				Type="1"
		Name="DetectorElementSpacing"						Type="1"
	SequenceEnd
ModuleEnd

Module="BreastTomosynthesisAcquisition"
	Sequence="XRay3DAcquisitionSequence"					Type="1"	VM="1-n"
		Name="FieldOfViewShape"								Type="1"	StringEnumValues="BreastTomosynthesisFieldOfViewShape"
		Name="XRayReceptorType"								Type="1"	StringEnumValues="BreastTomosynthesisXRayReceptorType"
		InvokeMacro="XRay3DGeneralSharedAcquisitionMacro"
		InvokeMacro="XRay3DGeneralPositionerMovementMacro"
		Name="DistanceSourceToDetector"						Type="1"	NotZeroWarning=""
		Name="DistanceSourceToPatient"						Type="1"	NotZeroWarning=""
		Name="EstimatedRadiographicMagnificationFactor"		Type="1"
		Name="AnodeTargetMaterial"							Type="1"	StringDefinedTerms="AnodeTargetMaterial"
		Name="BodyPartThickness"							Type="1"	NotZeroWarning=""
		Name="ExposureControlMode"							Type="1"	StringDefinedTerms="ExposureControlMode"
		Name="ExposureControlModeDescription"				Type="1"
		Name="HalfValueLayer"								Type="1"	NotZeroWarning=""
		Name="OrganDose"									Type="3"	NotZeroWarning=""
		Name="EntranceDoseInmGy"							Type="3"	NotZeroWarning=""
		Name="FocalSpots"									Type="1"
		Name="DetectorBinning"								Type="1C"	NoCondition=""	# real world
		Name="DetectorTemperature"							Type="1"	NotZeroWarning=""
		Name="FilterType"									Type="1"
		Name="FilterMaterial"								Type="1"
		Name="FilterThicknessMinimum"						Type="3"	NotZeroWarning=""
		Name="FilterThicknessMaximum"						Type="3"	NotZeroWarning=""
		Name="FilterBeamPathLengthMinimum"					Type="3"	NotZeroWarning=""
		Name="FilterBeamPathLengthMaximum"					Type="3"	NotZeroWarning=""
		Name="CompressionForce"								Type="1"	NotZeroWarning=""
		Name="PaddleDescription"							Type="1"
		Sequence="PerProjectionAcquisitionSequence"			Type="1"	VM="1-n"
			InvokeMacro="XRay3DGeneralPerProjectionAcquisitionMacro"
			Name="PositionerPrimaryAngle"					Type="1"
			Name="PositionerPrimaryAngleDirection"			Type="3"	StringEnumValues="PositionerPrimaryAngleDirection"
			Name="PositionerSecondaryAngle"					Type="1C"	NoCondition=""	# real world
			Name="ExposureTimeInms"							Type="1"	NotZeroWarning=""
			Name="ExposureInmAs"							Type="1"	NotZeroWarning=""
			Name="RelativeXRayExposure"						Type="1"	NotZeroWarning=""
			Name="OrganDose"								Type="3"	NotZeroWarning=""
			Name="EntranceDoseInmGy"						Type="3"	NotZeroWarning=""
			InvokeMacro="ExposureIndexMacro"
			Name="IrradiationEventUID"						Type="3"
		SequenceEnd
	SequenceEnd
ModuleEnd

Module="BreastView"
	Name="ImageType"									Type="1"	ValueSelector="2"	StringDefinedTerms="CommonEnhancedImageAndFrameType3AndBreastTomoImageAndFrameType3"
	Verify="ImageType"												ValueSelector="3"	StringDefinedTerms="BreastTomoImageAndFrameType4"
	Verify="ImageType"												ValueSelector="4"	StringDefinedTerms="BreastTomoImageAndFrameType5"
	Sequence="ViewCodeSequence"							Type="1"	VM="1"
		InvokeMacro="CodeSequenceMacro"								EnmeratedContextID="4014"
		Sequence="ViewModifierCodeSequence"				Type="2"	VM="0-n"
			InvokeMacro="CodeSequenceMacro"							EnmeratedContextID="4015"
		SequenceEnd
	SequenceEnd
	Name="BreastImplantPresent"							Type="1C"	Condition="ModalityIsMG"	StringEnumValues="YesNoFull"
	Name="PartialView"									Type="3"	StringEnumValues="YesNoFull"
	Verify="PartialView"											Condition="ViewModifierCodeSequenceIsMagnificationOrSpotCompression"	StringEnumValues="NoFull"
	Sequence="PartialViewCodeSequence"					Type="1C"	Condition="PartialViewIsYes"	VM="1-2"
		InvokeMacro="CodeSequenceMacro"								DefinedContextID="4005"
	SequenceEnd
ModuleEnd

Module="EnhancedMammographySeries"
	Name="Modality"										Type="1"	StringEnumValues="MammographyModality"
	Sequence="ReferencedPerformedProcedureStepSequence"	Type="1C"	VM="1"	Condition="SeriesNeedReferencedPerformedProcedureStepSequence"
		InvokeMacro="SOPInstanceReferenceMacro"
	SequenceEnd
	Sequence="RequestAttributesSequence"				Type="3"	VM="1-n"
		InvokeMacro="RequestAttributesMacro"
	SequenceEnd
ModuleEnd

Module="EnhancedMammographyImage"
	Name="PositionerMotion"								Type="1"	StringDefinedTerms="MammographyPositionerAndDetectorMotion"
	Name="PositionerType"								Type="1"	StringEnumValues="MammographyPositionerTypeWithoutNone"
	Name="ContentQualification"							Type="1"	StringEnumValues="ContentQualification"
	Name="AcquisitionDateTime"							Type="1"
	Name="AcquisitionDuration"							Type="1"
	InvokeMacro="DigitalXRayDetectorMacro"
	Name="KVP"											Type="1"
	Name="XRayTubeCurrentInmA"							Type="1C"	Condition="ExposureInmAsNotPresent" mbpo="true"
	Name="ExposureTimeInms"								Type="1C"	Condition="ExposureInmAsNotPresent" mbpo="true"
	Name="ExposureInmAs"								Type="1C"	Condition="XRayTubeCurrentInmAOrExposureTimeInmsNotPresent" mbpo="true"
	Name="FocalSpots"									Type="1"
	Name="AnodeTargetMaterial"							Type="1"	StringDefinedTerms="AnodeTargetMaterial"
	Name="BodyPartThickness"							Type="1"
	Name="CompressionForce"								Type="1"
	Name="PaddleDescription"							Type="1"
	Name="ExposureControlMode"							Type="1"	StringDefinedTerms="ExposureControlMode"
	Name="ExposureControlModeDescription"				Type="1"
	Name="PatientOrientation"							Type="1C"	Condition="ViewIsNotSpecimen" mbpo="true"
	Name="ImageComments"								Type="3"
	Name="SamplesPerPixel"								Type="1"	BinaryEnumValues="One"
	Name="PhotometricInterpretation"					Type="1"	StringEnumValues="PhotometricInterpretationMonochrome"
	Name="BitsAllocated"								Type="1"	BinaryEnumValues="BitsAre8Or16"
	Name="BitsStored"									Type="1"	BinaryEnumValues="BitsAre8To16"
	Name="HighBit"										Type="1"	BinaryEnumValues="BitsAre7To15"
	Name="PixelRepresentation"							Type="1"	BinaryEnumValues="PixelRepresentationUnsigned"
	Name="QualityControlImage"							Type="3"	StringEnumValues="YesNoFull"
	Name="BurnedInAnnotation"							Type="1"	StringEnumValues="NoFull"
	Name="LossyImageCompression"						Type="1"	StringEnumValues="LossyImageCompression"
	Name="LossyImageCompressionRatio"					Type="1C"	Condition="LossyImageCompressionIs01"	NotZeroError=""
	Name="LossyImageCompressionMethod"					Type="1C"	StringDefinedTerms="LossyImageCompressionMethod"	Condition="LossyImageCompressionIs01"
	Verify="LossyImageCompressionMethod"							Condition="LossyImageCompressionMethodInconsistentWithTransferSyntax"	ThenWarningMessage="method inconsistent with transfer syntax" ShowValueWithMessage="true"
	Name="OrganDose"									Type="1"
	Name="EntranceDoseInmGy"							Type="1"
	Name="TypeOfDetectorMotion"							Type="1"	StringDefinedTerms="MammographyPositionerAndDetectorMotion"
	Sequence="IconImageSequence"						Type="3"	VM="1"
		InvokeMacro="IconImageSequenceMacro"
	SequenceEnd
	Name="PresentationLUTShape"							Type="1"	StringEnumValues="DXPresentationLUTShape"
ModuleEnd

DefineMacro="BreastXRayPositionerMacro"
	Sequence="PositionerPositionSequence"				Type="1"	VM="1"
		Name="PositionerPrimaryAngle"					Type="1C"	NoCondition=""
		Name="PositionerPrimaryAngleDirection"			Type="1C"	NoCondition=""	StringEnumValues="PositionerPrimaryAngleDirection"
		Name="PositionerSecondaryAngle"					Type="1C"	NoCondition=""
	SequenceEnd
MacroEnd

DefineMacro="BreastXRayDetectorMacro"
	Sequence="DetectorPositionSequence"					Type="1"	VM="1"
		Name="DetectorPrimaryAngle"						Type="1C"	NoCondition=""
		Name="DetectorSecondaryAngle"					Type="1C"	NoCondition=""
	SequenceEnd
MacroEnd

DefineMacro="BreastXRayGeometryMacro"
	Sequence="XRayGeometrySequence"						Type="1"	VM="1"
		Name="DistanceSourceToDetector"					Type="1C"	Condition="PresentationIntentTypeIsForProcessing"	mbpo="true"
		Name="DistanceSourceToPatient"					Type="1C"	Condition="PresentationIntentTypeIsForProcessing"	mbpo="true"
		Name="DistanceSourceToIsocenter"				Type="1C"	Condition="PresentationIntentTypeIsForProcessing"	mbpo="true"
		Name="DistanceSourceToEntrance"					Type="3"
		Name="EstimatedRadiographicMagnificationFactor"	Type="1"
	SequenceEnd
MacroEnd

DefineMacro="BreastXRayAcquisitionDoseMacro"
	Sequence="XRayAcquisitionDoseSequence"				Type="1"	VM="1"
		Name="ExposureTimeInms"							Type="1"
		Name="ExposureInmAs"							Type="1"
		Name="RelativeXRayExposure"						Type="3"
		Name="HalfValueLayer"							Type="3"
		Name="OrganDose"								Type="1"
		Name="EntranceDoseInmGy"						Type="1"
	SequenceEnd
MacroEnd

DefineMacro="BreastXRayIsocenterReferenceSystemMacro"
	Sequence="IsocenterReferenceSystemSequence"			Type="1"	VM="1"
		Name="XRaySourceIsocenterPrimaryAngle"			Type="1"
		Name="XRaySourceIsocenterSecondaryAngle"		Type="1"
		Name="BreastSupportIsocenterPrimaryAngle"		Type="1"
		Name="BreastSupportIsocenterSecondaryAngle"		Type="1"
		Name="BreastSupportXPositionToIsocenter"		Type="1C"	Condition="PresentationIntentTypeIsForProcessing"	mbpo="true"
		Name="BreastSupportYPositionToIsocenter"		Type="1C"	Condition="PresentationIntentTypeIsForProcessing"	mbpo="true"
		Name="BreastSupportZPositionToIsocenter"		Type="1C"	Condition="PresentationIntentTypeIsForProcessing"	mbpo="true"
		Name="DetectorIsocenterPrimaryAngle"			Type="1"
		Name="DetectorIsocenterSecondaryAngle"			Type="1"
		Name="DetectorXPositionToIsocenter"				Type="1C"	Condition="PresentationIntentTypeIsForProcessing"	mbpo="true"
		Name="DetectorYPositionToIsocenter"				Type="1C"	Condition="PresentationIntentTypeIsForProcessing"	mbpo="true"
		Name="DetectorZPositionToIsocenter"				Type="1C"	Condition="PresentationIntentTypeIsForProcessing"	mbpo="true"
		Name="DetectorActiveAreaTLHCPosition"			Type="1C"	Condition="PresentationIntentTypeIsForProcessing"	mbpo="true"
		Name="DetectorActiveAreaOrientation"			Type="1C"	Condition="PresentationIntentTypeIsForProcessing"	mbpo="true"
	SequenceEnd
MacroEnd

DefineMacro="XRayGridMacro"
	Sequence="XRayGridSequence"							Type="1"	VM="1"	StringDefinedTerms="XRayGrid"
		Name="Grid"										Type="1"
		InvokeMacro="XRayGridDescriptionMacro"
	SequenceEnd
MacroEnd

DefineMacro="XRayFilterMacro"
	Sequence="XRayFilterSequence"						Type="1"	VM="1"
		InvokeMacro="XRayFiltrationMacro"
	SequenceEnd
MacroEnd

Module="MultiFrameFunctionalGroupsForBreastProjectionXRayImage"
	Sequence="SharedFunctionalGroupsSequence"	Type="1"	VM="1"
		InvokeMacro="ReferencedImageMacro"					Condition="ReferencedImageMacroOKInSharedFunctionalGroupSequence"
		InvokeMacro="DerivationImageMacro"					Condition="NeedDerivationImageMacroInSharedFunctionalGroupSequenceForBreastProjection"
		InvokeMacro="FrameAnatomyMacro"						Condition="FrameAnatomySequenceNotInPerFrameFunctionalGroupSequence"
		InvokeMacro="IdentityPixelValueTransformationMacro"	Condition="PixelValueTransformationSequenceNotInPerFrameFunctionalGroupSequence"
		InvokeMacro="FrameVOILUTWithLUTMacro"				Condition="FrameVOILUTSequenceNotInPerFrameFunctionalGroupSequence"
		InvokeMacro="ContrastBolusUsageMacro"				Condition="NeedContrastBolusUsageMacroInSharedFunctionalGroupSequence"
		InvokeMacro="FrameDisplayShutterMacro"				Condition="FrameDisplayShutterMacroOKInSharedFunctionalGroupSequence"
		InvokeMacro="IrradiationEventIdentificationMacro"	Condition="IrradiationEventIdentificationSequenceNotInPerFrameFunctionalGroupSequence"
		InvokeMacro="XRayFrameCharacteristicsMacro"			Condition="XRayFrameCharacteristicsMacroOKInSharedFunctionalGroupSequence"
		InvokeMacro="XRayFieldOfViewMacro"					Condition="FieldOfViewSequenceNotInPerFrameFunctionalGroupSequence"
		InvokeMacro="XRayFramePixelDataPropertiesMacro"		Condition="FramePixelDataPropertiesSequenceNotInPerFrameFunctionalGroupSequence"
		InvokeMacro="XRayFrameDetectorParametersMacro"		Condition="XRayFrameDetectorParametersMacroOKInSharedFunctionalGroupSequence"
		InvokeMacro="XRayCalibrationDeviceUsageMacro"		Condition="XRayCalibrationDeviceUsageMacroOKInSharedFunctionalGroupSequence"
		InvokeMacro="XRayFrameAcquisitionMacro"				Condition="XRayFrameAcquisitionMacroOKInSharedFunctionalGroupSequence"
		InvokeMacro="XRayCollimatorMacro"					Condition="CollimatorShapeSequenceSequenceNotInPerFrameFunctionalGroupSequence"
		InvokeMacro="BreastXRayPositionerMacro"				Condition="NeedBreastXRayPositionerMacroInSharedFunctionalGroupSequence"
		InvokeMacro="BreastXRayDetectorMacro"				Condition="NeedBreastXRayDetectorMacroInSharedFunctionalGroupSequence"
		InvokeMacro="BreastXRayGeometryMacro"				Condition="XRayGeometrySequenceNotInPerFrameFunctionalGroupSequence"
		InvokeMacro="BreastXRayAcquisitionDoseMacro"		Condition="XRayAcquisitionDoseSequenceNotInPerFrameFunctionalGroupSequence"
		InvokeMacro="BreastXRayIsocenterReferenceSystemMacro"	Condition="IsocenterReferenceSystemSequenceNotInPerFrameFunctionalGroupSequence"
		InvokeMacro="XRayGridMacro"							Condition="XRayGridMacroOKInSharedFunctionalGroupSequence"
		InvokeMacro="XRayFilterMacro"						Condition="XRayFilterMacroOKInSharedFunctionalGroupSequence"
	SequenceEnd

	Sequence="PerFrameFunctionalGroupsSequence"	Type="1"	VM="1-n"
		InvokeMacro="FrameContentMacro"
		InvokeMacro="ReferencedImageMacro"					Condition="ReferencedImageMacroOKInPerFrameFunctionalGroupSequence"
		InvokeMacro="DerivationImageMacro"					Condition="NeedDerivationImageMacroInPerFrameFunctionalGroupSequenceForBreastProjection"
		InvokeMacro="FrameAnatomyMacro"						Condition="FrameAnatomySequenceNotInSharedFunctionalGroupSequence"
		InvokeMacro="IdentityPixelValueTransformationMacro"	Condition="PixelValueTransformationSequenceNotInSharedFunctionalGroupSequence"
		InvokeMacro="FrameVOILUTWithLUTMacro"				Condition="FrameVOILUTSequenceNotInSharedFunctionalGroupSequence"
		InvokeMacro="ContrastBolusUsageMacro"				Condition="NeedContrastBolusUsageMacroInPerFrameFunctionalGroupSequence"
		InvokeMacro="FrameDisplayShutterMacro"				Condition="FrameDisplayShutterMacroOKInPerFrameFunctionalGroupSequence"
		InvokeMacro="IrradiationEventIdentificationMacro"	Condition="IrradiationEventIdentificationSequenceNotInSharedFunctionalGroupSequence"
		InvokeMacro="XRayFrameCharacteristicsMacro"			Condition="XRayFrameCharacteristicsMacroOKInPerFrameFunctionalGroupSequence"
		InvokeMacro="XRayFieldOfViewMacro"					Condition="FieldOfViewSequenceNotInSharedFunctionalGroupSequence"
		InvokeMacro="XRayFramePixelDataPropertiesMacro"		Condition="FramePixelDataPropertiesSequenceNotInSharedFunctionalGroupSequence"
		InvokeMacro="XRayFrameDetectorParametersMacro"		Condition="XRayFrameDetectorParametersMacroOKInPerFrameFunctionalGroupSequence"
		InvokeMacro="XRayCalibrationDeviceUsageMacro"		Condition="XRayCalibrationDeviceUsageMacroOKInPerFrameFunctionalGroupSequence"
		InvokeMacro="XRayFrameAcquisitionMacro"				Condition="XRayFrameAcquisitionMacroOKInPerFrameFunctionalGroupSequence"
		InvokeMacro="XRayCollimatorMacro"					Condition="CollimatorShapeSequenceSequenceNotInSharedFunctionalGroupSequence"
		InvokeMacro="BreastXRayPositionerMacro"				Condition="NeedBreastXRayPositionerMacroInPerFrameFunctionalGroupSequence"
		InvokeMacro="BreastXRayDetectorMacro"				Condition="NeedBreastXRayDetectorMacroInPerFrameFunctionalGroupSequence"
		InvokeMacro="BreastXRayGeometryMacro"				Condition="XRayGeometrySequenceNotInSharedFunctionalGroupSequence"
		InvokeMacro="BreastXRayAcquisitionDoseMacro"		Condition="XRayAcquisitionDoseSequenceNotInSharedFunctionalGroupSequence"
		InvokeMacro="BreastXRayIsocenterReferenceSystemMacro"	Condition="IsocenterReferenceSystemSequenceNotInSharedFunctionalGroupSequence"
		InvokeMacro="XRayGridMacro"							Condition="XRayGridMacroOKInPerFrameFunctionalGroupSequence"
		InvokeMacro="XRayFilterMacro"						Condition="XRayFilterMacroOKInPerFrameFunctionalGroupSequence"
	SequenceEnd
ModuleEnd

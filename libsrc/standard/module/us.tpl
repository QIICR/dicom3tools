Module="EnhancedPaletteColorLookupTable"
	Sequence="DataFrameAssignmentSequence"				Type="1"	VM="1-3"
		Name="DataType"									Type="1"
		Name="DataPathAssignment"						Type="1"	StringEnumValues="DataPathAssignment"
		Name="BitsMappedToColorLookupTable"				Type="3"
		InvokeMacro="VOILUTMacro"
	SequenceEnd
	Sequence="BlendingLUT1Sequence"						Type="1C"	VM="1"	Condition="AnyDataPathAssignmentIsOtherThanPrimaryPValues"
		Name="BlendingLUT1TransferFunction"				Type="1"	StringEnumValues="BlendingLUT1TransferFunction"
		Name="BlendingWeightConstant"					Type="1C"	Condition="BlendingLUT1TransferFunctionIsConstant"
		Name="BlendingLookupTableDescriptor"			Type="1C"	Condition="BlendingLUT1TransferFunctionIsTable"
		Verify="BlendingLookupTableDescriptor"						ValueSelector="1"	BinaryEnumValues="Zero"	
		Name="BlendingLookupTableData"					Type="1C"	Condition="BlendingLUT1TransferFunctionIsTable"
	SequenceEnd
	Sequence="BlendingLUT2Sequence"						Type="1C"	VM="1"	Condition="AnyDataPathAssignmentIsOtherThanPrimaryPValues"
		Name="BlendingLUT2TransferFunction"				Type="1"	StringEnumValues="BlendingLUT2TransferFunction"
		Name="BlendingWeightConstant"					Type="1C"	Condition="BlendingLUT2TransferFunctionIsConstant"
		Name="BlendingLookupTableDescriptor"			Type="1C"	Condition="BlendingLUT1TransferFunctionIsTable"
		Verify="BlendingLookupTableDescriptor"						ValueSelector="1"	BinaryEnumValues="Zero"	
		Name="BlendingLookupTableData"					Type="1C"	Condition="BlendingLUT1TransferFunctionIsTable"
	SequenceEnd
	Sequence="EnhancedPaletteColorLookupTableSequence"	Type="1C"	VM="1-2"	Condition="AnyDataPathAssignmentIsOtherThanPrimaryPValues"
		Name="DataPathID"								Type="1"	StringEnumValues="DataPathID"
		Name="RGBLUTTransferFunction"					Type="1"	StringEnumValues="RGBLUTTransferFunction"
		Name="AlphaLUTTransferFunction"					Type="1"	StringEnumValues="AlphaLUTTransferFunction"
		Name="RedPaletteColorLookupTableDescriptor"		Type="1C"	Condition="RGBLUTTransferFunctionIsTable"
		Verify="RedPaletteColorLookupTableDescriptor"				ValueSelector="1"	BinaryEnumValues="Zero"	
		Name="GreenPaletteColorLookupTableDescriptor"	Type="1C"	Condition="RGBLUTTransferFunctionIsTable"
		Verify="GreenPaletteColorLookupTableDescriptor"				ValueSelector="1"	BinaryEnumValues="Zero"	
		Name="BluePaletteColorLookupTableDescriptor"	Type="1C"	Condition="RGBLUTTransferFunctionIsTable"
		Verify="BluePaletteColorLookupTableDescriptor"				ValueSelector="1"	BinaryEnumValues="Zero"	
		Name="AlphaPaletteColorLookupTableDescriptor"	Type="1C"	Condition="RGBLUTTransferFunctionIsTable"
		Verify="AlphaPaletteColorLookupTableDescriptor"				ValueSelector="1"	BinaryEnumValues="Zero"	
		Name="RedPaletteColorLookupTableData"			Type="1C"	Condition="RGBLUTTransferFunctionIsTable"
		Name="GreenPaletteColorLookupTableData"			Type="1C"	Condition="RGBLUTTransferFunctionIsTable"
		Name="BluePaletteColorLookupTableData"			Type="1C"	Condition="RGBLUTTransferFunctionIsTable"
		Name="AlphaPaletteColorLookupTableData"			Type="1C"	Condition="RGBLUTTransferFunctionIsTable"
	SequenceEnd
	Name="ICCProfile"									Type="1C"	Condition="AnyDataPathAssignmentIsOtherThanPrimaryPValues"
	Name="ColorSpace"									Type="3"
ModuleEnd

DefineMacro="PlanePositionVolumeMacro" InformationEntity="FunctionalGroup"
	Sequence="PlanePositionVolumeSequence"			Type="1"	VM="1"
		Name="ImagePositionVolume"					Type="1" 
	SequenceEnd
MacroEnd

DefineMacro="PlaneOrientationVolumeMacro" InformationEntity="FunctionalGroup"
	Sequence="PlaneOrientationVolumeSequence"		Type="1"	VM="1"
		Name="ImageOrientationVolume"				Type="1" 
	SequenceEnd
MacroEnd

DefineMacro="TemporalPositionMacro" InformationEntity="FunctionalGroup"
	Sequence="TemporalPositionSequence"				Type="1"	VM="1"
		Name="TemporalPositionTimeOffset"			Type="1" 
	SequenceEnd
MacroEnd

DefineMacro="ImageDataTypeMacro" InformationEntity="FunctionalGroup"
	Sequence="ImageDataTypeSequence"				Type="1"	VM="1"
		Name="DataType"								Type="1"	StringDefinedTerms="EnhancedUSVolumeDataType"
		Name="AliasedDataType"						Type="1"	StringEnumValues="YesNoFull"
		Name="ZeroVelocityPixelValue"				Type="1C"	Condition="NeedZeroVelocityPixelValue" mbpo="true"
	SequenceEnd
MacroEnd

Module="EnhancedUSSeries"
	Name="Modality"										Type="1"	StringEnumValues="USOrIVUSModality"
	Sequence="ReferencedPerformedProcedureStepSequence"	Type="1C"	VM="1"	Condition="SeriesNeedReferencedPerformedProcedureStepSequence"
		InvokeMacro="SOPInstanceReferenceMacro"
	SequenceEnd
	Sequence="PerformedProtocolCodeSequence"			Type="1C"	VM="1"	NoCondition=""	mbpo="true"
		InvokeMacro="CodeSequenceMacro"
		Sequence="ProtocolContextSequence"				Type="3"	VM="1-n"
			InvokeMacro="ContentItemMacro"
			Sequence="ContentItemModifierSequence"		Type="3"	VM="1-n"
				InvokeMacro="ContentItemMacro"
			SequenceEnd
		SequenceEnd
	SequenceEnd
	Name="PerformedProtocolType"						Type="1C"	Condition="PerformedProtocolCodeSequenceIsPresent"	StringEnumValues="PerformedProtocolType"
ModuleEnd

Module="UltrasoundFrameOfReference"
	Name="VolumeFrameOfReferenceUID"						Type="1"
	Name="UltrasoundAcquisitionGeometry"					Type="1"	StringDefinedTerms="UltrasoundAcquisitionGeometry"
	Name="ApexPosition"										Type="1C"	Condition="UltrasoundAcquisitionGeometryIsApex"
	Name="VolumeToTransducerRelationship"					Type="1C"	NoCondition=""	StringEnumValues="VolumeToTransducerRelationship"
	Name="VolumeToTransducerMappingMatrix"					Type="1"
	Name="PatientFrameOfReferenceSource"					Type="1C"	Condition="NeedPatientFrameOfReferenceSource"	StringEnumValues="PatientFrameOfReferenceSource"
	Name="TableFrameOfReferenceUID"							Type="1C"	Condition="PatientFrameOfReferenceSourceIsTable"
	Name="VolumeToTableMappingMatrix"						Type="1C"	Condition="PatientFrameOfReferenceSourceIsTable"
ModuleEnd

Module="EnhancedUSImage"
	Name="ImageType"										Type="1"	VM="4-n"
	Verify="ImageType"													ValueSelector="0"	StringEnumValues="CommonEnhancedImageType1"
	Verify="ImageType"													ValueSelector="1"	StringEnumValues="CommonEnhancedImageAndFrameType2"
	Verify="ImageType"													ValueSelector="2"	StringDefinedTerms="CommonEnhancedImageAndFrameType3"
	Verify="ImageType"													ValueSelector="3"	StringDefinedTerms="CommonEnhancedImageType4"
	Name="SamplesPerPixel"									Type="1"	BinaryEnumValues="SamplesPerPixelIsOne"
	Name="PhotometricInterpretation"						Type="1"	StringEnumValues="PhotometricInterpretationMonochrome2"
	Name="BitsAllocated"									Type="1"	BinaryEnumValues="BitsAre8Or16"
	Name="BitsStored"										Type="1"	BinaryEnumValues="BitsAre8Or16"
	Name="HighBit"											Type="1"	BinaryEnumValues="BitsAre7Or15"
	Name="PixelRepresentation"								Type="1"	BinaryEnumValues="PixelRepresentationUnsigned"
	Name="DimensionOrganizationType"						Type="1"	StringEnumValues="DimensionOrganizationType3DOr3DTemporal"
	Name="AcquisitionDateTime"								Type="1"
	Name="AcquisitionDuration"								Type="1"
	Name="PositionMeasuringDeviceUsed"						Type="1C"	Condition="NeedPositionMeasuringDeviceUsed"	StringEnumValues="PositionMeasuringDeviceUsed"	mbpo="true"
	Name="LossyImageCompression"							Type="1"	StringEnumValues="LossyImageCompression"
	Name="LossyImageCompressionRatio"						Type="1C"	Condition="LossyImageCompressionIs01"	NotZeroError=""
	Name="LossyImageCompressionMethod"						Type="1C"	StringDefinedTerms="LossyImageCompressionMethod"	Condition="LossyImageCompressionIs01"
	Verify="LossyImageCompressionMethod"								Condition="LossyImageCompressionMethodInconsistentWithTransferSyntax"	ThenWarningMessage="method inconsistent with transfer syntax" ShowValueWithMessage="true"
	Name="PresentationLUTShape"								Type="1"	StringEnumValues="IdentityPresentationLUTShape"
	Name="RescaleIntercept"									Type="1"	BinaryEnumValues="Zero"
	Name="RescaleSlope"										Type="1"	BinaryEnumValues="One"
	Sequence="SourceImageSequence"							Type="1C"	VM="1-n"	Condition="ImageTypeValue1Derived"
		InvokeMacro="ImageSOPInstanceReferenceMacro"
		Sequence="PurposeOfReferenceCodeSequence"			Type="3"	VM="1"
			InvokeMacro="CodeSequenceMacro"
		SequenceEnd
	SequenceEnd
	Sequence="ReferencedImageSequence"						Type="3"	VM="1-n"
		InvokeMacro="ImageSOPInstanceReferenceMacro"
		Sequence="PurposeOfReferenceCodeSequence"			Type="3"	VM="1"
			InvokeMacro="CodeSequenceMacro"
		SequenceEnd
	SequenceEnd
	Sequence="ReferencedRawDataSequence"					Type="3"	VM="1-n"
		InvokeMacro="HierarchicalSOPInstanceReferenceMacro"
	SequenceEnd
	Sequence="ReferencedInstanceSequence"					Type="3"	VM="1-n"
		InvokeMacro="SOPInstanceReferenceMacro"
		Sequence="PurposeOfReferenceCodeSequence"			Type="3"	VM="1"
			InvokeMacro="CodeSequenceMacro"
		SequenceEnd
	SequenceEnd
	Name="NumberOfStages"									Type="1C"	Condition="PerformedProtocolTypeIsStaged"
	Name="StageNumber"										Type="1C"	Condition="PerformedProtocolTypeIsStaged"
	Sequence="StageCodeSequence"							Type="1C"	VM="1"	Condition="PerformedProtocolTypeIsStaged"
		InvokeMacro="CodeSequenceMacro"
	SequenceEnd
	InvokeMacro="MandatoryViewAndSliceProgressionDirectionMacro"
	Sequence="EventTimerSequence"							Type="3"	VM="1-n"
		Name="EventTimeOffset"								Type="1"
		Sequence="EventCodeSequence"						Type="1"	VM="1"
			InvokeMacro="CodeSequenceMacro"
		SequenceEnd
		Name="EventTimerNames"								Type="3"	VM="1"
	SequenceEnd
	InvokeMacro="GeneralAnatomyMandatoryMacro"
	Name="BurnedInAnnotation"								Type="1"	StringEnumValues="NoFull"
	Name="RecognizableVisualFeatures"						Type="3"	StringEnumValues="YesNoFull"
	Sequence="IconImageSequence"							Type="3"	VM="1"
		InvokeMacro="IconImageSequenceMacro"
	SequenceEnd
	Name="TransducerData"									Type="3"
	Sequence="TransducerScanPatternCodeSequence"			Type="1"	VM="1"
		InvokeMacro="CodeSequenceMacro"									DefinedContextID=12032"
	SequenceEnd
	Sequence="TransducerGeometryCodeSequence"				Type="1"	VM="1"
		InvokeMacro="CodeSequenceMacro"									DefinedContextID=12033"
	SequenceEnd
	Sequence="TransducerBeamSteeringCodeSequence"			Type="1"	VM="1-n"
		InvokeMacro="CodeSequenceMacro"									DefinedContextID=12034"
	SequenceEnd
	Sequence="TransducerApplicationCodeSequence"			Type="1"	VM="1"
		InvokeMacro="CodeSequenceMacro"									DefinedContextID=12035"
	SequenceEnd
	Name="ProcessingFunction"								Type="3"
	Name="MechanicalIndex"									Type="1"
	Name="BoneThermalIndex"									Type="1"
	Name="CranialThermalIndex"								Type="1"
	Name="SoftTissueThermalIndex"							Type="1"
	Name="DepthsOfFocus"									Type="1"
	Name="DepthOfScanField"									Type="1"
ModuleEnd

Module="IVUSImage"
	Name="IVUSAcquisition"									Type="1"	StringDefinedTerms="IVUSAcquisition"
	Name="IVUSPullbackRate"									Type="1C"	Condition="IVUSAcquisitionIsMotor"
	Name="IVUSGatedRate"									Type="1C"	Condition="IVUSAcquisitionIsGated"
	Name="IVUSPullbackStartFrameNumber"						Type="1C"	Condition="IVUSAcquisitionIsMotorOrGated"	NotZeroError=""
	Name="IVUSPullbackStopFrameNumber"						Type="1C"	Condition="IVUSAcquisitionIsMotorOrGated"	NotZeroError=""
ModuleEnd

Module="ExcludedIntervals"
	Sequence="ExcludedIntervalsSequence"					Type="1C"	VM="1-n"	NoCondition=""
		Name="ExclusionStartDateTime"						Type="1"
		Name="ExclusionDuration"							Type="1"
	SequenceEnd
ModuleEnd

DefineMacro="USImageDescriptionMacro" InformationEntity="FunctionalGroup"
	Sequence="USImageDescriptionSequence"				Type="1"	VM="1"
		Name="FrameType"								Type="1"	VM="4-n"
		Verify="FrameType"											ValueSelector="0"	StringEnumValues="CommonEnhancedFrameType1"
		Verify="FrameType"											ValueSelector="1"	StringEnumValues="CommonEnhancedImageAndFrameType2"
		Verify="FrameType"											ValueSelector="2"	StringEnumValues="CommonEnhancedImageAndFrameType3"
		Verify="FrameType"											ValueSelector="3"	StringEnumValues="CommonEnhancedFrameType4"
		Name="VolumetricProperties"						Type="1"	StringEnumValues="CommonCTMRVolumetricPropertiesImageLevel"
		Name="VolumeBasedCalculationTechnique"			Type="1"	StringDefinedTerms="CommonCTMRVolumeBasedCalculationTechniqueImageLevel"
	SequenceEnd
MacroEnd

DefineMacro="USImageDescriptionMacroForEnhancedUSVolume" InformationEntity="FunctionalGroup"
	Sequence="USImageDescriptionSequence"				Type="1"	VM="1"
		Name="VolumetricProperties"						Type="1"	StringEnumValues="Volume"
		Name="VolumeBasedCalculationTechnique"			Type="1"	StringEnumValues="None"
	SequenceEnd
MacroEnd

Module="MultiFrameFunctionalGroupsForEnhancedUSVolume"
	Sequence="SharedFunctionalGroupsSequence"			Type="1"	VM="1"
		InvokeMacro="PixelMeasuresMacro"				Condition="PixelMeasuresSequenceNotInPerFrameFunctionalGroupSequence"
		InvokeMacro="PlanePositionMacro"				Condition="PlanePositionSequenceOKInSharedFunctionalGroupSequence"
		InvokeMacro="PlaneOrientationMacro"				Condition="PlaneOrientationSequenceOKInSharedFunctionalGroupSequence"
		InvokeMacro="ReferencedImageMacro"				Condition="ReferencedImageMacroOKInSharedFunctionalGroupSequence"
		InvokeMacro="DerivationImageMacro"				Condition="DerivationImageMacroOKInSharedFunctionalGroupSequence"
		InvokeMacro="CardiacSynchronizationMacro"		Condition="NeedCardiacSynchronizationMacroInSharedFunctionalGroupSequenceRegardlessOfImageType"
		InvokeMacro="FrameVOILUTMacro"					Condition="FrameVOILUTSequenceNotInPerFrameFunctionalGroupSequence"
		InvokeMacro="RealWorldValueMappingMacro"		Condition="RealWorldValueMappingMacroOKInSharedFunctionalGroupSequence"
		InvokeMacro="ContrastBolusUsageMacro"			Condition="NeedContrastBolusUsageMacroInSharedFunctionalGroupSequence"
		InvokeMacro="PatientOrientationInFrameMacro"	Condition="PatientOrientationInFrameMacroOKInSharedFunctionalGroupSequence"
		InvokeMacro="FrameDisplayShutterMacro"			Condition="FrameDisplayShutterMacroOKInSharedFunctionalGroupSequence"
		InvokeMacro="RespiratorySynchronizationMacro"	Condition="NeedRespiratorySynchronizationMacroInSharedFunctionalGroupSequenceRegardlessOfImageType"
		InvokeMacro="PlaneOrientationVolumeMacro"
		InvokeMacro="TemporalPositionMacro"				Condition="TemporalPositionMacroOKInSharedFunctionalGroupSequence"
		InvokeMacro="ImageDataTypeMacro"				Condition="ImageDataTypeSequenceNotInPerFrameFunctionalGroupSequence"
		InvokeMacro="USImageDescriptionMacro"
		InvokeMacro="USImageDescriptionMacroForEnhancedUSVolume"
	SequenceEnd

	Sequence="PerFrameFunctionalGroupsSequence"			Type="1"	VM="1-n"
		InvokeMacro="FrameContentMacro"
		InvokeMacro="PixelMeasuresMacro"				Condition="PixelMeasuresSequenceNotInSharedFunctionalGroupSequence"
		InvokeMacro="PlanePositionMacro"				Condition="PlanePositionSequenceOKInPerFrameFunctionalGroupSequence"
		InvokeMacro="PlaneOrientationMacro"				Condition="PlaneOrientationSequenceOKInPerFrameFunctionalGroupSequence"
		InvokeMacro="ReferencedImageMacro"				Condition="ReferencedImageMacroOKInPerFrameFunctionalGroupSequence"
		InvokeMacro="DerivationImageMacro"				Condition="DerivationImageMacroOKInPerFrameFunctionalGroupSequence"
		InvokeMacro="CardiacSynchronizationMacro"		Condition="NeedCardiacSynchronizationMacroInPerFrameFunctionalGroupSequenceRegardlessOfImageType"
		InvokeMacro="FrameVOILUTMacro"					Condition="FrameVOILUTSequenceNotInSharedFunctionalGroupSequence"
		InvokeMacro="RealWorldValueMappingMacro"		Condition="RealWorldValueMappingMacroOKInPerFrameFunctionalGroupSequence"
		InvokeMacro="ContrastBolusUsageMacro"			Condition="NeedContrastBolusUsageMacroInPerFrameFunctionalGroupSequence"
		InvokeMacro="PatientOrientationInFrameMacro"	Condition="PatientOrientationInFrameMacroOKInPerFrameFunctionalGroupSequence"
		InvokeMacro="FrameDisplayShutterMacro"			Condition="FrameDisplayShutterMacroOKInPerFrameFunctionalGroupSequence"
		InvokeMacro="RespiratorySynchronizationMacro"	Condition="NeedRespiratorySynchronizationMacroInPerFrameFunctionalGroupSequenceRegardlessOfImageType"
		InvokeMacro="PlanePositionVolumeMacro"
		InvokeMacro="TemporalPositionMacro"				Condition="TemporalPositionMacroOKInPerFrameFunctionalGroupSequence"
		InvokeMacro="ImageDataTypeMacro"				Condition="ImageDataTypeSequenceNotInSharedFunctionalGroupSequence"
	SequenceEnd
ModuleEnd

Module="QTUSEnhancedUltrasoundVolumeProfilePatient"
	Name="IssuerOfPatientID"								Type="1"
ModuleEnd

Module="QTUSEnhancedUltrasoundVolumeProfileStudy"
	Name="StudyDate"										Type="1"
	Name="StudyTime"										Type="1"
	Name="StudyID"											Type="1"
	Name="AccessionNumber"									Type="1"
	Name="StudyDescription"									Type="1"
	Sequence="ProcedureCodeSequence"						Type="1"	VM="1"
		Name="CodeValue"									Type="1"	StringEnumValues="CodeValueForLOINCBreastUltrasound"
		Name="CodingSchemeDesignator"						Type="1"	StringEnumValues="CodingSchemeDesignatorLOINC"
		Name="CodeMeaning"									Type="1"	StringEnumValues="CodeMeaningForLOINCBreastUltrasound"
	SequenceEnd
	Name="PatientSize"										Type="1"
	Name="PatientWeight"									Type="1"
ModuleEnd

Module="QTUSEnhancedUltrasoundVolumeProfileSeries"
	Name="SeriesNumber"										Type="1"
	Name="Laterality"										Type="1"
	Name="SeriesDate"										Type="1"
	Name="SeriesTime"										Type="1"
	Name="SeriesDescription"								Type="1"
	Name="OperatorsName"									Type="1"
	Name="BodyPartExamined"									Type="1"	StringEnumValues="BodyPartExaminedBreast"
ModuleEnd

Module="QTUSEnhancedUltrasoundVolumeProfileFrameOfReference"
	Name="UltrasoundAcquisitionGeometry"					Type="1"	StringEnumValues="UltrasoundAcquisitionGeometryPatient"
	Name="VolumeToTransducerRelationship"					Type="1"	StringEnumValues="VolumeToTransducerRelationshipFixed"

	Name="VolumeToTransducerMappingMatrix"					Type="1"
	Verify="VolumeToTransducerMappingMatrix"							ValueSelector="0"	BinaryEnumValues="One"
	Verify="VolumeToTransducerMappingMatrix"							ValueSelector="1"	BinaryEnumValues="Zero"
	Verify="VolumeToTransducerMappingMatrix"							ValueSelector="2"	BinaryEnumValues="Zero"
	Verify="VolumeToTransducerMappingMatrix"							ValueSelector="3"	BinaryEnumValues="Zero"

	Verify="VolumeToTransducerMappingMatrix"							ValueSelector="4"	BinaryEnumValues="Zero"
	Verify="VolumeToTransducerMappingMatrix"							ValueSelector="5"	BinaryEnumValues="One"
	Verify="VolumeToTransducerMappingMatrix"							ValueSelector="6"	BinaryEnumValues="Zero"
	Verify="VolumeToTransducerMappingMatrix"							ValueSelector="7"	BinaryEnumValues="Zero"

	Verify="VolumeToTransducerMappingMatrix"							ValueSelector="8"	BinaryEnumValues="Zero"
	Verify="VolumeToTransducerMappingMatrix"							ValueSelector="9"	BinaryEnumValues="Zero"
	Verify="VolumeToTransducerMappingMatrix"							ValueSelector="10"	BinaryEnumValues="One"
	Verify="VolumeToTransducerMappingMatrix"							ValueSelector="11"	BinaryEnumValues="Zero"

	Verify="VolumeToTransducerMappingMatrix"							ValueSelector="12"	BinaryEnumValues="Zero"
	Verify="VolumeToTransducerMappingMatrix"							ValueSelector="13"	BinaryEnumValues="Zero"
	Verify="VolumeToTransducerMappingMatrix"							ValueSelector="14"	BinaryEnumValues="Zero"
	Verify="VolumeToTransducerMappingMatrix"							ValueSelector="15"	BinaryEnumValues="One"

	Name="PatientFrameOfReferenceSource"					Type="1"	StringEnumValues="PatientFrameOfReferenceSourceTable"

	Name="TableFrameOfReferenceUID"							Type="1"
	Name="VolumeToTableMappingMatrix"						Type="1"
	Verify="VolumeToTableMappingMatrix"									ValueSelector="0"	BinaryEnumValues="One"
	Verify="VolumeToTableMappingMatrix"									ValueSelector="1"	BinaryEnumValues="Zero"
	Verify="VolumeToTableMappingMatrix"									ValueSelector="2"	BinaryEnumValues="Zero"
	Verify="VolumeToTableMappingMatrix"									ValueSelector="3"	BinaryEnumValues="Zero"

	Verify="VolumeToTableMappingMatrix"									ValueSelector="4"	BinaryEnumValues="Zero"
	Verify="VolumeToTableMappingMatrix"									ValueSelector="5"	BinaryEnumValues="One"
	Verify="VolumeToTableMappingMatrix"									ValueSelector="6"	BinaryEnumValues="Zero"
	Verify="VolumeToTableMappingMatrix"									ValueSelector="7"	BinaryEnumValues="Zero"

	Verify="VolumeToTableMappingMatrix"									ValueSelector="8"	BinaryEnumValues="Zero"
	Verify="VolumeToTableMappingMatrix"									ValueSelector="9"	BinaryEnumValues="Zero"
	Verify="VolumeToTableMappingMatrix"									ValueSelector="10"	BinaryEnumValues="One"
	Verify="VolumeToTableMappingMatrix"									ValueSelector="11"	BinaryEnumValues="Zero"

	Verify="VolumeToTableMappingMatrix"									ValueSelector="12"	BinaryEnumValues="Zero"
	Verify="VolumeToTableMappingMatrix"									ValueSelector="13"	BinaryEnumValues="Zero"
	Verify="VolumeToTableMappingMatrix"									ValueSelector="14"	BinaryEnumValues="Zero"
	Verify="VolumeToTableMappingMatrix"									ValueSelector="15"	BinaryEnumValues="One"

	Name="SynchronizationFrameOfReferenceUID"				Type="1"
	Name="SynchronizationTrigger"							Type="1"	StringEnumValues="SynchronizationTriggerNoTrigger"
	Name="AcquisitionTimeSynchronized"						Type="1"	StringEnumValues="NoLetter"
ModuleEnd

Module="QTUSEnhancedUltrasoundVolumeProfileEquipment"
	Name="Manufacturer"										Type="1"
	Name="InstitutionName"									Type="1"
	Name="InstitutionAddress"								Type="1"
	Name="StationName"										Type="1"
	Name="InstitutionalDepartmentName"						Type="1"
	Name="ManufacturerModelName"							Type="1"
	Name="DeviceSerialNumber"								Type="1"
	Name="SoftwareVersions"									Type="1"
ModuleEnd

Module="QTUSEnhancedUltrasoundVolumeProfileInstance"
	Name="InstanceNumber"									Type="1"
	Name="ContentDate"										Type="1"
	Name="ContentTime"										Type="1"

	Name="ImageType"										Type="1"	VM="4"
	Verify="ImageType"													ValueSelector="0"	StringEnumValues="ImageType1OriginalOnly"
	Verify="ImageType"													ValueSelector="1"	StringEnumValues="ImageType2PrimaryOnly"
	Verify="ImageType"													ValueSelector="2"	StringEnumValues="QTUSImageAndFrameTypeValue3"
	Verify="ImageType"													ValueSelector="3"	StringEnumValues="EmptyValue"

	Name="AcquisitionNumber"								Type="1"
	Name="AcquisitionDateTime"								Type="1"
	Name="BurnedInAnnotation"								Type="1"
	Name="RecognizableVisualFeatures"						Type="1"
	Name="LossyImageCompression"							Type="1"
	Name="PresentationLUTShape"								Type="1"	StringEnumValues="IdentityPresentationLUTShape"

	Name="BitsAllocated"									Type="1"	BinaryEnumValues="BitsAre16"
	Name="BitsStored"										Type="1"	BinaryEnumValues="BitsAre16"
	Name="HighBit"											Type="1"	BinaryEnumValues="BitsAre15"
	Name="PixelRepresentation"								Type="1"	BinaryEnumValues="PixelRepresentationUnsigned"

	Name="PositionMeasuringDeviceUsed"						Type="1"	StringEnumValues="PositionMeasuringDeviceUsedRigid"

	Sequence="ViewCodeSequence"								Type="1"	VM="1"
		Name="CodeValue"									Type="1"	StringEnumValues="CoronalCodeValue"
		Name="CodingSchemeDesignator"						Type="1"	StringEnumValues="CoronalCodingSchemeDesignator"
		Name="CodeMeaning"									Type="1"	StringEnumValues="CoronalCodeMeaning"
	SequenceEnd

	Sequence="AnatomicRegionSequence"						Type="1"	VM="1"
		Name="CodeValue"									Type="1"	StringEnumValues="BreastCodeValue"
		Name="CodingSchemeDesignator"						Type="1"	StringEnumValues="BreastCodingSchemeDesignator"
		Name="CodeMeaning"									Type="1"	StringEnumValues="BreastCodeMeaning"
	SequenceEnd

	Sequence="TransducerScanPatternCodeSequence"			Type="1"	VM="1"
		Name="CodeValue"									Type="1"	StringEnumValues="TransducerScanPatternCodeSequenceCodeValue"
		Name="CodingSchemeDesignator"						Type="1"	StringEnumValues="TransducerScanPatternCodeSequenceCodingSchemeDesignator"
		Name="CodeMeaning"									Type="1"	StringEnumValues="TransducerScanPatternCodeSequenceCodeMeaning"
	SequenceEnd

	Sequence="TransducerGeometryCodeSequence"				Type="1"	VM="1"
		Name="CodeValue"									Type="1"
		Verify="CodeValue"												Condition="ImageTypeValue3IsSoundSpeedOrAttenuation"	StringEnumValues="TransducerGeometryCodeSequenceCodeValueForTransmission"
		Verify="CodeValue"												Condition="ImageTypeValue3IsTissueIntensity"			StringEnumValues="TransducerGeometryCodeSequenceCodeValueForReflection"
		Name="CodingSchemeDesignator"						Type="1"	StringEnumValues="TransducerGeometryCodeSequenceCodingSchemeDesignator"
		Name="CodeMeaning"									Type="1"
		Verify="CodeMeaning"											Condition="ImageTypeValue3IsSoundSpeedOrAttenuation"	StringEnumValues="TransducerGeometryCodeSequenceCodeMeaningForTransmission"
		Verify="CodeMeaning"											Condition="ImageTypeValue3IsTissueIntensity"			StringEnumValues="TransducerGeometryCodeSequenceCodeMeaningForReflection"
	SequenceEnd

	Sequence="TransducerBeamSteeringCodeSequence"			Type="1"	VM="1"
		Name="CodeValue"									Type="1"	StringEnumValues="TransducerBeamSteeringCodeSequenceCodeValue"
		Name="CodingSchemeDesignator"						Type="1"	StringEnumValues="TransducerBeamSteeringCodeSequenceCodingSchemeDesignator"
		Name="CodeMeaning"									Type="1"	StringEnumValues="TransducerBeamSteeringCodeSequenceCodeMeaning"
	SequenceEnd

	Sequence="TransducerApplicationCodeSequence"			Type="1"	VM="1"
		Name="CodeValue"									Type="1"	StringEnumValues="TransducerApplicationCodeSequenceCodeValue"
		Name="CodingSchemeDesignator"						Type="1"	StringEnumValues="TransducerApplicationCodeSequenceCodingSchemeDesignator"
		Name="CodeMeaning"									Type="1"	StringEnumValues="TransducerApplicationCodeSequenceCodeMeaning"
	SequenceEnd

	Sequence="DimensionOrganizationSequence"				Type="1"	VM="1"
		Name="DimensionOrganizationUID"						Type="1"
	SequenceEnd
	Name="DimensionOrganizationType"						Type="1"	StringEnumValues="DimensionOrganizationType3D"
	Sequence="DimensionIndexSequence"						Type="1"	VM="3"
		Name="DimensionIndexPointer"						Type="1"	TagEnumValues="QTUSDimensionOrganization3DDimensionIndexPointerValues"	# do not have sequence item specific selector mechansism so cannot check per item, but can check one of the expected values:(
		Name="FunctionalGroupPointer"						Type="1"	TagEnumValues="QTUSDimensionOrganization3DFunctionalGroupPointerValues"	# do not have sequence item specific selector mechansism so cannot check per item, but can check one of the expected values:(
		Name="DimensionOrganizationUID"						Type="1"
		Name="DimensionDescriptionLabel"					Type="1"	StringEnumValues="QTUSDimensionDescriptionLabel"	# do not have sequence item specific selector mechansism so cannot check per item, but can check one of the expected values:(
	SequenceEnd

	Name="SpecificCharacterSet"								Type="1"	StringEnumValues="SpecificCharacterSetISOIR100"
	Name="InstanceCreationDate"								Type="1"
	Name="InstanceCreationTime"								Type="1"
	Name="InstanceCreatorUID"								Type="1"
	Name="TimezoneOffsetFromUTC"							Type="1"

	Sequence="SharedFunctionalGroupsSequence"				Type="1"	VM="1"
		InvokeMacro="QTUSPixelMeasuresMacro"
		InvokeMacro="PlaneOrientationMacro"
		InvokeMacro="FrameVOILUTMacro"
		InvokeMacro="QTUSRealWorldValueMappingMacro"
		InvokeMacro="PlaneOrientationVolumeMacro"
		InvokeMacro="TemporalPositionMacro"
		InvokeMacro="QTUSTemporalPositionMacro"
		InvokeMacro="QTUSImageDataTypeMacro"
		InvokeMacro="QTUSUSImageDescriptionMacro"
	SequenceEnd

	Sequence="PerFrameFunctionalGroupsSequence"				Type="1"	VM="1-n"
		InvokeMacro="QTUSFrameContentMacro"
		InvokeMacro="PlanePositionMacro"
		InvokeMacro="PlanePositionVolumeMacro"
	SequenceEnd

ModuleEnd

DefineMacro="QTUSFrameContentMacro" InformationEntity="FunctionalGroup"
	Sequence="FrameContentSequence"							Type="1"	VM="1"
		Name="FrameAcquisitionNumber"						Type="1"
		Name="FrameReferenceDateTime"						Type="1"
		Name="FrameAcquisitionDateTime"						Type="1"
		Name="FrameAcquisitionDuration"						Type="1"
		Name="DimensionIndexValues"							Type="1"
		Name="TemporalPositionIndex"						Type="1"	BinaryEnumValues="One"
		Name="StackID"										Type="1"	StringEnumValues="DigitOne"
		Name="InStackPositionNumber"						Type="1"	NotZeroError=""
	SequenceEnd
MacroEnd

DefineMacro="QTUSPixelMeasuresMacro" InformationEntity="FunctionalGroup"
	Sequence="PixelMeasuresSequence"						Type="1"	VM="1"
		Name="PixelSpacing"									Type="1"	NotZeroError=""
		Name="SliceThickness"								Type="1"	NotZeroError=""
		Name="SpacingBetweenSlices"							Type="1"	NotZeroError=""
	SequenceEnd
MacroEnd

DefineMacro="QTUSRealWorldValueMappingMacro" InformationEntity="FunctionalGroup"
	Sequence="RealWorldValueMappingSequence"		Type="1"	VM="1"
		InvokeMacro="QTUSRealWorldValueMappingItemMacro"
	SequenceEnd
MacroEnd

DefineMacro="QTUSRealWorldValueMappingItemMacro" InformationEntity="FunctionalGroup"
	Name="RealWorldValueFirstValueMapped"		Type="1" 	BinaryEnumValues="Zero"
	Name="RealWorldValueLastValueMapped"		Type="1" 	BinaryEnumValues="FFFF"
	Name="RealWorldValueIntercept"				Type="1" 	BinaryEnumValues="Zero"
	Name="RealWorldValueSlope"					Type="1"	# should check scaled values once decided on ... hard to switch on DataType, since in functional group :(
	Name="LUTExplanation"						Type="1"	StringEnumValues="QTUSRealWorldValueMappingLUTExplanation"	# should check scaled values once decided on ... hard to switch on DataType, since in functional group :(
	Name="LUTLabel"								Type="1"	StringEnumValues="QTUSRealWorldValueMappingLUTLabel"	# should check scaled values once decided on ... hard to switch on DataType, since in functional group :(
	Sequence="MeasurementUnitsCodeSequence"		Type="1"	VM="1"	# should check codes once decided on ... hard to switch on DataType, since in functional group :(
		Name="CodeValue"						Type="1"	StringEnumValues="QTUSRealWorldValueMappingMeasurementUnitsCodeValue"
		Name="CodingSchemeDesignator"			Type="1"	StringEnumValues="CodingSchemeDesignatorUCUM"
		Name="CodeMeaning"						Type="1"	StringEnumValues="QTUSRealWorldValueMappingMeasurementUnitsCodeMeaning"
	SequenceEnd
MacroEnd

DefineMacro="QTUSImageDataTypeMacro" InformationEntity="FunctionalGroup"
	Sequence="ImageDataTypeSequence"				Type="1"	VM="1"
		Name="DataType"								Type="1"	StringEnumValues="QTUSEnhancedUSVolumeDataType"
		Verify="DataType"										Condition="ImageTypeValue3IsSoundSpeed"			StringEnumValues="EnhancedUSVolumeDataTypeSoundSpeed"
		Verify="DataType"										Condition="ImageTypeValue3IsAttenuation"		StringEnumValues="EnhancedUSVolumeDataTypeAttenuation"
		Verify="DataType"										Condition="ImageTypeValue3IsTissueIntensity"	StringEnumValues="EnhancedUSVolumeDataTypeTissueIntensity"

		Name="AliasedDataType"						Type="1"	StringEnumValues="NoFull"
		Name="ZeroVelocityPixelValue"				Type="1C"	Condition="ImageTypeValue3IsSoundSpeed"	BinaryEnumValues="Zero"
	SequenceEnd
MacroEnd

DefineMacro="QTUSTemporalPositionMacro" InformationEntity="FunctionalGroup"
	Sequence="TemporalPositionSequence"				Type="1"	VM="1"
		Name="TemporalPositionTimeOffset"			Type="1"  	BinaryEnumValues="Zero"
	SequenceEnd
MacroEnd

DefineMacro="QTUSUSImageDescriptionMacro" InformationEntity="FunctionalGroup"
	Sequence="USImageDescriptionSequence"				Type="1"	VM="1"
		Name="FrameType"								Type="1"	VM="4"
		Verify="FrameType"											ValueSelector="0"	StringEnumValues="ImageType1OriginalOnly"
		Verify="FrameType"											ValueSelector="1"	StringEnumValues="ImageType2PrimaryOnly"
		Verify="FrameType"											ValueSelector="2"	StringEnumValues="QTUSImageAndFrameTypeValue3"
		Verify="FrameType"											Condition="ImageTypeValue3IsSoundSpeed"			ValueSelector="2"	StringEnumValues="QTUSImageAndFrameTypeValue3SoundSpeed"
		Verify="FrameType"											Condition="ImageTypeValue3IsAttenuation"		ValueSelector="2"	StringEnumValues="QTUSImageAndFrameTypeValue3Attenuation"
		Verify="FrameType"											Condition="ImageTypeValue3IsTissueIntensity"	ValueSelector="2"	StringEnumValues="QTUSImageAndFrameTypeValue3SoundSpeed"
		Verify="FrameType"											ValueSelector="3"	StringEnumValues="EmptyValue"
	SequenceEnd
MacroEnd

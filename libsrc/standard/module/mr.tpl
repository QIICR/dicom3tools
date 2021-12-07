DefineMacro="CommonCTMRImageDescriptionImageLevelMacro" InformationEntity="Image"
	Name="PixelPresentation"						Type="1"	StringEnumValues="CommonCTMRPixelPresentationImageLevel"
	Verify="PixelPresentation"									Condition="EnhancedMRColorImageInstance"	StringEnumValues="PixelPresentationTrueColor"
	Name="VolumetricProperties"						Type="1"	StringEnumValues="CommonCTMRVolumetricPropertiesImageLevel"
	Name="VolumeBasedCalculationTechnique"			Type="1"	StringDefinedTerms="CommonCTMRVolumeBasedCalculationTechniqueImageLevel"
MacroEnd

DefineMacro="CommonCTMRImageDescriptionFrameLevelMacro" InformationEntity="Image"
	Name="PixelPresentation"						Type="1"	StringEnumValues="CommonCTMRPixelPresentationFrameLevel"
	Name="VolumetricProperties"						Type="1"	StringEnumValues="CommonCTMRVolumetricPropertiesFrameLevel"
	Name="VolumeBasedCalculationTechnique"			Type="1"	StringDefinedTerms="CommonCTMRVolumeBasedCalculationTechniqueFrameLevel"
MacroEnd

DefineMacro="MRImageDescriptionImageLevelMacro" InformationEntity="Image"
	Name="ComplexImageComponent"				Type="1C"	StringEnumValues="EnhancedMRComplexImageComponentImageLevel"	Condition="NotLegacyConvertedMR" mbpo="true"
	Name="AcquisitionContrast"					Type="1C"	StringEnumValues="EnhancedMRAcquisitionContrastImageLevel"		Condition="NotLegacyConvertedMR" mbpo="true"
	Name="FunctionalSettlingPhaseFramesPresent"	Type="3"	StringEnumValues="YesNoFull"
MacroEnd

DefineMacro="MRImageDescriptionFrameLevelMacro" InformationEntity="Image"
	Name="ComplexImageComponent"				Type="1C"	StringEnumValues="EnhancedMRComplexImageComponentFrameLevel"	Condition="NotLegacyConvertedMR" mbpo="true"
	Name="AcquisitionContrast"					Type="1C"	StringEnumValues="EnhancedMRAcquisitionContrastFrameLevel"		Condition="NotLegacyConvertedMR" mbpo="true"
	Name="FunctionalSettlingPhaseFramesPresent"	Type="3"	StringEnumValues="YesNoFull"
MacroEnd

DefineMacro="MRSpectroscopyDescriptionImageLevelMacro" InformationEntity="Image"
	Name="VolumetricProperties"					Type="1"	StringEnumValues="CommonCTMRVolumetricPropertiesImageLevel"
	Name="VolumeBasedCalculationTechnique"		Type="1"	StringDefinedTerms="MRSpectroscopyVolumeBasedCalculationTechniqueImageLevel"
	Name="ComplexImageComponent"				Type="1"	StringEnumValues="MRSpectroscopyComplexImageComponentImageLevel"
	Name="AcquisitionContrast"					Type="1"	StringEnumValues="MRSpectroscopyAcquisitionContrastImageLevel"
MacroEnd

DefineMacro="MRSpectroscopyDescriptionFrameLevelMacro" InformationEntity="Image"
	Name="VolumetricProperties"					Type="1"	StringEnumValues="CommonCTMRVolumetricPropertiesFrameLevel"
	Name="VolumeBasedCalculationTechnique"		Type="1"	StringDefinedTerms="MRSpectroscopyVolumeBasedCalculationTechniqueFrameLevel"
	Name="ComplexImageComponent"				Type="1"	StringEnumValues="MRSpectroscopyComplexImageComponentFrameLevel"
	Name="AcquisitionContrast"					Type="1"	StringEnumValues="MRSpectroscopyAcquisitionContrastFrameLevel"
MacroEnd

DefineMacro="MRImageFrameTypeMacro" InformationEntity="FunctionalGroup"
	Sequence="MRImageFrameTypeSequence"			Type="1"	VM="1"
		Name="FrameType"						Type="1"	VM="4"
		Verify="FrameType"									ValueSelector="0"	StringEnumValues="CommonEnhancedFrameType1"
		Verify="FrameType"									ValueSelector="1"	StringEnumValues="CommonEnhancedImageAndFrameType2"
		Verify="FrameType"									ValueSelector="2"	StringDefinedTerms="EnhancedMRImageAndFrameType3"
		Verify="FrameType"									ValueSelector="3"	StringDefinedTerms="EnhancedMRFrameType4"
		InvokeMacro="CommonCTMRImageDescriptionFrameLevelMacro"
		InvokeMacro="MRImageDescriptionFrameLevelMacro"
	SequenceEnd
MacroEnd

DefineMacro="MRTimingAndRelatedParametersMacro" InformationEntity="FunctionalGroup"
	Sequence="MRTimingAndRelatedParametersSequence"		Type="1"	VM="1"
		Name="RepetitionTime"							Type="1C"	Condition="Always"	NotZeroWarning=""	# ../MRImageFrameTypeMacro/FrameType[0] == ORIGINAL
		Name="FlipAngle"								Type="1C"	Condition="Always"	NotZeroWarning=""	# ../MRImageFrameTypeMacro/FrameType[0] == ORIGINAL
		Name="EchoTrainLength"							Type="1C"	Condition="Always"	NotZeroWarning=""	# ../MRImageFrameTypeMacro/FrameType[0] == ORIGINAL
		Name="RFEchoTrainLength"						Type="1C"	Condition="Always"	# ../MRImageFrameTypeMacro/FrameType[0] == ORIGINAL
		Name="GradientEchoTrainLength"					Type="1C"	Condition="Always"	# ../MRImageFrameTypeMacro/FrameType[0] == ORIGINAL
		Sequence="SpecificAbsorptionRateSequence"		Type="1C"	VM="1-n"	Condition="Always"	# real world
			Name="SpecificAbsorptionRateDefinition"		Type="1"	StringDefinedTerms="SpecificAbsorptionRateDefinition"
			Name="SpecificAbsorptionRateValue"			Type="1"
		SequenceEnd
		Name="GradientOutputType"						Type="1C"	StringDefinedTerms="GradientOutputType"	Condition="GradientOutputIsPresent"	# real world, but interconnect
		Name="GradientOutput"							Type="1C"	Condition="GradientOutputTypeIsPresent"	# real world, but interconnect
		Sequence="OperatingModeSequence"				Type="1C"	VM="1-n"	Condition="Always"	# real world
			Name="OperatingModeType"					Type="1"	StringDefinedTerms="OperatingModeType"
			Name="OperatingMode"						Type="1"	StringDefinedTerms="OperatingMode"
		SequenceEnd
	SequenceEnd
MacroEnd

DefineMacro="MRFOVGeometryMacro" InformationEntity="FunctionalGroup"
	Sequence="MRFOVGeometrySequence"						Type="1"	VM="1"
		Name="InPlanePhaseEncodingDirection"				Type="1C"	StringEnumValues="InplanePhaseEncodingDirection"	Condition="Always"	# ../MRImageFrameTypeMacro/FrameType[0] == ORIGINAL
		Name="MRAcquisitionFrequencyEncodingSteps"			Type="1C"	Condition="Always"	# ../MRImageFrameTypeMacro/FrameType[0] == ORIGINAL
		Name="MRAcquisitionPhaseEncodingStepsInPlane"		Type="1C"	Condition="Always"	# ../MRImageFrameTypeMacro/FrameType[0] == ORIGINAL
		Name="MRAcquisitionPhaseEncodingStepsOutOfPlane"	Type="1C"	NoCondition=""		# ../MRImageFrameTypeMacro/FrameType[0] == ORIGINAL and /MRAcquisitionType == 3D
		Name="PercentSampling"								Type="1C"	Condition="Always"	NotZeroWarning=""	# ../MRImageFrameTypeMacro/FrameType[0] == ORIGINAL
		Name="PercentPhaseFieldOfView"						Type="1C"	Condition="Always"	NotZeroWarning=""	# ../MRImageFrameTypeMacro/FrameType[0] == ORIGINAL
	SequenceEnd
MacroEnd

DefineMacro="MREchoMacro" InformationEntity="FunctionalGroup"
	Sequence="MREchoSequence"				Type="1"	VM="1"
		Name="EffectiveEchoTime"			Type="1"
	SequenceEnd
MacroEnd

DefineMacro="MRModifierMacro" InformationEntity="FunctionalGroup"
	Sequence="MRModifierSequence"					Type="1"	VM="1"
		Name="InversionRecovery"					Type="1C"	StringEnumValues="YesNoFull"			Condition="Always"	# ../MRImageFrameTypeMacro/FrameType[0] == ORIGINAL
		Name="InversionTimes"						Type="1C"							Condition="InversionRecoveryIsYes"	# also should check FrameType[0] :(
		Name="FlowCompensation"						Type="1C"	StringDefinedTerms="FlowCompensation"		Condition="Always"	# ../MRImageFrameTypeMacro/FrameType[0] == ORIGINAL
		Name="FlowCompensationDirection"			Type="1C"	StringEnumValues="FlowCompensationDirection"	Condition="FlowCompensationNotNone"	# also should check FrameType[0] etc. :(
		Name="Spoiling"								Type="1C"	StringEnumValues="Spoiling"			NoCondition=""	# EchoPulseSequenceGradientOrBoth (macro can't access root list), also should check FrameType[0] etc. :(
		Name="T2Preparation"						Type="1C"	StringEnumValues="YesNoFull"			Condition="Always"	# should check FrameType[0] etc. :(
		Name="SpectrallySelectedExcitation"			Type="1C"	StringEnumValues="SpectrallySelectedExcitation"	Condition="Always"	# should check FrameType[0] etc. :(
		Name="SpatialPresaturation"					Type="1C"	StringEnumValues="SpatialPresaturation"		Condition="Always"	# should check FrameType[0] etc. :(
		Name="PartialFourier"						Type="1C"	StringEnumValues="YesNoFull"			Condition="Always"	# should check FrameType[0] etc. :(
		Name="PartialFourierDirection"				Type="1C"	StringEnumValues="PartialFourierDirection"	Condition="PartialFourierIsYes"	# should check FrameType[0] etc. :(
		Name="ParallelAcquisition"					Type="1C"	StringEnumValues="YesNoFull"			Condition="Always"	# should check FrameType[0] etc. :(
		Name="ParallelAcquisitionTechnique"			Type="1C"	StringEnumValues="ParallelAcquisitionTechnique"	Condition="ParallelAcquisitionIsYes"	# should check FrameType[0] etc. :(
		Name="ParallelReductionFactorInPlane"		Type="1C"							Condition="ParallelAcquisitionIsYes"	# should check FrameType[0] etc. :(
		Name="ParallelReductionFactorOutOfPlane"	Type="1C"							Condition="ParallelAcquisitionIsYes"	# should check FrameType[0] etc. :(
		Name="ParallelReductionFactorSecondInPlane"	Type="1C"							Condition="ParallelAcquisitionIsYes"	# should check is spectroscopy instance and FrameType[0] etc. :(
	SequenceEnd
MacroEnd

DefineMacro="MRImagingModifierMacro" InformationEntity="FunctionalGroup"
	Sequence="MRImagingModifierSequence"			Type="1"	VM="1"
		Name="MagnetizationTransfer"				Type="1C"	StringEnumValues="MagnetizationTransfer"	Condition="Always"	# should check FrameType[0] etc. :(
		Name="BloodSignalNulling"					Type="1C"	StringEnumValues="YesNoFull"			Condition="Always"	# should check FrameType[0] etc. :(
		Name="Tagging"								Type="1C"	StringEnumValues="Tagging"			Condition="Always"	# should check FrameType[0] etc. :(
		Name="TagSpacingFirstDimension"				Type="1C"	NotZeroWarning=""							Condition="TaggingIsGridOrLine"	# should check FrameType[0] etc. :(
		Name="TagSpacingSecondDimension"			Type="1C"	NotZeroWarning=""							Condition="TaggingIsGrid"	# should check FrameType[0] etc. :(
		Name="TagAngleFirstAxis"					Type="1C"							Condition="TaggingIsGridOrLine"	# should check FrameType[0] etc. :(
		Name="TagAngleSecondAxis"					Type="1C"							Condition="TaggingIsGrid"	# should check FrameType[0] etc. :(
		Name="TagThickness"							Type="1C"	NotZeroWarning=""							Condition="TaggingIsGridOrLine"	# should check FrameType[0] etc. :(
		Name="TaggingDelay"							Type="3"
		Name="TransmitterFrequency"					Type="1C"	NotZeroWarning=""							Condition="Always"	# should check FrameType[0] etc. :(
		Name="PixelBandwidth"						Type="1C"	NotZeroWarning=""							Condition="Always"	# should check FrameType[0] etc. :(
	SequenceEnd
MacroEnd

DefineMacro="MRReceiveCoilMacro" InformationEntity="FunctionalGroup"
	Sequence="MRReceiveCoilSequence"			Type="1"	VM="1-n"
		Name="ReceiveCoilName"					Type="1"
		Name="ReceiveCoilManufacturerName"		Type="2"
		Name="ReceiveCoilType"					Type="1"	StringDefinedTerms="ReceiveCoilType"
		Name="QuadratureReceiveCoil"			Type="1"	StringEnumValues="YesNoFull"
		Sequence="MultiCoilDefinitionSequence"	Type="1C"	VM="1-n"					Condition="ReceiveCoilTypeIsMultiCoil"	# should check FrameType[0] etc. :(
			Name="MultiCoilElementName"			Type="1"
			Name="MultiCoilElementUsed"			Type="1"	StringEnumValues="YesNoFull"
		SequenceEnd
		Name="MultiCoilConfiguration"			Type="3"
	SequenceEnd
MacroEnd

DefineMacro="MRTransmitCoilMacro" InformationEntity="FunctionalGroup"
	Sequence="MRTransmitCoilSequence"			Type="1"	VM="1"
		Name="TransmitCoilName"					Type="1"
		Name="TransmitCoilManufacturerName"		Type="2"
		Name="TransmitCoilType"					Type="1"	StringDefinedTerms="TransmitCoilType"
	SequenceEnd
MacroEnd

DefineMacro="MRDiffusionMacro" InformationEntity="FunctionalGroup"
	Sequence="MRDiffusionSequence"						Type="1"	VM="1"
		Name="DiffusionBValue"							Type="1C"	NoCondition=""	# should check FrameType[0] etc. :(
		Name="DiffusionDirectionality"					Type="1C"	StringDefinedTerms="DiffusionDirectionality"	Condition="Always"	# should check FrameType[0] etc. :(
		Sequence="DiffusionGradientDirectionSequence"	Type="1C"	VM="1"				Condition="DiffusionDirectionalityIsDirectional" mbpo="true" # really should check if DiffusionDirectionality is BMATRIX
			Name="DiffusionGradientOrientation"			Type="1"
		SequenceEnd
		Sequence="DiffusionBMatrixSequence"				Type="1C"	VM="1"				Condition="DiffusionDirectionalityIsBMatrix"
			Name="DiffusionBValueXX"					Type="1"
			Name="DiffusionBValueXY"					Type="1"
			Name="DiffusionBValueXZ"					Type="1"
			Name="DiffusionBValueYY"					Type="1"
			Name="DiffusionBValueYZ"					Type="1"
			Name="DiffusionBValueZZ"					Type="1"
		SequenceEnd
		Name="DiffusionAnisotropyType"					Type="1C"	Condition="NeedDiffusionAnisotropyType"	StringDefinedTerms="DiffusionAnisotropyType" mbpo="true" # really shouldn't have mbpo, but account for inadequate condition using ImageType rather than 9current) FraneType
	SequenceEnd
MacroEnd

DefineMacro="MRAveragesMacro" InformationEntity="FunctionalGroup"
	Sequence="MRAveragesSequence"				Type="1"	VM="1"
		Name="NumberOfAverages"					Type="1"	NotZeroWarning=""
	SequenceEnd
MacroEnd

DefineMacro="MRSpatialSaturationMacro" InformationEntity="FunctionalGroup"
	Sequence="MRSpatialSaturationSequence"			Type="2"	VM="0-n"
		Name="SlabThickness"						Type="1"	NotZeroWarning=""
		Name="SlabOrientation"						Type="1"
		Name="MidSlabPosition"						Type="1"
	SequenceEnd
MacroEnd

DefineMacro="MRMetaboliteMapMacro" InformationEntity="FunctionalGroup"
	Sequence="MRMetaboliteMapSequence"							Type="1"	VM="1"
		Name="MetaboliteMapDescription"							Type="1"
		Sequence="MetaboliteMapCodeSequence"					Type="3"	VM="1"
			InvokeMacro="CodeSequenceMacro"
		SequenceEnd
		Sequence="ChemicalShiftSequence"						Type="3"	VM="1-n"
			Name="ChemicalShiftMinimumIntegrationLimitInppm"	Type="1"
			Name="ChemicalShiftMaximumIntegrationLimitInppm"	Type="1"
		SequenceEnd
	SequenceEnd
MacroEnd

DefineMacro="MRVelocityEncodingMacro" InformationEntity="FunctionalGroup"
	Sequence="MRVelocityEncodingSequence"		Type="1"	VM="1-n"
		Name="VelocityEncodingDirection"		Type="1"
		Name="VelocityEncodingMinimumValue"		Type="1"
		Name="VelocityEncodingMaximumValue"		Type="1"
	SequenceEnd
MacroEnd

DefineMacro="MRArterialSpinLabelingMacro" InformationEntity="FunctionalGroup"
	Sequence="MRArterialSpinLabelingSequence"	Type="1"	VM="1-n"
		Name="ASLTechniqueDescription"			Type="2"
		Name="ASLContext"						Type="1C"	NoCondition="" mbpo="true" StringEnumValues="ASLContext"	# FrameType is ORIGINAL too hard :(
		Sequence="ASLSlabSequence"				Type="1C"	VM="1-n" Condition="ASLContextIsControlLOrLabel" mbpo="true"
			Name="ASLSlabNumber"				Type="1"
			InvokeMacro="GeneralAnatomyOptionalMacro"
			Name="ASLSlabThickness"				Type="1"
			Name="ASLSlabOrientation"			Type="1"
			Name="ASLMidSlabPosition"			Type="1"
			Name="ASLPulseTrainDuration"		Type="1"
		SequenceEnd
		Name="ASLCrusherFlag"					Type="1"	StringEnumValues="YesNoFull"
		Name="ASLCrusherFlowLimit"				Type="1C"	Condition="ASLCrusherFlagIsYes"
		Name="ASLCrusherDescription"			Type="1C"	Condition="ASLCrusherFlagIsYes"
		Name="ASLBolusCutoffFlag"				Type="1"	StringEnumValues="YesNoFull"
		Sequence="ASLBolusCutoffTimingSequence"	Type="1C"	VM="1" Condition="ASLBolusCutoffFlagIsYes"
			Name="ASLBolusCutoffDelayTime"		Type="1"
			Name="ASLBolusCutoffTechnique"		Type="2"
		SequenceEnd
	SequenceEnd
MacroEnd

DefineMacro="FunctionalMRMacro"
	Sequence="FunctionalMRSequence"				Type="1"	VM="1"
		Name="SettlingPhaseFrame"				Type="1C"	Condition="FunctionalSettlingPhaseFramesPresentIsYes"	StringEnumValues="YesNoFull"
		Name="FunctionalSyncPulse"				Type="1"
	SequenceEnd
MacroEnd

DefineMacro="MRImageAndSpectroscopyInstanceMacro" InformationEntity="Image"
	Name="AcquisitionNumber"						Type="3"
	Name="AcquisitionDateTime"						Type="1C"	Condition="ImageTypeValue1OriginalOrMixedAndNotLegacyConvertedMR" mbpo="true"
	Name="AcquisitionDuration"						Type="1C"	Condition="ImageTypeValue1OriginalOrMixedAndNotLegacyConvertedMR" mbpo="true"
	Sequence="ReferencedRawDataSequence"			Type="3"	VM="1-n"
		InvokeMacro="HierarchicalSOPInstanceReferenceMacro"
	SequenceEnd
	Sequence="ReferencedWaveformSequence"			Type="3"	VM="1-n"
		InvokeMacro="HierarchicalSOPInstanceReferenceMacro"
	SequenceEnd
	Sequence="ReferencedImageEvidenceSequence"		Type="1C"	VM="1-n"	Condition="ReferencedImageSequenceIsPresentInFunctionalGroups"
		InvokeMacro="HierarchicalSOPInstanceReferenceMacro"
	SequenceEnd
	Sequence="SourceImageEvidenceSequence"			Type="1C"	VM="1-n"	Condition="SourceImageSequenceIsPresentInFunctionalGroups"
		InvokeMacro="HierarchicalSOPInstanceReferenceMacro"
	SequenceEnd
	Sequence="ReferencedPresentationStateSequence"	Type="1C"	VM="1-n"	NoCondition=""	# real world
		InvokeMacro="HierarchicalSOPInstanceReferenceMacro"
	SequenceEnd
	Name="ContentQualification"						Type="1C"	StringEnumValues="ContentQualification"	Condition="NotLegacyConvertedMR" mbpo="true"
	Name="ResonantNucleus"							Type="1C"	StringDefinedTerms="ResonantNucleus"	Condition="ImageTypeValue1OriginalOrMixedAndNotLegacyConvertedMR" mbpo="true"
	Name="KSpaceFiltering"							Type="1C"	StringDefinedTerms="KSpaceFiltering"	Condition="ImageTypeValue1OriginalOrMixedAndNotLegacyConvertedMR" mbpo="true"
	Name="MagneticFieldStrength"					Type="1C"	NotZeroWarning=""						Condition="ImageTypeValue1OriginalOrMixedAndNotLegacyConvertedMR" mbpo="true"
	Name="ApplicableSafetyStandardAgency"			Type="1C"	StringDefinedTerms="ApplicableSafetyStandardAgency"	Condition="NotLegacyConvertedMR" mbpo="true"
	Name="ApplicableSafetyStandardDescription"		Type="3"
	Name="ImageComments"							Type="3"
	Name="IsocenterPosition"						Type="3"
	Name="B1rms"									Type="3"
MacroEnd

Module="MultiFrameFunctionalGroupsForEnhancedMRImage"
	Sequence="SharedFunctionalGroupsSequence"	Type="1"	VM="1"
		InvokeMacro="PixelMeasuresMacro"		Condition="PixelMeasuresSequenceNotInPerFrameFunctionalGroupSequence"
		InvokeMacro="PlanePositionMacro"		Condition="PlanePositionSequenceNotInPerFrameFunctionalGroupSequence"
		InvokeMacro="PlaneOrientationMacro"		Condition="PlaneOrientationSequenceNotInPerFrameFunctionalGroupSequence"
		InvokeMacro="ReferencedImageMacro"		Condition="ReferencedImageMacroOKInSharedFunctionalGroupSequence"
		InvokeMacro="DerivationImageMacro"		Condition="DerivationImageMacroOKInSharedFunctionalGroupSequence"
		InvokeMacro="CardiacSynchronizationMacro"		Condition="NeedCardiacSynchronizationMacroInSharedFunctionalGroupSequence"
		InvokeMacro="FrameAnatomyMacro"			Condition="FrameAnatomySequenceNotInPerFrameFunctionalGroupSequence"
		InvokeMacro="PixelValueTransformationMacro"	Condition="PixelValueTransformationSequenceNotInPerFrameFunctionalGroupSequenceAndPhotometricInterpretationIsMonochrome2"
		InvokeMacro="FrameVOILUTMacro"			Condition="FrameVOILUTMacroOKInSharedFunctionalGroupSequenceAndPhotometricInterpretationIsMonochrome2"
		InvokeMacro="RealWorldValueMappingMacro"	Condition="RealWorldValueMappingMacroOKInSharedFunctionalGroupSequenceAndPhotometricInterpretationIsMonochrome2"
		InvokeMacro="ContrastBolusUsageMacro"		Condition="NeedContrastBolusUsageMacroInSharedFunctionalGroupSequence"
		InvokeMacro="RespiratorySynchronizationMacro"		Condition="NeedRespiratorySynchronizationMacroInSharedFunctionalGroupSequence"
		InvokeMacro="MRImageFrameTypeMacro"		Condition="MRImageFrameTypeSequenceNotInPerFrameFunctionalGroupSequence"
		InvokeMacro="MRTimingAndRelatedParametersMacro"	Condition="NeedMRTimingAndRelatedParametersMacroInSharedFunctionalGroupSequence"
		InvokeMacro="MRFOVGeometryMacro"		Condition="NeedMRFOVGeometryMacroInSharedFunctionalGroupSequence"
		InvokeMacro="MREchoMacro"			Condition="NeedMREchoMacroInSharedFunctionalGroupSequence"
		InvokeMacro="MRModifierMacro"			Condition="NeedMRModifierMacroInSharedFunctionalGroupSequence"
		InvokeMacro="MRImagingModifierMacro"		Condition="NeedMRImagingModifierMacroInSharedFunctionalGroupSequence"
		InvokeMacro="MRReceiveCoilMacro"		Condition="NeedMRReceiveCoilMacroInSharedFunctionalGroupSequence"
		InvokeMacro="MRTransmitCoilMacro"		Condition="NeedMRTransmitCoilMacroInSharedFunctionalGroupSequence"
		InvokeMacro="MRDiffusionMacro"			Condition="NeedMRDiffusionMacroInSharedFunctionalGroupSequence"
		InvokeMacro="MRAveragesMacro"			Condition="NeedMRAveragesMacroInSharedFunctionalGroupSequence"
		InvokeMacro="MRSpatialSaturationMacro"		Condition="NeedMRSpatialSaturationMacroInSharedFunctionalGroupSequence"
		InvokeMacro="MRMetaboliteMapMacro"		Condition="NeedMRMetaboliteMapMacroInSharedFunctionalGroupSequence"
		InvokeMacro="MRVelocityEncodingMacro"		Condition="NeedMRVelocityEncodingMacroInSharedFunctionalGroupSequence"
		InvokeMacro="MRArterialSpinLabelingMacro"		Condition="NeedMRArterialSpinLabelingMacroInSharedFunctionalGroupSequence"
		InvokeMacro="FunctionalMRMacro"		Condition="FunctionalMRMacroOKInSharedFunctionalGroupSequence"
		InvokeMacro="TemporalPositionMacro"			Condition="TemporalPositionMacroOKInSharedFunctionalGroupSequence"
	SequenceEnd
	Sequence="PerFrameFunctionalGroupsSequence"	Type="1"	VM="1-n"
		InvokeMacro="PixelMeasuresMacro"		Condition="PixelMeasuresSequenceNotInSharedFunctionalGroupSequence"
		InvokeMacro="FrameContentMacro"
		InvokeMacro="PlanePositionMacro"		Condition="PlanePositionSequenceNotInSharedFunctionalGroupSequence"
		InvokeMacro="PlaneOrientationMacro"		Condition="PlaneOrientationSequenceNotInSharedFunctionalGroupSequence"
		InvokeMacro="ReferencedImageMacro"		Condition="ReferencedImageMacroOKInPerFrameFunctionalGroupSequence"
		InvokeMacro="DerivationImageMacro"		Condition="DerivationImageMacroOKInPerFrameFunctionalGroupSequence"
		InvokeMacro="CardiacSynchronizationMacro"		Condition="NeedCardiacSynchronizationMacroInPerFrameFunctionalGroupSequence"
		InvokeMacro="FrameAnatomyMacro"			Condition="FrameAnatomySequenceNotInSharedFunctionalGroupSequence"
		InvokeMacro="PixelValueTransformationMacro"	Condition="PixelValueTransformationSequenceNotInSharedFunctionalGroupSequenceAndPhotometricInterpretationIsMonochrome2"
		InvokeMacro="FrameVOILUTMacro"			Condition="FrameVOILUTMacroOKInPerFrameFunctionalGroupSequenceAndPhotometricInterpretationIsMonochrome2"
		InvokeMacro="RealWorldValueMappingMacro"	Condition="RealWorldValueMappingMacroOKInPerFrameFunctionalGroupSequenceAndPhotometricInterpretationIsMonochrome2"
		InvokeMacro="ContrastBolusUsageMacro"		Condition="NeedContrastBolusUsageMacroInPerFrameFunctionalGroupSequence"
		InvokeMacro="RespiratorySynchronizationMacro"		Condition="NeedRespiratorySynchronizationMacroInPerFrameFunctionalGroupSequence"
		InvokeMacro="MRImageFrameTypeMacro"		Condition="MRImageFrameTypeSequenceNotInSharedFunctionalGroupSequence"
		InvokeMacro="MRTimingAndRelatedParametersMacro"	Condition="NeedMRTimingAndRelatedParametersMacroInPerFrameFunctionalGroupSequence"
		InvokeMacro="MRFOVGeometryMacro"		Condition="NeedMRFOVGeometryMacroInPerFrameFunctionalGroupSequence"
		InvokeMacro="MREchoMacro"			Condition="NeedMREchoMacroInPerFrameFunctionalGroupSequence"
		InvokeMacro="MRModifierMacro"			Condition="NeedMRModifierMacroInPerFrameFunctionalGroupSequence"
		InvokeMacro="MRImagingModifierMacro"		Condition="NeedMRImagingModifierMacroInPerFrameFunctionalGroupSequence"
		InvokeMacro="MRReceiveCoilMacro"		Condition="NeedMRReceiveCoilMacroInPerFrameFunctionalGroupSequence"
		InvokeMacro="MRTransmitCoilMacro"		Condition="NeedMRTransmitCoilMacroInPerFrameFunctionalGroupSequence"
		InvokeMacro="MRDiffusionMacro"			Condition="NeedMRDiffusionMacroInPerFrameFunctionalGroupSequence"
		InvokeMacro="MRAveragesMacro"			Condition="NeedMRAveragesMacroInPerFrameFunctionalGroupSequence"
		InvokeMacro="MRSpatialSaturationMacro"		Condition="NeedMRSpatialSaturationMacroInPerFrameFunctionalGroupSequence"
		InvokeMacro="MRMetaboliteMapMacro"		Condition="NeedMRMetaboliteMapMacroInPerFrameFunctionalGroupSequence"
		InvokeMacro="MRVelocityEncodingMacro"		Condition="NeedMRVelocityEncodingMacroInPerFrameFunctionalGroupSequence"
		InvokeMacro="MRArterialSpinLabelingMacro"		Condition="NeedMRArterialSpinLabelingMacroInPerFrameFunctionalGroupSequence"
		InvokeMacro="FunctionalMRMacro"		Condition="FunctionalMRMacroOKInPerFrameFunctionalGroupSequence"
		InvokeMacro="TemporalPositionMacro"			Condition="TemporalPositionMacroOKInPerFrameFunctionalGroupSequence"
	SequenceEnd
ModuleEnd

DefineMacro="MRSpectroscopyFrameTypeMacro" InformationEntity="FunctionalGroup"
	Sequence="MRSpectroscopyFrameTypeSequence"	Type="1"	VM="1"
		Name="FrameType"						Type="1"	VM="4"
		Verify="FrameType"								ValueSelector="0"	StringEnumValues="CommonEnhancedFrameType1"
		Verify="FrameType"								ValueSelector="1"	StringEnumValues="CommonEnhancedImageAndFrameType2"
		Verify="FrameType"								ValueSelector="2"	StringDefinedTerms="EnhancedMRSpectroscopyImageAndFrameType3"
		Verify="FrameType"								ValueSelector="3"	StringDefinedTerms="EnhancedMRSpectroscopyFrameType4"
		InvokeMacro="MRSpectroscopyDescriptionFrameLevelMacro"
	SequenceEnd
MacroEnd

DefineMacro="MRSpectroscopyFOVGeometryMacro" InformationEntity="FunctionalGroup"
	Sequence="MRSpectroscopyFOVGeometrySequence"			Type="1"	VM="1"
		Name="SpectroscopyAcquisitionDataColumns"			Type="1C"	NotZeroWarning=""	Condition="Always"	# ../MRImageFrameTypeMacro/FrameType[0] == ORIGINAL
		Name="SpectroscopyAcquisitionPhaseRows"				Type="1C"	NotZeroWarning=""	Condition="Always"	# ../MRImageFrameTypeMacro/FrameType[0] == ORIGINAL
		Name="SpectroscopyAcquisitionPhaseColumns"			Type="1C"	NotZeroWarning=""	Condition="Always"	# ../MRImageFrameTypeMacro/FrameType[0] == ORIGINAL
		Name="SpectroscopyAcquisitionOutOfPlanePhaseSteps"	Type="1C"	NotZeroWarning=""	NoCondition=""		# ../MRImageFrameTypeMacro/FrameType[0] == ORIGINAL and /MRSpectroscopyAcquisitionType == PLANE
		Name="PercentSampling"								Type="1C"	NotZeroWarning=""	Condition="Always"	# ../MRImageFrameTypeMacro/FrameType[0] == ORIGINAL
		Name="PercentPhaseFieldOfView"						Type="1C"	NotZeroWarning=""	Condition="Always"	# ../MRImageFrameTypeMacro/FrameType[0] == ORIGINAL
	SequenceEnd
MacroEnd

Module="MultiFrameFunctionalGroupsForMRSpectroscopy"
	Sequence="SharedFunctionalGroupsSequence"	Type="1"	VM="1"
		InvokeMacro="PixelMeasuresMacro"		Condition="PixelMeasuresSequenceNotInPerFrameFunctionalGroupSequence"
		InvokeMacro="PlanePositionMacro"		Condition="PlanePositionSequenceNotInPerFrameFunctionalGroupSequence"
		InvokeMacro="PlaneOrientationMacro"		Condition="PlaneOrientationSequenceNotInPerFrameFunctionalGroupSequence"
		InvokeMacro="ReferencedImageMacro"		Condition="ReferencedImageMacroOKInSharedFunctionalGroupSequence"
		InvokeMacro="DerivationImageMacro"		Condition="DerivationImageMacroOKInSharedFunctionalGroupSequence"
		InvokeMacro="CardiacSynchronizationMacro"		Condition="NeedCardiacSynchronizationMacroInSharedFunctionalGroupSequence"
		InvokeMacro="FrameAnatomyMacro"			Condition="FrameAnatomySequenceNotInPerFrameFunctionalGroupSequence"
		InvokeMacro="ContrastBolusUsageMacro"		Condition="NeedContrastBolusUsageMacroInSharedFunctionalGroupSequence"
		InvokeMacro="RespiratorySynchronizationMacro"		Condition="NeedRespiratorySynchronizationMacroInSharedFunctionalGroupSequence"
		InvokeMacro="MRSpectroscopyFrameTypeMacro"	Condition="MRSpectroscopyFrameTypeSequenceNotInPerFrameFunctionalGroupSequence"
		InvokeMacro="MRTimingAndRelatedParametersMacro"	Condition="NeedMRTimingAndRelatedParametersMacroInSharedFunctionalGroupSequence"
		InvokeMacro="MRSpectroscopyFOVGeometryMacro"	Condition="NeedMRSpectroscopyFOVGeometryMacroInSharedFunctionalGroupSequence"
		InvokeMacro="MREchoMacro"			Condition="NeedMREchoMacroInSharedFunctionalGroupSequence"
		InvokeMacro="MRModifierMacro"			Condition="NeedMRModifierMacroInSharedFunctionalGroupSequence"
		InvokeMacro="MRReceiveCoilMacro"		Condition="NeedMRReceiveCoilMacroInSharedFunctionalGroupSequence"
		InvokeMacro="MRTransmitCoilMacro"		Condition="NeedMRTransmitCoilMacroInSharedFunctionalGroupSequence"
		InvokeMacro="MRDiffusionMacro"			Condition="NeedMRDiffusionMacroInSharedFunctionalGroupSequence"
		InvokeMacro="MRAveragesMacro"			Condition="NeedMRAveragesMacroInSharedFunctionalGroupSequence"
		InvokeMacro="MRSpatialSaturationMacro"		Condition="NeedMRSpatialSaturationMacroInSharedFunctionalGroupSequence"
		InvokeMacro="MRVelocityEncodingMacro"		Condition="NeedMRVelocityEncodingMacroInSharedFunctionalGroupSequence"
		InvokeMacro="TemporalPositionMacro"			Condition="TemporalPositionMacroOKInSharedFunctionalGroupSequence"
	SequenceEnd
	Sequence="PerFrameFunctionalGroupsSequence"	Type="1"	VM="1-n"
		InvokeMacro="PixelMeasuresMacro"		Condition="PixelMeasuresSequenceNotInSharedFunctionalGroupSequence"
		InvokeMacro="FrameContentMacro"
		InvokeMacro="PlanePositionMacro"		Condition="PlanePositionSequenceNotInSharedFunctionalGroupSequence"
		InvokeMacro="PlaneOrientationMacro"		Condition="PlaneOrientationSequenceNotInSharedFunctionalGroupSequence"
		InvokeMacro="ReferencedImageMacro"		Condition="ReferencedImageMacroOKInPerFrameFunctionalGroupSequence"
		InvokeMacro="DerivationImageMacro"		Condition="DerivationImageMacroOKInPerFrameFunctionalGroupSequence"
		InvokeMacro="CardiacSynchronizationMacro"		Condition="NeedCardiacSynchronizationMacroInPerFrameFunctionalGroupSequence"
		InvokeMacro="FrameAnatomyMacro"			Condition="FrameAnatomySequenceNotInSharedFunctionalGroupSequence"
		InvokeMacro="ContrastBolusUsageMacro"		Condition="NeedContrastBolusUsageMacroInPerFrameFunctionalGroupSequence"
		InvokeMacro="RespiratorySynchronizationMacro"		Condition="NeedRespiratorySynchronizationMacroInPerFrameFunctionalGroupSequence"
		InvokeMacro="MRSpectroscopyFrameTypeMacro"	Condition="MRSpectroscopyFrameTypeSequenceNotInSharedFunctionalGroupSequence"
		InvokeMacro="MRTimingAndRelatedParametersMacro"	Condition="NeedMRTimingAndRelatedParametersMacroInPerFrameFunctionalGroupSequence"
		InvokeMacro="MRSpectroscopyFOVGeometryMacro"	Condition="NeedMRSpectroscopyFOVGeometryMacroInPerFrameFunctionalGroupSequence"
		InvokeMacro="MREchoMacro"			Condition="NeedMREchoMacroInPerFrameFunctionalGroupSequence"
		InvokeMacro="MRModifierMacro"			Condition="NeedMRModifierMacroInPerFrameFunctionalGroupSequence"
		InvokeMacro="MRReceiveCoilMacro"		Condition="NeedMRReceiveCoilMacroInPerFrameFunctionalGroupSequence"
		InvokeMacro="MRTransmitCoilMacro"		Condition="NeedMRTransmitCoilMacroInPerFrameFunctionalGroupSequence"
		InvokeMacro="MRDiffusionMacro"			Condition="NeedMRDiffusionMacroInPerFrameFunctionalGroupSequence"
		InvokeMacro="MRAveragesMacro"			Condition="NeedMRAveragesMacroInPerFrameFunctionalGroupSequence"
		InvokeMacro="MRSpatialSaturationMacro"		Condition="NeedMRSpatialSaturationMacroInPerFrameFunctionalGroupSequence"
		InvokeMacro="MRVelocityEncodingMacro"		Condition="NeedMRVelocityEncodingMacroInPerFrameFunctionalGroupSequence"
		InvokeMacro="TemporalPositionMacro"			Condition="TemporalPositionMacroOKInPerFrameFunctionalGroupSequence"
	SequenceEnd
ModuleEnd

Module="EnhancedMRImage"
	InvokeMacro="MRImageAndSpectroscopyInstanceMacro"
	Name="ImageType"								Type="1"	VM="4"
	Verify="ImageType"											ValueSelector="0"	StringEnumValues="CommonEnhancedImageType1"
	Verify="ImageType"											ValueSelector="1"	StringEnumValues="CommonEnhancedImageAndFrameType2"
	Verify="ImageType"											ValueSelector="2"	StringDefinedTerms="EnhancedMRImageAndFrameType3"
	Verify="ImageType"											ValueSelector="3"	StringDefinedTerms="EnhancedMRImageType4"
	InvokeMacro="CommonCTMRImageDescriptionImageLevelMacro"
	InvokeMacro="MRImageDescriptionImageLevelMacro"

	Name="SamplesPerPixel"							Type="1"
	Verify="SamplesPerPixel"									Condition="PhotometricInterpretationIsMonochrome"	BinaryEnumValues="SamplesPerPixelIsOne"
	Verify="SamplesPerPixel"									Condition="PhotometricInterpretationIsColor"		BinaryEnumValues="SamplesPerPixelIsThree"

	Name="PhotometricInterpretation"				Type="1"
	Verify="PhotometricInterpretation"							Condition="EnhancedMRImageInstance"      StringEnumValues="PhotometricInterpretationMonochrome2"
	Verify="PhotometricInterpretation"							Condition="EnhancedMRColorImageInstance" StringEnumValues="PhotometricInterpretationRGBOrYBR_FULL_422OrYBR_RCTOrYBR_ICTOrYBR_PARTIAL_420"

	Verify="PhotometricInterpretation"				Condition="UncompressedTransferSyntaxAndThreeSamples"					StringEnumValues="PhotometricInterpretationRGB"
	Verify="PhotometricInterpretation"				Condition="JPEGLSLosslessTransferSyntaxAndThreeSamples"					StringEnumValues="PhotometricInterpretationRGB"
	Verify="PhotometricInterpretation"				Condition="JPEG2000TransferSyntaxAndThreeSamples"						StringEnumValues="PhotometricInterpretationYBRRCTOrICT"
	Verify="PhotometricInterpretation"				Condition="JPEG2000LosslessTransferSyntaxAndThreeSamples"				StringEnumValues="PhotometricInterpretationYBRRCT"
	Verify="PhotometricInterpretation"				Condition="MPEG2TransferSyntax"											StringEnumValues="PhotometricInterpretationYBRPartial420"	# regardless of number of samples (required to be 3 by PS 3.5)
	Verify="PhotometricInterpretation"				Condition="JPEGLossyTransferSyntaxAndThreeSamples"						StringEnumValues="PhotometricInterpretationYBRFull422"
	Verify="PhotometricInterpretation"				Condition="RLETransferSyntaxAndThreeSamples"							StringEnumValues="PhotometricInterpretationYBRFullOrRGB"

	Name="BitsAllocated"							Type="1"	
	Verify="BitsAllocated"										Condition="PhotometricInterpretationIsMonochrome"	BinaryEnumValues="BitsAre8Or16"
	Verify="BitsAllocated"										Condition="PhotometricInterpretationIsColor"		BinaryEnumValues="BitsAre8"

	Name="BitsStored"								Type="1"
	Verify="BitsStored"											Condition="PhotometricInterpretationIsMonochrome"	BinaryEnumValues="BitsAre8Or12Or16"
	Verify="BitsStored"											Condition="PhotometricInterpretationIsColor"		BinaryEnumValues="BitsAre8"

	Name="HighBit"									Type="1"
	Verify="HighBit"											Condition="PhotometricInterpretationIsMonochrome"	BinaryEnumValues="BitsAre7Or11Or15"
	Verify="HighBit"											Condition="PhotometricInterpretationIsColor"		BinaryEnumValues="BitsAre7"

	Name="PixelRepresentation"						Type="1"
	Verify="PixelRepresentation"								Condition="PhotometricInterpretationIsMonochrome"	BinaryEnumValues="PixelRepresentation"
	Verify="PixelRepresentation"								Condition="PhotometricInterpretationIsColor"		BinaryEnumValues="PixelRepresentationUnsigned"

	Name="PlanarConfiguration"						Type="1C"	Condition="SamplesPerPixelGreaterThanOne"	BinaryEnumValues="PlanarConfigurationIsColorByPixel"
	
	Name="BurnedInAnnotation"						Type="1C"	Condition="NotLegacyConvertedMR"	StringEnumValues="NoFull"	mbpo="true"
	Name="RecognizableVisualFeatures"				Type="3"	StringEnumValues="YesNoFull"
	Name="LossyImageCompression"					Type="1C"	Condition="NotLegacyConvertedMR"	StringEnumValues="LossyImageCompression"	mbpo="true"
	Name="LossyImageCompressionRatio"				Type="1C"	Condition="LossyImageCompressionIs01"	NotZeroError=""
	Name="LossyImageCompressionMethod"				Type="1C"	StringDefinedTerms="LossyImageCompressionMethod"	Condition="LossyImageCompressionIs01"
	Verify="LossyImageCompressionMethod"								Condition="LossyImageCompressionMethodInconsistentWithTransferSyntax"	ThenWarningMessage="method inconsistent with Transfer Syntax" ShowValueWithMessage="true"
	Name="PresentationLUTShape"						Type="1"	StringEnumValues="IdentityPresentationLUTShape"
	Sequence="IconImageSequence"					Type="3"	VM="1"
		InvokeMacro="IconImageSequenceMacro"
	SequenceEnd
	InvokeMacro="OptionalViewAndSliceProgressionDirectionMacro"
ModuleEnd

Module="MRPulseSequence"
	Name="PulseSequenceName"				Type="1C"	Condition="ImageTypeValue1OriginalOrMixed"
	Name="MRAcquisitionType"				Type="1C"	StringDefinedTerms="EnhancedMRAcquisitionType"		Condition="ImageTypeValue1OriginalOrMixed"
	Name="EchoPulseSequence"				Type="1C"	StringEnumValues="EchoPulseSequence"			Condition="ImageTypeValue1OriginalOrMixed"
	Name="MultipleSpinEcho"					Type="1C"	StringEnumValues="YesNoFull"				Condition="ImageTypeValue1OriginalOrMixedAndEchoPulseSequenceNotGradient"
	Name="MultiPlanarExcitation"			Type="1C"	StringEnumValues="YesNoFull"				Condition="ImageTypeValue1OriginalOrMixed"
	Name="PhaseContrast"					Type="1C"	StringEnumValues="YesNoFull"				Condition="ImageTypeValue1OriginalOrMixed"
	Sequence="VelocityEncodingAcquisitionSequence"		Type="1C"	VM="1-n"	Condition="PhaseContrastIsYes"
		Name="VelocityEncodingDirection"				Type="1"
	SequenceEnd
	Name="TimeOfFlightContrast"				Type="1C"	StringEnumValues="YesNoFull"				Condition="ImageTypeValue1OriginalOrMixed"
	Name="ArterialSpinLabelingContrast"		Type="1C"	StringEnumValues="ArterialSpinLabelingContrast"				Condition="ImageTypeValue3ASL"
	Name="SteadyStatePulseSequence"			Type="1C"	StringDefinedTerms="SteadyStatePulseSequence"		Condition="ImageTypeValue1OriginalOrMixed"
	Name="EchoPlanarPulseSequence"			Type="1C"	StringEnumValues="YesNoFull"				Condition="ImageTypeValue1OriginalOrMixed"
	Name="SaturationRecovery"				Type="1C"	StringEnumValues="YesNoFull"				Condition="ImageTypeValue1OriginalOrMixed"
	Name="SpectrallySelectedSuppression"	Type="1C"	StringDefinedTerms="SpectrallySelectedSuppression"	Condition="ImageTypeValue1OriginalOrMixed"
	Name="OversamplingPhase"				Type="1C"	StringEnumValues="OversamplingPhase"			Condition="ImageTypeValue1OriginalOrMixed"
	Name="GeometryOfKSpaceTraversal"		Type="1C"	StringDefinedTerms="GeometryOfKSpaceTraversal"		Condition="ImageTypeValue1OriginalOrMixed"
	Name="RectilinearPhaseEncodeReordering"	Type="1C"	StringDefinedTerms="RectilinearPhaseEncodeReordering"	Condition="ImageTypeValue1OriginalOrMixedAndRectilinear"
	Name="SegmentedKSpaceTraversal"			Type="1C"	StringEnumValues="SegmentedKSpaceTraversal"		Condition="ImageTypeValue1OriginalOrMixed"
	Name="CoverageOfKSpace"					Type="1C"	StringDefinedTerms="CoverageOfKSpace"			Condition="ImageTypeValue1OriginalOrMixedAnd3D"
	Name="NumberOfKSpaceTrajectories"		Type="1C"	Condition="ImageTypeValue1OriginalOrMixed"
ModuleEnd

Module="MRSpectroscopy"
	InvokeMacro="MRImageAndSpectroscopyInstanceMacro"
	Name="ImageType"						Type="1"	VM="4"
	Verify="ImageType"									ValueSelector="0"	StringEnumValues="CommonEnhancedImageType1"
	Verify="ImageType"									ValueSelector="1"	StringEnumValues="CommonEnhancedImageAndFrameType2"
	Verify="ImageType"									ValueSelector="2"	StringDefinedTerms="EnhancedMRSpectroscopyImageAndFrameType3"
	Verify="ImageType"									ValueSelector="3"	StringDefinedTerms="EnhancedMRSpectroscopyImageType4"
	InvokeMacro="MRSpectroscopyDescriptionImageLevelMacro"
	Name="TransmitterFrequency"				Type="1C"	Condition="ImageTypeValue1Original"
	Name="SpectralWidth"					Type="1C"	Condition="ImageTypeValue1OriginalOrMixed"
	Name="ChemicalShiftReference"			Type="1C"	Condition="ImageTypeValue1OriginalOrMixed"
	Name="VolumeLocalizationTechnique"		Type="1C"	StringDefinedTerms="VolumeLocalizationTechnique"	Condition="ImageTypeValue1OriginalOrMixed"
	Sequence="VolumeLocalizationSequence"	Type="1C"	VM="1-n"	Condition="VolumeLocalizationTechniqueNotNone"
		Name="SlabThickness"				Type="1"
		Name="SlabOrientation"				Type="1"
		Name="MidSlabPosition"				Type="1"
	SequenceEnd
	Name="Decoupling"						Type="1C"	StringEnumValues="YesNoFull"				Condition="ImageTypeValue1OriginalOrMixed"
	Name="DecoupledNucleus"					Type="1C"	StringDefinedTerms="DecoupledNucleus"			Condition="DecouplingIsYes"
	Name="DecouplingFrequency"				Type="1C"								Condition="DecouplingIsYes"
	Name="DecouplingMethod"					Type="1C"	StringDefinedTerms="DecouplingMethod"			Condition="DecouplingIsYes"
	Name="DecouplingChemicalShiftReference"	Type="1C"								Condition="DecouplingIsYes"
	Name="TimeDomainFiltering"				Type="1C"	StringDefinedTerms="TimeDomainFiltering"		Condition="ImageTypeValue1OriginalOrMixed"
	Name="NumberOfZeroFills"				Type="1C"								Condition="ImageTypeValue1OriginalOrMixed"
	Name="BaselineCorrection"				Type="1C"	StringDefinedTerms="BaselineCorrection"			Condition="ImageTypeValue1OriginalOrMixed"
	Name="FrequencyCorrection"				Type="1C"	StringDefinedTerms="YesNoFull"				Condition="ImageTypeValue1OriginalOrMixed"
	Name="FirstOrderPhaseCorrection"		Type="1C"	StringDefinedTerms="YesNoFull"				Condition="ImageTypeValue1OriginalOrMixed"
	Name="WaterReferencedPhaseCorrection"	Type="1C"	StringDefinedTerms="YesNoFull"				Condition="ImageTypeValue1OriginalOrMixed"
	Name="WaterReferenceAcquisition"		Type="3"	StringDefinedTerms="WaterReferenceAcquisition"
	Sequence="ReferencedInstanceSequence"			Type="1C"	VM="1-n"	Condition="WaterReferenceAcquisitionIsReferenced"
		InvokeMacro="ImageSOPInstanceReferenceMacro"
		Sequence="PurposeOfReferenceCodeSequence"	Type="1"	VM="1"
			InvokeMacro="CodeSequenceMacro"				DefinedContextID="7215"
		SequenceEnd
	SequenceEnd
ModuleEnd

Module="MRSpectroscopyPulseSequence"
	Name="PulseSequenceName"				Type="1C"	Condition="ImageTypeValue1OriginalOrMixed"
	Name="MRSpectroscopyAcquisitionType"	Type="1C"	StringDefinedTerms="MRSpectroscopyAcquisitionType"	Condition="ImageTypeValue1OriginalOrMixed"
	Name="EchoPulseSequence"				Type="1C"	StringEnumValues="EchoPulseSequence"			Condition="ImageTypeValue1OriginalOrMixed"
	Name="MultipleSpinEcho"					Type="1C"	StringEnumValues="YesNoFull"				Condition="ImageTypeValue1OriginalOrMixedAndEchoPulseSequenceNotGradient"
	Name="MultiPlanarExcitation"			Type="1C"	StringEnumValues="YesNoFull"				Condition="ImageTypeValue1OriginalOrMixed"
	Name="SteadyStatePulseSequence"			Type="1C"	StringDefinedTerms="SteadyStatePulseSequence"		Condition="ImageTypeValue1OriginalOrMixed"
	Name="EchoPlanarPulseSequence"			Type="1C"	StringEnumValues="YesNoFull"				Condition="ImageTypeValue1OriginalOrMixed"
	Name="SpectrallySelectedSuppression"	Type="1C"	StringDefinedTerms="SpectrallySelectedSuppression"	Condition="ImageTypeValue1OriginalOrMixed"
	Name="GeometryOfKSpaceTraversal"		Type="1C"	StringDefinedTerms="GeometryOfKSpaceTraversal"		Condition="ImageTypeValue1OriginalOrMixed"
	Name="RectilinearPhaseEncodeReordering"	Type="1C"	StringDefinedTerms="RectilinearPhaseEncodeReordering"	Condition="ImageTypeValue1OriginalOrMixedAndRectilinear"
	Name="SegmentedKSpaceTraversal"			Type="1C"	StringEnumValues="SegmentedKSpaceTraversal"		Condition="ImageTypeValue1OriginalOrMixed"
	Name="CoverageOfKSpace"					Type="1C"	StringDefinedTerms="CoverageOfKSpace"	Condition="ImageTypeValue1OriginalOrMixedAndSpectroscopyVolume"
	Name="NumberOfKSpaceTrajectories"		Type="1C"	Condition="ImageTypeValue1OriginalOrMixed"
	Name="EchoPeakPosition"					Type="3"
ModuleEnd

Module="MRSpectroscopyData"
	Name="Rows"								Type="1"	NotZeroError=""
	Name="Columns"							Type="1"	NotZeroError=""
	Name="DataPointRows"					Type="1"	NotZeroError=""
	Name="DataPointColumns"					Type="1"	NotZeroError=""
	Name="DataRepresentation"				Type="1"	StringEnumValues="MRSpectroscopyDataRepresentation"
	Name="SignalDomainColumns"				Type="1"	StringEnumValues="SpectroscopySignalDomain"
	Name="SignalDomainRows"					Type="1C"	StringEnumValues="SpectroscopySignalDomain"	Condition="DataPointRowsGreaterThanOne"
	Name="FirstOrderPhaseCorrectionAngle"	Type="1C"							Condition="FirstOrderPhaseCorrectionIsYes"
	Name="SpectroscopyData"					Type="1"
ModuleEnd

Module="RawData"
	Name="InstanceNumber"							Type="2"
	Name="ContentDate"								Type="1"
	Name="ContentTime"								Type="1"
	Name="AcquisitionDateTime"						Type="3"
	Name="ContentLabel"								Type="3"
	Name="ContentDescription"						Type="3"
	Sequence="ConceptNameCodeSequence"				Type="3"	VM="1"
		InvokeMacro="CodeSequenceMacro"
	SequenceEnd
	Name="ImageLaterality"							Type="3"	StringEnumValues="ImageLaterality"
	Name="CreatorVersionUID"						Type="1"
	Sequence="ReferencedInstanceSequence"			Type="3"	VM="1-n"
		InvokeMacro="ImageSOPInstanceReferenceMacro"
		Sequence="PurposeOfReferenceCodeSequence"	Type="1"	VM="1"
			InvokeMacro="CodeSequenceMacro"
		SequenceEnd
	SequenceEnd
ModuleEnd

Module="MRSeries"
	Name="Modality"										Type="1"	StringEnumValues="MRModality"
	Sequence="ReferencedPerformedProcedureStepSequence"	Type="1C"	VM="1"	Condition="SeriesNeedReferencedPerformedProcedureStepSequence"
		InvokeMacro="SOPInstanceReferenceMacro"
	SequenceEnd
ModuleEnd


Module="MultiFrameFunctionalGroupsForLegacyConvertedEnhancedMRImage"
	Sequence="SharedFunctionalGroupsSequence"				Type="1"	VM="1"
		InvokeMacro="PixelMeasuresMacro"					Condition="PixelMeasuresSequenceNotInPerFrameFunctionalGroupSequence"
		InvokeMacro="PlanePositionMacro"					Condition="PlanePositionSequenceNotInPerFrameFunctionalGroupSequence"
		InvokeMacro="PlaneOrientationMacro"					Condition="PlaneOrientationSequenceNotInPerFrameFunctionalGroupSequence"
		InvokeMacro="ReferencedImageMacro"					Condition="ReferencedImageMacroOKInSharedFunctionalGroupSequence"
		InvokeMacro="DerivationImageMacro"					Condition="DerivationImageMacroOKInSharedFunctionalGroupSequence"
		InvokeMacro="CardiacSynchronizationMacro"			Condition="CardiacSynchronizationMacroOKInSharedFunctionalGroupSequence"
		InvokeMacro="FrameAnatomyMacro"						Condition="FrameAnatomyMacroOKInSharedFunctionalGroupSequence"
		InvokeMacro="PixelValueTransformationMacro"			Condition="PixelValueTransformationSequenceOKInSharedFunctionalGroupSequence"
		InvokeMacro="FrameVOILUTMacro"						Condition="FrameVOILUTMacroOKInSharedFunctionalGroupSequence"
		InvokeMacro="RealWorldValueMappingMacro"			Condition="RealWorldValueMappingMacroOKInSharedFunctionalGroupSequence"
		InvokeMacro="ContrastBolusUsageMacro"				Condition="NeedContrastBolusUsageMacroInSharedFunctionalGroupSequence"
		InvokeMacro="RespiratorySynchronizationMacro"		Condition="RespiratorySynchronizationMacroOKInSharedFunctionalGroupSequence"
		InvokeMacro="MRImageFrameTypeMacro"					Condition="MRImageFrameTypeSequenceNotInPerFrameFunctionalGroupSequence"
		InvokeMacro="TemporalPositionMacro"					Condition="TemporalPositionMacroOKInSharedFunctionalGroupSequence"
		InvokeMacro="UnassignedSharedConvertedAttributesMacro"
	SequenceEnd

	Sequence="PerFrameFunctionalGroupsSequence"				Type="1"	VM="1-n"
		InvokeMacro="PixelMeasuresMacro"					Condition="PixelMeasuresSequenceNotInSharedFunctionalGroupSequence"
		InvokeMacro="FrameContentMacro"
		InvokeMacro="PlanePositionMacro"					Condition="PlanePositionSequenceNotInSharedFunctionalGroupSequence"
		InvokeMacro="PlaneOrientationMacro"					Condition="PlaneOrientationSequenceNotInSharedFunctionalGroupSequence"
		InvokeMacro="ReferencedImageMacro"					Condition="ReferencedImageMacroOKInPerFrameFunctionalGroupSequence"
		InvokeMacro="DerivationImageMacro"					Condition="DerivationImageMacroOKInPerFrameFunctionalGroupSequence"
		InvokeMacro="CardiacSynchronizationMacro"			Condition="CardiacSynchronizationMacroOKInPerFrameFunctionalGroupSequence"
		InvokeMacro="FrameAnatomyMacro"						Condition="FrameAnatomyMacroOKInPerFrameFunctionalGroupSequence"
		InvokeMacro="PixelValueTransformationMacro"			Condition="PixelValueTransformationSequenceOKInPerFrameFunctionalGroupSequence"
		InvokeMacro="FrameVOILUTMacro"						Condition="FrameVOILUTMacroOKInPerFrameFunctionalGroupSequence"
		InvokeMacro="RealWorldValueMappingMacro"			Condition="RealWorldValueMappingMacroOKInPerFrameFunctionalGroupSequence"
		InvokeMacro="ContrastBolusUsageMacro"				Condition="NeedContrastBolusUsageMacroInPerFrameFunctionalGroupSequence"
		InvokeMacro="RespiratorySynchronizationMacro"		Condition="RespiratorySynchronizationMacroOKInPerFrameFunctionalGroupSequence"
		InvokeMacro="MRImageFrameTypeMacro"					Condition="MRImageFrameTypeSequenceNotInSharedFunctionalGroupSequence"
		InvokeMacro="TemporalPositionMacro"					Condition="TemporalPositionMacroOKInPerFrameFunctionalGroupSequence"
		InvokeMacro="UnassignedPerFrameConvertedAttributesMacro"
		InvokeMacro="ImageFrameConversionSourceMacro"		Condition="ImageFrameConversionSourceMacroPresentInPerFrameFunctionalGroupSequence"
	SequenceEnd
ModuleEnd


Module="MultiFrameFunctionalGroupsForPrivatePixelMedLegacyConvertedEnhancedMRImage"
	Sequence="SharedFunctionalGroupsSequence"				Type="1"	VM="1"
		InvokeMacro="PixelMeasuresMacro"					Condition="PixelMeasuresSequenceNotInPerFrameFunctionalGroupSequence"
		InvokeMacro="PlanePositionMacro"					Condition="PlanePositionSequenceNotInPerFrameFunctionalGroupSequence"
		InvokeMacro="PlaneOrientationMacro"					Condition="PlaneOrientationSequenceNotInPerFrameFunctionalGroupSequence"
		InvokeMacro="ReferencedImageMacro"					Condition="ReferencedImageMacroOKInSharedFunctionalGroupSequence"
		InvokeMacro="DerivationImageMacro"					Condition="DerivationImageMacroOKInSharedFunctionalGroupSequence"
		InvokeMacro="CardiacSynchronizationMacro"			Condition="CardiacSynchronizationMacroOKInSharedFunctionalGroupSequence"
		InvokeMacro="FrameAnatomyMacro"						Condition="FrameAnatomyMacroOKInSharedFunctionalGroupSequence"
		InvokeMacro="PixelValueTransformationMacro"			Condition="PixelValueTransformationSequenceOKInSharedFunctionalGroupSequence"
		InvokeMacro="FrameVOILUTMacro"						Condition="FrameVOILUTMacroOKInSharedFunctionalGroupSequence"
		InvokeMacro="ContrastBolusUsageMacro"				Condition="NeedContrastBolusUsageMacroInSharedFunctionalGroupSequence"
		InvokeMacro="RespiratorySynchronizationMacro"		Condition="RespiratorySynchronizationMacroOKInSharedFunctionalGroupSequence"
		InvokeMacro="MRImageFrameTypeMacro"					Condition="MRImageFrameTypeSequenceNotInPerFrameFunctionalGroupSequence"
		InvokeMacro="UnassignedSharedConvertedAttributesMacro"
		InvokeMacro="ImageFrameConversionSourceMacro"		Condition="ConversionSourceAttributesSequenceNotInPerFrameFunctionalGroupSequence"
	SequenceEnd

	Sequence="PerFrameFunctionalGroupsSequence"				Type="1"	VM="1-n"
		InvokeMacro="PixelMeasuresMacro"					Condition="PixelMeasuresSequenceNotInSharedFunctionalGroupSequence"
		InvokeMacro="FrameContentMacro"
		InvokeMacro="PlanePositionMacro"					Condition="PlanePositionSequenceNotInSharedFunctionalGroupSequence"
		InvokeMacro="PlaneOrientationMacro"					Condition="PlaneOrientationSequenceNotInSharedFunctionalGroupSequence"
		InvokeMacro="ReferencedImageMacro"					Condition="ReferencedImageMacroOKInPerFrameFunctionalGroupSequence"
		InvokeMacro="DerivationImageMacro"					Condition="DerivationImageMacroOKInPerFrameFunctionalGroupSequence"
		InvokeMacro="CardiacSynchronizationMacro"			Condition="CardiacSynchronizationMacroOKInPerFrameFunctionalGroupSequence"
		InvokeMacro="FrameAnatomyMacro"						Condition="FrameAnatomyMacroOKInPerFrameFunctionalGroupSequence"
		InvokeMacro="PixelValueTransformationMacro"			Condition="PixelValueTransformationSequenceOKInPerFrameFunctionalGroupSequence"
		InvokeMacro="FrameVOILUTMacro"						Condition="FrameVOILUTMacroOKInPerFrameFunctionalGroupSequence"
		InvokeMacro="ContrastBolusUsageMacro"				Condition="NeedContrastBolusUsageMacroInPerFrameFunctionalGroupSequence"
		InvokeMacro="RespiratorySynchronizationMacro"		Condition="RespiratorySynchronizationMacroOKInPerFrameFunctionalGroupSequence"
		InvokeMacro="MRImageFrameTypeMacro"					Condition="MRImageFrameTypeSequenceNotInSharedFunctionalGroupSequence"
		InvokeMacro="UnassignedPerFrameConvertedAttributesMacro"
		InvokeMacro="ImageFrameConversionSourceMacro"		Condition="ConversionSourceAttributesSequenceNotInSharedFunctionalGroupSequence"
	SequenceEnd
ModuleEnd


Module="TractographyResultsSeries"
	Name="Modality"										Type="1"	StringEnumValues="MRModality"
	Name="SeriesNumber"									Type="1"
	Sequence="ReferencedPerformedProcedureStepSequence"	Type="1C"	VM="1"	Condition="SeriesNeedReferencedPerformedProcedureStepSequence"
		InvokeMacro="SOPInstanceReferenceMacro"
	SequenceEnd
ModuleEnd

Module="TractographyResults"
	InvokeMacro="ContentIdentificationMacro"
	Name="ContentDate"									Type="1"
	Name="ContentTime"									Type="1"
	Sequence="TrackSetSequence"							Type="1"	VM="1-n"
		Name="TrackSetNumber"							Type="1"
		Name="TrackSetLabel"							Type="1"
		Name="TrackSetDescription"						Type="3"
		Sequence="TrackSetAnatomicalTypeCodeSequence"	Type="1"	VM="1"
			InvokeMacro="CodeSequenceMacro"
			Sequence="ModifierCodeSequence"				Type="3"	VM="1-n"
				InvokeMacro="CodeSequenceMacro"
			SequenceEnd
		SequenceEnd
		Sequence="TrackSequence"						Type="1"	VM="1-n"
			Name="PointCoordinatesData"					Type="1"
			Name="RecommendedDisplayCIELabValueList"	Type="1C"	Condition="NeedRecommendedDisplayCIELabValueListInTrackSequence"
			Name="RecommendedDisplayCIELabValue"		Type="1C"	Condition="NeedRecommendedDisplayCIELabValueInTrackSequence"
		SequenceEnd
		Name="RecommendedDisplayCIELabValue"			Type="1C"	Condition="NeedRecommendedDisplayCIELabValueInTrackSetSequence"
		Name="RecommendedLineThickness"					Type="3"
		Sequence="MeasurementsSequence"					Type="3"	VM="1-n"
			Sequence="ConceptNameCodeSequence"			Type="1"	VM="1"
				InvokeMacro="CodeSequenceMacro"
			SequenceEnd
			Sequence="MeasurementUnitsCodeSequence"		Type="1"	VM="1"
				InvokeMacro="CodeSequenceMacro"
			SequenceEnd
			Sequence="MeasurementValuesSequence"		Type="1"	VM="1-n"
				Name="FloatingPointValues"				Type="1"
				Name="TrackPointIndexList"				Type="1C"	NoCondition=""
			SequenceEnd
		SequenceEnd
		Sequence="TrackStatisticsSequence"				Type="3"	VM="1-n"
			Sequence="ConceptNameCodeSequence"			Type="1"	VM="1"
				InvokeMacro="CodeSequenceMacro"
			SequenceEnd
			Sequence="ModifierCodeSequence"				Type="1"	VM="1"
				InvokeMacro="CodeSequenceMacro"
			SequenceEnd
			Sequence="MeasurementUnitsCodeSequence"		Type="1"	VM="1"
				InvokeMacro="CodeSequenceMacro"
			SequenceEnd
			Name="FloatingPointValues"					Type="1"
		SequenceEnd
		Sequence="TrackSetStatisticsSequence"			Type="3"	VM="1-n"
			InvokeMacro="TableSummaryStatisticsMacro"
		SequenceEnd
		Sequence="DiffusionAcquisitionCodeSequence"		Type="3"	VM="1"
			InvokeMacro="CodeSequenceMacro"
		SequenceEnd
		Sequence="DiffusionModelCodeSequence"			Type="1"	VM="1"
			InvokeMacro="CodeSequenceMacro"
		SequenceEnd
		Sequence="TrackingAlgorithmIdentificationSequence"	Type="1"	VM="1-n"
			InvokeMacro="AlgorithmIdentificationMacro"
		SequenceEnd
	SequenceEnd

	Sequence="ReferencedInstanceSequence"				Type="1C"	VM="1-n"	NoCondition=""
		InvokeMacro="ImageSOPInstanceReferenceMacro"
	SequenceEnd
ModuleEnd

DefineMacro="TableSummaryStatisticsMacro"
	Sequence="ConceptNameCodeSequence"							Type="1"	VM="1"
		InvokeMacro="CodeSequenceMacro"
	SequenceEnd
	Sequence="ModifierCodeSequence"								Type="1"	VM="1"
		InvokeMacro="CodeSequenceMacro"
	SequenceEnd
	Sequence="MeasurementUnitsCodeSequence"						Type="1"	VM="1"
		InvokeMacro="CodeSequenceMacro"
	SequenceEnd
	Name="FloatingPointValue"									Type="1"
MacroEnd




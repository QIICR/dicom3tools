DefineMacro="CTFrameVOILUTMacro" InformationEntity="FunctionalGroup"
	Sequence="FrameVOILUTSequence"				Type="1"	VM="1"
		Name="WindowCenter"						Type="1" 
		Name="WindowWidth"						Type="1"	NotZeroError=""
		Verify="WindowWidth"								Condition="WindowWidthIsNegative"	ThenErrorMessage="Not permitted to be negative" ShowValueWithMessage="true"
		Name="WindowCenterWidthExplanation"		Type="3"	StringDefinedTerms="EnhancedCTWindowCenterWidthExplanation"
		Name="VOILUTFunction"					Type="3"	StringDefinedTerms="VOILUTFunction"
	SequenceEnd
MacroEnd

Module="CTSeries"
	Name="Modality"										Type="1"	StringEnumValues="CTModality"
	Sequence="ReferencedPerformedProcedureStepSequence"	Type="1C"	VM="1"	Condition="SeriesNeedReferencedPerformedProcedureStepSequence"
		InvokeMacro="SOPInstanceReferenceMacro"
	SequenceEnd
ModuleEnd

Module="EnhancedCTImage"
	Name="ImageType"										Type="1"	VM="4"
	Verify="ImageType"													ValueSelector="0"	StringEnumValues="CommonEnhancedImageType1"
	Verify="ImageType"													ValueSelector="1"	StringEnumValues="CommonEnhancedImageAndFrameType2"
	Verify="ImageType"													ValueSelector="2"	StringDefinedTerms="EnhancedCTImageAndFrameType3"
	Verify="ImageType"													ValueSelector="3"	StringDefinedTerms="EnhancedCTImageType4"
	InvokeMacro="CommonCTMRImageDescriptionImageLevelMacro"
	Name="AcquisitionNumber"								Type="3"
	Name="AcquisitionDateTime"								Type="1C"	Condition="ImageTypeValue1OriginalOrMixedAndNotLegacyConvertedCT" mbpo="true"
	Name="AcquisitionDuration"								Type="2C"	Condition="ImageTypeValue1OriginalOrMixedAndNotLegacyConvertedCT" mbpo="true"
	Sequence="ReferencedRawDataSequence"					Type="3"	VM="1-n"
		InvokeMacro="HierarchicalSOPInstanceReferenceMacro"
	SequenceEnd
	Sequence="ReferencedWaveformSequence"					Type="3"	VM="1-n"
		InvokeMacro="HierarchicalSOPInstanceReferenceMacro"
	SequenceEnd
	Sequence="ReferencedImageEvidenceSequence"				Type="1C"	VM="1-n"	Condition="ReferencedImageSequenceIsPresentInFunctionalGroups"
		InvokeMacro="HierarchicalSOPInstanceReferenceMacro"
	SequenceEnd
	Sequence="SourceImageEvidenceSequence"					Type="1C"	VM="1-n"	Condition="SourceImageSequenceIsPresentInFunctionalGroups"
		InvokeMacro="HierarchicalSOPInstanceReferenceMacro"
	SequenceEnd
	Sequence="ReferencedPresentationStateSequence"	Type="1C"	VM="1-n"	NoCondition=""	# real world
		InvokeMacro="HierarchicalSOPInstanceReferenceMacro"
	SequenceEnd
	Name="SamplesPerPixel"									Type="1"	BinaryEnumValues="SamplesPerPixelIsOne"
	Name="PhotometricInterpretation"						Type="1"	StringEnumValues="PhotometricInterpretationMonochrome2"
	Name="BitsAllocated"									Type="1"	BinaryEnumValues="BitsAre16"
	Name="BitsStored"										Type="1"	BinaryEnumValues="BitsAre12Or16"
	Name="HighBit"											Type="1"	BinaryEnumValues="BitsAre11Or15"
	Name="ContentQualification"								Type="1C"	StringEnumValues="ContentQualification"		Condition="NotLegacyConvertedCT" mbpo="true"
	Name="ImageComments"									Type="3"
	Name="BurnedInAnnotation"								Type="1C"	StringEnumValues="NoFull"					Condition="NotLegacyConvertedCT" mbpo="true"
	Name="RecognizableVisualFeatures"						Type="3"	StringEnumValues="YesNoFull"
	Name="LossyImageCompression"							Type="1C"	StringEnumValues="LossyImageCompression"	Condition="NotLegacyConvertedCT" mbpo="true"
	Name="LossyImageCompressionRatio"						Type="1C"	Condition="LossyImageCompressionIs01"	NotZeroError=""
	Name="LossyImageCompressionMethod"						Type="1C"	StringDefinedTerms="LossyImageCompressionMethod"	Condition="LossyImageCompressionIs01"
	Verify="LossyImageCompressionMethod"								Condition="LossyImageCompressionMethodInconsistentWithTransferSyntax"	ThenWarningMessage="method inconsistent with transfer syntax" ShowValueWithMessage="true"
	Name="PresentationLUTShape"								Type="1"	StringEnumValues="IdentityPresentationLUTShape"
	Sequence="IconImageSequence"							Type="3"	VM="1"
		InvokeMacro="IconImageSequenceMacro"
	SequenceEnd
	InvokeMacro="OptionalViewAndSliceProgressionDirectionMacro"
	Name="IsocenterPosition"								Type="3"
	InvokeMacro="RTEquipmentCorrelationMacro"
ModuleEnd

DefineMacro="CTImageFrameTypeMacro" InformationEntity="FunctionalGroup"
	Sequence="CTImageFrameTypeSequence"		Type="1"	VM="1"
		Name="FrameType"					Type="1"	VM="4"
		Verify="FrameType"								ValueSelector="0"	StringEnumValues="CommonEnhancedFrameType1"
		Verify="FrameType"								ValueSelector="1"	StringEnumValues="CommonEnhancedImageAndFrameType2"
		Verify="FrameType"								ValueSelector="2"	StringDefinedTerms="EnhancedCTImageAndFrameType3"
		Verify="FrameType"								ValueSelector="3"	StringDefinedTerms="EnhancedCTFrameType4"
		InvokeMacro="CommonCTMRImageDescriptionFrameLevelMacro"
	SequenceEnd
MacroEnd

DefineMacro="CTAcquisitionTypeMacro" InformationEntity="FunctionalGroup"
	Sequence="CTAcquisitionTypeSequence"			Type="1"	VM="1"
		Name="AcquisitionType"						Type="1C"	StringDefinedTerms ="CTAcquisitionType"		Condition="Always"	# ORIGINAL mbpo
		Name="TubeAngle"							Type="1C"	Condition="AcquisitionTypeConstantAngle"				# and ORIGINAL mbpo
		Name="ConstantVolumeFlag"					Type="1C"	StringDefinedTerms ="YesNoFull"			Condition="Always"	# ORIGINAL mbpo
		Name="FluoroscopyFlag"						Type="1C"	StringDefinedTerms ="YesNoFull"			Condition="Always"	# ORIGINAL mbpo
	SequenceEnd
MacroEnd

DefineMacro="CTAcquisitionDetailsMacro" InformationEntity="FunctionalGroup"
	Sequence="CTAcquisitionDetailsSequence"			Type="1"	VM="1"
		Name="RotationDirection"					Type="1C"	StringEnumValues="RotationDirection"		NoCondition=""		# :( cannot check since in sibling functional groups: Frame Type Value 1 of this frame is ORIGINAL and AcquisitionType not CONSTANT_ANGLE; mbpo only if DERIVED and same AcquisitionType
		Name="RevolutionTime"						Type="1C"	NoCondition=""	NotZeroWarning=""								# :( cannot check since in sibling functional groups: Frame Type Value 1 of this frame is ORIGINAL and AcquisitionType not CONSTANT_ANGLE; mbpo only if DERIVED and same AcquisitionType
		Name="SingleCollimationWidth"				Type="1C"	Condition="Always"	NotZeroWarning=""		# ORIGINAL mbpo
		Name="TotalCollimationWidth"				Type="1C"	Condition="Always"	NotZeroWarning=""		# ORIGINAL mbpo
		Name="TableHeight"							Type="1C"	Condition="Always"							# ORIGINAL mbpo
		Name="GantryDetectorTilt"					Type="1C"	Condition="Always"							# ORIGINAL mbpo
		Name="DataCollectionDiameter"				Type="1C"	Condition="Always"	NotZeroWarning=""		# ORIGINAL mbpo
	SequenceEnd
MacroEnd

DefineMacro="CTTableDynamicsMacro" InformationEntity="FunctionalGroup"
	Sequence="CTTableDynamicsSequence"			Type="1"	VM="1"
		Name="TableSpeed"						Type="1C"	NoCondition=""	NotZeroWarning=""	# :( cannot check since in sibling functional groups: Frame Type Value 1 of this frame is ORIGINAL and AcquisitionType SPIRAL or CONSTANT_ANGLE; mbpo only if DERIVED and same AcquisitionType
		Name="TableFeedPerRotation"				Type="1C"	NoCondition=""	NotZeroWarning=""	# :( cannot check since in sibling functional groups: Frame Type Value 1 of this frame is ORIGINAL and AcquisitionType SPIRAL or CONSTANT_ANGLE; mbpo only if DERIVED and same AcquisitionType
		Name="SpiralPitchFactor"				Type="1C"	NoCondition=""	NotZeroWarning=""	# :( cannot check since in sibling functional groups: Frame Type Value 1 of this frame is ORIGINAL and AcquisitionType SPIRAL or CONSTANT_ANGLE; mbpo only if DERIVED and same AcquisitionType
	SequenceEnd
MacroEnd

DefineMacro="CTPositionMacro" InformationEntity="FunctionalGroup"
	Sequence="CTPositionSequence"					Type="1"	VM="1"
		Name="TablePosition"						Type="1C"	Condition="Always"							# ORIGINAL mbpo
		Name="DataCollectionCenterPatient"			Type="1C"	Condition="Always"							# ORIGINAL mbpo
		Name="ReconstructionTargetCenterPatient"	Type="1C"	Condition="Always"							# ORIGINAL mbpo
	SequenceEnd
MacroEnd

DefineMacro="CTGeometryMacro" InformationEntity="FunctionalGroup"
	Sequence="CTGeometrySequence"					Type="1"	VM="1"
		Name="DistanceSourceToDetector"				Type="1C"	Condition="Always"	NotZeroWarning=""							# ORIGINAL mbpo
		Name="DistanceSourceToDataCollectionCenter"	Type="1C"	Condition="Always"	NotZeroWarning=""							# ORIGINAL mbpo
	SequenceEnd
MacroEnd

DefineMacro="CTReconstructionMacro" InformationEntity="FunctionalGroup"
	Sequence="CTReconstructionSequence"			Type="1"	VM="1"
		Name="ReconstructionAlgorithm"			Type="1C"	StringDefinedTerms ="CTReconstructionAlgorithm"	Condition="Always"	# ORIGINAL mbpo
		Name="ConvolutionKernel"				Type="1C"	Condition="Always"							# ORIGINAL mbpo
		Name="ConvolutionKernelGroup"			Type="1C"	StringDefinedTerms ="CTConvolutionKernelGroup"	Condition="ConvolutionKernelIsPresent"
		Name="ReconstructionDiameter"			Type="1C"	Condition="ReconstructionFieldOfViewAbsent"	NotZeroWarning=""				# ORIGINAL mbpo
		Name="ReconstructionFieldOfView"		Type="1C"	Condition="ReconstructionDiameterAbsent"	NotZeroWarning=""				# ORIGINAL mbpo
		Name="ReconstructionPixelSpacing"		Type="1C"	Condition="Always"	NotZeroWarning=""							# ORIGINAL mbpo
		Name="ReconstructionAngle"				Type="1C"	Condition="Always"							# ORIGINAL mbpo
		Name="ImageFilter"						Type="1C"	Condition="Always"							# ORIGINAL mbpo
	SequenceEnd
MacroEnd

DefineMacro="CTExposureMacro" InformationEntity="FunctionalGroup"
	Sequence="CTExposureSequence"				Type="1"	VM="1"
		Name="ExposureTimeInms"					Type="1C"	Condition="Always"	NotZeroWarning=""							# ORIGINAL mbpo
		Name="XRayTubeCurrentInmA"				Type="1C"	Condition="Always"	NotZeroWarning=""							# ORIGINAL mbpo
		Name="ExposureInmAs"					Type="1C"	Condition="Always"	NotZeroWarning=""							# ORIGINAL mbpo
		Name="ExposureModulationType"			Type="1C"	StringDefinedTerms ="CTExposureModulationType"	Condition="Always"	# ORIGINAL mbpo
		Name="EstimatedDoseSaving"				Type="2C"	Condition="ExposureModulationTypeIsNotNone"	NotZeroWarning=""				# ORIGINAL mbpo
		Name="CTDIvol"							Type="2C"	NoCondition=""	NotZeroWarning=""
		Sequence="CTDIPhantomTypeCodeSequence"	Type="3"	VM="1"
			InvokeMacro="CodeSequenceMacro"					DefinedContextID="4052"
		SequenceEnd
	SequenceEnd
MacroEnd

DefineMacro="CTXRayDetailsMacro" InformationEntity="FunctionalGroup"
	Sequence="CTXRayDetailsSequence"			Type="1"	VM="1"
		Name="KVP"								Type="1C"	Condition="Always"	NotZeroWarning=""							# ORIGINAL mbpo
		Name="FocalSpots"						Type="1C"	Condition="Always"							# ORIGINAL mbpo
		Name="FilterType"						Type="1C"	StringDefinedTerms ="CTFilterType"	Condition="Always"	# ORIGINAL mbpo
		Name="FilterMaterial"					Type="1C"	StringDefinedTerms ="CTFilterMaterial"	Condition="Always"	# ORIGINAL mbpo
		Name="CalciumScoringMassFactorPatient"	Type="3"	NotZeroWarning=""
		Name="CalciumScoringMassFactorDevice"	Type="3"	NotZeroWarning=""
		Name="EnergyWeightingFactor"			Type="1C"	NotZeroWarning=""	NoCondition="" mbpo="true"	# FrameTypeValue4IsEnergyProportionalWeighting ... too hard :(
	SequenceEnd
MacroEnd

DefineMacro="CTPixelValueTransformationMacro" InformationEntity="FunctionalGroup"
	Sequence="PixelValueTransformationSequence"		Type="1"	VM="1"
		Name="RescaleIntercept"						Type="1" 
		Name="RescaleSlope"							Type="1"	NotZeroError="" 
		Name="RescaleType"							Type="1" 	StringEnumValues="RescaleTypeHounsfieldUnits"	#actually only if not localizer :(
	SequenceEnd
MacroEnd

DefineMacro="CTAdditionalXRaySourceMacro" InformationEntity="FunctionalGroup"
	Sequence="CTAdditionalXRaySourceSequence"		Type="1"	VM="1-n"
		Name="KVP"								Type="1"	NotZeroWarning=""
		Name="XRayTubeCurrentInmA"				Type="1"	NotZeroWarning=""
		Name="DataCollectionDiameter"			Type="1"	NotZeroWarning=""
		Name="FocalSpots"						Type="1"
		Name="FilterType"						Type="1"	StringDefinedTerms ="CTFilterType"
		Name="FilterMaterial"					Type="1"	StringDefinedTerms ="CTFilterMaterial"
		Name="ExposureInmAs"					Type="3"	NotZeroWarning=""
		Name="EnergyWeightingFactor"			Type="1C"	NotZeroWarning=""	NoCondition="" mbpo="true"	# FrameTypeValue4IsEnergyProportionalWeighting ... too hard :(
	SequenceEnd
MacroEnd

DefineMacro="UnassignedSharedConvertedAttributesMacro" InformationEntity="FunctionalGroup"
	Sequence="UnassignedSharedConvertedAttributesSequence"		Type="2"	VM="1"
	SequenceEnd
MacroEnd

DefineMacro="UnassignedPerFrameConvertedAttributesMacro" InformationEntity="FunctionalGroup"
	Sequence="UnassignedPerFrameConvertedAttributesSequence"	Type="2"	VM="1"
	SequenceEnd
MacroEnd

DefineMacro="ImageFrameConversionSourceMacro" InformationEntity="FunctionalGroup"
	Sequence="ConversionSourceAttributesSequence"				Type="1"	VM="1-n"
		InvokeMacro="ImageSOPInstanceReferenceMacro"
	SequenceEnd
MacroEnd

Module="MultiFrameFunctionalGroupsForEnhancedCTImage"
	Sequence="SharedFunctionalGroupsSequence"	Type="1"	VM="1"
		InvokeMacro="PixelMeasuresMacro"		Condition="PixelMeasuresSequenceNotInPerFrameFunctionalGroupSequence"
		InvokeMacro="PlanePositionMacro"		Condition="PlanePositionSequenceNotInPerFrameFunctionalGroupSequence"
		InvokeMacro="PlaneOrientationMacro"		Condition="PlaneOrientationSequenceNotInPerFrameFunctionalGroupSequence"
		InvokeMacro="ReferencedImageMacro"		Condition="ReferencedImageMacroOKInSharedFunctionalGroupSequence"
		InvokeMacro="DerivationImageMacro"		Condition="DerivationImageMacroOKInSharedFunctionalGroupSequence"
		InvokeMacro="CardiacSynchronizationMacro"		Condition="NeedCardiacSynchronizationMacroInSharedFunctionalGroupSequence"
		InvokeMacro="FrameAnatomyMacro"			Condition="FrameAnatomySequenceNotInPerFrameFunctionalGroupSequence"
		InvokeMacro="CTFrameVOILUTMacro"		Condition="FrameVOILUTMacroOKInSharedFunctionalGroupSequence"
		InvokeMacro="RealWorldValueMappingMacro"	Condition="RealWorldValueMappingMacroOKInSharedFunctionalGroupSequence"
		InvokeMacro="ContrastBolusUsageMacro"		Condition="NeedContrastBolusUsageMacroInSharedFunctionalGroupSequence"
		InvokeMacro="RespiratorySynchronizationMacro"		Condition="NeedRespiratorySynchronizationMacroInSharedFunctionalGroupSequence"
		InvokeMacro="IrradiationEventIdentificationMacro"		Condition="IrradiationEventIdentificationSequenceNotInPerFrameFunctionalGroupSequence"
		InvokeMacro="CTImageFrameTypeMacro"		Condition="CTImageFrameTypeSequenceNotInPerFrameFunctionalGroupSequence"
		InvokeMacro="CTAcquisitionTypeMacro"		Condition="NeedCTAcquisitionTypeMacroInSharedFunctionalGroupSequence"
		InvokeMacro="CTAcquisitionDetailsMacro"		Condition="NeedCTAcquisitionDetailsMacroInSharedFunctionalGroupSequence"
		InvokeMacro="CTTableDynamicsMacro"		Condition="NeedCTTableDynamicsMacroInSharedFunctionalGroupSequence"
		InvokeMacro="CTPositionMacro"			Condition="NeedCTPositionMacroInSharedFunctionalGroupSequence"
		InvokeMacro="CTGeometryMacro"			Condition="NeedCTGeometryMacroInSharedFunctionalGroupSequence"
		InvokeMacro="CTReconstructionMacro"		Condition="NeedCTReconstructionMacroInSharedFunctionalGroupSequence"
		InvokeMacro="CTExposureMacro"			Condition="NeedCTExposureMacroInSharedFunctionalGroupSequence"
		InvokeMacro="CTXRayDetailsMacro"		Condition="NeedCTXRayDetailsMacroInSharedFunctionalGroupSequence"
		InvokeMacro="CTPixelValueTransformationMacro"	Condition="PixelValueTransformationSequenceNotInPerFrameFunctionalGroupSequence"
		InvokeMacro="CTAdditionalXRaySourceMacro"		Condition="CTAdditionalXRaySourceMacroInSharedFunctionalGroupSequence"
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
		InvokeMacro="CTFrameVOILUTMacro"		Condition="FrameVOILUTMacroOKInPerFrameFunctionalGroupSequence"
		InvokeMacro="RealWorldValueMappingMacro"	Condition="RealWorldValueMappingMacroOKInPerFrameFunctionalGroupSequence"
		InvokeMacro="ContrastBolusUsageMacro"		Condition="NeedContrastBolusUsageMacroInPerFrameFunctionalGroupSequence"
		InvokeMacro="RespiratorySynchronizationMacro"		Condition="NeedRespiratorySynchronizationMacroInPerFrameFunctionalGroupSequence"
		InvokeMacro="IrradiationEventIdentificationMacro"		Condition="IrradiationEventIdentificationSequenceNotInSharedFunctionalGroupSequence"
		InvokeMacro="CTImageFrameTypeMacro"		Condition="CTImageFrameTypeSequenceNotInSharedFunctionalGroupSequence"
		InvokeMacro="CTAcquisitionTypeMacro"		Condition="NeedCTAcquisitionTypeMacroInPerFrameFunctionalGroupSequence"
		InvokeMacro="CTAcquisitionDetailsMacro"		Condition="NeedCTAcquisitionDetailsMacroInPerFrameFunctionalGroupSequence"
		InvokeMacro="CTTableDynamicsMacro"		Condition="NeedCTTableDynamicsMacroInPerFrameFunctionalGroupSequence"
		InvokeMacro="CTPositionMacro"			Condition="NeedCTPositionMacroInPerFrameFunctionalGroupSequence"
		InvokeMacro="CTGeometryMacro"			Condition="NeedCTGeometryMacroInPerFrameFunctionalGroupSequence"
		InvokeMacro="CTReconstructionMacro"		Condition="NeedCTReconstructionMacroInPerFrameFunctionalGroupSequence"
		InvokeMacro="CTExposureMacro"			Condition="NeedCTExposureMacroInPerFrameFunctionalGroupSequence"
		InvokeMacro="CTXRayDetailsMacro"		Condition="NeedCTXRayDetailsMacroInPerFrameFunctionalGroupSequence"
		InvokeMacro="CTPixelValueTransformationMacro"	Condition="PixelValueTransformationSequenceNotInSharedFunctionalGroupSequence"
		InvokeMacro="CTAdditionalXRaySourceMacro"		Condition="CTAdditionalXRaySourceMacroInPerFrameFunctionalGroupSequence"
	SequenceEnd
ModuleEnd

Module="MultiFrameFunctionalGroupsForLegacyConvertedEnhancedCTImage"
	Sequence="SharedFunctionalGroupsSequence"				Type="1"	VM="1"
		InvokeMacro="PixelMeasuresMacro"					Condition="PixelMeasuresSequenceNotInPerFrameFunctionalGroupSequence"
		InvokeMacro="PlanePositionMacro"					Condition="PlanePositionSequenceNotInPerFrameFunctionalGroupSequence"
		InvokeMacro="PlaneOrientationMacro"					Condition="PlaneOrientationSequenceNotInPerFrameFunctionalGroupSequence"
		InvokeMacro="ReferencedImageMacro"					Condition="ReferencedImageMacroOKInSharedFunctionalGroupSequence"
		InvokeMacro="DerivationImageMacro"					Condition="DerivationImageMacroOKInSharedFunctionalGroupSequence"
		InvokeMacro="CardiacSynchronizationMacro"			Condition="CardiacSynchronizationMacroOKInSharedFunctionalGroupSequence"
		InvokeMacro="FrameAnatomyMacro"						Condition="FrameAnatomyMacroOKInSharedFunctionalGroupSequence"
		InvokeMacro="FrameVOILUTMacro"						Condition="FrameVOILUTMacroOKInSharedFunctionalGroupSequence"
		InvokeMacro="ContrastBolusUsageMacro"				Condition="NeedContrastBolusUsageMacroInSharedFunctionalGroupSequence"
		InvokeMacro="RespiratorySynchronizationMacro"		Condition="RespiratorySynchronizationMacroOKInSharedFunctionalGroupSequence"
		InvokeMacro="IrradiationEventIdentificationMacro"	Condition="IrradiationEventIdentificationMacroOKInSharedFunctionalGroupSequence"
		InvokeMacro="CTImageFrameTypeMacro"					Condition="CTImageFrameTypeSequenceNotInPerFrameFunctionalGroupSequence"
		InvokeMacro="CTPixelValueTransformationMacro"		Condition="PixelValueTransformationSequenceOKInSharedFunctionalGroupSequence"
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
		InvokeMacro="FrameVOILUTMacro"						Condition="FrameVOILUTMacroOKInPerFrameFunctionalGroupSequence"
		InvokeMacro="ContrastBolusUsageMacro"				Condition="NeedContrastBolusUsageMacroInPerFrameFunctionalGroupSequence"
		InvokeMacro="RespiratorySynchronizationMacro"		Condition="RespiratorySynchronizationMacroOKInPerFrameFunctionalGroupSequence"
		InvokeMacro="IrradiationEventIdentificationMacro"	Condition="IrradiationEventIdentificationMacroOKInPerFrameFunctionalGroupSequence"
		InvokeMacro="CTImageFrameTypeMacro"					Condition="CTImageFrameTypeSequenceNotInSharedFunctionalGroupSequence"
		InvokeMacro="CTPixelValueTransformationMacro"		Condition="PixelValueTransformationSequenceOKInPerFrameFunctionalGroupSequence"
		InvokeMacro="UnassignedPerFrameConvertedAttributesMacro"
		InvokeMacro="ImageFrameConversionSourceMacro"
	SequenceEnd
ModuleEnd


Module="MultiFrameFunctionalGroupsForPrivatePixelMedLegacyConvertedEnhancedCTImage"
	Sequence="SharedFunctionalGroupsSequence"				Type="1"	VM="1"
		InvokeMacro="PixelMeasuresMacro"					Condition="PixelMeasuresSequenceNotInPerFrameFunctionalGroupSequence"
		InvokeMacro="PlanePositionMacro"					Condition="PlanePositionSequenceNotInPerFrameFunctionalGroupSequence"
		InvokeMacro="PlaneOrientationMacro"					Condition="PlaneOrientationSequenceNotInPerFrameFunctionalGroupSequence"
		InvokeMacro="ReferencedImageMacro"					Condition="ReferencedImageMacroOKInSharedFunctionalGroupSequence"
		InvokeMacro="DerivationImageMacro"					Condition="DerivationImageMacroOKInSharedFunctionalGroupSequence"
		InvokeMacro="CardiacSynchronizationMacro"			Condition="CardiacSynchronizationMacroOKInSharedFunctionalGroupSequence"
		InvokeMacro="FrameAnatomyMacro"						Condition="FrameAnatomyMacroOKInSharedFunctionalGroupSequence"
		InvokeMacro="CTFrameVOILUTMacro"					Condition="FrameVOILUTSequenceNotInPerFrameFunctionalGroupSequence"
		InvokeMacro="ContrastBolusUsageMacro"				Condition="NeedContrastBolusUsageMacroInSharedFunctionalGroupSequence"
		InvokeMacro="RespiratorySynchronizationMacro"		Condition="RespiratorySynchronizationMacroOKInSharedFunctionalGroupSequence"
		InvokeMacro="IrradiationEventIdentificationMacro"	Condition="IrradiationEventIdentificationMacroOKInSharedFunctionalGroupSequence"
		InvokeMacro="CTImageFrameTypeMacro"					Condition="CTImageFrameTypeSequenceNotInPerFrameFunctionalGroupSequence"
		InvokeMacro="CTPixelValueTransformationMacro"		Condition="PixelValueTransformationSequenceNotInPerFrameFunctionalGroupSequence"
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
		InvokeMacro="CTFrameVOILUTMacro"					Condition="FrameVOILUTSequenceNotInSharedFunctionalGroupSequence"
		InvokeMacro="ContrastBolusUsageMacro"				Condition="NeedContrastBolusUsageMacroInPerFrameFunctionalGroupSequence"
		InvokeMacro="RespiratorySynchronizationMacro"		Condition="RespiratorySynchronizationMacroOKInPerFrameFunctionalGroupSequence"
		InvokeMacro="IrradiationEventIdentificationMacro"	Condition="IrradiationEventIdentificationMacroOKInPerFrameFunctionalGroupSequence"
		InvokeMacro="CTImageFrameTypeMacro"					Condition="CTImageFrameTypeSequenceNotInSharedFunctionalGroupSequence"
		InvokeMacro="CTPixelValueTransformationMacro"		Condition="PixelValueTransformationSequenceNotInSharedFunctionalGroupSequence"
		InvokeMacro="UnassignedPerFrameConvertedAttributesMacro"
		InvokeMacro="ImageFrameConversionSourceMacro"		Condition="ConversionSourceAttributesSequenceNotInSharedFunctionalGroupSequence"
	SequenceEnd
ModuleEnd


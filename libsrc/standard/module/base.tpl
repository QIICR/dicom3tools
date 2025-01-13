DefineMacro="IconImageSequenceMacro"
	#InvokeMacro="ImagePixelMacro" # would be nice to do this, but can't then insert verify statements (undeclared variables)
	Name="SamplesPerPixel"							Type="1"	BinaryEnumValues="SamplesPerPixelIsOne"
	Name="PhotometricInterpretation"				Type="1"	StringEnumValues="IconImagePhotometricInterpretation"
	Name="Rows"										Type="1"	NotZeroError=""
	Name="Columns"									Type="1"	NotZeroError=""
	Name="BitsAllocated"							Type="1"	BinaryEnumValues="BitsAre1Or8"
	Name="BitsStored"								Type="1"	BinaryEnumValues="BitsAre1Or8"
	Name="HighBit"									Type="1"	BinaryEnumValues="BitsAre0Or7"
	Name="PixelRepresentation"						Type="1"	BinaryEnumValues="PixelRepresentationUnsigned"
	Name="PixelData"								Type="1"
	Name="PlanarConfiguration"						Type="1C"	BinaryEnumValues="PlanarConfiguration"	Condition="Never"
	Name="PixelAspectRatio"							Type="3"	BinaryEnumValues="One"
	Name="SmallestImagePixelValue"					Type="3"
	Name="LargestImagePixelValue"					Type="3"
	Name="RedPaletteColorLookupTableDescriptor"		Type="1C"	Condition="PhotometricInterpretationNeedsPalette"
	Verify="RedPaletteColorLookupTableDescriptor"				ValueSelector="2"	BinaryEnumValues="BitsAre8Or16"
	Name="GreenPaletteColorLookupTableDescriptor"	Type="1C"	Condition="PhotometricInterpretationNeedsPalette"
	Verify="GreenPaletteColorLookupTableDescriptor"				ValueSelector="2"	BinaryEnumValues="BitsAre8Or16"
	Name="BluePaletteColorLookupTableDescriptor"	Type="1C"	Condition="PhotometricInterpretationNeedsPalette"
	Verify="BluePaletteColorLookupTableDescriptor"				ValueSelector="2"	BinaryEnumValues="BitsAre8Or16"
	Name="RedPaletteColorLookupTableData"			Type="1C"	Condition="PhotometricInterpretationNeedsPalette"
	Name="GreenPaletteColorLookupTableData"			Type="1C"	Condition="PhotometricInterpretationNeedsPalette"
	Name="BluePaletteColorLookupTableData"			Type="1C"	Condition="PhotometricInterpretationNeedsPalette"
	Name="ICCProfile"								Type="3"
	Name="ColorSpace"								Type="3"
MacroEnd

DefineMacro="BasicCodeSequenceMacro"
	Name="CodeValue"						Type="1C"	Condition="LongCodeValueAndURNCodeValueAbsent"
	Verify="CodeValue"									Condition="CodeValueIllegalOrDeprecated"	ThenErrorMessage="CodeValue is illegal or deprecated" ShowValueWithMessage="true"
	Name="CodingSchemeDesignator"			Type="1C"	Condition="CodeValueOrLongCodeValuePresent"	StringDefinedTerms="MiscellaneousCodingSchemeDesignators"	mbpo="true"
	Verify="CodingSchemeDesignator"						Condition="CodingSchemeDesignatorDeprecated"	ThenWarningMessage="CodingSchemeDesignator is deprecated" ShowValueWithMessage="true"
	Name="CodingSchemeVersion"				Type="1C"	Condition="CodingSchemeVersionRequired" mbpo="true"
	Name="CodeMeaning"						Type="1"
	Verify="CodeMeaning"								Condition="CodeMeaningIllegalOrDeprecated"	ThenErrorMessage="CodeMeaning is illegal or deprecated" ShowValueWithMessage="true"
	Name="LongCodeValue"					Type="1C"	Condition="CodeValueAndURNCodeValueAbsent"
	Name="URNCodeValue"						Type="1C"	Condition="CodeValueAndLongCodeValueAbsent"
MacroEnd

DefineMacro="EnhancedCodeSequenceMacro"
	Name="ContextIdentifier"				Type="3"
	Name="ContextUID"						Type="3"
	Name="MappingResource"					Type="1C"	Condition="ContextIdentifierIsPresent"		StringDefinedTerms="MappingResources"
	Name="MappingResourceUID"				Type="3"	StringDefinedTerms="MappingResourceUIDs"
	Name="MappingResourceName"				Type="3"	StringDefinedTerms="MappingResourceNames"
	Name="ContextGroupVersion"				Type="1C"	Condition="ContextIdentifierIsPresent"
	Name="ContextGroupExtensionFlag"		Type="3"	StringEnumValues="YesNoLetter"
	Name="ContextGroupLocalVersion"			Type="1C"	Condition="ExtendedCodingScheme"
	Name="ContextGroupExtensionCreatorUID"	Type="1C"	Condition="ExtendedCodingScheme"
MacroEnd

DefineMacro="CodeSequenceMacro"
	InvokeMacro="BasicCodeSequenceMacro"
	Sequence="EquivalentCodeSequence"		Type="3"	VM="1-n"
		InvokeMacro="BasicCodeSequenceMacro"
		InvokeMacro="EnhancedCodeSequenceMacro"
	SequenceEnd
	InvokeMacro="EnhancedCodeSequenceMacro"
MacroEnd

DefineMacro="BasicCodeSequenceMeaningOptionalMacro"
	Name="CodeValue"						Type="1C"	Condition="LongCodeValueAndURNCodeValueAbsent"
	Verify="CodeValue"									Condition="CodeValueIllegalOrDeprecated"	ThenErrorMessage="CodeValue is illegal or deprecated" ShowValueWithMessage="true"
	Name="CodingSchemeDesignator"			Type="1C"	Condition="CodeValueOrLongCodeValuePresent"	StringDefinedTerms="MiscellaneousCodingSchemeDesignators"	mbpo="true"
	Verify="CodingSchemeDesignator"						Condition="CodingSchemeDesignatorDeprecated"	ThenWarningMessage="CodingSchemeDesignator is deprecated" ShowValueWithMessage="true"
	Name="CodingSchemeVersion"				Type="1C"	Condition="CodingSchemeVersionRequired" mbpo="true"
	Name="CodeMeaning"						Type="3"
	Verify="CodeMeaning"								Condition="CodeMeaningEmptyOrNotPresent"	ThenWarningMessage="CodeMeaning is missing or empty, which is legal but undesirable"
	Verify="CodeMeaning"								Condition="CodeMeaningIllegalOrDeprecated"	ThenErrorMessage="CodeMeaning is illegal or deprecated" ShowValueWithMessage="true"
	Name="LongCodeValue"					Type="1C"	Condition="CodeValueAndURNCodeValueAbsent"
	Name="URNCodeValue"						Type="1C"	Condition="CodeValueAndLongCodeValueAbsent"
MacroEnd

DefineMacro="CodeSequenceMeaningOptionalMacro"
	InvokeMacro="BasicCodeSequenceMeaningOptionalMacro"
	Sequence="EquivalentCodeSequence"		Type="3"	VM="1-n"
		InvokeMacro="BasicCodeSequenceMacro"
		InvokeMacro="EnhancedCodeSequenceMacro"
	SequenceEnd
	InvokeMacro="EnhancedCodeSequenceMacro"
MacroEnd

DefineMacro="PersonIdentificationMacro"
	Sequence="PersonIdentificationCodeSequence"			Type="1"	VM="1-n"
		InvokeMacro="CodeSequenceMacro"
	SequenceEnd
	Name="PersonAddress"								Type="3"
	Name="PersonTelephoneNumbers"						Type="3"
	Name="PersonTelecomInformation"						Type="3"
	Name="InstitutionName"								Type="1C"	Condition="InstitutionCodeSequenceNotPresent"
	Name="InstitutionAddress"							Type="3"
	Sequence="InstitutionCodeSequence"					Type="1C"	VM="1"	Condition="InstitutionNameNotPresent"
		InvokeMacro="CodeSequenceMacro"
	SequenceEnd
	Name="InstitutionalDepartmentName"					Type="3"
	Sequence="InstitutionalDepartmentTypeCodeSequence"	Type="3"	VM="1"
		InvokeMacro="CodeSequenceMacro"								BaselineContextID="7030"
	SequenceEnd
MacroEnd

DefineMacro="ContentItemMacro"
	Name="ValueType"						Type="1"	StringEnumValues="ContentItemValueTypes"
	Name="ObservationDateTime"				Type="3"
	Name="ObservationStartDateTime"			Type="3"
	Sequence="ConceptNameCodeSequence"		Type="1"	VM="1"
		InvokeMacro="CodeSequenceMacro"
	SequenceEnd
	Name="DateTime"							Type="1C"	Condition="ValueTypeIsDateTime"
	Name="Date"								Type="1C"	Condition="ValueTypeIsDate"
	Name="Time"								Type="1C"	Condition="ValueTypeIsTime"
	Name="PersonName"						Type="1C"	Condition="ValueTypeIsPersonName"
	Name="UID"								Type="1C"	Condition="ValueTypeIsUID"
	Name="TextValue"						Type="1C"	Condition="ValueTypeIsText"
	Sequence="ConceptCodeSequence"			Type="1C"	VM="1"	Condition="ValueTypeIsCode"
		InvokeMacro="CodeSequenceMacro"
	SequenceEnd
	Name="NumericValue"						Type="1C"	Condition="ValueTypeIsNumeric"
	Name="FloatingPointValue"				Type="1C"	NoCondition=""
	Verify="FloatingPointValue"							Condition="FloatingPointValuePresentButValueTypeIsNotNumeric"	ThenErrorMessage="May only be present for NUMERIC ValueType"
	Name="RationalNumeratorValue"			Type="1C"	NoCondition=""
	Verify="RationalNumeratorValue"						Condition="RationalNumeratorValuePresentButValueTypeIsNotNumeric"	ThenErrorMessage="May only be present for NUMERIC ValueType"
	Name="RationalDenominatorValue"			Type="1C"	Condition="RationalNumeratorValueIsPresent" NotZeroError=""
	Verify="RationalDenominatorValue"					Condition="RationalDenominatorValueButValueTypeIsNotNumeric"	ThenErrorMessage="May only be present for NUMERIC ValueType"
	Sequence="MeasurementUnitsCodeSequence"	Type="1C"	VM="1"	Condition="ValueTypeIsNumeric"
		InvokeMacro="CodeSequenceMacro"
	SequenceEnd
	Sequence="ReferencedSOPSequence"		Type="1C"	VM="1"	Condition="ValueTypeIsCompositeOrImageOrWaveform"
		InvokeMacro="SOPInstanceReferenceMacro"
		Name="ReferencedFrameNumber"		Type="1C"	NoCondition=""	NotZeroError=""	# cannot just check SOP Class and mbpo false, since may be absent for multi-frame if applies to all frames (including multi-frame SOP Class with only 1 frame) :(
		Verify="ReferencedFrameNumber"					Condition="ReferencedFrameNumberPresentAndReferencedSOPClassUIDIsNotMultiFrame"	ThenErrorMessage="Shall not be present for Referenced SOP Class that is not multi-frame"
		Name="ReferencedSegmentNumber"		Type="1C"	NoCondition=""	NotZeroError=""	# cannot just check SOP Class and mbpo false, since may be absent for segmentation if applies to all segments :(
		Verify="ReferencedSegmentNumber"				Condition="ReferencedSegmentNumberPresentAndReferencedSOPClassUIDIsNotSegmentationOrSurfaceSegmentation"	ThenErrorMessage="Shall not be present for Referenced SOP Class that is not segmentation"
		Verify="ReferencedSegmentNumber"				Condition="ReferencedFrameNumberAndReferencedSegmentNumberPresent"	ThenErrorMessage="Shall not be present when ReferencedFrameNumber is present"
		Name="ReferencedWaveformChannels"	Type="1C"	NoCondition=""	NotZeroError=""	# cannot just check SOP Class and mbpo false, since may be absent for waveform if applies to all all Channels of all Multiplex Groups :(
		Verify="ReferencedWaveformChannels"				Condition="ReferencedWaveformChannelsPresentAndReferencedSOPClassUIDIsNotWaveform"	ThenErrorMessage="Shall not be present for Referenced SOP Class that is not waveform"
		SequenceEnd
MacroEnd

DefineMacro="ContentItemWithModifiersMacro"
	InvokeMacro="ContentItemMacro"
	Sequence="ContentItemModifierSequence"	Type="3"	VM="1-n"
		InvokeMacro="ContentItemMacro"
	SequenceEnd
MacroEnd

DefineMacro="ImageSOPInstanceReferenceMacro" InformationEntity="Image"
	InvokeMacro="SOPInstanceReferenceMacro"
	Name="ReferencedFrameNumber"					Type="1C"	NoCondition=""	NotZeroError=""	# cannot just check SOP Class and mbpo false, since may be absent for multi-frame if applies to all frames (including multi-frame SOP Class with only 1 frame) :(
	Verify="ReferencedFrameNumber"								Condition="ReferencedFrameNumberPresentAndReferencedSOPClassUIDIsNotMultiFrame"	ThenErrorMessage="Shall not be present for Referenced SOP Class that is not multi-frame"
	Name="ReferencedSegmentNumber"					Type="1C"	NoCondition=""	NotZeroError=""	# cannot just check SOP Class and mbpo false, since may be absent for segmentation if applies to all segments :(
	Verify="ReferencedSegmentNumber"							Condition="ReferencedSegmentNumberPresentAndReferencedSOPClassUIDIsNotSegmentationOrSurfaceSegmentation"	ThenErrorMessage="Shall not be present for Referenced SOP Class that is not segmentation"
	Verify="ReferencedSegmentNumber"							Condition="ReferencedFrameNumberAndReferencedSegmentNumberPresent"	ThenErrorMessage="Shall not be present when ReferencedFrameNumber is present"
MacroEnd

DefineMacro="ReferencedInstancesAndAccessMacro" InformationEntity="Image"
	Name="TypeOfInstances"					Type="1"	VM="1"	StringDefinedTerms="TypeOfInstances"
	Name="StudyInstanceUID"					Type="1C"	VM="1"	Condition="TypeOfInstancesIsDICOM"
	Name="SeriesInstanceUID"				Type="1C"	VM="1"	Condition="TypeOfInstancesIsDICOM"
	Sequence="ReferencedSOPSequence"		Type="1"	VM="1-n"
		Name="ReferencedSOPClassUID"		Type="1"
		Name="ReferencedSOPInstanceUID"		Type="1"
		Name="HL7InstanceIdentifier"		Type="1C"	VM="1"	Condition="TypeOfInstancesInParentIsCDA"
		Name="ReferencedFrameNumber"		Type="1C"	VM="1"	NoCondition="" mbpo="true"	# real-world - could check mutually exclusive with ReferencedSegmentNumber though :(
		Name="ReferencedSegmentNumber"		Type="1C"	VM="1"	NoCondition="" mbpo="true"	# real-world - could check mutually exclusive with ReferencedFrameNumber though :(
	SequenceEnd
	Sequence="DICOMRetrievalSequence"		Type="1C"	VM="1"	Condition="NeedDICOMRetrievalSequence" mbpo="true"
		Name="RetrieveAETitle"				Type="1"
	SequenceEnd
	Sequence="DICOMMediaRetrievalSequence"	Type="1C"	VM="1"	Condition="NeedDICOMMediaRetrievalSequence" mbpo="true"
		Name="StorageMediaFileSetID"		Type="2"
		Name="StorageMediaFileSetUID"		Type="1"
	SequenceEnd
	Sequence="WADORetrievalSequence"		Type="1C"	VM="1"	Condition="NeedWADORetrievalSequence" mbpo="true"
		Name="RetrieveURI"					Type="1"
	SequenceEnd
	Sequence="XDSRetrievalSequence"			Type="1C"	VM="1"	Condition="NeedXDSRetrievalSequence" mbpo="true"
		Name="RepositoryUniqueID"			Type="1"
		Name="HomeCommunityID"				Type="3"
	SequenceEnd
	Sequence="WADORSRetrievalSequence"		Type="1C"	VM="1"	Condition="NeedWADORSRetrievalSequence" mbpo="true"
		Name="RetrieveURL"					Type="1"
	SequenceEnd
MacroEnd

DefineMacro="StorageMacro"
	Name="ReferencedSOPClassUID"			Type="1C"			NoCondition="" mbpo="true"		# cannot determine whether needs to be specific to SOP Class or not :(
	Sequence="DICOMStorageSequence"			Type="1C"	VM="1"	Condition="NeedDICOMStorageSequence" mbpo="true"
		Name="DestinationAE"				Type="1"
	SequenceEnd
	Sequence="STOWRSStorageSequence"		Type="1C"	VM="1"	Condition="NeedSTOWRSStorageSequence" mbpo="true"
		Name="StorageURL"					Type="1"
	SequenceEnd
	Sequence="XDSStorageSequence"			Type="1C"	VM="1"	Condition="XDSStorageSequence" mbpo="true"
		Name="RepositoryUniqueID"			Type="1"
		Name="HomeCommunityID"				Type="3"
	SequenceEnd
MacroEnd

DefineMacro="SeriesAndInstanceReferenceMacro" InformationEntity="Image"
	Sequence="ReferencedSeriesSequence"				Type="1"	VM="1-n"
		Name="SeriesInstanceUID"					Type="1"
		Sequence="ReferencedInstanceSequence"		Type="1"	VM="1-n"
			InvokeMacro="SOPInstanceReferenceMacro"
		SequenceEnd
	SequenceEnd
MacroEnd

DefineMacro="PrimaryAnatomicStructureMacro" InformationEntity="Frame"
	Sequence="PrimaryAnatomicStructureSequence"				Type="3"	VM="1-n"
		InvokeMacro="CodeSequenceMacro"
		Sequence="PrimaryAnatomicStructureModifierSequence"	Type="3"	VM="1-n"
			InvokeMacro="CodeSequenceMacro"	BaselineContextID="2"
		SequenceEnd
	SequenceEnd
MacroEnd

DefineMacro="GeneralAnatomyMandatoryMacro" InformationEntity="Frame"
	Sequence="AnatomicRegionSequence"						Type="1"	VM="1"
		InvokeMacro="CodeSequenceMacro"
		Sequence="AnatomicRegionModifierSequence"			Type="3"	VM="1-n"
			InvokeMacro="CodeSequenceMacro"	BaselineContextID="2"
		SequenceEnd
	SequenceEnd
	InvokeMacro="PrimaryAnatomicStructureMacro"
	Sequence="AnatomicRegionModifierSequence"				Type="1C"	VM="1-n"	Condition="Never"
	SequenceEnd
	Sequence="PrimaryAnatomicStructureModifierSequence"		Type="1C"	VM="1-n"	Condition="Never"
	SequenceEnd
MacroEnd

DefineMacro="GeneralAnatomyRequiredMacro" InformationEntity="Frame"
	Sequence="AnatomicRegionSequence"						Type="2"	VM="0-1"
		InvokeMacro="CodeSequenceMacro"
		Sequence="AnatomicRegionModifierSequence"			Type="3"	VM="1-n"
			InvokeMacro="CodeSequenceMacro"	BaselineContextID="2"
		SequenceEnd
	SequenceEnd
	Verify="AnatomicRegionSequence"													Condition="AnatomicRegionSequencePresentAndEmptyButBodyPartExaminedHasValue"	ThenErrorMessage="AnatomicRegionSequence is only permitted to be empty when actually unknown, but BodyPartExamined has a value, therefore it is known"
	InvokeMacro="PrimaryAnatomicStructureMacro"
	Sequence="AnatomicRegionModifierSequence"				Type="1C"	VM="1-n"	Condition="Never"
	SequenceEnd
	Sequence="PrimaryAnatomicStructureModifierSequence"		Type="1C"	VM="1-n"	Condition="Never"
	SequenceEnd
MacroEnd

DefineMacro="GeneralAnatomyOptionalMacro" InformationEntity="Frame"
	Sequence="AnatomicRegionSequence"						Type="3"	VM="1"
		InvokeMacro="CodeSequenceMacro"
		Sequence="AnatomicRegionModifierSequence"			Type="3"	VM="1-n"
			InvokeMacro="CodeSequenceMacro"	BaselineContextID="2"
		SequenceEnd
	SequenceEnd
	InvokeMacro="PrimaryAnatomicStructureMacro"
	Sequence="AnatomicRegionModifierSequence"				Type="1C"	VM="1-n"	Condition="Never"
	SequenceEnd
	Sequence="PrimaryAnatomicStructureModifierSequence"		Type="1C"	VM="1-n"	Condition="Never"
	SequenceEnd
MacroEnd

DefineMacro="MultipleSiteGeneralAnatomyOptionalMacro" InformationEntity="Frame"
	Sequence="AnatomicRegionSequence"						Type="3"	VM="1-n"
		InvokeMacro="CodeSequenceMacro"
		Sequence="AnatomicRegionModifierSequence"			Type="3"	VM="1-n"
			InvokeMacro="CodeSequenceMacro"	BaselineContextID="2"
		SequenceEnd
	SequenceEnd
	InvokeMacro="PrimaryAnatomicStructureMacro"
	Sequence="AnatomicRegionModifierSequence"				Type="1C"	VM="1-n"	Condition="Never"
	SequenceEnd
	Sequence="PrimaryAnatomicStructureModifierSequence"		Type="1C"	VM="1-n"	Condition="Never"
	SequenceEnd
MacroEnd

DefineMacro="RequestAttributesMacro" InformationEntity="Series"
	Name="RequestedProcedureID"							Type="1C"	NoCondition="" mbpo="true"
	Name="AccessionNumber"								Type="3"
	Sequence="IssuerOfAccessionNumberSequence"			Type="3"	VM="1"
		InvokeMacro="HL7v2HierarchicDesignatorMacro"
	SequenceEnd
	Name="StudyInstanceUID"								Type="3"
	Sequence="ReferencedStudySequence"					Type="3"	VM="1-n"
		InvokeMacro="SOPInstanceReferenceMacro"
	SequenceEnd
	Name="RequestedProcedureDescription"				Type="3"
	Sequence="RequestedProcedureCodeSequence"			Type="3"	VM="1"
		InvokeMacro="CodeSequenceMacro"
	SequenceEnd
	Name="ReasonForTheRequestedProcedure"				Type="3"
	Sequence="ReasonForRequestedProcedureCodeSequence"	Type="3"	VM="1"
		InvokeMacro="CodeSequenceMacro"
	SequenceEnd
	Name="ScheduledProcedureStepID"						Type="1C"	NoCondition="" mbpo="true"
	Name="ScheduledProcedureStepDescription"			Type="3"
	Sequence="ScheduledProtocolCodeSequence"			Type="3"	VM="1-n"
		InvokeMacro="CodeSequenceMacro"
		Sequence="ProtocolContextSequence"				Type="3"	VM="1-n"
			InvokeMacro="ContentItemMacro"
			Sequence="ContentItemModifierSequence"		Type="3"	VM="1-n"
				InvokeMacro="ContentItemMacro"
			SequenceEnd
		SequenceEnd
	SequenceEnd
MacroEnd

DefineMacro="BasicPixelSpacingCalibrationMacro" InformationEntity="Frame"
	Name="PixelSpacing"							Type="1C"	NoCondition=""	NotZeroError=""
	Name="PixelSpacingCalibrationType"			Type="3"
	Name="PixelSpacingCalibrationDescription"	Type="1C"	Condition="PixelSpacingCalibrationTypeIsPresent"
MacroEnd

DefineMacro="SOPInstanceReferenceMacro"
	Name="ReferencedSOPClassUID"				Type="1"
	Name="ReferencedSOPInstanceUID"				Type="1"
MacroEnd

DefineMacro="DisplayShutterMacro" InformationEntity="Frame"
	Name="ShutterShape"							Type="1"	StringEnumValues="ShutterShape"
	Name="ShutterLeftVerticalEdge"				Type="1C"	Condition="ShutterShapeIsRectangular"
	Name="ShutterRightVerticalEdge"				Type="1C"	Condition="ShutterShapeIsRectangular"
	Name="ShutterUpperHorizontalEdge"			Type="1C"	Condition="ShutterShapeIsRectangular"
	Name="ShutterLowerHorizontalEdge"			Type="1C"	Condition="ShutterShapeIsRectangular"
	Name="CenterOfCircularShutter"				Type="1C"	Condition="ShutterShapeIsCircular"
	Name="RadiusOfCircularShutter"				Type="1C"	Condition="ShutterShapeIsCircular"
	Name="VerticesOfThePolygonalShutter"		Type="1C"	Condition="ShutterShapeIsPolygonal"
	Name="ShutterPresentationValue"				Type="3"
	Name="ShutterPresentationColorCIELabValue"	Type="3"
MacroEnd

DefineMacro="ContentIdentificationMacro" InformationEntity="Instance"
	Name="InstanceNumber"										Type="1"
	Name="ContentLabel"											Type="1"
	Name="ContentDescription"									Type="2"
	Sequence="ConceptNameCodeSequence"							Type="3"	VM="1"
		InvokeMacro="CodeSequenceMacro"
	SequenceEnd
	Sequence="AlternateContentDescriptionSequence"				Type="3"	VM="1-n"
		Name="ContentDescription"								Type="1"
		Sequence="LanguageCodeSequence"							Type="1"	VM="1"
			InvokeMacro="CodeSequenceMacro"									DefinedContextID="5000"
		SequenceEnd
		Sequence="ConceptNameCodeSequence"						Type="3"	VM="1"
			InvokeMacro="CodeSequenceMacro"
		SequenceEnd
	SequenceEnd
	InvokeMacro="ContentCreatorMacro"
MacroEnd

DefineMacro="EnhancedContentIdentificationMacro" InformationEntity="Instance"
	Name="UserContentLabel"										Type="1"
	Name="ContentDescription"									Type="2"
	InvokeMacro="ContentCreatorMacro"
MacroEnd

DefineMacro="ExtendedContentIdentificationMacro" InformationEntity="Instance"
	Name="UserContentLongLabel"									Type="1"
	Name="ContentDescription"									Type="2"
	InvokeMacro="ContentCreatorMacro"
MacroEnd

DefineMacro="ContentCreatorMacro" InformationEntity="Instance"
	Name="ContentCreatorName"									Type="3"
	Sequence="ContentCreatorIdentificationCodeSequence"			Type="3"	VM="1"
		InvokeMacro="PersonIdentificationMacro"
	SequenceEnd
MacroEnd

DefineMacro="HL7v2HierarchicDesignatorMacro"
	Name="LocalNamespaceEntityID"								Type="1C"	Condition="UniversalEntityIDNotPresent" mbpo="true"
	Name="UniversalEntityID"									Type="1C"	Condition="LocalNamespaceEntityIDNotPresent" mbpo="true"
	Name="UniversalEntityIDType"								Type="1C"	Condition="UniversalEntityIDPresent" StringDefinedTerms="UniversalEntityIDType"
MacroEnd

DefineMacro="IssuerOfPatientIDMacro"
	Name="IssuerOfPatientID"									Type="3"
	Sequence="IssuerOfPatientIDQualifiersSequence"				Type="3"	VM="1"
		Name="UniversalEntityID"								Type="3"
		Name="UniversalEntityIDType"							Type="3"	StringDefinedTerms="UniversalEntityIDType"
		Name="IdentifierTypeCode"								Type="3"	StringDefinedTerms="HL7Table0203IdentifierType"
		Sequence="AssigningFacilitySequence"					Type="3"	VM="1"
			InvokeMacro="HL7v2HierarchicDesignatorMacro"
		SequenceEnd
		Sequence="AssigningJurisdictionCodeSequence"			Type="3"	VM="1"
			InvokeMacro="CodeSequenceMacro"									BaselineContextID="5001"
		SequenceEnd
		Sequence="AssigningAgencyOrDepartmentCodeSequence"		Type="3"	VM="1"
			InvokeMacro="CodeSequenceMacro"
		SequenceEnd
	SequenceEnd
MacroEnd

DefineMacro="AlgorithmIdentificationMacro"
	Sequence="AlgorithmFamilyCodeSequence"						Type="1"	VM="1"
		InvokeMacro="CodeSequenceMacro"
	SequenceEnd
	Sequence="AlgorithmNameCodeSequence"						Type="3"	VM="1"
		InvokeMacro="CodeSequenceMacro"
	SequenceEnd
	Name="AlgorithmName"										Type="1"
	Name="AlgorithmVersion"										Type="1"
	Name="AlgorithmParameters"									Type="3"
	Name="AlgorithmSource"										Type="3"
MacroEnd

DefineMacro="SelectorAttributeMacro"
	Name="SelectorAttribute"						Type="1C"	VM="1"	NoCondition=""
	Name="SelectorValueNumber"						Type="1C"	VM="1"	NoCondition=""
	Name="SelectorSequencePointer"					Type="1C"	VM="1"	NoCondition=""
	Name="SelectorSequencePointerPrivateCreator"	Type="1C"	VM="1"	NoCondition=""
	Name="SelectorSequencePointerItems"				Type="1C"	VM="1"	Condition="SelectorSequencePointerIsPresent"
	Name="SelectorAttributePrivateCreator"			Type="1C"	VM="1"	NoCondition=""
MacroEnd

DefineMacro="ExtendedSelectorAttributeMacro"
	Name="SelectorAttributeName"					Type="1"	VM="1"
	Name="SelectorAttributeKeyword"					Type="3"	VM="1"
	Name="SelectorAttributeVR"						Type="1"	VM="1"
	InvokeMacro="SelectorAttributeMacro"
MacroEnd

DefineMacro="ExternallySourcedDataSetIdentificationMacro"
	Name="DataSetName"			Type="1"
	Name="DataSetVersion"		Type="1"
	Name="DataSetSource"		Type="1"
	Name="DataSetDescription"	Type="3"
MacroEnd

# no information entity specified for this macro, else screws up attributes that are otherwise at the Series entity level
DefineMacro="GeneralContributingSourcesMacro"
	Sequence="ContributingSOPInstancesReferenceSequence"	Type="1C"	VM="1-n"	NoCondition=""	# if present and have an equal value in the contributing SOP Instances :(
		Name="StudyInstanceUID"								Type="3"
		Sequence="ReferencedSeriesSequence"					Type="1"	VM="1-n"
			Name="SeriesInstanceUID"						Type="1"
			Name="SeriesNumber"								Type="2"
			Sequence="ReferencedInstanceSequence"			Type="1"	VM="1-n"
				InvokeMacro="SOPInstanceReferenceMacro"
				Name="InstanceNumber"						Type="2"
			SequenceEnd
		SequenceEnd
	SequenceEnd
	Name="Manufacturer"										Type="2"
	Name="ManufacturerModelName"							Type="1C"	NoCondition=""	# if present and have an equal value in the contributing SOP Instances :(
	Name="DeviceSerialNumber"								Type="1C"	NoCondition=""	# if present and have an equal value in the contributing SOP Instances :(
	Name="SoftwareVersions"									Type="1C"	NoCondition=""	# if present and have an equal value in the contributing SOP Instances :(
	Name="DateOfManufacture"								Type="3"
	Name="DateOfInstallation"								Type="3"
	Name="AcquisitionDateTime"								Type="1C"	NoCondition=""	# if present and have an equal value in the contributing SOP Instances :(
	Name="StationName"										Type="1C"	NoCondition=""	# if present and have an equal value in the contributing SOP Instances :(
	Name="OperatorsName"									Type="1C"	NoCondition=""	# if present and have an equal value in the contributing SOP Instances :(
	Sequence="OperatorIdentificationSequence"				Type="1C"	VM="1-n"	NoCondition=""	# if present and have an equal value in the contributing SOP Instances :(
		InvokeMacro="PersonIdentificationMacro"
	SequenceEnd
	Name="ProtocolName"										Type="1C"	NoCondition=""	# if present and have an equal value in the contributing SOP Instances :(
	Sequence="PerformedProtocolCodeSequence"				Type="1C"	VM="1-n"	NoCondition=""	# if present and have an equal value in the contributing SOP Instances :(
		InvokeMacro="CodeSequenceMacro"
	SequenceEnd
	Name="AcquisitionProtocolName"							Type="1C"	NoCondition=""	# if present and have an equal value in the contributing SOP Instances :(
MacroEnd

DefineMacro="ContributingImageSourcesMacro" InformationEntity="Instance"
	Name="Rows"												Type="1"	NotZeroError=""
	Name="Columns"											Type="1"	NotZeroError=""
	Name="BitsStored"										Type="1"	NotZeroError=""
	Name="LossyImageCompression"							Type="1"	StringEnumValues="LossyImageCompression"
	Name="LossyImageCompressionRatio"						Type="1C"	Condition="LossyImageCompressionIs01"	NotZeroError=""
	Name="LossyImageCompressionMethod"						Type="1C"	StringDefinedTerms="LossyImageCompressionMethod"	Condition="LossyImageCompressionIs01"
MacroEnd

DefineMacro="PatientOrientationMacro" InformationEntity="Instance"
	Sequence="PatientOrientationCodeSequence"				Type="1"	VM="1"
		InvokeMacro="CodeSequenceMacro"									BaselineContextID="19"
		Sequence="PatientOrientationModifierCodeSequence"   Type="1C"	VM="1"	NoCondition=""	# real-world - orientation wrt. gravity
 			InvokeMacro="CodeSequenceMacro"								BaselineContextID="20"
		SequenceEnd
	SequenceEnd
	Sequence="PatientGantryRelationshipCodeSequence"		Type="3"	VM="1"
		InvokeMacro="CodeSequenceMacro"									BaselineContextID="21"
	SequenceEnd
MacroEnd

DefineMacro="PerformedProcedureStepSummaryMacro" InformationEntity="Series"
	Name="PerformedProcedureStepID"							Type="3"
	Name="PerformedProcedureStepStartDate"					Type="3"
	Name="PerformedProcedureStepStartTime"					Type="3"
	Name="PerformedProcedureStepEndDate"					Type="3"
	Name="PerformedProcedureStepEndTime"					Type="3"
	Name="PerformedProcedureStepDescription"				Type="3"
	Sequence="PerformedProtocolCodeSequence"				Type="3"	VM="1-n"
		InvokeMacro="CodeSequenceMacro"
		Sequence="ProtocolContextSequence"					Type="3"	VM="1-n"
			InvokeMacro="ContentItemMacro"
			Sequence="ContentItemModifierSequence"			Type="3"	VM="1-n"
				InvokeMacro="ContentItemMacro"
			SequenceEnd
		SequenceEnd
	SequenceEnd
	Name="CommentsOnThePerformedProcedureStep"				Type="3"
MacroEnd

DefineMacro="ExposureIndexMacro" InformationEntity="Frame"
	Name="ExposureIndex"									Type="3"	NotZeroWarning=""
	Name="TargetExposureIndex"								Type="3"	NotZeroWarning=""
	Name="DeviationIndex"									Type="3"	NotZeroWarning=""
MacroEnd

DefineMacro="MandatoryViewAndSliceProgressionDirectionMacro" InformationEntity="Frame"
	Sequence="ViewCodeSequence"								Type="1"	VM="1"
		InvokeMacro="CodeSequenceMacro"						BaselineContextID="26"
		Sequence="ViewModifierCodeSequence"					Type="2C"	VM="0-n"	NoCondition=""	# real-world - if needed to fully specify the view
			InvokeMacro="ContentItemMacro"					BaselineContextID="23"
		SequenceEnd
	SequenceEnd
	Name="SliceProgressionDirection"						Type="1C"	StringEnumValues="CardiacSliceProgressionDirection"	Condition="ViewIsCardiacShortOrLongAxis"	mbpo="true"
MacroEnd

DefineMacro="OptionalViewAndSliceProgressionDirectionMacro" InformationEntity="Frame"
	Sequence="ViewCodeSequence"								Type="3"	VM="1"
		InvokeMacro="CodeSequenceMacro"						BaselineContextID="26"
		Sequence="ViewModifierCodeSequence"					Type="3"	VM="1-n"
			InvokeMacro="ContentItemMacro"					BaselineContextID="23"
		SequenceEnd
	SequenceEnd
	Name="SliceProgressionDirection"						Type="3"	StringEnumValues="CardiacSliceProgressionDirection"
MacroEnd

DefineMacro="NumericValueMacro"
	Sequence="ConceptNameCodeSequence"						Type="1"	VM="1"
		InvokeMacro="CodeSequenceMacro"
	SequenceEnd
	Name="NumericValue"										Type="1"
	Sequence="MeasurementUnitsCodeSequence"					Type="1"	VM="1"
		InvokeMacro="CodeSequenceMacro"						BaselineContextID="82"
	SequenceEnd
MacroEnd

DefineMacro="AttributeValueConstraintMacro"
	InvokeMacro="ExtendedSelectorAttributeMacro"
	Name="ConstraintType"						Type="1"				StringEnumValues="AttributeValueConstraintType"
	Name="ConstraintViolationSignificance"		Type="3"				StringEnumValues="ConstraintViolationSignificance"
	Name="ConstraintViolationCondition"			Type="1C"				NoCondition=""
	Sequence="ConstraintValueSequence"			Type="1C"	VM="1-n"	Condition="ConstraintTypeNotUnconstrained"
		InvokeMacro="AttributeValueMacro"
	SequenceEnd
	Verify="ConstraintValueSequence"									Condition="ConstraintValueSequenceNotSingleItemWhenRequiredToBe"	ThenErrorMessage="Only a single Item is permitted for this ConstraintType"
	Verify="ConstraintValueSequence"									Condition="ConstraintValueSequenceNotTwoItemsWhenRequiredToBe"		ThenErrorMessage="Exactly two Items are required for this ConstraintType"
	Sequence="RecommendedDefaultValueSequence"	Type="3"	VM="1"
		InvokeMacro="AttributeValueMacro"
	SequenceEnd
	Sequence="MeasurementUnitsCodeSequence"		Type="3"	VM="1"
		InvokeMacro="CodeSequenceMacro"
	SequenceEnd
	Name="SpecificationSelectionGuidance"		Type="3"
MacroEnd

DefineMacro="AttributeValueMacro"
	Name="SelectorAEValue"						Type="1C"	Condition="SelectorAttributeVRIsAE"
	Name="SelectorASValue"						Type="1C"	Condition="SelectorAttributeVRIsAS"
	Name="SelectorATValue"						Type="1C"	Condition="SelectorAttributeVRIsAT"
	Name="SelectorCSValue"						Type="1C"	Condition="SelectorAttributeVRIsCS"
	Name="SelectorDAValue"						Type="1C"	Condition="SelectorAttributeVRIsDA"
	Name="SelectorDSValue"						Type="1C"	Condition="SelectorAttributeVRIsDS"
	Name="SelectorDTValue"						Type="1C"	Condition="SelectorAttributeVRIsDT"
	Name="SelectorFDValue"						Type="1C"	Condition="SelectorAttributeVRIsFD"
	Name="SelectorFLValue"						Type="1C"	Condition="SelectorAttributeVRIsFL"
	Name="SelectorISValue"						Type="1C"	Condition="SelectorAttributeVRIsIS"
	Name="SelectorLOValue"						Type="1C"	Condition="SelectorAttributeVRIsLO"
	Name="SelectorLTValue"						Type="1C"	Condition="SelectorAttributeVRIsLT"
	Name="SelectorOBValue"						Type="1C"	Condition="SelectorAttributeVRIsOB"
	Name="SelectorODValue"						Type="1C"	Condition="SelectorAttributeVRIsOD"
	Name="SelectorOFValue"						Type="1C"	Condition="SelectorAttributeVRIsOF"
	Name="SelectorOLValue"						Type="1C"	Condition="SelectorAttributeVRIsOL"
	Name="SelectorOVValue"						Type="1C"	Condition="SelectorAttributeVRIsOV"
	Name="SelectorOWValue"						Type="1C"	Condition="SelectorAttributeVRIsOW"
	Name="SelectorPNValue"						Type="1C"	Condition="SelectorAttributeVRIsPN"
	Name="SelectorSHValue"						Type="1C"	Condition="SelectorAttributeVRIsSH"
	Name="SelectorSLValue"						Type="1C"	Condition="SelectorAttributeVRIsSL"
	Name="SelectorSSValue"						Type="1C"	Condition="SelectorAttributeVRIsSS"
	Name="SelectorSTValue"						Type="1C"	Condition="SelectorAttributeVRIsST"
	Name="SelectorSVValue"						Type="1C"	Condition="SelectorAttributeVRIsSV"
	Name="SelectorTMValue"						Type="1C"	Condition="SelectorAttributeVRIsTM"
	Name="SelectorUCValue"						Type="1C"	Condition="SelectorAttributeVRIsUC"
	Name="SelectorUIValue"						Type="1C"	Condition="SelectorAttributeVRIsUI"
	Name="SelectorULValue"						Type="1C"	Condition="SelectorAttributeVRIsUL"
	Name="SelectorUNValue"						Type="1C"	Condition="SelectorAttributeVRIsUN"
	Name="SelectorURValue"						Type="1C"	Condition="SelectorAttributeVRIsUR"
	Name="SelectorUSValue"						Type="1C"	Condition="SelectorAttributeVRIsUS"
	Name="SelectorUTValue"						Type="1C"	Condition="SelectorAttributeVRIsUT"
	Name="SelectorUVValue"						Type="1C"	Condition="SelectorAttributeVRIsUV"
	Sequence="SelectorCodeSequenceValue"		Type="1C"	VM="1-n"	Condition="SelectorAttributeVRIsSQ"
		InvokeMacro="CodeSequenceMacro"
	SequenceEnd
MacroEnd

DefineMacro="ReferenceLocationMacro"
	Name="ReferenceLocationLabel"				Type="1"
	Name="ReferenceLocationDescription"			Type="3"
	Sequence="ReferenceBasisCodeSequence"		Type="1"	VM="1"
		InvokeMacro="CodeSequenceMacro"
	SequenceEnd
	Sequence="ReferenceGeometryCodeSequence"	Type="1"	VM="1"
		InvokeMacro="CodeSequenceMacro"
	SequenceEnd
	Name="OffsetDistance"						Type="3"
	Name="OffsetDirection"						Type="1C"	Condition="OffsetDistancePresent"	StringEnumValues="OffsetDirection"
MacroEnd

DefineMacro="ProtocolElementIdentificationMacro"
	Name="ProtocolElementNumber"					Type="1"	NotZeroError=""
	Name="ProtocolElementName"						Type="2"
	Name="ProtocolElementPurpose"					Type="3"
	Name="ProtocolElementCharacteristicsSummary"	Type="3"
MacroEnd

DefineMacro="PatientGroupMacro" InformationEntity="Patient"
	Sequence="SourcePatientGroupIdentificationSequence"		Type="3"	VM="1"
		Name="PatientID"									Type="1"
		InvokeMacro="IssuerOfPatientIDMacro"
	SequenceEnd
	Sequence="GroupOfPatientsIdentificationSequence"		Type="3"	VM="1-n"
		Name="PatientID"									Type="1"
		InvokeMacro="IssuerOfPatientIDMacro"
		Name="SubjectRelativePositionInImage"				Type="3"
		Name="PatientPosition"								Type="3"
	SequenceEnd
MacroEnd

DefineMacro="UDIMacro" InformationEntity="Equipment"
	Name="UniqueDeviceIdentifier"							Type="1"
	Name="DeviceDescription"								Type="3"
MacroEnd

DefineMacro="AssertionMacro"
	Sequence="AssertionCodeSequence"			Type="1"	VM="1"
		InvokeMacro="CodeSequenceMacro"
	SequenceEnd
	Name="AssertionUID"	Type="1"
	Sequence="AsserterIdentificationSequence"	Type="1"	VM="1"
		InvokeMacro="IdentifiedPersonOrDeviceMacro"
	SequenceEnd
	Name="AssertionDateTime"					Type="1"
	Name="AssertionExpirationDateTime"			Type="3"
	Name="AssertionComments"					Type="3"
	Sequence="PertinentDocumentsSequence"		Type="3"	VM="1"
		Name="ReferencedSOPClassUID"			Type="3"
		Name="ReferencedSOPInstanceUID"			Type="3"
		Name="HL7InstanceIdentifier"			Type="3"
		Name="RetrieveURI"						Type="3"
	SequenceEnd
	Sequence="RelatedAssertionSequence"			Type="3"	VM="1-n"
		Name="ReferencedAssertionUID"			Type="1"
	SequenceEnd
MacroEnd

DefineMacro="EntityLabelingMacro"
	Name="EntityLabel"							Type="1"
	Name="EntityName"							Type="3"
	Name="EntityDescription"					Type="3"
MacroEnd

DefineMacro="EntityLongLabelingMacro"
	Name="EntityLongLabel"						Type="1"
	Name="EntityDescription"					Type="3"
MacroEnd

DefineMacro="ConceptualVolumeMacro"
	Name="ConceptualVolumeUID"														Type="1"
	Sequence="OriginatingSOPInstanceReferenceSequence"								Type="1C"	VM="1"	NoCondition=""
		InvokeMacro="SOPInstanceReferenceMacro"
	SequenceEnd
	Sequence="EquivalentConceptualVolumesSequence"									Type="3"	VM="1-n"
		Name="ReferencedConceptualVolumeUID"										Type="1"
		Sequence="EquivalentConceptualVolumeInstanceReferenceSequence"				Type="1"	VM="1"
			InvokeMacro="SOPInstanceReferenceMacro"
		SequenceEnd
	SequenceEnd
	Sequence="DerivationConceptualVolumeSequence"									Type="3"	VM="1"
		Name="DerivationDescription"												Type="3"
		Sequence="SourceConceptualVolumeSequence"									Type="1"	VM="1-n"
			Name="SourceConceptualVolumeUID"										Type="1"
			Name="ConceptualVolumeConstituentIndex"									Type="1"			NotZeroError=""
			Sequence="ConceptualVolumeConstituentSegmentationReferenceSequence"		Type="2"	VM="0-1"
				Sequence="ReferencedDirectSegmentInstanceSequence"					Type="1"	VM="1"
					InvokeMacro="SOPInstanceReferenceMacro"
				SequenceEnd
				Name="ReferencedSegmentReferenceIndex"								Type="1"
			SequenceEnd
		SequenceEnd
		Sequence="ConceptualVolumeDerivationAlgorithmSequence"						Type="3"	VM="1-n"
			InvokeMacro="AlgorithmIdentificationMacro"
			SequenceEnd
	SequenceEnd
MacroEnd

DefineMacro="ConceptualVolumeSegmentationReferenceAndCombinationMacro"
	InvokeMacro="ConceptualVolumeMacro"
	Name="ConceptualVolumeCombinationFlag"											Type="1"			StringEnumValues="YesNoFull"
	Sequence="ConceptualVolumeConstituentSequence"									Type="1C"	VM="1"	Condition="IsConceptualVolumeCombination"
		Name="ConceptualVolumeConstituentIndex"										Type="1"
		Name="ConstituentConceptualVolumeUID"										Type="1"
		Sequence="OriginatingSOPInstanceReferenceSequence"							Type="1"	VM="1"
			InvokeMacro="SOPInstanceReferenceMacro"
		SequenceEnd
		Sequence="ConceptualVolumeConstituentSegmentationReferenceSequence"			Type="1C"	VM="1"	NoCondition=""
			Sequence="ReferencedDirectSegmentInstanceSequence"						Type="1"	VM="1"
				InvokeMacro="SOPInstanceReferenceMacro"
			SequenceEnd
			Name="ReferencedSegmentReferenceIndex"									Type="1"
		SequenceEnd
	SequenceEnd
	Name="ConceptualVolumeCombinationExpression"									Type="1C"			Condition="IsConceptualVolumeCombination"
	Name="ConceptualVolumeCombinationDescription"									Type="2C"			Condition="IsConceptualVolumeCombination"
	Name="ConceptualVolumeSegmentationDefinedFlag"									Type="1"			StringEnumValues="YesNoFull"
	Sequence="ConceptualVolumeSegmentationReferenceSequence"						Type="1C"	VM="1"	Condition="ConceptualVolumeSegmentationReferenceSequenceRequired"
		Sequence="ReferencedDirectSegmentInstanceSequence"							Type="1"	VM="1"
			InvokeMacro="SOPInstanceReferenceMacro"
		SequenceEnd
		Name="ReferencedSegmentReferenceIndex"										Type="1"
	SequenceEnd
MacroEnd

DefineMacro="DeviceModelMacro"
	Name="Manufacturer"										Type="2"
	Name="ManufacturerModelName"							Type="2"
	Name="ManufacturerModelVersion"							Type="2"
MacroEnd

DefineMacro="DeviceIdentificationMacro"
	Sequence="DeviceTypeCodeSequence"						Type="1"	VM="1"
		InvokeMacro="CodeSequenceMacro"
	SequenceEnd
	Name="DeviceLabel"										Type="1"
	Name="LongDeviceDescription"							Type="3"
	Name="DeviceSerialNumber"								Type="2"
	Name="SoftwareVersions"									Type="2"
	Name="DateOfManufacture"								Type="3"
	Name="DateOfInstallation"								Type="3"
	Sequence="UDISequence"									Type="3"	VM="1"
		InvokeMacro="UDIMacro"
	SequenceEnd
	Name="ManufacturerDeviceIdentifier"						Type="2"
	Name="DeviceAlternateIdentifier"						Type="2"
	Name="DeviceAlternateIdentifierType"					Type="1C"	Condition="DeviceAlternateIdentifierPresent"
	Name="DeviceAlternateIdentifierFormat"					Type="1C"	Condition="DeviceAlternateIdentifierPresent"
MacroEnd

DefineMacro="RelatedInformationEntitiesMacro"
	Sequence="PurposeOfReferenceCodeSequence"					Type="1"	VM="1"
	InvokeMacro="CodeSequenceMacro"
	SequenceEnd
	Sequence="ReferencedStudySequence"							Type="1"	VM="1-n"
		Name="StudyInstanceUID"									Type="1"
		Name="PertinentSOPClassesInStudy"						Type="3"
		Sequence="ReferencedSeriesSequence"						Type="3"	VM="1-n"
			Name="SeriesInstanceUID"							Type="1"
			Name="PertinentSOPClassesInSeries"					Type="3"
			Sequence="ReferencedImageSequence"					Type="3"	VM="1-n"
				InvokeMacro="ImageSOPInstanceReferenceMacro"
			SequenceEnd
			Sequence="ReferencedInstanceSequence"				Type="3"	VM="1-n"
				InvokeMacro="SOPInstanceReferenceMacro"
			SequenceEnd
		SequenceEnd
	SequenceEnd
MacroEnd

DefineMacro="OutlineDefinitionMacro"
	Name="OutlineShapeType"						Type="1"	StringEnumValues="OutlineShapeType"
	Name="OutlineLeftVerticalEdge"				Type="1C"	Condition="OutlineShapeTypeIsRectangular"
	Name="OutlineRightVerticalEdge"				Type="1C"	Condition="OutlineShapeTypeIsRectangular"
	Name="OutlineUpperHorizontalEdge"			Type="1C"	Condition="OutlineShapeTypeIsRectangular"
	Name="OutlineLowerHorizontalEdge"			Type="1C"	Condition="OutlineShapeTypeIsRectangular"
	Name="CenterOfCircularOutline"				Type="1C"	Condition="OutlineShapeTypeIsCircular"
	Name="DiameterOfCircularOutline"			Type="1C"	Condition="OutlineShapeTypeIsCircular"
	Name="NumberOfPolygonalVertices"			Type="1C"	Condition="OutlineShapeTypeIsPolygonal"
	Name="VerticesOfThePolygonalOutline"		Type="1C"	Condition="OutlineShapeTypeIsPolygonal"
MacroEnd

DefineMacro="PatientToEquipmentRelationshipMacro"
	Name="ImageToEquipmentMappingMatrix"					Type="1"
	Name="FrameOfReferenceTransformationComment"			Type="3"
	Sequence="PatientLocationCoordinatesSequence"			Type="2"	VM="0-n"
		Name="ThreeDPointCoordinates"						Type="1"
		Sequence="PatientLocationCoordinatesCodeSequence"	Type="1"	VM="1"-n
			InvokeMacro="CodeSequenceMacro"
		SequenceEnd
	SequenceEnd
	Sequence="PatientSupportPositionSequence"				Type="2"	VM="0-1"
		InvokeMacro="PatientSupportPositionMacro"
	SequenceEnd
MacroEnd

DefineMacro="PatientSupportPositionMacro"
	Name="PatientSupportPositionSpecificationMethod"			Type="1"				StringEnumValues="PatientSupportPositionSpecificationMethod"
	Sequence="PatientSupportPositionDeviceParameterSequence"	Type="1C"	VM="1-n"	Condition="PatientSupportPositionSpecificationMethodNotAbsent"
		Name="ReferencedDeviceIndex"							Type="1C"				Condition="PatientSupportPositionSpecificationMethodDeviceSpecific"
		Name="DeviceOrderIndex"									Type="1C"				Condition="PatientSupportPositionSpecificationMethodDeviceSpecific"NotZeroError=""
		Sequence="PatientSupportPositionParameterSequence"		Type="1"	VM="1-n"
			Name="PatientSupportPositionParameterOrderIndex"	Type="1C"				Condition="PatientSupportPositionSpecificationMethodDeviceSpecific"	NotZeroError=""
			InvokeMacro="ContentItemMacro"
		SequenceEnd
	SequenceEnd
	Verify="PatientSupportPositionDeviceParameterSequence"								Condition="PatientSupportPositionDeviceParameterSequenceNotSingleItemWhenRequiredToBe"	ThenErrorMessage="Only a single Item is permitted for this PatientSupportPositionSpecificationMethod"
MacroEnd

DefineMacro="GeneralProcedureProtocolReferenceMacro" InformationEntity="Image"
	Sequence="ReferencedDefinedProtocolSequence"				Type="1C"	VM="1-n"	NoCondition=""
		InvokeMacro="SOPInstanceReferenceMacro"
		Name="SourceAcquisitionProtocolElementNumber"			Type="3"
		Verify="SourceAcquisitionProtocolElementNumber"									Condition="SourceAcquisitionProtocolElementNumberAndSourceReconstructionProtocolElementNumberPresent"	ThenErrorMessage="Shall not be present when SourceReconstructionProtocolElementNumber is present"
		Name="SourceReconstructionProtocolElementNumber"		Type="3"
	SequenceEnd
	Sequence="ReferencedPerformedProtocolSequence"				Type="1C"	VM="1-n"	NoCondition=""
		InvokeMacro="SOPInstanceReferenceMacro"
		Name="SourceAcquisitionProtocolElementNumber"			Type="3"
		Verify="SourceAcquisitionProtocolElementNumber"									Condition="SourceAcquisitionProtocolElementNumberAndSourceReconstructionProtocolElementNumberPresent"	ThenErrorMessage="Shall not be present when SourceReconstructionProtocolElementNumber is present"
		Name="SourceReconstructionProtocolElementNumber"		Type="3"
	SequenceEnd
MacroEnd

Module="Patient"
	Name="PatientName"						Type="2"
	Name="PatientID"						Type="2"
	InvokeMacro="IssuerOfPatientIDMacro"
	Name="TypeOfPatientID"					Type="3"	StringDefinedTerms="TypeOfPatientID"
	Name="PatientBirthDate"					Type="2"
	Name="PatientBirthDateInAlternativeCalendar"	Type="3"
	Name="PatientDeathDateInAlternativeCalendar"	Type="3"
	Name="PatientAlternativeCalendar"				Type="1C"	Condition="PatientAlternativeCalendarNeeded"	StringDefinedTerms="PatientAlternativeCalendar"
	Name="PatientSex"						Type="2"	StringEnumValues="Sex"
	Sequence="ReferencedPatientPhotoSequence"	Type="3"	VM="1"
		InvokeMacro="ReferencedInstancesAndAccessMacro"
	SequenceEnd
	Name="QualityControlSubject"			Type="3"	StringEnumValues="YesNoFull"
	Sequence="ReferencedPatientSequence"	Type="3"	VM="1"
		InvokeMacro="SOPInstanceReferenceMacro"
	SequenceEnd
	Name="PatientBirthTime"					Type="3"
	Sequence="OtherPatientIDsSequence"		Type="3"	VM="1-n"
		Name="PatientID"					Type="1"
		InvokeMacro="IssuerOfPatientIDMacro"
		Name="TypeOfPatientID"				Type="1"	StringDefinedTerms="TypeOfPatientID"
	SequenceEnd
	Name="OtherPatientNames"				Type="3"
	Name="EthnicGroup"						Type="3"
	Sequence="EthnicGroupCodeSequence"		Type="3"	VM="1-n"
		InvokeMacro="CodeSequenceMacro"
	SequenceEnd
	Name="PatientComments"					Type="3"
	Name="PatientSpeciesDescription"		Type="1C"	Condition="IsAnimalAndPatientSpeciesCodeSequenceAbsent" mbpo="true"
	Sequence="PatientSpeciesCodeSequence"	Type="1C"	VM="1"	Condition="IsAnimalAndPatientSpeciesDescriptionAbsent" mbpo="true"
		InvokeMacro="CodeSequenceMacro"
	SequenceEnd
	Name="PatientBreedDescription"			Type="2C"	Condition="IsAnimalAndPatientBreedCodeSequenceEmpty" mbpo="true"
	Sequence="PatientBreedCodeSequence"		Type="2C"	VM="0-1"	Condition="IsAnimal"
		InvokeMacro="CodeSequenceMacro"
	SequenceEnd
	Sequence="BreedRegistrationSequence"	Type="2C"	VM="0-n"	Condition="IsAnimal"
		Name="BreedRegistrationNumber"		Type="1"
		Sequence="BreedRegistryCodeSequence"	Type="1"	VM="1"
			InvokeMacro="CodeSequenceMacro"
		SequenceEnd
	SequenceEnd
	Name="StrainDescription"						Type="3"
	Name="StrainNomenclature"						Type="3"
	Sequence="StrainCodeSequence"					Type="3"	VM="1-n"
		InvokeMacro="CodeSequenceMacro"
	SequenceEnd
	Name="StrainAdditionalInformation"				Type="3"
	Sequence="StrainStockSequence"					Type="3"	VM="1"
		Name="StrainStockNumber"					Type="1"
		Name="StrainSource"							Type="1"
		Sequence="StrainSourceRegistryCodeSequence"	Type="1"	VM="1"
			InvokeMacro="CodeSequenceMacro"
		SequenceEnd
	SequenceEnd
	Sequence="GeneticModificationsSequence"				Type="3"	VM="1"
		Name="GeneticModificationsDescription"			Type="1"
		Name="GeneticModificationsNomenclature"			Type="1"
		Sequence="GeneticModificationsCodeSequence"		Type="3"	VM="1"
			InvokeMacro="CodeSequenceMacro"
		SequenceEnd
	SequenceEnd
	Name="ResponsiblePerson"				Type="2C"	Condition="IsAnimal" mbpo="true"
	Name="ResponsiblePersonRole"			Type="1C"	Condition="ResponsiblePersonIsPresentWithValue"	StringDefinedTerms="ResponsiblePersonRole"
	Name="ResponsibleOrganization"			Type="2C"	Condition="IsAnimal" mbpo="true"
	Name="PatientIdentityRemoved"			Type="3"	StringEnumValues="YesNoFull"
	Name="DeidentificationMethod"					Type="1C"	Condition="PatientIdentityRemovedAndNotDeidentificationMethodCodeSequence" mbpo="true"
	Sequence="DeidentificationMethodCodeSequence"	Type="1C"	VM="1-n"	Condition="PatientIdentityRemovedAndNotDeidentificationMethod" mbpo="true"
		InvokeMacro="CodeSequenceMacro"					DefinedContextID="7050"
	SequenceEnd
	InvokeMacro="PatientGroupMacro"
ModuleEnd

Module="ClinicalTrialSubject"
	Name="ClinicalTrialSponsorName"			Type="1"
	Name="ClinicalTrialProtocolID"			Type="1"
	Name="IssuerOfClinicalTrialProtocolID"	Type="3"
	Sequence="OtherClinicalTrialProtocolIDsSequence"	Type="3"	VM="1-n"
		Name="ClinicalTrialProtocolID"			Type="1"
		Name="IssuerOfClinicalTrialProtocolID"	Type="1"
	SequenceEnd
	Name="ClinicalTrialProtocolName"		Type="2"
	Name="ClinicalTrialSiteID"				Type="2"
	Name="IssuerOfClinicalTrialSiteID"		Type="3"
	Name="ClinicalTrialSiteName"			Type="2"
	Name="ClinicalTrialSubjectID"			Type="1C"	Condition="ClinicalTrialSubjectReadingIDAbsent" mbpo="true"
	Name="IssuerOfClinicalTrialSubjectID"	Type="3"
	Name="ClinicalTrialSubjectReadingID"	Type="1C"	Condition="ClinicalTrialSubjectIDAbsent" mbpo="true"
	Name="IssuerOfClinicalTrialSubjectReadingID"	Type="3"
	Name="ClinicalTrialProtocolEthicsCommitteeName"	Type="1C"	Condition="ClinicalTrialProtocolEthicsCommitteeApprovalNumberIsPresent"
	Name="ClinicalTrialProtocolEthicsCommitteeApprovalNumber"	Type="3"
ModuleEnd

Module="GeneralStudy"
	Name="StudyInstanceUID"									Type="1"
	Name="StudyDate"										Type="2"
	Name="StudyTime"										Type="2"
	Name="ReferringPhysicianName"							Type="2"
	Sequence="ReferringPhysicianIdentificationSequence"		Type="3"	VM="1"
		InvokeMacro="PersonIdentificationMacro"
	SequenceEnd
	Name="ConsultingPhysicianName"							Type="3"
	Sequence="ConsultingPhysicianIdentificationSequence"	Type="3"	VM="1-n"
		InvokeMacro="PersonIdentificationMacro"
	SequenceEnd
	Name="StudyID"											Type="2"
	Name="AccessionNumber"									Type="2"
	Sequence="IssuerOfAccessionNumberSequence"				Type="3"	VM="1"
		InvokeMacro="HL7v2HierarchicDesignatorMacro"
	SequenceEnd
	Name="StudyDescription"									Type="3"
	Name="PhysiciansOfRecord"								Type="3"
	Sequence="PhysiciansOfRecordIdentificationSequence"		Type="3"	VM="1-n"
		InvokeMacro="PersonIdentificationMacro"
	SequenceEnd
	Name="NameOfPhysiciansReadingStudy"						Type="3"
	Sequence="PhysiciansReadingStudyIdentificationSequence"	Type="3"	VM="1-n"
		InvokeMacro="PersonIdentificationMacro"
	SequenceEnd
	Sequence="RequestingServiceCodeSequence"				Type="3"	VM="1"
		InvokeMacro="CodeSequenceMacro"						DefinedContextID="7030"
	SequenceEnd
	Sequence="ReferencedStudySequence"						Type="3"	VM="1-n"
		InvokeMacro="SOPInstanceReferenceMacro"
	SequenceEnd
	Sequence="ProcedureCodeSequence"						Type="3"	VM="1-n"
		InvokeMacro="CodeSequenceMacro"
	SequenceEnd
	Sequence="ReasonForPerformedProcedureCodeSequence"		Type="3"	VM="1-n"
		InvokeMacro="CodeSequenceMacro"
	SequenceEnd
ModuleEnd

Module="PatientStudy"
	Name="AdmittingDiagnosesDescription"		Type="3"
	Sequence="AdmittingDiagnosesCodeSequence"	Type="3"	VM="1-n"
		InvokeMacro="CodeSequenceMacro"
	SequenceEnd
	Name="PatientAge"							Type="3"
	Name="PatientSize"							Type="3"	NotZeroWarning=""
	Name="PatientWeight"						Type="3"	NotZeroWarning=""
	Name="PatientBodyMassIndex"					Type="3"	NotZeroWarning=""
	Name="MeasuredAPDimension"					Type="3"	NotZeroWarning=""
	Name="MeasuredLateralDimension"				Type="3"	NotZeroWarning=""
	Sequence="PatientSizeCodeSequence"			Type="3"	VM="1-n"
		InvokeMacro="CodeSequenceMacro"
	SequenceEnd
	Name="MedicalAlerts"						Type="3"
	Name="Allergies"							Type="3"
	Name="SmokingStatus"						Type="3"	StringEnumValues="SmokingStatus"
	Name="PregnancyStatus"						Type="3"	BinaryEnumValues="PregnancyStatus"
	Name="LastMenstrualDate"					Type="3"
	Name="PatientState"							Type="3"
	Name="Occupation"							Type="3"
	Name="AdditionalPatientHistory"				Type="3"
	Name="AdmissionID"							Type="3"
	Name="IssuerOfAdmissionID"					Type="3"
	Sequence="IssuerOfAdmissionIDSequence"		Type="3"	VM="1"
		InvokeMacro="HL7v2HierarchicDesignatorMacro"
	SequenceEnd
	Name="ReasonForVisit"						Type="3"
	Sequence="ReasonForVisitCodeSequence"		Type="3"	VM="1-n"
		InvokeMacro="CodeSequenceMacro"
	SequenceEnd
	Name="ServiceEpisodeID"						Type="3"
	Sequence="IssuerOfServiceEpisodeIDSequence"	Type="3"	VM="1"
		InvokeMacro="HL7v2HierarchicDesignatorMacro"
	SequenceEnd
	Name="ServiceEpisodeDescription"			Type="3"
	Name="PatientSexNeutered"					Type="2C"	Condition="IsAnimal"	StringEnumValues="PatientSexNeutered" mbpo="true"
ModuleEnd

Module="ClinicalTrialStudy"
	Name="ClinicalTrialTimePointID"					Type="2"
	Name="IssuerOfClinicalTrialTimePointID"			Type="3"
	Name="ClinicalTrialTimePointDescription"		Type="3"
	Sequence="ClinicalTrialTimePointTypeCodeSequence"	Type="3"	VM="1-n"
		InvokeMacro="CodeSequenceMacro"
	SequenceEnd
	Name="LongitudinalTemporalOffsetFromEvent"		Type="3"
	Name="LongitudinalTemporalEventType"			Type="1C"	Condition="LongitudinalTemporalOffsetFromEventIsPresent"	StringDefinedTerms="LongitudinalTemporalEventType"
	Sequence="ConsentForClinicalTrialUseSequence"	Type="3"	VM="1-n"
		Name="DistributionType"						Type="1C"	Condition="ConsentForDistributionFlagIsYesOrWithdrawn"	StringEnumValues="DistributionType"
		Name="ClinicalTrialProtocolID"				Type="1C"	NoCondition=""
		Name="IssuerOfClinicalTrialProtocolID"		Type="3"
		Verify="ClinicalTrialProtocolID"						Condition="DistributionTypeIsNotNamedProtocol"		ThenErrorMessage="Only permitted when DistributionType is NAMED_PROTOCOL"
		Name="ConsentForDistributionFlag"			Type="1"	StringEnumValues="ConsentForDistributionFlag"
	SequenceEnd
ModuleEnd

Module="GeneralSeries"
	Name="Modality"											Type="1C"	Condition="NotSecondaryCaptureSOPClass" mbpo="true"
	Verify="Modality"													StringDefinedTerms="Modality"
	Name="SeriesInstanceUID"								Type="1"
	Name="SeriesNumber"										Type="2"
	Name="Laterality"										Type="2C"	Condition="LateralityRequired"	StringEnumValues="Laterality"
	Verify="Laterality"													Condition="LateralityHasNoValue"	ThenWarningMessage="is only permitted to be empty when actually unknown; should be absent (not empty) if an unpaired body part, and have a value if a paired body part"
	Name="SeriesDate"										Type="3"
	Name="SeriesTime"										Type="3"
	Name="PerformingPhysicianName"							Type="3"
	Sequence="PerformingPhysicianIdentificationSequence"	Type="3"	VM="1-n"
		InvokeMacro="PersonIdentificationMacro"
	SequenceEnd
	Name="ProtocolName"										Type="3"
	Name="SeriesDescription"								Type="3"
	Sequence="SeriesDescriptionCodeSequence"				Type="3"	VM="1"
		InvokeMacro="CodeSequenceMacro"
	SequenceEnd
	Name="OperatorsName"									Type="3"
	Sequence="OperatorIdentificationSequence"				Type="3"	VM="1-n"
		InvokeMacro="PersonIdentificationMacro"
	SequenceEnd
	Sequence="ReferencedPerformedProcedureStepSequence"		Type="3"	VM="1"
		InvokeMacro="SOPInstanceReferenceMacro"
	SequenceEnd
	Sequence="RelatedSeriesSequence"						Type="3"	VM="1-n"
		Name="StudyInstanceUID"								Type="1"
		Name="SeriesInstanceUID"							Type="1"
		Sequence="PurposeOfReferenceCodeSequence"			Type="2"	VM="0-n"
			InvokeMacro="CodeSequenceMacro"
		SequenceEnd
	SequenceEnd
	Name="BodyPartExamined"									Type="3"
	Verify="BodyPartExamined"											Condition="IsHuman"		StringDefinedTerms="BodyPartExaminedHuman"
	Verify="BodyPartExamined"											Condition="IsAnimal"	StringDefinedTerms="BodyPartExaminedAnimal"
	Name="PatientPosition"									Type="2C"	StringDefinedTerms="PatientPosition"	Condition="SOPClassIsCTOrMR" mbpo="true"
	Verify="PatientPosition"											Condition="PatientPositionAndPatientOrientationCodeSequencePresent"	ThenErrorMessage="Shall not be present when PatientOrientationCodeSequence is present"
	Name="SmallestPixelValueInSeries"						Type="3"
	Name="LargestPixelValueInSeries"						Type="3"
	Sequence="RequestAttributesSequence"					Type="3"	VM="1-n"
		InvokeMacro="RequestAttributesMacro"
	SequenceEnd
	InvokeMacro="PerformedProcedureStepSummaryMacro"
	Name="AnatomicalOrientationType"						Type="1C"	NoCondition=""	StringEnumValues="AnatomicalOrientationType"
ModuleEnd

Module="ClinicalTrialSeries"
	Name="ClinicalTrialCoordinatingCenterName"				Type="2"
	Name="ClinicalTrialSeriesID"							Type="3"
	Name="IssuerOfClinicalTrialSeriesID"					Type="3"
	Name="ClinicalTrialSeriesDescription"					Type="3"
ModuleEnd

Module="EnhancedSeries"
	Name="SeriesNumber"										Type="1"
	Sequence="ReferencedPerformedProcedureStepSequence"		Type="1C"	VM="1"	Condition="SeriesNeedReferencedPerformedProcedureStepSequence"
		InvokeMacro="SOPInstanceReferenceMacro"
	SequenceEnd
ModuleEnd

Module="FrameOfReference"
	Name="FrameOfReferenceUID"								Type="1"
	Name="PositionReferenceIndicator"						Type="2"
	Verify="PositionReferenceIndicator"									Condition="PositionReferenceIndicatorNotSlideCornerForSlide"	ThenErrorMessage="Required to be SLIDE_CORNER for slide-related Frame of Reference"
ModuleEnd

Module="GeneralEquipment"
	Name="Manufacturer"										Type="2"
	Name="InstitutionName"									Type="3"
	Name="InstitutionAddress"								Type="3"
	Name="StationName"										Type="3"
	Name="InstitutionalDepartmentName"						Type="3"
	Sequence="InstitutionalDepartmentTypeCodeSequence"		Type="3"	VM="1"
		InvokeMacro="CodeSequenceMacro"									BaselineContextID="7030"
	SequenceEnd
	Name="ManufacturerModelName"							Type="3"
	Name="ManufacturerDeviceClassUID"						Type="3"
	Name="DeviceSerialNumber"								Type="3"
	Name="SoftwareVersions"									Type="3"
	Name="GantryID"											Type="3"
	Sequence="UDISequence"									Type="3"	VM="1-n"
		InvokeMacro="UDIMacro"
	SequenceEnd
	Name="DeviceUID"										Type="3"
	Name="SpatialResolution"								Type="3"
	Name="DateOfManufacture"								Type="3"
	Name="DateOfInstallation"								Type="3"
	Name="DateOfLastCalibration"							Type="3"
	Name="TimeOfLastCalibration"							Type="3"
	Name="PixelPaddingValue"								Type="1C"	Condition="PixelPaddingRangeLimitIsPresent" mbpo="true"
	Verify="PixelPaddingValue"											Condition="PixelPaddingValueIsPresentAndInstanceIsNotAnImage"	ThenErrorMessage="Shall not be present when not an integer pixel data image"
ModuleEnd

Module="EnhancedGeneralEquipment"
	Name="Manufacturer"										Type="1"
	Name="ManufacturerModelName"							Type="1"
	Name="DeviceSerialNumber"								Type="1"
	Name="SoftwareVersions"									Type="1"
ModuleEnd

Module="GeneralReference"
	Sequence="ReferencedImageSequence"						Type="3"	VM="1-n"
		InvokeMacro="ImageSOPInstanceReferenceMacro"
		Sequence="PurposeOfReferenceCodeSequence"			Type="3"	VM="1"
			InvokeMacro="CodeSequenceMacro"
		SequenceEnd
	SequenceEnd
	Sequence="ReferencedInstanceSequence"					Type="3"	VM="1-n"
		InvokeMacro="SOPInstanceReferenceMacro"
		Sequence="PurposeOfReferenceCodeSequence"			Type="1"	VM="1"
 			InvokeMacro="CodeSequenceMacro"
		SequenceEnd
	SequenceEnd
	Name="DerivationDescription"							Type="3"
	Sequence="DerivationCodeSequence"						Type="3"	VM="1-n"
		InvokeMacro="CodeSequenceMacro"
	SequenceEnd
	Sequence="SourceImageSequence"							Type="3"	VM="1-n"
		InvokeMacro="ImageSOPInstanceReferenceMacro"
		Sequence="PurposeOfReferenceCodeSequence"			Type="3"	VM="1"
			InvokeMacro="CodeSequenceMacro"
		SequenceEnd
		Name="SpatialLocationsPreserved"					Type="3"	StringEnumValues="YesNoReorientedOnly"
		Name="PatientOrientation"							Type="1C"	Condition="SpatialLocationsPreservedReorientedOnly"
	SequenceEnd
	Sequence="SourceInstanceSequence"						Type="3"	VM="1-n"	NoCondition=""
		InvokeMacro="SOPInstanceReferenceMacro"
		Sequence="PurposeOfReferenceCodeSequence"			Type="3"	VM="1"
			InvokeMacro="CodeSequenceMacro"
		SequenceEnd
	SequenceEnd
ModuleEnd

Module="GeneralAcquisition"
	Name="AcquisitionUID"									Type="3"
	Name="AcquisitionNumber"								Type="3"
	Name="AcquisitionDate"									Type="3"
	Name="AcquisitionTime"									Type="3"
	Name="AcquisitionDateTime"								Type="3"
	Name="ImagesInAcquisition"								Type="3"
	Name="IrradiationEventUID"								Type="3"
ModuleEnd

Module="GeneralImage"
	Name="InstanceNumber"									Type="2"
	Name="PatientOrientation"								Type="2C"	Condition="PatientOrientationRequired" mbpo="true"
	# ImageDate and ImageTime real-world condition "images are temporally related"
	Name="ContentDate"										Type="2C"	NoCondition=""	# "if temporally related" ... real world
	Name="ContentTime"										Type="2C"	NoCondition=""	# "if temporally related" ... real world
	Name="ImageType"										Type="3"	ValueSelector="0"	StringEnumValues="ImageType1"
	Verify="ImageType"										Type="3"	ValueSelector="1"	StringEnumValues="ImageType2"
	Name="ImageComments"									Type="3"
	Name="QualityControlImage"								Type="3"	StringEnumValues="YesNoFull"
	Name="BurnedInAnnotation"								Type="3"	StringEnumValues="YesNoFull"
	Name="RecognizableVisualFeatures"						Type="3"	StringEnumValues="YesNoFull"
	Name="LossyImageCompression"							Type="3"	StringEnumValues="LossyImageCompression"
	Name="LossyImageCompressionRatio"						Type="3"
	Name="LossyImageCompressionMethod"						Type="3"	StringDefinedTerms="LossyImageCompressionMethod"
	Verify="LossyImageCompressionMethod"								Condition="LossyImageCompressionMethodInconsistentWithTransferSyntax"	ThenWarningMessage="method inconsistent with Transfer Syntax" ShowValueWithMessage="true"
	Sequence="IconImageSequence"							Type="3"	VM="1"
		InvokeMacro="IconImageSequenceMacro"
	SequenceEnd
	Name="PresentationLUTShape"								Type="3"	StringEnumValues="SoftcopyPresentationLUTShape"
	Verify="PresentationLUTShape"							Condition="PhotometricInterpretationIsMonochrome1"			StringEnumValues="InversePresentationLUTShape"
	Verify="PresentationLUTShape"							Condition="PhotometricInterpretationIsMonochrome2"			StringEnumValues="IdentityPresentationLUTShape"
	Verify="PresentationLUTShape"							Condition="PhotometricInterpretationIsColor"				StringEnumValues="IdentityPresentationLUTShape"
	# multienergy condition for RWVM is from IOD not module
	Sequence="RealWorldValueMappingSequence"				Type="1C"	VM="1-n"	Condition="IsMultienergyCTAcquisition"	mbpo="true"
		InvokeMacro="RealWorldValueMappingItemMacro"
	SequenceEnd
	Name="ImageLaterality"									Type="3"	StringEnumValues="ImageLaterality"
	# do not literally invoke GeneralAnatomyOptionalMacro per CP 1744, because Type 3 conflicts with Type 2 in DX so consider the latter overriding, despite cancellation of CP 1885, else would report error missing items for valid DX Type 2 usage :(
	Sequence="AnatomicRegionSequence"						Type="2C"	VM="0-1"	Condition="NeedAnatomicRegionSequenceInGeneralImageModule"	mbpo="true"
		InvokeMacro="CodeSequenceMacro"
		Sequence="AnatomicRegionModifierSequence"			Type="3"	VM="1-n"
			InvokeMacro="CodeSequenceMacro"	BaselineContextID="2"
		SequenceEnd
	SequenceEnd
	# do verify that if it is not overridden, an item should be present, i.e., Type 3 not Type 2 semantics (may produce redundant messages with more specific modules that invoke Type 3 or Type 1 usage)
	Verify="AnatomicRegionSequence"													Condition="AnatomicRegionSequencePresentButNotOneItemAndNotOverriddenType2"	ThenErrorMessage="A single Item is required if present and not a Digital X-Ray family image"
	InvokeMacro="PrimaryAnatomicStructureMacro"
	Sequence="AnatomicRegionModifierSequence"				Type="1C"	VM="1-n"	Condition="Never"
	SequenceEnd
	Sequence="PrimaryAnatomicStructureModifierSequence"		Type="1C"	VM="1-n"	Condition="Never"
	SequenceEnd
ModuleEnd

Module="ImagePlane"
	Name="PixelSpacing"										Type="1"	NotZeroError=""
	Name="ImageOrientationPatient"							Type="1"
	Name="ImagePositionPatient"								Type="1"
	Name="SliceThickness"									Type="2"	NotZeroError=""
	Name="SpacingBetweenSlices"								Type="3"
	Verify="SpacingBetweenSlices"										Condition="SpacingBetweenSlicesIsNegativeAndNotNM"	ThenErrorMessage="Not permitted to be negative" ShowValueWithMessage="true"
	Name="SliceLocation"									Type="3"
ModuleEnd

DefineMacro="ImagePixelDescriptionMacro" InformationEntity="Instance"
	Name="SamplesPerPixel"							Type="1"
	Verify="SamplesPerPixel"						Condition="PhotometricInterpretationNeedsOneSample"	BinaryEnumValues="One"
	Verify="SamplesPerPixel"						Condition="PhotometricInterpretationNeedsThreeSamples"	BinaryEnumValues="Three"
	Verify="SamplesPerPixel"						Condition="MPEG2TransferSyntaxAndNotThreeSamples"		ThenErrorMessage="May only be 3 for MPEG Transfer Syntax"
	
	Name="PhotometricInterpretation"				Type="1"	StringDefinedTerms="PhotometricInterpretation"
	#PS3.5 constraints only - others checked with IOD-specific modules
	Verify="PhotometricInterpretation"				Condition="JPEGLossyTransferSyntaxAndOneSample"							StringEnumValues="PhotometricInterpretationMonochrome"
	Verify="PhotometricInterpretation"				Condition="JPEGLossyTransferSyntaxAndThreeSamples"						StringEnumValues="PhotometricInterpretationYBRFull422OrRGB"

	Verify="PhotometricInterpretation"				Condition="JPEGLosslessTransferSyntaxAndOneSample"						StringEnumValues="PhotometricInterpretationMonochromeOrPaletteColor"
	Verify="PhotometricInterpretation"				Condition="JPEGLosslessTransferSyntaxAndThreeSamples"					StringEnumValues="PhotometricInterpretationYBRFullOrRGB"

	Verify="PhotometricInterpretation"				Condition="JPEGLSLosslessTransferSyntaxAndOneSample"					StringEnumValues="PhotometricInterpretationMonochromeOrPaletteColor"
	Verify="PhotometricInterpretation"				Condition="JPEGLSLosslessTransferSyntaxAndThreeSamples"					StringEnumValues="PhotometricInterpretationYBRFullOrRGB"

	Verify="PhotometricInterpretation"				Condition="JPEGLSNearLosslessTransferSyntaxAndOneSample"				StringEnumValues="PhotometricInterpretationMonochrome"
	Verify="PhotometricInterpretation"				Condition="JPEGLSNearLosslessTransferSyntaxAndThreeSamples"				StringEnumValues="PhotometricInterpretationYBRFullOrRGB"

	Verify="PhotometricInterpretation"				Condition="JPEG2000LosslessTransferSyntaxAndOneSample"					StringEnumValues="PhotometricInterpretationMonochromeOrPaletteColor"
	Verify="PhotometricInterpretation"				Condition="JPEG2000LosslessTransferSyntaxAndThreeSamples"				StringEnumValues="PhotometricInterpretationYBRFullOrRGBOrYBR_RCT"

	Verify="PhotometricInterpretation"				Condition="JPEG2000TransferSyntaxAndOneSample"							StringEnumValues="PhotometricInterpretationMonochrome"
	Verify="PhotometricInterpretation"				Condition="JPEG2000TransferSyntaxAndThreeSamples"						StringEnumValues="PhotometricInterpretationYBRFullOrRGBOrYBR_RCTOrYBR_ICT"

	Verify="PhotometricInterpretation"				Condition="MPEG2TransferSyntax"											StringEnumValues="PhotometricInterpretationYBRPartial420"	# regardless of number of samples (required to be 3 by PS 3.5)

	Verify="PhotometricInterpretation"				Condition="RLETransferSyntaxAndOneSample"								StringEnumValues="PhotometricInterpretationMonochromeOrPaletteColor"
	Verify="PhotometricInterpretation"				Condition="RLETransferSyntaxAndThreeSamples"							StringEnumValues="PhotometricInterpretationYBRFullOrRGB"

	Verify="PhotometricInterpretation"				Condition="UncompressedTransferSyntaxAndThreeSamples"					StringEnumValues="PhotometricInterpretationYBRFullOrRGBOrYBR_RCTOrYBR_ICT"
	
	Name="Rows"										Type="1"	NotZeroError=""
	Verify="Rows"									Condition="MPEG2MPMLTransferSyntaxAndRowsGreaterThan480NTSCOr576PAL"	ThenErrorMessage="Must be <= 480 (NTSC) or 576 (PAL) for MPEG MP@MLTransfer Syntax"
	Verify="Rows"									Condition="MPEG2MPHLTransferSyntaxAndRowsNot720Or1080"					ThenErrorMessage="Must be 720 or 1080 for MPEG MP@HLTransfer Syntax"
	
	Name="Columns"									Type="1"	NotZeroError=""
	Verify="Columns"								Condition="MPEG2MPMLTransferSyntaxAndColumnsGreaterThan720"				ThenErrorMessage="Must be <= 720 for MPEG MP@MLTransfer Syntax"
	Verify="Columns"								Condition="MPEG2MPHLTransferSyntaxAndColumnsNot1280Or1920"				ThenErrorMessage="Must be 1280 or 1920 for MPEG MP@HLTransfer Syntax"
	Verify="Columns"								Condition="MPEG2MPHLTransferSyntaxAndColumnsInconsistentWithRows"		ThenErrorMessage="Must be 1280 when 720 Rows, or 1920 when 1080 Rows, for MPEG MP@HLTransfer Syntax"
	
	Name="BitsAllocated"							Type="1"	NotZeroError=""
	Verify="BitsAllocated"							Condition="MPEG2TransferSyntaxAndNotBitsAllocated8"		ThenErrorMessage="May only be 8 for MPEG Transfer Syntax"
	
	Name="BitsStored"								Type="1"	NotZeroError=""
	Verify="BitsStored"								Condition="MPEG2TransferSyntaxAndNotBitsStored8"		ThenErrorMessage="May only be 8 for MPEG Transfer Syntax"
	
	Name="HighBit"									Type="1"
	Verify="HighBit"								Condition="MPEG2TransferSyntaxAndNotHighBit7"		ThenErrorMessage="May only be 7 for MPEG Transfer Syntax"
	
	Name="PixelRepresentation"						Type="1"	BinaryEnumValues="PixelRepresentation"
	Verify="PixelRepresentation"					Condition="MPEG2TransferSyntaxAndNotPixelRepresentation0"		ThenErrorMessage="May only be 0 for MPEG Transfer Syntax"
	
	Name="PlanarConfiguration"						Type="1C"	BinaryEnumValues="PlanarConfiguration"	Condition="SamplesPerPixelGreaterThanOne"
	Verify="PlanarConfiguration"					Condition="MPEG2TransferSyntaxAndNotPlanarConfiguration0"		ThenErrorMessage="May only be 0 for MPEG Transfer Syntax"
	
	# PixelAspectRatio required if the image plane module not applicable and the aspect ratio is not 1:1
	Name="PixelAspectRatio"							Type="1C"	NoCondition=""	# "if ! image plane module present && not 1:1" ... too hard for now :(
	Verify="PixelAspectRatio"									Condition="UnwantedPixelAspectRatioWhenPixelSpacingPresent"					ThenErrorMessage="Shall not be present when PixelSpacing is present"
	Verify="PixelAspectRatio"									Condition="UnwantedPixelAspectRatioWhenImagerPixelSpacingPresent"			ThenErrorMessage="Shall not be present when ImagerPixelSpacing is present"
	Verify="PixelAspectRatio"									Condition="UnwantedPixelAspectRatioWhenNominalScannedPixelSpacingPresent"	ThenErrorMessage="Shall not be present when NominalScannedPixelSpacing is present"
	Verify="PixelAspectRatio"									Condition="UnwantedPixelAspectRatioWhenSharedPixelMeasuresMacro"			ThenErrorMessage="Shall not be present when PixelMeasuresSequence is present"
	Verify="PixelAspectRatio"									Condition="UnwantedPixelAspectRatioWhenPerFramePixelMeasuresMacro"			ThenErrorMessage="Shall not be present when PixelMeasuresSequence is present"
	Verify="PixelAspectRatio"									Condition="UnwantedPixelAspectRatioWhenMPEG2MPHLTransferSyntax"				ThenErrorMessage="Shall not be present for MPEG MP@HLTransfer Syntax"
	Name="SmallestImagePixelValue"					Type="3"
	Name="LargestImagePixelValue"					Type="3"
	Name="RedPaletteColorLookupTableDescriptor"	Type="1C"	Condition="ImagePixelMacroNeedsPaletteDescriptor"
	Verify="RedPaletteColorLookupTableDescriptor"			ValueSelector="2"	BinaryEnumValues="BitsAre8Or16"
	Name="GreenPaletteColorLookupTableDescriptor"	Type="1C"	Condition="ImagePixelMacroNeedsPaletteDescriptor"
	Verify="GreenPaletteColorLookupTableDescriptor"			ValueSelector="2"	BinaryEnumValues="BitsAre8Or16"
	Name="BluePaletteColorLookupTableDescriptor"	Type="1C"	Condition="ImagePixelMacroNeedsPaletteDescriptor"
	Verify="BluePaletteColorLookupTableDescriptor"			ValueSelector="2"	BinaryEnumValues="BitsAre8Or16"
	Name="RedPaletteColorLookupTableData"			Type="1C"	Condition="ImagePixelMacroNeedsPaletteDescriptorAndNotSegmentedLegallyPresentInPaletteColorModule"
	Name="GreenPaletteColorLookupTableData"			Type="1C"	Condition="ImagePixelMacroNeedsPaletteDescriptorAndNotSegmentedLegallyPresentInPaletteColorModule"
	Name="BluePaletteColorLookupTableData"			Type="1C"	Condition="ImagePixelMacroNeedsPaletteDescriptorAndNotSegmentedLegallyPresentInPaletteColorModule"
	Name="ICCProfile"								Type="3"
	Name="ColorSpace"								Type="3"
MacroEnd

DefineMacro="ImagePixelMacro" InformationEntity="Instance"
	InvokeMacro="ImagePixelDescriptionMacro"
	Name="PixelData"								Type="1"
MacroEnd

Module="FloatingPointImagePixel"
	Name="SamplesPerPixel"							Type="1"	BinaryEnumValues="One"
	Name="PhotometricInterpretation"				Type="1"	StringEnumValues="PhotometricInterpretationMonochrome2"
	Name="Rows"										Type="1"	NotZeroError=""
	Name="Columns"									Type="1"	NotZeroError=""
	Name="BitsAllocated"							Type="1"	BinaryEnumValues="BitsAre32"
	Verify="BitsStored"								Condition="BitsStoredPresent"			ThenErrorMessage="Shall not be present for FloatPixelData"
	Verify="HighBit"								Condition="HighBitPresent"				ThenErrorMessage="Shall not be present for FloatPixelData"
	Verify="PixelRepresentation"					Condition="PixelRepresentationPresent"	ThenErrorMessage="Shall not be present for FloatPixelData"
	Verify="PlanarConfiguration"					Condition="PlanarConfigurationPresent"	ThenErrorMessage="Shall not be present for FloatPixelData"

	Name="FloatPixelData"							Type="1"

	# PixelAspectRatio required if the image plane module not applicable and the aspect ratio is not 1:1
	Name="PixelAspectRatio"							Type="1C"	NoCondition=""	# "if ! image plane module present && not 1:1" ... too hard for now :(
	Verify="PixelAspectRatio"									Condition="UnwantedPixelAspectRatioWhenPixelSpacingPresent"					ThenErrorMessage="Shall not be present when PixelSpacing is present"
	Verify="PixelAspectRatio"									Condition="UnwantedPixelAspectRatioWhenImagerPixelSpacingPresent"			ThenErrorMessage="Shall not be present when ImagerPixelSpacing is present"
	Verify="PixelAspectRatio"									Condition="UnwantedPixelAspectRatioWhenNominalScannedPixelSpacingPresent"	ThenErrorMessage="Shall not be present when NominalScannedPixelSpacing is present"
	Verify="PixelAspectRatio"									Condition="UnwantedPixelAspectRatioWhenSharedPixelMeasuresMacro"			ThenErrorMessage="Shall not be present when PixelMeasuresSequence is present"
	Verify="PixelAspectRatio"									Condition="UnwantedPixelAspectRatioWhenPerFramePixelMeasuresMacro"			ThenErrorMessage="Shall not be present when PixelMeasuresSequence is present"
	Verify="PixelAspectRatio"									Condition="UnwantedPixelAspectRatioWhenMPEG2MPHLTransferSyntax"				ThenErrorMessage="Shall not be present for MPEG MP@HLTransfer Syntax"

	Name="FloatPixelPaddingValue"					Type="3"
	Name="FloatPixelPaddingRangeLimit"				Type="1C"	Condition="FloatPixelPaddingValuePresent"
ModuleEnd

Module="DoubleFloatingPointImagePixel"
	Name="SamplesPerPixel"							Type="1"	BinaryEnumValues="One"
	Name="PhotometricInterpretation"				Type="1"	StringEnumValues="PhotometricInterpretationMonochrome2"
	Name="Rows"										Type="1"	NotZeroError=""
	Name="Columns"									Type="1"	NotZeroError=""
	Name="BitsAllocated"							Type="1"	BinaryEnumValues="BitsAre64"
	Verify="BitsStored"								Condition="BitsStoredPresent"			ThenErrorMessage="Shall not be present for DoubleFloatPixelData"
	Verify="HighBit"								Condition="HighBitPresent"				ThenErrorMessage="Shall not be present for DoubleFloatPixelData"
	Verify="PixelRepresentation"					Condition="PixelRepresentationPresent"	ThenErrorMessage="Shall not be present for DoubleFloatPixelData"
	Verify="PlanarConfiguration"					Condition="PlanarConfigurationPresent"	ThenErrorMessage="Shall not be present for DoubleFloatPixelData"

	Name="DoubleFloatPixelData"						Type="1"

	# PixelAspectRatio required if the image plane module not applicable and the aspect ratio is not 1:1
	Name="PixelAspectRatio"							Type="1C"	NoCondition=""	# "if ! image plane module present && not 1:1" ... too hard for now :(
	Verify="PixelAspectRatio"									Condition="UnwantedPixelAspectRatioWhenPixelSpacingPresent"					ThenErrorMessage="Shall not be present when PixelSpacing is present"
	Verify="PixelAspectRatio"									Condition="UnwantedPixelAspectRatioWhenImagerPixelSpacingPresent"			ThenErrorMessage="Shall not be present when ImagerPixelSpacing is present"
	Verify="PixelAspectRatio"									Condition="UnwantedPixelAspectRatioWhenNominalScannedPixelSpacingPresent"	ThenErrorMessage="Shall not be present when NominalScannedPixelSpacing is present"
	Verify="PixelAspectRatio"									Condition="UnwantedPixelAspectRatioWhenSharedPixelMeasuresMacro"			ThenErrorMessage="Shall not be present when PixelMeasuresSequence is present"
	Verify="PixelAspectRatio"									Condition="UnwantedPixelAspectRatioWhenPerFramePixelMeasuresMacro"			ThenErrorMessage="Shall not be present when PixelMeasuresSequence is present"
	Verify="PixelAspectRatio"									Condition="UnwantedPixelAspectRatioWhenMPEG2MPHLTransferSyntax"				ThenErrorMessage="Shall not be present for MPEG MP@HLTransfer Syntax"

	Name="DoubleFloatPixelPaddingValue"				Type="3"
	Name="DoubleFloatPixelPaddingRangeLimit"		Type="1C"	Condition="DoubleFloatPixelPaddingValuePresent"
ModuleEnd

Module="ImagePixel"
	InvokeMacro="ImagePixelDescriptionMacro"
	Verify="ICCProfile"										Condition="ICCProfileNotPermittedWhenOpticalPathModule"	ThenErrorMessage="Shall not be present when Optical Path Module is present"
	Verify="ICCProfile"										Condition="ColorSpaceNotPermittedWhenOpticalPathModule"	ThenErrorMessage="Shall not be present when Optical Path Module is present"
	Name="PixelData"										Type="1C"	Condition="PixelDataProviderURLIsAbsent"
	Name="PixelDataProviderURL"								Type="1C"	Condition="TransferSyntaxIsReferencedPixelData"
	Name="PixelPaddingRangeLimit"							Type="1C"	NoCondition=""		# real world
	Name="ExtendedOffsetTable"								Type="3"
	Verify="ExtendedOffsetTable"										Condition="ExtendedOffsetTableNotPermitted"	ThenErrorMessage="Shall not be present in absence of encapsulated Pixel Data"
	Name="ExtendedOffsetTableLengths"						Type="1C"	NoCondition=""	# Cannot tell whether every frame is encoded as a single fragment
	Verify="ExtendedOffsetTableLengths"									Condition="ExtendedOffsetTableLengthsPresentButExtendedOffsetTableNotPresent"	ThenErrorMessage="Shall not be present if ExtendedOffsetTable is not present"
ModuleEnd

Module="RealTimeBulkDataFlow"
	Sequence="RealTimeBulkDataFlowSequence"				Type="1"	VM="1-n"
		Name="SourceIdentifier"							Type="1"
		Sequence="FlowIdentifierSequence"				Type="1"	VM="1-n"
			Name="FlowIdentifier"						Type="1"
			Name="FlowTransferSyntaxUID"				Type="1"
			Name="FlowRTPSamplingRate"					Type="1"
		SequenceEnd
	SequenceEnd
ModuleEnd

Module="CurrentFrameFunctionalGroups"
	# CurrentFrameFunctionalGroupsSequence specified in IOD that invokes module, where the required functional groups are listed
ModuleEnd

Module="RealTimeAcquisition"
	# SharedFunctionalGroupSequence specified in IOD that invokes module, where the required functional groups are listed
	Name="StereoPairsPresent"							Type="1"	StringEnumValues="YesNoFull"
ModuleEnd

Module="ContrastBolus"
	Name="ContrastBolusAgent"							Type="2"
	Sequence="ContrastBolusAgentSequence"				Type="3"	VM="1-n"
		InvokeMacro="CodeSequenceMacro"
	SequenceEnd
	Name="ContrastBolusRoute"							Type="3"
	Sequence="ContrastBolusAdministrationRouteSequence"	Type="3"	VM="1"
		InvokeMacro="CodeSequenceMacro"
		Sequence="AdditionalDrugSequence"				Type="3"	VM="1-n"
			InvokeMacro="CodeSequenceMacro"
		SequenceEnd
	SequenceEnd
	Name="ContrastBolusVolume"							Type="3"
	Name="ContrastBolusStartTime"						Type="3"
	Name="ContrastBolusStopTime"						Type="3"
	Name="ContrastBolusTotalDose"						Type="3"
	Name="ContrastFlowRate"								Type="3"
	Name="ContrastFlowDuration"							Type="3"
	Name="ContrastBolusIngredient"						Type="3"
	Name="ContrastBolusIngredientConcentration"			Type="3"
ModuleEnd

Module="EnhancedContrastBolus"
	Sequence="ContrastBolusAgentSequence"					Type="1"	VM="1-n"
		InvokeMacro="CodeSequenceMacro"
		Name="ContrastBolusAgentNumber"						Type="1"
		Sequence="ContrastBolusAdministrationRouteSequence"	Type="1"	VM="1"
			InvokeMacro="CodeSequenceMacro"
		SequenceEnd
		Sequence="ContrastBolusIngredientCodeSequence"		Type="2"	VM="0-n"
			InvokeMacro="CodeSequenceMacro"
		SequenceEnd
		Name="ContrastBolusVolume"							Type="2"
		Name="ContrastBolusIngredientConcentration"			Type="2"
		Name="ContrastBolusIngredientPercentByVolume"		Type="3"
		Name="ContrastBolusIngredientOpaque"				Type="3"	StringEnumValues="YesNoFull"
		Name="ContrastBolusT1Relaxivity"					Type="3"
		Sequence="ContrastAdministrationProfileSequence"	Type="3"	VM="1-n"
			Name="ContrastBolusVolume"						Type="2"
			Name="ContrastBolusStartTime"					Type="3"
			Name="ContrastBolusStopTime"					Type="3"
			Name="ContrastFlowRate"							Type="3"
			Name="ContrastFlowDuration"						Type="3"
		SequenceEnd
	SequenceEnd
ModuleEnd

Module="Cine"
	Name="PreferredPlaybackSequencing"		Type="3"	BinaryEnumValues="PreferredPlaybackSequencing"
	
	Name="FrameTime"						Type="1C"	Condition="FrameIncrementPointerContainsFrameTime"
	Verify="FrameTime"						Condition="MPEG2MPMLTransferSyntaxAndFrameTimeNotNTSCOrPAL"	ThenErrorMessage="Must be 33.3 (NTSC) or 40 (PAL) for MPEG MP@MLTransfer Syntax"
	Verify="FrameTime"						Condition="MPEG2MPHLTransferSyntaxAndFrameTimeNotValid"	ThenErrorMessage="Must be 16.17, 20, 33.33, or 40 (PAL) for MPEG MP@HLTransfer Syntax"
	
	Name="FrameTimeVector"					Type="1C"	Condition="FrameIncrementPointerContainsFrameTimeVector"
	Name="StartTrim"						Type="3"
	Name="StopTrim"							Type="3"
	Name="RecommendedDisplayFrameRate"		Type="3"
	
	Name="CineRate"							Type="3"
	Verify="CineRate"						Condition="MPEG2MPMLTransferSyntaxAndCineRateNotNTSCOrPAL"	ThenErrorMessage="Must be 30 (NTSC) or 25 (PAL) for MPEG MP@MLTransfer Syntax"
	Verify="CineRate"						Condition="MPEG2MPHLTransferSyntaxAndCineRateNotValid"	ThenErrorMessage="Must be 25, 30, 50 or 60 for MPEG MP@HLTransfer Syntax"
	Verify="CineRate"						Condition="MPEG2MPMLTransferSyntaxAndCineRateInconsistentWithFrameTime"	ThenErrorMessage="Must be 30 when FrameTime is 33.3 (NTSC) or 25 when FrameTime is 40 (PAL) for MPEG MP@MLTransfer Syntax"
	Verify="CineRate"						Condition="MPEG2MPHLTransferSyntaxAndCineRateInconsistentWithFrameTime"	ThenErrorMessage="Must be 30 when FrameTime is 33.3, 25 when FrameTime is 40, 60 when FrameTime is 16.17, or 50 when FrameTime is 20 for MPEG MP@HLTransfer Syntax"
	
	Name="FrameDelay"						Type="3"
	Name="ImageTriggerDelay"				Type="3"
	Name="EffectiveDuration"				Type="3"
	Name="ActualFrameDuration"				Type="3"
	Sequence="MultiplexedAudioChannelsDescriptionCodeSequence"	Type="3"	VM="1-n"
		Name="ChannelIdentificationCode"	Type="1"
		Name="ChannelMode"					Type="1"
		Sequence="ChannelSourceSequence"	Type="1"	VM="1"
			InvokeMacro="CodeSequenceMacro"
		SequenceEnd
	SequenceEnd
ModuleEnd

Module="MultiFrame"
	Name="NumberOfFrames"					Type="1"	NotZeroError=""
	Name="FrameIncrementPointer"			Type="1C"	Condition="NotSCMultiFrameOrNumberOfFramesGreaterThanOne"
	Name="StereoPairsPresent"				Type="3"	StringEnumValues="YesNoFull"
ModuleEnd

Module="MultiFrameFunctionalGroupsCommon"
	# the Shared Functional Groups Sequence and Per-frame Functional Groups Sequence are included in the IOD-specific pseudo-modules
	Name="InstanceNumber"						Type="1"
	Name="ContentDate"							Type="1"
	Name="ContentTime"							Type="1"
	Name="NumberOfFrames"						Type="1"	NotZeroError=""
	Name="StereoPairsPresent"					Type="3"	StringEnumValues="YesNoFull"
	Name="ConcatenationFrameOffsetNumber"		Type="1C"	Condition="ConcatenationUIDIsPresent"
	Name="RepresentativeFrameNumber"			Type="3"	NotZeroError=""
	Name="ConcatenationUID"						Type="1C"	Condition="ConcatenationAttributesArePresentAndTotalNumberIfPresentGreaterThanOne"
	Name="SOPInstanceUIDOfConcatenationSource"	Type="1C"	Condition="ConcatenationUIDIsPresent"
	Name="InConcatenationNumber"				Type="1C"	Condition="ConcatenationUIDIsPresent"
	Name="InConcatenationTotalNumber"			Type="3"
	Verify="InConcatenationTotalNumber"						Condition="InConcatenationTotalNumberIsLessThanOrEqualToOne"	ThenErrorMessage="Cannot be less than or equal to one since then not a Concatenation"
ModuleEnd

DefineMacro="PixelMeasuresMacro" InformationEntity="FunctionalGroup"
	Sequence="PixelMeasuresSequence"		Type="1"	VM="1"
		Name="PixelSpacing"					Type="1C"					Condition="PixelSpacingRequiredInPixelMeasures" mbpo="true"
		Verify="PixelSpacing"							NotZeroError=""
		Name="SliceThickness"				Type="1C"					Condition="SliceThicknessRequiredInPixelMeasures" mbpo="true"
		Verify="SliceThickness"							NotZeroError=""
		Name="SpacingBetweenSlices"			Type="1C"					Condition="DimensionOrganizationTypeIsTILED_FULLAndTotalPixelMatrixFocalPlanesGreaterThanOne" mbpo="true"
		Verify="SpacingBetweenSlices"					NotZeroError=""
		Verify="SpacingBetweenSlices"									Condition="SpacingBetweenSlicesIsNegative"	ThenErrorMessage="Not permitted to be negative" ShowValueWithMessage="true"
	SequenceEnd
MacroEnd

DefineMacro="FrameContentMacro" InformationEntity="FunctionalGroup"
	Sequence="FrameContentSequence"				Type="1"	VM="1"
		Name="FrameAcquisitionNumber"			Type="3"
		Name="FrameReferenceDateTime"			Type="1C"	Condition="ImageTypeValue1OriginalOrMixedAndNotTILED_FULLAndNotLegacyConvertedOrWholeSlide" mbpo="true" # approximates (../../[SharedFunctionalGroupsSequence or PerFrameFunctionalGroupsSequence item for this frame]MRImageFrameTypeMacro/FrameType is ORIGINAL) and not legacy CT, MR or PET or WSI ... too hard :(
		Name="FrameAcquisitionDateTime"			Type="1C"	Condition="ImageTypeValue1OriginalOrMixedAndNotTILED_FULLAndNotLegacyConvertedOrWholeSlide" mbpo="true" # approximates (../../[SharedFunctionalGroupsSequence or PerFrameFunctionalGroupsSequence item for this frame]MRImageFrameTypeMacro/FrameType is ORIGINAL) and not legacy CT, MR or PET or WSI ... too hard :(
		Name="FrameAcquisitionDuration"			Type="1C"	Condition="ImageTypeValue1OriginalOrMixedAndNotTILED_FULLAndNotLegacyConvertedOrWholeSlide" mbpo="true" NotZeroWarning=""	# approximates (../../[SharedFunctionalGroupsSequence or PerFrameFunctionalGroupsSequence item for this frame]MRImageFrameTypeMacro/FrameType is ORIGINAL) and not legacy CT, MR or PET or WSI ... too hard :(
		Name="CardiacCyclePosition"				Type="3"	StringDefinedTerms="CardiacCyclePosition"
		Name="RespiratoryCyclePosition"			Type="3"	StringDefinedTerms="RespiratoryCyclePosition"
		Name="DimensionIndexValues"				Type="1C"	Condition="DimensionIndexSequencePresent"
		Verify="DimensionIndexValues"						Condition="DimensionIndexValuesContainsZero"	ThenErrorMessage="Must start from one, not zero"
		Name="TemporalPositionIndex"			Type="1C"	Condition="NeedTemporalPositionIndexInFrameContentMacro" mbpo="true"
		Verify="TemporalPositionIndex"						Condition="TemporalPositionIndexIsZero"	ThenErrorMessage="Must start from one, not zero"
		Name="StackID"							Type="1C"	Condition="NeedStackIDInFrameContentMacro" mbpo="true"
		Name="InStackPositionNumber"			Type="1C"	Condition="NeedInStackPositionNumberInFrameContentMacro"
		Verify="InStackPositionNumber"						Condition="InStackPositionNumberIsZero"	ThenErrorMessage="Must start from one, not zero"
		Name="FrameComments"					Type="3"
		Name="FrameLabel"						Type="3"
	SequenceEnd
	Verify="FrameContentSequence"							Condition="FrameContentSequenceInSharedFunctionalGroupSequence"	ThenErrorMessage="Not permitted in SharedFunctionalGroupSequence"
MacroEnd

DefineMacro="PlanePositionMacro" InformationEntity="FunctionalGroup"
	Sequence="PlanePositionSequence"			Type="1"	VM="1"
		Name="ImagePositionPatient"				Type="1C"	Condition="ImagePositionPatientRequiredInPlanePositionPatient" mbpo="true"
	SequenceEnd
MacroEnd

DefineMacro="PlaneOrientationMacro" InformationEntity="FunctionalGroup"
	Sequence="PlaneOrientationSequence"			Type="1"	VM="1"
		Name="ImageOrientationPatient"			Type="1C"		Condition="ImageOrientationPatientRequiredInPlanePositionPatient" mbpo="true"
	SequenceEnd
MacroEnd

DefineMacro="ReferencedImageMacro" InformationEntity="FunctionalGroup"
	Sequence="ReferencedImageSequence"				Type="2"	VM="0-n"
		InvokeMacro="ImageSOPInstanceReferenceMacro"
		Sequence="PurposeOfReferenceCodeSequence"	Type="1C"	VM="1"	Condition="NotLegacyConvertedCTOrMROrPET" mbpo="true"
			InvokeMacro="CodeSequenceMacro"
		SequenceEnd
	SequenceEnd
MacroEnd

DefineMacro="DerivationImageMacro" InformationEntity="FunctionalGroup"
	Sequence="DerivationImageSequence"					Type="2"	VM="0-n"
		Name="DerivationDescription"					Type="3" 
		Sequence="DerivationCodeSequence"				Type="1C"	VM="1-n"	Condition="NotLegacyConvertedCTOrMROrPET" mbpo="true"
			InvokeMacro="CodeSequenceMacro"
		SequenceEnd
		Sequence="SourceImageSequence"					Type="2"	VM="0-n"
			InvokeMacro="ImageSOPInstanceReferenceMacro"
			Sequence="PurposeOfReferenceCodeSequence"	Type="1C"	VM="1"	Condition="NotLegacyConvertedCTOrMROrPET" mbpo="true"
				InvokeMacro="CodeSequenceMacro"
			SequenceEnd
			Name="SpatialLocationsPreserved"			Type="3"	StringEnumValues="YesNoReorientedOnly"
			Name="PatientOrientation"					Type="1C"	Condition="SpatialLocationsPreservedReorientedOnly"
		SequenceEnd
	SequenceEnd
MacroEnd

DefineMacro="CardiacSynchronizationMacro" InformationEntity="FunctionalGroup"
	Sequence="CardiacSynchronizationSequence"	Type="1"	VM="1"
		Name="NominalPercentageOfCardiacPhase"	Type="1C"  	NoCondition="" mbpo="true"	# too hard
		Name="NominalCardiacTriggerDelayTime"	Type="1"
		Name="ActualCardiacTriggerDelayTime"	Type="1C"	Condition="SingleCardiacIntervalAcquired" mbpo="true"
		Name="IntervalsAcquired"				Type="3"
		Name="IntervalsRejected"				Type="3"
		Name="HeartRate"						Type="3"
		Name="RRIntervalTimeNominal"			Type="1C"	Condition="CardiacSynchronizationTechniqueOtherThanNoneOrRealTime" mbpo="true"
		Name="LowRRValue"						Type="3"
		Name="HighRRValue"						Type="3"
	SequenceEnd
MacroEnd

DefineMacro="FrameAnatomyMacro" InformationEntity="FunctionalGroup"
	Sequence="FrameAnatomySequence"						Type="1"	VM="1"
		Name="FrameLaterality"							Type="1"	StringEnumValues="ImageLaterality"
		InvokeMacro="GeneralAnatomyMandatoryMacro"
	SequenceEnd
MacroEnd

DefineMacro="PixelValueTransformationMacro" InformationEntity="FunctionalGroup"
	Sequence="PixelValueTransformationSequence"		Type="1"	VM="1"
		Name="RescaleIntercept"						Type="1" 
		Name="RescaleSlope"							Type="1"	NotZeroError=""
		Name="RescaleType"							Type="1"
		Verify="RescaleType"						Type="1C"	StringDefinedTerms="RescaleTypeUnspecified"	Condition="ModalityIsMROrPET"
	SequenceEnd
MacroEnd

DefineMacro="FrameVOILUTMacro" InformationEntity="FunctionalGroup"
	Sequence="FrameVOILUTSequence"				Type="1"	VM="1"
		Name="WindowCenter"						Type="1"
		Name="WindowWidth"						Type="1"	NotZeroError=""
		Verify="WindowWidth"								Condition="WindowWidthIsNegative"	ThenErrorMessage="Not permitted to be negative" ShowValueWithMessage="true"
		Name="WindowCenterWidthExplanation"		Type="3"
		Verify="WindowCenterWidthExplanation"	Type="1C"	StringDefinedTerms="EnhancedCTWindowCenterWidthExplanation"	Condition="ModalityIsCT"
		Name="VOILUTFunction"					Type="3"	StringDefinedTerms="VOILUTFunction"
	SequenceEnd
MacroEnd

DefineMacro="RealWorldValueMappingMacro" InformationEntity="FunctionalGroup"
	Sequence="RealWorldValueMappingSequence"		Type="1"	VM="1-n"
		InvokeMacro="RealWorldValueMappingItemMacro"
	SequenceEnd
MacroEnd

DefineMacro="RealWorldValueMappingItemMacro" InformationEntity="FunctionalGroup"
	Name="RealWorldValueFirstValueMapped"				Type="1C" 	Condition="NeedRealWorldValueFirstValueMapped"
	Name="RealWorldValueLastValueMapped"				Type="1C" 	Condition="NeedRealWorldValueLastValueMapped"
	Name="DoubleFloatRealWorldValueFirstValueMapped"	Type="1C" 	Condition="NeedDoubleFloatRealWorldValueFirstValueMapped"
	Name="DoubleFloatRealWorldValueLastValueMapped"		Type="1C" 	Condition="NeedDoubleFloatRealWorldValueLastValueMapped"
	Name="RealWorldValueIntercept"				Type="1C" 	Condition="NeedRealWorldValueSlopeAndIntercept"
	Name="RealWorldValueSlope"					Type="1C" 	Condition="NeedRealWorldValueSlopeAndIntercept"
	Name="RealWorldValueLUTData"				Type="1C" 	Condition="RealWorldValueInterceptNotPresent"
	Name="LUTExplanation"						Type="1" 
	Name="LUTLabel"								Type="1" 
	Sequence="MeasurementUnitsCodeSequence"		Type="1"	VM="1"
		InvokeMacro="CodeSequenceMacro"						DefinedContextID="7181"
	SequenceEnd
	Sequence="QuantityDefinitionSequence"		Type="3"	VM="1-n"
		InvokeMacro="ContentItemMacro"
	SequenceEnd
MacroEnd

DefineMacro="ContrastBolusUsageMacro" InformationEntity="FunctionalGroup"
	Sequence="ContrastBolusUsageSequence"			Type="1"	VM="1-n"
		Name="ContrastBolusAgentNumber"				Type="1" 
		Name="ContrastBolusAgentAdministered"		Type="1"	StringEnumValues="YesNoFull"
		Name="ContrastBolusAgentDetected"			Type="2"	StringEnumValues="YesNoFull"
		Name="ContrastBolusAgentPhase"				Type="2C"	NoCondition="" StringDefinedTerms="ContrastBolusAgentPhase"
	SequenceEnd
MacroEnd

DefineMacro="PixelIntensityRelationshipLUTMacro" InformationEntity="FunctionalGroup"
	Sequence="PixelIntensityRelationshipLUTSequence"	Type="1"	VM="1-n"
		Name="LUTDescriptor"							Type="1" 
		Name="LUTData"									Type="1" 
		Name="LUTFunction"								Type="1" 	StringEnumValues="PixelIntensityRelationshipLUTFunction"
	SequenceEnd
MacroEnd

DefineMacro="FramePixelShiftMacro" InformationEntity="FunctionalGroup"
	Sequence="FramePixelShiftSequence"		Type="1"	VM="1-n"
		Name="SubtractionItemID"			Type="1" 
		Name="MaskSubPixelShift"			Type="1"
	SequenceEnd
MacroEnd

DefineMacro="PatientOrientationInFrameMacro" InformationEntity="FunctionalGroup"
	Sequence="PatientOrientationInFrameSequence"		Type="1"	VM="1"
		Name="PatientOrientation"						Type="1"
	SequenceEnd
MacroEnd

DefineMacro="FrameDisplayShutterMacro" InformationEntity="FunctionalGroup"
	Sequence="FrameDisplayShutterSequence"		Type="1"	VM="1"
		InvokeMacro="DisplayShutterMacro"
	SequenceEnd
MacroEnd

DefineMacro="RespiratorySynchronizationMacro" InformationEntity="FunctionalGroup"
	Sequence="RespiratorySynchronizationSequence"		Type="1"	VM="1"
		Name="RespiratoryIntervalTime"					Type="1C"	Condition="NeedRespiratoryIntervalTime"
		Name="NominalPercentageOfRespiratoryPhase"		Type="1C"  	NoCondition="" mbpo="true"	# too hard
		Name="NominalRespiratoryTriggerDelayTime"		Type="1"
		Name="ActualRespiratoryTriggerDelayTime"		Type="1C"	Condition="RespiratoryTriggerTypeTimeOrBoth"
		Name="StartingRespiratoryAmplitude"				Type="1C"	Condition="RespiratoryTriggerTypeAmplitudeOrBoth"
		Name="StartingRespiratoryPhase"					Type="1C"	Condition="StartingRespiratoryAmplitudeIsPresent"	StringEnumValues="RespiratoryPhase"
		Name="EndingRespiratoryAmplitude"				Type="1C"	Condition="RespiratoryTriggerTypeAmplitudeOrBoth"
		Name="EndingRespiratoryPhase"					Type="1C"	Condition="EndingRespiratoryAmplitudeIsPresent"		StringEnumValues="RespiratoryPhase"
		
	SequenceEnd
MacroEnd

DefineMacro="IrradiationEventIdentificationMacro" InformationEntity="FunctionalGroup"
	Sequence="IrradiationEventIdentificationSequence"	Type="1"	VM="1"
		Name="IrradiationEventUID"						Type="1"
	SequenceEnd
MacroEnd

DefineMacro="RadiopharmaceuticalUsageMacro" InformationEntity="FunctionalGroup"
	Sequence="RadiopharmaceuticalUsageSequence"	Type="1"	VM="1"
		Name="RadiopharmaceuticalAgentNumber"	Type="1"
	SequenceEnd
MacroEnd

DefineMacro="PatientPhysiologicalStateMacro" InformationEntity="FunctionalGroup"
	Sequence="PatientPhysiologicalStateSequence"			Type="1"	VM="1"
		Sequence="PatientPhysiologicalStateCodeSequence"	Type="1"	VM="1"
			InvokeMacro="CodeSequenceMacro"					DefinedContextID="3101"
		SequenceEnd
	SequenceEnd
MacroEnd

Module="MultiFrameDimension"
	Sequence="DimensionOrganizationSequence"	Type="1"	VM="1-n"
		Name="DimensionOrganizationUID"			Type="1" 
	SequenceEnd
	Name="DimensionOrganizationType"			Type="3"	StringDefinedTerms="DimensionOrganizationType"
	Sequence="DimensionIndexSequence"			Type="1C"	VM="1-n" Condition="DimensionOrganizationTypeIsNotTILED_FULL"	mbpo="true"
		Name="DimensionIndexPointer"			Type="1"
		Verify="DimensionIndexPointer"						Condition="DimensionIndexPointerIsFrameContentSequence"	ThenErrorMessage="Shall not be FrameContentSequence"
		Verify="DimensionIndexPointer"						Condition="DimensionIndexPointerIsDimensionIndexValues"	ThenErrorMessage="Shall not be DimensionIndexValues"
		Name="DimensionIndexPrivateCreator"		Type="1C"	NoCondition="" # too hard to check
		Name="FunctionalGroupPointer"			Type="1C"	Condition="DimensionIndexPointerIsNotFunctionalGroup"
		Name="FunctionalGroupPrivateCreator"	Type="1C"	NoCondition="" # too hard to check
		Name="DimensionOrganizationUID"			Type="1"
		Name="DimensionDescriptionLabel"		Type="3" 
	SequenceEnd
ModuleEnd

Module="CardiacSynchronization"	
	Name="CardiacSynchronizationTechnique"		Type="1C" 	StringEnumValues="CardiacSynchronizationTechnique"	Condition="ImageTypeValue1OriginalOrMixed" mbpo="true"
	Name="CardiacSignalSource"					Type="1C" 	StringDefinedTerms="CardiacSignalSource"		Condition="CardiacSynchronizationTechniqueNotNoneAndOriginalOrMixed" mbpo="true"
	Verify="CardiacSignalSource"							Condition="CardiacSignalSourcePresentAndCardiacSynchronizationTechniqueIsNone"	ThenErrorMessage="Shall not be present when CardiacSynchronizationTechnique is NONE"
	Name="CardiacRRIntervalSpecified"			Type="1C" 	Condition="CardiacSynchronizationTechniqueNotNoneAndOriginalOrMixed"
	Verify="CardiacRRIntervalSpecified"						Condition="CardiacRRIntervalSpecifiedPresentAndCardiacSynchronizationTechniqueIsNone"	ThenErrorMessage="Shall not be present when CardiacSynchronizationTechnique is NONE"
	Name="CardiacBeatRejectionTechnique"		Type="1C" 	StringDefinedTerms="CardiacBeatRejectionTechnique"	Condition="CardiacSynchronizationTechniqueProspectiveOrRetrospective"
	Verify="CardiacBeatRejectionTechnique"					Condition="CardiacBeatRejectionTechniquePresentAndCardiacSynchronizationTechniqueIsNotProspectiveOrRetrospective"	ThenErrorMessage="Shall not be present when CardiacSynchronizationTechnique is not PROSPECTIVE or RETROSPECTIVE"
	Name="LowRRValue"							Type="2C" 	Condition="CardiacSynchronizationTechniqueProspectiveOrRetrospective"
	Verify="LowRRValue"										Condition="LowRRValuePresentAndCardiacSynchronizationTechniqueIsNotProspectiveOrRetrospective"	ThenErrorMessage="Shall not be present when CardiacSynchronizationTechnique is not PROSPECTIVE or RETROSPECTIVE"
	Name="HighRRValue"							Type="2C" 	Condition="CardiacSynchronizationTechniqueProspectiveOrRetrospective"
	Verify="HighRRValue"									Condition="HighRRValuePresentAndCardiacSynchronizationTechniqueIsNotProspectiveOrRetrospective"	ThenErrorMessage="Shall not be present when CardiacSynchronizationTechnique is not PROSPECTIVE or RETROSPECTIVE"
	Name="IntervalsAcquired"					Type="2C" 	Condition="CardiacSynchronizationTechniqueNotNoneAndOriginalOrMixed"
	Verify="IntervalsAcquired"								Condition="IntervalsAcquiredPresentAndCardiacSynchronizationTechniqueIsNone"	ThenErrorMessage="Shall not be present when CardiacSynchronizationTechnique is NONE"
	Name="IntervalsRejected"					Type="2C" 	Condition="CardiacSynchronizationTechniqueNotNoneAndOriginalOrMixed"
	Verify="IntervalsRejected"								Condition="IntervalsRejectedPresentAndCardiacSynchronizationTechniqueIsNone"	ThenErrorMessage="Shall not be present when CardiacSynchronizationTechnique is NONE"
	Name="SkipBeats"							Type="3" 
	Name="CardiacFramingType"					Type="1C"	NoCondition="" 	StringDefinedTerms="CardiacFramingType"
ModuleEnd

Module="RespiratorySynchronization"
	Name="RespiratoryMotionCompensationTechnique"	Type="1C" 	StringDefinedTerms="RespiratoryMotionCompensationTechnique"	Condition="ImageTypeValue1OriginalOrMixed" mbpo="true"
	Name="RespiratorySignalSource"					Type="1C" 	StringDefinedTerms="RespiratorySignalSource"			Condition="RespiratoryMotionCompensationTechniqueNotNone"
	Verify="RespiratorySignalSource"							Condition="RespiratorySignalSourcePresentAndRespiratoryMotionCompensationTechniqueIsNone"	ThenErrorMessage="Shall not be present when RespiratoryMotionCompensationTechnique is NONE"
	Name="RespiratoryTriggerDelayThreshold"			Type="1C" 	Condition="RespiratoryMotionCompensationTechniqueNotNoneOrRealTimeOrBreathHoldAndOriginalOrMixed" mbpo="true"
	Name="RespiratoryTriggerType"					Type="1C"	NoCondition="" 	StringDefinedTerms="RespiratoryTriggerType"
ModuleEnd

Module="BulkMotionSynchronization"
	Name="BulkMotionCompensationTechnique"		Type="1C" 	StringDefinedTerms="BulkMotionCompensationTechnique"	Condition="ImageTypeValue1OriginalOrMixed"
	Name="BulkMotionSignalSource"				Type="1C" 	StringDefinedTerms="BulkMotionSignalSource"		Condition="BulkMotionCompensationTechniqueNotNoneAndOriginalOrMixed"
	Verify="BulkMotionSignalSource"							Condition="BulkMotionSignalSourcePresentAndBulkMotionCompensationTechniqueIsNone"	ThenErrorMessage="Shall not be present when BulkMotionCompensationTechnique is NONE"
ModuleEnd

Module="SupplementalPaletteColorLUT"
	Name="RedPaletteColorLookupTableDescriptor"		Type="1"
	Verify="RedPaletteColorLookupTableDescriptor"	Type="1"	ValueSelector="2"	BinaryEnumValues="BitsAre16"
	Name="GreenPaletteColorLookupTableDescriptor"	Type="1"
	Verify="GreenPaletteColorLookupTableDescriptor"	Type="1"	ValueSelector="2"	BinaryEnumValues="BitsAre16"
	Name="BluePaletteColorLookupTableDescriptor"	Type="1"
	Verify="BluePaletteColorLookupTableDescriptor"	Type="1"	ValueSelector="2"	BinaryEnumValues="BitsAre16"
	Name="RedPaletteColorLookupTableData"			Type="1"
	Name="GreenPaletteColorLookupTableData"			Type="1"
	Name="BluePaletteColorLookupTableData"			Type="1"
ModuleEnd

DefineMacro="PaletteColorLookupTableMacro"
	Name="RedPaletteColorLookupTableDescriptor"			Type="1"
	Verify="RedPaletteColorLookupTableDescriptor"					Condition="NotColorPaletteInstance"	ValueSelector="2"	BinaryEnumValues="BitsAre8Or16"
	Verify="RedPaletteColorLookupTableDescriptor"					Condition="ColorPaletteInstance"	ValueSelector="2"	BinaryEnumValues="BitsAre8"
	Name="GreenPaletteColorLookupTableDescriptor"		Type="1"
	Verify="GreenPaletteColorLookupTableDescriptor"					Condition="NotColorPaletteInstance"	ValueSelector="2"	BinaryEnumValues="BitsAre8Or16"
	Verify="GreenPaletteColorLookupTableDescriptor"					Condition="ColorPaletteInstance"	ValueSelector="2"	BinaryEnumValues="BitsAre8"
	Name="BluePaletteColorLookupTableDescriptor"		Type="1"
	Verify="BluePaletteColorLookupTableDescriptor"					Condition="NotColorPaletteInstance"	ValueSelector="2"	BinaryEnumValues="BitsAre8Or16"
	Verify="BluePaletteColorLookupTableDescriptor"					Condition="ColorPaletteInstance"	ValueSelector="2"	BinaryEnumValues="BitsAre8"
	Name="PaletteColorLookupTableUID"					Type="3"	# should check matches SOPInstanceUID if is ColorPaletteInstance :(
	Name="RedPaletteColorLookupTableData"				Type="1C"	Condition="NeedsNonSegmentedLookupTableData"
	Name="GreenPaletteColorLookupTableData"				Type="1C"	Condition="NeedsNonSegmentedLookupTableData"
	Name="BluePaletteColorLookupTableData"				Type="1C"	Condition="NeedsNonSegmentedLookupTableData"
	Name="SegmentedRedPaletteColorLookupTableData"		Type="1C"	Condition="NeedsSegmentedLookupTableData"
	Name="SegmentedGreenPaletteColorLookupTableData"	Type="1C"	Condition="NeedsSegmentedLookupTableData"
	Name="SegmentedBluePaletteColorLookupTableData"		Type="1C"	Condition="NeedsSegmentedLookupTableData"
MacroEnd

Module="PaletteColorLookupTable"
	InvokeMacro="PaletteColorLookupTableMacro"
ModuleEnd

Module="PatientOrientation"
	InvokeMacro="PatientOrientationMacro"
ModuleEnd

Module="ImageEquipmentCoordinateRelationship"
	Name="ImageToEquipmentMappingMatrix"				Type="1"
	Name="EquipmentCoordinateSystemIdentification"		Type="1"	StringEnumValues="EquipmentCoordinateSystemIdentification"
ModuleEnd

Module="CRSeries"
	Name="BodyPartExamined"				Type="2"
	Verify="BodyPartExamined"						Condition="IsHuman"		StringDefinedTerms="BodyPartExaminedHuman"
	Verify="BodyPartExamined"						Condition="IsAnimal"	StringDefinedTerms="BodyPartExaminedAnimal"
	Name="ViewPosition"					Type="2"
	Verify="ViewPosition"							Condition="IsHuman"		StringDefinedTerms="ViewPositionHuman"
	Verify="ViewPosition"							Condition="IsAnimal"	StringDefinedTerms="ViewPositionAnimal"
	Name="FilterType"					Type="3"
	Name="CollimatorGridName"			Type="3"
	Name="FocalSpots"					Type="3"
	Name="PlateType"					Type="3"
	Name="PhosphorType"					Type="3"
ModuleEnd

Module="CRImage"
	Name="PhotometricInterpretation"				Type="1"	StringEnumValues="PhotometricInterpretationMonochrome"
	Name="KVP"										Type="3"	NotZeroWarning=""
	Name="PlateID"									Type="3"
	Name="DistanceSourceToDetector"					Type="3"
	Name="DistanceSourceToPatient"					Type="3"
	Name="ExposureTime"								Type="3"	NotZeroWarning=""
	Verify="ExposureTimeInms"									Condition="ExposureTimeInmsIsPresentAndOthersAreNot" ThenErrorMessage="Attribute should not be used with Module <CRImage> - use ExposureTime instead of"

	Name="XRayTubeCurrent"							Type="3"	NotZeroWarning=""
	Verify="XRayTubeCurrentInmA"								Condition="XRayTubeCurrentInmAIsPresentAndOthersAreNot" ThenErrorMessage="Attribute should not be used with Module <CRImage> - use XRayTubeCurrent instead of"

	Name="Exposure"									Type="3"	NotZeroWarning=""
	Name="ExposureInuAs"							Type="3"	NotZeroWarning=""
	Verify="ExposureInmAs"										Condition="ExposureInmAsIsPresentAndOthersAreNot" ThenErrorMessage="Attribute should not be used with Module <CRImage> - use Exposure and/or ExposureInuAs instead of"

	Name="ImagerPixelSpacing"						Type="3"	NotZeroError=""
	InvokeMacro="BasicPixelSpacingCalibrationMacro"
	Name="GeneratorPower"							Type="3"	NotZeroWarning=""
	Name="AcquisitionDeviceProcessingDescription"	Type="3"
	Name="AcquisitionDeviceProcessingCode"			Type="3"
	Name="CassetteOrientation"						Type="3"	StringEnumValues="Orientation"
	Name="CassetteSize"								Type="3"	StringDefinedTerms="CassetteSize"
	Name="ExposuresOnPlate"							Type="3"	NotZeroWarning=""
	Name="RelativeXRayExposure"						Type="3"	NotZeroWarning=""
	Name="Sensitivity"								Type="3"	NotZeroWarning=""
	InvokeMacro="GeneralAnatomyOptionalMacro"
	InvokeMacro="ExposureIndexMacro"
ModuleEnd

Module="CTImage"
	Name="ImageType"					Type="1"	ValueSelector="2"	StringDefinedTerms="CTImageType3"
	Verify="ImageType"								ValueSelector="3"	StringDefinedTerms="CTImageType4"
	Verify="ImageType"								Condition="ImageTypeValue3MissingOrEmpty"	ThenErrorMessage="A value is required for value 3 in CT Images"
	Verify="ImageType"								Condition="ImageTypeValue4MissingOrEmptyForMultienergy"	ThenErrorMessage="A value is required for value 4 in multi-energy acquisition CT Images"
	Name="MultienergyCTAcquisition"		Type="3"	StringEnumValues="YesNoFull"
	Name="SamplesPerPixel"				Type="1"	BinaryEnumValues="SamplesPerPixelIsOne"
	Name="PhotometricInterpretation"	Type="1"	StringEnumValues="PhotometricInterpretationMonochrome"
	Name="BitsAllocated"				Type="1"	BinaryEnumValues="BitsAre16"
	Name="BitsStored"					Type="1"	BinaryEnumValues="BitsAre12To16"
	Name="HighBit"						Type="1"	BinaryEnumValues="BitsAre11To15"
	Name="RescaleIntercept"				Type="1"
	Name="RescaleSlope"					Type="1"	NotZeroError=""
	Name="RescaleType"					Type="1C"	Condition="MultienergyAcquisitionOrRescaleTypeIsPresentAndNotHU"	StringDefinedTerms="RescaleTypeCTImage" mbpo="true"
	Verify="RescaleType"							Condition="RescaleTypeIsPresentAndNotHUAndImageIsOriginalNotLocalizerAndNotMultienergyAcquisition" ThenWarningMessage="If RescaleType is present and not multi-energy acquisition, should be HU for ORIGINAL non-LOCALIZER images"
	Verify="RescaleType"							Condition="RescaleTypeIsPresentAndIsHUAndImageIsOriginalLocalizerAndNotMultienergyAcquisition"   ThenWarningMessage="If RescaleType is present and not multi-energy acquisition, should not be HU for ORIGINAL LOCALIZER images"
	Name="KVP"							Type="2"	NotZeroWarning=""
	Verify="KVP"									Condition="KVPNotEmptyWhenAlsoPresentInMultienergyCTAcquisitionSequence" ThenErrorMessage="Attribute shall be empty within Module <CTImage> when also present in MultienergyCTAcquisitionSequence"
	Name="AcquisitionNumber"			Type="2"
	Name="ScanOptions"					Type="3"	# too hard to check multi-energy contraint of same value
	Name="DataCollectionDiameter"		Type="3"	NotZeroWarning=""	# too hard to check multi-energy contraint of same value
	Name="DataCollectionCenterPatient"	Type="3"
	Name="ReconstructionDiameter"		Type="3"	NotZeroWarning=""
	Name="ReconstructionTargetCenterPatient"	Type="3"
	Name="DistanceSourceToDetector"		Type="3"	NotZeroWarning=""	# too hard to check multi-energy contraint of same value
	Name="DistanceSourceToPatient"		Type="3"	NotZeroWarning=""	# too hard to check multi-energy contraint of same value
	Name="GantryDetectorTilt"			Type="3"
	Name="TableHeight"					Type="3"
	Name="RotationDirection"			Type="3"	StringEnumValues="RotationDirection"
	Name="ExposureTime"					Type="3"	NotZeroWarning=""	# too hard to check multi-energy contraint of same value
	Verify="ExposureTimeInms"						Condition="ExposureTimeInmsIsPresentAndOthersAreNot" ThenErrorMessage="Attribute should not be used with Module <CTImage> - use ExposureTime instead of"
	
	Name="XRayTubeCurrent"				Type="3"	NotZeroWarning=""	# too hard to check multi-energy contraint of same value
	Verify="XRayTubeCurrentInmA"					Condition="XRayTubeCurrentInmAIsPresentAndOthersAreNot" ThenErrorMessage="Attribute should not be used with Module <CTImage> - use XRayTubeCurrent instead of"
	
	Name="Exposure"						Type="3"	NotZeroWarning=""	# too hard to check multi-energy contraint of same value
	Name="ExposureInuAs"				Type="3"	NotZeroWarning=""	# too hard to check multi-energy contraint of same value
	Verify="ExposureInmAs"							Condition="ExposureInmAsIsPresentAndOthersAreNot" ThenErrorMessage="Attribute should not be used with Module <CTImage> - use Exposure and/or ExposureInuAs instead of"
	
	Name="FilterType"					Type="3"	# too hard to check multi-energy contraint of same value
	Name="GeneratorPower"				Type="3"	NotZeroWarning=""	# too hard to check multi-energy contraint of same value
	Name="FocalSpots"					Type="3"	# too hard to check multi-energy contraint of same value
	Name="ConvolutionKernel"			Type="3"
	Name="RevolutionTime"				Type="3"	NotZeroWarning=""
	Name="SingleCollimationWidth"		Type="3"	NotZeroWarning=""	# too hard to check multi-energy contraint of same value
	Name="TotalCollimationWidth"		Type="3"	NotZeroWarning=""	# too hard to check multi-energy contraint of same value
	Name="TableSpeed"					Type="3"	NotZeroWarning=""
	Name="TableFeedPerRotation"			Type="3"	NotZeroWarning=""
	Name="SpiralPitchFactor"			Type="3"	NotZeroWarning=""
	Name="ExposureModulationType"		Type="3"
	Name="CTDIvol"						Type="3"	NotZeroWarning=""
	Verify="CTDIvol"							Condition="CTDIvolIsPresentButCTDIPhantomTypeCodeSequenceIsNot"   ThenWarningMessage="CTDIvol is present but it is uninterpretable without CTDIPhantomTypeCodeSequence, which is absent"
	Sequence="CTDIPhantomTypeCodeSequence"	Type="3"	VM="1"
		InvokeMacro="CodeSequenceMacro"				DefinedContextID="4052"
	SequenceEnd
	Name="WaterEquivalentDiameter"		Type="3"	NotZeroWarning=""
	Sequence="WaterEquivalentDiameterCalculationMethodCodeSequence"	Type="1C"	VM="1"	Condition="WaterEquivalentDiameterIsPresent"
		InvokeMacro="CodeSequenceMacro"				DefinedContextID="10024"
	SequenceEnd
	Name="ImageAndFluoroscopyAreaDoseProduct"	Type="3"	NotZeroWarning=""
	InvokeMacro="GeneralAnatomyOptionalMacro"
	InvokeMacro="OptionalViewAndSliceProgressionDirectionMacro"
	Name="CalciumScoringMassFactorPatient"		Type="3"	NotZeroWarning=""
	Name="CalciumScoringMassFactorDevice"		Type="3"	NotZeroWarning=""
	Name="EnergyWeightingFactor"				Type="1C"	Condition="MultiEnergyProportionalWeighting" mbpo="true"
	Sequence="CTAdditionalXRaySourceSequence"	Type="3"	VM="1-n"
		Name="KVP"								Type="1"	NotZeroWarning=""
		Name="XRayTubeCurrentInmA"				Type="1"	NotZeroWarning=""
		Name="DataCollectionDiameter"			Type="1"	NotZeroWarning=""
		Name="FocalSpots"						Type="1"
		Name="FilterType"						Type="1"
		Name="FilterMaterial"					Type="1"
		Name="ExposureInmAs"					Type="3"	NotZeroWarning=""
		Name="EnergyWeightingFactor"			Type="1C"	NotZeroWarning=""	Condition="EnergyWeightingFactorPresentInRoot" mbpo="true"	# delegate condition since hard otherwise; same result
	SequenceEnd
	Name="IsocenterPosition"					Type="3"
	InvokeMacro="RTEquipmentCorrelationMacro"
ModuleEnd

Module="MRImage"
	Name="ImageType"					Type="1"	ValueSelector="2"	StringDefinedTerms="MRImageType3"
	Verify="ImageType"								Condition="ImageTypeValue3MissingOrEmpty"	ThenErrorMessage="A value is required for value 3 in MR Images"
	Name="SamplesPerPixel"				Type="1"	BinaryEnumValues="SamplesPerPixelIsOne"
	Name="PhotometricInterpretation"	Type="1"	StringEnumValues="PhotometricInterpretationMonochrome"
	Name="BitsAllocated"				Type="1"	BinaryEnumValues="BitsAre16"
	Name="ScanningSequence"				Type="1"	StringEnumValues="ScanningSequence"
	Name="SequenceVariant"				Type="1"	StringDefinedTerms="SequenceVariant"
	Name="ScanOptions"					Type="2"	StringDefinedTerms="ScanOptions"
	Name="MRAcquisitionType"			Type="2"	StringEnumValues="MRAcquisitionType"
	Name="RepetitionTime"				Type="2C"	Condition="MRIsNotEchoPlanarOrIsSegmentedKSpace" mbpo="true"
	Name="EchoTime"						Type="2"	NotZeroWarning=""
	Name="EchoTrainLength"				Type="2"	NotZeroWarning=""
	Name="InversionTime"				Type="2C"	Condition="MRIsInversionRecovery"	NotZeroWarning=""
	Name="TriggerTime"					Type="2C"	Condition="MRIsCardiacOrPulseGated"
	Name="SequenceName"					Type="3"
	Name="AngioFlag"					Type="3"	StringEnumValues="AngioFlag"
	Name="NumberOfAverages"				Type="3"	NotZeroWarning=""
	Name="ImagingFrequency"				Type="3"	NotZeroWarning=""
	Name="ImagedNucleus"				Type="3"
	Name="EchoNumbers"					Type="3"
	Name="MagneticFieldStrength"		Type="3"	NotZeroWarning=""
	Name="NumberOfPhaseEncodingSteps"	Type="3"
	Name="PercentSampling"				Type="3"
	Name="PercentPhaseFieldOfView"		Type="3"
	Name="PixelBandwidth"				Type="3"
	Name="NominalInterval"				Type="3"
	Name="BeatRejectionFlag"			Type="3"	StringEnumValues="YesNoLetter"
	Name="LowRRValue"					Type="3"
	Name="HighRRValue"					Type="3"
	Name="IntervalsAcquired"			Type="3"
	Name="IntervalsRejected"			Type="3"
	Name="PVCRejection"					Type="3"
	Name="SkipBeats"					Type="3"
	Name="HeartRate"					Type="3"
	Name="CardiacNumberOfImages"		Type="3"
	Name="TriggerWindow"				Type="3"
	Name="ReconstructionDiameter"		Type="3"
	Name="ReceiveCoilName"				Type="3"
	Name="TransmitCoilName"				Type="3"
	Name="AcquisitionMatrix"			Type="3"
	Name="InPlanePhaseEncodingDirection"	Type="3"	StringEnumValues="PhaseEncodingDirection"
	Name="FlipAngle"					Type="3"	NotZeroWarning=""
	Name="SAR"							Type="3"
	Name="VariableFlipAngleFlag"		Type="3"	StringEnumValues="YesNoLetter"
	Name="dBdt"							Type="3"
	Name="TemporalPositionIdentifier"	Type="3"
	Name="NumberOfTemporalPositions"	Type="3"
	Name="TemporalResolution"			Type="3"
	InvokeMacro="GeneralAnatomyOptionalMacro"
	InvokeMacro="OptionalViewAndSliceProgressionDirectionMacro"
	Name="IsocenterPosition"			Type="3"
	Name="B1rms"						Type="3"
	Verify="RescaleIntercept"							Condition="RescaleInterceptPresentAndNotIdentity"	ThenWarningMessage="Non-identity Modality LUT Module (RescaleSlope and RescaleIntercept) not expected to be present in standard MR IOD - may cause windowing problems" ShowValueWithMessage="true"
	Verify="RescaleSlope"								Condition="RescaleSlopePresentAndNotIdentity"		ThenWarningMessage="Non-identity Modality LUT Module (RescaleSlope and RescaleIntercept) not expected to be present in standard MR IOD - may cause windowing problems" ShowValueWithMessage="true"
ModuleEnd

Module="NMPETPatientOrientation"
	Sequence="PatientOrientationCodeSequence"				Type="2"	VM="0-1"
		InvokeMacro="CodeSequenceMeaningOptionalMacro"							BaselineContextID="19"
		Sequence="PatientOrientationModifierCodeSequence"   Type="2C"	VM="0-1"	NoCondition=""	# real-world - orientation wrt. gravity
 			InvokeMacro="CodeSequenceMeaningOptionalMacro"						BaselineContextID="20"
		SequenceEnd
	SequenceEnd
	Sequence="PatientGantryRelationshipCodeSequence"		Type="2"	VM="0-1"
		InvokeMacro="CodeSequenceMeaningOptionalMacro"							BaselineContextID="21"
	SequenceEnd
ModuleEnd

Module="NMImagePixel"
	Name="SamplesPerPixel"				Type="1"	BinaryEnumValues="SamplesPerPixelIsOne"
	Name="PhotometricInterpretation"   	Type="1"	StringEnumValues="NMPhotometricInterpretation"
	Name="BitsAllocated"				Type="1"	BinaryEnumValues="BitsAre8Or16"
	Name="BitsStored"					Type="1"	BinaryEnumValues="BitsAre8Or16"
	Name="HighBit"						Type="1"	BinaryEnumValues="BitsAre7Or15"
	Name="PixelSpacing"					Type="2"	NotZeroError=""
ModuleEnd

Module="NMMultiFrame"
	Name="FrameIncrementPointer"   		Type="1"	TagEnumValues="NMFrameIncrementPointerValues"
	
	Verify="FrameIncrementPointer"					Condition="ImageTypeValue3WholeBodyOrStatic"	ValueSelector="0"	TagEnumValues="FrameIncrementPointerIsEnergyWindowVector"
	Verify="FrameIncrementPointer"					Condition="ImageTypeValue3WholeBodyOrStatic"	ValueSelector="1"	TagEnumValues="FrameIncrementPointerIsDetectorVector"
	
	Verify="FrameIncrementPointer"					Condition="ImageTypeValue3Dynamic"	ValueSelector="0"	TagEnumValues="FrameIncrementPointerIsEnergyWindowVector"
	Verify="FrameIncrementPointer"					Condition="ImageTypeValue3Dynamic"	ValueSelector="1"	TagEnumValues="FrameIncrementPointerIsDetectorVector"
	Verify="FrameIncrementPointer"					Condition="ImageTypeValue3Dynamic"	ValueSelector="2"	TagEnumValues="FrameIncrementPointerIsPhaseVector"
	Verify="FrameIncrementPointer"					Condition="ImageTypeValue3Dynamic"	ValueSelector="3"	TagEnumValues="FrameIncrementPointerIsTimeSliceVector"

	Verify="FrameIncrementPointer"					Condition="ImageTypeValue3Gated"	ValueSelector="0"	TagEnumValues="FrameIncrementPointerIsEnergyWindowVector"
	Verify="FrameIncrementPointer"					Condition="ImageTypeValue3Gated"	ValueSelector="1"	TagEnumValues="FrameIncrementPointerIsDetectorVector"
	Verify="FrameIncrementPointer"					Condition="ImageTypeValue3Gated"	ValueSelector="2"	TagEnumValues="FrameIncrementPointerIsRRIntervalVector"
	Verify="FrameIncrementPointer"					Condition="ImageTypeValue3Gated"	ValueSelector="3"	TagEnumValues="FrameIncrementPointerIsTimeSlotVector"

	Verify="FrameIncrementPointer"					Condition="ImageTypeValue3Tomo"	ValueSelector="0"	TagEnumValues="FrameIncrementPointerIsEnergyWindowVector"
	Verify="FrameIncrementPointer"					Condition="ImageTypeValue3Tomo"	ValueSelector="1"	TagEnumValues="FrameIncrementPointerIsDetectorVector"
	Verify="FrameIncrementPointer"					Condition="ImageTypeValue3Tomo"	ValueSelector="2"	TagEnumValues="FrameIncrementPointerIsRotationVector"
	Verify="FrameIncrementPointer"					Condition="ImageTypeValue3Tomo"	ValueSelector="3"	TagEnumValues="FrameIncrementPointerIsAngularViewVector"

	Verify="FrameIncrementPointer"					Condition="ImageTypeValue3GatedTomo"	ValueSelector="0"	TagEnumValues="FrameIncrementPointerIsEnergyWindowVector"
	Verify="FrameIncrementPointer"					Condition="ImageTypeValue3GatedTomo"	ValueSelector="1"	TagEnumValues="FrameIncrementPointerIsDetectorVector"
	Verify="FrameIncrementPointer"					Condition="ImageTypeValue3GatedTomo"	ValueSelector="2"	TagEnumValues="FrameIncrementPointerIsRotationVector"
	Verify="FrameIncrementPointer"					Condition="ImageTypeValue3GatedTomo"	ValueSelector="3"	TagEnumValues="FrameIncrementPointerIsRRIntervalVector"
	Verify="FrameIncrementPointer"					Condition="ImageTypeValue3GatedTomo"	ValueSelector="4"	TagEnumValues="FrameIncrementPointerIsTimeSlotVector"
	Verify="FrameIncrementPointer"					Condition="ImageTypeValue3GatedTomo"	ValueSelector="5"	TagEnumValues="FrameIncrementPointerIsAngularViewVector"

	Verify="FrameIncrementPointer"					Condition="ImageTypeValue3ReconTomo"	ValueSelector="0"	TagEnumValues="FrameIncrementPointerIsSliceVector"

	Verify="FrameIncrementPointer"					Condition="ImageTypeValue3ReconGatedTomo"	ValueSelector="0"	TagEnumValues="FrameIncrementPointerIsRRIntervalVector"
	Verify="FrameIncrementPointer"					Condition="ImageTypeValue3ReconGatedTomo"	ValueSelector="1"	TagEnumValues="FrameIncrementPointerIsTimeSlotVector"
	Verify="FrameIncrementPointer"					Condition="ImageTypeValue3ReconGatedTomo"	ValueSelector="2"	TagEnumValues="FrameIncrementPointerIsSliceVector"
	
	Name="EnergyWindowVector"   		Type="1C"	Condition="FrameIncrementPointerContainsEnergyWindowVector"
	Name="NumberOfEnergyWindows"   		Type="1"
	Name="DetectorVector"				Type="1C"	Condition="FrameIncrementPointerContainsDetectorVector"
	Name="NumberOfDetectors"			Type="1"
	Name="PhaseVector"					Type="1C"	Condition="FrameIncrementPointerContainsPhaseVector"
	Name="NumberOfPhases"				Type="1C"	Condition="FrameIncrementPointerContainsPhaseVector"
	Name="RotationVector"				Type="1C"	Condition="FrameIncrementPointerContainsRotationVector"
	Name="NumberOfRotations"			Type="1C"	Condition="ImageTypeValue3TomoFamily"
	Name="RRIntervalVector"				Type="1C"	Condition="FrameIncrementPointerContainsRRIntervalVector"
	Name="NumberOfRRIntervals"   		Type="1C"	Condition="FrameIncrementPointerContainsRRIntervalVector"
	Name="TimeSlotVector"				Type="1C"	Condition="FrameIncrementPointerContainsTimeSlotVector"
	Name="NumberOfTimeSlots"			Type="1C"	Condition="FrameIncrementPointerContainsTimeSlotVector"
	Name="SliceVector"					Type="1C"	Condition="FrameIncrementPointerContainsSliceVector"
	Name="NumberOfSlices"				Type="1C"	Condition="FrameIncrementPointerContainsSliceVector"
	Name="AngularViewVector"			Type="1C"	Condition="FrameIncrementPointerContainsAngularViewVector"
	Name="TimeSliceVector"				Type="1C"	Condition="FrameIncrementPointerContainsTimeSliceVector"
ModuleEnd

Module="NMImage"
	Name="ImageType"						Type="1"	ValueSelector="1"	StringEnumValues="NMImageTypeValue2"
	Verify="ImageType"									ValueSelector="2"	StringEnumValues="NMImageTypeValue3"
	Verify="ImageType"									ValueSelector="3"	StringEnumValues="NMImageTypeValue4"
	Verify="ImageType"								Condition="ImageTypeValue3MissingOrEmpty"	ThenErrorMessage="A value is required for value 3 in NM Images"
	Verify="ImageType"								Condition="ImageTypeValue4MissingOrEmpty"	ThenErrorMessage="A value is required for value 4 in NM Images"
	Name="ImageID"							Type="3"
	Name="LossyImageCompression"			Type="1C"	NoCondition=""	StringEnumValues="LossyImageCompression"
	Name="CountsAccumulated"				Type="2"
	Name="AcquisitionTerminationCondition"	Type="3"	StringDefinedTerms="NMAcquisitionTerminationCondition"
	Name="TableHeight"						Type="3"
	Name="TableTraverse"					Type="3"
	Name="ActualFrameDuration"				Type="1C"	Condition="ImageTypeValue3WholeBodyOrStatic"
	Name="CountRate"						Type="3"
	Name="ProcessingFunction"				Type="3"
	Name="CorrectedImage"					Type="3"	StringDefinedTerms="NMCorrectedImage"
	Name="WholeBodyTechnique"				Type="3"	StringEnumValues="NMWholeBodyTechnique"
	Name="ScanVelocity"						Type="2C"	Condition="ImageTypeValue3WholeBody"
	Name="ScanLength"						Type="2C"	Condition="ImageTypeValue3WholeBody"
	Name="TriggerSourceOrType"   			Type="3"	StringDefinedTerms="EKG"
	InvokeMacro="GeneralAnatomyOptionalMacro"
	Sequence="RealWorldValueMappingSequence"		Type="3"	VM="1-n"
		InvokeMacro="RealWorldValueMappingItemMacro"
	SequenceEnd
	Name="ScanProgressionDirection"			Type="3"	StringEnumValues="ScanProgressionDirection"
ModuleEnd
	
Module="NMIsotope"
	Sequence="EnergyWindowInformationSequence"   		Type="2"	VM="0-n"
            Name="EnergyWindowName"						Type="3"
            Sequence="EnergyWindowRangeSequence"   		Type="3"	VM="1-n"
                    Name="EnergyWindowLowerLimit"   	Type="3"
                    Name="EnergyWindowUpperLimit"   	Type="3"
	    SequenceEnd
	SequenceEnd
	Sequence="RadiopharmaceuticalInformationSequence"  	Type="2"	VM="0-n"
		Sequence="RadionuclideCodeSequence"				Type="2"	VM="0-1"
			InvokeMacro="CodeSequenceMeaningOptionalMacro"		BaselineContextID="18"
	    SequenceEnd
		Name="RadiopharmaceuticalRoute"					Type="3"
		Sequence="AdministrationRouteCodeSequence"		Type="3"	VM="1"
			InvokeMacro="CodeSequenceMeaningOptionalMacro"		BaselineContextID="11"
	    SequenceEnd
		Name="RadiopharmaceuticalVolume"				Type="3"
		Name="RadiopharmaceuticalStartTime"				Type="3"
		Name="RadiopharmaceuticalStopTime"				Type="3"
		Name="RadionuclideTotalDose"					Type="3"
		Sequence="CalibrationDataSequence"				Type="3"	VM="1-n"
			Name="EnergyWindowNumber"					Type="1"
			Name="SyringeCounts"						Type="3"
			Name="ResidualSyringeCounts"				Type="3"
	    SequenceEnd
		Name="Radiopharmaceutical"						Type="3"
		Sequence="RadiopharmaceuticalCodeSequence"		Type="3"	VM="1"
			InvokeMacro="CodeSequenceMeaningOptionalMacro"		BaselineContextID="25"
	    SequenceEnd
	SequenceEnd
	Sequence="InterventionDrugInformationSequence"   	Type="3"	VM="1-n"
		Name="InterventionDrugName"						Type="3"
		Sequence="InterventionDrugCodeSequence"   		Type="3"	VM="1"
			InvokeMacro="CodeSequenceMeaningOptionalMacro"		BaselineContextID="10"
	    SequenceEnd
		Sequence="AdministrationRouteCodeSequence"		Type="3"	VM="1"
			InvokeMacro="CodeSequenceMeaningOptionalMacro"		BaselineContextID="11"
	    SequenceEnd
		Name="InterventionDrugStartTime"				Type="3"
		Name="InterventionDrugStopTime"					Type="3"
		Name="InterventionDrugDose"						Type="3"
	SequenceEnd
ModuleEnd

Module="NMDetector"
	Sequence="DetectorInformationSequence"   	Type="2"	VM="0-n"
		Name="CollimatorGridName"   			Type="3"
		Name="CollimatorType"   				Type="2"	StringDefinedTerms="NMCollimatorType"
		Name="FieldOfViewShape"   				Type="3"	StringDefinedTerms="NMFieldOfViewShape"
		Name="FieldOfViewDimensions"   			Type="3"
		Name="FocalDistance"					Type="3"
		Name="XFocusCenter"						Type="3"
		Name="YFocusCenter"						Type="3"
		Name="ZoomCenter"						Type="3"
		Name="ZoomFactor"						Type="3"
		Name="CenterOfRotationOffset"   		Type="3"
		Name="GantryDetectorTilt"   			Type="3"
		Name="DistanceSourceToDetector"   		Type="2C"	Condition="ImageTypeValue4TransmissionAndNotTomo"
		Name="StartAngle"						Type="3"
		Name="RadialPosition"   				Type="3"
		Name="ImageOrientationPatient"   		Type="2"
		Name="ImagePositionPatient"   			Type="2"
		Sequence="ViewCodeSequence"   			Type="3"	VM="1"
			InvokeMacro="CodeSequenceMeaningOptionalMacro"		BaselineContextID="26"
			Sequence="ViewModifierCodeSequence" Type="2C"	VM="0-1"	NoCondition=""	# if needed to fully specify the view
				InvokeMacro="CodeSequenceMeaningOptionalMacro"	BaselineContextID="23"
			SequenceEnd
		SequenceEnd
	SequenceEnd
ModuleEnd

Module="NMTomoAcquisition"
	Sequence="RotationInformationSequence"  Type="2"	VM="0-n"
		Name="StartAngle"   				Type="1"
		Name="AngularStep"   				Type="1"
		Name="RotationDirection"   			Type="1"	StringEnumValues="RotationDirection"
		Name="ScanArc"   					Type="1"
		Name="ActualFrameDuration"   		Type="1"
		Name="RadialPosition"   			Type="3"
		Name="DistanceSourceToDetector"  	Type="2C"	Condition="ImageTypeValue4Transmission"
		Name="NumberOfFramesInRotation"   	Type="1"
		Name="TableTraverse"   				Type="3"
		Name="TableHeight"   				Type="3"
	SequenceEnd
	Name="TypeOfDetectorMotion"   			Type="3"	StringEnumValues="NMTypeOfDetectorMotion"
ModuleEnd

Module="NMMultiGatedAcquisition"
	Name="BeatRejectionFlag"						Type="3"	StringEnumValues="YesNoLetter"
	Name="PVCRejection"								Type="3"
	Name="SkipBeats"								Type="3"
	Name="HeartRate"								Type="3"
	Sequence="GatedInformationSequence"   			Type="2C"	VM="0-n"	Condition="FrameIncrementPointerContainsRRIntervalVector"
		Name="TriggerTime"							Type="3"
		Name="CardiacFramingType"					Type="3"
		Sequence="DataInformationSequence"   		Type="2"	VM="0-n"
			Name="FrameTime"						Type="1"
			Name="NominalInterval"					Type="3"
			Name="LowRRValue"						Type="3"
			Name="HighRRValue"						Type="3"
			Name="IntervalsAcquired"				Type="3"
			Name="IntervalsRejected"				Type="3"
			Sequence="TimeSlotInformationSequence"  Type="2C"	VM="0-n"	Condition="FrameIncrementPointerContainsTimeSlotVector"
				Name="TimeSlotTime"					Type="3"
			SequenceEnd
	    SequenceEnd
	SequenceEnd
ModuleEnd

Module="NMPhase"
	Sequence="PhaseInformationSequence"   	Type="2C"	VM="0-n"	Condition="FrameIncrementPointerContainsPhaseVector"
		Name="PhaseDelay"					Type="1"
		Name="ActualFrameDuration"			Type="1"
		Name="PauseBetweenFrames"			Type="1"
		Name="NumberOfFramesInPhase"		Type="1"
		Name="TriggerVector"				Type="3"
		Name="NumberOfTriggersInPhase"   	Type="1C"	Condition="TriggerVectorIsPresent"
		Name="PhaseDescription"				Type="3"	StringDefinedTerms="NMPhaseDescription"
	SequenceEnd
ModuleEnd

Module="NMReconstruction"
	Name="SpacingBetweenSlices"   		Type="2"
	Name="ReconstructionDiameter"   	Type="3"	NotZeroWarning=""
	Name="ConvolutionKernel"			Type="3"
	Name="SliceThickness"				Type="2"	NotZeroWarning=""
	Name="SliceLocation"				Type="3"
	Name="SliceProgressionDirection"	Type="3"	StringEnumValues="CardiacSliceProgressionDirection"
ModuleEnd

Module="USRegionCalibration"
	Sequence="SequenceOfUltrasoundRegions"			Type="1"	VM="1-n"
		Name="RegionLocationMinX0"					Type="1"
		Name="RegionLocationMinY0"					Type="1"
		Name="RegionLocationMaxX1"					Type="1"
		Name="RegionLocationMaxY1"					Type="1"
		Name="PhysicalUnitsXDirection"				Type="1"
		Name="PhysicalUnitsYDirection"				Type="1"
		Name="PhysicalDeltaX"						Type="1"
		Name="PhysicalDeltaY"						Type="1"
		Name="ReferencePixelX0"						Type="3"
		Name="ReferencePixelY0"						Type="3"
		Name="ReferencePixelPhysicalValueX"			Type="3"
		Name="ReferencePixelPhysicalValueY"			Type="3"
		Name="RegionSpatialFormat"					Type="1"	BinaryEnumValues="RegionSpatialFormat"
		Name="RegionDataType"						Type="1"	BinaryEnumValues="RegionDataType"
		Name="RegionFlags"							Type="1"	BinaryBitMap="RegionFlags"
		Name="PixelComponentOrganization"			Type="1C"	Condition="NeedPixelComponentOrganization"	BinaryEnumValues="PixelComponentOrganization"
		Name="PixelComponentMask"					Type="1C"	Condition="PixelComponentOrganizationIs0"
		Name="PixelComponentRangeStart"				Type="1C"	Condition="PixelComponentOrganizationIs1"
		Name="PixelComponentRangeStop"				Type="1C"	Condition="PixelComponentOrganizationIs1"
		Name="PixelComponentPhysicalUnits"			Type="1C"	Condition="PixelComponentOrganizationPresent"	BinaryEnumValues="PixelComponentPhysicalUnits"
		Name="PixelComponentDataType"				Type="1C"	Condition="PixelComponentOrganizationPresent"	BinaryEnumValues="PixelComponentDataType"
		Name="NumberOfTableBreakPoints"				Type="1C"	Condition="PixelComponentOrganizationIs0Or1"
		Name="TableOfXBreakPoints"					Type="1C"	Condition="PixelComponentOrganizationIs0Or1"
		Name="TableOfYBreakPoints"					Type="1C"	Condition="PixelComponentOrganizationIs0Or1"
		Name="NumberOfTableEntries"					Type="1C"	Condition="PixelComponentOrganizationIs2Or3"
		Name="TableOfPixelValues"					Type="1C"	Condition="PixelComponentOrganizationIs2"
		Name="TableOfParameterValues"				Type="1C"	Condition="PixelComponentOrganizationIs2"
		Sequence="PixelValueMappingCodeSequence"	Type="1C"	VM="1-n"	Condition="PixelComponentOrganizationIs3"
			InvokeMacro="CodeSequenceMacro"			BaselineContextID="3497"
		SequenceEnd
		Name="TransducerFrequency"					Type="3"
		Name="PulseRepetitionFrequency"				Type="3"
		Name="DopplerCorrectionAngle"				Type="3"
		Name="SteeringAngle"						Type="3"
		Name="DopplerSampleVolumeXPosition"			Type="3"
		Name="DopplerSampleVolumeYPosition"			Type="3"
		Name="TMLinePositionX0"						Type="3"
		Name="TMLinePositionY0"						Type="3"
		Name="TMLinePositionX1"						Type="3"
		Name="TMLinePositionY1"						Type="3"
		Name="ActiveImageAreaOverlayGroup"			Type="3"
	SequenceEnd
ModuleEnd

Module="USImage"
	Name="SamplesPerPixel"							Type="1"	NotZeroError=""
	Verify="SamplesPerPixel"									Condition="PhotometricInterpretationNeedsOneSample"	BinaryEnumValues="SamplesPerPixelIsOne"
	Verify="SamplesPerPixel"									Condition="PhotometricInterpretationNeedsThreeSamples"	BinaryEnumValues="SamplesPerPixelIsThree"
	Name="PhotometricInterpretation"				Type="1"	StringDefinedTerms="USPhotometricInterpretation"

	Verify="PhotometricInterpretation"				Condition="UncompressedTransferSyntaxAndThreeSamples"					StringEnumValues="PhotometricInterpretationRGB"
	Verify="PhotometricInterpretation"				Condition="JPEGLSLosslessTransferSyntaxAndThreeSamples"					StringEnumValues="PhotometricInterpretationRGB"
	Verify="PhotometricInterpretation"				Condition="JPEG2000TransferSyntaxAndThreeSamples"						StringEnumValues="PhotometricInterpretationYBRRCTOrICT"
	Verify="PhotometricInterpretation"				Condition="JPEG2000LosslessTransferSyntaxAndThreeSamples"				StringEnumValues="PhotometricInterpretationYBRRCT"
	Verify="PhotometricInterpretation"				Condition="MPEG2TransferSyntax"											StringEnumValues="PhotometricInterpretationYBRPartial420"	# regardless of number of samples (required to be 3 by PS 3.5)
	Verify="PhotometricInterpretation"				Condition="JPEGLossyTransferSyntaxAndThreeSamples"						StringEnumValues="PhotometricInterpretationYBRFull422"
	Verify="PhotometricInterpretation"				Condition="RLETransferSyntaxAndThreeSamples"							StringEnumValues="PhotometricInterpretationYBRFullOrRGB"

	Name="BitsAllocated"							Type="1"	NotZeroError=""
	Verify="BitsAllocated"										Condition="US8BitSamples"	BinaryEnumValues="BitsAre8"
	Verify="BitsAllocated"										Condition="US8Or16BitSamples"	BinaryEnumValues="BitsAre8Or16"
	Name="BitsStored"								Type="1"	NotZeroError=""
	Verify="BitsStored"											Condition="US8BitSamples"	BinaryEnumValues="BitsAre8"
	Verify="BitsStored"											Condition="US8Or16BitSamples"	BinaryEnumValues="BitsAre8Or16"
	Name="HighBit"									Type="1"
	Verify="HighBit"											Condition="US8BitSamples"	BinaryEnumValues="BitsAre7"
	Verify="HighBit"											Condition="US8Or16BitSamples"	BinaryEnumValues="BitsAre7Or15"
	Name="PlanarConfiguration"						Type="1C"	Condition="SamplesPerPixelGreaterThanOne"	BinaryEnumValues="USPlanarConfiguration"
	Verify="PlanarConfiguration"								Condition="USNeedsColorByPlaneOrPixel"	BinaryEnumValues="PlanarConfigurationIsColorByPlaneOrPixel"
	Verify="PlanarConfiguration"								Condition="USNeedsColorByPixel"		BinaryEnumValues="PlanarConfigurationIsColorByPixel"
	Verify="PlanarConfiguration"								Condition="USNeedsColorByPlane"		BinaryEnumValues="PlanarConfigurationIsColorByPlane"
	Name="PixelRepresentation"						Type="1"	BinaryEnumValues="PixelRepresentationUnsigned"
	Name="FrameIncrementPointer"					Type="1C"	Condition="NumberOfFramesPresent"
	Name="ImageType"								Type="2"  	ValueSelector="2"	StringDefinedTerms="USImageType3"
	Verify="ImageType"											ValueSelector="3"	StringDefinedTerms="USImageType4"
	Name="LossyImageCompression"					Type="1C"	NoCondition=""	StringEnumValues="LossyImageCompression"
	Name="NumberOfStages"							Type="2C"	Condition="IsUltrasoundStageProtocol"
	Name="NumberOfViewsInStage"						Type="2C"	Condition="IsUltrasoundStageProtocol"
	Name="RWaveTimeVector"							Type="3"
	Name="UltrasoundColorDataPresent"				Type="3"	BinaryEnumValues="UltrasoundColorDataPresent"
	Name="StageName"								Type="3"	StringDefinedTerms="USStageName"
	Sequence="StageCodeSequence"					Type="3"	VM="1-n"
 		InvokeMacro="CodeSequenceMacro"				BaselineContextID="12002"
	SequenceEnd
	Name="StageNumber"								Type="3"
	Name="ViewName"									Type="3"
	Name="ViewNumber"								Type="3"
	Name="NumberOfEventTimers"						Type="3"
	Name="EventElapsedTimes"						Type="3"
	Name="EventTimerNames"							Type="3"
	InvokeMacro="GeneralAnatomyOptionalMacro"
	InvokeMacro="OptionalViewAndSliceProgressionDirectionMacro"
	Name="AcquisitionDateTime"						Type="1C"	Condition="ModalityIsIVUS" mbpo="true"
	Name="TriggerTime"								Type="3"
	Name="NominalInterval"							Type="3"
	Name="BeatRejectionFlag"						Type="3"	StringEnumValues="YesNoLetter"
	Name="LowRRValue"								Type="3"
	Name="HighRRValue"								Type="3"
	Name="HeartRate"								Type="3"
	Name="IVUSAcquisition"							Type="1C"	Condition="ModalityIsIVUS"	StringDefinedTerms="IVUSAcquisition"
	Name="IVUSPullbackRate"							Type="1C"	Condition="IVUSAcquisitionIsMotor"
	Name="IVUSGatedRate"							Type="1C"	Condition="IVUSAcquisitionIsGated"
	Name="IVUSPullbackStartFrameNumber"				Type="1C"	Condition="IVUSAcquisitionIsMotorOrGated"	NotZeroError=""
	Name="IVUSPullbackStopFrameNumber"				Type="1C"	Condition="IVUSAcquisitionIsMotorOrGated"	NotZeroError=""
	Name="LesionNumber"								Type="3"
	Name="OutputPower"								Type="3"
	Name="TransducerData"							Type="3"
	Sequence="TransducerIdentificationSequence"		Type="3"	VM="1"
		InvokeMacro="DeviceIdentificationMacro"
	SequenceEnd
	Name="TransducerType"							Type="3"	StringDefinedTerms="USTransducerType"
	Name="FocusDepth"								Type="3"
	Name="ProcessingFunction"						Type="3"
	Name="MechanicalIndex"							Type="3"
	Name="BoneThermalIndex"							Type="3"
	Name="CranialThermalIndex"						Type="3"
	Name="SoftTissueThermalIndex"					Type="3"
	Name="SoftTissueFocusThermalIndex"				Type="3"
	Name="SoftTissueSurfaceThermalIndex"			Type="3"
	Name="DepthOfScanField"							Type="3"
	Name="OverlaySubtype"							Type="3"	StringDefinedTerms="OverlaySubtypeUS"
ModuleEnd

Module="SCEquipment"
	Name="ConversionType"								Type="1"	StringDefinedTerms="ConversionType"
	Name="Modality"										Type="3"	StringDefinedTerms="Modality"
	Name="SecondaryCaptureDeviceID"						Type="3"
	Name="SecondaryCaptureDeviceManufacturer"			Type="3"
	Name="SecondaryCaptureDeviceManufacturerModelName"	Type="3"
	Name="SecondaryCaptureDeviceSoftwareVersions"		Type="3"
	Name="VideoImageFormatAcquired"						Type="3"
	Name="DigitalImageFormatAcquired"					Type="3"
ModuleEnd

Module="SCImage"
	Name="DateOfSecondaryCapture"						Type="3"
	Name="TimeOfSecondaryCapture"						Type="3"
	Name="NominalScannedPixelSpacing"					Type="3"	NotZeroError=""
	Sequence="DocumentClassCodeSequence"				Type="3"	VM="1-n"
		InvokeMacro="CodeSequenceMacro"
	SequenceEnd
	InvokeMacro="BasicPixelSpacingCalibrationMacro"
	InvokeMacro="OptionalViewAndSliceProgressionDirectionMacro"
ModuleEnd

Module="SCMultiFrameImage"
	Name="BurnedInAnnotation"							Type="1"	StringEnumValues="YesNoFull"
	Name="RecognizableVisualFeatures"					Type="3"	StringEnumValues="YesNoFull"
	Name="PresentationLUTShape"							Type="1C"	StringEnumValues="SecondaryCapturePresentationLUTShape"	Condition="MonochromeNotBitmapPhotometricInterpretation"
	Name="Illumination"									Type="3"
	Name="ReflectedAmbientLight"						Type="3"
	Name="RescaleIntercept"								Type="1C"	Condition="MonochromeNotBitmapPhotometricInterpretation"
	Name="RescaleSlope"									Type="1C"	Condition="MonochromeNotBitmapPhotometricInterpretation"
	Name="RescaleType"									Type="1C"	StringDefinedTerms="RescaleTypeUnspecified"	Condition="MonochromeNotBitmapPhotometricInterpretation"
	Name="FrameIncrementPointer"						Type="1C"	Condition="NumberOfFramesGreaterThanOne"
	Name="NominalScannedPixelSpacing"					Type="1C"	Condition="ConversionTypeDigitizedFilm"	mbpo="true" NotZeroError=""
	Verify="NominalScannedPixelSpacing"								Condition="NominalScannedPixelSpacingPresentAndConversionTypeNotDigitizedFilmScannedDocumentScannedImage" ThenErrorMessage="Shall not be present unless ConversionType is DF, SD or SI"
	InvokeMacro="BasicPixelSpacingCalibrationMacro"
	Name="DigitizingDeviceTransportDirection"			Type="3"	StringEnumValues="TransportDirection"
	Name="RotationOfScannedFilm"						Type="3"
ModuleEnd

Module="SCMultiFrameVector"
	Name="FrameTimeVector"								Type="1C"	Condition="FrameIncrementPointerContainsFrameTimeVector"
	Name="PageNumberVector"								Type="1C"	Condition="FrameIncrementPointerContainsPageNumberVector"
	Name="FrameLabelVector"								Type="1C"	Condition="FrameIncrementPointerContainsFrameLabelVector"
	Name="FramePrimaryAngleVector"						Type="1C"	Condition="FrameIncrementPointerContainsFramePrimaryAngleVector"
	Name="FrameSecondaryAngleVector"					Type="1C"	Condition="FrameIncrementPointerContainsFrameSecondaryAngleVector"
	Name="SliceLocationVector"							Type="1C"	Condition="FrameIncrementPointerContainsSliceLocationVector"
	Name="DisplayWindowLabelVector"						Type="1C"	Condition="FrameIncrementPointerContainsDisplayWindowLabelVector"
ModuleEnd

Module="MultiFrameFunctionalGroupsForMFSC"
	Sequence="SharedFunctionalGroupsSequence"	Type="1"	VM="1"
		InvokeMacro="PixelMeasuresMacro"		Condition="PixelMeasuresSequenceNotInPerFrameFunctionalGroupSequenceAndPlanePositionSequenceOrPlaneOrientationSequencePresent"
		InvokeMacro="PlanePositionMacro"		Condition="PlanePositionSequenceNotInPerFrameFunctionalGroupSequenceAndPixelMeasuresSequenceOrPlaneOrientationSequencePresent"
		InvokeMacro="PlaneOrientationMacro"		Condition="PlaneOrientationSequenceNotInPerFrameFunctionalGroupSequenceAndPixelMeasuresSequenceOrPlanePositionSequencePresent"
	SequenceEnd
	Sequence="PerFrameFunctionalGroupsSequence"	Type="1"	VM="1-n"
		InvokeMacro="PixelMeasuresMacro"		Condition="PixelMeasuresSequenceNotInSharedFunctionalGroupSequenceAndPlanePositionSequenceOrPlaneOrientationSequencePresent"
		InvokeMacro="PlanePositionMacro"		Condition="PlanePositionSequenceNotInSharedFunctionalGroupSequenceAndPixelMeasuresSequenceOrPlaneOrientationSequencePresent"
		InvokeMacro="PlaneOrientationMacro"		Condition="PlaneOrientationSequenceNotInSharedFunctionalGroupSequenceAndPixelMeasuresSequenceOrPlanePositionSequencePresent"
	SequenceEnd
ModuleEnd

Module="OverlayIdentification"
	Name="OverlayNumber"								Type="2"
	Name="OverlayDate"									Type="3"
	Name="OverlayTime"									Type="3"
	Sequence="ReferencedImageSequence"					Type="3"	VM="1-n"
		Name="ReferencedSOPClassUID"					Type="1"
		Name="ReferencedSOPInstanceUID"					Type="1"
	SequenceEnd
ModuleEnd

Module="OverlayPlane"
	Name="OverlayRows"									Type="1"	NotZeroError=""
	Name="OverlayColumns"								Type="1"	NotZeroError=""
	Name="OverlayType"									Type="1"	StringEnumValues="OverlayType"
	Name="OverlayOrigin"								Type="1"
	Name="OverlayBitsAllocated"							Type="1"	BinaryEnumValues="One"
	Name="OverlayBitPosition"							Type="1"	BinaryEnumValues="Zero"
	Name="OverlayData"									Type="1"
	Name="OverlayDescription"							Type="3"
	Name="OverlaySubtype"								Type="3"	StringDefinedTerms="OverlaySubtype"
	Name="OverlayLabel"									Type="3"
	Name="ROIArea"										Type="3"
	Name="ROIMean"										Type="3"
	Name="ROIStandardDeviation"							Type="3"
ModuleEnd

Module="MultiFrameOverlay"
	Name="NumberOfFramesInOverlay"						Type="1"
	Name="ImageFrameOrigin"								Type="3"
ModuleEnd

Module="CurveIdentification"
	Name="CurveNumber"									Type="2"
	Name="CurveDate"									Type="3"
	Name="CurveTime"									Type="3"
	Sequence="ReferencedImageSequence"					Type="3"	VM="1-n"
		Name="ReferencedSOPClassUID"					Type="1"
		Name="ReferencedSOPInstanceUID"					Type="1"
	SequenceEnd
	Sequence="ReferencedOverlaySequence"				Type="3"	VM="1-n"
		Name="ReferencedSOPClassUID"					Type="1"
		Name="ReferencedSOPInstanceUID"					Type="1"
	SequenceEnd
	Sequence="ReferencedCurveSequence"					Type="3"	VM="1-n"
		Name="ReferencedSOPClassUID"					Type="1"
		Name="ReferencedSOPInstanceUID"					Type="1"
	SequenceEnd
ModuleEnd

Module="Curve"
	Name="CurveDimensions"								Type="1"
	Name="NumberOfPoints"								Type="1"
	Name="TypeOfData"									Type="1"	StringDefinedTerms="CurveTypeOfData"
	Name="DataValueRepresentation"						Type="1"	BinaryEnumValues="CurveDataValueRepresentation"
	Name="CurveData"									Type="1"
	Name="CurveDescription"								Type="3"
	Name="AxisUnits"									Type="3"	StringDefinedTerms="CurveAxisUnits"
	Name="AxisLabels"									Type="3"
	Name="MinimumCoordinateValue"						Type="3"
	Name="MaximumCoordinateValue"						Type="3"
	Name="CurveRange"									Type="3"
	Name="CurveDataDescriptor"							Type="1C"	BinaryEnumValues="CurveDataDescriptor"	Condition="Never"
	Name="CoordinateStartValue"							Type="1C"	Condition="CurveDataDescriptorPresent"
	Name="CoordinateStepValue"							Type="1C"	Condition="CurveDataDescriptorPresent"
	Name="CurveLabel"									Type="3"
	Sequence="ReferencedOverlaySequence"				Type="3"	VM="1-n"
		Name="ReferencedSOPClassUID"					Type="1"
		Name="ReferencedSOPInstanceUID"					Type="1"
		Name="CurveReferencedOverlayGroup"				Type="1"
	SequenceEnd
ModuleEnd

Module="Audio"
	Name="AudioType"									Type="1"	BinaryEnumValues="AudioType"
	Name="AudioSampleFormat"							Type="1"	BinaryEnumValues="AudioSampleFormat"
	Name="NumberOfChannels"								Type="1"	BinaryEnumValues="NumberOfChannels"
	Name="NumberOfSamples"								Type="1"
	Name="SampleRate"									Type="1"
	Name="TotalTime"									Type="1"
	Name="AudioSampleData"								Type="1"
	Sequence="ReferencedImageSequence"					Type="3"	VM="1-n"
		Name="ReferencedSOPClassUID"					Type="1"
		Name="ReferencedSOPInstanceUID"					Type="1"
	SequenceEnd
	Name="AudioComments"
ModuleEnd

DefineMacro="ModalityLUTMacro"	InformationEntity="Frame"
	Sequence="ModalityLUTSequence"						Type="1C"	VM="1"	Condition="RescaleInterceptNotPresent"
		Name="LUTDescriptor"							Type="1"
		Verify="LUTDescriptor"										ValueSelector="2"	BinaryEnumValues="BitsAre8Or16"
		Name="LUTExplanation"							Type="3"
		Name="ModalityLUTType"							Type="1"	StringDefinedTerms="ModalityLUTType"
		Name="LUTData"									Type="1"
	SequenceEnd
	Name="RescaleIntercept"								Type="1C"	Condition="ModalityLUTSequenceNotPresent"
	Name="RescaleSlope"									Type="1C"	Condition="RescaleInterceptPresent"	NotZeroError=""
	Name="RescaleType"									Type="1C"	Condition="RescaleInterceptPresent"	StringDefinedTerms="ModalityLUTType"
	Verify="PhotometricInterpretation"					Condition="PhotometricInterpretationIsGrayscaleOrAbsent"	ElseWarningMessage="Modality LUT Module (RescaleSlope and RescaleIntercept) not appropriate for non-grayscale images" ShowValueWithMessage="true"
MacroEnd

Module="ModalityLUT"
	InvokeMacro="ModalityLUTMacro"
ModuleEnd

DefineMacro="VOILUTMacro"	InformationEntity="Frame"
	Sequence="VOILUTSequence"							Type="1C"	VM="1-n"	Condition="MonochromeAndWindowCenterNotPresent" mbpo="true"
		Name="LUTDescriptor"							Type="1"
		Verify="LUTDescriptor"										Condition="VOILUTSequenceLUTDescriptorRequiredToBe8Or16"	ValueSelector="2"	BinaryEnumValues="BitsAre8Or16"
		Name="LUTExplanation"							Type="3"
		Name="LUTData"									Type="1"
	SequenceEnd
	Name="WindowCenter"									Type="1C"	Condition="MonochromeAndVOILUTSequenceNotPresent" mbpo="true"
	Name="WindowWidth"									Type="1C"	Condition="WindowCenterPresent"	NotZeroError=""
	Verify="WindowWidth"											Condition="WindowWidthIsNegative"	ThenErrorMessage="Not permitted to be negative" ShowValueWithMessage="true"
	Verify="WindowWidth"											Condition="WindowWidthIsLessThanOneAndNotExact"	ThenErrorMessage="Not permitted to be < 1 unless VOILUTFunction is LINEAR_EXACT or SIGMOID" ShowValueWithMessage="true"
	Verify="WindowWidth"											Condition="WindowWidthIsZeroAndSigmoid"	ThenErrorMessage="Not permitted to be 0 when VOILUTFunction is SIGMOID" ShowValueWithMessage="true"
	Name="WindowCenterWidthExplanation"					Type="3"
	Name="VOILUTFunction"								Type="3"	StringDefinedTerms="VOILUTFunction"
	Verify="PhotometricInterpretation"					Condition="PhotometricInterpretationIsGrayscaleOrAbsent"	ElseWarningMessage="VOI LUT Module (WindowCenter and WindowWidth) not appropriate for non-grayscale images" ShowValueWithMessage="true"
ModuleEnd

Module="VOILUT"
	InvokeMacro="VOILUTMacro"
ModuleEnd

Module="LUTIdentification"
	Name="LUTNumber"									Type="2"
	Sequence="ReferencedImageSequence"					Type="3"	VM="1-n"
		Name="ReferencedSOPClassUID"					Type="1"
		Name="ReferencedSOPInstanceUID"					Type="1"
	SequenceEnd
ModuleEnd

DefineMacro="DigitalSignaturesMacro"	InformationEntity="Instance"
	Sequence="MACParametersSequence"					Type="3"	VM="1-n"
		Name="MACIDNumber"								Type="1"
		Name="MACCalculationTransferSyntaxUID"			Type="1"
		Name="MACAlgorithm"								Type="1"	StringDefinedTerms="MACAlgorithm"
		Name="DataElementsSigned"						Type="1"
	SequenceEnd
	Sequence="DigitalSignaturesSequence"				Type="3"	VM="1-n"
		Name="MACIDNumber"								Type="1"
		Name="DigitalSignatureUID"						Type="1"
		Name="DigitalSignatureDateTime"					Type="1"
		Name="CertificateType"							Type="1"	StringDefinedTerms="CertificateType"
		Name="CertificateOfSigner"						Type="1"
		Name="Signature"								Type="1"
		Name="CertifiedTimestampType"					Type="1C"	Condition="CertifiedTimestampIsPresent"	StringDefinedTerms="CertifiedTimestampType"
		Name="CertifiedTimestamp"						Type="3"
		Sequence="DigitalSignaturePurposeCodeSequence"	Type="3"	VM="1"
			InvokeMacro="CodeSequenceMacro"							BaselineContextID="7007"
		SequenceEnd
	SequenceEnd
MacroEnd

Module="SOPCommon"
	Name="SOPClassUID"									Type="1"
	Name="SOPInstanceUID"								Type="1"
	Name="SpecificCharacterSet"							Type="1C"	NoCondition=""	StringDefinedTerms="SpecificCharacterSet"
	Name="InstanceCreationDate"							Type="3"
	Name="InstanceCreationTime"							Type="3"
	Name="InstanceCoercionDateTime"						Type="3"
	Name="InstanceCreatorUID"							Type="3"
	Name="RelatedGeneralSOPClassUID"					Type="3"
	Name="OriginalSpecializedSOPClassUID"				Type="3"
	Name="SyntheticData"								Type="3"
	Sequence="CodingSchemeIdentificationSequence"		Type="3"	VM="1-n"
		Name="CodingSchemeDesignator"					Type="1"	StringDefinedTerms="MiscellaneousCodingSchemeDesignators"
		Name="CodingSchemeRegistry"						Type="1C"	NoCondition=""	StringDefinedTerms="CodingSchemeRegistries"
		Name="CodingSchemeUID"							Type="1C"	NoCondition=""	StringDefinedTerms="MiscellaneousCodingSchemeUIDs"
		Verify="CodingSchemeUID"						Condition="CodingSchemeDesignatorIsACR"				StringEnumValues="CodingSchemeUIDForACR"
		Verify="CodingSchemeUID"						Condition="CodingSchemeDesignatorIsASTMSigpurpose"	StringEnumValues="CodingSchemeUIDForASTMSigpurpose"
		Verify="CodingSchemeUID"						Condition="CodingSchemeDesignatorIsC4"				StringEnumValues="CodingSchemeUIDForC4"
		Verify="CodingSchemeUID"						Condition="CodingSchemeDesignatorIsC5"				StringEnumValues="CodingSchemeUIDForC5"
		Verify="CodingSchemeUID"						Condition="CodingSchemeDesignatorIsCD2"				StringEnumValues="CodingSchemeUIDForCD2"
		Verify="CodingSchemeUID"						Condition="CodingSchemeDesignatorIsCTV3"			StringEnumValues="CodingSchemeUIDForCTV3"
		Verify="CodingSchemeUID"						Condition="CodingSchemeDesignatorIsDCM"				StringEnumValues="CodingSchemeUIDForDCM"
		Verify="CodingSchemeUID"						Condition="CodingSchemeDesignatorIsDCMUID"			StringEnumValues="CodingSchemeUIDForDCMUID"
		Verify="CodingSchemeUID"						Condition="CodingSchemeDesignatorIsHPC"				StringEnumValues="CodingSchemeUIDForHPC"
		Verify="CodingSchemeUID"						Condition="CodingSchemeDesignatorIsI10"				StringEnumValues="CodingSchemeUIDForI10"
		Verify="CodingSchemeUID"						Condition="CodingSchemeDesignatorIsI10P"			StringEnumValues="CodingSchemeUIDForI10P"
		Verify="CodingSchemeUID"						Condition="CodingSchemeDesignatorIsI9"				StringEnumValues="CodingSchemeUIDForI9"
		Verify="CodingSchemeUID"						Condition="CodingSchemeDesignatorIsI9C"				StringEnumValues="CodingSchemeUIDForI9C"
		Verify="CodingSchemeUID"						Condition="CodingSchemeDesignatorIsISO3166_1"		StringEnumValues="CodingSchemeUIDForISO3166_1"
		Verify="CodingSchemeUID"						Condition="CodingSchemeDesignatorIsISO639_1"		StringEnumValues="CodingSchemeUIDForISO639_1"
		Verify="CodingSchemeUID"						Condition="CodingSchemeDesignatorIsISO639_2"		StringEnumValues="CodingSchemeUIDForISO639_2"
		Verify="CodingSchemeUID"						Condition="CodingSchemeDesignatorIsLN"				StringEnumValues="CodingSchemeUIDForLN"
		Verify="CodingSchemeUID"						Condition="CodingSchemeDesignatorIsPOS"				StringEnumValues="CodingSchemeUIDForPOS"
		Verify="CodingSchemeUID"						Condition="CodingSchemeDesignatorIsRFC3066"			StringEnumValues="CodingSchemeUIDForRFC3066"
		Verify="CodingSchemeUID"						Condition="CodingSchemeDesignatorIsSNM3"			StringEnumValues="CodingSchemeUIDForSNM3"
		Verify="CodingSchemeUID"						Condition="CodingSchemeDesignatorIsSCT"				StringEnumValues="CodingSchemeUIDForSCT"
		Verify="CodingSchemeUID"						Condition="CodingSchemeDesignatorIsSRT"				StringEnumValues="CodingSchemeUIDForSRT"
		Verify="CodingSchemeUID"						Condition="CodingSchemeDesignatorIsUCUM"			StringEnumValues="CodingSchemeUIDForUCUM"
		Verify="CodingSchemeUID"						Condition="CodingSchemeDesignatorIsUMLS"			StringEnumValues="CodingSchemeUIDForUMLS"
		Verify="CodingSchemeUID"						Condition="CodingSchemeDesignatorIsUPC"				StringEnumValues="CodingSchemeUIDForUPC"
		Name="CodingSchemeExternalID"					Type="2C"	NoCondition=""
		Name="CodingSchemeName"							Type="3"
		Name="CodingSchemeVersion"						Type="3"
		Name="CodingSchemeResponsibleOrganization"		Type="3"
		Sequence="CodingSchemeResourcesSequence"		Type="3"	VM="1-n"
			Name="CodingSchemeURLType"					Type="1"	StringDefinedTerms="CodingSchemeURLType"
			Name="CodingSchemeURL"						Type="1"
		SequenceEnd
	SequenceEnd
	Sequence="ContextGroupIdentificationSequence"		Type="3"	VM="1-n"
		Name="ContextIdentifier"						Type="1"
		Name="ContextUID"								Type="3"
		Name="MappingResource"							Type="1"	StringDefinedTerms="MappingResources"
		Name="ContextGroupVersion"						Type="1"
	SequenceEnd
	Sequence="MappingResourceIdentificationSequence"	Type="3"	VM="1-n"
		Name="MappingResource"							Type="1"	StringDefinedTerms="MappingResources"
		Name="MappingResourceUID"						Type="3"	StringDefinedTerms="MappingResourceUIDs"
		Name="MappingResourceName"						Type="3"	StringDefinedTerms="MappingResourceNames"
	SequenceEnd
	Name="TimezoneOffsetFromUTC"						Type="3"
	Sequence="ContributingEquipmentSequence"			Type="3"	VM="1-n"
		Sequence="PurposeOfReferenceCodeSequence"		Type="1"	VM="1"
			InvokeMacro="CodeSequenceMacro"							DefinedContextID="7005"
		SequenceEnd
		Name="Manufacturer"								Type="1"
		Name="InstitutionName"							Type="3"
		Name="InstitutionAddress"						Type="3"
		Name="StationName"								Type="3"
		Name="InstitutionalDepartmentName"				Type="3"
		Sequence="InstitutionalDepartmentTypeCodeSequence"	Type="3"	VM="1"
			InvokeMacro="CodeSequenceMacro"								BaselineContextID="7030"
		SequenceEnd
		Name="OperatorsName"							Type="3"
		Sequence="OperatorIdentificationSequence"		Type="3"	VM="1-n"
			InvokeMacro="PersonIdentificationMacro"
		SequenceEnd
		Name="ManufacturerModelName"					Type="3"
		Name="DeviceSerialNumber"						Type="3"
		Name="SoftwareVersions"							Type="3"
		Name="DateOfManufacture"						Type="3"
		Name="DateOfInstallation"						Type="3"
		Name="SpatialResolution"						Type="3"
		Name="DateOfLastCalibration"					Type="3"
		Name="TimeOfLastCalibration"					Type="3"
		Name="ContributionDateTime"						Type="3"
		Name="ContributionDescription"					Type="3"
	SequenceEnd
	Name="InstanceNumber"								Type="3"
	Name="SOPInstanceStatus"							Type="3"
	Name="SOPAuthorizationDateTime"						Type="3"
	Name="SOPAuthorizationComment"						Type="3"
	Name="AuthorizationEquipmentCertificationNumber"	Type="3"
	InvokeMacro="DigitalSignaturesMacro"
	Sequence="EncryptedAttributesSequence"				Type="1C"	VM="1-n"	NoCondition=""
		Name="EncryptedContentTransferSyntaxUID"		Type="1"
		Name="EncryptedContent"							Type="1"
	SequenceEnd
	Sequence="OriginalAttributesSequence"				Type="3"	VM="1-n"
		Name="SourceOfPreviousValues"					Type="2"
		Name="AttributeModificationDateTime"			Type="1"
		Name="ModifyingSystem"							Type="1"
		Name="ReasonForTheAttributeModification"		Type="1"
		Sequence="ModifiedAttributesSequence"			Type="1"	VM="1"
		SequenceEnd
		Sequence="NonconformingModifiedAttributesSequence"	Type="3"	VM="1"
			InvokeMacro="SelectorAttributeMacro"
			Name="NonconformingDataElementValue"		Type="1"
		SequenceEnd
	SequenceEnd
	Sequence="HL7StructuredDocumentReferenceSequence"	Type="1C"	VM="1-n"	NoCondition=""
		Name="ReferencedSOPClassUID"					Type="1"
		Name="ReferencedSOPInstanceUID"					Type="1"
		Name="HL7InstanceIdentifier"					Type="1"
		Name="RetrieveURI"								Type="1"
	SequenceEnd
	Name="LongitudinalTemporalInformationModified"		Type="3"	StringEnumValues="LongitudinalTemporalInformationModified"
	Name="QueryRetrieveView"							Type="1C"	NoCondition=""	StringEnumValues="QueryRetrieveView"
	Sequence="ConversionSourceAttributesSequence"		Type="1C"	VM="1-n"	NoCondition=""
		InvokeMacro="ImageSOPInstanceReferenceMacro"
	SequenceEnd
	Name="ContentQualification"							Type="3"	StringEnumValues="ContentQualification"
	Sequence="PrivateDataElementCharacteristicsSequence"	Type="3"	VM="1-n"
		Name="PrivateGroupReference"						Type="1"
		Name="PrivateCreatorReference"						Type="1"
		Sequence="PrivateDataElementDefinitionSequence"		Type="3"	VM="1-n"
			Name="PrivateDataElement"						Type="1"
			Name="PrivateDataElementValueMultiplicity"		Type="1"
			Name="PrivateDataElementValueRepresentation"	Type="1"	StringEnumValues="ValueRepresentations"
			Name="PrivateDataElementNumberOfItems"			Type="1C"	Condition="PrivateDataElementValueRepresentationIsSequence"
			Name="PrivateDataElementKeyword"				Type="1"
			Name="PrivateDataElementName"					Type="1"
			Name="PrivateDataElementDescription"			Type="3"
			Name="PrivateDataElementEncoding"				Type="3"
			Name="RetrieveURI"								Type="3"
		SequenceEnd
		Name="BlockIdentifyingInformationStatus"			Type="1"	StringEnumValues="BlockIdentifyingInformationStatus"
		Name="NonidentifyingPrivateElements"				Type="1C"	Condition="BlockIdentifyingInformationStatusIsMIXED"
		Sequence="DeidentificationActionSequence"			Type="3"	VM="1-n"
			Name="IdentifyingPrivateElements"				Type="1"
			Name="DeidentificationAction"					Type="1"	StringEnumValues="DeidentificationAction"
		SequenceEnd
	SequenceEnd
	Name="InstanceOriginStatus"							Type="3"	StringEnumValues="InstanceOriginStatus"
	Name="BarcodeValue"									Type="3"
	InvokeMacro="GeneralProcedureProtocolReferenceMacro"
ModuleEnd

Module="FrameExtraction"
	Sequence="FrameExtractionSequence"					Type="1"	VM="1-n"
		Name="MultiFrameSourceSOPInstanceUID"			Type="1"
		Name="SimpleFrameList"							Type="1C"	Condition="NeedSimpleFrameListInFrameExtractionModule"
		Name="CalculatedFrameList"						Type="1C"	Condition="NeedCalculatedFrameListInFrameExtractionModule"
		Name="TimeRange"								Type="1C"	Condition="NeedTimeRangeInFrameExtractionModule"
	SequenceEnd
ModuleEnd

Module="MultiframeSingleBitSCImagePseudo"
	Name="SamplesPerPixel"				Type="1"	BinaryEnumValues="One"
	Name="PhotometricInterpretation"	Type="1"	StringEnumValues="PhotometricInterpretationMonochrome2"
	Name="BitsAllocated"				Type="1"	BinaryEnumValues="One"
	Name="BitsStored"					Type="1"	BinaryEnumValues="One"
	Name="HighBit"						Type="1"	BinaryEnumValues="Zero"
	Name="PixelRepresentation"			Type="1"	BinaryEnumValues="Zero"
	Name="PlanarConfiguration"			Type="1C"	BinaryEnumValues="PlanarConfiguration"	Condition="Never"
ModuleEnd

Module="MultiframeGrayscaleByteSCImagePseudo"
	Name="SamplesPerPixel"				Type="1"	BinaryEnumValues="One"
	Name="PhotometricInterpretation"	Type="1"	StringEnumValues="PhotometricInterpretationMonochrome2"
	Name="BitsAllocated"				Type="1"	BinaryEnumValues="BitsAre8"
	Name="BitsStored"					Type="1"	BinaryEnumValues="BitsAre8"
	Name="HighBit"						Type="1"	BinaryEnumValues="BitsAre7"
	Name="PixelRepresentation"			Type="1"	BinaryEnumValues="Zero"
	Name="PlanarConfiguration"			Type="1C"	BinaryEnumValues="PlanarConfiguration"	Condition="Never"
 	Name="RescaleIntercept"				Type="1"	BinaryEnumValues="Zero"
 	Name="RescaleSlope"					Type="1"	BinaryEnumValues="One"
 	Name="RescaleType"					Type="1"	StringEnumValues="RescaleTypeUnspecified"
ModuleEnd

Module="MultiframeGrayscaleWordSCImagePseudo"
	Name="SamplesPerPixel"				Type="1"	BinaryEnumValues="One"
	Name="PhotometricInterpretation"	Type="1"	StringEnumValues="PhotometricInterpretationMonochrome2"
	Name="BitsAllocated"				Type="1"	BinaryEnumValues="BitsAre16"
	Name="BitsStored"					Type="1"	BinaryEnumValues="BitsAre9To16"
	Name="HighBit"						Type="1"	BinaryEnumValues="BitsAre8To15"	# :( should be one less than bits stored
	Name="PixelRepresentation"			Type="1"	BinaryEnumValues="Zero"
	Name="PlanarConfiguration"			Type="1C"	BinaryEnumValues="PlanarConfiguration"	Condition="Never"
ModuleEnd

Module="MultiframeTrueColorSCImagePseudo"

	Name="SamplesPerPixel"				Type="1"	BinaryEnumValues="Three"
	Name="PhotometricInterpretation"	Type="1"	StringEnumValues="PhotometricInterpretationMonochrome2OrRGBOrYBR_FULL_422OrYBR_RCTOrYBR_ICTOrYBR_PARTIAL_420"
	Verify="PhotometricInterpretation"				Condition="JPEGTransferSyntaxButNotYBR_FULL_422"			ThenErrorMessage="JPEG transfer syntax is required to have PhotometricInterpretation of YBR_FULL422" ShowValueWithMessage="true"
	Verify="PhotometricInterpretation"				Condition="JPEG2000LosslessTransferSyntaxButNotYBR_RCT"		ThenErrorMessage="JPEG 2000 reversible transfer syntax is required to have PhotometricInterpretation of YBR_RCT" ShowValueWithMessage="true"
	Verify="PhotometricInterpretation"				Condition="JPEG2000TransferSyntaxButNotYBR_RCTOrYBR_ICT"	ThenErrorMessage="JPEG 2000 transfer syntax is required to have PhotometricInterpretation of YBR_RCT or YBR_ICT" ShowValueWithMessage="true"
	# MPEG2TransferSyntaxButNotYBR_PARTIAL_420 is generic too ImagePixelMacro and not repeated here (PS 3.5 requirement)
	Name="BitsAllocated"				Type="1"	BinaryEnumValues="BitsAre8"
	Name="BitsStored"					Type="1"	BinaryEnumValues="BitsAre8"
	Name="HighBit"						Type="1"	BinaryEnumValues="BitsAre7"
	Name="PixelRepresentation"			Type="1"	BinaryEnumValues="Zero"
	Name="PlanarConfiguration"			Type="1"	BinaryEnumValues="Zero"		# only needs to be 0 for RGB

ModuleEnd

Module="CommonInstanceReference"
	# do not use SeriesAndInstanceReferenceMacro, but conditional inclusion instead, per CP 926
	# cannot actually check whether instances that are referenced are in this study or another study
	# may be present otherwise because cannot check whether or not both sequences are needed
	Sequence="ReferencedSeriesSequence"								Type="1C"	VM="1-n"	Condition="StudiesContainingOtherReferencedInstancesSequenceAbsentAndInstanceReferencesInstances" mbpo="true"
		Name="SeriesInstanceUID"									Type="1"
		Verify="StudyInstanceUID"															Condition="StudyInstanceUIDIsPresent"	ThenErrorMessage="StudyInstanceUID should not be present in ReferencedSeriesSequence in CommonInstanceReference Module - use StudiesContainingOtherReferencedInstancesSequence if not the same Study"
		Sequence="ReferencedInstanceSequence"						Type="1"	VM="1-n"
			InvokeMacro="SOPInstanceReferenceMacro"
		SequenceEnd
	SequenceEnd
	Verify="ReferencedSeriesSequence"														Condition="ReferencedSeriesSequencePresentAndInstanceDoesNotReferencesInstances"			ThenErrorMessage="ReferencedSeriesSequence present but Instance does not reference Instances"
	Sequence="StudiesContainingOtherReferencedInstancesSequence"	Type="1C"	VM="1-n"	Condition="ReferencedSeriesSequenceAbsentAndInstanceReferencesInstances" mbpo="true"
		Name="StudyInstanceUID"										Type="1"
		InvokeMacro="SeriesAndInstanceReferenceMacro"
	SequenceEnd
	Verify="StudiesContainingOtherReferencedInstancesSequence"								Condition="StudiesContainingOtherReferencedInstancesSequencePresentAndInstanceDoesNotReferencesInstances"			ThenErrorMessage="StudiesContainingOtherReferencedInstancesSequence present but Instance does not reference Instances"
ModuleEnd

Module="SegmentationSeries"
	Name="Modality"												Type="1"	StringEnumValues="SEGModality"
	Name="SeriesNumber"											Type="1"
	Sequence="ReferencedPerformedProcedureStepSequence"			Type="1C"	VM="1"	Condition="SeriesNeedReferencedPerformedProcedureStepSequence"
		InvokeMacro="SOPInstanceReferenceMacro"
	SequenceEnd
ModuleEnd

Module="SegmentationImage"
	Name="ImageType"										Type="1"	VM="2"
	Verify="ImageType"													ValueSelector="0"	StringEnumValues="ImageType1DerivedOnly"
	Verify="ImageType"													ValueSelector="1"	StringEnumValues="ImageType2PrimaryOnly"
	InvokeMacro="ContentIdentificationMacro"
	Name="SamplesPerPixel"									Type="1"	BinaryEnumValues="One"
	Name="PhotometricInterpretation"						Type="1"	StringEnumValues="PhotometricInterpretationMonochrome2OrPaletteColor"
	Verify="PhotometricInterpretation"									Condition="SegmentationTypeIsNotLabelMap"	StringEnumValues="PhotometricInterpretationMonochrome2"
	Name="PixelRepresentation"								Type="1"	BinaryEnumValues="Zero"
	
	Name="BitsAllocated"									Type="1"
	Verify="BitsAllocated"												Condition="SegmentationTypeIsBinary"					BinaryEnumValues="One"
	Verify="BitsAllocated"												Condition="SegmentationTypeIsFractional"				BinaryEnumValues="BitsAre8"
	Verify="BitsAllocated"												Condition="SegmentationTypeIsLabelMap"					BinaryEnumValues="BitsAre8Or16"
	
	Name="BitsStored"										Type="1"
	Verify="BitsStored"													Condition="SegmentationTypeIsBinary"					BinaryEnumValues="One"
	Verify="BitsStored"													Condition="SegmentationTypeIsFractional"				BinaryEnumValues="BitsAre8"
	Verify="BitsStored"													Condition="SegmentationTypeIsLabelMap"					BinaryEnumValues="BitsAre8Or16"
	
	Name="HighBit"											Type="1"
	Verify="HighBit"													Condition="SegmentationTypeIsBinary"					BinaryEnumValues="Zero"
	Verify="HighBit"													Condition="SegmentationTypeIsFractional"				BinaryEnumValues="BitsAre7"
	Verify="HighBit"													Condition="SegmentationTypeIsLabelMapAndBitsStoredIs8"	BinaryEnumValues="BitsAre7"
	Verify="HighBit"													Condition="SegmentationTypeIsLabelMapAndBitsStoredIs16"	BinaryEnumValues="BitsAre15"
	
	Name="PlanarConfiguration"								Type="1C"	BinaryEnumValues="PlanarConfiguration"	Condition="Never"
	Name="LossyImageCompression"							Type="1"	StringEnumValues="LossyImageCompression"
	Name="LossyImageCompressionRatio"						Type="1C"	NoCondition=""
	Name="LossyImageCompressionMethod"						Type="1C"	NoCondition=""
	Verify="LossyImageCompressionMethod"								Condition="LossyImageCompressionMethodInconsistentWithTransferSyntax"	ThenWarningMessage="method inconsistent with Transfer Syntax" ShowValueWithMessage="true"

	Name="SegmentationType"									Type="1"	StringEnumValues="SegmentationType"
	Verify="SegmentationType"											Condition="SegmentationInstance"				StringEnumValues="SegmentationTypeForSegmentation"
	Verify="SegmentationType"											Condition="LabelMapSegmentationInstance"		StringEnumValues="SegmentationTypeForLabelMap"

	Name="SegmentationFractionalType"						Type="1C"	Condition="SegmentationTypeIsFractional"	StringEnumValues="SegmentationFractionalType"
	Name="MaximumFractionalValue"							Type="1C"	Condition="SegmentationTypeIsFractional"
	# should verify than 0 < MaximumFractionalValue < 256 :(
	
	Name="SegmentsOverlap"									Type="3"	StringEnumValues="YesNoFullUndefined"
	Verify="SegmentsOverlap"											Condition="SegmentationTypeIsLabelMap"	StringEnumValues="NoFull"
	
	Sequence="SegmentSequence"								Type="1"	VM="1-n"
		InvokeMacro="SegmentDescriptionMacro"
		Name="SegmentAlgorithmName"							Type="1C"	Condition="SegmentAlgorithmTypeIsNotManual"
		Sequence="SegmentationAlgorithmIdentificationSequence"	Type="3"	VM="1-n"
			InvokeMacro="AlgorithmIdentificationMacro"									BaselineContextID="7162"
		SequenceEnd
		Name="RecommendedDisplayGrayscaleValue"				Type="3"
		Name="RecommendedDisplayCIELabValue"				Type="3"
		Verify="RecommendedDisplayCIELabValue"							Condition="RecommendedDisplayCIELabValuePresentButPaletteColorLabelMap"	ThenErrorMessage="present but SegmentationType is LABELMAP and PhotometricInterpretation is PALETTE COLOR"
	SequenceEnd
ModuleEnd

DefineMacro="SegmentDescriptionMacro" InformationEntity="Instance"
	Name="SegmentNumber"										Type="1"
	Verify="SegmentNumber"													Condition="SegmentNumberIsZeroButSegmentationTypeNotLabelMap"	ThenErrorMessage="Value is zero but SegmentationType is not LABELMAP"
	Name="SegmentLabel"											Type="1"
	Name="SegmentDescription"									Type="3"
	Name="SegmentAlgorithmType"									Type="1"	StringEnumValues="SegmentAlgorithmType"
	InvokeMacro="MultipleSiteGeneralAnatomyOptionalMacro"
	Sequence="SegmentedPropertyCategoryCodeSequence"			Type="1"	VM="1"
		InvokeMacro="CodeSequenceMacro"										BaselineContextID="7150"
	SequenceEnd
	Sequence="SegmentedPropertyTypeCodeSequence"				Type="1"	VM="1"
		InvokeMacro="CodeSequenceMacro"										BaselineContextID="7151"
		Sequence="SegmentedPropertyTypeModifierCodeSequence"	Type="3"	VM="1-n"
			InvokeMacro="CodeSequenceMacro"									BaselineContextID="244"
		SequenceEnd
	SequenceEnd
	Name="TrackingID"											Type="1C"	Condition="TrackingUIDIsPresent"
	Name="TrackingUID"											Type="1C"	Condition="TrackingIDIsPresent"
	Sequence="DefinitionSourceSequence"							Type="3"	VM="1"
		InvokeMacro="SOPInstanceReferenceMacro"
		Name="ReferencedROINumber"								Type="1C"	Condition="ReferencedSOPClassUIDIsRTStructureSetStorage"
	SequenceEnd
	InvokeMacro="ContentCreatorMacro"
MacroEnd

DefineMacro="SegmentationMacro" InformationEntity="FunctionalGroup"
	Sequence="SegmentIdentificationSequence"				Type="1"	VM="1"
		Name="ReferencedSegmentNumber"						Type="1"	VM="1"
	SequenceEnd
MacroEnd

Module="SurfaceSegmentation"
	InvokeMacro="ContentIdentificationMacro"
	Name="ContentDate"															Type="1"
	Name="ContentTime"															Type="1"
	Sequence="SegmentSequence"													Type="1"	VM="1-n"
		InvokeMacro="SegmentDescriptionMacro"
		Name="SurfaceCount"														Type="1"	NotZeroError="" 
		Sequence="ReferencedSurfaceSequence"									Type="1"	VM="1-n"				# should check that number of items equals SurfaceCount :(
			Name="ReferencedSurfaceNumber"										Type="1"	VM="1" 	NotZeroError=""	# should check that SurfaceNumber exists in SurfaceSequence :(
			Sequence="SegmentSurfaceGenerationAlgorithmIdentificationSequence"	Type="1"	VM="1-n"
				InvokeMacro="AlgorithmIdentificationMacro"									BaselineContextID="7162"
			SequenceEnd
			Sequence="SegmentSurfaceSourceInstanceSequence"						Type="2"	VM="0-n"
				InvokeMacro="ImageSOPInstanceReferenceMacro"
			SequenceEnd
		SequenceEnd
	SequenceEnd
ModuleEnd

DefineMacro="PointsMacro" InformationEntity="Surface"
	Name="NumberOfSurfacePoints"												Type="1"	NotZeroError=""
	Name="PointCoordinatesData"													Type="1"
	Name="PointPositionAccuracy"												Type="3"
	Name="MeanPointDistance"													Type="3"
	Name="MaximumPointDistance"													Type="3"
	Name="PointsBoundingBoxCoordinates"											Type="3"
	Name="AxisOfRotation"														Type="3"
	Name="CenterOfRotation"														Type="1C"	Condition="AxisOfRotationIsPresent" mbpo="true"
MacroEnd

DefineMacro="VectorsMacro" InformationEntity="Surface"
	Name="NumberOfVectors"														Type="1"	NotZeroError=""
	Name="VectorDimensionality"													Type="1"	NotZeroError=""
	Name="VectorAccuracy"														Type="3"
	Name="VectorCoordinateData"													Type="1"
MacroEnd

DefineMacro="SurfaceMeshPrimitivesMacro" InformationEntity="Surface"
	Name="LongVertexPointIndexList"												Type="2"
	Name="LongEdgePointIndexList"												Type="2"						# should check has 2n values :(
	Name="LongTrianglePointIndexList"											Type="2"						# should check has 3n values :(
	Sequence="TriangleStripSequence"											Type="2"	VM="0-n"
		Name="LongPrimitivePointIndexList"										Type="1"
	SequenceEnd
	Sequence="TriangleFanSequence"												Type="2"	VM="0-n"
		Name="LongPrimitivePointIndexList"										Type="1"
	SequenceEnd
	Sequence="LineSequence"														Type="2"	VM="0-n"
		Name="LongPrimitivePointIndexList"										Type="1"
	SequenceEnd
	Sequence="FacetSequence"													Type="2"	VM="0-n"
		Name="LongPrimitivePointIndexList"										Type="1"
	SequenceEnd
MacroEnd

Module="SurfaceMesh"
	Name="NumberOfSurfaces"														Type="1"	NotZeroError=""
	Sequence="SurfaceSequence"													Type="1"	VM="1-n"				# should check that number of items equals NumberOfSurfaces :(
		Name="SurfaceNumber"													Type="1"	NotZeroError=""			# should check that starts at a value of 1, and increases monotonically by 1 :(
		Name="SurfaceComments"													Type="3"
		Sequence="SegmentedPropertyCategoryCodeSequence"						Type="3"	VM="1"
			InvokeMacro="CodeSequenceMacro"													BaselineContextID="7150"
		SequenceEnd
		Sequence="SegmentedPropertyTypeCodeSequence"							Type="3"	VM="1"
			InvokeMacro="CodeSequenceMacro"													BaselineContextID="7151"
		SequenceEnd
		Name="SurfaceProcessing"												Type="2"	StringEnumValues="YesNoFull"
		Name="SurfaceProcessingRatio"											Type="2C"	Condition="SurfaceProcessingIsYes"
		Name="SurfaceProcessingDescription"										Type="3"
		Sequence="SurfaceProcessingAlgorithmIdentificationSequence"				Type="2C"	VM="0-n"	Condition="SurfaceProcessingIsYes"
			InvokeMacro="AlgorithmIdentificationMacro"										BaselineContextID="7162"
		SequenceEnd
		Name="RecommendedDisplayGrayscaleValue"									Type="1"
		Name="RecommendedDisplayCIELabValue"									Type="1"
		Name="RecommendedPresentationOpacity"									Type="1"
		Name="RecommendedPresentationType"										Type="1"	StringDefinedTerms="RecommendedPresentationType"
		Name="RecommendedPointRadius"											Type="3"
		Name="RecommendedLineThickness"											Type="3"
		Name="FiniteVolume"														Type="1"	StringEnumValues="YesNoFullUnknown"
		Name="Manifold"															Type="1"	StringEnumValues="YesNoFullUnknown"
		Sequence="SurfacePointsSequence"										Type="1"	VM="1"
			InvokeMacro="PointsMacro"
		SequenceEnd
		Sequence="SurfacePointsNormalsSequence"									Type="2"	VM="0-1"
			InvokeMacro="VectorsMacro"																				# should check that NumberOfVectors equals NumberOfSurfacePoints in SurfacePointsSequence, and VectorDimensionality equals 3 :(
		SequenceEnd
		Sequence="SurfaceMeshPrimitivesSequence"								Type="1"	VM="1"
			InvokeMacro="SurfaceMeshPrimitivesMacro"																# should check that indices do not exceed NumberOfSurfacePoints in SurfacePointsSequence :(
		SequenceEnd
	SequenceEnd
ModuleEnd

Module="MultiFrameFunctionalGroupsForSegmentation"
	Sequence="SharedFunctionalGroupsSequence"	Type="1"	VM="1"
		InvokeMacro="PixelMeasuresMacro"		Condition="PixelMeasuresSequenceNotInPerFrameFunctionalGroupSequenceAndDerivationImageMacroNotPresentInEitherMBPO"
		InvokeMacro="PlanePositionMacro"		Condition="PlanePositionSequenceNotInPerFrameFunctionalGroupSequenceAndDerivationImageMacroNotPresentInEitherMBPOIfNotSlideRelative"
		InvokeMacro="PlaneOrientationMacro"		Condition="PlaneOrientationSequenceNotInPerFrameFunctionalGroupSequenceAndDerivationImageMacroNotPresentInEitherMBPOIfNotSlideRelative""
		InvokeMacro="PlanePositionSlideMacro"	Condition="PlanePositionSlideSequenceNotInPerFrameFunctionalGroupSequenceAndDerivationImageMacroNotPresentInEitherAndNotTILED_FULL_MBPOIfNotPatientRelative"
		InvokeMacro="DerivationImageMacro"		Condition="DerivationImageSequenceNotInPerFrameFunctionalGroupSequenceAndPixelMeasuresPlanePositionPlaneOrientationNotPresentInEitherMBPO"
		InvokeMacro="SegmentationMacro"			Condition="SegmentIdentificationSequenceNotInPerFrameFunctionalGroupSequenceAndNotTILED_FULLAndSegmentationTypeNotLabelMap"
	SequenceEnd
	Sequence="PerFrameFunctionalGroupsSequence"	Type="1C"	VM="1-n"	Condition="PerFrameFunctionalGroupsSequencePresent"
		InvokeMacro="PixelMeasuresMacro"		Condition="PixelMeasuresSequenceNotInSharedFunctionalGroupSequenceAndDerivationImageMacroNotPresentInEitherMBPO"
		InvokeMacro="FrameContentMacro"
		InvokeMacro="PlanePositionMacro"		Condition="PlanePositionSequenceNotInSharedFunctionalGroupSequenceAndDerivationImageMacroNotPresentInEitherMBPOIfNotSlideRelative"
		InvokeMacro="PlaneOrientationMacro"		Condition="PlaneOrientationSequenceNotInSharedFunctionalGroupSequenceAndDerivationImageMacroNotPresentInEitherMBPOIfNotSlideRelative"
		InvokeMacro="PlanePositionSlideMacro"	Condition="PlanePositionSlideSequenceNotInSharedFunctionalGroupSequenceAndDerivationImageMacroNotPresentInEitherAndNotTILED_FULL_MBPOIfNotPatientRelative"
		InvokeMacro="DerivationImageMacro"		Condition="DerivationImageSequenceNotInSharedFunctionalGroupSequenceAndPixelMeasuresPlanePositionPlaneOrientationNotPresentInEitherMBPO"
		InvokeMacro="SegmentationMacro"			Condition="SegmentIdentificationSequenceNotInSharedFunctionalGroupSequenceAndNotTILED_FULLAndSegmentationTypeNotLabelMap"
	SequenceEnd
ModuleEnd

Module="SpatialRegistrationSeries"
	Name="Modality"												Type="1"	StringEnumValues="REGModality"
ModuleEnd

Module="SpatialRegistration"
	Name="ContentDate"											Type="1"
	Name="ContentTime"											Type="1"
	InvokeMacro="ContentIdentificationMacro"
	Sequence="RegistrationSequence"								Type="1"	VM="1-n"
		Name="FrameOfReferenceUID"								Type="1C"	Condition="ReferencedImageSequenceNotPresent" mbpo="true"
		Sequence="ReferencedImageSequence"						Type="1C"	VM="1-n"	Condition="FrameOfReferenceUIDNotPresent" mbpo="true"
			InvokeMacro="ImageSOPInstanceReferenceMacro"
		SequenceEnd
		Sequence="MatrixRegistrationSequence"					Type="1"	VM="1"
			Name="FrameOfReferenceTransformationComment"		Type="3"
			Sequence="RegistrationTypeCodeSequence"				Type="2"	VM="0-1"
				InvokeMacro="CodeSequenceMacro"
			SequenceEnd
			Sequence="MatrixSequence"							Type="1"	VM="1-n"
				Name="FrameOfReferenceTransformationMatrix"		Type="1"
				Name="FrameOfReferenceTransformationMatrixType"	Type="1"	StringEnumValues="FrameOfReferenceTransformationMatrixType"
			SequenceEnd
		SequenceEnd
		Sequence="UsedFiducialsSequence"						Type="3"	VM="1-n"
			InvokeMacro="SOPInstanceReferenceMacro"
			Name="FiducialUID"									Type="1"
		SequenceEnd
		Sequence="UsedSegmentsSequence"							Type="3"	VM="1-n"
			InvokeMacro="SOPInstanceReferenceMacro"
			Name="ReferencedSegmentNumber"						Type="1"
		SequenceEnd
	SequenceEnd
ModuleEnd

Module="DeformableSpatialRegistration"
	Name="ContentDate"											Type="1"
	Name="ContentTime"											Type="1"
	InvokeMacro="ContentIdentificationMacro"
	Sequence="DeformableRegistrationSequence"					Type="1"	VM="1-n"
		Name="SourceFrameOfReferenceUID"						Type="1"
		Sequence="ReferencedImageSequence"						Type="1C"	VM="1-n"	NoCondition=""
			InvokeMacro="ImageSOPInstanceReferenceMacro"
		SequenceEnd
		Name="FrameOfReferenceTransformationComment"			Type="3"
		Sequence="RegistrationTypeCodeSequence"					Type="2"	VM="0-1"
			InvokeMacro="CodeSequenceMacro"
		SequenceEnd
		Sequence="PreDeformationMatrixRegistrationSequence"		Type="1C"	VM="1"	NoCondition=""
			Name="FrameOfReferenceTransformationMatrix"			Type="1"
			Name="FrameOfReferenceTransformationMatrixType"		Type="1"	StringEnumValues="FrameOfReferenceTransformationMatrixType"
		SequenceEnd
		Sequence="PostDeformationMatrixRegistrationSequence"	Type="1C"	VM="1"	NoCondition=""
			Name="FrameOfReferenceTransformationMatrix"			Type="1"
			Name="FrameOfReferenceTransformationMatrixType"		Type="1"	StringDefinedTerms="FrameOfReferenceTransformationMatrixType"
		SequenceEnd
		Sequence="DeformableRegistrationGridSequence"			Type="1C"	VM="1"	NoCondition=""
			Name="ImageOrientationPatient"						Type="1"
			Name="ImagePositionPatient"							Type="1"
			Name="GridDimensions"								Type="1"
			Name="GridResolution"								Type="1"
			Name="VectorGridData"								Type="1"
		SequenceEnd
		Sequence="UsedFiducialsSequence"						Type="3"	VM="1-n"
			InvokeMacro="SOPInstanceReferenceMacro"
			Name="FiducialUID"									Type="1"
		SequenceEnd
	SequenceEnd
ModuleEnd

Module="SpatialFiducialsSeries"
	Name="Modality"												Type="1"	StringEnumValues="FIDModality"
ModuleEnd

Module="SpatialFiducials"
	Name="ContentDate"											Type="1"
	Name="ContentTime"											Type="1"
	InvokeMacro="ContentIdentificationMacro"
	Sequence="FiducialSetSequence"								Type="1"	VM="1-n"
		Name="FrameOfReferenceUID"								Type="1C"				Condition="ReferencedImageSequenceNotPresent" mbpo="true"
		Sequence="ReferencedImageSequence"						Type="1C"	VM="1-n"	Condition="FrameOfReferenceUIDNotPresent" mbpo="true"
			InvokeMacro="ImageSOPInstanceReferenceMacro"
		SequenceEnd
		Sequence="FiducialSequence"								Type="1"	VM="1-n"
			Name="FiducialIdentifier"							Type="1"
			Sequence="FiducialsPropertyCategoryCodeSequence"	Type="3"	VM="1"
				InvokeMacro="CodeSequenceMacro"
			SequenceEnd
			Sequence="FiducialIdentifierCodeSequence"			Type="1C"	VM="1"	Condition="FiducialIdentifierNotPresent" mbpo="true"
				InvokeMacro="CodeSequenceMacro"
			SequenceEnd
			Name="FiducialUID"									Type="3"
			Name="FiducialDescription"							Type="3"
			Name="ShapeType"									Type="1"	StringDefinedTerms="FiducialShapeType"
			Name="NumberOfContourPoints"						Type="1C"	Condition="ContourDataIsPresent"	NotZeroError=""
			Name="ContourData"									Type="1C"	Condition="FrameOfReferenceUIDIsPresentInParent"
			Name="ContourUncertaintyRadius"						Type="3"
			Sequence="GraphicCoordinatesDataSequence"			Type="1C"	VM="1-n"	Condition="ContourDataNotPresent" mbpo="true"
				Name="GraphicData"								Type="1"
				Sequence="ReferencedImageSequence"				Type="1"	VM="1"
					InvokeMacro="ImageSOPInstanceReferenceMacro"
				SequenceEnd
			SequenceEnd
			Sequence="DefinitionSourceSequence"					Type="3"	VM="1"
				InvokeMacro="SOPInstanceReferenceMacro"
				Name="ReferencedROINumber"						Type="1C"	Condition="ReferencedSOPClassUIDIsRTStructureSetStorage"
			SequenceEnd
		SequenceEnd
	SequenceEnd
ModuleEnd

Module="EncapsulatedDocumentSeries"
	Name="Modality"												Type="1"	StringDefinedTerms="Modality"
	Name="SeriesInstanceUID"									Type="1"
	Name="SeriesNumber"											Type="1"
	Name="SeriesDate"											Type="3"
	Name="SeriesTime"											Type="3"
	Sequence="ReferencedPerformedProcedureStepSequence"			Type="3"	VM="1"
		InvokeMacro="SOPInstanceReferenceMacro"
	SequenceEnd
	Name="ProtocolName"											Type="3"
	Name="SeriesDescription"									Type="3"
	Sequence="SeriesDescriptionCodeSequence"					Type="3"	VM="1"
		InvokeMacro="CodeSequenceMacro"
	SequenceEnd
	Sequence="RequestAttributesSequence"						Type="3"	VM="1-n"
		InvokeMacro="RequestAttributesMacro"
	SequenceEnd
	InvokeMacro="PerformedProcedureStepSummaryMacro"
ModuleEnd

Module="EncapsulatedDocument"
	Name="InstanceNumber"										Type="1"
	Name="ContentDate"											Type="2"
	Name="ContentTime"											Type="2"
	Name="AcquisitionDateTime"									Type="2"
	Name="BurnedInAnnotation"									Type="1"	StringEnumValues="YesNoFull"
	Name="RecognizableVisualFeatures"							Type="3"	StringEnumValues="YesNoFull"
	Sequence="SourceInstanceSequence"							Type="1C"	VM="1-n"	NoCondition=""
		InvokeMacro="SOPInstanceReferenceMacro"
		Sequence="PurposeOfReferenceCodeSequence"				Type="3"	VM="1"
			InvokeMacro="CodeSequenceMacro"									DefinedContextID="7060"
		SequenceEnd
	SequenceEnd
	Sequence="ReferencedImageSequence"							Type="3"	VM="1-n"
		InvokeMacro="ImageSOPInstanceReferenceMacro"
		Name="RelativeURIReferenceWithinEncapsulatedDocument"	Type="1C"	VM="1"	NoCondition=""
	SequenceEnd
	Sequence="ReferencedInstanceSequence"						Type="3"	VM="1-n"
		InvokeMacro="SOPInstanceReferenceMacro"
		Name="RelativeURIReferenceWithinEncapsulatedDocument"	Type="1C"	VM="1"	NoCondition=""
	SequenceEnd
	Name="DocumentTitle"										Type="2"
	Sequence="ConceptNameCodeSequence"							Type="2"	VM="0-1"
		InvokeMacro="CodeSequenceMacro"										BaselineContextID="7020"	# or 7061 if Modality is M3D ... not checked anyway :(
	SequenceEnd
	Sequence="DocumentClassCodeSequence"						Type="3"	VM="1-n"
		InvokeMacro="CodeSequenceMacro"
	SequenceEnd
	Name="VerificationFlag"										Type="3"	StringEnumValues="VerificationFlag"
	Name="HL7InstanceIdentifier"								Type="1C"	Condition="EncapsulatedCDAInstance"
	Sequence="PredecessorDocumentsSequence"						Type="3"	VM="1-n"
		InvokeMacro="HierarchicalSOPInstanceReferenceMacro"
	SequenceEnd
	Sequence="IdenticalDocumentsSequence"						Type="3"	VM="1-n"
		InvokeMacro="HierarchicalSOPInstanceReferenceMacro"
	SequenceEnd
	Name="MIMETypeOfEncapsulatedDocument"						Type="1"
	Name="ListOfMIMETypes"										Type="1C"	NoCondition=""
	Name="ImageLaterality"										Type="3"	StringEnumValues="ImageLaterality"
	Name="EncapsulatedDocument"									Type="1"
	Name="EncapsulatedDocumentLength"							Type="3"
	Name="ValueType"											Type="1C"	Condition="ContentSequencePresent"	StringEnumValues="EncapsulatedDocumentRootValueTypes"
	Sequence="ContentSequence"									Type="3"	VM="1-n"
		Name="RelationshipType"									Type="1"	StringDefinedTerms="EncapsulatedDocumentRelationshipType"
		InvokeMacro="DocumentRelationshipMacro"					Type="1"
		InvokeMacro="DocumentContentMacro"						Type="1"
	SequenceEnd
	Name="ContinuityOfContent"									Type="1C"	Condition="ContentSequencePresent"	StringEnumValues="ContinuityOfContent"
	Sequence="ContentTemplateSequence"							Type="1C"	VM="1"	NoCondition=""
		Name="MappingResource"									Type="1"	StringDefinedTerms="SRTemplateMappingResource"
		Name="MappingResourceUID"								Type="3"	StringDefinedTerms="MappingResourceUIDs"
		Name="TemplateIdentifier"								Type="1"
	SequenceEnd
ModuleEnd

Module="EncapsulatedDocumentPDFPseudo"
	Name="MIMETypeOfEncapsulatedDocument"						Type="1"	StringEnumValues="MIMETypeApplicationPDF"
ModuleEnd

Module="EncapsulatedDocumentCDAPseudo"
	Name="MIMETypeOfEncapsulatedDocument"						Type="1"	StringEnumValues="MIMETypeApplicationCDA"
ModuleEnd

Module="EncapsulatedDocumentSTLPseudo"
	Name="MIMETypeOfEncapsulatedDocument"						Type="1"	StringEnumValues="MIMETypeApplicationSTL"
ModuleEnd

Module="EncapsulatedDocumentSTLSeriesPseudo"
	Name="Modality"												Type="1"	StringEnumValues="M3DModality"
ModuleEnd

Module="CheckSingleFramePseudo"
	Name="NumberOfFrames"										Type="3"	DoNotSetUsed="" BinaryEnumValues="One"
ModuleEnd

Module="RealWorldValueMappingSeries"
	Name="Modality"												Type="1"	StringDefinedTerms="RealWorldValueMappingModality"
ModuleEnd

Module="RealWorldValueMapping"
	Name="ContentDate"											Type="1"
	Name="ContentTime"											Type="1"
	InvokeMacro="ContentIdentificationMacro"
	Sequence="ReferencedImageRealWorldValueMappingSequence"		Type="1"	VM="1-n"
		InvokeMacro="RealWorldValueMappingMacro"
		Sequence="ReferencedImageSequence"						Type="1"	VM="1-n"
			InvokeMacro="ImageSOPInstanceReferenceMacro"
		SequenceEnd
	SequenceEnd
ModuleEnd


Module="IntravascularOCTSeries"
	Name="Modality"											Type="1"	StringEnumValues="IVOCTModality"
	Name="SeriesNumber"										Type="1"
	Sequence="ReferencedPerformedProcedureStepSequence"		Type="1C"	VM="1"	Condition="SeriesNeedReferencedPerformedProcedureStepSequence"
		InvokeMacro="SOPInstanceReferenceMacro"
	SequenceEnd
	Name="PresentationIntentType"							Type="1"	StringEnumValues="PresentationIntentType"
	Verify="PresentationIntentType"										Condition="IsForProcessingSOPClass"		StringEnumValues="ForProcessing"
	Verify="PresentationIntentType"										Condition="IsForPresentationSOPClass"	StringEnumValues="ForPresentation"
ModuleEnd

Module="IntravascularOCTImage"
	Name="ImageType"								Type="1"	VM="4"
	Verify="ImageType"											ValueSelector="0"	StringEnumValues="CommonEnhancedImageType1"
	Verify="ImageType"											ValueSelector="1"	StringEnumValues="CommonEnhancedImageAndFrameType2"
	Verify="ImageType"											ValueSelector="2"	StringDefinedTerms="IVOCTImageAndFrameTypeValue3"
	Verify="ImageType"											ValueSelector="3"	StringDefinedTerms="CommonEnhancedImageType4"

	Name="VolumetricProperties"						Type="1"	StringEnumValues="IVOCTVolumetricProperties"
	Name="PixelPresentation"						Type="1"	StringEnumValues="IVOCTPixelPresentationImageLevel"
	Name="SamplesPerPixel"							Type="1"	BinaryEnumValues="SamplesPerPixelIsOne"
	Name="AcquisitionDateTime"						Type="1"
	Name="AcquisitionDuration"						Type="1C"	Condition="ImageTypeValue1Original"
	Name="AcquisitionNumber"						Type="1"
	Name="PhotometricInterpretation"				Type="1"	StringEnumValues="PhotometricInterpretationMonochrome2"
	Name="PixelRepresentation"						Type="1"	BinaryEnumValues="PixelRepresentationUnsigned"
	Name="BitsAllocated"							Type="1"	BinaryEnumValues="BitsAre8Or12Or16"
	Name="BitsStored"								Type="1"	BinaryEnumValues="BitsAre8Or12Or16"
	Name="HighBit"									Type="1"	BinaryEnumValues="BitsAre7Or11Or15"
	Name="PresentationLUTShape"						Type="1C"	Condition="PresentationIntentTypeIsForPresentation"	StringEnumValues="IdentityPresentationLUTShape"
	Name="LossyImageCompression"					Type="1"	StringEnumValues="LossyImageCompression"
	Name="LossyImageCompressionRatio"				Type="1C"	Condition="LossyImageCompressionIs01"
	Name="LossyImageCompressionMethod"				Type="1C"	StringDefinedTerms="LossyImageCompressionMethod"	Condition="LossyImageCompressionIs01"
	Name="BurnedInAnnotation"						Type="1"	StringEnumValues="NoFull"
	Name="RecognizableVisualFeatures"				Type="1"	StringEnumValues="NoFull"
	Sequence="ReferencedInstanceSequence"			Type="3"	VM="1-n"
		InvokeMacro="SOPInstanceReferenceMacro"
		Sequence="PurposeOfReferenceCodeSequence"	Type="1"	VM="1"
			InvokeMacro="CodeSequenceMacro"
		SequenceEnd
	SequenceEnd
	Name="ImageComments"							Type="3"
	Name="RecommendedDisplayFrameRate"				Type="3"
	Name="InterpolationType"						Type="1C"	Condition="PresentationIntentTypeIsForPresentation"	StringEnumValues="IVOCTInterpolationType"
	Name="ReferencedColorPaletteInstanceUID"		Type="1C"	Condition="PixelPresentationIsColorRef"				StringDefinedTerms="WellKnownColorPaletteInstanceUIDs"
ModuleEnd

Module="IntravascularOCTAcquisitionParameters"
	Name="OCTFocalDistance"						Type="2"
	Name="BeamSpotSize"							Type="2"
	Name="EffectiveRefractiveIndex"				Type="2C"		Condition="PresentationIntentTypeIsForProcessing"
	Name="OCTAcquisitionDomain"					Type="1"		StringDefinedTerms="OCTAcquisitionDomain"
	Name="OCTOpticalCenterWavelength"			Type="2"
	Name="AxialResolution"						Type="2"
	Name="RangingDepth"							Type="1"
	Name="ALineRate"							Type="1"
	Name="ALinesPerFrame"						Type="1"
ModuleEnd

Module="IntravascularImageAcquisitionParameters"
	Name="IVUSAcquisition"						Type="1"	StringEnumValues="IVOCTIVUSAcquisition"
	Name="IVUSPullbackRate"						Type="1C"	Condition="IVUSAcquisitionIsMotorized"
	Name="IVUSPullbackStartFrameNumber"			Type="1C"	Condition="IVUSAcquisitionIsMotorized"
	Name="IVUSPullbackStopFrameNumber"			Type="1C"	Condition="IVUSAcquisitionIsMotorized"
	Name="CatheterDirectionOfRotation"			Type="1C"	Condition="RotationalCatheterInformationIsPresent"	StringEnumValues="CatheterDirectionOfRotation"
	Name="CatheterRotationalRate"				Type="1C"	Condition="RotationalCatheterInformationIsPresent"				
	Sequence="ModeOfPercutaneousAccessSequence"	Type="2"	VM="0-1"
		InvokeMacro="CodeSequenceMacro"
	SequenceEnd				
ModuleEnd

Module="IntravascularOCTProcessingParameters"
	Name="OCTZOffsetApplied"					Type="1"	StringEnumValues="YesNoFull"
	Name="RefractiveIndexApplied"				Type="1"	StringEnumValues="YesNoFull"
	Name="ALinePixelSpacing"					Type="1"	NotZeroError=""
	Name="PixelIntensityRelationship"			Type="1"	StringEnumValues="IVOCTPixelIntensityRelationship"
	Name="FirstALineLocation"					Type="1"
ModuleEnd

DefineMacro="IntravascularOCTFrameTypeMacro"		InformationEntity="FunctionalGroup"
	Sequence="IntravascularOCTFrameTypeSequence"	Type="1"	VM="1"
		Name="FrameType"							Type="1"	VM="4"
		Verify="FrameType"										ValueSelector="0"	StringEnumValues="CommonEnhancedImageType1"
		Verify="FrameType"										ValueSelector="1"	StringEnumValues="CommonEnhancedImageAndFrameType2"
		Verify="FrameType"										ValueSelector="2"	StringDefinedTerms="IVOCTImageAndFrameTypeValue3"
		Verify="FrameType"										ValueSelector="3"	StringDefinedTerms="CommonEnhancedImageType4"
	SequenceEnd
MacroEnd

DefineMacro="IntravascularFrameContentMacro"		InformationEntity="FunctionalGroup"
	Sequence="IntravascularFrameContentSequence"	Type="1"	VM="1"
		Name="IntravascularLongitudinalDistance"	Type="1C"	Condition="IVUSAcquisitionIsMeasured"
		Name="SeamLineLocation"						Type="2C"	Condition="PresentationIntentTypeIsForPresentation"
	SequenceEnd
MacroEnd

DefineMacro="IntravascularOCTFrameContentMacro"		InformationEntity="FunctionalGroup"
	Sequence="IntravascularOCTFrameContentSequence"	Type="1"	VM="1"
		Name="OCTZOffsetCorrection"					Type="1"
		Name="SeamLineIndex"						Type="1"
		Name="NumberOfPaddedALines"					Type="1C"	NoCondition=""
		Verify="NumberOfPaddedALines"							Condition="PresentationIntentTypeIsForPresentation"	ThenErrorMessage="Only permitted for FOR PROCESSING images"
	SequenceEnd
MacroEnd

Module="MultiFrameFunctionalGroupsForIVOCTImageForPresentation"
	Sequence="SharedFunctionalGroupsSequence"	Type="1"	VM="1"
		InvokeMacro="PixelMeasuresMacro"					Condition="PixelMeasuresSequenceNotInPerFrameFunctionalGroupSequence"
		InvokeMacro="DerivationImageMacro"					Condition="DerivationImageMacroOKInSharedFunctionalGroupSequence"
		InvokeMacro="CardiacSynchronizationMacro"			Condition="NeedCardiacSynchronizationMacroInSharedFunctionalGroupSequence"
		InvokeMacro="FrameAnatomyMacro"						Condition="FrameAnatomySequenceNotInPerFrameFunctionalGroupSequence"
		InvokeMacro="FrameVOILUTMacro"						Condition="FrameVOILUTMacroOKInSharedFunctionalGroupSequence"
		InvokeMacro="PixelIntensityRelationshipLUTMacro"	Condition="NeedPixelIntensityRelationshipLUTMacroInSharedFunctionalGroupSequence"
		InvokeMacro="IntravascularOCTFrameTypeMacro"		Condition="IntravascularOCTFrameTypeSequenceNotInPerFrameFunctionalGroupSequence"
		InvokeMacro="IntravascularFrameContentMacro"		Condition="IntravascularFrameContentSequenceNotInPerFrameFunctionalGroupSequence"
	SequenceEnd
	Sequence="PerFrameFunctionalGroupsSequence"	Type="1"	VM="1-n"
		InvokeMacro="FrameContentMacro"
		InvokeMacro="PixelMeasuresMacro"					Condition="PixelMeasuresSequenceNotInSharedFunctionalGroupSequence"
		InvokeMacro="DerivationImageMacro"					Condition="DerivationImageMacroOKInPerFrameFunctionalGroupSequence"
		InvokeMacro="CardiacSynchronizationMacro"			Condition="NeedCardiacSynchronizationMacroInPerFrameFunctionalGroupSequence"
		InvokeMacro="FrameAnatomyMacro"						Condition="FrameAnatomySequenceNotInSharedFunctionalGroupSequence"
		InvokeMacro="FrameVOILUTMacro"						Condition="FrameVOILUTMacroOKInPerFrameFunctionalGroupSequence"
		InvokeMacro="PixelIntensityRelationshipLUTMacro"	Condition="NeedPixelIntensityRelationshipLUTMacroInPerFrameFunctionalGroupSequence"
		InvokeMacro="IntravascularOCTFrameTypeMacro"		Condition="IntravascularOCTFrameTypeSequenceNotInSharedFunctionalGroupSequence"
		InvokeMacro="IntravascularFrameContentMacro"		Condition="IntravascularFrameContentSequenceNotInSharedFunctionalGroupSequence"
	SequenceEnd
ModuleEnd

Module="MultiFrameFunctionalGroupsForIVOCTImageForProcessing"
	Sequence="SharedFunctionalGroupsSequence"	Type="1"	VM="1"
		InvokeMacro="DerivationImageMacro"					Condition="DerivationImageMacroOKInSharedFunctionalGroupSequence"
		InvokeMacro="CardiacSynchronizationMacro"			Condition="NeedCardiacSynchronizationMacroInSharedFunctionalGroupSequence"
		InvokeMacro="FrameAnatomyMacro"						Condition="FrameAnatomySequenceNotInPerFrameFunctionalGroupSequence"
		InvokeMacro="FrameVOILUTMacro"						Condition="FrameVOILUTMacroOKInSharedFunctionalGroupSequence"
		InvokeMacro="PixelIntensityRelationshipLUTMacro"	Condition="NeedPixelIntensityRelationshipLUTMacroInSharedFunctionalGroupSequence"
		InvokeMacro="IntravascularOCTFrameTypeMacro"		Condition="IntravascularOCTFrameTypeSequenceNotInPerFrameFunctionalGroupSequence"
		InvokeMacro="IntravascularFrameContentMacro"		Condition="IntravascularFrameContentSequenceNotInPerFrameFunctionalGroupSequenceAndAcquisitionIsMeasured"
		InvokeMacro="IntravascularOCTFrameContentMacro"		Condition="IntravascularOCTFrameContentSequenceNotInPerFrameFunctionalGroupSequence"
	SequenceEnd
	Sequence="PerFrameFunctionalGroupsSequence"	Type="1"	VM="1-n"
		InvokeMacro="FrameContentMacro"
		InvokeMacro="DerivationImageMacro"					Condition="DerivationImageMacroOKInPerFrameFunctionalGroupSequence"
		InvokeMacro="CardiacSynchronizationMacro"			Condition="NeedCardiacSynchronizationMacroInPerFrameFunctionalGroupSequence"
		InvokeMacro="FrameAnatomyMacro"						Condition="FrameAnatomySequenceNotInSharedFunctionalGroupSequence"
		InvokeMacro="FrameVOILUTMacro"						Condition="FrameVOILUTMacroOKInPerFrameFunctionalGroupSequence"
		InvokeMacro="PixelIntensityRelationshipLUTMacro"	Condition="NeedPixelIntensityRelationshipLUTMacroInPerFrameFunctionalGroupSequence"
		InvokeMacro="IntravascularOCTFrameTypeMacro"		Condition="IntravascularOCTFrameTypeSequenceNotInSharedFunctionalGroupSequence"
		InvokeMacro="IntravascularFrameContentMacro"		Condition="IntravascularFrameContentSequenceNotInSharedFunctionalGroupSequenceAndAcquisitionIsMeasured"
		InvokeMacro="IntravascularOCTFrameContentMacro"		Condition="IntravascularOCTFrameContentSequenceNotInSharedFunctionalGroupSequence"
	SequenceEnd
ModuleEnd

Module="ParametricMapSeries"
	Name="Modality"												Type="1"
	Name="SeriesNumber"											Type="1"
	Sequence="ReferencedPerformedProcedureStepSequence"			Type="1C"	VM="1"	Condition="SeriesNeedReferencedPerformedProcedureStepSequence"
		InvokeMacro="SOPInstanceReferenceMacro"
	SequenceEnd
ModuleEnd

Module="ParametricMapImage"
	Name="ImageType"										Type="1"	VM="4"
	Verify="ImageType"										ValueSelector="0"	StringEnumValues="ParametricMapImageAndFrameType1"
	Verify="ImageType"										ValueSelector="1"	StringEnumValues="CommonEnhancedImageAndFrameType2"
	Verify="ImageType"										ValueSelector="2"	StringDefinedTerms="CommonEnhancedImageAndFrameType3"
	Verify="ImageType"										ValueSelector="3"	StringDefinedTerms="EnhancedMRImageType4"
	InvokeMacro="ContentIdentificationMacro"
	Name="PixelPresentation"								Type="3"	StringEnumValues="ParametricMapImagePixelPresentation"
	Name="SamplesPerPixel"									Type="1"	BinaryEnumValues="One"
	Name="PhotometricInterpretation"						Type="1"	StringEnumValues="PhotometricInterpretationMonochrome2"
	Name="BitsAllocated"									Type="1"
	Verify="BitsAllocated"												Condition="PixelDataPresent"			BinaryEnumValues="BitsAre16"
	Verify="BitsAllocated"												Condition="FloatPixelDataPresent"		BinaryEnumValues="BitsAre32"
	Verify="BitsAllocated"												Condition="DoubleFloatPixelDataPresent"	BinaryEnumValues="BitsAre64"
	Name="BitsStored"										Type="1C"	Condition="PixelDataPresent"			BinaryEnumValues="BitsAre16"
	Name="HighBit"											Type="1C"	Condition="PixelDataPresent"			BinaryEnumValues="BitsAre15"
	Name="PresentationLUTShape"								Type="1"	StringEnumValues="IdentityPresentationLUTShape"
	Name="LossyImageCompression"							Type="1"	StringEnumValues="LossyImageCompression"
	Name="LossyImageCompressionRatio"						Type="1C"	NoCondition=""
	Name="LossyImageCompressionMethod"						Type="1C"	NoCondition=""
	Verify="LossyImageCompressionMethod"								Condition="LossyImageCompressionMethodInconsistentWithTransferSyntax"	ThenWarningMessage="method inconsistent with Transfer Syntax" ShowValueWithMessage="true"
	Name="BurnedInAnnotation"								Type="1"	StringEnumValues="NoFull"
	Name="RecognizableVisualFeatures"						Type="1"	StringEnumValues="YesNoFull"
	Name="ContentQualification"								Type="1"	StringEnumValues="ContentQualification"
	Name="PaletteColorLookupTableUID"						Type="1C"	Condition="PixelPresentationIsColorRangeAndPaletteColorLookupTableModuleAbsent"
	Name="ICCProfile"										Type="1C"	Condition="PixelPresentationIsColorRange"
	Name="ColorSpace"										Type="3"
ModuleEnd

Module="MultiFrameFunctionalGroupsForParametricMap"
	Sequence="SharedFunctionalGroupsSequence"	Type="1"	VM="1"
		InvokeMacro="PixelMeasuresMacro"					Condition="PixelMeasuresSequenceNotInPerFrameFunctionalGroupSequence"
		InvokeMacro="PlanePositionMacro"					Condition="PlanePositionSequenceNotInPerFrameFunctionalGroupSequenceAndNotSlide"
		InvokeMacro="PlaneOrientationMacro"					Condition="PlaneOrientationSequenceNotInPerFrameFunctionalGroupSequenceAndNotSlide"
		InvokeMacro="PlanePositionSlideMacro"				Condition="PlanePositionSlideSequenceNotInPerFrameFunctionalGroupSequenceAndNotPatientAndNotTILED_FULL"
		InvokeMacro="ReferencedImageMacro"					Condition="ReferencedImageMacroOKInSharedFunctionalGroupSequence"
		InvokeMacro="DerivationImageMacro"					Condition="DerivationImageMacroOKInSharedFunctionalGroupSequence"
		InvokeMacro="CardiacSynchronizationMacro"			Condition="CardiacSynchronizationMacroOKInSharedFunctionalGroupSequence"
		InvokeMacro="FrameAnatomyMacro"						Condition="FrameAnatomySequenceOKInSharedFunctionalGroupSequence"
		InvokeMacro="IdentityPixelValueTransformationMacro"	Condition="PixelValueTransformationSequenceNotInPerFrameFunctionalGroupSequence"
		InvokeMacro="FrameVOILUTWithLUTMacro"				Condition="FrameVOILUTMacroOKInSharedFunctionalGroupSequence"
		InvokeMacro="RealWorldValueMappingMacro"			Condition="RealWorldValueMappingSequenceNotInPerFrameFunctionalGroupSequence"
		InvokeMacro="ContrastBolusUsageMacro"				Condition="NeedContrastBolusUsageMacroInSharedFunctionalGroupSequence"
		InvokeMacro="RespiratorySynchronizationMacro"		Condition="RespiratorySynchronizationMacroOKInSharedFunctionalGroupSequence"
		InvokeMacro="ParametricMapFrameTypeMacro"			Condition="ParametricMapFrameTypeSequenceNotInPerFrameFunctionalGroupSequence"
		InvokeMacro="StoredValueColorRangeMacro"			Condition="StoredValueColorRangeSequenceNotInPerFrameFunctionalGroupSequenceAndPixelPresentationIsColorRange"
		InvokeMacro="UnassignedSharedConvertedAttributesMacro"	Condition="UnassignedSharedConvertedAttributesMacroPresentInSharedFunctionalGroupSequence"
	SequenceEnd
	Sequence="PerFrameFunctionalGroupsSequence"	Type="1C"	VM="1-n"	Condition="PerFrameFunctionalGroupsSequencePresent"
		InvokeMacro="PixelMeasuresMacro"					Condition="PixelMeasuresSequenceNotInSharedFunctionalGroupSequence"
		InvokeMacro="PlanePositionMacro"					Condition="PlanePositionSequenceNotInSharedFunctionalGroupSequenceAndNotSlide"
		InvokeMacro="PlaneOrientationMacro"					Condition="PlaneOrientationSequenceNotInSharedFunctionalGroupSequenceAndNotSlide"
		InvokeMacro="PlanePositionSlideMacro"				Condition="PlanePositionSlideSequenceNotInSharedFunctionalGroupSequenceAndNotPatientAndNotTILED_FULL"
		InvokeMacro="ReferencedImageMacro"					Condition="ReferencedImageMacroOKInPerFrameFunctionalGroupSequence"
		InvokeMacro="DerivationImageMacro"					Condition="DerivationImageMacroOKInPerFrameFunctionalGroupSequence"
		InvokeMacro="FrameContentMacro"
		InvokeMacro="CardiacSynchronizationMacro"			Condition="CardiacSynchronizationMacroOKInPerFrameFunctionalGroupSequence"
		InvokeMacro="FrameAnatomyMacro"						Condition="FrameAnatomySequenceOKInPerFrameSharedFunctionalGroupSequence"
		InvokeMacro="IdentityPixelValueTransformationMacro"	Condition="PixelValueTransformationSequenceNotInSharedFunctionalGroupSequence"
		InvokeMacro="FrameVOILUTWithLUTMacro"				Condition="FrameVOILUTMacroOKInPerFrameFunctionalGroupSequence"
		InvokeMacro="RealWorldValueMappingMacro"			Condition="RealWorldValueMappingSequenceNotInSharedFunctionalGroupSequence"
		InvokeMacro="ContrastBolusUsageMacro"				Condition="NeedContrastBolusUsageMacroInPerFrameFunctionalGroupSequence"
		InvokeMacro="RespiratorySynchronizationMacro"		Condition="RespiratorySynchronizationMacroOKInPerFrameFunctionalGroupSequence"
		InvokeMacro="ParametricMapFrameTypeMacro"			Condition="ParametricMapFrameTypeSequenceNotInSharedFunctionalGroupSequence"
		InvokeMacro="StoredValueColorRangeMacro"			Condition="StoredValueColorRangeSequenceNotInSharedFunctionalGroupSequenceAndPixelPresentationIsColorRange"
		InvokeMacro="UnassignedPerFrameConvertedAttributesMacro"	Condition="UnassignedPerFrameConvertedAttributesMacroPresentInPerFrameFunctionalGroupSequence"
	SequenceEnd
ModuleEnd

DefineMacro="ParametricMapFrameTypeMacro" InformationEntity="FunctionalGroup"
	Sequence="ParametricMapFrameTypeSequence"	Type="1"	VM="1"
		Name="FrameType"						Type="1"	VM="4"
		Verify="FrameType"								ValueSelector="0"	StringEnumValues="ParametricMapImageAndFrameType1"
		Verify="FrameType"								ValueSelector="1"	StringEnumValues="CommonEnhancedImageAndFrameType2"
		Verify="FrameType"								ValueSelector="2"	StringDefinedTerms="CommonEnhancedImageAndFrameType3"
		Verify="FrameType"								ValueSelector="3"	StringDefinedTerms="EnhancedMRFrameType4"
	SequenceEnd
MacroEnd

DefineMacro="StoredValueColorRangeMacro" InformationEntity="FunctionalGroup"
	Sequence="StoredValueColorRangeSequence"	Type="1"	VM="1"
		Name="MinimumStoredValueMapped"			Type="1"				StringEnumValues="YesNoFull"
		Name="MaximumStoredValueMapped"			Type="1"				StringEnumValues="YesNoFull"
	SequenceEnd
MacroEnd

DefineMacro="FrameUsefulnessFunctionalGroupMacro" InformationEntity="FunctionalGroup"
	Sequence="FrameUsefulnessGroupSequence"		Type="1"	VM="1"
		Name="IncludesInformation"				Type="3"
		Name="IncludesImagingSubject"			Type="3"
	SequenceEnd
MacroEnd

DefineMacro="CameraPositionFunctionalGroupMacro" InformationEntity="FunctionalGroup"
	Sequence="CameraPositionGroupSequence"		Type="1"	VM="1"
		Name="RenderProjection"					Type="1"				StringEnumValues="RenderProjection"
		Name="ViewpointPosition"				Type="1"
		Name="ViewpointLookAtPoint"				Type="1"
		Name="ViewpointUpDirection"				Type="1"
		Name="RenderFieldOfView"				Type="1"
	SequenceEnd
MacroEnd

DefineMacro="TimeOfFrameFunctionalGroupMacro" InformationEntity="FunctionalGroup"
	Sequence="TimeOfFrameGroupSequence"			Type="1"	VM="1"
		Name="FrameOriginTimestamp"				Type="1"
	SequenceEnd
MacroEnd

Module="Manufacturing3DModel"
	Sequence="MeasurementUnitsCodeSequence"		Type="1"	VM="1"
		InvokeMacro="CodeSequenceMacro"									DefinedContextID="7063"
	SequenceEnd
	Name="ModelModification"					Type="3"				StringEnumValues="YesNoFull"
	Name="ModelMirroring"						Type="3"				StringEnumValues="YesNoFull"
	Sequence="ModelUsageCodeSequence"			Type="3"	VM="1"
		InvokeMacro="CodeSequenceMacro"									BaselineContextID="7064"
	SequenceEnd
	Name="ContentDescription"					Type="3"
	Sequence="IconImageSequence"				Type="3"	VM="1"
		InvokeMacro="IconImageSequenceMacro"
	SequenceEnd
	Sequence="DerivationAlgorithmSequence"		Type="3"	VM="1"
		InvokeMacro="AlgorithmIdentificationMacro"
	SequenceEnd
ModuleEnd

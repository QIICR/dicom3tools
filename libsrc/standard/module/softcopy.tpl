Module="BitmapDisplayShutter"
	Name="ShutterShape"							Type="1"	StringEnumValues="BitmapShutterShape"
	Name="ShutterOverlayGroup"					Type="1"	BinaryEnumValues="AllPossibleOverlayGroups"
	Name="ShutterPresentationValue"				Type="1"
	Name="ShutterPresentationColorCIELabValue"	Type="3"
ModuleEnd

Module="DisplayedArea"
	Sequence="DisplayedAreaSelectionSequence"		Type="1"	VM="1-n"
		Sequence="ReferencedImageSequence"			Type="1C"	VM="1-n"	NoCondition=""	# realworld
			InvokeMacro="ImageSOPInstanceReferenceMacro"
		SequenceEnd
		Name="PixelOriginInterpretation"			Type="1C"	Condition="VLWholeSlideMicroscopyImageInstance"	mbpo="true"	StringEnumValues="PixelOriginInterpretation"
		Name="DisplayedAreaTopLeftHandCorner"		Type="1"
		Name="DisplayedAreaBottomRightHandCorner"	Type="1"
		Name="PresentationSizeMode"					Type="1"	StringEnumValues="PresentationSizeMode"
		Name="PresentationPixelSpacing"				Type="1C"	NotZeroError=""	Condition="RequirePresentationPixelSpacing"
		Name="PresentationPixelAspectRatio"			Type="1C"	NotZeroError=""	Condition="RequirePresentationPixelAspectRatio"
		Name="PresentationPixelMagnificationRatio"	Type="1C"	NotZeroError=""	Condition="RequirePresentationPixelMagnificationRatio"
	SequenceEnd
ModuleEnd

Module="GraphicAnnotation"
	Sequence="GraphicAnnotationSequence"					Type="1"	VM="1-n"
		Sequence="ReferencedImageSequence"					Type="1C"	VM="1-n"	NoCondition=""	# realworld
			InvokeMacro="ImageSOPInstanceReferenceMacro"
		SequenceEnd
		Name="GraphicLayer"									Type="1"
		Sequence="TextObjectSequence"						Type="1C"	VM="1-n"	Condition="RequireTextObjectSequence"
			Name="BoundingBoxAnnotationUnits"				Type="1C"	Condition="BoundingBoxTopLeftHandCornerOrBottomRightHandCornerPresent"	StringEnumValues="AnnotationUnits"
			Name="AnchorPointAnnotationUnits"				Type="1C"	Condition="AnchorPointPresent"	StringEnumValues="AnnotationUnits"
			Name="UnformattedTextValue"						Type="1"
			Name="BoundingBoxTopLeftHandCorner"				Type="1C"	Condition="BoundingBoxNeeded"
			Name="BoundingBoxBottomRightHandCorner"			Type="1C"	Condition="BoundingBoxNeeded"
			Name="BoundingBoxTextHorizontalJustification"	Type="1C"	Condition="BoundingBoxTopLeftHandCornerPresent"	StringEnumValues="BoundingBoxTextHorizontalJustification"
			Name="AnchorPoint"								Type="1C"	Condition="AnchorPointNeeded" mbpo="true"
			Name="AnchorPointVisibility"					Type="1C"	Condition="AnchorPointPresent"	StringEnumValues="YesNoLetter"
			Name="CompoundGraphicInstanceID"				Type="3"
			Name="GraphicGroupID"							Type="3"
			Name="TrackingID"								Type="1C"	Condition="TrackingUIDIsPresent"
			Name="TrackingUID"								Type="1C"	Condition="TrackingIDIsPresent"
		SequenceEnd
		Sequence="GraphicObjectSequence"					Type="1C"	VM="1-n"	Condition="RequireGraphicObjectSequence"
			Name="GraphicAnnotationUnits"					Type="1"	StringEnumValues="AnnotationUnits"
			Name="GraphicDimensions"						Type="1"	BinaryEnumValues="Two"
			Name="NumberOfGraphicPoints"					Type="1"	NotZeroError=""
			Name="GraphicData"								Type="1"
			Verify="GraphicData"										VM="2"	Condition="GraphicTypeIsPOINT"
			Verify="GraphicData"										VM="4"	Condition="GraphicTypeIsCIRCLE"
			Verify="GraphicData"										VM="8"	Condition="GraphicTypeIsELLIPSE"
			Name="GraphicType"								Type="1"	StringEnumValues="GraphicType"
			InvokeMacro="LineStyleSequenceMacro"
			Name="GraphicFilled"							Type="1C"	NoCondition=""	StringEnumValues="YesNoLetter"	# very hard to check
			InvokeMacro="FillStyleSequenceMacro"
			Name="CompoundGraphicInstanceID"				Type="3"
			Name="GraphicGroupID"							Type="3"
			Name="TrackingID"								Type="1C"	Condition="TrackingUIDIsPresent"
			Name="TrackingUID"								Type="1C"	Condition="TrackingIDIsPresent"
		SequenceEnd
		Sequence="CompoundGraphicSequence"					Type="3"	VM="1-n"
			Name="CompoundGraphicInstanceID"				Type="1"
			Name="CompoundGraphicUnits"						Type="1"	StringEnumValues="CompoundGraphicUnits"
			Name="GraphicDimensions"						Type="1"	BinaryEnumValues="Two"
			Name="NumberOfGraphicPoints"					Type="1"	NotZeroError=""
			Name="GraphicData"								Type="1"
			Name="CompoundGraphicType"						Type="1"	StringEnumValues="CompoundGraphicType"
			InvokeMacro="TextStyleSequenceMacro"
			InvokeMacro="LineStyleSequenceMacro"
			Name="RotationAngle"							Type="3"
			Name="RotationPoint"							Type="1C"	Condition="RotationAngleIsPresentOrCompoundGraphicTypeCUTLINEOrINFINITELINE"
			Name="GapLength"								Type="1C"	Condition="CompoundGraphicTypeCUTLINEOrINFINITELINEOrCROSSHAIR"
			Name="DiameterOfVisibility"						Type="1C"	Condition="CompoundGraphicTypeCROSSHAIR"
			Sequence="MajorTicksSequence"					Type="1C"	VM="2-n"	Condition="CompoundGraphicTypeAXIS"
				Name="TickPosition"							Type="1"
				Name="TickLabel"							Type="1"
			SequenceEnd
			Name="TickAlignment"							Type="1C"	Condition="CompoundGraphicTypeRULEROrAXISOrCROSSHAIR"	StringEnumValues="TickAlignment"
			Name="TickLabelAlignment"						Type="1C"	Condition="CompoundGraphicTypeRULEROrAXISOrCROSSHAIR"	StringEnumValues="TickLabelAlignment"
			Name="ShowTickLabel"							Type="1C"	Condition="CompoundGraphicTypeRULEROrAXISOrCROSSHAIR"	StringEnumValues="YesNoLetter"
			Name="GraphicFilled"							Type="1C"	Condition="CompoundGraphicTypeRECTANGLEOrELLIPSE"		StringEnumValues="YesNoLetter"
			InvokeMacro="FillStyleSequenceMacro"						Condition="GraphicFilledIsY"
			Name="GraphicGroupID"							Type="3"
		SequenceEnd
	SequenceEnd
ModuleEnd

DefineMacro="TextStyleSequenceMacro"
	Sequence="TextStyleSequence"							Type="3"	VM="1"
		Name="FontName"										Type="3"
		Name="FontNameType"									Type="1C"	Condition="FontNameIsPresent"	StringDefinedTerms="FontNameType"
		Name="CSSFontName"									Type="1"
		Name="TextColorCIELabValue"							Type="1"
		Name="HorizontalAlignment"							Type="1C"	NoCondition=""	StringEnumValues="HorizontalAlignment"	# too hard to check BoundingBoxTopLeftHandCorner is in sibling sequence
		Name="VerticalAlignment"							Type="1C"	NoCondition=""	StringEnumValues="VerticalAlignment"	# too hard to check BoundingBoxTopLeftHandCorner is in sibling sequence
		Name="ShadowStyle"									Type="1"	StringEnumValues="ShadowStyle"
		Name="ShadowOffsetX"								Type="1C"	Condition="ShadowStyleNotOFF"
		Name="ShadowOffsetY"								Type="1C"	Condition="ShadowStyleNotOFF"
		Name="ShadowColorCIELabValue"						Type="1C"	Condition="ShadowStyleNotOFF"
		Name="ShadowOpacity"								Type="1C"	Condition="ShadowStyleNotOFF"
		Name="Underlined"									Type="1"	StringEnumValues="YesNoLetter"
		Name="Bold"											Type="1"	StringEnumValues="YesNoLetter"
		Name="Italic"										Type="1"	StringEnumValues="YesNoLetter"
	SequenceEnd
MacroEnd

DefineMacro="LineStyleSequenceMacro"
	Sequence="LineStyleSequence"							Type="3"	VM="1"
		Name="PatternOnColorCIELabValue"					Type="1"
		Name="PatternOffColorCIELabValue"					Type="3"
		Name="PatternOnOpacity"								Type="1"
		Name="PatternOffOpacity"							Type="3"
		Name="LineThickness"								Type="1"
		Name="LineDashingStyle"								Type="1"	StringEnumValues="LineDashingStyle"
		Name="LinePattern"									Type="1C"	Condition="LineDashingStyleDASHED"
		Name="ShadowStyle"									Type="1"	StringEnumValues="ShadowStyle"
		Name="ShadowOffsetX"								Type="1"	# should probably be conditional like in TextStyleSequence - need CP :(
		Name="ShadowOffsetY"								Type="1"	# should probably be conditional like in TextStyleSequence - need CP :(
		Name="ShadowColorCIELabValue"						Type="1"	# should probably be conditional like in TextStyleSequence - need CP :(
		Name="ShadowOpacity"								Type="1"	# should probably be conditional like in TextStyleSequence - need CP :(
	SequenceEnd
MacroEnd

DefineMacro="FillStyleSequenceMacro"
	Sequence="FillStyleSequence"							Type="3"	VM="1"
		Name="PatternOnColorCIELabValue"					Type="1"
		Name="PatternOffColorCIELabValue"					Type="3"
		Name="PatternOnOpacity"								Type="1"
		Name="PatternOffOpacity"							Type="1"
		Name="FillMode"										Type="1"	StringEnumValues="FillMode"
		Name="FillPattern"									Type="1C"	Condition="FillModeSTIPPELED"
	SequenceEnd
MacroEnd

Module="SpatialTransformation"
	Name="ImageRotation"					Type="1"	BinaryEnumValues="ImageRotationValues"
	Name="ImageHorizontalFlip"				Type="1"	StringEnumValues="YesNoLetter"
ModuleEnd

Module="GraphicLayer"
	Sequence="GraphicLayerSequence"							Type="1"	VM="1-n"
		Name="GraphicLayer"									Type="1"
		Name="GraphicLayerOrder"							Type="1"
		Name="GraphicLayerRecommendedDisplayGrayscaleValue"	Type="3"
		Name="GraphicLayerRecommendedDisplayCIELabValue"	Type="3"
		Name="GraphicLayerDescription"						Type="3"
	SequenceEnd

ModuleEnd

Module="GraphicGroup"
	Sequence="GraphicGroupSequence"							Type="1"	VM="1-n"
		Name="GraphicGroupID"								Type="1"
		Name="GraphicGroupLabel"							Type="1"
		Name="GraphicGroupDescription"						Type="3"
	SequenceEnd
ModuleEnd

Module="SoftcopyPresentationLUT"
	Sequence="PresentationLUTSequence"			Type="1C"	VM="1"	Condition="PresentationLUTShapeNotPresent"
		Name="LUTDescriptor"					Type="1"
		Verify="LUTDescriptor"								ValueSelector="2"	BinaryEnumValues="BitsAre8To16"
		Name="LUTExplanation"					Type="3"
		Name="LUTData"							Type="1"
	SequenceEnd
	Name="PresentationLUTShape"					Type="1C"	Condition="PresentationLUTSequenceNotPresent"	StringEnumValues="SoftcopyPresentationLUTShape"
ModuleEnd

Module="OverlayActivation"
	Name="OverlayActivationLayer"				Type="2C"	NoCondition=""	# may require access to referenced image
ModuleEnd

Module="SoftcopyVOILUT"
	Sequence="SoftcopyVOILUTSequence"			Type="1"	VM="1-n"
		Sequence="ReferencedImageSequence"		Type="1C"	VM="1-n"	NoCondition=""	# realworld
			InvokeMacro="ImageSOPInstanceReferenceMacro"
		SequenceEnd
		InvokeMacro="VOILUTMacro"
	SequenceEnd
ModuleEnd

Module="PresentationSeries"
	Name="Modality"								Type="1"	StringEnumValues="PresentationStateModality"
ModuleEnd

Module="PresentationStateIdentification"
	Name="PresentationCreationDate"				Type="1"
	Name="PresentationCreationTime"				Type="1"
	InvokeMacro="ContentIdentificationMacro"
ModuleEnd

DefineMacro="PresentationStateRelationshipMacro"
	Sequence="ReferencedSeriesSequence"			Type="1"	VM="1-n"
		Name="SeriesInstanceUID"				Type="1"
		Sequence="ReferencedImageSequence"		Type="1"	VM="1-n"
			InvokeMacro="ImageSOPInstanceReferenceMacro"
		SequenceEnd
	SequenceEnd
MacroEnd

Module="PresentationStateRelationship"
	InvokeMacro="PresentationStateRelationshipMacro"
ModuleEnd

Module="PresentationStateShutter"
	Name="ShutterPresentationValue"				Type="1C"	Condition="DisplayOrBitmapDisplayShutterModulePresent"
	Name="ShutterPresentationColorCIELabValue"	Type="1C"	Condition="DisplayOrBitmapDisplayShutterModulePresentAndNotGrayscaleSoftcopyPresentationState"
ModuleEnd

Module="PresentationStateMask"
	Sequence="MaskSubtractionSequence"			Type="1C"	VM="1"	Condition="MaskModulePresent"
		Name="MaskOperation"					Type="1"	StringEnumValues="MaskOperationForPresentationState"
		Name="ContrastFrameAveraging"			Type="1"
	SequenceEnd
	Name="RecommendedViewingMode"				Type="1C"	Condition="MaskModulePresent"	StringEnumValues="RecommendedViewingMode"
ModuleEnd

Module="PresentationStateBlending"
	Sequence="BlendingSequence"								Type="1"	VM="2"
		Name="BlendingPosition"								Type="1"	StringEnumValues="BlendingPosition"
		Name="StudyInstanceUID"								Type="1"
		InvokeMacro="PresentationStateRelationshipMacro"
		InvokeMacro="ModalityLUTMacro"
		Sequence="SoftcopyVOILUTSequence"					Type="1C"	VM="1-n"	NoCondition=""	# real-world "if a VOI LUT is to be applied"
			Sequence="ReferencedImageSequence"				Type="1C"	VM="1-n"	NoCondition=""	# real-world "does not apply to all the images and frames in the enclosing Item"
				InvokeMacro="ImageSOPInstanceReferenceMacro"
			SequenceEnd
			InvokeMacro="VOILUTMacro"
		SequenceEnd
	SequenceEnd
	Name="RelativeOpacity"								Type="1"
	Sequence="ReferencedSpatialRegistrationSequence"	Type="3"	VM="1-n"
		InvokeMacro="HierarchicalSOPInstanceReferenceMacro"
	SequenceEnd
ModuleEnd

Module="AdvancedBlendingPresentationState"
	Sequence="AdvancedBlendingSequence"						Type="1"	VM="1-n"
		Name="BlendingInputNumber"							Type="1"
		Name="StudyInstanceUID"								Type="1"
		Name="SeriesInstanceUID"							Type="1"
		Sequence="ReferencedImageSequence"					Type="1C"	VM="1-n"	NoCondition=""
			InvokeMacro="ImageSOPInstanceReferenceMacro"
			Name="ReferencedOpticalPathIdentifier"			Type="1C"	VM="1"	NoCondition=""
		SequenceEnd
		Sequence="ReferencedSpatialRegistrationSequence"	Type="1C"	VM="1"	NoCondition=""	mbpo="true"
			InvokeMacro="HierarchicalSOPInstanceReferenceMacro"
		SequenceEnd
		InvokeMacro="ThresholdSequenceMacro"
		Sequence="SoftcopyVOILUTSequence"					Type="1C"	VM="1-n"	NoCondition=""
			Sequence="ReferencedImageSequence"				Type="1C"	VM="1-n"	NoCondition=""
				InvokeMacro="ImageSOPInstanceReferenceMacro"
				Name="ReferencedOpticalPathIdentifier"		Type="1C"	VM="1"	NoCondition=""
			SequenceEnd
			InvokeMacro="VOILUTMacro"
		SequenceEnd
		Sequence="PaletteColorLookupTableSequence"			Type="1C"	VM="1"	NoCondition=""
			InvokeMacro="PaletteColorLookupTableMacro"
		SequenceEnd
		Name="TimeSeriesBlending"							Type="1C"	StringEnumValues="TrueFalseFull"	NoCondition=""	mbpo="true"
		Name="GeometryForDisplay"							Type="1C"	StringEnumValues="TrueFalseFull"	NoCondition=""	mbpo="true"
	SequenceEnd
ModuleEnd

Module="AdvancedBlendingPresentationStateIDCVOIPaletteOpticalPath"
	Sequence="AdvancedBlendingSequence"						Type="1"	VM="1-n"
		Name="BlendingInputNumber"							Type="1"
		Name="StudyInstanceUID"								Type="1"
		Name="SeriesInstanceUID"							Type="1"
		Sequence="ReferencedImageSequence"					Type="1C"	VM="1-n"	NoCondition=""
			InvokeMacro="ImageSOPInstanceReferenceMacro"
			Name="ReferencedOpticalPathIdentifier"			Type="1C"	VM="1"	NoCondition=""
		SequenceEnd
		Sequence="ReferencedSpatialRegistrationSequence"	Type="1C"	VM="1"	NoCondition=""	mbpo="true"
			InvokeMacro="HierarchicalSOPInstanceReferenceMacro"
		SequenceEnd
		InvokeMacro="ThresholdSequenceMacro"
		Sequence="SoftcopyVOILUTSequence"					Type="1C"	VM="1-n"	NoCondition=""
			Sequence="ReferencedImageSequence"				Type="1C"	VM="1-n"	NoCondition=""
				InvokeMacro="ImageSOPInstanceReferenceMacro"
				Name="ReferencedOpticalPathIdentifier"		Type="1C"	VM="1"	NoCondition=""
			SequenceEnd
			InvokeMacro="VOILUTMacro"
		SequenceEnd
		Sequence="PaletteColorLookupTableSequence"			Type="1C"	VM="1"	NoCondition=""
			InvokeMacro="PaletteColorLookupTableMacro"
		SequenceEnd
		Name="TimeSeriesBlending"							Type="1C"	StringEnumValues="TrueFalseFull"	NoCondition=""	mbpo="true"
		Name="GeometryForDisplay"							Type="1C"	StringEnumValues="TrueFalseFull"	NoCondition=""	mbpo="true"
	SequenceEnd
ModuleEnd

DefineMacro="ThresholdSequenceMacro"
	Sequence="ThresholdSequence"							Type="1C"	VM="1-n"	NoCondition=""
		Name="ThresholdType"								Type="1"	StringEnumValues="ThresholdType"
		Sequence="ThresholdValueSequence"					Type="1"	VM="1-2"
			Name="ThresholdValue"							Type="1"
		SequenceEnd
	SequenceEnd
MacroEnd

Module="AdvancedBlendingPresentationStateDisplay"
	Name="PixelPresentation"								Type="1"	StringEnumValues="AdvancedBlendingPixelPresentation"
	Sequence="BlendingDisplaySequence"						Type="1"	VM="1-n"
		Sequence="BlendingDisplayInputSequence"				Type="1"	VM="1-n"
			Name="BlendingInputNumber"						Type="1"
		SequenceEnd
		Name="RelativeOpacity"								Type="1C"	Condition="BlendingModeIsForeground"
		Name="BlendingMode"									Type="1"	StringEnumValues="BlendingMode"
		Name="BlendingInputNumber"							Type="1C"	NoCondition=""
	SequenceEnd
ModuleEnd

Module="ICCProfile"
	Name="ICCProfile"											Type="1"
	Name="ColorSpace"											Type="3"
ModuleEnd

DefineMacro="HangingProtocolSelectorAttributeContextMacro"
	Name="SelectorSequencePointer"							Type="1C"	NoCondition=""
	Name="FunctionalGroupPointer"							Type="1C"	NoCondition=""
	Name="SelectorSequencePointerPrivateCreator"			Type="1C"	NoCondition=""
	Name="FunctionalGroupPrivateCreator"					Type="1C"	NoCondition=""
	Name="SelectorAttributePrivateCreator"					Type="1C"	NoCondition=""
MacroEnd

DefineMacro="HangingProtocolSelectorAttributeValueMacro"
	Name="SelectorATValue"						Type="1C"	Condition="SelectorAttributeVRIsAT"
	Name="SelectorCSValue"						Type="1C"	Condition="SelectorAttributeVRIsCS"
	Name="SelectorISValue"						Type="1C"	Condition="SelectorAttributeVRIsIS"
	Name="SelectorLOValue"						Type="1C"	Condition="SelectorAttributeVRIsLO"
	Name="SelectorLTValue"						Type="1C"	Condition="SelectorAttributeVRIsLT"
	Name="SelectorPNValue"						Type="1C"	Condition="SelectorAttributeVRIsPN"
	Name="SelectorSHValue"						Type="1C"	Condition="SelectorAttributeVRIsSH"
	Name="SelectorSTValue"						Type="1C"	Condition="SelectorAttributeVRIsST"
	Name="SelectorUTValue"						Type="1C"	Condition="SelectorAttributeVRIsUT"
	Name="SelectorDSValue"						Type="1C"	Condition="SelectorAttributeVRIsDS"
	Name="SelectorFDValue"						Type="1C"	Condition="SelectorAttributeVRIsFD"
	Name="SelectorFLValue"						Type="1C"	Condition="SelectorAttributeVRIsFL"
	Name="SelectorULValue"						Type="1C"	Condition="SelectorAttributeVRIsUL"
	Name="SelectorUSValue"						Type="1C"	Condition="SelectorAttributeVRIsUS"
	Name="SelectorSLValue"						Type="1C"	Condition="SelectorAttributeVRIsSL"
	Name="SelectorSSValue"						Type="1C"	Condition="SelectorAttributeVRIsSS"
	Sequence="SelectorCodeSequenceValue"		Type="1C"	VM="1-n"	Condition="SelectorAttributeVRIsSQ"
		InvokeMacro="CodeSequenceMacro"
	SequenceEnd
MacroEnd

Module="HangingProtocolDefinition"
	Name="HangingProtocolName"									Type="1"
	Name="HangingProtocolDescription"							Type="1"
	Name="HangingProtocolLevel"									Type="1"	StringEnumValues="HangingProtocolLevel"
	Name="HangingProtocolCreator"								Type="1"
	Name="HangingProtocolCreationDateTime"						Type="1"
	Sequence="HangingProtocolDefinitionSequence"				Type="1"	VM="1-n"
		Name="Modality"											Type="1C"	Condition="AnatomicRegionSequenceNotPresent"	StringDefinedTerms="Modality"
		Sequence="AnatomicRegionSequence"						Type="1C"	VM="1-n"	Condition="ModalityNotPresent"
			InvokeMacro="CodeSequenceMacro"
		SequenceEnd
		Name="Laterality"										Type="2C"	Condition="AnatomicRegionSequencePresent"	StringDefinedTerms="ImageLaterality"
		Sequence="ProcedureCodeSequence"						Type="2"	VM="0-n"
			InvokeMacro="CodeSequenceMacro"
		SequenceEnd
		Sequence="ReasonForRequestedProcedureCodeSequence"		Type="2"	VM="0-n"
			InvokeMacro="CodeSequenceMacro"
		SequenceEnd
	SequenceEnd
	Name="NumberOfPriorsReferenced"								Type="1"
	Sequence="ImageSetsSequence"								Type="1"	VM="1-n"
		Sequence="ImageSetSelectorSequence"						Type="1"	VM="1-n"
			Name="ImageSetSelectorUsageFlag"					Type="1"	StringEnumValues="ImageSetSelectorUsageFlag"
			Name="SelectorAttribute"							Type="1"
			Name="SelectorAttributeVR"							Type="1"	StringEnumValues="SelectorAttributeVR"
			InvokeMacro="HangingProtocolSelectorAttributeContextMacro"
			InvokeMacro="HangingProtocolSelectorAttributeValueMacro"
			Name="SelectorValueNumber"							Type="1"
		SequenceEnd
		Sequence="TimeBasedImageSetsSequence"					Type="1"	VM="1-n"
			Name="ImageSetNumber"								Type="1"
			Name="ImageSetSelectorCategory"						Type="1"	StringEnumValues="ImageSetSelectorCategory"
			Name="RelativeTime"									Type="1C"	Condition="ImageSetSelectorCategoryIsRelativeTime"
			Name="RelativeTimeUnits"							Type="1C"	Condition="RelativeTimePresent"	StringEnumValues="RelativeTimeUnits"
			Name="AbstractPriorValue"							Type="1C"	Condition="ImageSetSelectorCategoryIsAbstractPriorAndAbstractPriorCodeSequenceNotPresent"
			Sequence="AbstractPriorCodeSequence"				Type="1C"	VM="1"	Condition="ImageSetSelectorCategoryIsAbstractPriorAndAbstractPriorValueNotPresent"
				InvokeMacro="CodeSequenceMacro"								DefinedContextID="31"
			SequenceEnd
			Name="ImageSetLabel"								Type="3"
		SequenceEnd
	SequenceEnd
	Sequence="HangingProtocolUserIdentificationCodeSequence"	Type="2"	VM="0-1"
		InvokeMacro="CodeSequenceMacro"
	SequenceEnd
	Name="HangingProtocolUserGroupName"							Type="3"
	Sequence="SourceHangingProtocolSequence"					Type="3"	VM="1"
		InvokeMacro="SOPInstanceReferenceMacro"
	SequenceEnd
ModuleEnd

Module="HangingProtocolEnvironment"
	Name="NumberOfScreens"										Type="2"
	Sequence="NominalScreenDefinitionSequence"					Type="2"	VM="0-n"
		InvokeMacro="ScreenSpecificationsMacro"
	SequenceEnd
ModuleEnd

DefineMacro="ScreenSpecificationsMacro"
	Name="NumberOfVerticalPixels"								Type="1"
	Name="NumberOfHorizontalPixels"								Type="1"
	Name="DisplayEnvironmentSpatialPosition"					Type="1"
	Name="ScreenMinimumGrayscaleBitDepth"						Type="1C"	Condition="ScreenMinimumColorBitDepthNotPresent"
	Name="ScreenMinimumColorBitDepth"							Type="1C"	Condition="ScreenMinimumGrayscaleBitDepthNotPresent"
	Name="ApplicationMaximumRepaintTime"						Type="3"
MacroEnd

Module="HangingProtocolDisplay"
	Sequence="DisplaySetsSequence"								Type="1"	VM="1-n"
		Name="DisplaySetNumber"									Type="1"
		Name="DisplaySetLabel"									Type="3"
		Name="DisplaySetPresentationGroup"						Type="1"
		Name="ImageSetNumber"									Type="1"
		Sequence="ImageBoxesSequence"							Type="1"	VM="1-n"	# is sometimes one, and sometimes more than one, depending on whether tiled :(
			Name="ImageBoxNumber"								Type="1"
			Name="DisplayEnvironmentSpatialPosition"			Type="1"
			Name="ImageBoxLayoutType"							Type="1"	StringDefinedTerms="ImageBoxLayoutTypeForHangingProtocol"
			Name="ImageBoxTileHorizontalDimension"				Type="1C"	Condition="ImageBoxLayoutTypeIsTiled"
			Name="ImageBoxTileVerticalDimension"				Type="1C"	Condition="ImageBoxLayoutTypeIsTiled"
			Name="ImageBoxScrollDirection"						Type="1C"	Condition="ImageBoxLayoutTypeIsTiledAndMoreThanOneTile"	StringEnumValues="ImageBoxScrollDirection"
			Name="ImageBoxSmallScrollType"						Type="2C"	Condition="ImageBoxLayoutTypeIsTiledAndMoreThanOneTile"	StringEnumValues="ImageBoxScrollType"
			Name="ImageBoxSmallScrollAmount"					Type="1C"	Condition="ImageBoxSmallScrollTypePresentWithValue"
			Name="ImageBoxLargeScrollType"						Type="2C"	Condition="ImageBoxLayoutTypeIsTiledAndMoreThanOneTile"	StringEnumValues="ImageBoxScrollType"
			Name="ImageBoxLargeScrollAmount"					Type="1C"	Condition="ImageBoxLargeScrollTypePresentWithValue"
			Name="ImageBoxOverlapPriority"						Type="3"	# should check value is between 1 and 100
			Name="PreferredPlaybackSequencing"					Type="1C"	Condition="ImageBoxLayoutTypeIsCine"	BinaryEnumValues="PreferredPlaybackSequencingForHangingProtocol"
			Name="RecommendedDisplayFrameRate"					Type="1C"	Condition="ImageBoxLayoutTypeIsCineAndCineRelativeToRealTimeNotPresent"
			Name="CineRelativeToRealTime"						Type="1C"	Condition="ImageBoxLayoutTypeIsCineAndRecommendedDisplayFrameRateNotPresent"
		SequenceEnd
		Sequence="FilterOperationsSequence"						Type="2"	VM="0-n"
			Name="FilterByCategory"								Type="1C"	Condition="SelectorAttributeNotPresent"	StringDefinedTerms="FilterByCategory"
			Name="FilterByAttributePresence"					Type="1C"	Condition="SelectorAttributePresentAndFilterByOperatorNotPresent"	StringDefinedTerms="FilterByAttributePresence"
			Name="SelectorAttribute"							Type="1C"	Condition="FilterByCategoryNotPresent"
			Name="SelectorAttributeVR"							Type="1C"	Condition="SelectorAttributeOrFilterByCategoryAndFilterByOperatorPresent"
			InvokeMacro="HangingProtocolSelectorAttributeContextMacro"
			InvokeMacro="HangingProtocolSelectorAttributeValueMacro"
			Name="SelectorValueNumber"							Type="1C"	Condition="SelectorAttributeAndFilterByOperatorPresent"
			Name="FilterByOperator"								Type="1C"	Condition="SelectorAttributePresentAndFilterByAttributePresenceNotPresentOrFilterByCategoryPresent"	StringEnumValues="FilterByOperator"
			Name="ImageSetSelectorUsageFlag"					Type="3"	StringEnumValues="ImageSetSelectorUsageFlag"
		SequenceEnd
		Sequence="SortingOperationsSequence"					Type="2"	VM="0-n"
			Name="SelectorAttribute"							Type="1C"	Condition="SortByCategoryNotPresent"
			InvokeMacro="HangingProtocolSelectorAttributeContextMacro"
			Name="SelectorValueNumber"							Type="1C"	Condition="SelectorAttributePresent"
			Name="SortByCategory"								Type="1C"	Condition="SelectorAttributeNotPresent"	StringDefinedTerms="SortByCategory"
			Name="SortingDirection"								Type="1"	StringEnumValues="SortingDirection"
		SequenceEnd
		Name="BlendingOperationType"							Type="3"	StringDefinedTerms="BlendingOperationType"
		Name="ReformattingOperationType"						Type="3"	StringDefinedTerms="ReformattingOperationType"
		Name="ReformattingThickness"							Type="1C"	Condition="ReformattingOperationTypeIsSlabOrMPR"
		Name="ReformattingInterval"								Type="1C"	Condition="ReformattingOperationTypeIsSlabOrMPR"
		Name="ReformattingOperationInitialViewDirection"		Type="1C"	Condition="ReformattingOperationTypeIsMPROr3D"	StringDefinedTerms="ReformattingOperationInitialViewDirection"
		Name="ThreeDRenderingType"								Type="1C"	Condition="ReformattingOperationTypeIs3D"	StringDefinedTerms="ThreeDRenderingType"
		Name="DisplaySetPatientOrientation"						Type="3"
		Name="DisplaySetHorizontalJustification"				Type="3"	StringEnumValues="DisplaySetHorizontalJustification"
		Name="DisplaySetVerticalJustification"					Type="3"	StringEnumValues="DisplaySetVerticalJustification"
		Name="VOIType"											Type="3"	StringDefinedTerms="VOIType"
		Name="PseudoColorType"									Type="3"	StringDefinedTerms="PseudoColorType"
		Name="ShowGrayscaleInverted"							Type="3"	StringDefinedTerms="YesNoFull"
		Name="ShowImageTrueSizeFlag"							Type="3"	StringDefinedTerms="YesNoFull"
		Name="ShowGraphicAnnotationFlag"						Type="3"	StringDefinedTerms="YesNoFull"
		Name="ShowPatientDemographicsFlag"						Type="3"	StringDefinedTerms="YesNoFull"
		Name="ShowAcquisitionTechniquesFlag"					Type="3"	StringDefinedTerms="YesNoFull"
		Name="DisplaySetPresentationGroupDescription"			Type="3"
	SequenceEnd
	Name="PartialDataDisplayHandling"							Type="3"	StringEnumValues="PartialDataDisplayHandling"
	Sequence="SynchronizedScrollingSequence"					Type="3"	VM="1-n"
		Name="DisplaySetScrollingGroup"							Type="1"
	SequenceEnd
	Sequence="NavigationIndicatorSequence"						Type="3"	VM="1-n"
		Name="NavigationDisplaySet"								Type="1C"	NoCondition=""	# real world
		Name="ReferenceDisplaySets"								Type="1"
	SequenceEnd
ModuleEnd

Module="ColorPaletteDefinition"
	InvokeMacro="ContentIdentificationMacro"
ModuleEnd

Module="StructuredDisplay"
	InvokeMacro="ContentIdentificationMacro"
	Name="PresentationCreationDate"								Type="1"
	Name="PresentationCreationTime"								Type="1"
	Name="NumberOfScreens"										Type="1"
	Verify="NumberOfScreens"												BinaryEnumValues="One"	Condition="BasicStructuredDisplayInstance"
	Sequence="NominalScreenDefinitionSequence"					Type="1"	VM="1-n"	# should check length is == NumberOfScreens, but no mechanism for that :(
		InvokeMacro="ScreenSpecificationsMacro"
	SequenceEnd
	Sequence="IconImageSequence"								Type="3"	VM="1"
		InvokeMacro="IconImageSequenceMacro"
	SequenceEnd
	Name="StructuredDisplayBackgroundCIELabValue"				Type="3"
	Name="EmptyImageBoxCIELabValue"								Type="3"
	Name="HangingProtocolName"									Type="3"
	Name="HangingProtocolCreator"								Type="3"
ModuleEnd

Module="StructuredDisplayImageBox"
	Sequence="StructuredDisplayImageBoxSequence"				Type="1"	VM="1-n"
		Name="DisplayEnvironmentSpatialPosition"				Type="1"
		Name="ImageBoxNumber"									Type="1"
		Name="ImageBoxLayoutType"								Type="1"	StringDefinedTerms="ImageBoxLayoutTypeForStructuredDisplay"
		Name="ImageBoxOverlapPriority"							Type="3"
		Verify="ImageBoxOverlapPriority"									Condition="ImageBoxOverlapPriorityValueNot1To100"	ThenErrorMessage="Is not a positive integer in the range 1 to 100" ShowValueWithMessage="true"
		Name="DisplaySetHorizontalJustification"				Type="3"	StringEnumValues="DisplaySetHorizontalJustification"
		Name="DisplaySetVerticalJustification"					Type="3"	StringEnumValues="DisplaySetVerticalJustification"
		Name="PreferredPlaybackSequencing"						Type="1C"	Condition="ImageBoxLayoutTypeIsCine"	BinaryEnumValues="PreferredPlaybackSequencingForStructuredDisplay"
		Name="RecommendedDisplayFrameRate"						Type="1C"	Condition="ImageBoxLayoutTypeIsCineAndCineRelativeToRealTimeNotPresent"
		Verify="RecommendedDisplayFrameRate"								Condition="RecommendedDisplayFrameRateNotGreaterThanZero"	ThenErrorMessage="Is not greater than 0" ShowValueWithMessage="true"
		Name="CineRelativeToRealTime"							Type="1C"	Condition="ImageBoxLayoutTypeIsCineAndRecommendedDisplayFrameRateNotPresent"
		Verify="CineRelativeToRealTime"										Condition="CineRelativeToRealTimeNotGreaterThanZero"	ThenErrorMessage="Is not greater than 0" ShowValueWithMessage="true"
		Name="InitialCineRunState"								Type="1C"	Condition="ImageBoxLayoutTypeIsCine"	StringDefinedTerms="InitialCineRunState"
		Name="StartTrim"										Type="2C"	Condition="ImageBoxLayoutTypeIsCine"
		Name="StopTrim"											Type="2C"	Condition="ImageBoxLayoutTypeIsCine"
		Sequence="ReferencedFirstFrameSequence"					Type="2C"	VM="0-1"	Condition="ImageBoxLayoutTypeIsStack"
			InvokeMacro="ImageSOPInstanceReferenceMacro"
		SequenceEnd
		Sequence="ReferencedImageSequence"						Type="2C"	VM="0-n"	Condition="NoReferencedPresentationStateOrStereometricInstanceOrInstance"
			InvokeMacro="ImageSOPInstanceReferenceMacro"
			Sequence="ReferencedPresentationStateSequence"		Type="1C"	VM="1"		NoCondition=""
				InvokeMacro="SOPInstanceReferenceMacro"
			SequenceEnd
		SequenceEnd
		Sequence="ReferencedPresentationStateSequence"			Type="1C"	VM="1"		Condition="NoReferencedImageOrStereometricInstanceOrInstance"
			InvokeMacro="SOPInstanceReferenceMacro"
		SequenceEnd
		Sequence="ReferencedInstanceSequence"					Type="1C"	VM="1"		Condition="NoReferencedPresentationStateOrStereometricInstanceOrImage"
			InvokeMacro="SOPInstanceReferenceMacro"
		SequenceEnd
		Sequence="ReferencedStereometricInstanceSequence"		Type="1C"	VM="1"		Condition="NoReferencedPresentationStateOrInstanceOrImage"
			InvokeMacro="SOPInstanceReferenceMacro"
		SequenceEnd
	SequenceEnd
	Sequence="ImageBoxSynchronizationSequence"					Type="1C"	VM="1-n"	NoCondition=""
		Name="SynchronizedImageBoxList"							Type="1"	VM="2-n"
		Name="TypeOfSynchronization"							Type="1"				StringEnumValues="TypeOfSynchronizationBetweenImageBoxes"
	SequenceEnd
ModuleEnd

Module="StructuredDisplayAnnotation"
	Sequence="StructuredDisplayTextBoxSequence"					Type="1"	VM="1-n"
		Name="UnformattedTextValue"								Type="1"
		Name="DisplayEnvironmentSpatialPosition"				Type="1"
		Name="BoundingBoxTextHorizontalJustification"			Type="1"				StringEnumValues="BoundingBoxTextHorizontalJustification"
		Name="GraphicLayerRecommendedDisplayCIELabValue"		Type="3"
	SequenceEnd
ModuleEnd



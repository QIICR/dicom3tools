CompositeIOD="EnhancedMRImage"			Condition="EnhancedMRImageInstance"
	InformationEntity="File"
		Module="FileMetaInformation"							Usage="C"	Condition="NeedModuleFileMetaInformation"
	InformationEntityEnd
	InformationEntity="Patient"
		Module="Patient"										Usage="M"
		Module="ClinicalTrialSubject"							Usage="U"	Condition="NeedModuleClinicalTrialSubject"
	InformationEntityEnd
	InformationEntity="Study"
		Module="GeneralStudy"									Usage="M"
		Module="PatientStudy"									Usage="U"	# no condition ... all attributes type 3
		Module="ClinicalTrialStudy"								Usage="U"	Condition="NeedModuleClinicalTrialStudy"
	InformationEntityEnd
	InformationEntity="Series"
		Module="GeneralSeries"									Usage="M"
		Module="ClinicalTrialSeries"							Usage="U"	Condition="NeedModuleClinicalTrialSeries"
		Module="MRSeries"										Usage="M"
	InformationEntityEnd
	InformationEntity="FrameOfReference"
		Module="FrameOfReference"								Usage="M"
		Module="Synchronization"								Usage="U"	Condition="NeedToCheckModuleSynchronization"
	InformationEntityEnd
	InformationEntity="Equipment"
		Module="GeneralEquipment"								Usage="M"
		Module="EnhancedGeneralEquipment"						Usage="M"
	InformationEntityEnd
	InformationEntity="Image"
		Module="ImagePixel"										Usage="M"
		Module="EnhancedContrastBolus"							Usage="C"	Condition="NeedModuleEnhancedContrastBolus"
		Module="MultiFrameFunctionalGroupsCommon"				Usage="M"
		Module="MultiFrameFunctionalGroupsForEnhancedMRImage"	Usage="M"
		Module="MultiFrameDimension"							Usage="M"
		Module="CardiacSynchronization"							Usage="C"	Condition="NeedModuleCardiacSynchronization"
		Module="RespiratorySynchronization"						Usage="C"	Condition="NeedModuleRespiratorySynchronization"
		Module="BulkMotionSynchronization"						Usage="C"	Condition="NeedModuleBulkMotion"
		Module="SupplementalPaletteColorLUT"					Usage="C"	Condition="NeedModuleSupplementalPaletteColorLUT"
		Module="AcquisitionContext"								Usage="M"
		Module="Device"											Usage="U"	Condition="NeedModuleDevice"
		Module="Specimen"										Usage="U"	Condition="NeedModuleSpecimen"
		Module="EnhancedMRImage"								Usage="M"
		Module="MRPulseSequence"								Usage="C"	Condition="NeedModuleMRPulseSequence"
		Module="ICCProfile"										Usage="U"	Condition="NeedModuleICCProfile"
		Module="SOPCommon"										Usage="M"
		Module="CommonInstanceReference"						Usage="U"	Condition="NeedModuleCommonInstanceReference"
		Module="FrameExtraction"								Usage="C"	Condition="NeedModuleFrameExtraction"
	InformationEntityEnd
CompositeIODEnd

CompositeIOD="EnhancedMRColorImage"			Condition="EnhancedMRColorImageInstance"
	InformationEntity="File"
		Module="FileMetaInformation"							Usage="C"	Condition="NeedModuleFileMetaInformation"
	InformationEntityEnd
	InformationEntity="Patient"
		Module="Patient"										Usage="M"
		Module="ClinicalTrialSubject"							Usage="U"	Condition="NeedModuleClinicalTrialSubject"
	InformationEntityEnd
	InformationEntity="Study"
		Module="GeneralStudy"									Usage="M"
		Module="PatientStudy"									Usage="U"	# no condition ... all attributes type 3
		Module="ClinicalTrialStudy"								Usage="U"	Condition="NeedModuleClinicalTrialStudy"
	InformationEntityEnd
	InformationEntity="Series"
		Module="GeneralSeries"									Usage="M"
		Module="ClinicalTrialSeries"							Usage="U"	Condition="NeedModuleClinicalTrialSeries"
		Module="MRSeries"										Usage="M"
	InformationEntityEnd
	InformationEntity="FrameOfReference"
		Module="FrameOfReference"								Usage="M"
		Module="Synchronization"								Usage="U"	Condition="NeedToCheckModuleSynchronization"
	InformationEntityEnd
	InformationEntity="Equipment"
		Module="GeneralEquipment"								Usage="M"
		Module="EnhancedGeneralEquipment"						Usage="M"
	InformationEntityEnd
	InformationEntity="Image"
		Module="ImagePixel"										Usage="M"
		Module="EnhancedContrastBolus"							Usage="C"	Condition="NeedModuleEnhancedContrastBolus"
		Module="MultiFrameFunctionalGroupsCommon"				Usage="M"
		Module="MultiFrameFunctionalGroupsForEnhancedMRImage"	Usage="M"
		Module="MultiFrameDimension"							Usage="M"
		Module="CardiacSynchronization"							Usage="C"	Condition="NeedModuleCardiacSynchronization"
		Module="RespiratorySynchronization"						Usage="C"	Condition="NeedModuleRespiratorySynchronization"
		Module="BulkMotionSynchronization"						Usage="C"	Condition="NeedModuleBulkMotion"
		Module="SupplementalPaletteColorLUT"					Usage="C"	Condition="NeedModuleSupplementalPaletteColorLUT"
		Module="AcquisitionContext"								Usage="M"
		Module="Device"											Usage="U"	Condition="NeedModuleDevice"
		Module="Specimen"										Usage="C"	Condition="NeedModuleSpecimen"
		Module="EnhancedMRImage"								Usage="M"
		Module="MRPulseSequence"								Usage="C"	Condition="NeedModuleMRPulseSequence"
		Module="ICCProfile"										Usage="M"
		Module="SOPCommon"										Usage="M"
		Module="CommonInstanceReference"						Usage="U"	Condition="NeedModuleCommonInstanceReference"
		Module="FrameExtraction"								Usage="C"	Condition="NeedModuleFrameExtraction"
	InformationEntityEnd
CompositeIODEnd

CompositeIOD="MRSpectroscopy"			Condition="MRSpectroscopyInstance"
	InformationEntity="File"
		Module="FileMetaInformation"							Usage="C"	Condition="NeedModuleFileMetaInformation"
	InformationEntityEnd
	InformationEntity="Patient"
		Module="Patient"										Usage="M"
		Module="ClinicalTrialSubject"							Usage="U"	Condition="NeedModuleClinicalTrialSubject"
	InformationEntityEnd
	InformationEntity="Study"
		Module="GeneralStudy"									Usage="M"
		Module="PatientStudy"									Usage="U"	# no condition ... all attributes type 3
		Module="ClinicalTrialStudy"								Usage="U"	Condition="NeedModuleClinicalTrialStudy"
	InformationEntityEnd
	InformationEntity="Series"
		Module="GeneralSeries"									Usage="M"
		Module="ClinicalTrialSeries"							Usage="U"	Condition="NeedModuleClinicalTrialSeries"
		Module="MRSeries"										Usage="M"
	InformationEntityEnd
	InformationEntity="FrameOfReference"
		Module="FrameOfReference"								Usage="M"
		Module="Synchronization"								Usage="U"	Condition="NeedToCheckModuleSynchronization"
	InformationEntityEnd
	InformationEntity="Equipment"
		Module="GeneralEquipment"								Usage="M"
		Module="EnhancedGeneralEquipment"						Usage="M"
	InformationEntityEnd
	InformationEntity="MRSpectroscopy"
		Module="EnhancedContrastBolus"							Usage="C"	Condition="NeedModuleEnhancedContrastBolus"
		Module="MultiFrameFunctionalGroupsCommon"				Usage="M"
		Module="MultiFrameFunctionalGroupsForMRSpectroscopy"	Usage="M"
		Module="MultiFrameDimension"							Usage="M"
		Module="CardiacSynchronization"							Usage="C"	Condition="NeedModuleCardiacSynchronization"
		Module="RespiratorySynchronization"						Usage="C"	Condition="NeedModuleRespiratorySynchronization"
		Module="BulkMotionSynchronization"						Usage="C"	Condition="NeedModuleBulkMotion"
		Module="AcquisitionContext"								Usage="M"
		Module="Specimen"										Usage="U"	Condition="NeedModuleSpecimen"
		Module="MRSpectroscopy"									Usage="M"
		Module="MRSpectroscopyPulseSequence"					Usage="C"	Condition="NeedModuleMRSpectroscopyPulseSequence"
		Module="MRSpectroscopyData"								Usage="M"
		Module="SOPCommon"										Usage="M"
		Module="FrameExtraction"								Usage="C"	Condition="NeedModuleFrameExtraction"
	InformationEntityEnd
CompositeIODEnd

CompositeIOD="RawData"			Condition="RawDataInstance"
	InformationEntity="File"
		Module="FileMetaInformation"		Usage="C"	Condition="NeedModuleFileMetaInformation"
	InformationEntityEnd
	InformationEntity="Patient"
		Module="Patient"					Usage="M"
		Module="ClinicalTrialSubject"		Usage="U"	Condition="NeedModuleClinicalTrialSubject"
	InformationEntityEnd
	InformationEntity="Study"
		Module="GeneralStudy"				Usage="M"
		Module="PatientStudy"				Usage="U"	# no condition ... all attributes type 3
		Module="ClinicalTrialStudy"			Usage="U"	Condition="NeedModuleClinicalTrialStudy"
	InformationEntityEnd
	InformationEntity="Series"
		Module="GeneralSeries"				Usage="M"
		Module="ClinicalTrialSeries"		Usage="U"	Condition="NeedModuleClinicalTrialSeries"
	InformationEntityEnd
	InformationEntity="FrameOfReference"
		Module="FrameOfReference"			Usage="U"	Condition="NeedModuleFrameOfReference"
		Module="Synchronization"			Usage="C"	Condition="NeedToCheckModuleSynchronization"
	InformationEntityEnd
	InformationEntity="Equipment"
		Module="GeneralEquipment"			Usage="M"
	InformationEntityEnd
	InformationEntity="RawData"
		Module="AcquisitionContext"			Usage="M"
		Module="Specimen"					Usage="U"	Condition="NeedModuleSpecimen"
		Module="RawData"					Usage="M"
		Module="SOPCommon"					Usage="M"
	InformationEntityEnd
CompositeIODEnd

CompositeIOD="LegacyConvertedEnhancedMRImage"	Condition="LegacyConvertedEnhancedMRImageInstance"
	InformationEntity="File"
		Module="FileMetaInformation"							Usage="C"	Condition="NeedModuleFileMetaInformation"
	InformationEntityEnd
	InformationEntity="Patient"
		Module="Patient"										Usage="M"
		Module="ClinicalTrialSubject"							Usage="U"	Condition="NeedModuleClinicalTrialSubject"
	InformationEntityEnd
	InformationEntity="Study"
		Module="GeneralStudy"									Usage="M"
		Module="PatientStudy"									Usage="U"	# no condition ... all attributes type 3
		Module="ClinicalTrialStudy"								Usage="U"	Condition="NeedModuleClinicalTrialStudy"
	InformationEntityEnd
	InformationEntity="Series"
		Module="GeneralSeries"									Usage="M"
		Module="ClinicalTrialSeries"							Usage="U"	Condition="NeedModuleClinicalTrialSeries"
		Module="MRSeries"										Usage="M"
	InformationEntityEnd
	InformationEntity="FrameOfReference"
		Module="FrameOfReference"								Usage="M"
		Module="Synchronization"								Usage="U"	Condition="NeedToCheckModuleSynchronization"
	InformationEntityEnd
	InformationEntity="Equipment"
		Module="GeneralEquipment"								Usage="M"
		Module="EnhancedGeneralEquipment"						Usage="U"	Condition="EnhancedGeneralEquipmentIsPresent"
	InformationEntityEnd
	InformationEntity="Image"
		Module="ImagePixel"										Usage="M"
		Module="ContrastBolus"									Usage="U"	Condition="NeedModuleContrastBolus"
		Module="EnhancedContrastBolus"							Usage="U"	Condition="NeedModuleEnhancedContrastBolus"
		Module="MultiFrameFunctionalGroupsCommon"				Usage="M"
		Module="MultiFrameFunctionalGroupsForLegacyConvertedEnhancedMRImage"	Usage="M"
		Module="MultiFrameDimension"							Usage="U"	Condition="NeedModuleMultiFrameDimension"
		Module="CardiacSynchronization"							Usage="U"	Condition="NeedModuleCardiacSynchronization"
		Module="RespiratorySynchronization"						Usage="U"	Condition="NeedModuleRespiratorySynchronization"
		Module="BulkMotionSynchronization"						Usage="U"	Condition="NeedModuleBulkMotion"
		Module="AcquisitionContext"								Usage="M"
		Module="Device"											Usage="U"	Condition="NeedModuleDevice"
		Module="Specimen"										Usage="U"	Condition="NeedModuleSpecimen"
		Module="EnhancedMRImage"								Usage="M"
		Module="SOPCommon"										Usage="M"
		Module="CommonInstanceReference"						Usage="U"	Condition="NeedModuleCommonInstanceReference"
		Module="FrameExtraction"								Usage="C"	Condition="NeedModuleFrameExtraction"
	InformationEntityEnd
CompositeIODEnd

CompositeIOD="PrivatePixelMedLegacyConvertedEnhancedMRImage"	Condition="PrivatePixelMedLegacyConvertedEnhancedMRImageInstance"
	InformationEntity="File"
		Module="FileMetaInformation"							Usage="C"	Condition="NeedModuleFileMetaInformation"
	InformationEntityEnd
	InformationEntity="Patient"
		Module="Patient"										Usage="M"
		Module="ClinicalTrialSubject"							Usage="U"	Condition="NeedModuleClinicalTrialSubject"
	InformationEntityEnd
	InformationEntity="Study"
		Module="GeneralStudy"									Usage="M"
		Module="PatientStudy"									Usage="U"	# no condition ... all attributes type 3
		Module="ClinicalTrialStudy"								Usage="U"	Condition="NeedModuleClinicalTrialStudy"
	InformationEntityEnd
	InformationEntity="Series"
		Module="GeneralSeries"									Usage="M"
		Module="ClinicalTrialSeries"							Usage="U"	Condition="NeedModuleClinicalTrialSeries"
		Module="MRSeries"										Usage="M"
	InformationEntityEnd
	InformationEntity="FrameOfReference"
		Module="FrameOfReference"								Usage="M"
		Module="Synchronization"								Usage="U"	Condition="NeedToCheckModuleSynchronization"
	InformationEntityEnd
	InformationEntity="Equipment"
		Module="GeneralEquipment"								Usage="M"
		Module="EnhancedGeneralEquipment"						Usage="U"	Condition="EnhancedGeneralEquipmentIsPresent"
	InformationEntityEnd
	InformationEntity="Image"
		Module="ImagePixel"										Usage="M"
		Module="ContrastBolus"									Usage="C"	Condition="NeedModuleContrastBolus"
		Module="MultiFrameFunctionalGroupsCommon"				Usage="M"
		Module="MultiFrameFunctionalGroupsForPrivatePixelMedLegacyConvertedEnhancedMRImage"	Usage="M"
		Module="MultiFrameDimension"							Usage="C"	Condition="NeedModuleMultiFrameDimension"
		Module="CardiacSynchronization"							Usage="C"	Condition="NeedModuleCardiacSynchronization"
		Module="RespiratorySynchronization"						Usage="C"	Condition="NeedModuleRespiratorySynchronization"
		Module="BulkMotionSynchronization"						Usage="C"	Condition="NeedModuleBulkMotion"
		Module="AcquisitionContext"								Usage="M"
		Module="Device"											Usage="U"	Condition="NeedModuleDevice"
		Module="Specimen"										Usage="U"	Condition="NeedModuleSpecimen"
		Module="EnhancedMRImage"								Usage="M"
		Module="SOPCommon"										Usage="M"
		Module="CommonInstanceReference"						Usage="U"	Condition="NeedModuleCommonInstanceReference"
		Module="FrameExtraction"								Usage="C"	Condition="NeedModuleFrameExtraction"
	InformationEntityEnd
CompositeIODEnd

CompositeIOD="TractographyResults" Condition="TractographyResultsInstance"
	InformationEntity="File"
		Module="FileMetaInformation"							Usage="C"	Condition="NeedModuleFileMetaInformation"
	InformationEntityEnd
	InformationEntity="Patient"
		Module="Patient"										Usage="M"
		Module="ClinicalTrialSubject"							Usage="U"	Condition="NeedModuleClinicalTrialSubject"
	InformationEntityEnd
	InformationEntity="Study"
		Module="GeneralStudy"									Usage="M"
		Module="PatientStudy"									Usage="U"	# no condition ... all attributes type 3
		Module="ClinicalTrialStudy"								Usage="U"	Condition="NeedModuleClinicalTrialStudy"
	InformationEntityEnd
	InformationEntity="Series"
		Module="GeneralSeries"									Usage="M"
		Module="TractographyResultsSeries"						Usage="M"
		Module="ClinicalTrialSeries"							Usage="U"	Condition="NeedModuleClinicalTrialSeries"
	InformationEntityEnd
	InformationEntity="FrameOfReference"
		Module="FrameOfReference"								Usage="M"
	InformationEntityEnd
	InformationEntity="Equipment"
		Module="GeneralEquipment"								Usage="M"
		Module="EnhancedGeneralEquipment"						Usage="M"
	InformationEntityEnd
	InformationEntity="TractographyResults"
		Module="TractographyResults"							Usage="M"
		Module="Specimen"										Usage="U"	Condition="NeedModuleSpecimen"
		Module="CommonInstanceReference"						Usage="M"
		Module="SOPCommon"										Usage="M"
	InformationEntityEnd
CompositeIODEnd


CompositeIOD="VLEndoscopicImage"		Condition="VisibleLightEndoscopicImageInstance"
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
		Module="VLEndoscopicSeriesPseudo"	Usage="M"	# not in standard ... use to check conditions
		Module="ClinicalTrialSeries"		Usage="U"	Condition="NeedModuleClinicalTrialSeries"
	InformationEntityEnd
	InformationEntity="Equipment"
		Module="GeneralEquipment"			Usage="M"
	InformationEntityEnd
	InformationEntity="Image"
		Module="GeneralImage"				Usage="M"
		Module="GeneralReference"			Usage="U"	Condition="NeedModuleGeneralReference"
		Module="ImagePixel"					Usage="M"
		Module="AcquisitionContext"			Usage="M"	# not check for baseline CIDs yet
		Module="Device"						Usage="U"	Condition="NeedModuleDevice"
		Module="Specimen"					Usage="U"	Condition="NeedModuleSpecimen"
		Module="VLImage"					Usage="M"
		Module="OverlayPlane"				Usage="U"	Condition="NeedModuleOverlayPlane"
		Module="ICCProfile"					Usage="U"	Condition="NeedModuleICCProfile"
		Module="CheckSingleFramePseudo"		Usage="M"
		Module="SOPCommon"					Usage="M"
		Module="CommonInstanceReference"	Usage="U"	Condition="NeedModuleCommonInstanceReference"
	InformationEntityEnd
CompositeIODEnd

CompositeIOD="VLMicroscopicImage"		Condition="VisibleLightMicroscopicImageInstance"
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
		Module="VLMicroscopicSeriesPseudo"	Usage="M"	# not in standard ... use to check conditions
		Module="ClinicalTrialSeries"		Usage="U"	Condition="NeedModuleClinicalTrialSeries"
	InformationEntityEnd
	InformationEntity="Equipment"
		Module="GeneralEquipment"			Usage="M"
	InformationEntityEnd
	InformationEntity="Image"
		Module="GeneralImage"				Usage="M"
		Module="GeneralReference"			Usage="U"	Condition="NeedModuleGeneralReference"
		Module="ImagePixel"					Usage="M"
		Module="AcquisitionContext"			Usage="M"	# not check for baseline CIDs yet
		Module="Device"						Usage="U"	Condition="NeedModuleDevice"
		Module="Specimen"					Usage="C"	Condition="NeedModuleSpecimen"	# real-world "is a specimen"
		Module="VLImage"					Usage="M"
		Module="OpticalPath"				Usage="U"	Condition="NeedModuleOpticalPath"
		Module="OverlayPlane"				Usage="U"	Condition="NeedModuleOverlayPlane"
		Module="ICCProfile"					Usage="U"	Condition="NeedModuleICCProfile"
		Module="CheckSingleFramePseudo"		Usage="M"
		Module="SOPCommon"					Usage="M"
		Module="CommonInstanceReference"	Usage="U"	Condition="NeedModuleCommonInstanceReference"
	InformationEntityEnd
CompositeIODEnd

CompositeIOD="VLSlideCoordinatesMicroscopicImage"		Condition="VisibleLightSlideCoordinatesMicroscopicImageInstance"
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
		Module="VLSlideCoordinatesMicroscopicSeriesPseudo"	Usage="M"	# not in standard ... use to check conditions
		Module="ClinicalTrialSeries"		Usage="U"	Condition="NeedModuleClinicalTrialSeries"
	InformationEntityEnd
	InformationEntity="FrameOfReference"
		Module="FrameOfReference"			Usage="M"
	InformationEntityEnd
	InformationEntity="Equipment"
		Module="GeneralEquipment"			Usage="M"
	InformationEntityEnd
	InformationEntity="Image"
		Module="GeneralImage"				Usage="M"
		Module="GeneralReference"			Usage="U"	Condition="NeedModuleGeneralReference"
		Module="ImagePixel"					Usage="M"
		Module="AcquisitionContext"			Usage="M"	# not check for baseline CIDs yet
		Module="Device"						Usage="U"	Condition="NeedModuleDevice"
		Module="Specimen"					Usage="M"
		Module="VLImage"					Usage="M"
		Module="SlideCoordinates"			Usage="M"
		Module="OpticalPath"				Usage="U"	Condition="NeedModuleOpticalPath"
		Module="OverlayPlane"				Usage="U"	Condition="NeedModuleOverlayPlane"
		Module="ICCProfile"					Usage="U"	Condition="NeedModuleICCProfile"
		Module="CheckSingleFramePseudo"		Usage="M"
		Module="SOPCommon"					Usage="M"
		Module="CommonInstanceReference"	Usage="U"	Condition="NeedModuleCommonInstanceReference"
	InformationEntityEnd
CompositeIODEnd

CompositeIOD="VLPhotographicImage"		Condition="VisibleLightPhotographicImageInstance"
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
		Module="VLPhotographicSeriesPseudo"	Usage="M"	# not in standard ... use to check conditions
		Module="ClinicalTrialSeries"		Usage="U"	Condition="NeedModuleClinicalTrialSeries"
	InformationEntityEnd
	InformationEntity="Equipment"
		Module="GeneralEquipment"			Usage="M"
	InformationEntityEnd
	InformationEntity="Image"
		Module="GeneralImage"				Usage="M"
		Module="GeneralReference"			Usage="U"	Condition="NeedModuleGeneralReference"
		Module="ImagePixel"					Usage="M"
		Module="AcquisitionContext"			Usage="M"	# not check for baseline CIDs yet
		Module="Device"						Usage="U"	Condition="NeedModuleDevice"
		Module="Specimen"					Usage="C"	Condition="NeedModuleSpecimen"	# real-world "is a specimen"
		Module="VLImage"					Usage="M"
		Module="OverlayPlane"				Usage="U"	Condition="NeedModuleOverlayPlane"
		Module="ICCProfile"					Usage="U"	Condition="NeedModuleICCProfile"
		Module="CheckSingleFramePseudo"		Usage="M"
		Module="SOPCommon"					Usage="M"
		Module="CommonInstanceReference"	Usage="U"	Condition="NeedModuleCommonInstanceReference"
	InformationEntityEnd
CompositeIODEnd

CompositeIOD="VideoEndoscopicImage"			Condition="VideoEndoscopicImageInstance"
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
		Module="VLEndoscopicSeriesPseudo"	Usage="M"	# not in standard ... use to check conditions
		Module="ClinicalTrialSeries"		Usage="U"	Condition="NeedModuleClinicalTrialSeries"
	InformationEntityEnd
	InformationEntity="Equipment"
		Module="GeneralEquipment"			Usage="M"
	InformationEntityEnd
	InformationEntity="Image"
		Module="GeneralImage"				Usage="M"
		Module="GeneralReference"			Usage="U"	Condition="NeedModuleGeneralReference"
		Module="Cine"						Usage="M"
		Module="MultiFrame"					Usage="M"
		Module="ImagePixel"					Usage="M"
		Module="AcquisitionContext"			Usage="M"	# no check for baseline CIDs yet
		Module="Device"						Usage="U"	Condition="NeedModuleDevice"
		Module="Specimen"					Usage="C"	Condition="NeedModuleSpecimen"	# real-world "is a specimen"
		Module="VLImage"					Usage="M"
		Module="ICCProfile"					Usage="U"	Condition="NeedModuleICCProfile"
		Module="SOPCommon"					Usage="M"
		Module="CommonInstanceReference"	Usage="U"	Condition="NeedModuleCommonInstanceReference"
		Module="FrameExtraction"			Usage="C"	Condition="NeedModuleFrameExtraction"
	InformationEntityEnd
CompositeIODEnd

CompositeIOD="VideoMicroscopicImage"		Condition="VideoMicroscopicImageInstance"
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
		Module="VLMicroscopicSeriesPseudo"	Usage="M"	# not in standard ... use to check conditions
		Module="ClinicalTrialSeries"		Usage="U"	Condition="NeedModuleClinicalTrialSeries"
	InformationEntityEnd
	InformationEntity="Equipment"
		Module="GeneralEquipment"			Usage="M"
	InformationEntityEnd
	InformationEntity="Image"
		Module="GeneralImage"				Usage="M"
		Module="GeneralReference"			Usage="U"	Condition="NeedModuleGeneralReference"
		Module="Cine"						Usage="M"
		Module="MultiFrame"					Usage="M"
		Module="ImagePixel"					Usage="M"
		Module="AcquisitionContext"			Usage="M"	# not check for baseline CIDs yet
		Module="Device"						Usage="U"	Condition="NeedModuleDevice"
		Module="Specimen"					Usage="C"	Condition="NeedModuleSpecimen"	# real-world "is a specimen"
		Module="VLImage"					Usage="M"
		Module="ICCProfile"					Usage="U"	Condition="NeedModuleICCProfile"
		Module="SOPCommon"					Usage="M"
		Module="CommonInstanceReference"	Usage="U"	Condition="NeedModuleCommonInstanceReference"
		Module="FrameExtraction"			Usage="C"	Condition="NeedModuleFrameExtraction"
	InformationEntityEnd
CompositeIODEnd

CompositeIOD="VideoPhotographicImage"		Condition="VideoPhotographicImageInstance"
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
		Module="VLPhotographicSeriesPseudo"	Usage="M"	# not in standard ... use to check conditions
		Module="ClinicalTrialSeries"		Usage="U"	Condition="NeedModuleClinicalTrialSeries"
	InformationEntityEnd
	InformationEntity="Equipment"
		Module="GeneralEquipment"			Usage="M"
	InformationEntityEnd
	InformationEntity="Image"
		Module="GeneralImage"				Usage="M"
		Module="GeneralReference"			Usage="U"	Condition="NeedModuleGeneralReference"
		Module="Cine"						Usage="M"
		Module="MultiFrame"					Usage="M"
		Module="ImagePixel"					Usage="M"
		Module="AcquisitionContext"			Usage="M"	# not check for baseline CIDs yet
		Module="Device"						Usage="U"	Condition="NeedModuleDevice"
		Module="Specimen"					Usage="C"	Condition="NeedModuleSpecimen"	# real-world "is a specimen"
		Module="VLImage"					Usage="M"
		Module="ICCProfile"					Usage="U"	Condition="NeedModuleICCProfile"
		Module="SOPCommon"					Usage="M"
		Module="CommonInstanceReference"	Usage="U"	Condition="NeedModuleCommonInstanceReference"
		Module="FrameExtraction"			Usage="C"	Condition="NeedModuleFrameExtraction"
	InformationEntityEnd
CompositeIODEnd

CompositeIOD="OphthalmicPhotography8BitImage"		Condition="OphthalmicPhotography8BitImageInstance"
	InformationEntity="File"
		Module="FileMetaInformation"						Usage="C"	Condition="NeedModuleFileMetaInformation"
	InformationEntityEnd
	InformationEntity="Patient"
		Module="Patient"									Usage="M"
		Module="ClinicalTrialSubject"						Usage="U"	Condition="NeedModuleClinicalTrialSubject"
	InformationEntityEnd	
	InformationEntity="Study"
		Module="GeneralStudy"								Usage="M"
		Module="PatientStudy"								Usage="U"	# no condition ... all attributes type 3
		Module="ClinicalTrialStudy"							Usage="U"	Condition="NeedModuleClinicalTrialStudy"
	InformationEntityEnd
	InformationEntity="Series"
		Module="GeneralSeries"								Usage="M"
		Module="OphthalmicPhotographySeries"				Usage="M"
		Module="ClinicalTrialSeries"						Usage="U"	Condition="NeedModuleClinicalTrialSeries"
	InformationEntityEnd
	InformationEntity="FrameOfReference"
		Module="Synchronization"							Usage="M"
	InformationEntityEnd
	InformationEntity="Equipment"
		Module="GeneralEquipment"							Usage="M"
	InformationEntityEnd
	InformationEntity="Image"
		Module="GeneralImage"								Usage="M"
		Module="GeneralReference"							Usage="U"	Condition="NeedModuleGeneralReference"
		Module="ImagePixel"									Usage="M"
		Module="EnhancedContrastBolus"						Usage="C"	Condition="NeedModuleEnhancedContrastBolus"
		Module="Cine"										Usage="C"	Condition="NeedModuleCine"
		Module="MultiFrame"									Usage="M"
		Module="AcquisitionContext"							Usage="U"	Condition="NeedModuleAcquisitionContext"
		Module="OphthalmicPhotographyImage"					Usage="M"
		Module="OphthalmicPhotography8BitImagePseudo"		Usage="M"	# not in standard ... use to check bit depths
		Module="OcularRegionImaged"							Usage="M"
		Module="OphthalmicPhotographyAcquisitionParameters"	Usage="M"
		Module="OphthalmicPhotographicParameters"			Usage="M"
		Module="ICCProfile"									Usage="U"	Condition="NeedModuleICCProfile"
		Module="SOPCommon"									Usage="M"
		Module="CommonInstanceReference"					Usage="U"	Condition="NeedModuleCommonInstanceReference"
		Module="FrameExtraction"							Usage="C"	Condition="NeedModuleFrameExtraction"
	InformationEntityEnd
CompositeIODEnd

CompositeIOD="OphthalmicPhotography16BitImage"		Condition="OphthalmicPhotography16BitImageInstance"
	InformationEntity="File"
		Module="FileMetaInformation"						Usage="C"	Condition="NeedModuleFileMetaInformation"
	InformationEntityEnd
	InformationEntity="Patient"
		Module="Patient"									Usage="M"
		Module="ClinicalTrialSubject"						Usage="U"	Condition="NeedModuleClinicalTrialSubject"
	InformationEntityEnd	
	InformationEntity="Study"
		Module="GeneralStudy"								Usage="M"
		Module="PatientStudy"								Usage="U"	# no condition ... all attributes type 3
		Module="ClinicalTrialStudy"							Usage="U"	Condition="NeedModuleClinicalTrialStudy"
	InformationEntityEnd
	InformationEntity="Series"
		Module="GeneralSeries"								Usage="M"
		Module="OphthalmicPhotographySeries"					Usage="M"
		Module="ClinicalTrialSeries"						Usage="U"	Condition="NeedModuleClinicalTrialSeries"
	InformationEntityEnd
	InformationEntity="FrameOfReference"
		Module="Synchronization"							Usage="M"
	InformationEntityEnd
	InformationEntity="Equipment"
		Module="GeneralEquipment"							Usage="M"
	InformationEntityEnd
	InformationEntity="Image"
		Module="GeneralImage"								Usage="M"
		Module="GeneralReference"							Usage="U"	Condition="NeedModuleGeneralReference"
		Module="ImagePixel"									Usage="M"
		Module="EnhancedContrastBolus"						Usage="C"	Condition="NeedModuleEnhancedContrastBolus"
		Module="Cine"										Usage="C"	Condition="NeedModuleCine"
		Module="MultiFrame"									Usage="M"
		Module="AcquisitionContext"							Usage="U"	Condition="NeedModuleAcquisitionContext"
		Module="OphthalmicPhotographyImage"					Usage="M"
		Module="OphthalmicPhotography16BitImagePseudo"		Usage="M"	# not in standard ... use to check bit depths
		Module="OcularRegionImaged"							Usage="M"
		Module="OphthalmicPhotographyAcquisitionParameters"	Usage="M"
		Module="OphthalmicPhotographicParameters"			Usage="M"
		Module="ICCProfile"									Usage="U"	Condition="NeedModuleICCProfile"
		Module="SOPCommon"									Usage="M"
		Module="CommonInstanceReference"					Usage="U"	Condition="NeedModuleCommonInstanceReference"
		Module="FrameExtraction"							Usage="C"	Condition="NeedModuleFrameExtraction"
	InformationEntityEnd
CompositeIODEnd


CompositeIOD="StereometricRelationship"			Condition="StereometricRelationshipInstance"
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
		Module="StereometricSeries"			Usage="M"
		Module="ClinicalTrialSeries"		Usage="U"	Condition="NeedModuleClinicalTrialSeries"
	InformationEntityEnd
	InformationEntity="Equipment"
		Module="GeneralEquipment"			Usage="M"
	InformationEntityEnd
	InformationEntity="Image"
		Module="StereometricRelationship"	Usage="M"
		Module="CommonInstanceReference"	Usage="M"
		Module="SOPCommon"					Usage="M"
	InformationEntityEnd
CompositeIODEnd

CompositeIOD="OphthalmicTomographyImage"		Condition="OphthalmicTomographyImageInstance"
	InformationEntity="File"
		Module="FileMetaInformation"						Usage="C"	Condition="NeedModuleFileMetaInformation"
	InformationEntityEnd
	InformationEntity="Patient"
		Module="Patient"									Usage="M"
		Module="ClinicalTrialSubject"						Usage="U"	Condition="NeedModuleClinicalTrialSubject"
	InformationEntityEnd	
	InformationEntity="Study"
		Module="GeneralStudy"								Usage="M"
		Module="PatientStudy"								Usage="U"	# no condition ... all attributes type 3
		Module="ClinicalTrialStudy"							Usage="U"	Condition="NeedModuleClinicalTrialStudy"
	InformationEntityEnd
	InformationEntity="Series"
		Module="GeneralSeries"								Usage="M"
		Module="ClinicalTrialSeries"						Usage="U"	Condition="NeedModuleClinicalTrialSeries"
		Module="OphthalmicTomographySeries"					Usage="M"
	InformationEntityEnd
	InformationEntity="FrameOfReference"
		Module="FrameOfReference"							Usage="C"	Condition="NeedModuleFrameOfReference"			# condition is real-world (Ophthalmic Photography Reference Image available) ... just check if present
		Module="Synchronization"							Usage="C"	Condition="NeedToCheckModuleSynchronization"	# condition is real-world (Ophthalmic Photography Reference Image available) ... just check if present
	InformationEntityEnd
	InformationEntity="Equipment"
		Module="GeneralEquipment"							Usage="M"
		Module="EnhancedGeneralEquipment"					Usage="M"
	InformationEntityEnd
	InformationEntity="Image"
		Module="ImagePixel"									Usage="M"
		Module="EnhancedContrastBolus"						Usage="C"	Condition="NeedModuleEnhancedContrastBolus"
		Module="MultiFrameFunctionalGroupsCommon"			Usage="M"
		Module="MultiFrameFunctionalGroupsForOphthalmicTomography"	Usage="M"
		Module="MultiFrameDimension"						Usage="M"
		Module="AcquisitionContext"							Usage="M"
		Module="CardiacSynchronization"						Usage="C"	Condition="NeedModuleCardiacSynchronization"
		Module="OphthalmicTomographyImage"					Usage="M"
		Module="OphthalmicTomographyAcquisitionParameters"	Usage="M"
		Module="OphthalmicTomographyParameters"				Usage="M"
		Module="OcularRegionImaged"							Usage="M"
		Module="SOPCommon"									Usage="M"
		Module="CommonInstanceReference"					Usage="U"	Condition="NeedModuleCommonInstanceReference"
		Module="FrameExtraction"							Usage="C"	Condition="NeedModuleFrameExtraction"
	InformationEntityEnd
CompositeIODEnd

CompositeIOD="VLWholeSlideMicroscopyImage"		Condition="VLWholeSlideMicroscopyImageInstance"
	InformationEntity="File"
		Module="FileMetaInformation"						Usage="C"	Condition="NeedModuleFileMetaInformation"
	InformationEntityEnd
	InformationEntity="Patient"
		Module="Patient"									Usage="M"
		Module="ClinicalTrialSubject"						Usage="U"	Condition="NeedModuleClinicalTrialSubject"
	InformationEntityEnd	
	InformationEntity="Study"
		Module="GeneralStudy"								Usage="M"
		Module="PatientStudy"								Usage="U"	# no condition ... all attributes type 3
		Module="ClinicalTrialStudy"							Usage="U"	Condition="NeedModuleClinicalTrialStudy"
	InformationEntityEnd
	InformationEntity="Series"
		Module="GeneralSeries"								Usage="M"
		Module="ClinicalTrialSeries"						Usage="U"	Condition="NeedModuleClinicalTrialSeries"
		Module="WholeSlideMicroscopySeries"					Usage="M"
	InformationEntityEnd
	InformationEntity="FrameOfReference"
		Module="FrameOfReference"							Usage="C"	Condition="NeedModuleFrameOfReference"
	InformationEntityEnd
	InformationEntity="Equipment"
		Module="GeneralEquipment"							Usage="M"
		Module="EnhancedGeneralEquipment"					Usage="M"
	InformationEntityEnd
	InformationEntity="Image"
		Module="GeneralImage"								Usage="M"
		Module="GeneralReference"							Usage="U"	Condition="NeedModuleGeneralReference"
		Module="ImagePixel"									Usage="M"
		Module="AcquisitionContext"							Usage="M"
		Module="MultiFrameFunctionalGroupsCommon"			Usage="M"
		Module="MultiFrameFunctionalGroupsForWholeSlideMicroscopy"	Usage="M"
		Module="MultiFrameDimension"						Usage="M"
		Module="Specimen"									Usage="M"
		Module="WholeSlideMicroscopyImage"					Usage="M"
		Module="OpticalPath"								Usage="M"
		Module="MultiResolutionNavigation"					Usage="C"	Condition="ImageTypeValue3Localizer"
		Module="SlideLabel"									Usage="C"	Condition="ImageTypeValue3Label"
		Module="SOPCommon"									Usage="M"
		Module="CommonInstanceReference"					Usage="M"
		Module="FrameExtraction"							Usage="C"	Condition="NeedModuleFrameExtraction"
	InformationEntityEnd
CompositeIODEnd

CompositeIOD="LensometryMeasurements" Condition="LensometryMeasurementsInstance"
	InformationEntity="Patient"
		Module="Patient"	Usage="M"
		Module="ClinicalTrialSubject"	Usage="U"
	InformationEntityEnd
	InformationEntity="Study"
		Module="GeneralStudy"	Usage="M"
		Module="PatientStudy"	Usage="U"
		Module="ClinicalTrialStudy"	Usage="U"
	InformationEntityEnd
	InformationEntity="Series"
		Module="GeneralSeries"	Usage="M"
		Module="LensometryMeasurementsSeries"	Usage="M"
		Module="ClinicalTrialSeries"	Usage="U"
	InformationEntityEnd
	InformationEntity="Equipment"
		Module="GeneralEquipment"	Usage="M"
		Module="EnhancedGeneralEquipment"	Usage="M"
	InformationEntityEnd
	InformationEntity="Measurements"
		Module="GeneralOphthalmicRefractiveMeasurements"	Usage="M"
		Module="LensometryMeasurements"	Usage="M"
		Module="SOPCommon"	Usage="M"
	InformationEntityEnd
CompositeIODEnd

CompositeIOD="AutorefractionMeasurements" Condition="AutorefractionMeasurementsInstance"
	InformationEntity="Patient"
		Module="Patient"	Usage="M"
		Module="ClinicalTrialSubject"	Usage="U"
	InformationEntityEnd
	InformationEntity="Study"
		Module="GeneralStudy"	Usage="M"
		Module="PatientStudy"	Usage="U"
		Module="ClinicalTrialStudy"	Usage="U"
	InformationEntityEnd
	InformationEntity="Series"
		Module="GeneralSeries"	Usage="M"
		Module="AutorefractionMeasurementsSeries"	Usage="M"
		Module="ClinicalTrialSeries"	Usage="U"
	InformationEntityEnd
	InformationEntity="Equipment"
		Module="GeneralEquipment"	Usage="M"
		Module="EnhancedGeneralEquipment"	Usage="M"
	InformationEntityEnd
	InformationEntity="Measurements"
		Module="GeneralOphthalmicRefractiveMeasurements"	Usage="M"
		Module="AutorefractionMeasurements"	Usage="M"
		Module="SOPCommon"	Usage="M"
	InformationEntityEnd
CompositeIODEnd

CompositeIOD="KeratometryMeasurements" Condition="KeratometryMeasurementsInstance"
	InformationEntity="Patient"
		Module="Patient"	Usage="M"
		Module="ClinicalTrialSubject"	Usage="U"
	InformationEntityEnd
	InformationEntity="Study"
		Module="GeneralStudy"	Usage="M"
		Module="PatientStudy"	Usage="U"
		Module="ClinicalTrialStudy"	Usage="U"
	InformationEntityEnd
	InformationEntity="Series"
		Module="GeneralSeries"	Usage="M"
		Module="KeratometryMeasurementsSeries"	Usage="M"
		Module="ClinicalTrialSeries"	Usage="U"
	InformationEntityEnd
	InformationEntity="Equipment"
		Module="GeneralEquipment"	Usage="M"
		Module="EnhancedGeneralEquipment"	Usage="M"
	InformationEntityEnd
	InformationEntity="Measurements"
		Module="GeneralOphthalmicRefractiveMeasurements"	Usage="M"
		Module="KeratometryMeasurements"	Usage="M"
		Module="SOPCommon"	Usage="M"
	InformationEntityEnd
CompositeIODEnd

CompositeIOD="SubjectiveRefractionMeasurements" Condition="SubjectiveRefractionMeasurementsInstance"
	InformationEntity="Patient"
		Module="Patient"	Usage="M"
		Module="ClinicalTrialSubject"	Usage="U"
	InformationEntityEnd
	InformationEntity="Study"
		Module="GeneralStudy"	Usage="M"
		Module="PatientStudy"	Usage="U"
		Module="ClinicalTrialStudy"	Usage="U"
	InformationEntityEnd
	InformationEntity="Series"
		Module="GeneralSeries"	Usage="M"
		Module="SubjectiveRefractionMeasurementsSeries"	Usage="M"
		Module="ClinicalTrialSeries"	Usage="U"
	InformationEntityEnd
	InformationEntity="Equipment"
		Module="GeneralEquipment"	Usage="M"
		Module="EnhancedGeneralEquipment"	Usage="M"
	InformationEntityEnd
	InformationEntity="Measurements"
		Module="GeneralOphthalmicRefractiveMeasurements"	Usage="M"
		Module="SubjectiveRefractionMeasurements"	Usage="M"
		Module="SOPCommon"	Usage="M"
	InformationEntityEnd
CompositeIODEnd

CompositeIOD="VisualAcuityMeasurements" Condition="VisualAcuityMeasurementsInstance"
	InformationEntity="Patient"
		Module="Patient"	Usage="M"
		Module="ClinicalTrialSubject"	Usage="U"
	InformationEntityEnd
	InformationEntity="Study"
		Module="GeneralStudy"	Usage="M"
		Module="PatientStudy"	Usage="U"
		Module="ClinicalTrialStudy"	Usage="U"
	InformationEntityEnd
	InformationEntity="Series"
		Module="GeneralSeries"	Usage="M"
		Module="VisualAcuityMeasurementsSeries"	Usage="M"
		Module="ClinicalTrialSeries"	Usage="U"
	InformationEntityEnd
	InformationEntity="Equipment"
		Module="GeneralEquipment"	Usage="M"
		Module="EnhancedGeneralEquipment"	Usage="M"
	InformationEntityEnd
	InformationEntity="Measurements"
		Module="GeneralOphthalmicRefractiveMeasurements"	Usage="M"
		Module="VisualAcuityMeasurements"	Usage="M"
		Module="SOPCommon"	Usage="M"
	InformationEntityEnd
CompositeIODEnd

CompositeIOD="OphthalmicAxialMeasurements" Condition="OphthalmicAxialMeasurementsInstance"
	InformationEntity="Patient"
		Module="Patient"	Usage="M"
		Module="ClinicalTrialSubject"	Usage="U"
	InformationEntityEnd
	InformationEntity="Study"
		Module="GeneralStudy"	Usage="M"
		Module="PatientStudy"	Usage="U"
		Module="ClinicalTrialStudy"	Usage="U"
	InformationEntityEnd
	InformationEntity="Series"
		Module="GeneralSeries"	Usage="M"
		Module="OphthalmicAxialMeasurementsSeries"	Usage="M"
		Module="ClinicalTrialSeries"	Usage="U"
	InformationEntityEnd
	InformationEntity="Equipment"
		Module="GeneralEquipment"	Usage="M"
		Module="EnhancedGeneralEquipment"	Usage="M"
	InformationEntityEnd
	InformationEntity="Measurements"
		Module="OphthalmicAxialMeasurements"	Usage="M"
		Module="GeneralOphthalmicRefractiveMeasurements"	Usage="M"
		Module="SOPCommon"	Usage="M"
	InformationEntityEnd
CompositeIODEnd

CompositeIOD="IntraocularLensCalculations" Condition="IntraocularLensCalculationsInstance"
	InformationEntity="Patient"
		Module="Patient"	Usage="M"
		Module="ClinicalTrialSubject"	Usage="U"
	InformationEntityEnd
	InformationEntity="Study"
		Module="GeneralStudy"	Usage="M"
		Module="PatientStudy"	Usage="U"
		Module="ClinicalTrialStudy"	Usage="U"
	InformationEntityEnd
	InformationEntity="Series"
		Module="GeneralSeries"	Usage="M"
		Module="IntraocularLensCalculationsSeries"	Usage="M"
		Module="ClinicalTrialSeries"	Usage="U"
	InformationEntityEnd
	InformationEntity="Equipment"
		Module="GeneralEquipment"	Usage="M"
		Module="EnhancedGeneralEquipment"	Usage="M"
	InformationEntityEnd
	InformationEntity="Measurements"
		Module="IntraocularLensCalculations"	Usage="M"
		Module="GeneralOphthalmicRefractiveMeasurements"	Usage="M"
		Module="SOPCommon"	Usage="M"
	InformationEntityEnd
CompositeIODEnd


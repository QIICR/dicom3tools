/* ie.h Copyright (c) 1993-2024, David A. Clunie DBA PixelMed Publishing. All rights reserved. */
#ifndef __Header_ie__
#define __Header_ie__

enum InformationEntity {
	UnknownIE,
	DirectoryIE,
	DocumentIE,
	EncapsulatedDocumentIE,
	EquipmentIE,
	FileIE,
	FrameOfReferenceIE,
	HangingProtocolIE,
	ImageIE,
	MeasurementsIE,
	MRSpectroscopyIE,
	PatientIE,
	PlanIE,
	PresentationIE,
	RawDataIE,
	RealWorldValueMappingIE,
	SeriesIE,
	SpatialFiducialsIE,
	SpatialRegistrationIE,
	StructureSetIE,
	StudyIE,
	TreatmentRecordIE,
	WaveformIE,
	OverlayIE,
	CurveIE,
	ModalityLUTIE,
	VOILUTIE,
	ColorPaletteIE,
	SurfaceIE,
	TractographyResultsIE,
	AnnotationIE,
	AcquisitionIE,
	MultiResolutionPyramidIE
};

InformationEntity getInformationEntityFromDescription(const char *d);
const char *describeInformationEntity(InformationEntity ie);
int getDepthOfInformationEntity(InformationEntity ie);

#endif // __Header_ie__

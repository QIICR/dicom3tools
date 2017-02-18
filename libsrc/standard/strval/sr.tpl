StringValues="SRModality" {
	SR
}

StringValues="KOModality" {
	KO
}

StringValues="PreliminaryFlag" {
	PRELIMINARY,
	FINAL
}

StringValues="CompletionFlag" {
	PARTIAL,
	COMPLETE
}

StringValues="VerificationFlag" {
	UNVERIFIED,
	VERIFIED
}

StringValues="ContinuityOfContent" {
	SEPARATE,
	CONTINUOUS
}

StringValues="SRRelationshipType" {
	CONTAINS,
	HAS PROPERTIES,
	HAS CONCEPT MOD,
	HAS OBS CONTEXT,
	HAS ACQ CONTEXT,
	INFERRED FROM,
	SELECTED FROM
}

StringValues="SRRelationshipTypeHasConceptModifier" {
	HAS CONCEPT MOD
}

StringValues="SRValueTypes" {
	TEXT,
	NUM,
	CODE,
	DATETIME,
	DATE,
	TIME,
	UIDREF,
	PNAME,
	IMAGE,
	WAVEFORM,
	COMPOSITE,
	SCOORD,
	SCOORD3D,
	TCOORD,
	CONTAINER
}

StringValues="EnhancedAndComprehensiveSRValueTypes" {
	TEXT,
	NUM,
	CODE,
	DATETIME,
	DATE,
	TIME,
	UIDREF,
	PNAME,
	IMAGE,
	WAVEFORM,
	COMPOSITE,
	SCOORD,
	TCOORD,
	CONTAINER
}

StringValues="BasicTextSRValueTypes" {
	TEXT,
	CODE,
	DATETIME,
	DATE,
	TIME,
	UIDREF,
	PNAME,
	COMPOSITE,
	IMAGE,
	WAVEFORM,
	CONTAINER
}

StringValues="KeyObjectSelectionDocumentValueTypes" {
	TEXT,
	CODE,
	UIDREF,
	PNAME,
	IMAGE,
	WAVEFORM,
	COMPOSITE,
	CONTAINER
}

StringValues="MammographyCADSRValueTypes" {
	TEXT,
	CODE,
	NUM,
	DATE,
	TIME,
	PNAME,
	SCOORD,
	COMPOSITE,
	IMAGE,
	CONTAINER
}

StringValues="ChestCADSRValueTypes" {
	TEXT,
	CODE,
	NUM,
	DATE,
	TIME,
	PNAME,
	SCOORD,
	TCOORD,
	COMPOSITE,
	IMAGE,
	CONTAINER,
	UIDREF,
	WAVEFORM
}

StringValues="ProcedureLogValueTypes" {
	CODE,
	CONTAINER,
	COMPOSITE,
	DATETIME,
	DATE,
	IMAGE,
	NUM,
	PNAME,
	TEXT,
	TIME,
	UIDREF,
	WAVEFORM
}

StringValues="XRayRadiationDoseSRValueTypes" {
	TEXT,
	CODE,
	NUM,
	DATETIME,
	UIDREF,
	PNAME,
	COMPOSITE,
	IMAGE,
	CONTAINER
}

StringValues="SRGraphicType" {
	POINT,
	MULTIPOINT,
	POLYLINE,
	CIRCLE,
	ELLIPSE
}

StringValues="SRGraphicType3D" {
	POINT,
	MULTIPOINT,
	POLYLINE,
	POLYGON,
	ELLIPSE,
	ELLIPSOID
}

StringValues="TemporalRangeType" {
	POINT,
	MULTIPOINT,
	SEGMENT,
	MULTISEGMENT,
	BEGIN,
	END
}

StringValues="ParticipationType" {
	SOURCE,
	ENT,
	ATTEST 
}

StringValues="ObserverType" {
	PSN,
	DEV 
}

StringValues="SRTemplateMappingResource" {
	DCMR,
	99RPH,
	99SMS_CTMR = Siemens CT MR,
	99PMP = PixelMed,
	99QIICR = NCI QIICR Project 3DSlicer BWH
}

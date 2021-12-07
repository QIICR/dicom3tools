StringValues="TomoType"	{
	LINEAR,
	SPIRAL,
	POLYCYCLOIDAL,
	CIRCULAR
}

StringValues="TomoClass"	{
	MOTION,
	TOMOSYNTHESIS
}

StringValues="OrganExposed"	{
	BREAST,
	GONADS,
	BONE MARROW,
	FETUS,
	LENS
}

StringValues="MammographyOrganExposed"	{
	BREAST
}

StringValues="AnodeTargetMaterial"	{
	TUNGSTEN,
	MOLYBDENUM,
	RHODIUM
}

StringValues="DXFilterMaterial"	{
	MOLYBDENUM,
	ALUMINUM,
	COPPER,
	RHODIUM,
	NIOBIUM,
	EUROPIUM,
	LEAD
}

StringValues="DXFilterType"	{
	STRIP,
	WEDGE,
	BUTTERFLY,
	MULTIPLE,
	NONE
}

StringValues="RectificationType"	{
	SINGLE PHASE,
	THREE PHASE,
	CONST POTENTIAL
}

StringValues="ExposureControlMode"	{
	MANUAL,
	AUTOMATIC
}

StringValues="ExposureStatus"	{
	NORMAL,
	ABORTED
}

StringValues="XRayGrid"	{
	FIXED,
	FOCUSED,
	RECIPROCATING,
	PARALLEL,
	CROSSED,
	NONE
}

StringValues="DXModality"	{
	DX = Digital Radiography,
	IO = Intra-oral Radiography,
	MG = Mammography,
	PX = Panoramic X-Ray
}

StringValues="MammographyModality"	{
	MG = Mammography
}

StringValues="IntraoralModality"	{
	IO = Intra-oral Radiography,
}

StringValues="PresentationIntentType"	{
	FOR PROCESSING,
	FOR PRESENTATION
}

StringValues="ForProcessing"	{
	FOR PROCESSING
}

StringValues="ForPresentation"	{
	FOR PRESENTATION
}

StringValues="ImageLaterality"	{
	R = Right,
	L = Left,
	U = Unpaired,
	B = Both left and right
}

StringValues="MammographyImageLaterality"	{
	R = Right,
	L = Left,
	B = Both left and right
}

StringValues="IntraoralImageLaterality"	{
	R = Right,
	L = Left,
	B = Both left and right
}

StringValues="DXImageType3"	{
	***EMPTYVALUE***
}

# C.8.11.7.1.4
StringValues="MammoImageType3"	{
	***EMPTYVALUE***,
	STEREO_SCOUT,
	STEREO_MINUS,
	STEREO_PLUS,
	PREFIRE_MINUS,
	PREFIRE_PLUS,
	POSTFIRE_MINUS,
	POSTFIRE_PLUS,
	POSTBIOPSY_MINUS,
	POSTBIOPSY_PLUS,
	POSTBIOPSY,
	POSTMARKER_MINUS,
	POSTMARKER_PLUS,
	POSTMARKER,
	TOMO_PROJ,
	TOMOSYNTHESIS,
	TOMO_SCOUT,
	PREFIRE,
	POSTFIRE,
	PRE_CONTRAST,
	POST_CONTRAST
}

# C.8.11.7.1.4
StringValues="MammoImageType4"	{
	***EMPTYVALUE***,
	GENERATED_2D,
	ADDITION,
	SUBTRACTION
}

# C.8.21.6.1.1
StringValues="BreastTomoImageAndFrameType4"	{
	***EMPTYVALUE***,
	NONE,
	GENERATED_2D,
	MAXIMUM,
	MEAN,
	ADDITION,
	SUBTRACTION
}

# C.8.11.7.1.4
StringValues="MammoImageType5"	{
	***EMPTYVALUE***,
	LOW_ENERGY,
	HIGH_ENERGY
}

# C.8.21.6.1.1
StringValues="BreastTomoImageAndFrameType5"	{
	***EMPTYVALUE***,
	LOW_ENERGY,
	HIGH_ENERGY
}

# C.8.21.6.1.1
StringValues="CommonEnhancedImageAndFrameType3AndBreastTomoImageAndFrameType3"	{
	ANGIO,
	CARDIAC,
	CARDIAC_GATED,
	CARDRESP_GATED,
	DYNAMIC,
	FLUOROSCOPY,
	LOCALIZER,
	MOTION,
	PERFUSION,
	PRE_CONTRAST,
	POST_CONTRAST,
	RESP_GATED,
	REST,
	STATIC,
	STRESS,
	VOLUME,
	NON_PARALLEL,
	PARALLEL,
	WHOLE_BODY,
	TOMO_PROJ,
	TOMOSYNTHESIS,
	TOMO_SCOUT,
	PREFIRE,
	POSTFIRE,
	POSTBIOPSY,
	POSTMARKER
}

StringValues="DXPixelIntensityRelationship" {
	LIN = Approximately proportional to X-Ray beam intensity,
	LOG = Non-linear Log Function
}

StringValues="DXPresentationLUTShape"	{
	IDENTITY,
	INVERSE
}

StringValues="DetectorType"	{
	DIRECT,
	SCINTILLATOR,
	STORAGE,
	FILM
}

StringValues="DetectorTypeExcludingFilm"	{
	DIRECT,
	SCINTILLATOR,
	STORAGE
}

StringValues="DetectorConfiguration"	{
	AREA,
	SLOT
}

StringValues="DXShape" {
	RECTANGLE,
	ROUND,
	HEXAGONAL
}

StringValues="DXFieldOfViewRotation" {
	0,
	90,
	180,
	270
}

StringValues="DXPositionerType" {
	CARM,
	COLUMN,
	MAMMOGRAPHIC,
	PANORAMIC,
	CEPHALOSTAT,
	RIGID,
	NONE
}

StringValues="MammographyPositionerType" {
	MAMMOGRAPHIC,
	NONE
}

StringValues="MammographyPositionerTypeWithoutNone" {
	MAMMOGRAPHIC
}

StringValues="IntraoralPositionerType" {
	CEPHALOSTAT,
	RIGID,
	NONE
}

StringValues="DXTableType" {
	FIXED,
	TILTING,
	NONE
}

StringValues="CodeValueForScreeningOrDiagnostic" {
	R-42453 = Screening,
	R-408C3 = Diagnostic
}

StringValues="PolygonalShutterShape" {
	POLYGONAL
}

StringValues="BreastTomosynthesisFieldOfViewShape" {
	RECTANGLE
}

StringValues="BreastTomosynthesisXRayReceptorType" {
	DIGITAL_DETECTOR
}

StringValues="PositionerPrimaryAngleDirection" {
	CW = Clockwise,
	CC = CounterClockwise
}

StringValues="MammographyPositionerAndDetectorMotion" {
	STATIONARY = No motion,
	ROTATION_STEP = Circular arc motion, stepped, acquire only while stationary,
	ROTATION_CONT = Circular arc motion, continuous during acquisition,
	TRANSLATION_STEP = Linear motion, stepped, acquire only while stationary,
	TRANSLATION_CONT = Linear motion, continuous during acquisition,
	COMPLEX_STEP = Complex motion, stepped, acquire only while stationary,
	COMPLEX_CONT = Complex motion, continuous during acquisition
}

StringValues="EntranceDoseDerivation"	{
	IAK,
	ESAK,
	ESDBS,
	ESDNOBS
}


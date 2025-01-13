static const char *CopyrightIdentifier(void) { return "@(#)dcdisp.cc Copyright (c) 1993-2024, David A. Clunie DBA PixelMed Publishing. All rights reserved."; }
//#define PROFILETIME
//#define DYNAMICWINDOW
//#define DONTSENDEXPOSEEVENT

#ifdef PROFILETIME
#include <sys/types.h>
#include <sys/time.h>
static long g_starttime;
static long g_lasttime;
static long g_newtime;
static struct timeval g_rtime;
#define STARTTHETIME		((void)gettimeofday(&g_rtime,0),g_lasttime=g_starttime=g_rtime.tv_sec*1000+g_rtime.tv_usec/1000)
#define ECHOTHETIME(s)		((void)gettimeofday(&g_rtime,0), \
				  g_newtime=g_rtime.tv_sec*1000+g_rtime.tv_usec/1000, \
				  cerr << "***TIME***: " << s << ": " << dec << g_newtime-g_starttime \
				       << "(" << g_newtime-g_lasttime << ") mS"<< endl, \
				  g_lasttime=g_newtime)
#else
#define STARTTHETIME
#define ECHOTHETIME(s)
#endif

#include "attrmxls.h"
#include "attrval.h"
#include "mesgtext.h"
#include "dcopt.h"
#include "elmconst.h"

#include "errclass.h"

#include "attrothr.h"

#include "ourdisp.h"

#include "lutclass.h"
#include "lutextr.h"

#include "usepal.h"
#include "usegray.h"
#include "useindex.h"
#include "usetrue.h"

#include "rdimage.h"
#include "rdgray.h"
#include "rdindex.h"
#include "rdrgb.h"
#include "rdhsv.h"
#include "rdargb.h"
#include "rdcmyk.h"

#include "pixposn.h"

class OverlayBuffer {
private:
	bool		present[16];
	bool		activated[16];

	Uint16		vOverlayRows[16];
	Uint16		vOverlayColumns[16];
	const char *	vOverlayType[16];
	Uint16		vOverlayBitsAllocated[16]; 
	Uint16		vOverlayBitPosition[16];
	Uint16		vOverlayLocation[16];			// old ACR-NEMA, defaults to 0x7FEO if no pixel data
	Int16		vOverlayOriginRow[16];
	Int16 		vOverlayOriginColumn[16];

	Attribute *	aOverlayData[16];

	Uint32		vOverlayDataLength[16];
	const Uint16 *	vOverlayDataValues[16];

	void dump(TextOutputStream& log,const char *msg);

public:
	OverlayBuffer(ManagedAttributeList& list,TextOutputStream& log,bool noattributes);

	bool getOverlayValues(Uint16 which,const Uint16 * &data, Uint32 &length, Uint16 &bitsallocated, Uint16 &bitposition) const
		{
			Assert(which<16);
			if (activated[which]) {
				bitsallocated=vOverlayBitsAllocated[which];
				bitposition=vOverlayBitPosition[which];
				Assert(aOverlayData[which]);
				return aOverlayData[which]->getValue(data,length);
			}
			else {
				return false;
			}
		}

	void putOverlay(OurWindowImage &wimage,unsigned which);
	void putOverlay(OurWindowImage &wimage);
};

OverlayBuffer::OverlayBuffer(ManagedAttributeList& list,TextOutputStream& log,bool noattributes)
{
	unsigned u;
	for (u=0; u<=0x1E; u+=2) {

		activated[u/2] = false;

		Attribute *aOverlayRows = list[Tag(OverlayRows_GROUP+u,OverlayRows_ELEMENT)];
		Attribute *aOverlayColumns = list[Tag(OverlayColumns_GROUP+u,OverlayColumns_ELEMENT)];
		Attribute *aOverlayType = list[Tag(OverlayType_GROUP+u,OverlayType_ELEMENT)];
		Attribute *aOverlayBitsAllocated = list[Tag(OverlayBitsAllocated_GROUP+u,OverlayBitsAllocated_ELEMENT)];
		Attribute *aOverlayBitPosition = list[Tag(OverlayBitPosition_GROUP+u,OverlayBitPosition_ELEMENT)];
		Attribute *aOverlayLocation = list[Tag(OverlayLocation_GROUP+u,OverlayLocation_ELEMENT)];
		Attribute *aOverlayOrigin = list[Tag(OverlayOrigin_GROUP+u,OverlayOrigin_ELEMENT)];
		aOverlayData[u/2] = list[Tag(OverlayData_GROUP+u,OverlayData_ELEMENT)];

		present[u/2] = (aOverlayRows || aOverlayColumns || aOverlayType
			       || aOverlayBitsAllocated || aOverlayBitPosition
			       || aOverlayLocation || aOverlayOrigin || aOverlayData[u/2]);

		vOverlayRows[u/2] = Uint16(AttributeValue(list[TagFromName(Rows)]));	// default
		if (!aOverlayRows) {
			if (present[u/2]) {
				log << WMsgDC(MissingAttribute)
				    << " - \"OverlayRows\" for group " << hex << u << dec
				    << " - using \"Rows\" = " << vOverlayRows[u/2]
				    << endl;
			}
		}
		else
			vOverlayRows[u/2]=AttributeValue(aOverlayRows);

		vOverlayColumns[u/2] = Uint16(AttributeValue(list[TagFromName(Columns)]));	// default
		if (!aOverlayColumns) {
			if (present[u/2]) {
				log << WMsgDC(MissingAttribute)
				    << " - \"OverlayColumns\" for group " << hex << u << dec
				    << " - using \"Columns\" = " << vOverlayColumns[u/2]
				    << endl;
			}
		}
		else
			vOverlayColumns[u/2]=AttributeValue(aOverlayColumns);

		vOverlayType[u/2] = "G";
		if (!aOverlayType) {
			if (present[u/2]) {
				log << WMsgDC(MissingAttribute)
				    << " - \"OverlayType\" for group " << hex << u << dec
				    << " - using \"G\""
				    << endl;
			}
		}
		else {
			const char *v=AttributeValue(aOverlayType);
			if (v && strcmp(v,"G") == 0)
				vOverlayType[u/2]="G";
			else if (v && strcmp(v,"R") == 0)
				vOverlayType[u/2]="R";
			else
				log << EMsgDC(BadAttributeValue)
				    << " - \"OverlayType\" for group " << hex << u << dec
				    << " = <" << (v ? v : "") << ">"
				    << " - using \"G\""
				    << endl;
		}

		vOverlayBitsAllocated[u/2] = Uint16(AttributeValue(list[TagFromName(BitsAllocated)]));	// default
		if (!aOverlayBitsAllocated) {
			if (present[u/2]) {
				log << WMsgDC(MissingAttribute)
				    << " - \"OverlayBitsAllocated\" for group " << hex << u << dec
				    << " - using \"BitsAllocated\" = " << vOverlayBitsAllocated[u/2]
				    << endl;
			}
		}
		else
			vOverlayBitsAllocated[u/2]=AttributeValue(aOverlayBitsAllocated);

		vOverlayBitPosition[u/2] = 0;	// default
		if (!aOverlayBitPosition) {
			if (present[u/2]) {
				log << WMsgDC(MissingAttribute)
				    << " - \"OverlayBitPosition\" for group " << hex << u << dec
				    << " - using 0"
				    << endl;
			}
		}
		else
			vOverlayBitPosition[u/2]=AttributeValue(aOverlayBitPosition);

		vOverlayOriginRow[u/2] = 1;	// default
		vOverlayOriginColumn[u/2] = 1;	// default
		if (!aOverlayOrigin) {
			if (present[u/2]) {
				log << WMsgDC(MissingAttribute)
				    << " - \"OverlayOrigin\" for group " << hex << u << dec
				    << " - using 1\\1"
				    << endl;
			}
		}
		else if (aOverlayOrigin->getVM() != 2)
			log << EMsgDC(BadAttributeValueMultiplicity)
			    << " - \"OverlayOrigin\" for group " << hex << u << dec
			    << " != 2 "
			    << " - using 1\\1"
			    << endl;
		else {
			bool success;
			success=aOverlayOrigin->getValue(0,vOverlayOriginRow[u/2]);
			Assert(success);
			success=aOverlayOrigin->getValue(1,vOverlayOriginColumn[u/2]);
			Assert(success);
		}

		vOverlayLocation[u/2] = 0;	// missing flag (not required in DICOM 3.0)
		if (aOverlayLocation)
			vOverlayLocation[u/2]=AttributeValue(aOverlayLocation);

		if (present[u/2] && aOverlayData[u/2]) {
			Assert(aOverlayData[u/2]->getValue(vOverlayDataValues[u/2],vOverlayDataLength[u/2]));
			Assert(vOverlayDataLength[u/2]);
			Assert(vOverlayDataValues[u/2]);
		}

		if (present[u/2] && !vOverlayLocation[u/2] && !aOverlayData[u/2])
			vOverlayLocation[u/2]=0x7FE0;

		// Only Overlay Data supported for now :(

		if (present[u/2] && aOverlayData[u/2]) {
			activated[u/2]=true;

			Assert(vOverlayOriginRow[u/2] == 1);
			Assert(vOverlayOriginColumn[u/2] == 1);
			Assert(vOverlayRows[u/2]== Uint16(AttributeValue(list[TagFromName(Rows)])));
			Assert(vOverlayColumns[u/2] == Uint16(AttributeValue(list[TagFromName(Columns)])));
			long expectedLength = vOverlayRows[u/2]*vOverlayColumns[u/2]*vOverlayBitsAllocated[u/2]/16;
//cerr << "OverlayBuffer::OverlayBuffer(): expectedLength = " << expectedLength << endl;
			if (expectedLength%2 != 0) ++expectedLength;	// pad odd length to even length
//cerr << "OverlayBuffer::OverlayBuffer(): expectedLength after padding = " << expectedLength << endl;
//cerr << "OverlayBuffer::OverlayBuffer(): vOverlayDataLength[u/2] = " << vOverlayDataLength[u/2] << endl;
//cerr << "OverlayBuffer::OverlayBuffer(): vOverlayRows[u/2] = " << vOverlayRows[u/2] << endl;
//cerr << "OverlayBuffer::OverlayBuffer(): vOverlayColumns[u/2] = " << vOverlayColumns[u/2] << endl;
//cerr << "OverlayBuffer::OverlayBuffer(): vOverlayBitsAllocated[u/2] = " << vOverlayBitsAllocated[u/2] << endl;
			Assert(vOverlayDataLength[u/2] == expectedLength);
		}

	}

	if (!noattributes) dump(log,"Using");
}

void
OverlayBuffer::dump(TextOutputStream& log,const char *msg)
{
	Assert(msg);
	unsigned u;
	for (u=0; u<=0x1E; u+=2) {
		if (present[u/2]) {
			log << msg << " Overlay Group " << hex << u << dec << " ..." << endl;
			log << "\tpresent = " << (present[u/2] ? "yes" : "no") << endl;
			log << "\tactivated = " << (activated[u/2] ? "yes" : "no") << endl;
			log << "\tRows = " << dec << vOverlayRows[u/2] << endl;
			log << "\tColumns = " << dec << vOverlayColumns[u/2] << endl;
			log << "\tType = " << dec << vOverlayType[u/2] << endl;
			log << "\tBitsAllocated = " << dec << vOverlayBitsAllocated[u/2] << endl;
			log << "\tBitPosition = " << dec << vOverlayBitPosition[u/2] << endl;
			log << "\tOrigin (Row) = " << dec << vOverlayOriginRow[u/2] << endl;
			log << "\tOrigin (Column) = " << dec << vOverlayOriginColumn[u/2] << endl;
			log << "\tLocation = " << hex << vOverlayLocation[u/2] << dec << endl;
			log << "\tData " << (aOverlayData[u/2] ? "is" : "is not") << " present" << endl;
			if (aOverlayData[u/2])
				log << "\tData Length = " << dec << vOverlayDataLength[u/2] << endl;
			if (aOverlayData[u/2] && vOverlayDataValues[u/2] && vOverlayDataLength[u/2])
				log << "\tData Value[0] = " << hex << vOverlayDataValues[u/2][0] << dec << endl;
		}
	}
}

void
OverlayBuffer::putOverlay(OurWindowImage &wimage,unsigned which)
{
cerr << "OverlayBuffer::putOverlay(" << which << "):" << endl;
	Assert(which < 16);
	if (activated[which]) {
cerr << "OverlayBuffer::putOverlay(" << which << "): activated" << endl;
		Assert(vOverlayBitsAllocated[which] <= 16);
		Assert(16%vOverlayBitsAllocated[which] == 0);
		Assert(vOverlayBitPosition[which] < vOverlayBitsAllocated[which]);

		unsigned bitincrement = vOverlayBitsAllocated[which];
		unsigned bitmask = 1 << vOverlayBitPosition[which];
		unsigned bitgroupsperword = 16 / bitincrement;

		const Uint16 *ptr = vOverlayDataValues[which];
		const Uint16 *last = ptr + vOverlayDataLength[which];

		unsigned rows = vOverlayRows[which];
		unsigned cols = vOverlayColumns[which];
		unsigned row = 0;
		unsigned col = 0;

		while (ptr < last) {
			Uint16 word=*ptr++;
			Assert (row < rows);
			// optimize here for word == 0 later
			unsigned bit = 0;
			while (bit < 16) {
				bit+=bitincrement;
				if (word & bitmask) wimage.putPoint(col,row);
				word=word>>bitincrement;
				if (++col >= cols) {
					col=0;
					++row;
				}
			}
		}
	}
}

void
OverlayBuffer::putOverlay(OurWindowImage &wimage)
{
	unsigned which;
	for (which=0; which<16; ++which) {
		if (activated[which]) putOverlay(wimage,which);
	}
}



int
main(int argc, char *argv[])
{
STARTTHETIME;
ECHOTHETIME("start");

	bool bad=false;

	GetNamedOptions 	options(argc,argv);
	DicomInputOptions 	dicom_input_options(options);

	bool verbose=options.get("verbose") || options.get("v");
	bool nodisplayloop=options.get("nodisplayloop");
	bool noattributes=options.get("noattributes");
	bool showwithhelp=options.get("showwithhelp");
	bool justhelp=options.get("help") || options.get("h");
	bool invertedgrayscaleoption=options.get("invertedgray");
	bool forcesigned=options.get("signed");
	bool forceunsigned=options.get("unsigned");
	bool ignorewindowinobject=options.get("ignorewindow");
	bool writeimage=options.get("writeimage");
	bool showoverlays=options.get("showoverlays");
	bool ignorepadvalue=options.get("ignorepadvalue");;

	unsigned windowwidthvalue=0;
	bool windowwidthset=options.get("windowwidth",windowwidthvalue);
	unsigned windowlevelvalue=0;
	bool windowlevelset=options.get("windowlevel",windowlevelvalue);

	dicom_input_options.done();
	options.done();

	DicomInputOpenerFromOptions input_opener(
		options,dicom_input_options.filename,cin);

	cerr << dicom_input_options.errors();
	cerr << options.errors();
	cerr << input_opener.errors();

	if (forcesigned && forceunsigned) {
		cerr << EMsgDC(NotBothSignedOrUnsigned) << endl;
		bad=true;
	};

	if ( (windowwidthset && !windowlevelset)
	 || (!windowwidthset &&  windowlevelset)) {
		cerr << EMsgDC(NeedBothWindowLevelWidth) << endl;
		bad=true;
	};

	if (!dicom_input_options.good()
	 || !options.good()
	 || !input_opener.good()
	 || !options
	 || bad) {
		cerr 	<< MMsgDC(Usage) << ": " << options.command()
			<< dicom_input_options.usage()
			<< " [-v|-verbose]"
			<< " [-h|-help]"
			<< " [-showwithhelp]"
			<< " [-nodisplayloop]"
			<< " [-noattributes]"
			<< " [-windowwidth width]"
			<< " [-windowlevel level]"
			<< " [-ignorewindow]"
			<< " [-invertedgray]"
			<< " [-[signed|unsigned]]"
			<< " [-ignorepadvalue]"
			<< " [-showoverlays]"
			<< " [-writeimage]"
			<< " [" << MMsgDC(InputFile)
			<< " <" << MMsgDC(InputFile)
			<< endl;
		return 1;
	}

	if (showwithhelp || justhelp) {
		cerr << "Window level/width:" << endl;
		cerr << endl;
		cerr << "\t- for > 8 bit deep grayscale images only" << endl;
		cerr << "\t- controlled by cursor movement while the left mouse button is down" << endl;
		cerr << "\t- left or right decreases or increases width" << endl;
		cerr << "\t- down or up decreases or increases level" << endl;
		cerr << endl;
		cerr << "\t- if shift key held, effect is multiplied 10 fold" << endl;
		cerr << "\t- if control key held, effect is multiplied 100 fold" << endl;
		cerr << "\t- if both shift & control keys held, effect is multiplied 1000 fold" << endl;
		cerr << endl;
		cerr << "\t- arrow keys (with or without shift and control) do the same" << endl;
		cerr << endl;
		cerr << "Cursor feedback:" << endl;
		cerr << endl;
		cerr << "\t- crosshair cursor when quiescent" << endl;
		cerr << "\t- ramp  cursor while setting new values" << endl;
		cerr << "\t- watch cursor while recomputing ... BE PATIENT" << endl;
		cerr << endl;
		cerr << "Key commands:" << endl;
		cerr << endl;
		cerr << "\t- o or O toggles overlays on or off." << endl;
		cerr << endl;
		cerr << "\t- v or V restores the VOI LUT or toggles to the next VOI LUT." << endl;
		cerr << endl;
		cerr << "\t- q or Q or x or X or return quits." << endl;
		cerr << endl;
		cerr << "Annotation:" << endl;
		cerr << endl;
		cerr << "\t- top left   - Patient ID" << endl;
		cerr << "\t- top center - Study ID/Series Number/Image Number" << endl;
		cerr << "\t- top right  - Patient Name" << endl;
		cerr << endl;
	}

	if (justhelp) return 0;

ECHOTHETIME("reading");

	DicomInputStream din(*(istream *)input_opener,
		dicom_input_options.transfersyntaxuid,
		dicom_input_options.usemetaheader);

	ManagedAttributeList list;

	TextOutputStream  log(cerr);
	if (verbose) log << "******** While reading ... ********" << endl; 
	list.read(din,false/*newformat*/,&log,verbose,0xffffffff,true,dicom_input_options.uselengthtoend,dicom_input_options.ignoreoutofordertags,dicom_input_options.useUSVRForLUTDataIfNotExplicit);

	const char *errors=list.errors();
	if (errors) log << errors << flush;
	if (!list.good()) {
		log << EMsgDC(DatasetReadFailed) << endl;
		//return 1;	// Press on regardless ...
	}

	Uint16 vRows = 0;
	Attribute *aRows = list[TagFromName(Rows)];
	if (!aRows)
		log << WMsgDC(MissingAttribute)
		    << " - \"Rows\""
		    << endl;
	else
		vRows=AttributeValue(aRows);

	Uint16 vColumns = 0;
	Attribute *aColumns = list[TagFromName(Columns)];
	if (!aColumns)
		log << WMsgDC(MissingAttribute)
		    << " - \"Columns\""
		    << endl;
	else
		vColumns=AttributeValue(aColumns);

	Uint16 vNumberOfFrames = 0;
	Attribute *aNumberOfFrames = list[TagFromName(NumberOfFrames)];
	if (aNumberOfFrames)	// optional
		vNumberOfFrames=AttributeValue(aNumberOfFrames);

	char *vPhotometricInterpretation = 0;
	Attribute *aPhotometricInterpretation = list[TagFromName(PhotometricInterpretation)];
	if (!aPhotometricInterpretation)
		log << WMsgDC(MissingAttribute)
		    << " - \"PhotometricInterpretation\""
		    << endl;
	else
		vPhotometricInterpretation=AttributeValue(aPhotometricInterpretation);

	Uint16 vSamplesPerPixel = 0;
	Attribute *aSamplesPerPixel = list[TagFromName(SamplesPerPixel)];
	if (!aSamplesPerPixel)
		log << WMsgDC(MissingAttribute)
		    << " - \"SamplesPerPixel\""
		    << endl;
	else
		vSamplesPerPixel=AttributeValue(aSamplesPerPixel);

	Uint16 vBitsAllocated = 0;
	Attribute *aBitsAllocated = list[TagFromName(BitsAllocated)];
	if (!aBitsAllocated)
		log << WMsgDC(MissingAttribute)
		    << " - \"BitsAllocated\""
		    << endl;
	else
		vBitsAllocated=AttributeValue(aBitsAllocated);

	Uint16 vBitsStored = 0;
	Attribute *aBitsStored = list[TagFromName(BitsStored)];
	if (!aBitsStored)
		log << WMsgDC(MissingAttribute)
		    << " - \"BitsStored\""
		    << endl;
	else
		vBitsStored=AttributeValue(aBitsStored);

	Uint16 vHighBit = 0;
	Attribute *aHighBit = list[TagFromName(HighBit)];
	if (!aHighBit)
		log << WMsgDC(MissingAttribute)
		    << " - \"HighBit\""
		    << endl;
	else
		vHighBit=AttributeValue(aHighBit);

	Uint16 vPixelRepresentation = 0xffff;
	Attribute *aPixelRepresentation = list[TagFromName(PixelRepresentation)];
	if (!aPixelRepresentation)
		log << WMsgDC(MissingAttribute)
		    << " - \"PixelRepresentation\""
		    << endl;
	else
		vPixelRepresentation=AttributeValue(aPixelRepresentation);

	Uint16 vPlanarConfiguration = 0xffff;
	Attribute *aPlanarConfiguration = list[TagFromName(PlanarConfiguration)];
	if (vSamplesPerPixel > 1 && !aPlanarConfiguration)
		log << WMsgDC(MissingAttribute)
		    << " - \"PlanarConfiguration\""
		    << endl;
	else
		vPlanarConfiguration=AttributeValue(aPlanarConfiguration);

	Float32 vRescaleIntercept = 0;
	Attribute *aRescaleIntercept = list[TagFromName(RescaleIntercept)];
	if (aRescaleIntercept)	// optional
		vRescaleIntercept=AttributeValue(aRescaleIntercept);

	Float32 vRescaleSlope = 0;
	Attribute *aRescaleSlope = list[TagFromName(RescaleSlope)];
	if (aRescaleSlope)	// optional
		vRescaleSlope=AttributeValue(aRescaleSlope);

	Uint16 vWindowCenter = 0;
	Attribute *aWindowCenter = list[TagFromName(WindowCenter)];
	if (aWindowCenter)	// optional
		vWindowCenter=AttributeValue(aWindowCenter);

	Uint16 vWindowWidth = 0;
	Attribute *aWindowWidth = list[TagFromName(WindowWidth)];
	if (aWindowWidth)	// optional
		vWindowWidth=AttributeValue(aWindowWidth);

	Uint16 vPixelPaddingValue;
	Attribute *aPixelPaddingValue = list[TagFromName(PixelPaddingValue)];
	if (aPixelPaddingValue)	{	// optional
		vPixelPaddingValue=AttributeValue(aPixelPaddingValue);
	}
	bool usepadvalue=aPixelPaddingValue && !ignorepadvalue;

	Attribute *aPixelData = list[TagFromName(PixelData)];

	if (!aPixelData) {
		if (!noattributes)
			log << "\tPixeldata not in normal place ... checking for ImageLocation attribute" << endl;
		Uint16 groupstart;
		Uint16 groupend;
		Attribute *aImageLocation=list[TagFromName(ImageLocation)];
		if (aImageLocation) {
			Uint16 vImageLocation=AttributeValue(aImageLocation);
			if (!noattributes)
				log << "\tImageLocation = " << hex << vImageLocation << dec << endl;
			groupstart=vImageLocation;
			groupend=vImageLocation;
		}
		else {
			groupstart=0x7fe0;
			groupend=0x7ffd;
		}
		if (!noattributes)
			log << "\tNow searching for Pixeldata" << endl;
		Uint16 group;
		for (group=groupstart; !aPixelData && group <= groupend; ++group) {
			Uint32 owner;
			for (owner=((group&0x0001) ? 0x0100 : 0x0000);
					!aPixelData && owner <= ((group&0x0001) ? 0xff00 : 0x0000); owner+=0x0100) {
				if ((aPixelData=list[Tag(group,Uint16(owner|0x0010))]) && aPixelData->isOtherData()) {
					if (!noattributes)
						log << "\tFound Pixeldata in ";
						aPixelData->getTag().write(log);
						log << endl;
					break;
				}
				aPixelData=0;
			}
		}
	}

	if (!aPixelData) {
		log << EMsgDC(MissingAttribute)
		    << " - \"PixelData\""
		    << endl;
		log << EMsgDC(NothingToDisplay) << endl;
		return 1;
	}

	Uint32 length=aPixelData->getVL();

	Attribute *aVOILUTSequence = list[TagFromName(VOILUTSequence)];
	int nVOILUT=0;
	Uint16 *VOILUT_first = 0;
	Uint16 *VOILUT_number = 0;
	Uint16 *VOILUT_depth = 0;
	Uint16 const **VOILUT_table = 0;
	if (aVOILUTSequence) {
cerr << "Have VOILUTSequence" << endl;
		AttributeList **items;
		nVOILUT=aVOILUTSequence->getLists(&items);
		if (nVOILUT) {
			VOILUT_first = new Uint16[nVOILUT];
			Assert(VOILUT_first);
			VOILUT_number = new Uint16[nVOILUT];
			Assert(VOILUT_number);
			VOILUT_depth = new Uint16[nVOILUT];
			Assert(VOILUT_depth);
			VOILUT_table = new const Uint16 *[nVOILUT];
			Assert(VOILUT_table);
			int i;
			for (i=0; i<nVOILUT; ++i) {
				Assert(items[i]);
				Attribute *aLUTDescriptor=items[i]->operator[](TagFromName(LUTDescriptor));
				Assert(aLUTDescriptor);
				Assert(aLUTDescriptor->getVM() == 3);
				Assert(aLUTDescriptor->getValue(0,VOILUT_number[i]));
				Assert(aLUTDescriptor->getValue(1,VOILUT_first[i]));
				Assert(aLUTDescriptor->getValue(2,VOILUT_depth[i]));
cerr << "VOILUTSequence" << endl
     << "\t first[" << dec << i << "]=" << VOILUT_first[i] << endl
     << "\t number[" << dec << i << "]=" << VOILUT_number[i] << endl
     << "\t depth[" << dec << i << "]=" << VOILUT_depth[i] << endl;

				Attribute *aLUTData=items[i]->operator[](TagFromName(LUTData));
				Assert(aLUTData);
				if (aLUTData->isOtherWordNonPixel()) {
					Uint32 nLUTData;
					const Uint16 *vLUTData = NULL;
					Assert(aLUTData->getValue(vLUTData,nLUTData));
					VOILUT_table[i] = vLUTData;
				}
				else if (aLUTData->isNumericBinary()) {		// e.g. US VR
					Uint16 *vLUTData = new Uint16[VOILUT_number[i]];
					Assert(VOILUT_table[i]);
					int j;
					for (j=0; j<VOILUT_number[i]; ++j) {
						Assert(aLUTData->getValue(j,vLUTData[j]));
					}
					VOILUT_table[i] = vLUTData;
				}
				else {
					Assert(0);
				}
			}
		}
	}

	if (!noattributes) {
		log << "Read ..." << endl;
		log << "\tRows = " << dec << vRows << endl;
		log << "\tColumns = " << dec << vColumns << endl;
		log << "\tNumberOfFrames = " << dec << vNumberOfFrames << endl;
		log << "\tPhotometricInterpretation = "
		    << (vPhotometricInterpretation ? vPhotometricInterpretation : "")
		    << endl;
		log << "\tSamplesPerPixel = " << dec << vSamplesPerPixel << endl;
		log << "\tBitsAllocated = " << dec << vBitsAllocated << endl;
		log << "\tBitsStored = " << dec << vBitsStored << endl;
		log << "\tHighBit = " << dec << vHighBit << endl;
		log << "\tPixelRepresentation = " << dec << vPixelRepresentation << endl;
		log << "\tPlanarConfiguration = " << hex << vPlanarConfiguration << dec << endl;
		log << "\tRescaleIntercept = " << dec << vRescaleIntercept << endl;
		log << "\tRescaleSlope = " << dec << vRescaleSlope << endl;
		log << "\tWindowCenter = "; if (aWindowCenter) log << vWindowCenter; log << endl;
		log << "\tWindowWidth = "; if (aWindowWidth) log << vWindowWidth; log << endl;
		log << "\tPixelPaddingValue = "; if (aPixelPaddingValue) log << vPixelPaddingValue; log << endl;
		log << "\tVOILUTs = "; if (nVOILUT) log << nVOILUT; log << endl;
		log << "\tPixelData Value Length = " << hex << length << dec << endl;
	}


	// Try to guess some missing attributes ...

	if (vRescaleSlope*vRescaleSlope < 0.00001) vRescaleSlope=1;

	if (vPixelRepresentation == 0xffff) vPixelRepresentation=0;
	if (forceunsigned) vPixelRepresentation=0;
	if (forcesigned) vPixelRepresentation=1;

	if (!vNumberOfFrames) vNumberOfFrames=1;

	if (!vSamplesPerPixel && !vPhotometricInterpretation) {
		vSamplesPerPixel=1;
		vPhotometricInterpretation=StrDup("MONOCHROME2");
	}
	else if (!vSamplesPerPixel && vPhotometricInterpretation) {
		if (strcmp(vPhotometricInterpretation,"MONOCHROME1") == 0
		 || strcmp(vPhotometricInterpretation,"MONOCHROME2") == 0
		 || strcmp(vPhotometricInterpretation,"PALETTE COLOR") == 0
		) {
			vSamplesPerPixel=1;
		}
		else if (
		    strcmp(vPhotometricInterpretation,"RGB") == 0
		 || strcmp(vPhotometricInterpretation,"HSV") == 0
		) {
			vSamplesPerPixel=3;
		}
		else if (
		    strcmp(vPhotometricInterpretation,"ARGB") == 0
		 || strcmp(vPhotometricInterpretation,"CMYK") == 0
		) {
			vSamplesPerPixel=4;
		}
	}
	else if (!vPhotometricInterpretation && vSamplesPerPixel) {
		switch (vSamplesPerPixel) {
			case 1:	// could check for presence of palette
				vPhotometricInterpretation=StrDup("MONOCHROME2");
				break;
			case 3:	vPhotometricInterpretation=StrDup("RGB");
				break;
			case 4:	vPhotometricInterpretation=StrDup("ARGB");
				break;
		}
	}

	if (!vBitsAllocated && length && length != 0xffffffff
	 && (vRows && vColumns && vNumberOfFrames && vSamplesPerPixel)) {
		vBitsAllocated=Uint16(length/((Uint32)vRows*vColumns*vNumberOfFrames*vSamplesPerPixel)*8);
	}

	if (!vBitsAllocated && vBitsStored)
		vBitsAllocated=((vBitsStored-1u)/8u+1u)*8u;

	if (!vBitsAllocated) {
		if (strcmp(aPixelData->getVR(),"OW") == 0)
			vBitsAllocated=16;
		else
			vBitsAllocated=8;
	}

	Assert(vBitsAllocated <= 16);

	if (!vBitsStored) vBitsStored=vBitsAllocated;
	if (!vHighBit) vHighBit=vBitsStored-1;

	Uint32 framelengthinwords=length/vNumberOfFrames*8/vBitsAllocated;

	if (!vRows) {
		if (!vColumns) {
			if (!vSamplesPerPixel) {
				vRows=Uint16(sqrt(framelengthinwords));
				vColumns=Uint16(length/vRows);
				vSamplesPerPixel=1;
			}
			else {
				Uint32 left=framelengthinwords/vSamplesPerPixel;
				vRows=Uint16(sqrt(left));
				vColumns=Uint16(left/vRows);
			}
		}
		else {
			if (!vSamplesPerPixel) {
				Uint32 left=framelengthinwords/vColumns;
				vRows=Uint16(sqrt(length));
				vSamplesPerPixel=1;
			}
			else {
				vRows=Uint16(framelengthinwords/(vColumns*vSamplesPerPixel));
			}
		}
	}
	else {
		if (!vColumns) {
			if (!vSamplesPerPixel) {
				vColumns=Uint16(framelengthinwords/vRows);
				vSamplesPerPixel=1;
			}
			else {
				vColumns=Uint16(framelengthinwords/(vRows*vSamplesPerPixel));
			}
		}
		else {
			if (!vSamplesPerPixel) {
				vSamplesPerPixel=Uint16(framelengthinwords/(vRows*vColumns));
			}
			// else we know all three
		}
	}

	// use object values if present and not zero, unless overridden by command line ...

	if (!windowwidthset && !windowlevelset && !ignorewindowinobject && aWindowCenter && vWindowCenter && aWindowWidth && vWindowWidth) {
		windowwidthset=true;
		windowwidthvalue=vWindowWidth;
		windowlevelset=true;
		windowlevelvalue=vWindowCenter;
	}

	if (!noattributes) {
		log << "Using ..." << endl;
		log << "\tRows = " << dec << vRows << endl;
		log << "\tColumns = " << dec << vColumns << endl;
		log << "\tNumberOfFrames = " << dec << vNumberOfFrames << endl;
		log << "\tPhotometricInterpretation = "
		    << (vPhotometricInterpretation ? vPhotometricInterpretation : "")
		    << endl;
		log << "\tSamplesPerPixel = " << dec << vSamplesPerPixel << endl;
		log << "\tBitsAllocated = " << dec << vBitsAllocated << endl;
		log << "\tBitsStored = " << dec << vBitsStored << endl;
		log << "\tHighBit = " << dec << vHighBit << endl;
		log << "\tPixelRepresentation = " << dec << vPixelRepresentation << endl;
		log << "\tPlanarConfiguration = " << hex << vPlanarConfiguration << dec << endl;
		log << "\tRescaleIntercept = " << dec << vRescaleIntercept << endl;
		log << "\tRescaleSlope = " << dec << vRescaleSlope << endl;
		log << "\tWindowCenter = "; if (windowlevelset) log << windowlevelvalue; log << endl;
		log << "\tWindowWidth = "; if (windowwidthset) log << windowwidthvalue; log << endl;
		log << "\tPixelPaddingValue = "; if (usepadvalue) log << vPixelPaddingValue; log << endl;
		log << "\tVOILUTs = "; if (nVOILUT) log << nVOILUT; log << endl;
		log << "\tRows*Columns*SamplesPerPixel*BitsAllocated/8 = "
		    << hex << (Uint32)vRows*vColumns*vSamplesPerPixel*vBitsAllocated/8
		    << dec << endl;
	}

	Assert((Uint32)vRows*vColumns*vSamplesPerPixel <= framelengthinwords);

	if (!vRows || !vColumns
	 || !vPhotometricInterpretation || !vSamplesPerPixel
	 || !vBitsAllocated
	 || (vSamplesPerPixel > 1 && vPlanarConfiguration == 0xffff)) {
		log << EMsgDC(MissingMandatoryAttributes) << endl;
		return 1;
	}

ECHOTHETIME("attributes done ... setting up overlays");

	OverlayBuffer overlays(list,log,noattributes);

ECHOTHETIME("attributes done ... setting up pixel data");

	ReadableImage *image = 0;
	SupplySourceFromAttribute sPixelData(aPixelData);

	// The standard doesn't say it, but what could a
	// signed PixelRepresentation mean for other than grayscale ?

	bool pixelrepresentationok = (vPixelRepresentation == 0);
	bool windowlevelwidthok = !windowlevelset && !windowwidthset;

	if (vSamplesPerPixel == 1) {
		bool monochrome=false;
		bool invertedgrayscale=false;
		bool palettecolor=false;
		if (strcmp(vPhotometricInterpretation,"MONOCHROME1") == 0) {
			monochrome=true;
			invertedgrayscale=true;
		}
		else if (strcmp(vPhotometricInterpretation,"MONOCHROME2") == 0) {
			monochrome=true;
			invertedgrayscale=false;
		}
		else if (strcmp(vPhotometricInterpretation,"PALETTE COLOR") == 0) {
			palettecolor=true;
		}
		else {
			log << EMsgDC(Unsupported) << " - PhotometricInterpretation = \""
			    << (vPhotometricInterpretation ? vPhotometricInterpretation : "")
			    << "\"" << endl;
			return 1;
		}

		if (invertedgrayscaleoption) invertedgrayscale=!invertedgrayscale;

		DicomLUT *RedLUT;
		DicomLUT *GreenLUT;
		DicomLUT *BlueLUT;

		if (palettecolor && !extractLookUpTables(log,list,RedLUT,GreenLUT,BlueLUT))
			return 1;

		if (vBitsAllocated <= 8) {
			if (monochrome) {
				pixelrepresentationok=true;	// Not required to be unsigned
				image=new ReadableWindowed8BitGrayImage(&sPixelData,vColumns,vRows,vNumberOfFrames,
						vBitsAllocated,vBitsStored,vHighBit,
						vPixelRepresentation,invertedgrayscale);
			}
			else if (palettecolor)
				image=new Readable8BitIndexedColorImage(
						&sPixelData,vColumns,vRows,vNumberOfFrames,
						vBitsAllocated,vBitsStored,vHighBit,
						RedLUT,GreenLUT,BlueLUT);
		}
		else if (vBitsAllocated <= 16) {
			if (monochrome) {
				pixelrepresentationok=true;	// Not required to be unsigned
				windowlevelwidthok=true;	// allowed to specify width & level on command line
				image=new ReadableWindowed16BitGrayImage(&sPixelData,vColumns,vRows,vNumberOfFrames,
						vBitsAllocated,vBitsStored,vHighBit,
						vPixelRepresentation,invertedgrayscale,
						usepadvalue,vPixelPaddingValue);
			}
			else if (palettecolor)
				image=new Readable16BitIndexedColorImage(
						&sPixelData,vColumns,vRows,vNumberOfFrames,
						vBitsAllocated,vBitsStored,vHighBit,
						RedLUT,GreenLUT,BlueLUT);
		}
		else {
			log << EMsgDC(Unsupported) << " - BitsStored = " << vBitsStored << endl;
			return 1;
		}
	}
	else if (vSamplesPerPixel == 3) {
		if (strcmp(vPhotometricInterpretation,"RGB") == 0) {
			if (vPlanarConfiguration == 0)
				image=new ReadableInterleaved24BitRGBImage(&sPixelData,vColumns,vRows,vNumberOfFrames,
						vBitsAllocated,vBitsStored,vHighBit);
			else if (vPlanarConfiguration == 1)
				image=new ReadableNonInterleaved24BitRGBImage(&sPixelData,vColumns,vRows,vNumberOfFrames,
						vBitsAllocated,vBitsStored,vHighBit);
			else {
				log << EMsgDC(Unsupported) << " - PlanarConfiguration = " << vPlanarConfiguration << endl;
				return 1;
			}
		}
		else if (strcmp(vPhotometricInterpretation,"HSV") == 0) {
			if (vPlanarConfiguration == 0)
				image=new ReadableInterleaved24BitHSVImage(&sPixelData,vColumns,vRows,vNumberOfFrames,
						vBitsAllocated,vBitsStored,vHighBit);
			else if (vPlanarConfiguration == 1)
				image=new ReadableNonInterleaved24BitHSVImage(&sPixelData,vColumns,vRows,vNumberOfFrames,
						vBitsAllocated,vBitsStored,vHighBit);
			else {
				log << EMsgDC(Unsupported) << " - PlanarConfiguration = " << vPlanarConfiguration << endl;
				return 1;
			}
		}
		else {
			log << EMsgDC(Unsupported) << " - PhotometricInterpretation = \""
			    << (vPhotometricInterpretation ? vPhotometricInterpretation : "")
			    << "\"" << endl;
			return 1;
		}
	}
	else if (vSamplesPerPixel == 4) {
		if (strcmp(vPhotometricInterpretation,"ARGB") == 0) {
			DicomLUT *RedLUT;
			DicomLUT *GreenLUT;
			DicomLUT *BlueLUT;

			if (!extractLookUpTables(log,list,RedLUT,GreenLUT,BlueLUT))
				return 1;

			if (vPlanarConfiguration == 0)
				image=new ReadableInterleaved32BitARGBImage(
						&sPixelData,vColumns,vRows,vNumberOfFrames,
						vBitsAllocated,vBitsStored,vHighBit,
						RedLUT,GreenLUT,BlueLUT);
			else if (vPlanarConfiguration == 1)
				image=new ReadableNonInterleaved32BitARGBImage(
						&sPixelData,vColumns,vRows,vNumberOfFrames,
						vBitsAllocated,vBitsStored,vHighBit,
						RedLUT,GreenLUT,BlueLUT);
			else {
				log << EMsgDC(Unsupported) << " - PlanarConfiguration = " << vPlanarConfiguration << endl;
				return 1;
			}
		}
		else if (strcmp(vPhotometricInterpretation,"CMYK") == 0) {
			if (vPlanarConfiguration == 0)
				image=new ReadableInterleaved32BitCMYKImage(&sPixelData,vColumns,vRows,vNumberOfFrames,
						vBitsAllocated,vBitsStored,vHighBit);
			else if (vPlanarConfiguration == 1)
				image=new ReadableNonInterleaved32BitCMYKImage(&sPixelData,vColumns,vRows,vNumberOfFrames,
						vBitsAllocated,vBitsStored,vHighBit);
			else {
				log << EMsgDC(Unsupported) << " - PlanarConfiguration = " << vPlanarConfiguration << endl;
				return 1;
			}
		}
		else {
			log << EMsgDC(Unsupported) << " - PhotometricInterpretation = \""
			    << (vPhotometricInterpretation ? vPhotometricInterpretation : "")
			    << "\"" << endl;
			return 1;
		}
	}
	else {
		log << EMsgDC(Unsupported) << " - SamplesPerPixel = " << vSamplesPerPixel << endl;
		return 1;
	}

	if (!pixelrepresentationok) {
		log << WMsgDC(NonMonochromeSignedPixelRepresentation) << endl;
	}
	if (!windowlevelwidthok) {
		log << WMsgDC(NoNeedForWindowLevelWidth) << endl;
	}

	char *vPatientName=AttributeValue(list[TagFromName(PatientName)]);
	char *vPatientID=AttributeValue(list[TagFromName(PatientID)]);
	char *vStudyID=AttributeValue(list[TagFromName(StudyID)]);
	Uint16 vSeriesNumber=AttributeValue(list[TagFromName(SeriesNumber)]);
	Uint16 vInstanceNumber=AttributeValue(list[TagFromName(InstanceNumber)]);

	ostrstream topleftostr;
	topleftostr << (vPatientID ? vPatientID : "?") << ends;
	char *topleftstring=topleftostr.str();

	ostrstream toprightostr;
	toprightostr << (vPatientName ? vPatientName : "?") << ends;
	char *toprightstring=toprightostr.str();

	ostrstream topcenterostr;
	topcenterostr << (vStudyID ? vStudyID : "?") << "/" << vSeriesNumber << "/" << vInstanceNumber << ends;
	char *topcenterstring=topcenterostr.str();

ECHOTHETIME("opening and setting up display");

	OurDisplay display;
	if (!display.good()) {
		log << display.errors() << endl;
		return 1;
	}

	OurWindow window(&display,
		vColumns,
		vRows*vNumberOfFrames,
		20,20);
	if (!window.good()) {
		log << window.errors() << endl;
		return 1;
	}

	OurWindowImage wimage(&window);
	log << wimage.errors() << endl;
	if (!wimage.good()) {
		return 1;
	}

	OurColorMap map(&display);
	if (!map.good()) {
		log << map.errors() << endl;
		return 1;
	}
	else {
		unsigned nwanted;
		unsigned nminimum;
		unsigned n;
		unsigned long *cells;
		unsigned short *red;
		unsigned short *green;
		unsigned short *blue;
		if (!(image->getColorCellsWanted(nwanted,nminimum)
		   && map.setColorCellsWanted(nwanted,nminimum)
		   && map.getColorCellsAvailable(n,cells)
		   && image->setColorCellsAvailable(n,cells)
		   && image->getColorCellValues(n,red,green,blue)
		   && map.setColorCellValues(n,red,green,blue)
		)) {
			log << map.errors();
			log << "Color map establishment failed" << endl;
			return 1;
		}
		window.setColormap(&map);
	}

	OurWindowLevelWidthUpdator wlwupdate(
		window,image->getBits(),	// Probably still same as BitsStored
		image->getSigned(),		// May have been changed by statistics
		vRescaleIntercept,vRescaleSlope);

	bool usewlm = !nVOILUT && image->hasWindowLevelWidth();

	int usewhichlut=0;

	if (nVOILUT) {
		image->setVOILUT(VOILUT_first[usewhichlut],VOILUT_number[usewhichlut],VOILUT_depth[usewhichlut],VOILUT_table[usewhichlut]);
	}

	if (usewlm && windowlevelset && windowwidthset) {
		Uint16 width;
		Uint16 level;
			level=(Uint16)wlwupdate.getStoredLevelFromDisplayedLevel(windowlevelvalue);
			width=(Uint16)wlwupdate.getStoredWidthFromDisplayedWidth(windowwidthvalue);
			image->setWindowLevelWidth(level,width);
	}

	if (usewlm) {
		Uint16 width;
		Uint16 level;
		image->getWindowLevelWidth(level,width);
		wlwupdate.set(level,width);
	}

	char *pixels=wimage.get8BitDataAddress();
	if (!pixels) {
		log << EMsgDC(PixelDataTargetNotAvailable) << endl;
		return 1;
	}

ECHOTHETIME("first put8BitIndexedPixels");

	if (!image->put8BitIndexedPixels(pixels,wimage.getBytesPerRow(),
			0,0,vColumns-1,vRows*vNumberOfFrames-1)) {
		log << EMsgDC(PixelDataReadFailed) << endl;
		//return 1;
	}

	window.useCursorCrossHair();
	window.start();

	PositionOfPixel positioner(list,log,false);

ECHOTHETIME("about to enter event loop");

	bool shifton=false;
	bool controlon=false;
	bool button1down=false;
	while (1) {
		XEvent report = display.nextEvent();
		switch (report.type) {
			case Expose:
//cerr << "report.xexpose.count == " << report.xexpose.count << endl;
				if (report.xexpose.count != 0) break;
				if (usewlm) wlwupdate.put();
				window.writeHeaderText(topleftstring,topcenterstring,toprightstring);
ECHOTHETIME("wimage.put() start");
				wimage.put();
ECHOTHETIME("wimage.put() done");
ECHOTHETIME("overlays.putOverlay(wimage) start");
				if (showoverlays) overlays.putOverlay(wimage);
ECHOTHETIME("overlays.putOverlay(wimage) done");
				if (nodisplayloop) goto done;
				break;
			case ButtonPress:
				if (report.xbutton.button == Button1) {
					button1down=true;
					if (usewlm) {
						wlwupdate.press(report.xbutton.x,report.xbutton.y);
						window.useCursorLevelWidth();
					}
					else {
						window.alarm();
					}
				}
				break;
			case ButtonRelease:
				if (report.xbutton.button == Button1) {
					button1down=false;
					if (usewlm) {
#ifndef DYNAMICWINDOW
						window.useCursorWatch();
						wlwupdate.release(report.xbutton.x,report.xbutton.y);
						Uint16 width;
						Uint16 level;
						wlwupdate.get(level,width);
						if (!image->setWindowLevelWidth(level,width)) {
							log << map.errors();
							log << EMsgDC(ColorCellValueReplacementFailed) << endl;
							return 1;
						}
ECHOTHETIME("put8BitIndexedPixels start");
						if (!image->put8BitIndexedPixels(pixels,wimage.getBytesPerRow(),
								0,0,vColumns-1,vRows*vNumberOfFrames-1)) {
							log << EMsgDC(PixelDataReadFailed) << endl;
							//return 1;
						}
#ifdef DONTSENDEXPOSEEVENT
ECHOTHETIME("wimage.put() start");
						wimage.put();
ECHOTHETIME("wimage.put() done");
ECHOTHETIME("overlays.putOverlay(wimage) start");
						if (showoverlays) overlays.putOverlay(wimage);
ECHOTHETIME("overlays.putOverlay(wimage) done");
#else
						window.redraw();							
#endif
						window.useCursorCrossHair();
#endif
					}
				}
				break;
			case MotionNotify:
				if (button1down) {
					int multiplier=(report.xkey.state&ShiftMask ? 10 : 1)
						      *(report.xkey.state&ControlMask ? 100 : 1);
					if (usewlm) {
						wlwupdate.update(report.xmotion.x,report.xmotion.y,multiplier);
#ifdef DYNAMICWINDOW
						window.useCursorWatch();
						wlwupdate.release(report.xbutton.x,report.xbutton.y);
						Uint16 width;
						Uint16 level;
						wlwupdate.get(level,width);
						if (!image->setWindowLevelWidth(level,width)) {
							log << map.errors();
							log << EMsgDC(ColorCellValueReplacementFailed) << endl;
							return 1;
						}
ECHOTHETIME("put8BitIndexedPixels start");
						if (!image->put8BitIndexedPixels(pixels,wimage.getBytesPerRow(),
								0,0,vColumns-1,vRows*vNumberOfFrames-1)) {
							log << EMsgDC(PixelDataReadFailed) << endl;
							//return 1;
						}
#ifdef DONTSENDEXPOSEEVENT
ECHOTHETIME("wimage.put() start");
						wimage.put();
ECHOTHETIME("wimage.put() done");
ECHOTHETIME("overlays.putOverlay(wimage) start");
						if (showoverlays) overlays.putOverlay(wimage);
ECHOTHETIME("overlays.putOverlay(wimage) done");
#else
						window.redraw();							
#endif
						window.useCursorCrossHair();
#endif
					}
				}
				else {
					unsigned short row;
					unsigned short col;
					window.reportPosition(
						report.xmotion.x,report.xmotion.y,
						row,col);
					Float64 patientX,patientY,patientZ;
					if (positioner.getPosition(row,col,patientX,patientY,patientZ)) {
//cerr <<  "row=" << row
//     << " col=" << col
//     << " X=" << patientX
//     << " Y=" << patientY
//     << " Z=" << patientZ
//     << endl;
						window.clearFooter();
						ostrstream rowcolostr;
						rowcolostr <<  "R" << setw(4) << row
							   << " C" << setw(4) << col
							   << ends;
						char *rowcolstr = rowcolostr.str();

						ostrstream xyzostr;
						xyzostr <<  setiosflags(ios::fixed|ios::showpoint)
							<<  "X" <<  setprecision(1) << setw(6) << patientX
							<< " Y" <<  setprecision(1) << setw(6) << patientY
							<< " Z" <<  setprecision(1) << setw(6) << patientZ
							<< ends;
						char *xyzstr = xyzostr.str();

						window.writeFooterText(rowcolstr,0,xyzstr);

						if (rowcolstr) delete[] rowcolstr;
						if (xyzstr) delete[] xyzstr;
					}

				}
				break;
			case KeyPress:
				{
					int deltax=0;
					int deltay=0;
					KeySym keysym;
					(void)XLookupString(&report.xkey,0,0,&keysym,0);
					switch (keysym) {
						case XK_Shift_L:
						case XK_Shift_R:
						case XK_Shift_Lock:
						case XK_Control_L:
						case XK_Control_R:
							break;		// handled by state, but must be allowed to press them
						case XK_Left:
						case XK_R10:		// the shifted state is a different keysym :(
							deltax=-1;
							break;
						case XK_Right:
						case XK_R12:		// the shifted state is a different keysym :(
							deltax=1;
							break;
						case XK_Up:
						case XK_R8:		// the shifted state is a different keysym :(
							deltay=-1;
							break;
						case XK_Down:
						case XK_R14:		// the shifted state is a different keysym :(
							deltay=1;
							break;
						case XK_Escape:
						case XK_Return:
						case XK_q:
						case XK_Q:
						case XK_x:
						case XK_X:
							goto done;
							// break;
						case XK_o:
						case XK_O:
							showoverlays=!showoverlays;
#ifdef DONTSENDEXPOSEEVENT
							if (showoverlays) {
ECHOTHETIME("overlays.putOverlay(wimage) start");
								overlays.putOverlay(wimage);
ECHOTHETIME("overlays.putOverlay(wimage) done");
							}
							else {
ECHOTHETIME("wimage.put() start");
								wimage.put();
ECHOTHETIME("wimage.put() done");
							}
#else
							window.redraw();							
#endif
							break;
						case XK_v:
						case XK_V:
							if (nVOILUT) {
								window.useCursorWatch();
								if (++usewhichlut >= nVOILUT) usewhichlut=0;
								image->setVOILUT(VOILUT_first[usewhichlut],VOILUT_number[usewhichlut],
									VOILUT_depth[usewhichlut],VOILUT_table[usewhichlut]);
								if (!image->put8BitIndexedPixels(pixels,wimage.getBytesPerRow(),
									0,0,vColumns-1,vRows*vNumberOfFrames-1)) {
									log << EMsgDC(PixelDataReadFailed) << endl;
									//return 1;
								}
#ifdef DONTSENDEXPOSEEVENT
ECHOTHETIME("wimage.put() start");
								wimage.put();
ECHOTHETIME("wimage.put() done");
ECHOTHETIME("overlays.putOverlay(wimage) start");
								if (showoverlays) overlays.putOverlay(wimage);
ECHOTHETIME("overlays.putOverlay(wimage) done");
#else
								window.redraw();							
#endif
								window.useCursorCrossHair();

							}
							else
								window.alarm();
							break;
						default:
							window.alarm();
							break;
					}
					if (deltax || deltay) {
						if (usewlm) {
							int multiplier=(report.xkey.state&ShiftMask ? 10 : 1)
								      *(report.xkey.state&ControlMask ? 100 : 1);
							window.useCursorWatch();
							wlwupdate.move(deltax,deltay,multiplier);
							Uint16 width;
							Uint16 level;
							wlwupdate.get(level,width);
							if (!image->setWindowLevelWidth(level,width)) {
								log << map.errors();
								log << EMsgDC(ColorCellValueReplacementFailed) << endl;
								return 1;
							}
							if (!image->put8BitIndexedPixels(pixels,wimage.getBytesPerRow(),
									0,0,vColumns-1,vRows*vNumberOfFrames-1)) {
								log << EMsgDC(PixelDataReadFailed) << endl;
								//return 1;
							}
#ifdef DONTSENDEXPOSEEVENT
ECHOTHETIME("wimage.put() start");
							wimage.put();
ECHOTHETIME("wimage.put() done");
ECHOTHETIME("overlays.putOverlay(wimage) start");
							if (showoverlays) overlays.putOverlay(wimage);
ECHOTHETIME("overlays.putOverlay(wimage) done");
#else
							window.redraw();							
#endif
							window.useCursorCrossHair();
						}
						else {
							window.alarm();
						}
					}
				}
				break;
			default:
				break;
		}
	}

	// not reached ...

	// if (topleftstring) delete[] topleftstring;
	// if (toprightstring) delete[] toprightstring;
	// if (topcenterstring) delete[] topcenterstring;
	// if (vPatientName) delete[] vPatientName;
	// if (vPatientID) delete[] vPatientID;
	// if (vStudyID) delete[] vStudyID;

done:
	if (writeimage && !wimage.write8BitDataToPGMStream(cout)) {
		log << EMsgDC(PixelDataWriteFailed) << endl;
		return 1;
	}
	else {
		return 0;
	}
}


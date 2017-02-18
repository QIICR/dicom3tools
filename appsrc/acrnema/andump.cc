static const char *CopyrightIdentifier(void) { return "@(#)andump.cc Copyright (c) 1993-2015, David A. Clunie DBA PixelMed Publishing. All rights reserved."; }
#if USESTANDARDHEADERSWITHOUTEXTENSION == 1
#include <iostream>
#include <iomanip>
#include <cctype>
#else
#include <iostream.h>
#include <iomanip.h>
#include <ctype.h>
#endif

#if EMITUSINGSTDNAMESPACE == 1
using namespace std;
#endif

#ifdef POWINTEGEREXPONENTTYPE
#define	powi(m,e)	pow(m,(POWINTEGEREXPONENTTYPE)(e))
#else
#define	powi(m,e)	pow(m,(long)(e))
#endif

#ifdef __SC__
#define infinity()    HUGE_VAL
#define quiet_nan(x)  0
#endif /* __SC__ */

#ifdef __MWERKS__
#define infinity()    __inf()
#define quiet_nan(x)  0
#endif /* __MWERKS__ */

#ifdef USEDUMBINFINITYANDNAN
#if USEDUMBINFINITYANDNAN
#define infinity()    HUGE_VAL
#define quiet_nan(x)  0
#endif
#endif

#include "attrtag.h"
#include "dcstream.h"
#include "dcopt.h"
#include "elmconst.h"
#include "elmdict.h"
#include "mesgtext.h"
#include "vr.h"

#ifndef MAXVLTODUMP
#define MAXVLTODUMP 32768
#endif

static TextOutputStream& 
writebase(TextOutputStream& stream,ElementDictionary& dict,const Tag tag,const char *vr,Uint32 vl)
{
	tag.write(stream,&dict);
	stream << "\t VR=<" << (vr ? vr : "") << ">  " << flush;
	stream << " VL=<";
	writeZeroPaddedHexNumber(stream,vl,4);
	stream << ">  " << flush;
	return stream;
}

static TextOutputStream&
doStringValues(DicomInputStream& in,TextOutputStream& log,Uint32 vl,const char * &rstr)
{
	static char buffer[MAXVLTODUMP];
	Assert(vl < MAXVLTODUMP);
	if (vl) in.read(buffer,(int)vl);
	buffer[vl]=0;
	if (!in.fail()) {
		log << "<";
		char *ptr=buffer;
		while (vl--) {
			if (*ptr)
				log << *ptr;
			else if (vl) {	// Allow single trailing null eg. for UI string
				log << endl << WMsgDC(UnexpectedNullInString) << endl;
				break;
			}
			++ptr;
		}
		log << "> ";
		// return value has no leading or trailing space
		ptr=buffer+strlen(buffer);
		while (ptr >= buffer && (*ptr == 0 || isspace(*ptr))) *ptr--=0;
		rstr=buffer;
		while (*rstr && isspace(*rstr)) ++rstr;
	}
	else {
		cerr << EMsgDC(ReadFailed) << endl;
		rstr=0;
	}
	return log;
}

static TextOutputStream&
doTagValues(DicomInputStream& in,TextOutputStream& log,Uint32 vl)
{
	if (vl%4) {
		cerr << EMsgDC(BadValueLength) << endl;
		in.seekg(vl,ios::cur);
		if (in.fail()) {
			cerr << EMsgDC(SeekFailed) << endl;
		}
	}
	else {
		log << "{";
		while (vl) {
			Uint16 group;
			Uint16 element;
			in >> group;
			in >> element;
			log << "(";
			writeZeroPaddedHexNumber(log,group,4);
			log << ",";
			writeZeroPaddedHexNumber(log,element,4);
			log << ")";
			vl-=4;
		}
		log << "} ";
		if (in.fail()) {
			cerr << EMsgDC(ReadFailed) << endl;
		}
	}
	return log;
}

static TextOutputStream&
doBinaryValues(DicomInputStream& in,TextOutputStream& log,Uint32 vl,size_t size,Uint32& rval)
{
	rval=0;
	if (vl < size) size=vl;	// handles special case of 1 US where UL wanted
	if (vl%size) {
		cerr << EMsgDC(BadValueLength) << endl;
		in.seekg(vl,ios::cur);
		if (in.fail()) {
			cerr << EMsgDC(SeekFailed) << endl;
		}
	}
	else {
		log << "[";
		while (vl) {
			Uint32 value;
			switch(size) {
				case 1: { Uint8  v; in >> v; value=v; } break;
				case 2: { Uint16 v; in >> v; value=v; } break;
				case 4: { Uint32 v; in >> v; value=v; } break;
				default: Assert(0); break;
			}
			rval=value;
			writeZeroPaddedHexNumber(log,value,size*2);
			vl-=size;
			if (vl) log << ",";
		}
		log << "] ";
		if (in.fail()) {
			cerr << EMsgDC(ReadFailed) << endl;
		}
	}
	return log;
}

static TextOutputStream&
doFloatValues(DicomInputStream& in,TextOutputStream& log,Uint32 vl,size_t size)
{
	if (vl%size) {
		Uint32 ival;
		doBinaryValues(in,log,vl,1,ival);
		cerr << EMsgDC(BadValueLength) << endl;
		//in.seekg(vl,ios::cur);
		//if (in.fail()) {
		//	cerr << EMsgDC(SeekFailed) << endl;
		//}
	}
	else {
		log << "{";
		while (vl) {
			if (size == 4) {
				Uint32 binary; in >> binary;

				double value;
				Int16 sign	=(Int16)((binary&0x80000000)>>31);
				Int16 exponent	=(Int16)((binary&0x7f800000)>>23);
				Uint32 mantissa	= binary&0x007fffff;

				if (exponent == 0) {
					if (mantissa == 0)
						value=0;
					else {
						value=((double)mantissa/
							(1<<23))*powi(2.0,-126);
						value = (sign == 0) ? value : -value;
					}
				}
				else if (exponent == 255) {
					if (mantissa)
						value=quiet_nan(0);
					else
						value=infinity();
				}
				else {
					value=(1.0+(double)mantissa/
						(1<<23))*powi(2.0,exponent-127);
					value = (sign == 0) ? value : -value;
				}
				log << dec << value;
			}
			else if (size == 8) {
				Uint32 binary1; in >> binary1;
				Uint32 binary2; in >> binary2;

				double value;
				Uint32 high = in.isBigEndian() ? binary1 : binary2;
				Uint32 low  = in.isBigEndian() ? binary2 : binary1;

				Int16 sign	=(Int16)((high&0x80000000)>>31);
				Int16 exponent	=(Int16)((high&0x7ff00000)>>20);
				Uint32 mantissahigh = high&0x000fffff;
				Uint32 mantissalow  = low &0xffffffff;
				double mantissavalue = (double)mantissahigh * powi(2.0,32)
						     + (double)mantissalow;

				if (exponent == 0) {
					if (mantissahigh == 0 && mantissalow == 0)
						value=0;
					else {
						value=(mantissavalue/powi(2.0,52))
							*powi(2.0,-1022);
						value = (sign == 0) ? value : -value;
					}
				}
				else if (exponent == 255) {
					if (mantissahigh || mantissalow)
						value=quiet_nan(0);
					else
						value=infinity();
				}
				else {
					value=(1.0+mantissavalue/powi(2.0,52))
						*powi(2.0,exponent-1023);
					value = (sign == 0) ? value : -value;
				}
				log << dec << value;
			}
			else {
				Assert(0);
			}

			vl-=size;
			if (vl) log << ",";
		}
		log << "} ";
		if (in.fail()) {
			cerr << EMsgDC(ReadFailed) << endl;
		}
	}
	return log;
}

static bool
readAll(DicomInputStream& stream,TextOutputStream& log,ElementDictionary& dict,bool showoffset,ios::fmtflags showoffsetbase,bool ancreate,bool extractCSA)
{
	Uint32 n=stream.haveMetaHeader() ? 132 : 0;
	Uint32 length=0xffffffff;
	bool lastwasencapOXorItem=false;
	bool donewithmetaheader=false;
	Tag *siemensCSAHeaderInfoTag = NULL;
	while (stream.peek() != istream::traits_type::eof() && (length == 0xffffffff || n < length)) {
		if (showoffset) {
			log << "@";
			writeZeroPaddedNumber(log,n,showoffsetbase,8);
#ifdef CHECKFORSGINATIVECCSEEKBUG
			log << "(";
			writeZeroPaddedHexNumber(log,stream.rdbuf()->PubSeekOff(0,ios::cur),8);
			log << ")";
#endif
			log << ": ";
		}
		Tag tag;
		stream >> tag;
		if (stream.fail()) {
			cerr << EMsgDC(TagReadFailed) << endl;
			return false;
		}
		n+=4;

		if (!donewithmetaheader && !tag.isMetaheaderGroup()) {
			{
				// backup and read again in case endian changed ...
#ifdef CHECKFORSGINATIVECCSEEKBUG
log << endl << "Before endian check backup @";
writeZeroPaddedHexNumber(log,n,8);
log << "(";
writeZeroPaddedHexNumber(log,stream.rdbuf()->PubSeekOff(0,ios::cur),8);
log << ")"
    << ": ";
#endif
				stream.seekg(-4l,ios::cur);
				if (stream.fail()) {
					cerr << EMsgDC(TagReadFailed) << " - " << EMsgDC(SeekFailed) << endl;
					return false;
				}
#ifdef CHECKFORSGINATIVECCSEEKBUG
log << endl << "Before endian check backup @";
writeZeroPaddedHexNumber(log,n,8);
log << "(";
writeZeroPaddedHexNumber(log,stream.rdbuf()->PubSeekOff(0,ios::cur),8);
log << ")"
    << ": " << endl;
#endif
				if (!stream.getTransferSyntaxToReadDataSet()) {
					cerr << EMsgDC(NoTransferSyntaxInMetaHeader) << endl;
					bool setswapped32big;
					stream.guessTransferSyntaxToReadDataSet(setswapped32big);		// always guesses something
				}
				stream.readingDataSet();
				donewithmetaheader=true;
				stream >> tag;
				if (stream.fail()) {
					cerr << EMsgDC(TagReadFailed) << endl;
					return false;
				}
			}
		}

		char vre[3];
		const char *vr;
		Uint32 vl;

		if (tag == TagFromName(ItemDelimitationItem)
		 || tag == TagFromName(SequenceDelimitationItem)
		 || tag == TagFromName(Item)
		 || tag == Tag(0xfeff,0x00e0)				// GE bug (endianness of Item tag in encapsulated pixel data)
		 || tag == Tag(0xfeff,0xdde0)				// GE bug (endianness of Sequence Delimitation Item tag in encapsulated pixel data)
		) {
			vr=0;
			stream >> vl;
			if (tag == Tag(0xfeff,0x00e0)) {
				vl = ((vl>>24)&0xff) + (((vl>>16)&0xff)<<8) + (((vl>>8)&0xff)<<16) +((vl&0xff)<<24);	// GE bug - swap VL endianness as well
			}
			n+=4;
		}
		else  {
			if (stream.getTransferSyntaxInUse()->isExplicitVR()) {
				stream.read(vre,2);
				if (stream.fail()) {
					cerr << EMsgDC(VRReadFailed) << endl;
					return false;
				}
				if (vre[0] == '-' && vre[1] == '-') {			// illegal proprietary equivalent of UN VR used by Australian Central Data Networks (CDN) PACS
					vr="UN";
					vl=stream.read16();
					n+=2;
				}
				else if (vre[0] == 0 && vre[1] == 0) {			// illegal two bytes of zero VR encountered in Sante de-identifier output (followed by two byte length)
					vr="UN";
					vl=stream.read16();
					n+=2;
				}
				else if (vre[0] < 'A' || vre[1] < 'A') {		// DicomWorks bug ... occasional implicit VR attribute even though explicit transfer syntax
					//cerr << EMsgDC(TagReadFailed) << " - " << MMsgDC(ImplicitVREncodingWhenExplicitRequired) << endl;
					vr="UN";
					stream.seekg(-2l,ios::cur);
					if (stream.fail()) {
						cerr << EMsgDC(TagReadFailed) << " - " << EMsgDC(SeekFailed) << endl;
						return false;
					}
					stream >> vl;				// read VL as if implicit VR
					n+=4;
				}
				else {
					n+=2;
					vre[2]=0;
					vr=vre;
					if (isUniversalResourceVR(vr) || isUnlimitedCharactersVR(vr) || isUnlimitedTextVR(vr) || isUnknownVR(vr)) {
						// should be long form, but check for bad implementations that use short form ...
						vl=stream.read16();
						n+=2;
						if (vl == 0) {		// if reserved bytes not zero, assume used for short form of length (risky) :(
							stream >> vl;
							n+=4;
						}
						else {
							cerr << EMsgDC(IncorrectShortVLForUROrUCOrUTOrUN) << endl;
						}
					}
					else if (isLongValueLengthInExplicitValueRepresentation(vr)) {	// some of these already handled above
						(void)stream.read16();	// "Reserved"
						stream >> vl;
						n+=6;
					}
					else {
						vl=stream.read16();
						n+=2;
					}
				}
			}
			else {
				vr=(tag.isPrivateGroup() && tag.isPrivateOwner())
					? "LO"	// PS3.5-7.8.1
					: dict.getValueRepresentation(tag);
				stream >> vl;
				n+=4;
			}
		}
		if (stream.fail()) {
			cerr << EMsgDC(VLReadFailed) << endl;
			return false;
		}

		if (ancreate) {
			if (tag == TagFromName(ItemDelimitationItem)) {
				log << "%enditem";
			}
			else if (tag == TagFromName(SequenceDelimitationItem)) {
				log << "%endseq";
			}
			else if (tag == TagFromName(Item)) {
				log << "%item";
			}
			else {
				writebase(log,dict,tag,vr,vl);
			}
		}
		else {
			writebase(log,dict,tag,vr,vl);
		}
		
		if (vl == 0xffffffff		// SQ or OX both will contain items
		 || vl == 0			// includes ItemDelimitationItem,SequenceDelimitationItem
		 || isSequenceVR(vr)		// SQ with defined length
		 || (tag == TagFromName(Item) && !lastwasencapOXorItem)	// Item with element contents
		) {
			if (!ancreate
			 || (tag != TagFromName(ItemDelimitationItem)
			  && tag != TagFromName(SequenceDelimitationItem)
			  && tag != TagFromName(Item))) {
				log << "\t[]";
			}
		}
		else {
			if (extractCSA && siemensCSAHeaderInfoTag && *siemensCSAHeaderInfoTag == tag) {
				// do nothing - treat it as containing DICOM tags and loop around - works for EVRLE only
				// should also check to stop at (0xffff,0xffff)
			}
			else if (vl < MAXVLTODUMP) {
				if (isStringVR(vr)) {
					const char *sval;
					doStringValues(stream,log,vl,sval);
					if (!stream.fail() && vl && sval && *sval) {
						if (tag == TagFromName(TransferSyntaxUID)) {
							if (!donewithmetaheader) {
								stream.setTransferSyntaxToReadDataSet(new TransferSyntax(sval));
							}
						}
						else if (tag.isPrivateGroup() && tag.isPrivateOwner()) {
							dict.addOwner(tag,sval);
							if (tag.getGroup() == 0x0029 && strcmp(sval,"SIEMENS CSA HEADER") == 0) {
								Uint16 siemensCSAHeaderInfoElement=((tag.getElement() << 8) & 0xff00)+0x0010;
								siemensCSAHeaderInfoTag = new Tag(0x0029,siemensCSAHeaderInfoElement);
							}
						}
					}
				}
				else if (isAttributeTagVR(vr))
					doTagValues(stream,log,vl);
				else if (isNumericVR(vr)) {
					Uint32 ival;
					size_t size=sizeofNumericVR(vr);
					doBinaryValues(stream,log,vl,size,ival);
					if (!stream.fail() && vl == size) {
						if (tag == TagFromName(LengthToEnd)
						 && length == 0xffffffff) {
							// Retired, but if you've got it use it
							//length=n+ival+vl;
						}
					}
				}
				else if (isFloatVR(vr)) {
					size_t size=sizeofFloatVR(vr);
					doFloatValues(stream,log,vl,size);
				}
				else {
					//cerr << endl << WMsgDC(UnrecognizedVR) << endl;
					Uint32 ival;
					doBinaryValues(stream,log,vl,1,ival);
				}
			}
			else {
				Assert(!ancreate);
				log << "\t[]\t# skipping ...";		
				stream.seekg(vl,ios::cur);
				if (stream.fail()) {
					cerr << EMsgDC(SeekFailed) << endl;
					return false;
				}
			}
			n+=vl;
		}
		lastwasencapOXorItem=
			(isOtherByteOrWordOrUnspecifiedVR(vr)
			 || tag == TagFromName(Item)
			 || tag == TagFromName(ItemDelimitationItem)
			) && stream.getTransferSyntaxInUse()->isEncapsulated();

		log << endl;
	}
	return true;
}

int
main(int argc, char *argv[])
{
	GetNamedOptions    options(argc,argv);
	DicomInputOptions input_options(options);

	bool showfilename=options.get("filename");
	bool ancreate=options.get("ancreate");
	bool extractCSA=options.get("extractCSA");
	bool showoffset=false;
	ios::fmtflags showoffsetbase;
	if (options["showoffset"]||options["showoffset-hex"])
		{ showoffset=true; showoffsetbase=ios::hex; }
	else if (options["showoffset-octal"]||options["showoffset-oct"])
		{ showoffset=true; showoffsetbase=ios::oct; }
	else if (options["showoffset-decimal"]||options["showoffset-dec"])
		{ showoffset=true; showoffsetbase=ios::dec; }

	input_options.done();
	options.done();

	DicomInputOpenerFromOptions input_opener(
		options,input_options.filename,cin);

	cerr << options.errors();
	cerr << input_options.errors();
	cerr << input_opener.errors();

	if (!input_options.good()
	 || !options.good()
	 || !input_opener.good()
	 || !options) {
		cerr 	<< MMsgDC(Usage) << ": " << options.command()
			<< input_options.usage()
			<< " [-ancreate]"
			<< " [-extractCSA]"
			<< " [-showoffset|-showoffset-hex"
			<< "|-showoffset-octal|-showoffset-oct"
			<< "|-showoffset-decimal|-showoffset-dec]"
			<< " [-filename]"
			<< " [" << MMsgDC(InputFile) << "]"
			<< " <" << MMsgDC(InputFile)
			<< endl;
		exit(1);
	}

	DicomInputStream din(*(istream *)input_opener,
		input_options.transfersyntaxuid,
		input_options.usemetaheader);
	TextOutputStream log(cerr);

	if (showfilename) {
		const char *filenameused = input_opener.getFilename();
		log << "Filename: \"" << (filenameused && strlen(filenameused) > 0 ? filenameused : "-") << "\"" << endl;
	}

	ElementDictionary dictionary;

	readAll(din,log,dictionary,showoffset,showoffsetbase,ancreate,extractCSA);
}

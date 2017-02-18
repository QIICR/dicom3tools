static const char *CopyrightIdentifier(void) { return "@(#)attrmxrd.cc Copyright (c) 1993-2015, David A. Clunie DBA PixelMed Publishing. All rights reserved."; }
#include "attrtype.h"
#include "attrnew.h"
#include "attrmxls.h"
#include "attrseq.h"
#include "elmconst.h"
#include "attrothr.h"
#include "attrval.h"
#include "mesgtext.h"

// This may be defined in attrtype.h previously ...

#ifndef LARGESTOTHERDATATOKEEPINMEMORY
#define LARGESTOTHERDATATOKEEPINMEMORY 524288
#endif

// Want a routine to actually read rather than just use seekg(), since otherwise
// there is no detection of failure to skip a truncated attribute at the end
// of the dataset

// Need to use Unit32 (NOT long) argument and return value, since may be larger than 2GB (e.g., for large uncompressed pixel data), and VL may be up to (2^32)-2 (000440)

static Uint32
skipBytes(istream *stream,Uint32 nSkip) {
	bool success=true;
	const int bufferSize=32768;
	char buffer[bufferSize];
	Uint32 totalSkipped=0;
	while (nSkip > 0) {
		int nToRead = nSkip > bufferSize ? bufferSize : (int)nSkip;
		stream->read(buffer,nToRead);
		if (stream->fail()) {
			break;
		}
		int nActuallyRead = (int)(stream->gcount());
		if (nActuallyRead == 0) {
			break;
		}
		nSkip-=nActuallyRead;
		totalSkipped+=nActuallyRead;
	}
	return totalSkipped;
}

TextOutputStream& 
ReadableAttributeList::writebase(const Tag tag,const char *vr,Uint32 vl)
{
	Assert(log);
	tag.write(*log,dictionary);
	(*log) << "\t VR=<" << (vr ? vr : "") << ">  " << flush;
	(*log) << " VL=<";
	writeZeroPaddedHexNumber(*log,vl,4);
	(*log) << ">  " << flush;
	return (*log);
}

const char *
ReadableAttributeList::getValueRepresentation(Tag tag,char *vrbuf,bool& readAsImplicitRegardless)
{
//cerr << "ReadableAttributeList::getValueRepresentation():" << endl;
	// dictionary Value Representation expected

//cerr << "ReadableAttributeList::getValueRepresentation tag.isPrivateGroup()" << (tag.isPrivateGroup() ? "true" : "false") << endl;
//cerr << "ReadableAttributeList::getValueRepresentation tag.isPrivateOwner()" << (tag.isPrivateOwner() ? "true" : "false") << endl;
	
	const char *vrd=
		(tag.isPrivateGroup() && tag.isPrivateOwner())
			? "LO"	// PS3.5-7.8.1
			: dictionary->getValueRepresentation(tag);

	// explicit Value Representation in input

	//readAsImplicitRegardless=false;
	const char *vre;
	//Assert(stream->getTransferSyntaxInUse()->isImplicitVR() != stream->getTransferSyntaxInUse()->isExplicitVR());
	//if (stream->getTransferSyntaxInUse()->isExplicitVR()) {	// See [bugs.dicom3tools] (000130) as to why this and previous assertion commented out
	if (!stream->getTransferSyntaxInUse()->isImplicitVR() && !readAsImplicitRegardless) {
//cerr << "ReadableAttributeList::getValueRepresentation(): stream is explicit VR - reading VR" << endl;
		stream->read(vrbuf,2);
		if (stream->fail()) return 0;
		if (vrbuf[0] == '-' && vrbuf[1] == '-') {	// illegal proprietary equivalent of UN VR used by Australian Central Data Networks (CDN) PACS
			TextOutputStream terr(errorstream.rdbuf());
			tag.write(terr,dictionary);
			errorstream << EMsgDC(IllegalCDNHyphenVR) << endl;
			byteoffset+=2;
			vrbuf[0]=vrbuf[1]=vrbuf[2]=0;		// ignore whatever was read (vrbuf contents are tested by caller)
			vre=0;								// will trigger return value based on dictionary lookup
		}
		else if (vrbuf[0] == 0 && vrbuf[1] == 0) {	// illegal two bytes of zero VR encountered in Sante de-identifier output (followed by two byte length)
			TextOutputStream terr(errorstream.rdbuf());
			tag.write(terr,dictionary);
			errorstream << EMsgDC(IllegalZeroBytesWhenExplicitVRExpected) << endl;
			byteoffset+=2;
			vrbuf[0]=vrbuf[1]=vrbuf[2]=0;		// ignore whatever was read (vrbuf contents are tested by caller)
			vre=0;								// will trigger return value based on dictionary lookup
			// subsequent call to getValueLength() will guess that short form length is in use because no padding zero bytes
		}
		else if (vrbuf[0] < 'A' || vrbuf[1] < 'A') {		// DicomWorks bug ... occasional implicit VR attribute even though explicit transfer syntax
			TextOutputStream terr(errorstream.rdbuf());
			tag.write(terr,dictionary);
			errorstream << EMsgDC(TagReadFailed) << " - " << MMsgDC(ImplicitVREncodingWhenExplicitRequired) << endl;
//cerr << "ReadableAttributeList::getValueRepresentation(): implicit VR encoding even though supposed to be explicit" << endl;
			good_flag=false;
			// backup so that we treat the VR bytes as VL, and do not advance byteoffset
			stream->seekg(-2l,ios::cur);
			if (stream->fail()) {
				tag.write(terr,dictionary);
				errorstream << EMsgDC(TagReadFailed) << " - " << EMsgDC(SeekFailed) << endl;
				good_flag=false;
				return 0;
			}
			vrbuf[0]=vrbuf[1]=vrbuf[2]=0;		// ignore whatever was read (vrbuf contents are tested by caller)
			readAsImplicitRegardless=true;
			vre=0;					// will trigger return value based on dictionary lookup
		}
		else {
			byteoffset+=2;
			vrbuf[2]=0;
			vre=vrbuf;
		}
	}
	else
		vre=0;

	// if was Explicit VR, vrbuf is now set and can be used as return value

	if (!vrd && vre) {
		TextOutputStream terr(errorstream.rdbuf());
		tag.write(terr,dictionary);
		if (strncmp(vre,"UN",2) == 0) {
			errorstream << " - " << WMsgDC(NoDictionaryVRUseExplicitUN) << endl;
		}
		else {
			errorstream << " - " << WMsgDC(NoDictionaryVRUseExplicit) << endl;
		}
	}

	// choose/match Value Representation to use

	TextOutputStream terr(errorstream.rdbuf());
	const char *vru;
	if (vre && vrd) {
		if (strncmp(vre,vrd,2) == 0) {
			// Both present and same
			vru=vre;
		}
		else if (strncmp(vre,"UN",2) == 0) {
			if (strncmp(vrd,"SQ",2) == 0) {
				vru=vre;	// Explicit overrides dictionary for sequence (since need to treat undefined length sequence content as implicit VR later)
				//tag.write(terr,dictionary);
				//errorstream << " - " << WMsgDC(MismatchDictionaryVR) << "; Explicit <" << vre << "> Dictionary <" << vrd << ">" << endl;
			}
			else {
				// Replace explicit UN with dictionary only if not a sequence
				vru=vrd;
				//tag.write(terr,dictionary);
				//errorstream << " - " << WMsgDC(OverridingUNWithDictionaryVR) << endl;
			}
		}
		else if ((strncmp(vrd,"OX",2) == 0
		          && (strncmp(vre,"OB",2) == 0
		              || strncmp(vre,"OW",2) == 0)
		         )
		      || (strncmp(vrd,"XS",2) == 0
		          && (strncmp(vre,"US",2) == 0
		              || strncmp(vre,"SS",2) == 0)
		         )
		      || (strncmp(vrd,"XO",2) == 0
		          && (strncmp(vre,"US",2) == 0
		              || strncmp(vre,"SS",2) == 0
		              || strncmp(vre,"OW",2) == 0)
		         )
		      || (strncmp(vrd,"XL",2) == 0
		          && (strncmp(vre,"UL",2) == 0
		              || strncmp(vre,"SL",2) == 0)
			 )
		      ) {
			// Explicit overrides ambiguous in dictionary
			vru=vre;
		}
		else {
			vru=vre;	// Explicit overrides dictionary
			tag.write(terr,dictionary);
			errorstream << " - " << WMsgDC(MismatchDictionaryVR) << "; Explicit <" << vre << "> Dictionary <" << vrd << ">" << endl;
		}
	}
	else if (vrd) {
		vru=vrd;
	}
	else if (vre) {
		vru=vre;
	}
	else {
		vru="UN";
	}

	if (tag.isPrivateGroup() && tag.isPrivateOwner()) {
		if (strncmp(vru,"LO",2) != 0) {
			vru="LO";
			tag.write(terr,dictionary);
			errorstream << " - " << EMsgDC(PrivateCreatorIsNotLOVR) << "; Explicit <" << vre << "> " << MMsgDC(OverridingVR) << " with <LO>" << endl;
		}
	}
	return vru;
}




Uint32
ReadableAttributeList::getValueLength(const char *vr,bool readAsImplicitRegardless)
{
//cerr << "ReadableAttributeList::getValueLength(): vr=" << vr << endl;
//cerr << "ReadableAttributeList::getValueLength(): readAsImplicitRegardless=" << readAsImplicitRegardless << endl;

	Uint32 vl;
	if (stream->getTransferSyntaxInUse()->isImplicitVR() || readAsImplicitRegardless) {
//cerr << "ReadableAttributeList::getValueLength(): is implicit VR" << endl;
		(*stream) >> vl;
		byteoffset+=4;
	}
	else {
//cerr << "ReadableAttributeList::getValueLength(): is explicit VR" << endl;
		if (isUniversalResourceVR(vr) || isUnlimitedCharactersVR (vr) || isUnlimitedTextVR(vr) || isUnknownVR(vr)) {
			// should be long form, but check for bad implementations that use short form ...
			vl=stream->read16();
			byteoffset+=2;
			if (vl == 0) {		// if reserved bytes not zero, assume used for short form of length (risky) :(
				(*stream) >> vl;
				byteoffset+=4;
			}
			else {
				errorstream << EMsgDC(IncorrectShortVLForUROrUCOrUTOrUN) << endl;
				//good_flag=false;
			}
		}
		else if (isLongValueLengthInExplicitValueRepresentation(vr)) {		// some of these already handled above
			(void)stream->read16();	// "Reserved"
			(*stream) >> vl;
			byteoffset+=6;
		}
		else {
			vl=stream->read16();
			byteoffset+=2;
		}
	}
//cerr << "ReadableAttributeList::getValueLength(): vl=0x" << hex << vl << dec << endl;
	return vl;
}

static void
dumpOffset(TextOutputStream *log,Uint32 byteoffset,DicomInputStream *stream,Uint32 length)
{
	unsigned long position=(unsigned long)stream->tellg();
	(*log) << "@";
	writeZeroPaddedHexNumber(*log,position,8);
#ifdef CHECKFORSGINATIVECCSEEKBUG
	(*log) << "(";
	writeZeroPaddedHexNumber(*log,stream->rdbuf()->PubSeekOff(0,ios::cur),8);
	(*log) << ")";
#endif
	(*log) << ",";
	writeZeroPaddedHexNumber(*log,byteoffset,8);
	(*log) << " of ";
	writeZeroPaddedHexNumber(*log,length,8);
	(*log) << ": ";
}

void
ReadableAttributeList::skipEncapsulatedData(void)
{
//cerr << "ReadableAttributeList::skipEncapsulatedData: start" << endl;
	bool showoffset=verbose;
	// See libsrc/include/pixeldat/unencap.h for details of GE bug
	while (1) {
//cerr << "ReadableAttributeList::skipEncapsulatedData: looping" << endl;
		if (verbose && showoffset) dumpOffset(log,byteoffset,stream,0xffffffff);
		Tag tag;
		(*stream) >> tag;	// Assume is Item Tag
		if (stream->fail()) {
			errorstream << EMsgDC(TagReadFailed) << endl;
			good_flag=false;
			return;
		}
		byteoffset+=4;
		
		// Always Implicit VR
		Uint32 vl;
		(*stream) >> vl;
		if (stream->fail()) {
			errorstream << EMsgDC(VLReadFailed) << endl;
			good_flag=false;
			return;
		}
		byteoffset+=4;

		if (verbose) {
			writebase(tag,"",vl); (*log) << endl;
		}

		if (tag == TagFromName(SequenceDelimitationItem)
		 || tag == Tag(0xfeff,0xdde0)				// GE bug
		 || tag == Tag(0xe0dd,0xfffe)				// GE bug
		) {
			return;
		}

		// If GE byte order bug is present, need to swap vl bytes ...

		if (tag != TagFromName(Item)) {		// don't actually check for 0xfeff,0x00e0 or 0xe000,0xfffe
//cerr << "ReadableAttributeList::skipEncapsulatedData: got possible bad byte order VL of 0x" << hex << vl << dec << endl;
			vl=(((Uint32)vl&0xff000000)>>24)
			  +(((Uint32)vl&0x00ff0000)>>8)
			  +(((Uint32)vl&0x0000ff00)<<8)
			  +(((Uint32)vl&0x000000ff)<<24);
//cerr << "ReadableAttributeList::skipEncapsulatedData: assuming VL has bad byte order, using 0x" << hex << vl << dec << endl;
		}

		//stream->seekg(vl,ios::cur); 
		//if (stream->fail()) {
		if (skipBytes(stream,vl) != vl || stream->fail()) {
			errorstream << EMsgDC(SeekFailed)
				    << " - while skipping encapsulated data"
				    << endl;
			good_flag=false;
			return;
		}
		byteoffset+=vl;
	}
}

SequenceAttribute *
ReadableAttributeList::readNewSequenceAttribute(Tag stag,Uint32 length,bool ignoreoutofordertags,bool useUSVRForLUTDataIfNotExplicit,bool undefinedLengthUNTreatedAsSequence,const char *sequenceOwner,bool fixBitsDuringRead,bool havePixelRepresentation,Uint16 vPixelRepresentation)
{
//cerr << "readNewSequenceAttribute(): start: undefinedLengthUNTreatedAsSequence = " << (undefinedLengthUNTreatedAsSequence ? "T" : "F") << endl;
//cerr << "readNewSequenceAttribute(): start: length = " << dec << length << endl;
//cerr << "readNewSequenceAttribute(): start: sequenceOwner = \"" << (sequenceOwner ? sequenceOwner : "--NULL--") << "\"" << endl;
	bool showoffset=verbose;
	SequenceAttribute *a=new SequenceAttribute(stag);
//cerr << "readNewSequenceAttribute(): created empty tag - isEmpty()=" << a->isEmpty() << endl;
//cerr << "readNewSequenceAttribute(): created empty tag - isOne()=" << a->isOne() << endl;
//cerr << "readNewSequenceAttribute(): created empty tag - isMultiple()=" << a->isMultiple() << endl;
	Uint32 startbyteoffset=byteoffset;
//cerr << "readNewSequenceAttribute(): start: startbyteoffset = " << dec << startbyteoffset << endl;
	bool done=false;
	while (!done && (byteoffset < startbyteoffset+length || length == 0xffffffff)) {
//cerr << "readNewSequenceAttribute(): start: byteoffset = " << dec << byteoffset << endl;
		// Expecting Item or SequenceDelimitationItem
		if (verbose && showoffset) dumpOffset(log,byteoffset,stream,length);
		Tag tag;
		(*stream) >> tag;
		if (stream->fail()) {
			errorstream << EMsgDC(TagReadFailed) << endl;
			good_flag=false;
			return 0;
		}
		byteoffset+=4;

		// Always Implicit VR
		Uint32 vl;
		(*stream) >> vl;
		if (stream->fail()) {
			errorstream << EMsgDC(VLReadFailed) << endl;
			good_flag=false;
			return 0;
		}
		byteoffset+=4;
		Uint32 itemstartbyteoffset=byteoffset;

		if (verbose) {
			writebase(tag,"",vl); (*log) << endl;
		}
		
		if (tag == TagFromName(SequenceDelimitationItem)
		 || tag == Tag(0xffe0,0xe0dd)				// GE bug
		) {
			if (tag != TagFromName(SequenceDelimitationItem)) {
//cerr << "Ignoring GE Sequence Delimitation Item encoding bug" << endl;
				errorstream << WMsgDC(IgnoringGESequenceDelimitationItemEncodingBug) << endl;
			}
			if (length != 0xffffffff) {
				errorstream << WMsgDC(UnexpectedSequenceDelimiterInFixedLengthSequence) << endl;
				if (byteoffset < startbyteoffset+length) {
					errorstream << WMsgDC(PrematureEndOfSequence) << endl;
				}
			}
			done=true;	// Force loop exit
			continue;	// Normal exit path for delimited sequences - don't just break here, in case length was specified - need to detect that error
		}
		if (tag == TagFromName(Item)) {
//cerr << "readNewSequenceAttribute(): Item" << endl;
			ReadableAttributeList *item=new ReadableAttributeList();
			Assert(item);
			ElementDictionary *newdict=new ElementDictionary();
			Assert(newdict);
			bool result=item->read(*stream,newdict,log,verbose,vl,false/*metaheadercheck*/,false/*uselengthtoend*/,ignoreoutofordertags,useUSVRForLUTDataIfNotExplicit,undefinedLengthUNTreatedAsSequence/*forceImplicit*/,false/*useStopAtTag*/,Tag(0,0)/*stopAtTag*/,true/*nestedWithinSequence*/,sequenceOwner,fixBitsDuringRead,havePixelRepresentation,vPixelRepresentation);
			const char *e=item->errors();
			if (e) errorstream << e;	// may be warnings
			if (!result) {
				errorstream << EMsgDC(SequenceItemReadFailed) << endl;
//cerr << "readNewSequenceAttribute(): Item error exit" << endl;
				good_flag=false;
				return 0;
			}
			byteoffset+=item->getByteOffset();
			(*a)+=item;
//cerr << "readNewSequenceAttribute(): added item - isEmpty()=" << a->isEmpty() << endl;
//cerr << "readNewSequenceAttribute(): added item - isOne()=" << a->isOne() << endl;
//cerr << "readNewSequenceAttribute(): added item - isMultiple()=" << a->isMultiple() << endl;
			if (vl != 0xffffffff && byteoffset != itemstartbyteoffset+vl) {
				TextOutputStream terr(errorstream.rdbuf());
				stag.write(terr,dictionary);
				errorstream << " - " << EMsgDC(BadSequenceItemValueLength)
					<< " - " << MMsgDC(ActualLength) << " " << hex << (byteoffset-itemstartbyteoffset)
					<< " " << MMsgDC(NotEqualTo) << " " << MMsgDC(SpecifiedLength) << " " << vl << dec
					<< endl;
				good_flag=false;
			}
//cerr << "readNewSequenceAttribute(): Item done" << endl;
		}
		else {
			TextOutputStream terr(errorstream.rdbuf());
			stag.write(terr,dictionary);
			terr << " - " << EMsgDC(BadTagInSequence) << " - got - ";
			tag.write(terr,dictionary);
			terr << " - " << MMsgDC(ExpectingItemOrSequenceDelimiter);
			long bytesToSkip = 0;
			if (length == 0xffffffff) {
				terr << " - " << MMsgDC(SkippingBadTagInsideUndefinedLengthSequence) << endl;
				bytesToSkip = vl;
			}
			else {
				terr << " - " << MMsgDC(SkippingToEndOfEnclosingFixedLengthSequence) << endl;
				bytesToSkip = length - (byteoffset-startbyteoffset);
			}
//cerr << "readNewSequenceAttribute(): bytesToSkip = " << dec << bytesToSkip << endl;
			if (skipBytes(stream,bytesToSkip) != bytesToSkip || stream->fail()) {
				errorstream << EMsgDC(SeekFailed)
					<< " - " << MMsgDC(WhileSkipping)
					<< endl;
				good_flag=false;
				return 0;
			}
			byteoffset+=bytesToSkip;
		}
	}
	if (length != 0xffffffff && byteoffset != startbyteoffset+length) {
		TextOutputStream terr(errorstream.rdbuf());
		stag.write(terr,dictionary);
		errorstream << " - " << EMsgDC(BadSequenceValueLength)
			    << " - " << MMsgDC(ActualLength) << " " << hex << (byteoffset-startbyteoffset)
			    << " " << MMsgDC(NotEqualTo) << " " << MMsgDC(SpecifiedLength) << " " << length << dec
			    << endl;
		good_flag=false;
	}
	//if (stream->fail()) good_flag=false;		// this seems to fail on AMD64 Linux with Siemens PDI 2004 DICOMDIR :(
//cerr << "readNewSequenceAttribute(): done good_flag=" << good_flag << endl;
	//return good_flag ? a : NULL;
	return a;
}

ReadableAttributeList::ReadableAttributeList(void)
	: ErrorsInClass()
{
	stream=0;
	dictionary=0;
	log=0;
	verbose=false;
	byteoffset=0;
}

ReadableAttributeList::~ReadableAttributeList()
{
#ifdef TRACE_DESTRUCTORS
cerr << "ReadableAttributeList::~ReadableAttributeList" << endl;
#endif
}

bool
ReadableAttributeList::read(DicomInputStream& str,ElementDictionary* dict,TextOutputStream* l,bool v,Uint32 length,
	bool metaheadercheck,bool uselengthtoend,bool ignoreoutofordertags,bool useUSVRForLUTDataIfNotExplicit,bool forceImplicit,bool useStopAtTag,Tag stopAtTag,bool nestedWithinSequence,const char *sequenceOwner,bool fixBitsDuringRead,bool havePixelRepresentation,Uint16 vPixelRepresentation)
{
//cerr << "ReadableAttributeList::read - start: forceImplicit = " << (forceImplicit ? "T" : "F") << endl;
//cerr << "ReadableAttributeList::read nestedWithinSequence = " << (nestedWithinSequence ? "T" : "F") << endl;
//cerr << "ReadableAttributeList::read sequenceOwner = \"" << (sequenceOwner ? sequenceOwner : "--NULL--") << "\"" << endl;
//cerr << "ReadableAttributeList::read - fixBitsDuringRead = " << (fixBitsDuringRead ? "T" : "F") << endl;
	stream=&str;
	dictionary=dict;
	log=l;
	verbose=v;

	bool showoffset=v;

	bool treatPixelDataAsOtherNonPixelAttribute=false;	// to handle an illegal GE form in which inside a private GE Private Image Thumbnail Sequence is compressed PixelData even though uncompressed transfer syntax (000426)
	bool allUSSeemToBeByteSwapped=false;				// detect a very unusual and peculiar bug in some images
	Endian forcePixelDataEndian=NoEndian;				// leave it to the transfer syntax, unless peculiar circumstances arise (allUSSeemToBeByteSwapped is true)
	bool donewithmetaheader=!metaheadercheck;
	Uint32 startbyteoffset=byteoffset;
	Uint32 dicomdirposition=0xffffffff;
	bool oldtagvalid=false;
	Tag oldtag;
	bool grouplengthcheck=false;
	Uint32 groupbyteoffsetafterlength=0;	// not used unless grouplengthcheck, but shuts up warning
	Uint32 grouplengthexpected=0;		// not used unless grouplengthcheck, but shuts up warning
	while (stream->peek() != istream::traits_type::eof() && (byteoffset < startbyteoffset+length || length == 0xffffffff)) {
//cerr << "ReadableAttributeList::read - looping (donewithmetaheader is " << (donewithmetaheader ? "true" : "false") << ")" << endl;

//{
//TransferSyntax *ts = stream->getTransferSyntaxInUse();
//cerr << "ReadableAttributeList::read getTransferSyntaxInUse(): uid = " << ts->getUID() << endl;
//cerr << "ReadableAttributeList::read getTransferSyntaxInUse(): description = " << ts->getDescription() << endl;
//cerr << "ReadableAttributeList::read getTransferSyntaxInUse(): encapsulated = " << (ts->getEncapsulated() ? "true" : "false") << endl;
//}

		//unsigned long position=stream->rdbuf()->PubSeekOff(0,ios::cur);
		unsigned long position=(unsigned long)stream->tellg();

		dicomdirposition=position;	// includes preamble and "DICM"

		if (verbose && showoffset) dumpOffset(log,byteoffset,stream,length);
		Tag tag;
		(*stream) >> tag;
		if (stream->fail()) {
			errorstream << WMsgDC(TagReadFailed) << endl;
			//good_flag=false;
			//return false;
			if (verbose && showoffset) (*log) << endl;
			return true;
		}
//{ TextOutputStream terr(cerr.rdbuf()); terr << "ReadableAttributeList::read(): tag = "; tag.write(terr,dictionary); terr << endl; }
		// this next would fail if endian changed and first group was 0x0200 !

		if (!donewithmetaheader && !tag.isMetaheaderGroup()) {
//cerr << "ReadableAttributeList::read(): Changing from metaheader to dataset" << endl;
			{
				// backup and read again in case endian changed ...
//cerr << "ReadableAttributeList::read(): There is a dataset transfer syntax" << endl;
#ifdef CHECKFORSGINATIVECCSEEKBUG
cerr << endl << "Before endian check backup @";
writeZeroPaddedHexNumber(cerr,position,8);
cerr << "(";
writeZeroPaddedHexNumber(cerr,stream->rdbuf()->PubSeekOff(0,ios::cur));
cerr << ")"
     << ": ";
#endif
				stream->seekg(-4l,ios::cur);
				if (stream->fail()) {
					errorstream << EMsgDC(TagReadFailed) << " - " << EMsgDC(SeekFailed) << endl;
					good_flag=false;
					return false;
				}
#ifdef CHECKFORSGINATIVECCSEEKBUG
cerr << endl << "Before endian check backup @";
writeZeroPaddedHexNumber(cerr,position,8);
cerr << "(";
writeZeroPaddedHexNumber(cerr,stream->rdbuf()->PubSeekOff(0,ios::cur));
cerr << ")"
    << ": " << endl;
#endif
				if (!stream->getTransferSyntaxToReadDataSet()) {
					errorstream << EMsgDC(NoTransferSyntaxInMetaHeader) << endl;
					good_flag=false;
					if (verbose && showoffset) (*log) << endl;
					bool setswapped32big;
					stream->guessTransferSyntaxToReadDataSet(setswapped32big);		// always guesses something
				}
				stream->readingDataSet();
				donewithmetaheader=true;
				(*stream) >> tag;
				if (stream->fail()) {
					errorstream << WMsgDC(TagReadFailed) << endl;
					//good_flag=false;
					//return false;
					if (verbose && showoffset) (*log) << endl;
					return true;
				}
			}
		}

		if (oldtagvalid) {
			if (tag < oldtag) {
			//if (tag <= oldtag) {
				errorstream << (ignoreoutofordertags ? WMsgDC(TagsOutOfOrder) : EMsgDC(TagsOutOfOrder)) << endl;
				//good_flag=false;
				if (verbose && showoffset) (*log) << endl;
				if (!ignoreoutofordertags) return false;
			}
			else if (tag == oldtag) {
				TextOutputStream terr(errorstream.rdbuf());
				oldtag.write(terr,dictionary);
				errorstream << EMsgDC(TagsDuplicated) << endl;
				good_flag=false;
				// don't return ... can keep reading
			}
 			if (tag.getGroup() != oldtag.getGroup() && grouplengthcheck) {
				Uint32 actualgrouplength=byteoffset-groupbyteoffsetafterlength;
				if (grouplengthexpected != actualgrouplength) {
					errorstream << WMsgDC(BadGroupLength)
						    << " - " << MMsgDC(Group) << " " << hex << oldtag.getGroup()
						    << " " << MMsgDC(SpecifiedAs) << " " << hex << grouplengthexpected
						    << " " << MMsgDC(Actually) << " " << hex << actualgrouplength
						    << dec << endl;
				}
				grouplengthcheck=false;
			}
		}
		oldtag=tag;
		oldtagvalid=true;

		byteoffset+=4;

		if (useStopAtTag && tag == stopAtTag) {
//cerr << "read: stopped at " << byteoffset << endl;
			return true;
		}
				
		if (tag == TagFromName(ItemDelimitationItem)
		 || tag == Tag(0xffe0,0xe00d)					// GE bug
		) {
//cerr << "ReadableAttributeList::read - ItemDelimitationItem" << endl;
			if (tag != TagFromName(ItemDelimitationItem)) {
				errorstream << WMsgDC(IgnoringGEItemDelimitationItemEncodingBug) << endl;
			}
			// Read and discard value length
			(void)stream->read32();
			if (stream->fail()) {
				errorstream << EMsgDC(VLReadFailed) << endl;
				good_flag=false;
				if (verbose && showoffset) (*log) << endl;
				return false;
			}
			byteoffset+=4;
			if (byteoffset < startbyteoffset+length && length != 0xffffffff) {
				errorstream << WMsgDC(PrematureEndOfItem) << endl;
			}
			length=0;	// Force loop exit
			continue;	// Normal exit path for delimited items
		}

		if (tag == TagFromName(Item)) {
			// this is bad ... there shouldn't be Items here since they should
			// only be found during readNewSequenceAttribute()
			// however, try to work around Philips bug ...
			// Read and discard value length
			(void)stream->read32();
			if (stream->fail()) {
				errorstream << EMsgDC(VLReadFailed) << endl;
				good_flag=false;
				if (verbose && showoffset) (*log) << endl;
				return false;
			}
			byteoffset+=4;
			errorstream << WMsgDC(BadItemInItem) << endl;
			continue;	// let's just ignore it for now
		}

		// need to have owner in dictionary BEFORE calling getValueRepresentation()
		if (tag.isPrivateGroup() && !tag.isLengthElement() && !tag.isPrivateOwner() && !dictionary->hasOwner(tag)) {
//cerr << "ReadableAttributeList::read - tag is private without owner, have sequenceOwner = " << (sequenceOwner ? sequenceOwner : "--NULL--") << "\"" << endl;
			TextOutputStream terr(errorstream.rdbuf());
			tag.write(terr,dictionary);
			errorstream << " - " << WMsgDC(PrivateTagWithoutOwner);
			
			if (sequenceOwner != NULL) {
				errorstream << " - use owner of parent sequence \"" << (sequenceOwner ? sequenceOwner : "--NULL--") << "\"";
				// need to make a simulated private owner that specifies the block used by the current tag
				dictionary->addOwner(Tag(tag.getGroup(),(tag.getElement()>>8)&0xff),sequenceOwner);
			}
			errorstream << endl;
		}
		
		char vre[3];
		bool readAsImplicitRegardless = forceImplicit;
		const char *vr = NULL;
		Uint32 vl = 0;
		bool tryAgain = false;
		Uint32 vrstartbyteoffset = byteoffset;
		do {
			vr=getValueRepresentation(tag,vre,readAsImplicitRegardless);	// readAsImplicitRegardless may be set on return even if forceImplicit was false
			if (stream->fail()) {
				errorstream << EMsgDC(VRReadFailed) << endl;
				good_flag=false;
				if (verbose && showoffset) (*log) << endl;
				return false;
			}

			// Make sure to use the VR for the input, even if overridden by dictionary VR
			// to select the VL encoding method in the input ...

			vl=getValueLength(stream->getTransferSyntaxInUse()->isExplicitVR() ? vre : vr,readAsImplicitRegardless);
			if (stream->fail()) {
				errorstream << EMsgDC(VLReadFailed) << endl;
				good_flag=false;
				if (verbose && showoffset) (*log) << endl;
				return false;
			}
//cerr << "Value length = 0x" << hex << vl << endl;
			if (length != 0xffffffff && vl != 0xffffffff && vl > (byteoffset-startbyteoffset+length)) {
				TextOutputStream terr(errorstream.rdbuf());
				tag.write(terr,dictionary);
				terr << " - ";
//cerr << "Value length exceeds fixed length for reading dataset" << endl;
				if (!tryAgain && readAsImplicitRegardless && stream->getTransferSyntaxInUse()->isExplicitVR()) {
//cerr << "Since readAsImplicitRegardless was set, try reading VL again without forcing implicit" << endl;
					// could be because even though supposed to be implicit VR inside UN sequence, is actually explicit :( (000286)
					// try again without forcing explicit
					terr << EMsgDC(IncorrectExplicitVRInsideFixedLengthSequenceEncodedAsUnknownVR) << endl;
					// backup to start of VR and re-read VR and VL
					long backup = byteoffset-vrstartbyteoffset;
//cerr << "backup bytes = " << dec << (-backup) << endl;
					stream->seekg(-backup,ios::cur);
					if (stream->fail()) {
						tag.write(terr,dictionary);
						terr << EMsgDC(TagReadFailed) << " - " << EMsgDC(SeekFailed) << endl;
						good_flag=false;
						return 0;
					}
					byteoffset=vrstartbyteoffset;
					readAsImplicitRegardless = false;
					tryAgain = true;
					continue;
				}
				else {
					// not sure what to do here - skip to end of fixed length dataset, potentially allowing resumption if inside sequence item ? :(
					// turns out to be better not to skip ... allows later detection of when actual sequence length does not match defined length, though sequence can be successfully read, which sometimes happens
					terr << EMsgDC(ValueLengthExceedsFixedLengthForReadingDataset) << " - " << MMsgDC(Ignoring) << endl;
					//Uint32 skiptoend = byteoffset-startbyteoffset+length;
					////stream->seekg(skiptoend,ios::cur);
					////if (stream->fail()) {
					//if (skipBytes(stream,skiptoend) != skiptoend || stream->fail()) {
					//	tag.write(terr,dictionary);
					//	terr << EMsgDC(SeekFailed)
					//		<< endl;
					//	good_flag=false;
					//	return false;
					//}
					//byteoffset+=skiptoend;
				}
			}
			tryAgain = false;
		} while (tryAgain);
		
		if (ignoreoutofordertags && vl > 0xffff && stream->getTransferSyntaxInUse()->isImplicitVR()) {
			// there are occasions when buggy files will have some elements encoded with explicit rather than implicit VR
			// check here to see if first two bytes are actually a VR ... if so, assume the presence of this bug and repair
			char vrtest[3];
			vrtest[0] = vl & 0xff;			// implicit is always little endian
			vrtest[1] = (vl >> 8) & 0xff;
			vrtest[2] = 0;
			if (isKnownExplicitValueRepresentation(vrtest)) {
				TextOutputStream terr(errorstream.rdbuf());
				tag.write(terr,dictionary);
				terr << " - " << WMsgDC(DataElementEncodedAsExplicitInImplicitVRTransferSyntax) << " - ignoring explicit VR <" << vrtest << "> and trying to recover short VL" << endl;
				vl = (vl >> 16) &0xffff;
				// ignore "explicit" VR, since experience suggests that it will be "wrong" when this bug occurs
			}
		}
		
		if (vl != 0xffffffff & vl%2 != 0) {
			TextOutputStream terr(errorstream.rdbuf());
			tag.write(terr,dictionary);
			terr << " - " << EMsgDC(BadValueLengthNotEven) << " - VL is " << hex << vl << " should be " << (vl+1) << dec << endl;
			good_flag=false;
		}
//cerr << "ReadableAttributeList::read VL  = 0x" << hex << vl << dec << endl;

		Attribute *a=0;

		const char *vrd = dictionary->getValueRepresentation(tag);
		bool treatedUnknownVRAsSequence = isUnknownVR(vr) && (vl == 0xffffffff || (vrd && strncmp(vrd,"SQ",2) == 0));
		if (isSequenceVR(vr) || treatedUnknownVRAsSequence) {
			if (verbose) { writebase(tag,vr,vl); (*log) << endl; }
//cerr << "ReadableAttributeList::read - before readNewSequenceAttribute() good_flag = " << good_flag << endl;
			const char *useSequenceOwner = dictionary->getOwner(tag);
//cerr << "ReadableAttributeList::read - useSequenceOwner from dictionary->getOwner(tag) = \"" << (useSequenceOwner ? useSequenceOwner : "--NULL--") << "\"" << endl;
			if (!useSequenceOwner) {
				useSequenceOwner = sequenceOwner;	// propagate owner of successively nested sequences (really should check group and block, but since this is non-standard anyway ... :( )
//cerr << "ReadableAttributeList::read - useSequenceOwner from parent = \"" << (useSequenceOwner ? useSequenceOwner : "--NULL--") << "\"" << endl;
			}
			a=readNewSequenceAttribute(tag,vl,ignoreoutofordertags,useUSVRForLUTDataIfNotExplicit,
				forceImplicit || treatedUnknownVRAsSequence,		/* once inside UN SQ, always implicit, even if nested */
				useSequenceOwner,									/* in case nested lists are missing owner, propagate owner of the sequence tag itself, if private, or its parent, if missing its own owner */
				fixBitsDuringRead,
				havePixelRepresentation,vPixelRepresentation
				);
//cerr << "ReadableAttributeList::read - back from readNewSequenceAttribute() with a = " << (a == NULL ? "null" : "valid") << endl;
//cerr << "ReadableAttributeList::read - back from readNewSequenceAttribute() with stream->fail() = " << stream->fail() << endl;
//cerr << "ReadableAttributeList::read - back from readNewSequenceAttribute() good_flag = " << good_flag << endl;
			if (!a) {	// hmm; should check good_flag ? :(
				errorstream << EMsgDC(SeqAttrReadFailed) << endl;
				good_flag=false;
				if (verbose && showoffset) (*log) << endl;
				return false;
			}
			// byteoffset already updated by readNewSequenceAttribute()
		}
		else if (tag.isPixelDataElement() && !treatPixelDataAsOtherNonPixelAttribute) {		// treatPixelDataAsOtherNonPixelAttribute is to handle (000426)
//cerr << "ReadableAttributeList::read PixelData" << endl;
			if (isOtherByteOrWordOrUnspecifiedVR(vr)) {
//cerr << "ReadableAttributeList::read OX PixelData" << endl;
				Uint16 vBitsAllocated=AttributeValue(operator[](TagFromName(BitsAllocated)));
				Uint16 vBitsStored=AttributeValue(operator[](TagFromName(BitsStored)));
				Uint16 vHighBit=AttributeValue(operator[](TagFromName(HighBit)));
				if (!vBitsAllocated && vBitsStored) vBitsAllocated=((vBitsStored-1u)/8u+1u)*8u;
				if (!vBitsAllocated) vBitsAllocated=16;
				if (!vBitsStored) vBitsStored=vBitsAllocated;
				if (!vHighBit) vHighBit=vBitsStored-1u;
				if (vHighBit > (vBitsStored-1u)) {
					errorstream << WMsgDC(BadAttributeValue)
						    << " - High Bit = " << vHighBit
						    << " " << MMsgDC(Exceeds) << " " << (vBitsStored-1u)
						    << endl;
				}
				if (vHighBit > (vBitsAllocated-1u)) {
					errorstream << EMsgDC(BadAttributeValue)
						    << " - High Bit = " << vHighBit
						    << " " << MMsgDC(Exceeds) << " " << (vBitsAllocated-1u);
					if (fixBitsDuringRead) {
						errorstream << " " << MMsgDC(Using) << " " << (vBitsAllocated-1u);
					}
					errorstream << endl;
					if (fixBitsDuringRead) {
						vHighBit=vBitsAllocated-1u;
						operator-=(TagFromName(HighBit));
						UnsignedShortAttribute *aHighBit=new UnsignedShortAttribute(TagFromName(HighBit),vHighBit);
						Assert(aHighBit);
						operator+=(aHighBit);
					}
				}
				if (vHighBit < (vBitsStored-1u)) {
					errorstream << EMsgDC(BadAttributeValue)
						    << " - Bits Stored = " << vBitsStored
						    << " " << MMsgDC(Exceeds) << " High Bit " << vHighBit << " + 1";
					if (fixBitsDuringRead) {
						errorstream << " " << MMsgDC(Using) << " " << (vHighBit+1u);
					}
					errorstream << endl;
					if (fixBitsDuringRead) {
						vBitsStored=vHighBit+1u;
						operator-=(TagFromName(BitsStored));
						UnsignedShortAttribute *aBitsStored=new UnsignedShortAttribute(TagFromName(BitsStored),vBitsStored);
						Assert(aBitsStored);
						operator+=(aBitsStored);
					}
				}
				if (vl == 0xffffffff) {
//cerr << "ReadableAttributeList::read Pixel Data has undefined length VL" << endl;
					if (stream->getTransferSyntaxInUse()->isEncapsulated()) {
						a=new OtherUnspecifiedLargeAttributeEncapsulated(
							tag,
							*stream,
							stream->tellg(),
							AttributeValue(operator[](TagFromName(Rows))),
							AttributeValue(operator[](TagFromName(Columns))),
							AttributeValue(operator[](TagFromName(NumberOfFrames)),1),
							AttributeValue(operator[](TagFromName(SamplesPerPixel)),1),
							vBitsAllocated,
							vBitsStored,
							vHighBit
						);
						// skip the blocked data (we don't know its length)...
						skipEncapsulatedData();	// increments byteoffset as it skips
						if (verbose) { a->write(*log,dictionary); (*log) << endl; }
						//byteoffset+=vl;	// already done in skipEncapsulatedData()
					}
					else {
						errorstream << EMsgDC(UndefinedVLForOX) << endl;
						good_flag=false;
						if (verbose && showoffset) (*log) << endl;
						return false;
					}
				}
				else {
//cerr << "ReadableAttributeList::read Pixel Data has defined length VL" << endl;
					if (stream->getTransferSyntaxInUse()->isEncapsulated() && !nestedWithinSequence) {
						errorstream << EMsgDC(IllegalVLForPixelDataInEncapsulatedTransferSyntaxInTopLevelDataset) << endl;
						if (verbose && showoffset) (*log) << endl;
						// do not return false but keep going anyway, and do not negate good_flag, since should be able to read it and no need to fail reading of entire dataset
					}
					{
//cerr << "ReadableAttributeList::read vl=" << hex << vl << dec << endl;
						Uint16 bytesinword = (Uint16)(vr[1] == 'W' ? 2 : (vr[1] == 'B' ? 1 : 0));
						if (vBitsAllocated > 8 && isOtherByteVR(vr) && stream->getTransferSyntaxInUse()->isExplicitVR()) {
								errorstream << EMsgDC(BadValueRepresentation)
								    << " - Pixel Data - VR = OB, Explicit VR, Bits Allocated = " << vBitsAllocated
								    << " " << MMsgDC(Exceeds) << " 8"
								    << endl;
							bytesinword=2;		// force OW to make it usable
						}
						a=new OtherUnspecifiedLargeAttributeCopied(
							tag,
							*stream,
							stream->tellg(),
							AttributeValue(operator[](TagFromName(Rows))),
							AttributeValue(operator[](TagFromName(Columns))),
							AttributeValue(operator[](TagFromName(NumberOfFrames)),1),
							AttributeValue(operator[](TagFromName(SamplesPerPixel)),1),
							bytesinword,
							vBitsAllocated,
							vBitsStored,
							vHighBit,
							vl,
							forcePixelDataEndian
						);
						//stream->seekg(vl,ios::cur);
						//if (stream->fail()) {
						if (skipBytes(stream,vl) != vl || stream->fail()) {
							errorstream << EMsgDC(SeekFailed)
								    << " - while reading unencapsulated Pixel Data"
								    << endl;
							good_flag=false;
							return false;
						}
						if (verbose) { a->write(*log,dictionary); (*log) << endl; }
						byteoffset+=vl;
					}
				}
			}
			else {
//cerr << "ReadableAttributeList::read PixelData not OX" << endl;
				TextOutputStream terr(errorstream.rdbuf());
				tag.write(terr,dictionary);
				terr << EMsgDC(IllegalVRForPixelData) << endl;
				good_flag=false;
				if (verbose && showoffset) (*log) << endl;
				return false;
			}
		}
		else {
//cerr << "ReadableAttributeList::read non-PixelData" << endl;
			if (tag == TagFromName(WaveformData)) {
//cerr << "ReadableAttributeList::read WaveformData" << endl;
				Uint16 vWaveformBitsAllocated=AttributeValue(operator[](TagFromName(WaveformBitsAllocated)));
				if (vWaveformBitsAllocated > 8) {
					if (isOtherByteVR(vr) && stream->getTransferSyntaxInUse()->isExplicitVR()) {
						errorstream << EMsgDC(BadValueRepresentation)
							<< " - Waveform Data - VR = OB, Explicit VR, Waveform Bits Allocated = " << vWaveformBitsAllocated
							<< " " << MMsgDC(Exceeds) << " 8"
							<< endl;
						if (stream->getTransferSyntaxInUse()->isLittleEndian()) {
//cerr << "ReadableAttributeList::forcing WaveformData VR from OB to OW since > 8 bit, explicit VR and little endian" << endl;
							vr="OW";
						}
						// else cannot recover to OW without byte swapping, which is too hard at this point :(
					}
					else {
						if (strcmp(vr,"OX") == 0) {
//cerr << "ReadableAttributeList::using OW for > 8 bit WaveformData in implicit VR" << endl;
							vr="OW";
						}
					}
				}
				else {
					if (strcmp(vr,"OX") == 0) {
//cerr << "ReadableAttributeList::using OB for <= 8 bit WaveformData in implicit VR" << endl;
						vr="OB";
					}
				}
			}
			
			if (isOtherByteOrWordOrUnspecifiedVR(vr)) {
				// PixelData already handled specially
				if (strcmp(vr,"OX") == 0) {
					if (tag == TagFromName(OverlayData)) {
						vr="OW";
					}
					else if (tag == TagFromName(CurveData)) {
						vr="OB";
					}
					else {
						vr="OB";
					}
				}
				if (vl <= LARGESTOTHERDATATOKEEPINMEMORY) {
					if (strcmp(vr,"OB") == 0)
						a=new OtherByteSmallNonPixelAttribute(tag);
					else if (strcmp(vr,"OW") == 0)
						a=new OtherWordSmallNonPixelAttribute(tag);
					else { Assert(0); }
				}
				else {
					if (strcmp(vr,"OB") == 0)
						a=new OtherByteLargeNonPixelAttribute(tag,
							*stream,
							stream->tellg());
					else if (strcmp(vr,"OW") == 0)
						a=new OtherWordLargeNonPixelAttribute(tag,
							*stream,
							stream->tellg());
					else { Assert(0); }
					// the skipping and vl setting is done later in read()
				}
			}
			else if (isOtherLongVR(vr)) {
				//if (vl <= LARGESTOTHERDATATOKEEPINMEMORY) {
				//	a=new OtherLongSmallAttribute(tag);
				//}
				//else {
					a=new OtherLongLargeAttribute(tag,
							*stream,
							stream->tellg());
					// the skipping and vl setting is done later in read()
				//}
			}
			else if (isOtherFloatVR(vr)) {
				//if (vl <= LARGESTOTHERDATATOKEEPINMEMORY) {
				//	a=new OtherFloatSmallAttribute(tag);
				//}
				//else {
					a=new OtherFloatLargeAttribute(tag,
							*stream,
							stream->tellg());
					// the skipping and vl setting is done later in read()
				//}
			}
			else if (isOtherDoubleVR(vr)) {
				//if (vl <= LARGESTOTHERDATATOKEEPINMEMORY) {
				//	a=new OtherDoubleSmallAttribute(tag);
				//}
				//else {
					a=new OtherDoubleLargeAttribute(tag,
							*stream,
							stream->tellg());
					// the skipping and vl setting is done later in read()
				//}
			}
			else if (isUnknownVR(vr)) {
				if (vl <= LARGESTOTHERDATATOKEEPINMEMORY) {
					a=new UnknownSmallAttribute(tag);
				}
				else {
					a=new UnknownLargeAttribute(tag,
							*stream,
							stream->tellg());
					// the skipping and vl setting is done later in read()
				}
			}
			else if (tag == TagFromName(LUTData) && strcmp(vr,"XO") == 0 && useUSVRForLUTDataIfNotExplicit) {
//cerr << "ReadableAttributeList::read(): using US VR for LUT Data" << endl;
				a=new UnsignedShortAttribute(tag);
			}
			else {
				a=newAttribute(vr,tag);
				if (!a) {
					TextOutputStream terr(errorstream.rdbuf());
					tag.write(terr,dictionary);
					errorstream << WMsgDC(VRUnsupported) << " - <" << vr[0] << vr[1] << ">" << endl;
				}
			}

			if (a) {
				if (vl%a->getValueSize() != 0) {
					TextOutputStream terr(errorstream.rdbuf());
					tag.write(terr,dictionary);
					terr << " - " << EMsgDC(VLDoesNotMatchVR) << " - value length = " << dec << vl << " dec - expected multiple of " << a->getValueSize() << " - skipping value length bytes to next data element" << endl;
					good_flag=false;
					if (verbose && showoffset) (*log) << endl;
					// do not give up though - just skip it
					if (skipBytes(stream,vl) != vl || stream->fail()) {
						errorstream << EMsgDC(SeekFailed)
							<< " - while skipping value of length " << dec << vl << " dec"
							<< endl;
						good_flag=false;
						return false;
					}
				}
				else {
					a->read(*stream,vl);
					if (!isLongValueLengthInExplicitValueRepresentation(vr) && a->getValueSize()*a->getVM() >= 65536) {
						TextOutputStream terr(errorstream.rdbuf());
						tag.write(terr,dictionary);
						terr << " - " << WMsgDC(VLExceedsExplicitVRMaximium) << " - value length = " << dec << vl << endl;
					}
				}
				if (stream->fail()) {
					errorstream << EMsgDC(AttributeReadFailed) << endl;
					good_flag=false;
					if (verbose && showoffset) (*log) << endl;
					return false;
				}
				if (verbose) { a->write(*log,dictionary); (*log) << endl; }
#define FIXUPSWAPPEDUS
#ifdef FIXUPSWAPPEDUS
				if (strcmp(a->getVR(),"US") == 0 && a->getVM() == 1) {
					Uint16 value;
					if (a->getValue(0,value)) {
						if (tag == TagFromName(SamplesPerPixel)) {		// check the first US we are likely to encounter
							if (value > 255) {
								allUSSeemToBeByteSwapped=true;
								forcePixelDataEndian=BigEndian;
								errorstream << EMsgDC(BadEncoding) << " - detected swapped bytes of US and pixel data values - fixing" << endl;
							}
						}
						if (allUSSeemToBeByteSwapped) {
							value = ((value&0xff)<<8)|(((value&0xff00)>>8)&0xff);
							a->setValue(0,value);
							if (verbose) { (*log) << "Fixup swapped US VR: "; a->write(*log,dictionary); (*log) << endl; }
						}
					}
				}
#endif

				byteoffset+=vl;
				if (tag == TagFromName(TransferSyntaxUID)) {
					const char *newTransferSyntaxUID = AttributeValue(a);
					if (donewithmetaheader) {
						errorstream << EMsgDC(UnexpectedTransferSyntaxUIDOutsideMetaInformationHeader) << " - ignoring - " << newTransferSyntaxUID << endl;
					}
					else if (newTransferSyntaxUID && strlen(newTransferSyntaxUID) > 0) {
//cerr << "ReadableAttributeList::read() encountered TransferSyntaxUID - before changing getTransferSyntaxInUse()->isEncapsulated() " << (stream->getTransferSyntaxInUse()->isEncapsulated() ? "true" : "false") << endl;
//cerr << "ReadableAttributeList::read() encountered TransferSyntaxUID - setting transfer syntax to read data set to " << newTransferSyntaxUID << endl;
						stream->setTransferSyntaxToReadDataSet(new TransferSyntax(newTransferSyntaxUID));
//cerr << "ReadableAttributeList::read() encountered TransferSyntaxUID - after changing getTransferSyntaxInUse()->isEncapsulated() " << (stream->getTransferSyntaxInUse()->isEncapsulated() ? "true" : "false") << endl;
					}
					else {
						errorstream << EMsgDC(EmptyTransferSyntaxUIDInMetaInformationHeader) << endl;
						stream->setTransferSyntaxToReadDataSet(NULL);
					}
				}
				else if (tag == TagFromName(PixelRepresentation)) {
					// needed to determine VR of XS data elements in implicit VR in data set at this or nested levels (000490) (000491)
					Uint16 value;
					Uint32 length;
					if (!a->getValue(0,value)
					 || a->getVM() != 1) {
						errorstream << EMsgDC(BadPixelRepresentation) << endl;
					}
					else {
						havePixelRepresentation = true;
						vPixelRepresentation = value;
//cerr << "ReadableAttributeList::read() encountered PixelRepresentation - set havePixelRepresentation = " << (havePixelRepresentation ? "true" : "false") << " vPixelRepresentation = " << vPixelRepresentation << endl;
					}
				}
				else if (tag == TagFromName(FileMetaInformationVersion)) {
					// check this is correct here ... easier than elsewhere
					// and this is the only place an OB is used like this
					const unsigned char *value;
					Uint32 length;
					if (!a->isOtherByteNonPixel()
					 || !a->getValue(value,length)
					 || length != 2
					 || *value != 0x00
					 || *(value+1) != 0x01) {
						errorstream << WMsgDC(BadFileMetaInformationVersion) << endl;
					}
				}
				else if (tag.isLengthElement()) {
					// Retired except for metaheader, but if you've got it check it
					grouplengthexpected=Uint32(AttributeValue(a));
					groupbyteoffsetafterlength=byteoffset;
					grouplengthcheck=true;
				}
				else if (tag == TagFromName(LengthToEnd)
					&& vl != 0 && length == 0xffffffff) {
					// Retired, but if you've got it use it
					if (uselengthtoend) length=byteoffset-startbyteoffset+Uint32(AttributeValue(a));
				}
				else if (tag.isPrivateGroup()) {
					if (tag.isPrivateOwner()) {
//cerr << "ReadableAttributeList::read adding owner" << endl;
						if (tag.getElement() < 0x0010) {
							TextOutputStream terr(errorstream.rdbuf());
							tag.write(terr,dictionary);
							errorstream << " - " << EMsgDC(BadPrivateOwner) << " - element must be greater than or equal to 0x0010" << endl;
						}
						char *s=AttributeValue(a);
						if (s && *s) 
							dictionary->addOwner(tag,s);
						else {
							TextOutputStream terr(errorstream.rdbuf());
							tag.write(terr,dictionary);
							errorstream << " - " << WMsgDC(BadPrivateOwner) << " - empty value" << endl;
						}
						if (s) delete[] s;
					}
					// PrivateTagWithoutOwner is handled earlier when establishing dictionary VR and need to possibly inherit parent sequence owner if owner missing within item dataset
					//else {
					//	if (!dictionary->hasOwner(tag)) {
					//		TextOutputStream terr(errorstream.rdbuf());
					//		tag.write(terr,dictionary);
					//		errorstream << " - " << WMsgDC(PrivateTagWithoutOwner) << endl;
					//	}
					//}
					else if (tag.isPrivateTag()) {
						const char *useOwner = dictionary->getOwner(tag);
						// handle an illegal GE form in which inside a private GE Private Image Thumbnail Sequence is compressed PixelData even though uncompressed transfer syntax (000426)
						if (tag.getGroup() == 0x7fd1 && (tag.getElement() & 0x00ff) == 0x0010 && useOwner != NULL && strcmp(useOwner,"GEIIS ")) {	// (0x7fd1,0x1010) Compression Type; note the space in the owner check
							// Need to actually check the value, since when this is used, there is one inside the GE Private Image Thumbnail Sequence with a non-zero value
							// and one in the top level dataset with a zero value, which shoudl not affect how top level Pixel Data is handled ...
							Uint32 geGompressionType =AttributeValue(a);
							treatPixelDataAsOtherNonPixelAttribute = geGompressionType != 0;
//cerr << "ReadableAttributeList::read - tag is private GE Compression Type, value " << geGompressionType << "; will " << (treatPixelDataAsOtherNonPixelAttribute ? "" : "not ") << "treat PixelData as ordinary tag" << endl;
						}
					}
				}
			}
			else {
				TextOutputStream terr(errorstream.rdbuf());
				tag.write(terr,dictionary);
				errorstream << WMsgDC(UnrecognizedOrUnsupportedTag) << endl;
				if (verbose && showoffset) (*log) << endl;
				//stream->seekg(vl,ios::cur);
				//if (stream->fail()) {
				if (skipBytes(stream,vl) != vl || stream->fail()) {
					errorstream << EMsgDC(SeekFailed)
						<< " - while skipping remainder of "
						<< MMsgDC(UnrecognizedOrUnsupportedTag)
						<< endl;
					good_flag=false;
					return false;
				}
				byteoffset+=vl;
			}
		}

		if (a) {
			a->setByteOffset(dicomdirposition);
			operator+=(a);
		}

		// Need private owner & metaheader stuff here
	}
//cerr << "ReadableAttributeList::read - falling out at end byteoffset = " << hex << byteoffset << dec << endl;
//cerr << "ReadableAttributeList::read - falling out at end startbyteoffset = " << hex << startbyteoffset << dec << endl;
//cerr << "ReadableAttributeList::read - falling out at end length = " << hex << length << dec << endl;
//cerr << "ReadableAttributeList::read - falling out at end startbyteoffset+length = " << hex << (length == 0xffffffff ? 0xffffffff : (startbyteoffset+length)) << dec << endl;
//cerr << "ReadableAttributeList::read - falling out at end stream->fail() = " << stream->fail() << endl;
	TransferSyntax *dts=stream->getTransferSyntaxToReadDataSet();
	return ((dts && dts->isExplicitVR()) || setValueRepresentationForThisList(havePixelRepresentation,vPixelRepresentation))
	    /*&& !stream->fail()*/;		// seems to fail inappropriately on AMD 64 Linux with Siemens PDI 2004 demo DICOMDIR :(
}


static const char *CopyrightIdentifier(void) { return "@(#)attrtypo.cc Copyright (c) 1993-2015, David A. Clunie DBA PixelMed Publishing. All rights reserved."; }
#include "attr.h"
#include "attrtypo.h"
#include "attrtag.h"
#include "elmdict.h"
#include "srcsink.h"
#include "convtype.h"
#include "tobyte.h"
#include "frombyte.h"

OtherNonPixelAttribute::OtherNonPixelAttribute(Tag t) : Attribute(t)
{
	lengthinbytes=0;
}

OtherNonPixelAttribute:: ~OtherNonPixelAttribute(void)
{
}

OtherByteSmallNonPixelAttributeBase::OtherByteSmallNonPixelAttributeBase(Tag t)
	 : OtherNonPixelAttribute(t)
{
	data=0;
}

OtherByteSmallNonPixelAttributeBase:: ~OtherByteSmallNonPixelAttributeBase(void)
{
	if (data) delete[] data;
}

BinaryOutputStream&
OtherByteSmallNonPixelAttributeBase::writeValues(BinaryOutputStream& stream)
{
	if (lengthinbytes) {
		Assert(data);
		stream.write((char *)data,size_t(lengthinbytes));
	}
	return stream;
}

TextOutputStream&
OtherByteSmallNonPixelAttributeBase::writeData(TextOutputStream& stream)
{
	Uint32 i = lengthinbytes;
	unsigned char *ptr = data;
	while (i > 0) {
		writeZeroPaddedHexNumber(stream,unsigned(*ptr++),2);
		--i;
		if (i > 0) {
			stream << ",";
			if (i%16 == 0) stream << "\n\t";
		}
	}
	return stream;
}

TextOutputStream&
OtherByteSmallNonPixelAttributeBase::write(TextOutputStream& stream,ElementDictionary *dict,bool verbose,bool showUsedAndIE)
{
	Attribute::writeBase(stream,dict,verbose,showUsedAndIE);
	Tag t = getTag();
	if (dict->isRenderAsString(t)) {
		stream << "<";
		stream << data;
		if (strlen((const char *)data)%2) stream << ' ';		// pad for consistency with string attribute writes
		stream << "> ";
	}
	else {
		stream << "[";
		writeData(stream);
		stream << "] ";
	}
	return stream;
}

BinaryInputStream&
OtherByteSmallNonPixelAttributeBase::read(BinaryInputStream& stream,Uint32 length)
{
	Assert(lengthinbytes == 0);
	Assert(data == 0);
	Assert(length%2 == 0);	// DICOM likes even things
	data=new unsigned char[length];
	Assert(data);
	if (length) stream.read((char *)data,size_t(length));
	lengthinbytes=length;
	return stream;
}

bool
OtherByteSmallNonPixelAttributeBase::getValue(const unsigned char * & rvalue,Uint32 &rlength) const
{
	rlength=lengthinbytes;
	rvalue=data;
	return true;	// ? should this be false if zero length ? :(
}

void
OtherByteSmallNonPixelAttributeBase::setValue(const unsigned char *values,Uint32 length)
{
	Assert(lengthinbytes == 0);
	Assert(data == 0);
	Assert(length%2 == 0);	// DICOM likes even things
	data=new unsigned char[length];
	Assert(data);
	memcpy(data,values,size_t(length));
	lengthinbytes=length;
}

OtherWordSmallNonPixelAttributeBase::OtherWordSmallNonPixelAttributeBase(Tag t)
	 : OtherNonPixelAttribute(t)
{
	data=0;
}

OtherWordSmallNonPixelAttributeBase:: ~OtherWordSmallNonPixelAttributeBase(void)
{
	if (data) delete[] data;
}

BinaryOutputStream&
OtherWordSmallNonPixelAttributeBase::writeValues(BinaryOutputStream& stream)
{
	if (lengthinbytes) {
		Assert(data);
		Assert(lengthinbytes%2 == 0);
		Uint32 lengthinwords=lengthinbytes/2;
		Uint16 *ptr=data;
		while (lengthinwords--) stream << *ptr++;
	}
	return stream;
}

TextOutputStream&
OtherWordSmallNonPixelAttributeBase::writeData(TextOutputStream& stream)
{
	Assert(lengthinbytes%2 == 0);
	Uint32 i = lengthinbytes/2;
	Uint16 *ptr = data;
	while (i > 0) {
		writeZeroPaddedHexNumber(stream,*ptr++,4);
		--i;
		if (i > 0) {
			stream << ",";
			if (i%8 == 0) stream << "\n\t";
		}
	}
	return stream;
}

TextOutputStream&
OtherWordSmallNonPixelAttributeBase::write(TextOutputStream& stream,ElementDictionary *dict,bool verbose,bool showUsedAndIE)
{
	Attribute::writeBase(stream,dict,verbose,showUsedAndIE);
	stream << "[";
	writeData(stream);
	stream << "] ";
	return stream;
}

BinaryInputStream&
OtherWordSmallNonPixelAttributeBase::read(BinaryInputStream& stream,Uint32 length)
{
	Assert(lengthinbytes == 0);
	Assert(data == 0);
	Assert(length%2 == 0);	// DICOM likes even things
	Uint32 lengthinwords=length/2;
	if (lengthinwords) {
		data=new Uint16[lengthinwords];
		Assert(data);
		Uint32 i=lengthinwords;
		Uint16 *ptr=data;
		while (i--) stream >> *ptr++;
		lengthinbytes=length;
	}
	return stream;
}

bool
OtherWordSmallNonPixelAttributeBase::getValue(const Uint16 * & rvalue,Uint32 &rlengthinwords) const
{
	Assert(lengthinbytes%2 == 0);
	rlengthinwords=lengthinbytes/2;
	rvalue=data;
	return true;	// ? should this be false if zero length ? :(
}

void
OtherWordSmallNonPixelAttributeBase::setValue(const Uint16 *values,Uint32 lengthinwords)
{
	Assert(lengthinbytes == 0);
	Assert(data == 0);
	if (lengthinwords) {
		data=new Uint16[lengthinwords];
		Assert(data);
		Uint32 i=lengthinwords;
		Uint16 *ptr=data;
		while (i--) *ptr++=*values++;
		lengthinbytes=lengthinwords*2;
	}
}

OtherByteLargeNonPixelAttributeBase::OtherByteLargeNonPixelAttributeBase(Tag t,
		BinaryInputStream &stream,OurStreamPos pos,OurStreamPos length)
	 : OtherNonPixelAttribute(t)
{
	srcstream=&stream;
	srcpos=pos;
	srclength=length;
	hasSrclength=true;
	lengthinbytes=length;
	if (lengthinbytes%2 != 0) {
		++lengthinbytes;
	}
	
	Assert(srcstream);
}

OtherByteLargeNonPixelAttributeBase::OtherByteLargeNonPixelAttributeBase(Tag t,
		BinaryInputStream &stream,OurStreamPos pos)
	 : OtherNonPixelAttribute(t)
{
	srcstream=&stream;
	srcpos=pos;
	hasSrclength=false;

	Assert(srcstream);
}

OtherByteLargeNonPixelAttributeBase::~OtherByteLargeNonPixelAttributeBase()
{
}

BinaryOutputStream&
OtherByteLargeNonPixelAttributeBase::writeValues(BinaryOutputStream& dststream)
{
	srcstream->clear();
	srcstream->seekg(srcpos);
	Uint32 lengthToCopy = hasSrclength ? Uint32(srclength) : lengthinbytes;
	if (srcstream->good()) {
		Source<unsigned char> srcinput    (*srcstream,1024,lengthToCopy);
		Sink<unsigned char>   output      (dststream,srcinput);
		output.write(lengthToCopy);
	}
	Uint32 pad = lengthinbytes - lengthToCopy;
	while (pad-- > 0) {
//cerr << "OtherByteLargeNonPixelAttributeBase::writeValues: writing pad byte" << endl;
		dststream.put(0);
	}
	return dststream;
}

TextOutputStream&
OtherByteLargeNonPixelAttributeBase::writeData(TextOutputStream& stream)
{
	stream << "...";
	return stream;
}

TextOutputStream&
OtherByteLargeNonPixelAttributeBase::write(TextOutputStream& stream,ElementDictionary *dict,bool verbose,bool showUsedAndIE)
{
	Attribute::writeBase(stream,dict,verbose,showUsedAndIE);
	stream << "[";
	writeData(stream);
	stream << "] ";
	return stream;
}

BinaryInputStream&
OtherByteLargeNonPixelAttributeBase::read(BinaryInputStream& stream,Uint32 vl)
{
	Assert(&stream == srcstream);
	stream.seekg(vl,ios::cur);
	lengthinbytes=vl;
	return stream;
}

bool
OtherByteLargeNonPixelAttributeBase::getValue(const unsigned char * &,Uint32 &) const
{
	Assert(0);
	return false;
}

void
OtherByteLargeNonPixelAttributeBase::setValue(const unsigned char *,Uint32 )
{
	Assert(0);
}


OtherWordLargeNonPixelAttributeBase::OtherWordLargeNonPixelAttributeBase(Tag t,
		BinaryInputStream &stream,OurStreamPos pos)
	 : OtherNonPixelAttribute(t)
{
	srcstream=&stream;
	Assert(srcstream);
	srcpos=pos;
	srcendian=srcstream->getEndian();
	Assert(srcendian != NoEndian);
	Assert(srcendian != ByteEndian);
}

OtherWordLargeNonPixelAttributeBase::~OtherWordLargeNonPixelAttributeBase()
{
}

BinaryOutputStream&
OtherWordLargeNonPixelAttributeBase::writeValues(BinaryOutputStream& dststream)
{
	// use current dststream endian, not getTransferSyntaxToReadDataSet()->getEndian()
	Endian dstendian=dststream.getEndian();
	Assert(dstendian != NoEndian);
	Assert(dstendian != ByteEndian);

	Assert(getVL()%2 == 0);

	srcstream->clear();
	srcstream->seekg(srcpos);
	if (srcstream->good()) {
		Source<unsigned char> srcinput    (*srcstream,1024,getVL());
		ConvertByteToUint16   srcfrombyte (srcinput,srcendian);
		ConvertUint16ToByte   tobyte      (srcfrombyte,dstendian);
		Sink<unsigned char>   output      (dststream,tobyte);
		output.write(getVL());
	}
	return dststream;
}

TextOutputStream&
OtherWordLargeNonPixelAttributeBase::writeData(TextOutputStream& stream)
{
	stream << "...";
	return stream;
}

TextOutputStream&
OtherWordLargeNonPixelAttributeBase::write(TextOutputStream& stream,ElementDictionary *dict,bool verbose,bool showUsedAndIE)
{
	Attribute::writeBase(stream,dict,verbose,showUsedAndIE);
	stream << "[";
	writeData(stream);
	stream << "] ";
	return stream;
}

BinaryInputStream&
OtherWordLargeNonPixelAttributeBase::read(BinaryInputStream& stream,Uint32 vl)
{
	Assert(&stream == srcstream);
	stream.seekg(vl,ios::cur);
	lengthinbytes=vl;
	return stream;
}

bool
OtherWordLargeNonPixelAttributeBase::getValue(const Uint16 * &,Uint32 &) const
{
	Assert(0);
	return false;
}

void
OtherWordLargeNonPixelAttributeBase::setValue(const Uint16 *,Uint32 )
{
	Assert(0);
}

/* ********************* OL VR Attributes ********************* */

OtherLongLargeAttributeBase::OtherLongLargeAttributeBase(Tag t,
		BinaryInputStream &stream,OurStreamPos pos)
	 : OtherNonPixelAttribute(t)
{
	srcstream=&stream;
	Assert(srcstream);
	srcpos=pos;
	srcendian=srcstream->getEndian();
	Assert(srcendian != NoEndian);
	Assert(srcendian != ByteEndian);
}

OtherLongLargeAttributeBase::~OtherLongLargeAttributeBase()
{
}

BinaryOutputStream&
OtherLongLargeAttributeBase::writeValues(BinaryOutputStream& dststream)
{
	// use current dststream endian, not getTransferSyntaxToReadDataSet()->getEndian()
	Endian dstendian=dststream.getEndian();
	Assert(dstendian != NoEndian);
	Assert(dstendian != ByteEndian);

	Assert(getVL()%4 == 0);

	srcstream->clear();
	srcstream->seekg(srcpos);
	if (srcstream->good()) {
		// we don't have a ConvertByteToUint32, analogous to the ConvertByteToUint16 used for OW, so do it like we do for OF and OD ...
		Source<unsigned char> srcinput (*srcstream,1024,getVL());
		if (dstendian != srcendian) {
			ConvertSourceToSinkSwapping<unsigned char,unsigned char,4> swab(srcinput);
			Sink<unsigned char> output(dststream,swab);
			output.write(getVL());
		}
		else {
			Sink<unsigned char> output(dststream,srcinput);
			output.write(getVL());
		}
	}
	return dststream;
}

TextOutputStream&
OtherLongLargeAttributeBase::writeData(TextOutputStream& stream)
{
	stream << "...";
	return stream;
}

TextOutputStream&
OtherLongLargeAttributeBase::write(TextOutputStream& stream,ElementDictionary *dict,bool verbose,bool showUsedAndIE)
{
	Attribute::writeBase(stream,dict,verbose,showUsedAndIE);
	stream << "[";
	writeData(stream);
	stream << "] ";
	return stream;
}

BinaryInputStream&
OtherLongLargeAttributeBase::read(BinaryInputStream& stream,Uint32 vl)
{
	Assert(&stream == srcstream);
	stream.seekg(vl,ios::cur);
	lengthinbytes=vl;
	return stream;
}

bool
OtherLongLargeAttributeBase::getValue(const Uint16 * &,Uint32 &) const
{
	Assert(0);
	return false;
}

void
OtherLongLargeAttributeBase::setValue(const Uint16 *,Uint32 )
{
	Assert(0);
}

/* ********************* OF VR Attributes ********************* */

OtherFloatLargeAttributeBase::OtherFloatLargeAttributeBase(Tag t,
		BinaryInputStream &stream,OurStreamPos pos)
	 : OtherNonPixelAttribute(t)
{
	srcstream=&stream;
	Assert(srcstream);
	srcpos=pos;
	srcendian=srcstream->getEndian();
	Assert(srcendian != NoEndian);
	Assert(srcendian != ByteEndian);
}

OtherFloatLargeAttributeBase::~OtherFloatLargeAttributeBase()
{
}

BinaryOutputStream&
OtherFloatLargeAttributeBase::writeValues(BinaryOutputStream& dststream)
{
	// use current dststream endian, not getTransferSyntaxToReadDataSet()->getEndian()
	Endian dstendian=dststream.getEndian();
	Assert(dstendian != NoEndian);
	Assert(dstendian != ByteEndian);

	Assert(getVL()%4 == 0);

	srcstream->clear();
	srcstream->seekg(srcpos);
	if (srcstream->good()) {
		Source<unsigned char> srcinput (*srcstream,1024,getVL());
		if (dstendian != srcendian) {
			ConvertSourceToSinkSwapping<unsigned char,unsigned char,4> swab(srcinput);
			Sink<unsigned char> output(dststream,swab);
			output.write(getVL());
		}
		else {
			Sink<unsigned char> output(dststream,srcinput);
			output.write(getVL());
		}
	}
	return dststream;
}

TextOutputStream&
OtherFloatLargeAttributeBase::writeData(TextOutputStream& stream)
{
	stream << "...";
	return stream;
}

TextOutputStream&
OtherFloatLargeAttributeBase::write(TextOutputStream& stream,ElementDictionary *dict,bool verbose,bool showUsedAndIE)
{
	Attribute::writeBase(stream,dict,verbose,showUsedAndIE);
	stream << "[";
	writeData(stream);
	stream << "] ";
	return stream;
}

BinaryInputStream&
OtherFloatLargeAttributeBase::read(BinaryInputStream& stream,Uint32 vl)
{
	Assert(&stream == srcstream);
	stream.seekg(vl,ios::cur);
	lengthinbytes=vl;
	return stream;
}

bool
OtherFloatLargeAttributeBase::getValue(const unsigned char * &,Uint32 &) const
{
	Assert(0);
	return false;
}

void
OtherFloatLargeAttributeBase::setValue(const unsigned char *,Uint32 )
{
	Assert(0);
}


/* ********************* OD VR Attributes ********************* */

OtherDoubleLargeAttributeBase::OtherDoubleLargeAttributeBase(Tag t,
		BinaryInputStream &stream,OurStreamPos pos)
	 : OtherNonPixelAttribute(t)
{
	srcstream=&stream;
	Assert(srcstream);
	srcpos=pos;
	srcendian=srcstream->getEndian();
	Assert(srcendian != NoEndian);
	Assert(srcendian != ByteEndian);
}

OtherDoubleLargeAttributeBase::~OtherDoubleLargeAttributeBase()
{
}

BinaryOutputStream&
OtherDoubleLargeAttributeBase::writeValues(BinaryOutputStream& dststream)
{
	// use current dststream endian, not getTransferSyntaxToReadDataSet()->getEndian()
	Endian dstendian=dststream.getEndian();
	Assert(dstendian != NoEndian);
	Assert(dstendian != ByteEndian);

	Assert(getVL()%8 == 0);
	
	srcstream->clear();
	srcstream->seekg(srcpos);
	if (srcstream->good()) {
		Source<unsigned char> srcinput (*srcstream,1024,getVL());
		if (dstendian != srcendian) {
			ConvertSourceToSinkSwapping<unsigned char,unsigned char,8> swab(srcinput);
			Sink<unsigned char> output(dststream,swab);
			output.write(getVL());
		}
		else {
			Sink<unsigned char> output(dststream,srcinput);
			output.write(getVL());
		}
	}
	return dststream;
}

TextOutputStream&
OtherDoubleLargeAttributeBase::writeData(TextOutputStream& stream)
{
	stream << "...";
	return stream;
}

TextOutputStream&
OtherDoubleLargeAttributeBase::write(TextOutputStream& stream,ElementDictionary *dict,bool verbose,bool showUsedAndIE)
{
	Attribute::writeBase(stream,dict,verbose,showUsedAndIE);
	stream << "[";
	writeData(stream);
	stream << "] ";
	return stream;
}

BinaryInputStream&
OtherDoubleLargeAttributeBase::read(BinaryInputStream& stream,Uint32 vl)
{
	Assert(&stream == srcstream);
	stream.seekg(vl,ios::cur);
	lengthinbytes=vl;
	return stream;
}

bool
OtherDoubleLargeAttributeBase::getValue(const unsigned char * &,Uint32 &) const
{
	Assert(0);
	return false;
}

void
OtherDoubleLargeAttributeBase::setValue(const unsigned char *,Uint32 )
{
	Assert(0);
}

/* ********************* Unknown VR Attributes ********************* */

UnknownSmallAttributeBase::UnknownSmallAttributeBase(Tag t)
	 : OtherNonPixelAttribute(t)
{
	data=0;
}

UnknownSmallAttributeBase:: ~UnknownSmallAttributeBase(void)
{
	if (data) delete[] data;
}

BinaryOutputStream&
UnknownSmallAttributeBase::writeValues(BinaryOutputStream& stream)
{
	if (lengthinbytes) {
		Assert(data);
		stream.write((char *)data,size_t(lengthinbytes));
	}
	return stream;
}

TextOutputStream&
UnknownSmallAttributeBase::writeData(TextOutputStream& stream)
{
	Uint32 i = lengthinbytes;
	unsigned char *ptr = data;
	while (i > 0) {
		writeZeroPaddedHexNumber(stream,unsigned(*ptr++),2);
		--i;
		if (i > 0) {
			stream << ",";
			if (i%16 == 0) stream << "\n\t";
		}
	}
	return stream;
}

TextOutputStream&
UnknownSmallAttributeBase::write(TextOutputStream& stream,ElementDictionary *dict,bool verbose,bool showUsedAndIE)
{
	Attribute::writeBase(stream,dict,verbose,showUsedAndIE);
	stream << "[";
	writeData(stream);
	stream << "] ";
	return stream;
}

BinaryInputStream&
UnknownSmallAttributeBase::read(BinaryInputStream& stream,Uint32 length)
{
	Assert(lengthinbytes == 0);
	Assert(data == 0);
	//Assert(length%2 == 0);	// DICOM likes even things
	data=new unsigned char[length];
	Assert(data);
	if (length) stream.read((char *)data,size_t(length));
	lengthinbytes=length;
	return stream;
}

bool
UnknownSmallAttributeBase::getValue(const unsigned char * & rvalue,Uint32 &rlength) const
{
	rlength=lengthinbytes;
	rvalue=data;
	return true;	// ? should this be false if zero length ? :(
}

void
UnknownSmallAttributeBase::setValue(const unsigned char *values,Uint32 length)
{
	Assert(lengthinbytes == 0);
	Assert(data == 0);
	Assert(length%2 == 0);	// DICOM likes even things
	data=new unsigned char[length];
	Assert(data);
	memcpy(data,values,size_t(length));
	lengthinbytes=length;
}

void
UnknownSmallAttributeBase::addValues(const char *values)
{
	if (values) {
		int length=strlen(values);
		if (length) {
			Uint32 padcount = (lengthinbytes+length)%2;	// DICOM likes even things
			Uint32 newlength = lengthinbytes+length+padcount;
			unsigned char *newdata = new unsigned char[newlength];
			Assert(newdata);
			if (lengthinbytes) {
				memcpy(newdata,data,size_t(lengthinbytes));
			}
			memcpy(newdata+lengthinbytes,values,size_t(length));
			if (padcount) newdata[newlength-1]=0;
			data=newdata;
			lengthinbytes=lengthinbytes+length+padcount;
		}
	}
}

UnknownLargeAttributeBase::UnknownLargeAttributeBase(Tag t,
		BinaryInputStream &stream,OurStreamPos pos)
	 : OtherNonPixelAttribute(t)
{
	srcstream=&stream;
	srcpos=pos;

	Assert(srcstream);
}

UnknownLargeAttributeBase::~UnknownLargeAttributeBase()
{
}

BinaryOutputStream&
UnknownLargeAttributeBase::writeValues(BinaryOutputStream& dststream)
{
	srcstream->clear();
	srcstream->seekg(srcpos);
	if (srcstream->good()) {
		Source<unsigned char> srcinput    (*srcstream,1024,getVL());
		Sink<unsigned char>   output      (dststream,srcinput);
		output.write(getVL());
	}
	return dststream;
}

TextOutputStream&
UnknownLargeAttributeBase::writeData(TextOutputStream& stream)
{
	stream << "...";
	return stream;
}

TextOutputStream&
UnknownLargeAttributeBase::write(TextOutputStream& stream,ElementDictionary *dict,bool verbose,bool showUsedAndIE)
{
	Attribute::writeBase(stream,dict,verbose,showUsedAndIE);
	stream << "[";
	writeData(stream);
	stream << "] ";
	return stream;
}

BinaryInputStream&
UnknownLargeAttributeBase::read(BinaryInputStream& stream,Uint32 vl)
{
	Assert(&stream == srcstream);
	stream.seekg(vl,ios::cur);
	lengthinbytes=vl;
	return stream;
}

bool
UnknownLargeAttributeBase::getValue(const unsigned char * &,Uint32 &) const
{
	Assert(0);
	return false;
}

void
UnknownLargeAttributeBase::setValue(const unsigned char *,Uint32 )
{
	Assert(0);
}


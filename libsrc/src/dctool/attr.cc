static const char *CopyrightIdentifier(void) { return "@(#)attr.cc Copyright (c) 1993-2021, David A. Clunie DBA PixelMed Publishing. All rights reserved."; }
#include "attr.h"
// the following are for buildFullPathInInstanceToCurrentAttribute() only ...
#include "attrlist.h"
#include "attrseq.h"
#include "elmdict.h"
#include "listsimp.h"
#include "strtype.h"

Attribute::Attribute(Tag t)
{
	tag=t;
	byteoffset=0xffffffff;
	used=false;
	ie = UnknownIE;
	parentSequenceAttribute = NULL;
	parentAttributeList = NULL;
}

Attribute::~Attribute()
{
#ifdef TRACE_DESTRUCTORS
cerr << "Attribute::~Attribute" << endl;
#endif
}

void
Attribute::setByteOffset(Uint32 offset)
{
//cerr << "Attribute::setByteOffset to " << hex << offset << dec << endl;
	byteoffset=offset;
}

Uint32
Attribute::getByteOffset(void) const
{
//cerr << "Attribute::getByteOffset is " << hex << byteoffset << dec << endl;
//	Assert(byteoffset != 0xffffffff);
	return byteoffset;
}

TextOutputStream&
Attribute::writeBase(TextOutputStream& stream,ElementDictionary *dict,bool verbose,bool showUsedAndIE)
{
	if (verbose) {
		stream << "@";
		writeZeroPaddedHexNumber(stream,byteoffset,8);
		stream << ": ";
	}
	tag.write(stream,dict);
	stream << "\t VR=<" << getVR() << ">  ";
	stream << " VL=<";
	writeZeroPaddedHexNumber(stream,getVL(),4);
	stream << ">  " << flush;
	if (showUsedAndIE) {
		stream << "Used=<" << (isUsed() ? "T" : "F") << "> ";
		stream << "IE=<" << describeInformationEntity(getInformationEntity()) << "> ";
	}
	return stream;
}

BinaryOutputStream&
Attribute::writeBase(BinaryOutputStream& stream)
{
	Assert(0);
	// this routine is probably never used, but just in case ...
	// assume default Implicit VR
	stream << tag << getVL();
	return stream;
}

DicomOutputStream&
Attribute::writeBase(DicomOutputStream& stream)
{
	// NB. Changing transfer syntaxes is caller's responsibility
	stream << tag;
	const char *vr = getVR();
	Assert(stream.getTransferSyntaxInUse());
	if (stream.getTransferSyntaxInUse()->isExplicitVR()) {
		Assert(vr);
		Assert(strlen(vr) == 2);
//cerr << "VR=" << vr << endl;
		if (vr[0]=='X') {			// we have a problem ... an internal unspecified pseudo-VR is present ... need to override it
			if (vr[1]=='S') {		// XS is choice between US or SS
//cerr << "Overriding XS with US during write" << endl;
				vr="US";
			}
			else if (vr[1]=='O') {		// XO is choice between US or SS or OW
//cerr << "Overriding XO with OW during write" << endl;
				vr="OW";
			}
		}
		else if (vr[0]=='O' && vr[1]=='X') {	// we have a problem ... an internal unspecified pseudo-VR is present ... need to override it
//cerr << "Overriding OX with OW during write" << endl;
			vr="OW";
		}
		stream << vr;
		if ((vr[0]=='O' && (vr[1]=='B' || vr[1]=='D' || vr[1]=='F' || vr[1]=='L' || vr[1]=='W' || vr[1]=='X'))
	 	 || (vr[0]=='S' &&  vr[1]=='Q')
	 	 || (vr[0]=='U' && (vr[1]=='C' || vr[1]=='N' || vr[1]=='R' || vr[1]=='T')))
		{
			// Explicit OB,OD,OF,OL,OW,OX,SQ,UC,UN,UR,UT
			stream << Uint16(0) << getVL();
		}
		else {
			stream << (Uint16)getVL();
		}
	}
	else {	// Implicit VR
		stream << getVL();
	}
	return stream;
}

BinaryOutputStream&
Attribute::writeData(BinaryOutputStream& stream)
{
	Assert(0);
	return stream;
}

TextOutputStream&
Attribute::writeData(TextOutputStream& stream)
{
	Assert(0);
	return stream;
}

OtherUnspecifiedLargeAttributeBase *
Attribute::castToOtherData(void)
{
	Assert(0);
	return 0;
}

void
Attribute::setOutputEncoding(
		TransferSyntax *,
		unsigned short,
		unsigned short,
		unsigned short,
		unsigned short,
		Uint32)
{
	// ignore, since may be set for PixelData that we are treating as ordinary attribute, e.g., illegal GE Private Thumbnails (000426)
}

bool
Attribute::getValue(unsigned,Uint16&) const
{
	return false;
}

bool
Attribute::getValue(unsigned,Uint32&) const
{
	return false;
}

bool
Attribute::getValue(unsigned,Int16&) const
{
	return false;
}

bool
Attribute::getValue(unsigned,Int32&) const
{
	return false;
}

bool
Attribute::getValue(unsigned,Float32&) const
{
	return false;
}

bool
Attribute::getValue(unsigned,Float64&) const
{
	return false;
}

bool
Attribute::getValue(unsigned,Tag&) const
{
	return false;
}

bool
Attribute::getValue(unsigned,char * &) const
{
	return false;
}

bool
Attribute::getValue(const unsigned char * &,Uint32 &) const
{
	return false;
}

bool
Attribute::getValue(const Uint16 * &,Uint32 &) const
{
	return false;
}

void
Attribute::setValue(unsigned,Uint16)
{
	Assert(0);
}

void
Attribute::setValue(unsigned,Uint32)
{
	Assert(0);
}

void
Attribute::setValue(unsigned,Int16)
{
	Assert(0);
}

void
Attribute::setValue(unsigned,Int32)
{
	Assert(0);
}

void
Attribute::setValue(unsigned,Float32)
{
	Assert(0);
}

void
Attribute::setValue(unsigned,Float64)
{
	Assert(0);
}

void
Attribute::setValue(unsigned,Tag)
{
	Assert(0);
}

void
Attribute::setValue(unsigned,const char *)
{
	Assert(0);
}

void
Attribute::setValue(const unsigned char *,Uint32)
{
	Assert(0);
}

void
Attribute::setValue(const Uint16 *,Uint32)
{
	Assert(0);
}

void
Attribute::addValue(Uint16)
{
	Assert(0);
}

void
Attribute::addValue(Uint32)
{
	Assert(0);
}

void
Attribute::addValue(Int16)	
{
	Assert(0);
}

void
Attribute::addValue(Int32)	
{
	Assert(0);
}

void
Attribute::addValue(Float32)
{
	Assert(0);
}

void
Attribute::addValue(Float64)
{
	Assert(0);
}

void
Attribute::addValue(Tag)
{
	Assert(0);
}

void
Attribute::addValue(const char *)
{
	Assert(0);
}


void
Attribute::addValues(unsigned number,Uint16 *vptr)
{
	while (number--) addValue(*vptr++);
}

void
Attribute::addValues(unsigned number,Uint32 *vptr)
{
	while (number--) addValue(*vptr++);
}

void
Attribute::addValues(unsigned number,Int16 *vptr)
{
	while (number--) addValue(*vptr++);
}

void
Attribute::addValues(unsigned number,Int32 *vptr)
{
	while (number--) addValue(*vptr++);
}

void
Attribute::addValues(unsigned number,Float32 *vptr)
{
	while (number--) addValue(*vptr++);
}

void
Attribute::addValues(unsigned number,Float64 *vptr)
{
	while (number--) addValue(*vptr++);
}

void
Attribute::addValues(unsigned number,Tag *vptr)
{
	while (number--) addValue(*vptr++);
}

void
Attribute::addValues(unsigned number,const char **vptr)
{
	while (number--) addValue(*vptr++);
}

void
Attribute::addValues(const char *)
{
	Assert(0);
}

int
Attribute::getLists(AttributeList ***a)
{
	Assert(0);
	*a=0;
	return 0;
}

DicomOutputStream&
DicomOutputStream::operator<<(Attribute& rhs)
{
	rhs.write(*this);
	return *this;
}

// should factor out somewhere generic :(
static char *unsignedIntToCharArrayAsDecimal(Uint32 u)
{
	size_t n=0;
	if (u == 0) {
		n=1;
	}
	else {
		int t=u;
		while (t) {
			++n;
			t/=10;
		}
	}
//cerr << "Attribute::unsignedIntToCharArrayAsDecimal(): n = " << n << endl;
	char *a = new char[n+1];
	for (size_t i=n; i>0; --i) {
//cerr << "Attribute::unsignedIntToCharArrayAsDecimal(): i-1 = " << (i-1) << endl;
		a[i-1] = (u % 10) + '0';
//cerr << "Attribute::unsignedIntToCharArrayAsDecimal(): a[i-1] = " << a[i-1] << endl;
		u/=10;
	}
	a[n]=(char)0;
	return a;
}

// should factor out somewhere generic :(
static char *unsignedIntToCharArrayAsHexadecimal(Uint32 u,size_t l)
{
//cerr << "Attribute::unsignedIntToCharArrayAsHexadecimal(): u = " << u << endl;
//cerr << "Attribute::unsignedIntToCharArrayAsHexadecimal(): l = " << l << endl;
	size_t n=0;
	if (u == 0) {
		n=1;
	}
	else {
		int t=u;
		while (t) {
			++n;
			t/=16;
		}
	}
	if (n > l) {
//cerr << "Attribute::unsignedIntToCharArrayAsHexadecimal(): silent truncation" << endl;
		n = l;	// silent truncation
	}
//cerr << "Attribute::unsignedIntToCharArrayAsHexadecimal(): n = " << n << endl;
	char *a = new char[l+1];
	a[l]=(char)0;
	int pad = l-n;
	int i = 0;
	{
		while (i < pad) {
//cerr << "Attribute::unsignedIntToCharArrayAsHexadecimal(): inserted 0 pad at = " << i << endl;
			a[i++]='0';	// zero pad high digits
		}
	}
	for (size_t i=1; i<=n; ++i) {
//cerr << "Attribute::unsignedIntToCharArrayAsHexadecimal(): l-i = " << (l-i) << endl;
		unsigned int digit = u % 16;
		a[l-i] = (digit >= 10) ? (digit - 10 + 'a') : (digit + '0');
//cerr << "Attribute::unsignedIntToCharArrayAsHexadecimal(): a[l-i] = " << a[l-i] << endl;
		u/=16;
	}
	return a;
}

// should factor out somewhere generic :(
char *
Attribute::getCopyOfKeywordOrPrivateTagRepresentation(Tag t,ElementDictionary *dict)
{
//cerr << "Attribute::getCopyOfKeywordOrPrivateTagRepresentation(): dec ( = " << t.getGroup() << "," << t.getElement() << ") " << (t.isPrivateTag() ? "PRIVATE" : "STD") << endl;
//cerr << "Attribute::getCopyOfKeywordOrPrivateTagRepresentation(): dict " << dict << endl;
	const char *keyword = NULL;
	const char *owner = NULL;
	if (dict != NULL) {
		if (t.isPrivateGroup()) {
			if (!t.isLengthElement() && !t.isPrivateOwner()) {
				owner = dict->getOwner(t);
//cerr << "Attribute::getCopyOfKeywordOrPrivateTagRepresentation(): owner " << owner << endl;
			}
		}
		else if (!t.isLengthElement()) {
			keyword = dict->getKeyword(t);
//cerr << "Attribute::getCopyOfKeywordOrPrivateTagRepresentation(): keyword " << keyword << endl;
		}
	}
	size_t keyword_lng = keyword == NULL ? 0 : strlen(keyword);
	size_t owner_lng = owner == NULL ? 0 : strlen(owner);
	size_t lng = keyword_lng
			   + 11										// (gggg,eeee)
			   + (owner_lng == 0 ? 0 : (3+owner_lng))	// ,"owner"
			   + 1;										// trailing NULL
	char *result = new char[lng];
	size_t i = 0;
	if (keyword_lng) {
		strncpy(result,keyword,keyword_lng);
		i+=keyword_lng;
	}
	result[i++] = '(';
	char *group = unsignedIntToCharArrayAsHexadecimal(t.getGroup(),4);
	strncpy(result+i,group,4);
	i+=4;
	delete[] group;
	result[i++] = ',';
	char *element = unsignedIntToCharArrayAsHexadecimal(t.getElement(),4);
	strncpy(result+i,element,4);
	delete[] element;
	i+=4;
	if (owner_lng != 0) {
		result[i++] = ',';
		result[i++] = '"';
		strncpy(result+i,owner,owner_lng);
		i+=owner_lng;
		result[i++] = '"';
	}
	result[i++] = ')';
	result[i++] = (char)0;
//cerr << "Attribute::getCopyOfKeywordOrPrivateTagRepresentation(): result " << result << endl;
	return result;
}

char *
Attribute::buildFullPathInInstanceToValueOfCurrentAttribute(ElementDictionary *dict,int valuenumber) const
{
	char *result = NULL;
	SimpleList<char *> *pathEntries =  new SimpleList<char *>();		// is LIFO
	if (valuenumber) {
		(*pathEntries)+=StrDup("]");
		(*pathEntries)+= unsignedIntToCharArrayAsDecimal(valuenumber);
		(*pathEntries)+=StrDup("[");
	}
	// could recurse but let's iterate instead ...
	// add ourself
	(*pathEntries)+=getCopyOfKeywordOrPrivateTagRepresentation(getTag(),dict);	// want transient copy since caller deletes all later
	AttributeList *itemList = getParentAttributeList();
	while (itemList != NULL) {
		(*pathEntries)+=StrDup("/");
		SequenceAttribute *seq = (SequenceAttribute *)(itemList->getParentSequenceAttribute());
		if (seq == NULL) break;
//cerr << "Attribute::buildFullPathInInstanceToCurrentAttribute(): have parent SequenceAttribute"<< endl;
		int itemNumber = seq->whatItemNumberIsList(itemList);
		(*pathEntries)+=StrDup("]");
		if (itemNumber != 0) {		// zero is flag that it could not be found
//cerr << "Attribute::buildFullPathInInstanceToCurrentAttribute(): have itemNumber = " << itemNumber << endl;
			(*pathEntries)+= unsignedIntToCharArrayAsDecimal(itemNumber);
		}
		(*pathEntries)+=StrDup("[");
		(*pathEntries)+=getCopyOfKeywordOrPrivateTagRepresentation(seq->getTag(),dict);
		itemList = seq->getParentAttributeList();
	}
	{
		size_t length = 0;
		{
			SimpleListIterator<char *> ei(*pathEntries);
			while (!ei) {
				char *e = ei();
				length += (e == NULL ? 0 : strlen(e));
				++ei;
			}
		}
		result = new char[length+1];
		{
			char *dst=result;
			SimpleListIterator<char *> ei(*pathEntries);
			while (!ei) {
				char *e = ei();
				if (e != NULL) {
					size_t el = strlen(e);
					strncpy(dst,e,el);
					delete[] e;
					dst+=el;
				}
				++ei;
			}
			*dst=0;
		}
	}
	return result;
}

char *
Attribute::buildFullPathInInstanceToCurrentAttribute(ElementDictionary *dict) const
{
	return buildFullPathInInstanceToValueOfCurrentAttribute(dict,0/*valuenumber*/);	// values are numbered from 1; 0 is flag that there is none
}


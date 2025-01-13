static const char *CopyrightIdentifier(void) { return "@(#)attrtypv.cc Copyright (c) 1993-2024, David A. Clunie DBA PixelMed Publishing. All rights reserved."; }
#if USESTANDARDHEADERSWITHOUTEXTENSION == 1
#include <cctype>
#else
#include <ctype.h>
#endif

#if EMITUSINGSTDNAMESPACE == 1
using namespace std;
#endif

#include "attr.h"
#include "attrtype.h"
#include "mesgtext.h"
#include "elmdict.h"

static bool inline iscntrlok(char c) {	// Per PS 3.5 6.1.3 and CP 1425 that added TAB
	return (c == 0x1b /*ESC*/ || c == 0x0a /*LF*/ || c == 0x0c /*FF*/ || c == 0x0d /*CR*/ || c == 0x09 /*TAB*/);
}

static bool inline isescape(char c) {	// Per PS 3.5 6.1.3
	return (c == 0x1b /*ESC*/);
}

static void
writeWarningVRValue(bool verbose,bool newformat,TextOutputStream& log,ElementDictionary *dict,const Attribute *a,const char *vr,int valuenumber,const char *value)
{
	if (newformat) {
		log << Attribute::WMsgDCF(MMsgDC(ValueDubiousForThisVR),a,valuenumber);
		log << " [" << (vr ? vr : 0) << "] =";
	}
	else {
		log << WMsgDC(ValueDubiousForThisVR) << " - ";
		a->getTag().write(log,dict);
		log << " " << (vr ? vr : 0)
		    << " [" << dec << valuenumber << "] =";
	}
	log << " <" << (value ? value : "") << "> - ";
}

static void
writeErrorBadVR(bool verbose,bool newformat,TextOutputStream& log,ElementDictionary *dict,const Attribute *a,const char *vr)
{
	if (newformat) {
		log << Attribute::EMsgDCF(MMsgDC(ValueInvalidForThisVR),a);
		log << " [" << (vr ? vr : 0) << "]";
	}
	else {
		log << EMsgDC(ValueInvalidForThisVR) << " - ";
		a->getTag().write(log,dict);
		log << " " << (vr ? vr : 0);
	}
	log << " - ";
}

static void
writeErrorBadVRValue(bool verbose,bool newformat,TextOutputStream& log,ElementDictionary *dict,const Attribute *a,const char *vr,int valuenumber,const char *value)
{
	if (newformat) {
		log << Attribute::EMsgDCF(MMsgDC(ValueInvalidForThisVR),a,valuenumber);
		log << " [" << (vr ? vr : 0) << "] =";
	}
	else {
		log << EMsgDC(ValueInvalidForThisVR) << " - ";
		a->getTag().write(log,dict);
		log << " " << (vr ? vr : 0)
		    << " [" << dec << valuenumber << "] =";
	}
	log << " <" << (value ? value : "") << "> - ";
}

static void
writeErrorBadTrailingChar(bool verbose,bool newformat,TextOutputStream& log,ElementDictionary *dict,const Attribute *a,const char *vr,char c)
{
	writeErrorBadVR(verbose,newformat,log,dict,a,vr);
	log << MMsgDC(TrailingCharacterInvalidForThisVR)
	    << " = '";
	if (isprint(c)) log << c;
	log << "' (" << hex << (unsigned(c)&0xff) << dec << ")"
	    << endl;
}

static void
writeErrorBadVRCharNL(bool verbose,bool newformat,TextOutputStream& log,ElementDictionary *dict,const Attribute *a,const char *vr,char c)
{
	writeErrorBadVR(verbose,newformat,log,dict,a,vr);
	log << MMsgDC(CharacterInvalidForThisVR)
	    << " = '";
	if (isprint(c)) log << c;
	log << "' (" << hex << (unsigned(c)&0xff) << dec << ")"
	    << endl;
}

static void
writeErrorBadVRCharNL(bool verbose,bool newformat,TextOutputStream& log,ElementDictionary *dict,const Attribute *a,const char *vr,int valuenumber,const char *value,
	char c)
{
	writeErrorBadVRValue(verbose,newformat,log,dict,a,vr,valuenumber,value);
	log << MMsgDC(CharacterInvalidForThisVR)
	    << " = '";
	if (isprint(c)) log << c;
	log << "' (" << hex << (unsigned(c)&0xff) << dec << ")"
	    << endl;
}

static void
writeErrorBadCharacterRepertoireCharNL(bool verbose,bool newformat,TextOutputStream& log,ElementDictionary *dict,const Attribute *a,const char *vr,int valuenumber,const char *value,
	char c)
{
	writeErrorBadVRValue(verbose,newformat,log,dict,a,vr,valuenumber,value);
	log << MMsgDC(CharacterInvalidForCharacterRepertoire)
	    << " = '";
	if (isprint(c)) log << c;
	log << "' (" << hex << (unsigned(c)&0xff) << dec << ")"
	    << endl;
}

static void
writeErrorBadVRLengthNL(bool verbose,bool newformat,TextOutputStream& log,ElementDictionary *dict,const Attribute *a,const char *vr,int valuenumber,const char *value,
	unsigned length,const char *expected)
{
	writeErrorBadVRValue(verbose,newformat,log,dict,a,vr,valuenumber,value);
	log << MMsgDC(LengthInvalidForThisVR);
	if (newformat) {
		log << " = <" << dec << length << "> -";
	}
	else {
		log << " = " << dec << length << ",";
	}
	log << " " << MMsgDC(Expected) << " " << (expected ? expected : "");
	log << endl;
}

static void
writeErrorBadVRRange(bool verbose,bool newformat,TextOutputStream& log,ElementDictionary *dict,const Attribute *a,const char *vr,int valuenumber,const char *value,
	const char *expected)
{
	writeErrorBadVRValue(verbose,newformat,log,dict,a,vr,valuenumber,value);
	log << MMsgDC(RangeInvalidForThisVR)
	    << (newformat ? " - " : ", ") << MMsgDC(Expected) << " " << (expected ? expected : "")
	    << endl;
}

// (000580)
static void
writeErrorBadTimezoneNL(bool verbose,bool newformat,TextOutputStream& log,ElementDictionary *dict,const Attribute *a,const char *vr,int valuenumber,const char *value,unsigned timezonedigitsfound) {
	writeErrorBadVRValue(verbose,newformat,log,dict,a,vr,valuenumber,value);
	log << MMsgDC(TimezoneLengthInvalidForDTVR);
	log << " - " << MMsgDC(Got) << " <" << timezonedigitsfound << "> - " << MMsgDC(Expected) << " 4 " << MMsgDC(Digits);
	log << endl;
}

bool
Attribute::validateRetired(bool verbose,bool newformat,TextOutputStream& log,ElementDictionary *dict) const
{
	Tag t = getTag();
	bool retired = dict && dict->isRetired(t);
	if (retired) {
		if (newformat) {
			log << WMsgDCF(MMsgDC(RetiredAttribute),this) << endl;
		}
		else {
			log << WMsgDC(RetiredAttribute) << " - ";
			tag.write(log,dict);
			log << endl;
		}
	}
	return !retired;
}

bool
ApplicationEntityAttribute::validateVR(bool verbose,bool newformat,TextOutputStream& log,SpecificCharacterSetInfo *specificCharacterSetInfo,ElementDictionary *dict) const
{
	bool ok=true;
	int vn=1;
	ValueListIterator<char *> i(values);
	while (!i) {
		char *s=i();
		if (strlen(s) > 16) {
			writeErrorBadVRLengthNL(verbose,newformat,log,dict,this,getVR(),vn,s,strlen(s),"<= 16");
			ok=false;
		}
		const char *p=s;
		while (*p) {
			if (iscntrl(*p) || (isspace(*p) && *p != ' ')) {
				writeErrorBadVRCharNL(verbose,newformat,log,dict,this,getVR(),vn,s,*p);
				ok=false;
			}
			++p;
		}
		++vn; ++i;
		//if (s) delete[] s;
	}
	if (embeddedNullByte) {		// set during StringAttribute::read()
		writeErrorBadVRCharNL(verbose,newformat,log,dict,this,getVR(),0);
		ok=false;
	}
	if (trailingNullByte) {		// set during StringAttribute::read()
		writeErrorBadTrailingChar(verbose,newformat,log,dict,this,getVR(),0);
		ok=false;
	}
	return ok;
}

bool
AgeStringAttribute::validateVR(bool verbose,bool newformat,TextOutputStream& log,SpecificCharacterSetInfo *specificCharacterSetInfo,ElementDictionary *dict) const
{
	bool ok=true;
	int vn=1;
	ValueListIterator<char *> i(values);
	while (!i) {
		char *s=i();
		if (strlen(s) != 4) {
			writeErrorBadVRLengthNL(verbose,newformat,log,dict,this,getVR(),vn,s,strlen(s),"== 4");
			ok=false;
		}
		else {
			int j;
			for (j=0; j<3; ++j) {
				if (!isdigit(s[j])) {
					writeErrorBadVRCharNL(verbose,newformat,log,dict,this,getVR(),vn,s,s[j]);
					ok=false;
				}
			}
			if (s[3] != 'D' && s[3] != 'W' && s[3] != 'M' && s[3] != 'Y') {
				writeErrorBadVRCharNL(verbose,newformat,log,dict,this,getVR(),vn,s,s[3]);
				ok=false;
			}
		}
		++vn; ++i;
		//if (s) delete[] s;
	}
	if (embeddedNullByte) {		// set during StringAttribute::read()
		writeErrorBadVRCharNL(verbose,newformat,log,dict,this,getVR(),0);
		ok=false;
	}
	if (trailingNullByte) {		// set during StringAttribute::read()
		writeErrorBadTrailingChar(verbose,newformat,log,dict,this,getVR(),0);
		ok=false;
	}
	if (trailingSpace && getVM()%2 == 1) {	// set during StringAttribute::read(); need to check VM, since if odd number of delimiters need some sort of padding, even if standard doesn't specify it :(
		writeErrorBadTrailingChar(verbose,newformat,log,dict,this,getVR(),' ');
		ok=false;
	}
	return ok;
}

bool
CodeStringAttribute::validateVR(bool verbose,bool newformat,TextOutputStream& log,SpecificCharacterSetInfo *specificCharacterSetInfo,ElementDictionary *dict) const
{
	bool ok=true;
	int vn=1;
	ValueListIterator<char *> i(values);
	while (!i) {
		char *s=i();
		if (strlen(s) > 16) {
			writeErrorBadVRLengthNL(verbose,newformat,log,dict,this,getVR(),vn,s,strlen(s),"<= 16");
			ok=false;
		}
		const char *p=s;
		while (*p) {
			// should check for invalid embedded spaces :(
			if (!isupper(*p) && !isdigit(*p) && *p != ' ' && *p != '_') {
				writeErrorBadVRCharNL(verbose,newformat,log,dict,this,getVR(),vn,s,*p);
				ok=false;
			}
			++p;
		}
		++vn; ++i;
		//if (s) delete[] s;
	}
	if (embeddedNullByte) {		// set during StringAttribute::read()
		writeErrorBadVRCharNL(verbose,newformat,log,dict,this,getVR(),0);
		ok=false;
	}
	if (trailingNullByte) {		// set during StringAttribute::read()
		writeErrorBadTrailingChar(verbose,newformat,log,dict,this,getVR(),0);
		ok=false;
	}
	return ok;
}

bool
CodeStringFileComponentAttribute::validateVR(bool verbose,bool newformat,TextOutputStream& log,SpecificCharacterSetInfo *specificCharacterSetInfo,ElementDictionary *dict) const
{
	bool ok=true;
	int vn=1;
	ValueListIterator<char *> i(values);
	while (!i) {
		char *s=i();
		if (strlen(s) > 8) {
			writeErrorBadVRLengthNL(verbose,newformat,log,dict,this,getVR(),vn,s,strlen(s),"<= 8");
			ok=false;
		}
		const char *p=s;
		while (*p) {
			if (!isupper(*p) && !isdigit(*p) && *p != '_') {
				writeErrorBadVRCharNL(verbose,newformat,log,dict,this,getVR(),vn,s,*p);
				ok=false;
			}
			++p;
		}
		++vn; ++i;
		//if (s) delete[] s;
	}

	// should check for VM <= 8 here :(

	if (embeddedNullByte) {		// set during StringAttribute::read()
		writeErrorBadVRCharNL(verbose,newformat,log,dict,this,getVR(),0);
		ok=false;
	}
	if (trailingNullByte) {		// set during StringAttribute::read()
		writeErrorBadTrailingChar(verbose,newformat,log,dict,this,getVR(),0);
		ok=false;
	}
	return ok;
}

bool
DateStringAttribute::validateVR(bool verbose,bool newformat,TextOutputStream& log,SpecificCharacterSetInfo *specificCharacterSetInfo,ElementDictionary *dict) const
{
	bool ok=true;
	int vn=1;
	ValueListIterator<char *> i(values);
	while (!i) {
		char *s=i();
		int l=strlen(s);
		if (l != 8 && l != 10) {		// check length seperately from content (000581)
			writeErrorBadVRLengthNL(verbose,newformat,log,dict,this,getVR(),vn,s,l,"== 8 or 10");
			ok=false;
		}
		{	// check content regardless of length (000581) ...
			const char *p=s;
			if (*p != '1' &&  *p != '2') {
				writeErrorBadVRCharNL(verbose,newformat,log,dict,this,getVR(),vn,s,*p);
				ok=false;
			}
			++p;
			if (!isdigit(*p)) {
				writeErrorBadVRCharNL(verbose,newformat,log,dict,this,getVR(),vn,s,*p);
				ok=false;
			}
			++p;
			if (!isdigit(*p)) {
				writeErrorBadVRCharNL(verbose,newformat,log,dict,this,getVR(),vn,s,*p);
				ok=false;
			}
			++p;
			if (!isdigit(*p)) {
				writeErrorBadVRCharNL(verbose,newformat,log,dict,this,getVR(),vn,s,*p);
				ok=false;
			}
			++p;
			if (*p == '.' && l == 10) {
				// CP 714 (000513)
				writeErrorBadVRCharNL(verbose,newformat,log,dict,this,getVR(),vn,s,*p);
				ok=false;
				++p;
			}
			if (*p != '0' &&  *p != '1') {
				writeErrorBadVRCharNL(verbose,newformat,log,dict,this,getVR(),vn,s,*p);
				ok=false;
			}
			++p;
			if (!isdigit(*p)) {
				writeErrorBadVRCharNL(verbose,newformat,log,dict,this,getVR(),vn,s,*p);
				ok=false;
			}
			++p;
			if (*p == '.' && l == 10) {
				// CP 714 (000513)
				writeErrorBadVRCharNL(verbose,newformat,log,dict,this,getVR(),vn,s,*p);
				ok=false;
				++p;
			}
			if (*p != '0' &&  *p != '1' &&  *p != '2' &&  *p != '3') {
				writeErrorBadVRCharNL(verbose,newformat,log,dict,this,getVR(),vn,s,*p);
				ok=false;
			}
			++p;
			if (!isdigit(*p)) {
				writeErrorBadVRCharNL(verbose,newformat,log,dict,this,getVR(),vn,s,*p);
				ok=false;
			}
		}
		++vn; ++i;
		//if (s) delete[] s;
	}
	if (embeddedNullByte) {		// set during StringAttribute::read()
		writeErrorBadVRCharNL(verbose,newformat,log,dict,this,getVR(),0);
		ok=false;
	}
	if (trailingNullByte) {		// set during StringAttribute::read()
		writeErrorBadTrailingChar(verbose,newformat,log,dict,this,getVR(),0);
		ok=false;
	}
	if (trailingSpace && getVM()%2 == 1) {	// set during StringAttribute::read(); need to check VM, since if odd number of delimiters need some sort of padding, even if standard doesn't specify it :(
		writeErrorBadTrailingChar(verbose,newformat,log,dict,this,getVR(),' ');
		ok=false;
	}
	return ok;
}

bool
DateTimeStringAttribute::validateVR(bool verbose,bool newformat,TextOutputStream& log,SpecificCharacterSetInfo *specificCharacterSetInfo,ElementDictionary *dict) const
{
	bool ok=true;
	int vn=1;
	ValueListIterator<char *> i(values);
	while (!i) {
		char *s=i();
		int l=strlen(s);
		if (l < 2 || l > 26)  {		// check length seperately from content (000581)
			writeErrorBadVRLengthNL(verbose,newformat,log,dict,this,getVR(),vn,s,l,">= 2 && <= 26");
			ok=false;
		}
		{	// check content regardless of length (000581) ...
			const char *p=s;
			if (*p != '1' &&  *p != '2') {
				writeErrorBadVRCharNL(verbose,newformat,log,dict,this,getVR(),vn,s,*p);
				ok=false;
			}
			++p;
			if (!isdigit(*p)) {
				writeErrorBadVRCharNL(verbose,newformat,log,dict,this,getVR(),vn,s,*p);
				ok=false;
			}
			++p;
			if (*p) {	// Not just CC
				if (!isdigit(*p)) {
					writeErrorBadVRCharNL(verbose,newformat,log,dict,this,getVR(),vn,s,*p);
					ok=false;
				}
				++p;
				if (!isdigit(*p)) {
					writeErrorBadVRCharNL(verbose,newformat,log,dict,this,getVR(),vn,s,*p);
					ok=false;
				}
				++p;
				if (*p) {	// Not just CCYY
					if (*p != '0' &&  *p != '1') {
						writeErrorBadVRCharNL(verbose,newformat,log,dict,this,getVR(),vn,s,*p);
						ok=false;
					}
					++p;
					if (!isdigit(*p)) {
						writeErrorBadVRCharNL(verbose,newformat,log,dict,this,getVR(),vn,s,*p);
						ok=false;
					}
					++p;
					if (*p) {	// Not just CCYYMM
						if (*p != '0' &&  *p != '1' &&  *p != '2' &&  *p != '3') {
							writeErrorBadVRCharNL(verbose,newformat,log,dict,this,getVR(),vn,s,*p);
							ok=false;
						}
						++p;
						if (!isdigit(*p)) {
							writeErrorBadVRCharNL(verbose,newformat,log,dict,this,getVR(),vn,s,*p);
							ok=false;
						}
						++p;
						if (*p) {	// Not just CCYYMMDD
							if (*p != '0' &&  *p != '1' &&  *p != '2') {
								writeErrorBadVRCharNL(verbose,newformat,log,dict,this,getVR(),vn,s,*p);
								ok=false;
							}
							++p;
							if (!isdigit(*p)) {
								writeErrorBadVRCharNL(verbose,newformat,log,dict,this,getVR(),vn,s,*p);
								ok=false;
							}
							++p;
							if (*p) {	// Not just CCYYMMDDHH
								if (*p != '0' &&  *p != '1' &&  *p != '2' &&  *p != '3' &&  *p != '4' &&  *p != '5') {
									writeErrorBadVRCharNL(verbose,newformat,log,dict,this,getVR(),vn,s,*p);
									ok=false;
								}
								++p;
								if (!isdigit(*p)) {
									writeErrorBadVRCharNL(verbose,newformat,log,dict,this,getVR(),vn,s,*p);
									ok=false;
								}
								++p;
								if (*p) {	// Not just CCYYMMDDHHMM
									if (*p != '0' &&  *p != '1' &&  *p != '2' &&  *p != '3' &&  *p != '4' &&  *p != '5') {
										writeErrorBadVRCharNL(verbose,newformat,log,dict,this,getVR(),vn,s,*p);
										ok=false;
									}
									++p;
									if (!isdigit(*p)) {
										writeErrorBadVRCharNL(verbose,newformat,log,dict,this,getVR(),vn,s,*p);
										ok=false;
									}
									++p;
									if (*p) {	// Not just CCYYMMDDHHMMSS
										if (*p == '.') {	// .FFFFFF
											while (*++p && isdigit(*p));
										}
										if (*p == '+' || *p == '-') {	// + or - ZZZZ
											unsigned timezonedigitcount = 0;
											while (*++p) {
												++timezonedigitcount;
												if (!isdigit(*p)) {
													writeErrorBadVRCharNL(verbose,newformat,log,dict,this,getVR(),vn,s,*p);
													ok=false;
												}
											}
											if (timezonedigitcount != 4) { // (000580)
												writeErrorBadTimezoneNL(verbose,newformat,log,dict,this,getVR(),vn,s,timezonedigitcount);
												ok=false;
											}
										}
									}
								}
							}
						}
					}
				}
				while (*p) {
					writeErrorBadVRCharNL(verbose,newformat,log,dict,this,getVR(),vn,s,*p);
					ok=false;
					++p;
				}
			}
		}
		++vn; ++i;
		//if (s) delete[] s;
	}
	if (embeddedNullByte) {		// set during StringAttribute::read()
		writeErrorBadVRCharNL(verbose,newformat,log,dict,this,getVR(),0);
		ok=false;
	}
	if (trailingNullByte) {		// set during StringAttribute::read()
		writeErrorBadTrailingChar(verbose,newformat,log,dict,this,getVR(),0);
		ok=false;
	}
	return ok;
}

bool
DecimalStringAttribute::validateVR(bool verbose,bool newformat,TextOutputStream& log,SpecificCharacterSetInfo *specificCharacterSetInfo,ElementDictionary *dict) const
{
	bool ok=true;
	int vn=1;
	ValueListIterator<char *> i(values);
	while (!i) {
		char *s=i();
		if (strlen(s) > 16) {
			writeErrorBadVRLengthNL(verbose,newformat,log,dict,this,getVR(),vn,s,strlen(s),"<= 16");
			ok=false;
		}
		const char *p=s;
		if (*p == '+' ||  *p == '-') ++p;
		if (isdigit(*p)) while (isdigit(*++p));
		if (*p == '.') while (isdigit(*++p));
		if (*p == 'e' || *p == 'E') {
			++p;
			if (*p == '+' ||  *p == '-') ++p;
			if (isdigit(*p)) while (isdigit(*++p));
		}
		if (*p){
			writeErrorBadVRCharNL(verbose,newformat,log,dict,this,getVR(),vn,s,*p);
			ok=false;
		}

		++vn; ++i;
		//if (s) delete[] s;
	}
	if (embeddedNullByte) {		// set during StringAttribute::read()
		writeErrorBadVRCharNL(verbose,newformat,log,dict,this,getVR(),0);
		ok=false;
	}
	if (trailingNullByte) {		// set during StringAttribute::read()
		writeErrorBadTrailingChar(verbose,newformat,log,dict,this,getVR(),0);
		ok=false;
	}
	return ok;
}

bool
IntegerStringAttribute::validateVR(bool verbose,bool newformat,TextOutputStream& log,SpecificCharacterSetInfo *specificCharacterSetInfo,ElementDictionary *dict) const
{
	bool ok=true;
	int vn=1;
	ValueListIterator<char *> i(values);
	while (!i) {
		char *s=i();
		if (strlen(s) > 12) {
			writeErrorBadVRLengthNL(verbose,newformat,log,dict,this,getVR(),vn,s,strlen(s),"<= 12");
			ok=false;
		}
		const char *p=s;
		if (*p == '+' ||  *p == '-') ++p;
		if (isdigit(*p)) while (isdigit(*++p));
		if (*p){
			writeErrorBadVRCharNL(verbose,newformat,log,dict,this,getVR(),vn,s,*p);
			ok=false;
		}

		// check in range of -(2^31-1) <= n <= (2^31-1)
		//                   -2147483647        2147483647

		double value = 0.0; 	// :)
		p=s;
		while (*p) {
			if (isdigit(*p)) value=value*10+(toascii(*p)-toascii('0'));
			++p;
		}

		// don't need to worry about sign because abs() max is same for both

		if (value > 2147483647) {
			writeErrorBadVRRange(verbose,newformat,log,dict,this,getVR(),vn,s,"-(2^31-1) <= n <= (2^31-1)");
			ok=false;
		}

		++vn; ++i;
		//if (s) delete[] s;
	}
	if (embeddedNullByte) {		// set during StringAttribute::read()
		writeErrorBadVRCharNL(verbose,newformat,log,dict,this,getVR(),0);
		ok=false;
	}
	if (trailingNullByte) {		// set during StringAttribute::read()
		writeErrorBadTrailingChar(verbose,newformat,log,dict,this,getVR(),0);
		ok=false;
	}
	return ok;
}

bool
LongStringAttribute::validateVR(bool verbose,bool newformat,TextOutputStream& log,SpecificCharacterSetInfo *specificCharacterSetInfo,ElementDictionary *dict) const
{
	bool ok=true;
	int vn=1;
	ValueListIterator<char *> i(values);
	while (!i) {
		char *s=i();
		if (strlen(s) > 64) {
			writeErrorBadVRLengthNL(verbose,newformat,log,dict,this,getVR(),vn,s,strlen(s),"<= 64");
			ok=false;
		}
		if (specificCharacterSetInfo) {
			int badCharacterPosition;
			if (!specificCharacterSetInfo->isValidString(s,badCharacterPosition)) {
				Assert(badCharacterPosition >= 0);
				writeErrorBadCharacterRepertoireCharNL(verbose,newformat,log,dict,this,getVR(),vn,s,*(s+badCharacterPosition));
				ok=false;
			}
		}
		const char *p=s;
		while (*p) {
			if ((iscntrl(*p) && !isescape(*p)) || *p == '\\') {
				writeErrorBadVRCharNL(verbose,newformat,log,dict,this,getVR(),vn,s,*p);
				ok=false;
			}
			++p;
		}
		++vn; ++i;
		//if (s) delete[] s;
	}
	if (embeddedNullByte) {		// set during StringAttribute::read()
		writeErrorBadVRCharNL(verbose,newformat,log,dict,this,getVR(),0);
		ok=false;
	}
	if (trailingNullByte) {		// set during StringAttribute::read()
		writeErrorBadTrailingChar(verbose,newformat,log,dict,this,getVR(),0);
		ok=false;
	}
	return ok;
}

bool
LongTextAttribute::validateVR(bool verbose,bool newformat,TextOutputStream& log,SpecificCharacterSetInfo *specificCharacterSetInfo,ElementDictionary *dict) const
{
	bool ok=true;
	int vn=1;
	ValueListIterator<char *> i(values);
	while (!i) {
		char *s=i();
		if (strlen(s) > 10240) {
			writeErrorBadVRLengthNL(verbose,newformat,log,dict,this,getVR(),vn,s,strlen(s),"<= 10240");
			ok=false;
		}
		const char *p=s;
		while (*p) {
			if (iscntrl(*p) && !iscntrlok(*p)) {
				writeErrorBadVRCharNL(verbose,newformat,log,dict,this,getVR(),vn,s,*p);
				ok=false;
			}
			++p;
		}
		if (specificCharacterSetInfo) {
			int badCharacterPosition;
			if (!specificCharacterSetInfo->isValidString(s,badCharacterPosition)) {
				Assert(badCharacterPosition >= 0);
				writeErrorBadCharacterRepertoireCharNL(verbose,newformat,log,dict,this,getVR(),vn,s,*(s+badCharacterPosition));
				ok=false;
			}
		}
		++vn; ++i;
		//if (s) delete[] s;
	}
	if (embeddedNullByte) {		// set during StringAttribute::read()
		writeErrorBadVRCharNL(verbose,newformat,log,dict,this,getVR(),0);
		ok=false;
	}
	if (trailingNullByte) {		// set during StringAttribute::read()
		writeErrorBadTrailingChar(verbose,newformat,log,dict,this,getVR(),0);
		ok=false;
	}
	return ok;
}

bool
PersonNameAttribute::validateVR(bool verbose,bool newformat,TextOutputStream& log,SpecificCharacterSetInfo *specificCharacterSetInfo,ElementDictionary *dict) const
{
	bool ok=true;
	int vn=1;
	ValueListIterator<char *> i(values);
	while (!i) {
		char *s=i();
		if (strlen(s) > 64) {
			writeErrorBadVRLengthNL(verbose,newformat,log,dict,this,getVR(),vn,s,strlen(s),"<= 64");
			ok=false;
		}
		if (specificCharacterSetInfo) {
			int badCharacterPosition;
			if (!specificCharacterSetInfo->isValidString(s,badCharacterPosition)) {
				Assert(badCharacterPosition >= 0);
				writeErrorBadCharacterRepertoireCharNL(verbose,newformat,log,dict,this,getVR(),vn,s,*(s+badCharacterPosition));
				ok=false;
			}
		}
		int caretsTotal=0;
		int caretsInGroup=0;
		int equals=0;
		const char *p=s;
		while (*p) {
			if ((iscntrl(*p) && !isescape(*p)) || *p == '\\' || (isspace(*p) && *p != ' ')) {
				writeErrorBadVRCharNL(verbose,newformat,log,dict,this,getVR(),vn,s,*p);
				ok=false;
			}
			else if (*p == '^') {
				++caretsTotal;
				++caretsInGroup;
//log << "Found ^ - incrementing - now equals = " << equals << ", caretsInGroup = " <<  caretsInGroup<< ", caretsTotal = " << caretsTotal << endl;
			}
			else if (*p == '=') {
				if (caretsInGroup > 4) {
					writeErrorBadVRValue(verbose,newformat,log,dict,this,getVR(),vn,s);
					log << MMsgDC(TooManyComponentDelimitersInPersonName) << endl;
					ok=false;
				}
				caretsInGroup=0;
				++equals;
//log << "Found = - incrementing - now equals = " << equals << ", caretsInGroup = " <<  caretsInGroup<< ", caretsTotal = " << caretsTotal << endl;
			}
			++p;
		}
		if (caretsTotal == 0) {
			writeWarningVRValue(verbose,newformat,log,dict,this,getVR(),vn,s);
			log << MMsgDC(RetiredPersonNameForm) << endl;
		}
		else if (caretsInGroup > 4) {
			writeErrorBadVRValue(verbose,newformat,log,dict,this,getVR(),vn,s);
			log << MMsgDC(TooManyComponentDelimitersInPersonName) << endl;
			ok=false;
		}
		if (equals > 2) {
			log << MMsgDC(TooManyComponentGroupDelimitersInPersonName) << endl;
		}
		++vn; ++i;
		//if (s) delete[] s;
	}
	if (embeddedNullByte) {		// set during StringAttribute::read()
		writeErrorBadVRCharNL(verbose,newformat,log,dict,this,getVR(),0);
		ok=false;
	}
	if (trailingNullByte) {		// set during StringAttribute::read()
		writeErrorBadTrailingChar(verbose,newformat,log,dict,this,getVR(),0);
		ok=false;
	}
	return ok;
}

bool
ShortStringAttribute::validateVR(bool verbose,bool newformat,TextOutputStream& log,SpecificCharacterSetInfo *specificCharacterSetInfo,ElementDictionary *dict) const
{
	bool ok=true;
	int vn=1;
	ValueListIterator<char *> i(values);
	while (!i) {
		char *s=i();
		if (strlen(s) > 16) {
			writeErrorBadVRLengthNL(verbose,newformat,log,dict,this,getVR(),vn,s,strlen(s),"<= 16");
			ok=false;
		}
		if (specificCharacterSetInfo) {
			int badCharacterPosition;
			if (!specificCharacterSetInfo->isValidString(s,badCharacterPosition)) {
				Assert(badCharacterPosition >= 0);
				writeErrorBadCharacterRepertoireCharNL(verbose,newformat,log,dict,this,getVR(),vn,s,*(s+badCharacterPosition));
				ok=false;
			}
		}
		const char *p=s;
		while (*p) {
			if ((iscntrl(*p) && !isescape(*p)) || *p == '\\') {
				writeErrorBadVRCharNL(verbose,newformat,log,dict,this,getVR(),vn,s,*p);
				ok=false;
			}
			++p;
		}
		++vn; ++i;
		//if (s) delete[] s;
	}
	if (embeddedNullByte) {		// set during StringAttribute::read()
		writeErrorBadVRCharNL(verbose,newformat,log,dict,this,getVR(),0);
		ok=false;
	}
	if (trailingNullByte) {		// set during StringAttribute::read()
		writeErrorBadTrailingChar(verbose,newformat,log,dict,this,getVR(),0);
		ok=false;
	}
	return ok;
}

bool
ShortTextAttribute::validateVR(bool verbose,bool newformat,TextOutputStream& log,SpecificCharacterSetInfo *specificCharacterSetInfo,ElementDictionary *dict) const
{
	bool ok=true;
	int vn=1;
	ValueListIterator<char *> i(values);
	while (!i) {
		char *s=i();
		if (strlen(s) > 1024) {
			writeErrorBadVRLengthNL(verbose,newformat,log,dict,this,getVR(),vn,s,strlen(s),"<= 1024");
			ok=false;
		}
		const char *p=s;
		while (*p) {
			if (iscntrl(*p) && !iscntrlok(*p)) {
				writeErrorBadVRCharNL(verbose,newformat,log,dict,this,getVR(),vn,s,*p);
				ok=false;
			}
			++p;
		}
		if (specificCharacterSetInfo) {
			int badCharacterPosition;
			if (!specificCharacterSetInfo->isValidString(s,badCharacterPosition)) {
				Assert(badCharacterPosition >= 0);
				writeErrorBadCharacterRepertoireCharNL(verbose,newformat,log,dict,this,getVR(),vn,s,*(s+badCharacterPosition));
				ok=false;
			}
		}
		++vn; ++i;
		//if (s) delete[] s;
	}
	if (embeddedNullByte) {		// set during StringAttribute::read()
		writeErrorBadVRCharNL(verbose,newformat,log,dict,this,getVR(),0);
		ok=false;
	}
	if (trailingNullByte) {		// set during StringAttribute::read()
		writeErrorBadTrailingChar(verbose,newformat,log,dict,this,getVR(),0);
		ok=false;
	}
	return ok;
}

bool
TimeStringAttribute::validateVR(bool verbose,bool newformat,TextOutputStream& log,SpecificCharacterSetInfo *specificCharacterSetInfo,ElementDictionary *dict) const
{
	bool ok=true;
	int vn=1;
	ValueListIterator<char *> i(values);
	while (!i) {
		char *s=i();
		int l=strlen(s);
		if (l < 2 || l > 16) {		// check length seperately from content (000581)
			writeErrorBadVRLengthNL(verbose,newformat,log,dict,this,getVR(),vn,s,l,">= 2 && <= 16");
			ok=false;
		}
		{	// check content regardless of length (000581) ...
			const char *p=s;
			if (*p != '0' &&  *p != '1' &&  *p != '2') {
				writeErrorBadVRCharNL(verbose,newformat,log,dict,this,getVR(),vn,s,*p);
				ok=false;
			}
			++p;
			if (!isdigit(*p)) {
				writeErrorBadVRCharNL(verbose,newformat,log,dict,this,getVR(),vn,s,*p);
				ok=false;
			}
			++p;
			if (*p) {	// Not just HH
				if (*p == ':') {
					// CP 714 (000513)
					writeErrorBadVRCharNL(verbose,newformat,log,dict,this,getVR(),vn,s,*p);
					ok=false;
					++p;
				}
				if (*p != '0' &&  *p != '1' &&  *p != '2' &&  *p != '3' &&  *p != '4' &&  *p != '5') {
					writeErrorBadVRCharNL(verbose,newformat,log,dict,this,getVR(),vn,s,*p);
					ok=false;
				}
				++p;
				if (!isdigit(*p)) {
					writeErrorBadVRCharNL(verbose,newformat,log,dict,this,getVR(),vn,s,*p);
					ok=false;
				}
				++p;
				if (*p) {	// Not just HHMM
					if (*p == ':') {
						// CP 714 (000513)
						writeErrorBadVRCharNL(verbose,newformat,log,dict,this,getVR(),vn,s,*p);
						ok=false;
						++p;
					}
					if (*p != '0' &&  *p != '1' &&  *p != '2' &&  *p != '3' &&  *p != '4' &&  *p != '5') {
						writeErrorBadVRCharNL(verbose,newformat,log,dict,this,getVR(),vn,s,*p);
						ok=false;
					}
					++p;
					if (!isdigit(*p)) {
						writeErrorBadVRCharNL(verbose,newformat,log,dict,this,getVR(),vn,s,*p);
						ok=false;
					}
					++p;
					if (*p == '.') {	// .FFFFFF
						while (*++p) {
							if (!isdigit(*p)) {
								writeErrorBadVRCharNL(verbose,newformat,log,dict,this,getVR(),vn,s,*p);
								ok=false;
							}
						}
					}
					while (*p) {
						writeErrorBadVRCharNL(verbose,newformat,log,dict,this,getVR(),vn,s,*p);
						ok=false;
						++p;
					}
				}
			}
		}
		++vn; ++i;
		//if (s) delete[] s;
	}
	if (embeddedNullByte) {		// set during StringAttribute::read()
		writeErrorBadVRCharNL(verbose,newformat,log,dict,this,getVR(),0);
		ok=false;
	}
	if (trailingNullByte) {		// set during StringAttribute::read()
		writeErrorBadTrailingChar(verbose,newformat,log,dict,this,getVR(),0);
		ok=false;
	}
	return ok;
}

bool
UIStringAttribute::validateVR(bool verbose,bool newformat,TextOutputStream& log,SpecificCharacterSetInfo *specificCharacterSetInfo,ElementDictionary *dict) const
{
	bool ok=true;
	int vn=1;
	ValueListIterator<char *> i(values);
	while (!i) {
		char *s=i();
		int length = strlen(s);
		if (length > 0) {
			if (length > 64) {
				writeErrorBadVRLengthNL(verbose,newformat,log,dict,this,getVR(),vn,s,strlen(s),"<= 64");
				ok=false;
			}
			const char *p=s;
			int componentlength=0;
			int countleadingzeroes=0;
			bool foundnonzerodigitsincomponent=false;
			bool nothingbutzeroesinallcomponents=true;
			while (*p) {
				if (!isdigit(*p) && *p != '.') {
					writeErrorBadVRCharNL(verbose,newformat,log,dict,this,getVR(),vn,s,*p);
					ok=false;
				}

				if (*p == '0') {
					if (!foundnonzerodigitsincomponent) ++countleadingzeroes;
				}
				else {
					if (isdigit(*p)) {
						foundnonzerodigitsincomponent=true;
					}
					if (*p != '.') {
						nothingbutzeroesinallcomponents=false;
					}
				}

				componentlength = (*p == '.') ? 0 : (componentlength+1);

				++p;

				if (!*p || *p == '.') {
					if (componentlength == 0) {
						writeErrorBadVRValue(verbose,newformat,log,dict,this,getVR(),vn,s);
						log << MMsgDC(EmptyComponent)
						    << endl;
						ok=false;
					}
					else if ((foundnonzerodigitsincomponent && countleadingzeroes > 0) || (!foundnonzerodigitsincomponent && countleadingzeroes > 1)) {
						writeErrorBadVRValue(verbose,newformat,log,dict,this,getVR(),vn,s);
						log << MMsgDC(LeadingZeroes)
						    << endl;
						ok=false;
					}
					countleadingzeroes=0; foundnonzerodigitsincomponent=false;
				}
			}
			if (nothingbutzeroesinallcomponents) {
				writeErrorBadVRValue(verbose,newformat,log,dict,this,getVR(),vn,s);
				log << MMsgDC(NothingButZeroComponents)
				    << endl;
				ok=false;
			}
		}
		++vn; ++i;
		//if (s) delete[] s;
	}
	if (embeddedNullByte) {		// set during StringAttribute::read()
		writeErrorBadVRCharNL(verbose,newformat,log,dict,this,getVR(),0);
		ok=false;
	}
	// null is OK as trailing character, but trailing space is not
	if (trailingSpace) {		// set during StringAttribute::read()
		writeErrorBadTrailingChar(verbose,newformat,log,dict,this,getVR(),' ');
		ok=false;
	}
	return ok;
}


bool
UniversalResourceAttribute::validateVR(bool verbose,bool newformat,TextOutputStream& log,SpecificCharacterSetInfo *specificCharacterSetInfo,ElementDictionary *dict) const
{
	bool ok=true;
	int vn=1;
	ValueListIterator<char *> i(values);
	while (!i) {
		char *s=i();
		const char *p=s;
		while (*p) {
			// pct-encoded = "%" HEXDIG HEXDIG
			// reserved    = gen-delims / sub-delims
			// gen-delims  = ":" / "/" / "?" / "#" / "[" / "]" / "@"
			// sub-delims  = "!" / "$" / "&" / "'" / "(" / ")" / "*" / "+" / "," / ";" / "="
			// unreserved  = ALPHA / DIGIT / "-" / "." / "_" / "~"
			if (!isalnum(*p)
			 && *p != ':' && *p != '/' && *p != '?' && *p != '#' && *p != '[' && *p != ']' && *p != '@'
			 && *p != '!' && *p != '$' && *p != '&' && *p != '\'' && *p != '(' && *p != ')' && *p != '*' && *p != '+' && *p != ',' && *p != ';' && *p != '='
			 && *p != '-' && *p != '.' && *p != '_' && *p != '~' && *p != '%') {
				writeErrorBadVRCharNL(verbose,newformat,log,dict,this,getVR(),vn,s,*p);
				ok=false;
			}
			++p;
		}
		if (specificCharacterSetInfo) {
			int badCharacterPosition;
			if (!specificCharacterSetInfo->isValidString(s,badCharacterPosition)) {
				Assert(badCharacterPosition >= 0);
				writeErrorBadCharacterRepertoireCharNL(verbose,newformat,log,dict,this,getVR(),vn,s,*(s+badCharacterPosition));
				ok=false;
			}
		}
		++vn; ++i;
		//if (s) delete[] s;
	}
	if (embeddedNullByte) {		// set during StringAttribute::read()
		writeErrorBadVRCharNL(verbose,newformat,log,dict,this,getVR(),0);
		ok=false;
	}
	if (trailingNullByte) {		// set during StringAttribute::read()
		writeErrorBadTrailingChar(verbose,newformat,log,dict,this,getVR(),0);
		ok=false;
	}
	return ok;
}

bool
UnlimitedCharactersAttribute::validateVR(bool verbose,bool newformat,TextOutputStream& log,SpecificCharacterSetInfo *specificCharacterSetInfo,ElementDictionary *dict) const
{
	bool ok=true;
	int vn=1;
	ValueListIterator<char *> i(values);
	while (!i) {
		char *s=i();
		if (specificCharacterSetInfo) {
			int badCharacterPosition;
			if (!specificCharacterSetInfo->isValidString(s,badCharacterPosition)) {
				Assert(badCharacterPosition >= 0);
				writeErrorBadCharacterRepertoireCharNL(verbose,newformat,log,dict,this,getVR(),vn,s,*(s+badCharacterPosition));
				ok=false;
			}
		}
		const char *p=s;
		while (*p) {
			if ((iscntrl(*p) && !isescape(*p)) || *p == '\\') {
				writeErrorBadVRCharNL(verbose,newformat,log,dict,this,getVR(),vn,s,*p);
				ok=false;
			}
			++p;
		}
		++vn; ++i;
		//if (s) delete[] s;
	}
	if (embeddedNullByte) {		// set during StringAttribute::read()
		writeErrorBadVRCharNL(verbose,newformat,log,dict,this,getVR(),0);
		ok=false;
	}
	if (trailingNullByte) {		// set during StringAttribute::read()
		writeErrorBadTrailingChar(verbose,newformat,log,dict,this,getVR(),0);
		ok=false;
	}
	return ok;
}


bool
UnlimitedTextAttribute::validateVR(bool verbose,bool newformat,TextOutputStream& log,SpecificCharacterSetInfo *specificCharacterSetInfo,ElementDictionary *dict) const
{
	bool ok=true;
	int vn=1;
	ValueListIterator<char *> i(values);
	while (!i) {
		char *s=i();
		const char *p=s;
		while (*p) {
			if (iscntrl(*p) && !iscntrlok(*p)) {
				writeErrorBadVRCharNL(verbose,newformat,log,dict,this,getVR(),vn,s,*p);
				ok=false;
			}
			++p;
		}
		if (specificCharacterSetInfo) {
			int badCharacterPosition;
			if (!specificCharacterSetInfo->isValidString(s,badCharacterPosition)) {
				Assert(badCharacterPosition >= 0);
				writeErrorBadCharacterRepertoireCharNL(verbose,newformat,log,dict,this,getVR(),vn,s,*(s+badCharacterPosition));
				ok=false;
			}
		}
		++vn; ++i;
		//if (s) delete[] s;
	}
	if (embeddedNullByte) {		// set during StringAttribute::read()
		writeErrorBadVRCharNL(verbose,newformat,log,dict,this,getVR(),0);
		ok=false;
	}
	if (trailingNullByte) {		// set during StringAttribute::read()
		writeErrorBadTrailingChar(verbose,newformat,log,dict,this,getVR(),0);
		ok=false;
	}
	return ok;
}


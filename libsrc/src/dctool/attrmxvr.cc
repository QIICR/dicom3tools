static const char *CopyrightIdentifier(void) { return "@(#)attrmxvr.cc Copyright (c) 1993-2024, David A. Clunie DBA PixelMed Publishing. All rights reserved."; }
#include "attrtype.h"
#include "attrmxls.h"
#include "attrval.h"
#include "elmconst.h"
#include "mesgtext.h"

// Handle any special cases required to determine Value Representation

// May need to consult:
//	- other attributes specifying representation
//	- transfer syntax

// If PixelRepresentation = 0 (unsigned) or 1 (signed), can determine:
//
// XS	SmallestImagePixelValue
// XS	LargestImagePixelValue
// XS	SmallestValidPixelValue
// XS	LargestValidPixelValue
// XS	SmallestPixelValueInSeries
// XS	LargestPixelValueInSeries
// XS	SmallestImagePixelValueInPlane
// XS	LargestImagePixelValueInPlane
// XS	PixelPaddingValue

// XS	RedPaletteColorLookupTableDescriptor
// XS	GreenPaletteColorLookupTableDescriptor
// XS	BluePaletteColorLookupTableDescriptor
// XO	RedPaletteColorLookupTableData
// XO	GreenPaletteColorLookupTableData
// XO	BluePaletteColorLookupTableData

// LUTDescriptor and LUTData are not here anymore... they are now specified
// as US in the dictionary, even though they might be US or SS ... they occur
// within a sequence and hence access to PixelRepresentation is tough.
// XS	LUTDescriptor
// XS	LUTData
// It is not clear how the LUT Descriptor VR should be specified
// The VM is 3 ... NumberOfEntries\FirstStoredPixelMapped\BitsPerEntry
// Presumably the VR of the second is dictated by PixelRepresentation,
// and therefore the others will therefore have to be the same.

// The following are retired as of PS 3.0 but no reason we shouldn't
// be able to handle them ...

// XS	GrayLookupTableDescriptor
// XS	GrayLookupTableData

// More recent additions ...

// XS	RealWorldValueLastValueMapped
// XS	RealWorldValueFirstValueMapped
// XS	HistogramFirstBinValue
// XS	HistogramLastBinValue

// Another oldie ...

// XS	PerimeterValue

// ? should we not change if OW for XO to avoid VM problems ?

bool
ReadableAttributeList::replaceWithPixelRepresentation(const Tag &t,const char *name,bool havePixelRepresentation,bool usesigned)
{
	bool success=true;
	Attribute *a=operator[](t);
	if (a) {
		if (havePixelRepresentation) {
			Attribute *newa;
			if (usesigned)
				newa=new SignedShortAttribute(t);
			else
				newa=new UnsignedShortAttribute(t);
			Assert(newa);
			unsigned vm=a->getVM();
			unsigned i;
			for (i=0; i < vm; ++i) {
				Uint16 v;
				if (!a->getValue(i,v)) Assert(0);
				newa->addValue(v);
			}
			operator-=(a);
			operator+=(newa);
		}
		else {
			const char *vr=a->getVR();
			if (vr && vr[0] == 'X') {
				errorstream << EMsgDC(MissingPixelRepresentation) << " - " << name << endl;
				good_flag=0;
				success=false;
			}
		}
	}
	return success;
}

#define ReplaceWithPixelRepresentation(n) \
	replaceWithPixelRepresentation(TagFromName(n),#n,havePixelRepresentation,vPixelRepresentation==1)

bool
ReadableAttributeList::setValueRepresentationForThisList(bool havePixelRepresentation,Uint16 vPixelRepresentation)
{
//cerr << "ReadableAttributeList::setValueRepresentationForThisList - havePixelRepresentation = " << (havePixelRepresentation ? "true" : "false") << " vPixelRepresentation = " << vPixelRepresentation << endl;
	bool success=true;
	
	// caller is responsible for setting vPixelRepresentation during reading, whether it be
	// in the current level data set or inherited from a sequence parent, since
	// attributes like RWV-related nested in sequence items may need pixel representation
	// from the root data set (000490)(000491)
	
	// for this to work with attributes in nested sequences, the sequence needs to occur
	// after the PixelRepresentation attribute ... all known affected sequences (i.e.,
	// HistogramSequence, Referenced Image Real World Value Mapping Sequence,
	// Real World Value Mapping Sequence, Data Frame Assignment Sequence,
	// Enhanced Palette Color Lookup Table Sequence, Optical Path Sequence
	// Modality LUT Sequence, VOI LUT Sequence, Presentation State Classification Component Sequence
	// fit that pattern

	if (havePixelRepresentation && vPixelRepresentation != 0 && vPixelRepresentation != 1) {
		errorstream << EMsgDC(BadValuePixelRepresentation) << endl;
		good_flag=0;
		//success=false;			// do not freak out if we get a valid value for PixelRepresentation; not the end of the world if we assume US (000490)
		vPixelRepresentation=0;		// assume unsigned if not recognized
	}

	success=success && ReplaceWithPixelRepresentation(PerimeterValue);
	success=success && ReplaceWithPixelRepresentation(SmallestImagePixelValue);
	success=success && ReplaceWithPixelRepresentation(LargestImagePixelValue);
	success=success && ReplaceWithPixelRepresentation(SmallestValidPixelValue);
	success=success && ReplaceWithPixelRepresentation(LargestValidPixelValue);
	success=success && ReplaceWithPixelRepresentation(SmallestPixelValueInSeries);
	success=success && ReplaceWithPixelRepresentation(LargestPixelValueInSeries);
	success=success && ReplaceWithPixelRepresentation(SmallestImagePixelValueInPlane);
	success=success && ReplaceWithPixelRepresentation(LargestImagePixelValueInPlane);
	success=success && ReplaceWithPixelRepresentation(PixelPaddingValue);
	success=success && ReplaceWithPixelRepresentation(RedPaletteColorLookupTableDescriptor);
	success=success && ReplaceWithPixelRepresentation(GreenPaletteColorLookupTableDescriptor);
	success=success && ReplaceWithPixelRepresentation(BluePaletteColorLookupTableDescriptor);
	//success=success && ReplaceWithPixelRepresentation(RedPaletteColorLookupTableData);
	//success=success && ReplaceWithPixelRepresentation(GreenPaletteColorLookupTableData);
	//success=success && ReplaceWithPixelRepresentation(BluePaletteColorLookupTableData);
	//success=success && ReplaceWithPixelRepresentation(LUTDescriptor);
	//success=success && ReplaceWithPixelRepresentation(LUTData);
	success=success && ReplaceWithPixelRepresentation(GrayLookupTableDescriptor);
	//success=success && ReplaceWithPixelRepresentation(GrayLookupTableData);
	success=success && ReplaceWithPixelRepresentation(RealWorldValueLastValueMapped);
	success=success && ReplaceWithPixelRepresentation(RealWorldValueFirstValueMapped);
	success=success && ReplaceWithPixelRepresentation(HistogramFirstBinValue);
	success=success && ReplaceWithPixelRepresentation(HistogramLastBinValue);

	return success;
}

bool
ReadableAttributeList::setValueRepresentationForThisListAndNestedSequences(bool havePixelRepresentation,Uint16 vPixelRepresentation)
{
//cerr << "ReadableAttributeList::setValueRepresentationForThisListAndNestedSequences(bool,Unint16)" << endl;

	bool success = setValueRepresentationForThisList(havePixelRepresentation,vPixelRepresentation);
	
	// the following is based on ::loopOverListsInSequences() ...
	AttributeListIterator listi(*this);
	while (!listi) {
		Attribute *a=listi();
		Assert(a);
		if (strcmp(a->getVR(),"SQ") == 0) {
			AttributeList **al;
			int n;
			if ((n=a->getLists(&al)) > 0) {
				int i;
				for (i=0; i<n; ++i) {
					ReadableAttributeList *itemList = (ReadableAttributeList *)(al[i]);		// blech ... dangerous downcast, but should be OK because only ever called from ReadableAttributeList::setValueRepresentationForThisListAndNestedSequences() :(
					success=success && itemList->setValueRepresentationForThisListAndNestedSequences(havePixelRepresentation,vPixelRepresentation);
				}
				delete [] al;
			}
		}
		++listi;
	}

	return success;
}

bool
ReadableAttributeList::setValueRepresentationForThisListAndNestedSequences()
{
//cerr << "ReadableAttributeList::setValueRepresentationForThisListAndNestedSequences()" << endl;
	bool havePixelRepresentation = false;
	
	Attribute *aPixelRepresentation = operator[](TagFromName(PixelRepresentation));
	Uint16 vPixelRepresentation = 0;	// should not matter what we set this to if havePixelRepresentation equals false, but make it unsigned just in case
	if (aPixelRepresentation) {
		vPixelRepresentation=AttributeValue(aPixelRepresentation);
		havePixelRepresentation = true;
	}
	
	bool success = setValueRepresentationForThisListAndNestedSequences(havePixelRepresentation,vPixelRepresentation);

	return success;
}

// Handle elsewhere or not at all yet :( ...

// If AudioSampleFormat = 0 (16 bit signed LSB 1st interleaved per channel)
// If AudioSampleFormat = 1 (8 bit signed LSB 1st interleaved per channel)
//
// OX	AudioSampleData

// If DateValueRepresentation is nn then CurveData is:
//	0 - US
//	1 - SS
//	2 - FL
//	3 - FD
//	4 - SL
//
//	Unless implict VR in which case it is OB little endian !
//
// OX	CurveData

// These depend only on the transfer syntax:
//	- Implicit VR Little Endian -> OW
//	- Explicit VR Little Endian -> OW
//	- Explicit VR Big Endian -> OW
//	- Encapsulated Pixel Data -> OB

// OX	PixelData


static const char *CopyrightIdentifier(void) { return "@(#)rdgray.cc Copyright (c) 1993-2021, David A. Clunie DBA PixelMed Publishing. All rights reserved."; }
#if USESTANDARDHEADERSWITHOUTEXTENSION == 1
#include <iostream>
#else
#include <iostream.h>
#endif

#if EMITUSINGSTDNAMESPACE == 1
using namespace std;
#endif

#include "basetype.h"
#include "srcsink.h"
#include "usegray.h"
#include "rdimage.h"
#include "rdgray.h"

ReadableWindowed8BitGrayImage::ReadableWindowed8BitGrayImage(
	SupplySource *s,Uint16 vColumns,Uint16 vRows,Uint16 vNumberOfFrames,
	Uint16 vBitsAllocated,Uint16 vBitsStored,Uint16 vHighBit,
	Uint16 vPixelRepresentation,bool invertedgrayscale)
		: Readable8BitSinglePlaneImage(
			s,vColumns,vRows,vNumberOfFrames,
			vBitsAllocated,vBitsStored,vHighBit,vPixelRepresentation),
		  UseableWindowedGrayImage(
			invertedgrayscale,vBitsStored,vPixelRepresentation)
{}

ReadableWindowed8BitGrayImage::~ReadableWindowed8BitGrayImage()
{
}

bool
ReadableWindowed8BitGrayImage::getColorCellsWanted(
	unsigned &nwanted,unsigned &nminimum)
{
	return UseableWindowedGrayImage::getColorCellsWanted(nwanted,nminimum);
}

bool
ReadableWindowed8BitGrayImage::setColorCellsAvailable(unsigned n,
		unsigned long *table)
{
	return UseableWindowedGrayImage::setColorCellsAvailable(n,table);
}

bool
ReadableWindowed8BitGrayImage::getColorCellValues(unsigned n,
	unsigned short *&red,
	unsigned short *&green,
	unsigned short *&blue)
{
	return UseableWindowedGrayImage::getColorCellValues(n,red,green,blue);
}

ReadableWindowed16BitGrayImage::ReadableWindowed16BitGrayImage(
	SupplySource *s,Uint16 vColumns,Uint16 vRows,Uint16 vNumberOfFrames,
	Uint16 vBitsAllocated,Uint16 vBitsStored,Uint16 vHighBit,
	Uint16 vPixelRepresentation,bool invertedgrayscale,
	bool padvaluepresent,Uint16 vPixelPaddingValue)
		: Readable16BitSinglePlaneImage(
			s,vColumns,vRows,vNumberOfFrames,
			vBitsAllocated,vBitsStored,vHighBit,vPixelRepresentation),
		  UseableWindowedGrayImage(
			invertedgrayscale,vBitsStored,vPixelRepresentation)
{
	usepadvalue=padvaluepresent;
	padvalue=vPixelPaddingValue;
}

ReadableWindowed16BitGrayImage::~ReadableWindowed16BitGrayImage()
{
}

bool
ReadableWindowed16BitGrayImage::getColorCellsWanted(unsigned &nwanted,
		unsigned &nminimum)
{
	return UseableWindowedGrayImage::getColorCellsWanted(nwanted,nminimum);
}

bool
ReadableWindowed16BitGrayImage::setColorCellsAvailable(unsigned n,
		unsigned long *table)
{
	Uint16 minval;
	Uint16 maxval;
	return UseableWindowedGrayImage::setColorCellsAvailable(n,table)
	    && getImageStatistics(1,minval,maxval,usepadvalue,padvalue)	// just one frame
	    && UseableWindowedGrayImage::setSign(getBits(),getSigned())	// may be changed by stats
	    && UseableWindowedGrayImage::setWindowRange(minval,maxval);
}

bool
ReadableWindowed16BitGrayImage::getColorCellValues(unsigned n,
		unsigned short *&red,
		unsigned short *&green,
		unsigned short *&blue)
{
	return UseableWindowedGrayImage::getColorCellValues(n,red,green,blue);
}

bool
ReadableWindowed16BitGrayImage::setWindowLevelWidth(Uint16 level,Uint16 width)
{
	return UseableWindowedGrayImage::setWindowLevelWidth(level,width);
}

bool
ReadableWindowed16BitGrayImage::getWindowLevelWidth(Uint16 &level,Uint16 &width)
{
	return UseableWindowedGrayImage::getWindowLevelWidth(level,width);
}

bool
ReadableWindowed16BitGrayImage::needToResetColorCells(void)
{
	return false;
}

bool
ReadableWindowed16BitGrayImage::needToResetIndexedPixels(void)
{
	return false;
}

bool
ReadableWindowed16BitGrayImage::setVOILUT(Uint16 first,Uint16 number,Uint16 depth,const Uint16 *table)
{
	return UseableWindowedGrayImage::setVOILUT(first,number,depth,table);
}

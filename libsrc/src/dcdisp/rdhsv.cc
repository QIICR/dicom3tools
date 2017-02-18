static const char *CopyrightIdentifier(void) { return "@(#)rdhsv.cc Copyright (c) 1993-2015, David A. Clunie DBA PixelMed Publishing. All rights reserved."; }
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
#include "usetrue.h"
#include "rdimage.h"
#include "rdhsv.h"

ReadableInterleaved24BitHSVImage::ReadableInterleaved24BitHSVImage(
	SupplySource *s,Uint16 vColumns,Uint16 vRows,Uint16 vNumberOfFrames,
	Uint16 vBitsAllocated,Uint16 vBitsStored,Uint16 vHighBit)
		: ReadableInterleaved24BitMultiplePlaneImage(
			s,vColumns,vRows,vNumberOfFrames,
			vBitsAllocated,vBitsStored,vHighBit),
		  UseableTrueColorImage()
{}

ReadableNonInterleaved24BitHSVImage::ReadableNonInterleaved24BitHSVImage(
	SupplySource *s,Uint16 vColumns,Uint16 vRows,Uint16 vNumberOfFrames,
	Uint16 vBitsAllocated,Uint16 vBitsStored,Uint16 vHighBit)
		: ReadableNonInterleaved24BitMultiplePlaneImage(
			s,vColumns,vRows,vNumberOfFrames,
			vBitsAllocated,vBitsStored,vHighBit),
		  UseableTrueColorImage()
{}


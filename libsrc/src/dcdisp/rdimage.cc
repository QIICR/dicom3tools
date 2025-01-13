static const char *CopyrightIdentifier(void) { return "@(#)rdimage.cc Copyright (c) 1993-2024, David A. Clunie DBA PixelMed Publishing. All rights reserved."; }
#if USESTANDARDHEADERSWITHOUTEXTENSION == 1
#include <iostream>
#include <iomanip>
#else
#include <iostream.h>
#include <iomanip.h>
#endif

#if EMITUSINGSTDNAMESPACE == 1
using namespace std;
#endif

#include "basetype.h"
#include "srcsink.h"
#include "rdimage.h"
#include "mesgtext.h"

class SourceBase<Uint16> *
ReadableImage::getSource(void)
{
	Assert(supplysource);
	return supplysource->getSource();
}

ReadableImage::ReadableImage(
	SupplySource *s,Uint16 c,Uint16 r,Uint16 f,Uint16 p,
	Uint16 bn,Uint16 ba,Uint16 bs,Uint16 hb,bool issgn)
{
	supplysource=s;
	columns=c;
	rows=r;
	frames=f;
	planes=p;
	bitsneeded=bn;
	bitsallocated=ba;
	bitsstored=bs;
	highbit=hb;
	issigned=issgn;
	Assert(supplysource);
	Assert(columns);
	Assert(rows);
	Assert(frames);
	Assert(planes);
	Assert(bitsneeded);
	Assert(bitsallocated);
	Assert(bitsstored);
	//Assert(highbit);	// could legitimately be zero for single bit image
}

ReadableImage::~ReadableImage()
{}

bool
ReadableImage::put8BitIndexedPixels(
			char *dest,
			unsigned long bytes_per_row,
			unsigned long tlhc_col,
			unsigned long tlhc_row,
			unsigned long brhc_col,
			unsigned long brhc_row)
{
	Assert(0);
	(void)dest;
	(void)bytes_per_row;
	(void)tlhc_col;
	(void)tlhc_row;
	(void)brhc_col;
	(void)brhc_row;
	return false;
}

bool
ReadableImage::getColorCellsWanted(unsigned &nwanted,unsigned &nminimum)
{
	Assert(0);
	(void)nwanted;
	(void)nminimum;
	return false;
}

bool
ReadableImage::setColorCellsAvailable(unsigned n,unsigned long *table)
{
	Assert(0);
	(void)n;
	(void)table;
	return false;
}

bool
ReadableImage::getColorCellValues(unsigned n,
		unsigned short *&red,
		unsigned short *&green,
		unsigned short *&blue)
{
	Assert(0);
	(void)n;
	(void)red;
	(void)green;
	(void)blue;
	return false;
}

bool
ReadableImage::setWindowLevelWidth(Uint16 level,Uint16 width)
{
	Assert(0);
	(void)width;
	(void)level;
	return false;
}

bool
ReadableImage::setVOILUT(Uint16 first,Uint16 number,Uint16 depth,const Uint16 *table)
{
	Assert(0);
	(void)first;
	(void)number;
	(void)depth;
	(void)table;
	return false;
}

bool
ReadableImage::getWindowLevelWidth(Uint16 &level,Uint16 &width)
{
	Assert(0);
	width=0;
	level=0;
	return false;
}

bool
ReadableImage::needToResetColorCells(void)
{
	Assert(0);
	return false;
}

bool
ReadableImage::needToResetIndexedPixels(void)
{
	Assert(0);
	return false;
}

ReadableSinglePlaneImage::ReadableSinglePlaneImage(
	SupplySource *s,Uint16 columns,Uint16 rows,Uint16 frames,
	Uint16 bitsneeded,Uint16 bitsallocated,Uint16 bitsstored,Uint16 highbit,
		bool issigned)
		: ReadableImage(
			s,columns,rows,frames,1,
			bitsneeded,bitsallocated,bitsstored,highbit,
			issigned)
{
	bufferforfulldepthimage=0;
}

ReadableSinglePlaneImage::~ReadableSinglePlaneImage()
{
	if (bufferforfulldepthimage) delete[] bufferforfulldepthimage;
}

bool
ReadableSinglePlaneImage::getBufferedFullDepthImage(void)
{
	if (!bufferforfulldepthimage) {
		Assert(rows);
		Assert(columns);
		Assert(planes==1);
		Assert(frames);

		class SourceBase<Uint16> *source = getSource();
		if (!source) return false;

		Assert(!bufferforfulldepthimage);
		bufferforfulldepthimage=new Uint16[columns*rows*frames];
		Assert(bufferforfulldepthimage);
		Uint16 *ptr=bufferforfulldepthimage;
#ifdef REALLYSLOW
		unsigned row=0;
		unsigned column=0;
		while (row < rows*frames && source->read()) {
			size_t n=source->getBufferCount();
			Assert(n);
			const Uint16 *buffer=source->getBuffer();
			Assert(buffer);
			while (n-- && row < rows*frames) {
				*ptr++=*buffer++;
				if (++column >= columns) {
					column=0;
					++row;
				}
			}
		}
		//Assert(column == 0 && row == rows*frames);
#else
		size_t n;
		const Uint16 *buffer;
		while (source->read()) {
			n=source->getBufferCount();
			//Assert(n);
			buffer=source->getBuffer();
			//Assert(buffer);
			while (n--) {
				*ptr++=*buffer++;
			}
		}
#endif
	}
	//return row >= rows*frames;	// read enough
	return true;	// ignore premature eof
}

bool
ReadableSinglePlaneImage::getImageStatistics(Uint16 framecount,
		Uint16 &minval,Uint16 &maxval,
		bool excludepadvalue,Uint16 padvalue)
{
	if (!bufferforfulldepthimage) getBufferedFullDepthImage();
	Uint16 *ptr=bufferforfulldepthimage;

	Int16  signedminval=Int16_MAX;
	Int16  signedmaxval=Int16_MIN;
	Uint16 unsignedminval=Uint16_MAX;
	Uint16 unsignedmaxval=0;

//cerr << "ReadableSinglePlaneImage::getImageStatistics start min=" << hex << minval << " max=" << hex << maxval << dec << endl;

	unsigned row=0;
	unsigned column=0;
	while (row < rows*framecount) {
		Uint16 value=*ptr++;
		if (!excludepadvalue || value != padvalue) {
			if (Int16(value) < signedminval) signedminval=value;
			if (Int16(value) > signedmaxval) signedmaxval=value;
			if (value < unsignedminval) unsignedminval=value;
			if (value > unsignedmaxval) unsignedmaxval=value;
		}
		if (++column >= columns) {
			column=0;
			++row;
		}
	}
	//Assert(column == 0 && row == rows*framecount);

//cerr << "ReadableSinglePlaneImage::getImageStatistics signedminval=" << hex << Uint16(signedminval) << endl;
//cerr << "ReadableSinglePlaneImage::getImageStatistics signedmaxval=" << hex << Uint16(signedmaxval) << dec << endl;
//cerr << "ReadableSinglePlaneImage::getImageStatistics unsignedminval=" << hex << unsignedminval << endl;
//cerr << "ReadableSinglePlaneImage::getImageStatistics unsignedmaxval=" << hex << unsignedmaxval << dec << endl;

	Uint16 signedrange=Uint16(signedmaxval-signedminval);
	Uint16 unsignedrange=unsignedmaxval-unsignedminval;
//cerr << "ReadableSinglePlaneImage::getImageStatistics signedrange=" << hex << signedrange << dec << endl;
//cerr << "ReadableSinglePlaneImage::getImageStatistics unsignedrange=" << hex << unsignedrange << endl;
#ifdef FIXSIGNIFGUESSDIFFERENT
	if (signedrange < unsignedrange) {
		if (!issigned) {
			// This message should be propagated properly ... :(
			cerr << WMsgDC(PixelRepresentationIncorrect)
			     << " - " << MMsgDC(ShouldBe) << " " << MMsgDC(Signed)
			     << endl;
			issigned=true;
		}
		minval=Uint16(signedminval);
		maxval=Uint16(signedmaxval);
	}
	else if (signedrange > unsignedrange) {
		if (issigned) {
			// This message should be propagated properly ... :(
			cerr << WMsgDC(PixelRepresentationIncorrect)
			     << " - " << MMsgDC(ShouldBe) << " " << MMsgDC(Unsigned)
			     << endl;
			issigned=false;
		}
		minval=unsignedminval;
		maxval=unsignedmaxval;
	}
	else {
		issigned=false;
		minval=unsignedminval;
		maxval=unsignedmaxval;
	}
#else /* FIXSIGNIFGUESSDIFFERENT */
	if (issigned) {
		if (signedrange > unsignedrange) {
			// This message should be propagated properly ... :(
			cerr << WMsgDC(PixelRepresentationIncorrect)
			     << " - " << MMsgDC(ShouldBe) << " " << MMsgDC(Unsigned)
			     << endl;
			issigned=true;
		}
		minval=Uint16(signedminval);
		maxval=Uint16(signedmaxval);
	}
	else {
		if (signedrange < unsignedrange) {
			// This message should be propagated properly ... :(
			cerr << WMsgDC(PixelRepresentationIncorrect)
			     << " - " << MMsgDC(ShouldBe) << " " << MMsgDC(Signed)
			     << endl;
			issigned=false;
		}
		minval=unsignedminval;
		maxval=unsignedmaxval;
	}
#endif /* FIXSIGNIFGUESSDIFFERENT */

//cerr << "ReadableSinglePlaneImage::getImageStatistics minval before xoring=" << hex << minval << endl;
//cerr << "ReadableSinglePlaneImage::getImageStatistics maxval before xoring=" << hex << maxval << dec << endl;

	// xor with high bit into unsigned space used to represent pixels ...

	if (issigned) minval=minval^(1<<(bitsstored-1));
	if (issigned) maxval=maxval^(1<<(bitsstored-1));

//cerr << "ReadableSinglePlaneImage::getImageStatistics minval=" << hex << minval << endl;
//cerr << "ReadableSinglePlaneImage::getImageStatistics maxval=" << hex << maxval << dec << endl;

//cerr << "ReadableSinglePlaneImage::getImageStatistics done min=" << hex << minval << " max=" << hex << maxval << dec << endl;

	//return row >= rows*framecount;	// read enough
	return true;	// ignore premature eof
}

bool
ReadableSinglePlaneImage::put8BitIndexedPixels(
			char *dest,
			unsigned long bytes_per_row,
			unsigned long tlhc_col,
			unsigned long tlhc_row,
			unsigned long brhc_col,
			unsigned long brhc_row)
{
	if (!bufferforfulldepthimage) getBufferedFullDepthImage();
	Uint16 *ptr=bufferforfulldepthimage;

	if (tlhc_row+rows > brhc_row+1
	 || tlhc_col+columns  > brhc_col+1) {
		return false;
	}
	unsigned row=0;
	unsigned column=0;
	char *p = dest
		+ tlhc_row*bytes_per_row
		+ tlhc_col;

#ifndef REALLYSLOW
		Uint32 pixelMapLength=0;
//cerr << "ReadableSinglePlaneImage::put8BitIndexedPixels: about to getPixelMap()" << endl;
		const char *pixelMap=getPixelMap(pixelMapLength);	// this will fail on palette color images :(
		Assert(pixelMap && pixelMapLength);
#endif

#ifdef REALLYSLOW
	while (row < rows*frames) {
		*p=mapPixel(*ptr);
		p++;
		ptr++;
		if (++column >= columns) {
			column=0;
			++row;
			p = dest
			  + (tlhc_row+row)*bytes_per_row
			  + tlhc_col;
		}
	}
	//Assert(column == 0 && row == rows*frames);
	return row >= rows*frames;	// read enough
#else
#ifdef PRETTYSLOW
	while (row < rows*frames) {
		//Assert(*ptr < pixelMapLength);
		*p++=pixelMap[*ptr++];
		if (++column >= columns) {
			column=0;
			++row;
			p = dest
			  + (tlhc_row+row)*bytes_per_row
			  + tlhc_col;
		}
	}
	//Assert(column == 0 && row == rows*frames);
	return row >= rows*frames;	// read enough
#else
	char *plast=p+rows*frames*bytes_per_row;
	int add_at_row_end=bytes_per_row-columns;
	if (add_at_row_end) {
		while (p < plast) {
			char *p_row_end=p+columns;
			while (p < p_row_end) {
				*p++=pixelMap[*ptr++];
			}
			p+=add_at_row_end;
		}
	}
	else {
//cerr << "ReadableSinglePlaneImage::put8BitIndexedPixels: optimizing for no row end padding" << endl;
		if (columns%8 == 0) {
//cerr << "ReadableSinglePlaneImage::put8BitIndexedPixels: optimizing for mod 8" << endl;
			while (p < plast) {
				*p++=pixelMap[*ptr++];
				*p++=pixelMap[*ptr++];
				*p++=pixelMap[*ptr++];
				*p++=pixelMap[*ptr++];
				*p++=pixelMap[*ptr++];
				*p++=pixelMap[*ptr++];
				*p++=pixelMap[*ptr++];
				*p++=pixelMap[*ptr++];
			}
		}
		else {
			while (p < plast) *p++=pixelMap[*ptr++];
		}
	}
	return true;
#endif
#endif
}

ReadableMultiplePlaneImage::ReadableMultiplePlaneImage(
	SupplySource *s,Uint16 columns,Uint16 rows,Uint16 frames,Uint16 planes,
	Uint16 bitsneeded,Uint16 bitsallocated,Uint16 bitsstored,Uint16 highbit)
		: ReadableImage(
			s,columns,rows,frames,planes,
			bitsneeded,bitsallocated,bitsstored,highbit)
{}

ReadableMultiplePlaneImage::~ReadableMultiplePlaneImage()
{}

Readable8BitSinglePlaneImage::Readable8BitSinglePlaneImage(
	SupplySource *s,Uint16 columns,Uint16 rows,Uint16 frames,
	Uint16 bitsallocated,Uint16 bitsstored,Uint16 highbit,
		bool issigned)
		: ReadableSinglePlaneImage(
			s,columns,rows,frames,
			8,bitsallocated,bitsstored,highbit,
			issigned)
{}

Readable8BitSinglePlaneImage::~Readable8BitSinglePlaneImage()
{}

bool
Readable8BitSinglePlaneImage::put8BitIndexedPixels(
			char *dest,
			unsigned long bytes_per_row,
			unsigned long tlhc_col,
			unsigned long tlhc_row,
			unsigned long brhc_col,
			unsigned long brhc_row)
{
//cerr << "Readable8BitSinglePlaneImage::put8BitIndexedPixels" << endl;
	Assert(bitsneeded==8);
	Assert(bitsallocated==8);
	Assert(bitsstored==8);
	Assert(highbit==7);
	return ReadableSinglePlaneImage::put8BitIndexedPixels(dest,
		bytes_per_row,tlhc_col,tlhc_row,brhc_col,brhc_row);
}

Readable16BitSinglePlaneImage::Readable16BitSinglePlaneImage(
	SupplySource *s,Uint16 columns,Uint16 rows,Uint16 frames,
	Uint16 bitsallocated,Uint16 bitsstored,Uint16 highbit,
		bool issigned)
		: ReadableSinglePlaneImage(
			s,columns,rows,frames,
			16,bitsallocated,bitsstored,highbit,
			issigned)
{}

Readable16BitSinglePlaneImage::~Readable16BitSinglePlaneImage()
{}

bool Readable16BitSinglePlaneImage::put8BitIndexedPixels(
			char *dest,
			unsigned long bytes_per_row,
			unsigned long tlhc_col,
			unsigned long tlhc_row,
			unsigned long brhc_col,
			unsigned long brhc_row)
{
//cerr << "Readable16BitSinglePlaneImage::put8BitIndexedPixels" << endl;
	Assert(bitsneeded<=16);
	Assert(bitsallocated<=16);
	Assert(bitsstored<=16);
	Assert(highbit<=15);
	return ReadableSinglePlaneImage::put8BitIndexedPixels(dest,
		bytes_per_row,tlhc_col,tlhc_row,brhc_col,brhc_row);
}

Readable16BitMultiplePlaneImage::Readable16BitMultiplePlaneImage(
	SupplySource *s,Uint16 columns,Uint16 rows,Uint16 frames,
	Uint16 bitsallocated,Uint16 bitsstored,Uint16 highbit)
		: ReadableMultiplePlaneImage(
			s,columns,rows,frames,3,
			5,bitsallocated,bitsstored,highbit)
{}

Readable16BitMultiplePlaneImage::~Readable16BitMultiplePlaneImage()
{}

ReadableInterleaved24BitMultiplePlaneImage::ReadableInterleaved24BitMultiplePlaneImage(
	SupplySource *s,Uint16 columns,Uint16 rows,Uint16 frames,
	Uint16 bitsallocated,Uint16 bitsstored,Uint16 highbit)
		: ReadableMultiplePlaneImage(
			s,columns,rows,frames,3,
			8,bitsallocated,bitsstored,highbit)
{}

ReadableInterleaved24BitMultiplePlaneImage::~ReadableInterleaved24BitMultiplePlaneImage()
{}

bool
ReadableInterleaved24BitMultiplePlaneImage::put8BitIndexedPixels(
			char *dest,
			unsigned long bytes_per_row,
			unsigned long tlhc_col,
			unsigned long tlhc_row,
			unsigned long brhc_col,
			unsigned long brhc_row)
{
	Assert(rows);
	Assert(columns);
	Assert(planes==3);

//cerr << "ReadableInterleaved24BitMultiplePlaneImage::put8BitIndexedPixels(): bytes_per_row=" << bytes_per_row << endl;

	class SourceBase<Uint16> *source = getSource();
	if (!source) return false;

	if (tlhc_row+rows > brhc_row+1
	 || tlhc_col+columns  > brhc_col+1) {
		return false;
	}
	unsigned row=0;
	unsigned column=0;
	char *p = dest
		+ tlhc_row*bytes_per_row
		+ tlhc_col;
	while (row < rows*frames && source->read()) {
		size_t n=source->getBufferCount();
		Assert(n);
		Assert(n%3 == 0);
		const Uint16 *buffer=source->getBuffer();
		Assert(buffer);
		while (n >= 3 && row < rows*frames) {
			n-=3;
			*p=mapPixel(*buffer,*(buffer+1),*(buffer+2));
//if (row%50 == 0) {
//cerr << "[" << dec << column << "," << dec << row
//     << "] = " << hex << *buffer
//     << ", " << hex << *(buffer+1)
//     << ", " << hex << *(buffer+2)
//     << " -> " << dec << Uint16(*(unsigned char *)p)
//     << dec << endl;
//}

//if (column == 0 || column == columns-1) {
//	cerr << "[" << row << "," << column << "]: r=" << *buffer << " g=" << *(buffer+1) << " b= " << *(buffer+2) << endl;
//}
			p++;
			buffer+=3;
			if (++column >= columns) {
				column=0;
				++row;
				char *p = dest
					+ (tlhc_row+row)*bytes_per_row
					+ tlhc_col;
//cerr << "ReadableInterleaved24BitMultiplePlaneImage::put8BitIndexedPixels(): Start new row=" << row << " with p=" << (unsigned long)p << " and " << n << " left in buffer" << endl;
			}
		}
	}
	//Assert(column == 0 && row == rows*frames);
	return row >= rows*frames;	// read enough
}

ReadableNonInterleaved24BitMultiplePlaneImage::ReadableNonInterleaved24BitMultiplePlaneImage(
	SupplySource *s,Uint16 columns,Uint16 rows,Uint16 frames,
	Uint16 bitsallocated,Uint16 bitsstored,Uint16 highbit)
		: ReadableMultiplePlaneImage(
			s,columns,rows,frames,3,
			8,bitsallocated,bitsstored,highbit)
{}

ReadableNonInterleaved24BitMultiplePlaneImage::~ReadableNonInterleaved24BitMultiplePlaneImage()
{}

bool
ReadableNonInterleaved24BitMultiplePlaneImage::put8BitIndexedPixels(
			char *dest,
			unsigned long bytes_per_row,
			unsigned long tlhc_col,
			unsigned long tlhc_row,
			unsigned long brhc_col,
			unsigned long brhc_row)
{
	Assert(rows);
	Assert(columns);
	Assert(planes==3);

	class SourceBase<Uint16> *source = getSource();
	if (!source) return false;

	// be wary here about using unsigned char to truncate Uint16
	// from buffer - inadvertent sign extension will confuse
	// mapPixel()

	int pixelsinframe=rows*columns;

	unsigned char *redplane  =new unsigned char[pixelsinframe];
	Assert(redplane);
	unsigned char *greenplane=new  unsigned char[pixelsinframe];
	Assert(greenplane);
	unsigned char *blueplane =new  unsigned char[pixelsinframe];
	Assert(blueplane);

	unsigned char *planes[3];
	planes[0]=redplane;
	planes[1]=greenplane;
	planes[2]=blueplane;

	if (tlhc_row+rows > brhc_row+1
	 || tlhc_col+columns  > brhc_col+1) {
		return false;
	}

	unsigned row=0;
	unsigned column=0;
	unsigned frame=0;
	unsigned plane=0;

	size_t n=0;
	const Uint16 *buffer=0;
	while (frame < frames) {
		if (n <= 0) {
			if (source->read()) {
				n=source->getBufferCount();
				Assert(n);
				buffer=source->getBuffer();
				Assert(buffer);
			}
			else
				break;
		}

		*(planes[plane]++)=*buffer++;
		--n;

		if (++column >= columns) {
			column=0;
			if (++row >= rows) {
				row=0;
				if (++plane >= 3) {
					plane=0;

					unsigned char *rp=planes[0]=redplane;
					unsigned char *gp=planes[1]=greenplane;
					unsigned char *bp=planes[2]=blueplane;

					unsigned r=0;
					while (r < rows) {
						char *p = dest
							+ (tlhc_row+r+frame*rows)*bytes_per_row
							+ tlhc_col;
						unsigned c=0;
						while (c++ < columns) {
							*p++=mapPixel(*rp++,*gp++,*bp++);
						}
						++r;
					}

					++frame;
				}
			}
		}
	}

	if (redplane)   delete[] redplane;
	if (greenplane) delete[] greenplane;
	if (blueplane)  delete[] blueplane;

	return frame >= frames;	// read enough
}

ReadableInterleaved32BitMultiplePlaneImage::ReadableInterleaved32BitMultiplePlaneImage(
	SupplySource *s,Uint16 columns,Uint16 rows,Uint16 frames,
	Uint16 bitsallocated,Uint16 bitsstored,Uint16 highbit)
		: ReadableMultiplePlaneImage(
			s,columns,rows,frames,4,
			8,bitsallocated,bitsstored,highbit)
{}

ReadableInterleaved32BitMultiplePlaneImage::~ReadableInterleaved32BitMultiplePlaneImage()
{}

ReadableNonInterleaved32BitMultiplePlaneImage::ReadableNonInterleaved32BitMultiplePlaneImage(
	SupplySource *s,Uint16 columns,Uint16 rows,Uint16 frames,
	Uint16 bitsallocated,Uint16 bitsstored,Uint16 highbit)
		: ReadableMultiplePlaneImage(
			s,columns,rows,frames,4,
			8,bitsallocated,bitsstored,highbit)
{}

ReadableNonInterleaved32BitMultiplePlaneImage::~ReadableNonInterleaved32BitMultiplePlaneImage()
{}


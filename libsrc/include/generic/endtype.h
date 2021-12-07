/* endtype.h Copyright (c) 1993-2021, David A. Clunie DBA PixelMed Publishing. All rights reserved. */
#ifndef __Header_endtype__
#define __Header_endtype__

#if USESTANDARDHEADERSWITHOUTEXTENSION == 1
#include <iostream>	//for debugging only
#else
#include <iostream.h>	//for debugging only
#endif

#if EMITUSINGSTDNAMESPACE == 1
using namespace std;	//for debugging only
#endif

typedef enum { NoEndian, LittleEndian, BigEndian, ByteEndian } Endian;

class HostEndian {
	Endian endian;
public:
	HostEndian(void)
		{
			Uint16 i=0;
			*((char *)&i)=1;
//cerr << "HostEndian::test value = 0x" << hex << i << dec << endl;
//#define NOBUGINENDTYPE
#ifdef NOBUGINENDTYPE
			endian=(i==1) ? LittleEndian : BigEndian;
#else
			Uint16 j=i;	// assigning it works around some bug in gcc for Linux
			if (j == 1)
				endian=LittleEndian;
			else
				endian=BigEndian;
#endif
//cerr << "HostEndian::i == 1 = " << (i == 1 ? "Little" : "Big") << endl;
//cerr << "HostEndian::endian = " << (endian == LittleEndian ? "Little" : "Big") << endl;
		}

	Endian getEndian(void) const	{ return endian; }
	bool isLittleEndian(void) const	{ return endian == LittleEndian; }
	bool isBigEndian(void) const	{ return endian == BigEndian; }
};

#endif /* __Header_endtype__ */

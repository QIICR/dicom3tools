static const char *CopyrightIdentifier(void) { return "@(#)somp.cc Copyright (c) 1993-2015, David A. Clunie DBA PixelMed Publishing. All rights reserved."; }
#include "basetype.h"
#include "bnstream.h"
#include "txstream.h"
#include "somp.h"
#include "sompcl.h"
#include "srcsink.h"
#include "sompsrc.h"

SOMP_Conversion::SOMP_Conversion(istream &i,ostream &e)
{
	in=new BinaryInputStream(i,BigEndian);
	err=new TextOutputStream(e);
	somphdr=0;
	pixeldatasrc=0;
}

SOMP_Conversion::~SOMP_Conversion()
{
	Assert(in);
	if (in) delete in;
	Assert(err);
	if (err) delete err;

	if (somphdr) delete somphdr;
	if (pixeldatasrc) delete pixeldatasrc;
}


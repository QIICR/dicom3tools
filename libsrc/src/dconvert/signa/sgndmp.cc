static const char *CopyrightIdentifier(void) { return "@(#)sgndmp.cc Copyright (c) 1993-2021, David A. Clunie DBA PixelMed Publishing. All rights reserved."; }
#include "sgndmp.h"

#include "bnstream.h"
#include "transyn.h"

#include "signa.h"

bool
SGN_Conversion::dumpCommon(ostream &o)
{
	Assert(in);
	if (!sgnhdr) sgnhdr=new SGN_Header_BothClass(in);
	Assert(sgnhdr);

	TextOutputStream out(o);

	sgnhdr->DumpCommon(&out);

	return true;
}



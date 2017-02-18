static const char *CopyrightIdentifier(void) { return "@(#)gendmp.cc Copyright (c) 1993-2015, David A. Clunie DBA PixelMed Publishing. All rights reserved."; }
#include "gendmp.h"

#include "bnstream.h"
#include "transyn.h"

#include "gen.h"

bool
GEN_Conversion::dumpCommon(ostream &o)
{
	Assert(in);
	if (!genhdr) genhdr=new GEN_Header_BothClass(in,fileinfo);
	Assert(genhdr);

	TextOutputStream out(o);

	genhdr->DumpCommon(&out);

	return true;
}



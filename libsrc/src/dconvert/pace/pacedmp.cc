static const char *CopyrightIdentifier(void) { return "@(#)pacedmp.cc Copyright (c) 1993-2015, David A. Clunie DBA PixelMed Publishing. All rights reserved."; }
#include "pacedmp.h"

#include "bnstream.h"
#include "transyn.h"

#include "pace.h"

bool
PACE_Conversion::dumpCommon(ostream &o)
{
	Assert(in);
	if (!pacehdr) pacehdr=new PACE_Header_BothClass(in);
	Assert(pacehdr);

	TextOutputStream out(o);

	pacehdr->DumpCommon(&out);

	return true;
}


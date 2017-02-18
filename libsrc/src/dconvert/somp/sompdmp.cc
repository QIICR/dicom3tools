static const char *CopyrightIdentifier(void) { return "@(#)sompdmp.cc Copyright (c) 1993-2015, David A. Clunie DBA PixelMed Publishing. All rights reserved."; }
#include "sompdmp.h"

#include "bnstream.h"
#include "transyn.h"

#include "somp.h"

bool
SOMP_Conversion::dumpCommon(ostream &o)
{
	Assert(in);
	if (!somphdr) somphdr=new SOMP_Header_BothClass(in);
	Assert(somphdr);

	TextOutputStream out(o);

	somphdr->DumpCommon(&out);

	return true;
}



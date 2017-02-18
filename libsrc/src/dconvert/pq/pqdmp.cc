static const char *CopyrightIdentifier(void) { return "@(#)pqdmp.cc Copyright (c) 1993-2015, David A. Clunie DBA PixelMed Publishing. All rights reserved."; }
#include "pqdmp.h"

#include "bnstream.h"
#include "transyn.h"

#include "pq.h"

bool
PQ_Conversion::dumpCommon(ostream &o)
{
	Assert(in);
	if (!pqhdr) pqhdr=new PQ_Header_BothClass(in);
	Assert(pqhdr);

	TextOutputStream out(o);

	pqhdr->DumpCommon(&out);

	return true;
}


bool
PQ_Conversion::dumpSelectedImage(ostream &o)
{
	Assert(in);
	if (!pqhdr) pqhdr=new PQ_Header_BothClass(in);
	Assert(pqhdr);

	TextOutputStream out(o);

	pqhdr->DumpSelectedImage(&out);

	return true;
}


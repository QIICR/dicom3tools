static const char *CopyrightIdentifier(void) { return "@(#)himrdmp.cc Copyright (c) 1993-2015, David A. Clunie DBA PixelMed Publishing. All rights reserved."; }
#include "himrdmp.h"

#include "bnstream.h"
#include "transyn.h"

#include "himr.h"

bool
HIMR_Conversion::dumpCommon(ostream &o)
{
	Assert(in);
	if (!himrhdr) himrhdr=new HIMR_Header_BothClass(in);
	Assert(himrhdr);

	TextOutputStream out(o);

	himrhdr->DumpCommon(&out);

	return true;
}


bool
HIMR_Conversion::dumpSelectedImage(ostream &o)
{
	Assert(in);
	if (!himrhdr) himrhdr=new HIMR_Header_BothClass(in);
	Assert(himrhdr);

	TextOutputStream out(o);

	himrhdr->DumpSelectedImage(&out);

	return true;
}


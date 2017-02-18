static const char *CopyrightIdentifier(void) { return "@(#)xxxxdmp.cc Copyright (c) 1993-2015, David A. Clunie DBA PixelMed Publishing. All rights reserved."; }
#include "xxxxdmp.h"

#include "bnstream.h"
#include "transyn.h"

#include "xxxx.h"

bool
XXXX_Conversion::dumpCommon(ostream &o)
{
	Assert(in);
	if (!xxxxhdr) xxxxhdr=new XXXX_Header_BothClass(in);
	Assert(xxxxhdr);

	TextOutputStream out(o);

	xxxxhdr->DumpCommon(&out);

	return true;
}


bool
XXXX_Conversion::dumpSelectedImage(ostream &o,unsigned imagenumber)
{
	Assert(in);
	if (!xxxxhdr) xxxxhdr=new XXXX_Header_BothClass(in);
	Assert(xxxxhdr);

	TextOutputStream out(o);

	xxxxhdr->DumpSelectedImage(&out,imagenumber);

	return true;
}


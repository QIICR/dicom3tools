static const char *CopyrightIdentifier(void) { return "@(#)imtndmp.cc Copyright (c) 1993-2015, David A. Clunie DBA PixelMed Publishing. All rights reserved."; }
#include "imtndmp.h"

#include "bnstream.h"
#include "transyn.h"

#include "imtn.h"

bool
IMTN_Conversion::dumpCommon(ostream &o)
{
	Assert(in);
	if (!imtnhdr) imtnhdr=new IMTN_Header_BothClass(in);
	Assert(imtnhdr);

	TextOutputStream out(o);

	imtnhdr->DumpCommon(&out);

	return true;
}

bool
IMTN_Conversion::dumpSelectedImage(ostream &o,unsigned imagenumber)
{
	Assert(in);
	if (!imtnhdr) imtnhdr=new IMTN_Header_BothClass(in);
	Assert(imtnhdr);

	TextOutputStream out(o);

	imtnhdr->DumpSelectedImage(&out,imagenumber);

	return true;
}


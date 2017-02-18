static const char *CopyrightIdentifier(void) { return "@(#)shimdmpf.cc Copyright (c) 1993-2015, David A. Clunie DBA PixelMed Publishing. All rights reserved."; }
#include "shimdmp.h"
#include "shimptrs.h"
#include "shimdmpf.h"

// shim.tpl currently has no select="image" entries so
// the following doesn't make it into shimdmpf.h ...

void
SHIM_Header_BothClass::DumpSelectedImage(TextOutputStream *,unsigned)
{
}

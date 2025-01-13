static const char *CopyrightIdentifier(void) { return "@(#)strval.cc Copyright (c) 1993-2024, David A. Clunie DBA PixelMed Publishing. All rights reserved."; }
#include <string.h>

#include "basetype.h"		// for strstream
#include "strvalc.h"

struct StringValueEntry {
	const char *value;
	const char *description;
};

static char *
StringValueDescription(const struct StringValueEntry *table,const char * value)
{
	ostrstream ost;
	const struct StringValueEntry *p;
	for (p=table; p->value; ++p) {
		if (strcmp(p->value,value) == 0) {
			if (p->description && strlen(p->description) > 0) {
				ost << p->description << '\0';
			}
			else {
				ost << p->value << '\0';
			}
			return ost.str();
		}
	}
	return 0;
}

#include "strvald.h"

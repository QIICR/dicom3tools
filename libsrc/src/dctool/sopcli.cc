static const char *CopyrightIdentifier(void) { return "@(#)sopcli.cc Copyright (c) 1993-2015, David A. Clunie DBA PixelMed Publishing. All rights reserved."; }
#include "basetype.h"

#include "sopcle.h"
#include "sopclt.h"
#include "sopcli.h"

const char *getDirectoryRecordTypeFromUID(const char *uid) {
	Assert(uid);
	SOPClassTableEntry *ptr = SOPClassTable;
	while (ptr && ptr->UID) {
		if (strcmp(ptr->UID,uid) == 0) {
			return ptr->DirectoryRecordType;
		}
		++ptr;
	}
	return 0;
}



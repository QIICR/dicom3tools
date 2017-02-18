/* transyne.h Copyright (c) 1993-2015, David A. Clunie DBA PixelMed Publishing. All rights reserved. */
#ifndef __Header_transyne__
#define __Header_transyne__

struct TransferSyntaxDictionaryEntry {
	const char *	UID;
	const char *	Description;
	Endian 		endian;
	VRType 		VRtype;
	bool 		encapsulated;
	Endian 		pixelendian;
};

#endif /* __Header_transyne__ */

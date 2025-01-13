/* transyne.h Copyright (c) 1993-2024, David A. Clunie DBA PixelMed Publishing. All rights reserved. */
#ifndef __Header_transyne__
#define __Header_transyne__

struct TransferSyntaxDictionaryEntry {
	const char *	UID;
	const char *	Description;
	Endian 		endian;
	VRType 		VRtype;
	bool 		encapsulated;
	Endian 		pixelendian;
	const char *	standardfamily;
};

#endif /* __Header_transyne__ */

/* elmentry.h Copyright (c) 1993-2015, David A. Clunie DBA PixelMed Publishing. All rights reserved. */
#ifndef __Header_elmentry__
#define __Header_elmentry__

class ElementDictionaryTableEntry {
public:
	Uint16		Group;
	Uint16		Element;
	Uint16		PrivateBlock;	// 0x0010-0x00ff valid, 0x0000=inactive
	const char *	ValueRepresentation;
	Uint32		ValueMultiplicityMinimum;
	Uint32		ValueMultiplicityMaximum;
	const char *	Owner;
	const char *	Keyword;
	const char *	Description;
	bool	Retired;
	bool	RenderAsString;
};

#endif /* __Header_elmentry__ */

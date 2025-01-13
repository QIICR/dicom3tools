/* transyn.h Copyright (c) 1993-2024, David A. Clunie DBA PixelMed Publishing. All rights reserved. */
#ifndef __Header_transyn__
#define __Header_transyn__

#include "misctype.h"
#include "transynu.h"

class TransferSyntax {
private:
	const char *		UID;
	const char *		Description;
	Endian 			endian;
	VRType 			VRtype;
	bool 			encapsulated;
	Endian 			pixelendian;
	const char *	standardfamily;
public:	
	TransferSyntax(const char *uid=DefaultTransferSyntaxUID);

	TransferSyntax(VRType vr,Endian e,bool encap=false);

	const char *	getUID(void) const		{ return UID; }
	const char *	getDescription(void) const	{ return Description; }
	Endian		getEndian(void) const		{ return endian; }
	VRType		getVR(void) const		{ return VRtype; }
	bool		getEncapsulated(void) const	{ return encapsulated; }
	Endian		getPixelEndian(void) const	{ return pixelendian; }
	const char *	getStandardFamily(void) const	{ return standardfamily; }

	bool	isLittleEndian(void) const	{ return endian == LittleEndian; }
	bool	isBigEndian(void) const		{ return endian == BigEndian; }

	bool	isPixelLittleEndian(void) const	{ return pixelendian == LittleEndian; }
	bool	isPixelBigEndian(void) const	{ return pixelendian == BigEndian; }

	bool	isImplicitVR(void) const	{ return VRtype == ImplicitVR; }
	bool	isExplicitVR(void) const	{ return VRtype == ExplicitVR; }

	bool	isEncapsulated(void) const	{ return encapsulated; }
	bool	isNotEncapsulated(void) const	{ return !encapsulated; }

	bool	isValid(void) const		{ return UID != 0; }
	
	bool	isISO10918JPEGFamily()		{ return standardfamily != NULL && strcmp(standardfamily,"ISO10918") == 0; }
	bool	isISO14495JPEGLSFamily()	{ return standardfamily != NULL && strcmp(standardfamily,"ISO14495") == 0; }
	bool	isISO15444JPEG2000Family()	{ return standardfamily != NULL && strcmp(standardfamily,"ISO15444") == 0; }

	bool operator==(const TransferSyntax& t2) const;
};

#endif /* __Header_transyn__ */

/* attr.h Copyright (c) 1993-2015, David A. Clunie DBA PixelMed Publishing. All rights reserved. */
// utility methods for value representation

#ifndef __Header_vr__
#define __Header_vr__

static bool isAgeStringVR(const char *vr) { return vr && vr[0]=='A' &&  vr[1]=='S'; }

static bool isAttributeTagVR(const char *vr) { return vr && vr[0]=='A' &&  vr[1]=='T'; }

static bool isDateStringVR(const char *vr) { return vr && vr[0]=='D' &&  vr[1]=='A'; }

static bool isDateTimeStringVR(const char *vr) { return vr && vr[0]=='D' &&  vr[1]=='T'; }

static bool isOtherUnspecifiedVR(const char *vr) { return vr && vr[0]=='O' && vr[1]=='X'; }

static bool isOtherDoubleVR(const char *vr) { return vr && vr[0]=='O' && vr[1]=='D'; }

static bool isOtherFloatVR(const char *vr) { return vr && vr[0]=='O' && vr[1]=='F'; }

static bool isOtherLongVR(const char *vr) { return vr && vr[0]=='O' && vr[1]=='L'; }

static bool isOtherByteVR(const char *vr) { return vr && vr[0]=='O' && vr[1]=='B'; }

static bool isSequenceVR(const char *vr) { return vr && vr[0]=='S' &&  vr[1]=='Q'; }

static bool isTimeStringVR(const char *vr) { return vr && vr[0]=='T' &&  vr[1]=='M'; }

static bool isUIStringVR(const char *vr) { return vr && vr[0]=='U' &&  vr[1]=='I'; }

static bool isUniversalResourceVR(const char *vr) { return vr && vr[0]=='U' &&  vr[1]=='R'; }

static bool isUnknownVR(const char *vr) { return vr && vr[0]=='U' &&  vr[1]=='N'; }

static bool isUnlimitedCharactersVR(const char *vr) { return vr && vr[0]=='U' &&  vr[1]=='C'; }

static bool isUnlimitedTextVR(const char *vr) { return vr && vr[0]=='U' &&  vr[1]=='T'; }

static bool isOtherByteOrWordOrUnspecifiedVR(const char *vr) { return vr && vr[0]=='O' && (vr[1]=='B' || vr[1]=='W' || vr[1]=='X'); }

static bool isOtherByteOrLongOrWordOrFloatOrDoubleVR(const char *vr) { return vr && vr[0]=='O' && (vr[1]=='B' || vr[1]=='D' || vr[1]=='F' || vr[1]=='L' || vr[1]=='W' || vr[1]=='X'); }

// use strncmp throughout, because might have passed fixed length array of 2 characters that is not null terminated ...

static bool
isLongValueLengthInExplicitValueRepresentation(const char *vr) {
	// Check for known short form VRs, rather than known long form VRs, since all new VRs will be long form, in case we encounter unrecognized one
	// but be sure and check that there really is a VR present
	return  vr && vr[0] != 0 && vr[1] != 0 && (
			strncmp(vr,"AE",2) != 0
		 && strncmp(vr,"AS",2) != 0
		 && strncmp(vr,"AT",2) != 0
		 && strncmp(vr,"CS",2) != 0
		 && strncmp(vr,"DA",2) != 0
		 && strncmp(vr,"DS",2) != 0
		 && strncmp(vr,"DT",2) != 0
		 && strncmp(vr,"FD",2) != 0
		 && strncmp(vr,"FL",2) != 0
		 && strncmp(vr,"IS",2) != 0
		 && strncmp(vr,"LO",2) != 0
		 && strncmp(vr,"LT",2) != 0
		 && strncmp(vr,"PN",2) != 0
		 && strncmp(vr,"SH",2) != 0
		 && strncmp(vr,"SL",2) != 0
		 && strncmp(vr,"SS",2) != 0
		 && strncmp(vr,"ST",2) != 0
		 && strncmp(vr,"TM",2) != 0
		 && strncmp(vr,"UI",2) != 0
		 && strncmp(vr,"UL",2) != 0
		 && strncmp(vr,"US",2) != 0
		);
}

static bool
isKnownExplicitValueRepresentation(const char *vr) {
	return vr && (
		   strncmp(vr,"AE",2) == 0
		|| strncmp(vr,"AS",2) == 0
		|| strncmp(vr,"AT",2) == 0
		|| strncmp(vr,"CS",2) == 0
		|| strncmp(vr,"DA",2) == 0
		|| strncmp(vr,"DS",2) == 0
		|| strncmp(vr,"DT",2) == 0
		|| strncmp(vr,"FL",2) == 0
		|| strncmp(vr,"FD",2) == 0
		|| strncmp(vr,"IS",2) == 0
		|| strncmp(vr,"LO",2) == 0
		|| strncmp(vr,"LT",2) == 0
		|| strncmp(vr,"OB",2) == 0
		|| strncmp(vr,"OD",2) == 0
		|| strncmp(vr,"OF",2) == 0
		|| strncmp(vr,"OL",2) == 0
		|| strncmp(vr,"OW",2) == 0
		|| strncmp(vr,"PN",2) == 0
		|| strncmp(vr,"SH",2) == 0
		|| strncmp(vr,"SL",2) == 0
		|| strncmp(vr,"SQ",2) == 0
		|| strncmp(vr,"SS",2) == 0
		|| strncmp(vr,"ST",2) == 0
		|| strncmp(vr,"TM",2) == 0
		|| strncmp(vr,"UI",2) == 0
		|| strncmp(vr,"UL",2) == 0
		|| strncmp(vr,"UN",2) == 0
		|| strncmp(vr,"UR",2) == 0
		|| strncmp(vr,"US",2) == 0
		|| strncmp(vr,"UT",2) == 0
		);
}

static bool
isStringVR(const char *vr)
{
	return vr &&
		(  strncmp(vr,"AE",2) == 0
		|| strncmp(vr,"AS",2) == 0
		|| strncmp(vr,"CS",2) == 0
		|| strncmp(vr,"DA",2) == 0
		|| strncmp(vr,"DT",2) == 0
		|| strncmp(vr,"DS",2) == 0
		|| strncmp(vr,"IS",2) == 0
		|| strncmp(vr,"LO",2) == 0
		|| strncmp(vr,"LT",2) == 0
		|| strncmp(vr,"PN",2) == 0
		|| strncmp(vr,"SH",2) == 0
		|| strncmp(vr,"ST",2) == 0
		|| strncmp(vr,"TM",2) == 0
		|| strncmp(vr,"UC",2) == 0
		|| strncmp(vr,"UI",2) == 0
		|| strncmp(vr,"UR",2) == 0
		|| strncmp(vr,"UT",2) == 0);
}


static bool
isNonOtherNumericOrDateOrTimeOrUIStringVR(const char *vr)
{
	return vr &&
		(  strncmp(vr,"DA",2) == 0
		|| strncmp(vr,"DT",2) == 0
		|| strncmp(vr,"DS",2) == 0
		|| strncmp(vr,"IS",2) == 0
		|| strncmp(vr,"TM",2) == 0
		|| strncmp(vr,"UI",2) == 0);
}

static bool
isNumericVR(const char *vr)
{
	return vr &&
		(  strncmp(vr,"OB",2) == 0
		|| strncmp(vr,"OL",2) == 0
		|| strncmp(vr,"OW",2) == 0
		|| strncmp(vr,"OX",2) == 0
		|| strncmp(vr,"SL",2) == 0
		|| strncmp(vr,"SS",2) == 0
		|| strncmp(vr,"UL",2) == 0
		|| strncmp(vr,"US",2) == 0
		|| strncmp(vr,"XL",2) == 0
		|| strncmp(vr,"XS",2) == 0);
}

static bool
isFloatVR(const char *vr)
{
	return vr &&
		(  strncmp(vr,"FL",2) == 0
		|| strncmp(vr,"FD",2) == 0
		|| strncmp(vr,"OD",2) == 0
		|| strncmp(vr,"OF",2) == 0);
}

static size_t
sizeofNumericVR(const char *vr)
{
	if (     strncmp(vr,"OB",2) == 0
	      || strncmp(vr,"OX",2) == 0)
		return 1;
	else if (strncmp(vr,"OW",2) == 0
	      || strncmp(vr,"US",2) == 0
	      || strncmp(vr,"SS",2) == 0
	      || strncmp(vr,"XS",2) == 0)
		return 2;
	else if (strncmp(vr,"OL",2) == 0
	      || strncmp(vr,"SL",2) == 0
	      || strncmp(vr,"UL",2) == 0
	      || strncmp(vr,"XL",2) == 0)
		return 4;
	else {
		Assert(0);
	}
	return 0;	// never gets here but prevents warning
}

static size_t
sizeofFloatVR(const char *vr)
{
	if (     strncmp(vr,"FL",2) == 0
	      || strncmp(vr,"OF",2) == 0)
		return 4;
	else if (strncmp(vr,"FD",2) == 0
	      || strncmp(vr,"OD",2) == 0)
		return 8;
	else {
		Assert(0);
	}
	return 0;	// never gets here but prevents warning
}

#endif // __Header_vr__

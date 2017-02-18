static const char *CopyrightIdentifier(void) { return "@(#)uidgen.cc Copyright (c) 1993-2015, David A. Clunie DBA PixelMed Publishing. All rights reserved."; }
#if USESTANDARDHEADERSWITHOUTEXTENSION == 1
#include <iomanip>
#else
#include <iomanip.h>
#endif

#if EMITUSINGSTDNAMESPACE == 1
using namespace std;
#endif

#include "basetype.h"
#include "uidgen.h"

#ifndef DEFAULTUIDROOT
#define	DEFAULTUIDROOT		"0.0.0.0"
#endif /* DEFAULTUIDROOT */

#define	UIDGEN_INSTANCE_SOP		".1"
#define	UIDGEN_INSTANCE_STUDY		".2"
#define	UIDGEN_INSTANCE_SERIES		".3"
#define	UIDGEN_FRAMEOFREFERENCE		".4"
#define	UIDGEN_INSTANCE_DIR		".5"
#define	UIDGEN_DIMENSIONORGANIZATION	".6"
#define	UIDGEN_CONCATENATION		".7"
#define	UIDGEN_SYNCFRAMEOFREFERENCE	".8"
#define	UIDGEN_RAWDATA			".9"
#define UIDGEN_IRRADIATIONEVENT	".10"

void
GeneratedUID::setSOPInstance()
{
	ost << UIDGEN_INSTANCE_SOP;
}

void
GeneratedUID::setStudyInstance()
{
	ost << UIDGEN_INSTANCE_STUDY;
}

void
GeneratedUID::setSeriesInstance()
{
	ost << UIDGEN_INSTANCE_SERIES;
}

void
GeneratedUID::setFrameOfReference()
{
	ost << UIDGEN_FRAMEOFREFERENCE;
}

void
GeneratedUID::setSynchronizationFrameOfReference()
{
	ost << UIDGEN_SYNCFRAMEOFREFERENCE;
}

void
GeneratedUID::setDirInstance()
{
	ost << UIDGEN_INSTANCE_DIR;
}

void
GeneratedUID::setDimensionOrganization()
{
	ost << UIDGEN_DIMENSIONORGANIZATION;
}

void
GeneratedUID::setConcatenation()
{
	ost << UIDGEN_CONCATENATION;
}

void
GeneratedUID::setIrradiationEvent()
{
	ost << UIDGEN_IRRADIATIONEVENT;
}

void
GeneratedUID::setRawData()
{
	ost << UIDGEN_RAWDATA;
}

void GeneratedUID::setUnsigned(unsigned u)
{
	ost << "." << (u & 0xffff);		// masked, otherwise gives different results on 64 bit platforms when value is large
}

GeneratedUID::GeneratedUID(void)
{
	ost << DEFAULTUIDROOT;
	stamp=0;
	string=0;
}

GeneratedUID::GeneratedUID(const char *s)
{
	ost << DEFAULTUIDROOT;
	stamp=s;
	string=0;
}

GeneratedUID::~GeneratedUID()
{
	if (string) delete[] string;
}

GeneratedUID::operator char *(void)
{
	Assert(!string);

	ost << ".";
	if (stamp)
		ost << stamp;
	else
		ost << (unsigned long)time(0) << "." << (unsigned long)getpid () << "." << (unsigned long)gethostid();
	ost << ends;

	return string=ost.str();
}


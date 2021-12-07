/* iodcomp.h Copyright (c) 1993-2021, David A. Clunie DBA PixelMed Publishing. All rights reserved. */
#ifndef __Header_iodcomp__
#define __Header_iodcomp__

class CompositeIOD {
public:
	virtual bool		retired(void) const = 0;
	virtual const char *identify(void) const = 0;
	virtual void        write(TextOutputStream& stream,AttributeList *list,ElementDictionary *dict) const = 0;
	virtual bool        verify(AttributeList *list,bool verbose,bool newformat,TextOutputStream& log,ElementDictionary *dict) const = 0;
};

CompositeIOD *selectCompositeIOD(AttributeList *list,const char *profile);

#endif /* __Header_iodcomp__ */


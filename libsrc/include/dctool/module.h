/* module.h Copyright (c) 1993-2024, David A. Clunie DBA PixelMed Publishing. All rights reserved. */
#ifndef __Header_module__
#define __Header_module__

class Module {
protected:
	InformationEntity ie;
public:
	InformationEntity getInformationEntity() { return ie; }
	virtual const char *identify(void) const = 0;
	virtual void        write(TextOutputStream& stream,AttributeList *list,ElementDictionary *dict) const = 0 ;
	virtual bool        verify(AttributeList *list,AttributeList *parentlist,AttributeList *rootlist,bool verbose,bool newformat,TextOutputStream& log,ElementDictionary *dict) const = 0;
};

#endif /* __Header_module__ */


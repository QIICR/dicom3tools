/* attrlist.h Copyright (c) 1993-2021, David A. Clunie DBA PixelMed Publishing. All rights reserved. */
#ifndef __Header_attrlist__
#define __Header_attrlist__

#include "elmdict.h"
#include "charset.h"

class Attribute;

class AttributeListImpl;
class AttributeListIteratorImpl;

class AttributeList {
	friend class AttributeListImpl;
	friend class AttributeListIterator;
private:
	AttributeListImpl *	list;
protected:
	ElementDictionary *	dictionary;		// only ever set by inherited classes
	class SpecificCharacterSetInfo *specificCharacterSetInfo;
	Attribute *parentSequenceAttribute;
public:
	AttributeList(void);
	virtual ~AttributeList();

	Attribute * operator[](Tag tag);
	void	operator-=(Tag tag);
	void	operator+=(Attribute *p);
	void	operator-=(Attribute *p);
	void	operator-=(AttributeList& deletelist);
	void	operator+=(AttributeList& replacelist);
	
	void	   setParentSequenceAttribute(Attribute* a) { parentSequenceAttribute=a; }
	Attribute *getParentSequenceAttribute(void) { return parentSequenceAttribute; }

	ElementDictionary *getDictionary(void)	     { return dictionary; } // Should all be const
	
	SpecificCharacterSetInfo *getSpecificCharacterSetInfo() { return specificCharacterSetInfo; }
	void setSpecificCharacterSetInfo(SpecificCharacterSetInfo *info) { specificCharacterSetInfo = info; }

	//const char*	MMsgDCF(const char *index,const char *keyword);
	const char*	EMsgDCF(const char *index,const char *keyword);
	const char*	WMsgDCF(const char *index,const char *keyword);
};

class AttributeListIterator {
	AttributeListIteratorImpl *iterator;
public:
	AttributeListIterator(AttributeList& list);
	virtual ~AttributeListIterator();

	void first(void);
	int ismore(void);
	void next(void);
	Attribute * value(void);
	int operator!()			{ return ismore(); }
	void operator++()		{ next(); }		// prefix  ++i
	void operator++(int)		{ next(); }		// postfix i++
	Attribute * operator()()	{ return value(); }
};

#endif /* __Header_attrlist__ */

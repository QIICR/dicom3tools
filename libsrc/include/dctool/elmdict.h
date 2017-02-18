/* elmdict.h Copyright (c) 1993-2015, David A. Clunie DBA PixelMed Publishing. All rights reserved. */
#ifndef __Header_elmdict__
#define __Header_elmdict__

class PrivateOwners;
class ElementDictionaryTableEntry;

class ElementDictionary {
	PrivateOwners *CurrentOwners;

	const ElementDictionaryTableEntry *operator[] (Tag tag) const;
	const ElementDictionaryTableEntry *operator[] (const char *keyword) const;
public:
	ElementDictionary(void);
	~ElementDictionary();

	const char *	getValueRepresentation(Tag t) const;
	const Uint32	getValueMultiplicityMinimum(Tag t) const;
	const Uint32	getValueMultiplicityMaximum(Tag t) const;
	const char *	getDescription(Tag t) const;
	const char *	getKeyword(Tag t) const;
	bool		getTag(const char *keyword,Tag& tr) const;
	bool		isRetired(Tag& t) const;
	bool		isRenderAsString(Tag& t) const;

	void			addOwner(Tag t,const char *owner);
	bool			hasOwner(Tag& t) const;
	const char *	getOwner(Tag& t) const;
};

#endif /* __Header_elmdict__ */

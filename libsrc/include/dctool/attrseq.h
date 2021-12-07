/* attrseq.h Copyright (c) 1993-2021, David A. Clunie DBA PixelMed Publishing. All rights reserved. */
#ifndef __Header_attrseq__
#define __Header_attrseq__

#include "listfifo.h"

// Note use of FifoList to preserve order of items in sequence

/* ********************* Sequence Attribute ********************* */

class SequenceAttribute : public Attribute {
	FifoList<AttributeList *> listoflists;
	Uint32 length;
public:
	SequenceAttribute(Tag t) : Attribute(t)
		{
			length=0xffffffff;	// unspecified until revised
		}

	virtual ~SequenceAttribute();

	TextOutputStream& write(TextOutputStream& stream,
			ElementDictionary *dict=0,bool verbose=false,bool showUsedAndIE=false);

	BinaryOutputStream& write(BinaryOutputStream& stream)
		{
			Assert(0);
			return stream;
		}

	DicomOutputStream& write(DicomOutputStream& stream);

	BinaryInputStream& read(BinaryInputStream& stream,Uint32 length)
		{
			// read is handled elsewhere ... see attrmxrd.h
			Assert(0);
			(void)length;
			return stream;
		}

	const char *	getVR() const		{ return "SQ"; }
	Uint16		getVM(void) const	{ return 1; }

	Uint32		getVL(void) const	{ return length; }
	
	Uint16	getValueSize(void) const	{ return 1; }	// should never be used, since is meaningless

	bool	isSequence(void) const		{ return true; }

	bool	isEmpty(void) const		{ return /*getVM() == 0;*/ listoflists.isEmpty(); }
	bool	isOne(void) const		{ return /*getVM() == 1;*/ listoflists.isOne(); }
	bool	isTwo(void) const		{ return /*getVM() == 2;*/ listoflists.isTwo(); }
	bool	isMultiple(void) const		{ return /*getVM() > 1;*/  listoflists.isMultiple(); }
	// isEmptyOrHasAnyEmptyValue() from attr.h should work fine
	// isEmptyOrHasAllEmptyValues() from attr.h should work fine
	
	int	getLists(AttributeList ***);

	// Methods unique to this class ...

	void operator +=(AttributeList *item);

	Uint32 getNumberOfItems (void) const;

	Uint32 whatItemNumberIsList(AttributeList *item);

	void reviseVL(void)	{}

	bool verifyVM(const char *module,const char *element,bool verbose,bool newformat,TextOutputStream& log,ElementDictionary *dict,Uint32 multiplicityMin=0,Uint32 multiplicityMax=0,const char *source=NULL) const;
};

#endif /* __Header_attrseq__ */

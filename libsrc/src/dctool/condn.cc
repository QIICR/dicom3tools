static const char *CopyrightIdentifier(void) { return "@(#)condn.cc Copyright (c) 1993-2021, David A. Clunie DBA PixelMed Publishing. All rights reserved."; }
#include "attr.h"
#include "attrseq.h"
#include "attrlist.h"
#include "elmconst.h"
#include "sopclu.h"

#include "condnc.h"

static bool ElementPresent(AttributeList *list,Tag tag)
{
	Assert(list);
	return (*list)[tag] != 0;
}

static bool ElementPresentMasked(AttributeList *list,Tag tag,Uint16 mask)
{
	Uint16 g = tag.getGroup() & mask;
	Uint16 e = tag.getElement();
	Assert(list);
	AttributeListIterator li(*list);
	while (!li) {
		Tag t = li()->getTag();
		if (!t.isPrivateGroup() && (t.getGroup() & mask) == g && t.getElement() == e) return true;
		li++;
	}
	return false;
}

static bool ElementPresentAbove(AttributeList *parentlist,Tag tag)
{
//cerr << "ElementPresentAbove: returns " << (((*parentlist)[tag] != 0) ? "true" : "false") << endl;
	return (*parentlist)[tag] != 0;
}

static bool ElementPresentWithin(AttributeList *list,Tag tag,Tag sequencetag)
{
//cerr << "ElementPresentWithin:" << endl;
	bool present=false;
	Assert(list);
	Attribute *a=(*list)[sequencetag];
	if (a && a->isSequence()) {
//cerr << "ElementPresentWithin: found sequence" << endl;
		SequenceAttribute *aseq=(SequenceAttribute *)a;
		Assert(aseq);
		AttributeList **array;
		int n;
		if ((n=aseq->getLists(&array)) > 0) {
//cerr << "ElementPresentWithin: found items" << endl;
			int i; for (i=0; i<n; ++i) {
//cerr << "ElementPresentWithin: item " << dec << i << endl;
				AttributeList *list=array[i];
				if ((*list)[tag]) {
//cerr << "ElementPresentWithin: tag present" << endl;
					present=true;
					break;
				}
			}
		}
	}

	return present;
}

static bool ElementPresentInPath(AttributeList *list,Tag tag)
{
//cerr << "ElementPresentInPath:" << endl;
//cerr << "ElementPresentInPath: tag " << hex << tag.getGroup() << "," << tag.getElement() << dec << endl;
	if ((*list)[tag]) {
//cerr << "ElementPresentInPath: tag present" << endl;
		return true;
	}
	else {
		AttributeListIterator listi(*list);
		while (!listi) {
			Attribute *a=listi();
			if (a->isSequence()) {
				SequenceAttribute *aseq=(SequenceAttribute *)a;
				Assert(aseq);
				AttributeList **array;
				int n;
				if ((n=aseq->getLists(&array)) > 0) {
//cerr << "ElementPresentInPath: found " << n << " items" << endl;
					int i;
					for (i=0; i<n; ++i) {
//cerr << "ElementPresentInPath: item " << dec << i << endl;
						AttributeList *list=array[i];
						if (ElementPresentInPath(list,tag)) {	// recurses if necessary
//cerr << "ElementPresentInPath: back from ElementPresentInPath having found tag" << endl;
							delete [] array;
							return true;	
						}
					}
				}
				delete [] array;
			}
			++listi;
		}
	}
//cerr << "ElementPresentInPath: did not find tag" << endl;
	return false;
}

static bool SequencePresentInPathHasItems(AttributeList *list,Tag tag)
{
//cerr << "SequencePresentInPathHasItems:" << endl;
//cerr << "SequencePresentInPathHasItems: tag " << hex << tag.getGroup() << "," << tag.getElement() << dec << endl;
	Attribute *a=(*list)[tag];
	if (a) {
//cerr << "SequencePresentInPathHasItems: tag present" << endl;
		if (a->isSequence()) {
//cerr << "SequencePresentInPathHasItems: tag is sequence" << endl;
			SequenceAttribute *aseq=(SequenceAttribute *)a;
			Assert(aseq);
			if (!aseq->isEmpty()) {
//cerr << "SequencePresentInPathHasItems: tag is not empty sequence" << endl;
				return true;
			}
		}
		return false;
	}
	else {
		AttributeListIterator listi(*list);
		while (!listi) {
			Attribute *a=listi();
			if (a->isSequence()) {
				SequenceAttribute *aseq=(SequenceAttribute *)a;
				Assert(aseq);
				AttributeList **array;
				int n;
				if ((n=aseq->getLists(&array)) > 0) {
//cerr << "SequencePresentInPathHasItems: found " << n << " items" << endl;
					int i;
					for (i=0; i<n; ++i) {
//cerr << "SequencePresentInPathHasItems: item " << dec << i << endl;
						AttributeList *list=array[i];
						if (SequencePresentInPathHasItems(list,tag)) {	// recurses if necessary
//cerr << "SequencePresentInPathHasItems: back from SequencePresentInPathHasItems having found tag" << endl;
							delete [] array;
							return true;
						}
					}
				}
				delete [] array;
			}
			++listi;
		}
	}
//cerr << "SequencePresentInPathHasItems: did not find tag" << endl;
	return false;
}

static bool ElementPresentInPathFirstItem(AttributeList *list,Tag tag)
{
//cerr << "ElementPresentInPathFirstItem:" << endl;
//cerr << "ElementPresentInPathFirstItem: tag " << hex << tag.getGroup() << "," << tag.getElement() << dec << endl;
	if ((*list)[tag]) {
//cerr << "ElementPresentInPathFirstItem: tag present" << endl;
		return true;
	}
	else {
		AttributeListIterator listi(*list);
		while (!listi) {
			Attribute *a=listi();
			if (a->isSequence()) {
				SequenceAttribute *aseq=(SequenceAttribute *)a;
				Assert(aseq);
				AttributeList **array;
				int n;
				if ((n=aseq->getLists(&array)) > 0) {
//cerr << "ElementPresentInPathFirstItem: found " << n << " items" << endl;
					{
//cerr << "ElementPresentInPathFirstItem: item " << dec << 0 << endl;
						AttributeList *list=array[0];
						if (ElementPresentInPath(list,tag)) {	// recurses if necessary
//cerr << "ElementPresentInPathFirstItem: back from ElementPresentInPathFirstItem having found tag" << endl;
							delete [] array;
							return true;	
						}
					}
				}
				delete [] array;
			}
			++listi;
		}
	}
//cerr << "ElementPresentInPathFirstItem: did not find tag" << endl;
	return false;
}

// Recursively descends from root into items of a top level sequence ... can be very slow :(
// This doesn't work when called within a macro, which doesn't really have access
// to the rootlist at all :(
static bool ElementPresentInPathFromRoot(AttributeList *list,Tag tag,Tag sequencetag)
{
//cerr << "ElementPresentInPathFromRoot:" << endl;
//cerr << "ElementPresentInPathFromRoot: sequencetag " << hex << sequencetag.getGroup() << "," << sequencetag.getElement() << dec << endl;
//cerr << "ElementPresentInPathFromRoot: tag " << hex << tag.getGroup() << "," << tag.getElement() << dec << endl;
//if (sequencetag.getElement() == 0x9222) {
//TextOutputStream terr(cerr);
//AttributeListIterator i(*list);
//	while (!i) {
//		Attribute *a=i();
//		Assert(a);
//		a->write(terr,NULL);
//		terr << endl;
//		++i;
//	}
//}
	Assert(list);
	Attribute *a=(*list)[sequencetag];
	if (a && a->isSequence()) {
//cerr << "ElementPresentInPathFromRoot: found sequence" << endl;
		SequenceAttribute *aseq=(SequenceAttribute *)a;
		Assert(aseq);
		AttributeList **array;
		int n;
		if ((n=aseq->getLists(&array)) > 0) {
//cerr << "ElementPresentInPathFromRoot: found " << n << " items" << endl;
			int i; for (i=0; i<n; ++i) {
//cerr << "ElementPresentInPathFromRoot: item " << dec << i << endl;
				AttributeList *list=array[i];
				if (ElementPresentInPath(list,tag)) {	// recurses if necessary
//cerr << "ElementPresentInPathFromRoot: back from ElementPresentInPath having found tag" << endl;
					delete [] array;
					return true;	
				}
			}
		}
		delete [] array;
	}
//cerr << "ElementPresentInPathFromRoot: did not find tag" << endl;
	return false;
}

// Recursively descends from root into items of a top level sequence ... can be very slow :(
// This doesn't work when called within a macro, which doesn't really have access
// to the rootlist at all :(
static bool SequencePresentInPathFromRootHasItems(AttributeList *list,Tag tag,Tag sequencetag)
{
//cerr << "SequencePresentInPathFromRootHasItems:" << endl;
//cerr << "SequencePresentInPathFromRootHasItems: sequencetag " << hex << sequencetag.getGroup() << "," << sequencetag.getElement() << dec << endl;
//cerr << "SequencePresentInPathFromRootHasItems: tag " << hex << tag.getGroup() << "," << tag.getElement() << dec << endl;
//if (sequencetag.getElement() == 0x9222) {
//TextOutputStream terr(cerr);
//AttributeListIterator i(*list);
//	while (!i) {
//		Attribute *a=i();
//		Assert(a);
//		a->write(terr,NULL);
//		terr << endl;
//		++i;
//	}
//}
	Assert(list);
	Attribute *a=(*list)[sequencetag];
	if (a && a->isSequence()) {
//cerr << "SequencePresentInPathFromRootHasItems: found sequence" << endl;
		SequenceAttribute *aseq=(SequenceAttribute *)a;
		Assert(aseq);
		AttributeList **array;
		int n;
		if ((n=aseq->getLists(&array)) > 0) {
//cerr << "SequencePresentInPathFromRootHasItems: found " << n << " items" << endl;
			int i; for (i=0; i<n; ++i) {
//cerr << "SequencePresentInPathFromRootHasItems: item " << dec << i << endl;
				AttributeList *list=array[i];
				if (SequencePresentInPathHasItems(list,tag)) {	// recurses if necessary
//cerr << "SequencePresentInPathFromRootHasItems: back from SequencePresentInPathHasItems having found tag " << endl;
					delete [] array;
					return true;
				}
			}
		}
		delete [] array;
	}
//cerr << "ElementPresentInPathFromRoot: did not find tag" << endl;
	return false;
}

// Recursively descends from root into first items of a top level sequence.
// Optimization to use when ElementPresentInPathFromRoot() is too slow :(
// E.g., for many frames in PerFrameFunctionalGroupsSequence and (?) can assume all items the same :(
static bool ElementPresentInPathFromRootFirstItem(AttributeList *list,Tag tag,Tag sequencetag)
{
//cerr << "ElementPresentInPathFromRootFirstItem:" << endl;
//cerr << "ElementPresentInPathFromRootFirstItem: sequencetag " << hex << sequencetag.getGroup() << "," << sequencetag.getElement() << dec << endl;
//cerr << "ElementPresentInPathFromRootFirstItem: tag " << hex << tag.getGroup() << "," << tag.getElement() << dec << endl;
	Assert(list);
	Attribute *a=(*list)[sequencetag];
	if (a && a->isSequence()) {
//cerr << "ElementPresentInPathFromRootFirstItem: found sequence" << endl;
		SequenceAttribute *aseq=(SequenceAttribute *)a;
		Assert(aseq);
		AttributeList **array;
		int n;
		if ((n=aseq->getLists(&array)) > 0) {
//cerr << "ElementPresentInPathFromRootFirstItem: found " << n << " items" << endl;
			{
//cerr << "ElementPresentInPathFromRoot: item " << dec << 0 << endl;
				AttributeList *list=array[0];
				if (ElementPresentInPathFirstItem(list,tag)) {	// recurses if necessary
//cerr << "ElementPresentInPathFromRootFirstItem: back from ElementPresentInPathFirstItem having found tag" << endl;
					delete [] array;
					return true;	
				}
			}
		}
		delete [] array;
	}
//cerr << "ElementPresentInPathFromRootFirstItem: did not find tag" << endl;
	return false;
}

// Recursively descends from root into first items of a top level sequence.
// Optimization to use when ElementPresentInPathFromRoot() is too slow :(
// E.g., for many frames in PerFrameFunctionalGroupsSequence and (?) can assume all items the same :(
static bool SequencePresentInPathFromRootFirstItemHasItems(AttributeList *list,Tag tag,Tag sequencetag)
{
//cerr << "SequencePresentInPathFromRootFirstItemHasItems:" << endl;
//cerr << "SequencePresentInPathFromRootFirstItemHasItems: sequencetag " << hex << sequencetag.getGroup() << "," << sequencetag.getElement() << dec << endl;
//cerr << "SequencePresentInPathFromRootFirstItemHasItems: tag " << hex << tag.getGroup() << "," << tag.getElement() << dec << endl;
	Assert(list);
	Attribute *a=(*list)[sequencetag];
	if (a && a->isSequence()) {
//cerr << "SequencePresentInPathFromRootFirstItemHasItems: found sequence" << endl;
		SequenceAttribute *aseq=(SequenceAttribute *)a;
		Assert(aseq);
		AttributeList **array;
		int n;
		if ((n=aseq->getLists(&array)) > 0) {
//cerr << "SequencePresentInPathFromRootFirstItemHasItems: found " << n << " items" << endl;
			{
//cerr << "SequencePresentInPathFromRootFirstItemHasItems: item " << dec << 0 << endl;
				AttributeList *list=array[0];
				if (SequencePresentInPathHasItems(list,tag)) {	// recurses if necessary
//cerr << "SequencePresentInPathFromRootFirstItemHasItems: back from SequencePresentInPathHasItems having found tag" << endl;
					delete [] array;
					return true;
				}
			}
		}
		delete [] array;
	}
//cerr << "SequencePresentInPathFromRootFirstItemHasItems: did not find tag" << endl;
	return false;
}

static bool GroupPresent(AttributeList *list,Tag tag)
{
	Uint16 g = tag.getGroup();
	Assert(list);
	AttributeListIterator li(*list);
	while (!li) {
		Tag t = li()->getTag();
		if (t.getGroup() == g) return true;
		li++;
	}
	return false;
}

static bool GroupPresentMasked(AttributeList *list,Tag tag,Uint16 mask)
{
	Uint16 g = tag.getGroup() & mask;
	Assert(list);
	AttributeListIterator li(*list);
	while (!li) {
		Tag t = li()->getTag();
		if ((t.getGroup() & mask) == g) return true;
		li++;
	}
	return false;
}

static bool ValuePresent(AttributeList *list,Tag tag,int valueselector)
{
//cerr << "ValuePresent: want valueselector=" << dec << valueselector << endl;
	int present=false;
	Assert(list);
	Attribute *a=(*list)[tag];
	if (a) {
		int vm = int(a->getVM());
//cerr << "ValuePresent: vm =" << dec << vm << endl;
		if (valueselector >= 0) {			// 0 is 1st value
			if(vm > valueselector) {
				present=true;
			}
		}
		else {								// -1 is wildcard
			present = vm > 0;		// any value will do
		}
	}
	return present;
}


static bool StringValueMatch(AttributeList *list,Tag tag,int valueselector,const char *string)
{
//cerr << "StringValueMatch: want valueselector=" << dec << valueselector << endl;
//cerr << "StringValueMatch: want value <" << string << ">" << endl;
//cerr << "StringValueMatch: want tag <" << hex << tag << dec << ">" << endl;
//cerr << "StringValueMatch: want string <" << string << ">" << endl;
//cerr << "StringValueMatch: looking in list " << hex << list << dec << endl;
	int match=false;
	Assert(list);
	Attribute *a=(*list)[tag];
	if (a) {
//cerr << "StringValueMatch: got attribute" << a << endl;
		if (a->isString()) {
//cerr << "StringValueMatch: testing string attribute" << a << endl;
			unsigned start;
			unsigned end;
			if (valueselector >= 0) {	// 0 is 1st value
				if(int(a->getVM()) >= valueselector) {
					start=valueselector;
					end=valueselector+1;
				}
				else
					start=end=0;
			}
			else {				// -1 is wildcard
				start=0;
				end=a->getVM();
			}
			while (start<end && !match) {
				char *value;
				if (a->getValue(start,value) && value) {
//cerr << "StringValueMatch: testing value number=" << dec << start << endl;
//cerr << "StringValueMatch: testing value <" << value << ">" << endl;
					if (strcmp(value,string) == 0)  {
//cerr << "StringValueMatch: matched at value# " << dec << start << endl;
						match=true;
					}
					delete[] value;	// correct: getValue() returns a copy
				}
				++start;
			}
		}
	}
	return match;
}

static bool TagValueMatch(AttributeList *list,Tag tag,int valueselector,Tag tagtomatch)
{
//cerr << "TagValueMatch: want valueselector=" << dec << valueselector << endl;
	int match=false;
	Assert(list);
	Attribute *a=(*list)[tag];
	if (a && a->isTag()) {
		unsigned start;
		unsigned end;
		if (valueselector >= 0) {	// 0 is 1st value
			if(int(a->getVM()) >= valueselector) {
				start=valueselector;
				end=valueselector+1;
			}
			else
				start=end=0;
		}
		else {				// -1 is wildcard
			start=0;
			end=a->getVM();
		}
		while (start<end && !match) {
			Tag value;
			if (a->getValue(start,value) && value == tagtomatch) {
//cerr << "TagValueMatch: matched at value# " << dec << start << endl;
				match=true;
			}
			++start;
		}
	}
	return match;
}

enum BinaryValueMatchOperator {
	Equals,
	NotEquals,
	LessThan,
	LessThanOrEquals,
	GreaterThan,
	GreaterThanOrEquals
};

static bool BinaryValueMatch(AttributeList *list,Tag tag,int valueselector,BinaryValueMatchOperator matchoperator,Int32 valuetomatch)
{
//cerr << "BinaryValueMatch: want valueselector=" << dec << valueselector << endl;
	int match=false;
	Assert(list);
	Attribute *a=(*list)[tag];
	if (a && a->isNumeric()) {
		unsigned start;
		unsigned end;
		if (valueselector >= 0) {	// 0 is 1st value
			if(int(a->getVM()) >= valueselector) {
				start=valueselector;
				end=valueselector+1;
			}
			else
				start=end=0;
		}
		else {				// -1 is wildcard
			start=0;
			end=a->getVM();
		}
		while (start<end && !match) {
			Int32 value;
			if (a->getValue(start,value)) {
//cerr << "BinaryValueMatch: checking value# " << dec << start << endl;
				if ((matchoperator == Equals && value == valuetomatch)
				 || (matchoperator == NotEquals && value != valuetomatch)
				 || (matchoperator == LessThan && value < valuetomatch)
				 || (matchoperator == LessThanOrEquals && value <= valuetomatch)
				 || (matchoperator == GreaterThan && value > valuetomatch)
				 || (matchoperator == GreaterThanOrEquals && value >= valuetomatch)
				) {
//cerr << "BinaryValueMatch: matched at value# " << dec << start << endl;
					match=true;
				}
			}
			++start;
		}
	}
	return match;
}

static bool SequenceHasItems(AttributeList *list,Tag tag)
{
	bool present=false;
	Assert(list);
	Attribute *a=(*list)[tag];
	if (a && a->isSequence()) {
		SequenceAttribute *aseq=(SequenceAttribute *)a;
		Assert(aseq);
		if (!aseq->isEmpty()) {
			return true;
		}
	}
	return false;
}

static bool SequenceHasOneItem(AttributeList *list,Tag tag)
{
	bool present=false;
	Assert(list);
	Attribute *a=(*list)[tag];
	if (a && a->isSequence()) {
		SequenceAttribute *aseq=(SequenceAttribute *)a;
		Assert(aseq);
		if (aseq->isOne()) {
			return true;
		}
	}
	return false;
}

static bool SequenceHasTwoItems(AttributeList *list,Tag tag)
{
	bool present=false;
	Assert(list);
	Attribute *a=(*list)[tag];
	if (a && a->isSequence()) {
		SequenceAttribute *aseq=(SequenceAttribute *)a;
		Assert(aseq);
		if (aseq->isTwo()) {
			return true;
		}
	}
	return false;
}

static bool SequenceHasMultipleItems(AttributeList *list,Tag tag)
{
	bool present=false;
	Assert(list);
	Attribute *a=(*list)[tag];
	if (a && a->isSequence()) {
		SequenceAttribute *aseq=(SequenceAttribute *)a;
		Assert(aseq);
		if (aseq->isMultiple()) {
			return true;
		}
	}
	return false;
}

static bool ElementStringValueMatchWithin(AttributeList *list,Tag tag,Tag sequencetag,int valueselector,const char *string)
{
//cerr << "ElementStringValueMatchWithin:" << endl;
	bool presentAndMatch=false;
	Assert(list);
	Attribute *a=(*list)[sequencetag];
	if (a && a->isSequence()) {
//cerr << "ElementStringValueMatchWithin: found sequence" << endl;
		SequenceAttribute *aseq=(SequenceAttribute *)a;
		Assert(aseq);
		AttributeList **array;
		int n;
		if ((n=aseq->getLists(&array)) > 0) {
//cerr << "ElementStringValueMatchWithin: found items" << endl;
			int i; for (i=0; i<n; ++i) {
//cerr << "ElementStringValueMatchWithin: item " << dec << i << endl;
				AttributeList *list=array[i];
				if ((*list)[tag]) {
//cerr << "ElementStringValueMatchWithin: tag present" << endl;
					presentAndMatch = StringValueMatch(list,tag,valueselector,string);
//cerr << "ElementStringValueMatchWithin: presentAndMatch = " << presentAndMatch << endl;
					break;
				}
			}
		}
	}
	return presentAndMatch;
}

#include "condnd.h"

static const char *CopyrightIdentifier(void) { return "@(#)attrlist.cc Copyright (c) 1993-2021, David A. Clunie DBA PixelMed Publishing. All rights reserved."; }
#include "attr.h"
#include "attrlist.h"
#include "attrseq.h"
#include "listsort.h"
#include "mesgtext.h"

// In order for the sorted list template to know how to sort one needs
// to define a type that can order itself, hence this ...

class AttributePointer {
	Attribute *Pointer;
public:
	AttributePointer(void)				{ Pointer=0; }
	AttributePointer(Attribute *p)			{ Pointer=p; }
	AttributePointer(const AttributePointer& t)	{ Pointer=t.Pointer; }

	void operator=(Attribute *p)			{ Pointer=p; }
	void operator=(const AttributePointer& t)	{ Pointer=t.Pointer; }

	Attribute *	operator()(void)		{ return Pointer; }
	Attribute *	operator->(void)		{ return Pointer; }
	Attribute &	operator*(void)			{ return *Pointer; }

	operator Attribute*()				{ return Pointer; }

	int operator==(const AttributePointer& t2)
		{ return Pointer->getTag() == t2.Pointer->getTag(); }
	int operator<(const AttributePointer& t2)
		{ return Pointer->getTag() <  t2.Pointer->getTag(); }
	int operator<=(const AttributePointer& t2)
		{ return Pointer->getTag() <= t2.Pointer->getTag(); }
	int operator>(const AttributePointer& t2)
		{ return Pointer->getTag() >  t2.Pointer->getTag(); }
	int operator>=(const AttributePointer& t2)
		{ return Pointer->getTag() >= t2.Pointer->getTag(); }
};	

// ********************** Implementation methods ************************

class AttributeListImpl : public SortedList<AttributePointer> {
private:
	AttributeList *listActual;
public:
	AttributeListImpl(AttributeList* list) : SortedList<AttributePointer>()
		{
			listActual=list;
		}

	virtual ~AttributeListImpl();

	Attribute * operator[](Tag tag);
	void	operator-=(Tag tag);

	void	operator+=(Attribute *p);
	void	operator-=(Attribute *p);

	void	operator-=(AttributeList& deletelist);
	void	operator+=(AttributeList& replacelist);

	void	operator-=(AttributeListImpl& deletelist);
	void	operator+=(AttributeListImpl& replacelist);
};

class AttributeListIteratorImpl : public SortedListIterator<AttributePointer> {
public:
	AttributeListIteratorImpl(AttributeListImpl& list)
		: SortedListIterator<AttributePointer> (list)
		{
			//cerr << "AttributeListIteratorImpl(list)" << endl;
			//cerr << "AttributeListIteratorImpl(list) "
			//     << "list.head=" << hex << (unsigned long)(list.head)
			//     << "" << endl;
		}
};

AttributeListImpl::~AttributeListImpl()
{
//#ifdef TRACE_DESTRUCTORS
//cerr << "AttributeListImpl::~AttributeListImpl" << endl;
//#endif
	AttributeListIteratorImpl listi(*this);
	while (!listi) {
		Attribute *a=listi();
		Assert(a);
		delete a;
		++listi;
	}
}

inline Attribute *
AttributeListImpl::operator[](Tag tag)
{
	Attribute *p = 0;
	AttributeListIteratorImpl i(*this);
	while (!i) {
		if (i()->getTag() == tag) {
			p=i();
//cerr << "operator[]: found tag = " << tag << endl;
			break;
		}
		++i;
	}
	return p;
}

inline void
AttributeListImpl::operator-=(Attribute *p)
{
	if (p) {
//cerr << "operator-=: removing tag = " << p->getTag() << endl;
		SortedList<AttributePointer>::operator-=(p);
		p->setParentAttributeList(NULL);
	}
}

inline void
AttributeListImpl::operator+=(Attribute *p)
{
	if (p) {
		SortedList<AttributePointer>::operator+=(p);
		p->setParentAttributeList(listActual);
	}
}

inline void
AttributeListImpl::operator-=(Tag tag)
{
	Attribute *p;
	while ((p = operator[](tag)) != 0) operator-=(p);
}

inline void
AttributeListImpl::operator-=(AttributeListImpl& deletelist)
{
	AttributeListIteratorImpl i(deletelist);
	while (!i) { operator-=(i()); ++i; }
}

inline void
AttributeListImpl::operator+=(AttributeListImpl& replacelist)
{
	AttributeListIteratorImpl i(replacelist);
	while (!i) {
		Attribute *a=i();
		operator-=(a->getTag());
		operator+=(a);
		replacelist-=a;
		i.first();
	}
}

inline void
AttributeListImpl::operator-=(AttributeList& deletelist)
{
	operator-=(*deletelist.list);
}

inline void
AttributeListImpl::operator+=(AttributeList& replacelist)
{
	operator+=(*replacelist.list);
}

// ********************** Interface methods ************************

AttributeList::AttributeList(void)
{
	list=new AttributeListImpl(this);
	Assert(list);
	dictionary=0;
	specificCharacterSetInfo=NULL;		// populated when needed by looking for SpecificCharacterSet attribute value in list, e.g., on calling validateVR() in ManagedAttributeList
	parentSequenceAttribute = NULL;
}

AttributeList::~AttributeList()
{
#ifdef TRACE_DESTRUCTORS
cerr << "AttributeList::~AttributeList" << endl;
#endif
	Assert(list);
	delete list;
	if (dictionary) delete dictionary;
	if (specificCharacterSetInfo) delete specificCharacterSetInfo;
}

Attribute * AttributeList::operator[](Tag tag)		{ return list->operator[](tag); }
void		AttributeList::operator-=(Tag tag)		{ list->operator-=(tag); }

void 		AttributeList::operator-=(Attribute *p)		{ list->operator-=(p); }
void		AttributeList::operator+=(Attribute *p)		{ list->operator+=(p); }

void 		AttributeList::operator-=(AttributeList& p)	{ list->operator-=(p); }
void		AttributeList::operator+=(AttributeList& p)	{ list->operator+=(p); }

AttributeListIterator::AttributeListIterator(AttributeList& list)
{
	iterator=new AttributeListIteratorImpl(*list.list);
	Assert(iterator);
}

AttributeListIterator::~AttributeListIterator()
{
#ifdef TRACE_DESTRUCTORS
cerr << "AttributeListIterator::~AttributeListIterator" << endl;
#endif
	Assert(iterator);
	delete iterator;
}

void 		AttributeListIterator::first(void)	{ iterator->first(); }
int 		AttributeListIterator::ismore(void)	{ return iterator->ismore(); }
void 		AttributeListIterator::next(void)	{ iterator->next(); }
Attribute * 	AttributeListIterator::value(void)	{ return iterator->value(); }

const char* EMsgDCF(const char *index,Attribute *a) {
	const char *result = "";
	if (a) {
		AttributeList *list = a->getParentAttributeList();
		if (list) {
			ElementDictionary *dict = list->getDictionary();
			char *name = a->buildFullPathInInstanceToCurrentAttribute(dict);
			result = EMsgDCA(index,name);
		}
	}
	return result;
}

const char* WMsgDCF(const char *index,Attribute *a) {
	const char *result = "";
	if (a) {
		AttributeList *list = a->getParentAttributeList();
		if (list) {
			ElementDictionary *dict = list->getDictionary();
			char *name = a->buildFullPathInInstanceToCurrentAttribute(dict);
			result = WMsgDCA(index,name);
		}
	}
	return result;
}

// duplicated from attr.cc
// should factor out somewhere generic :(
static char *unsignedIntToCharArrayAsDecimal(Uint32 u)
{
	size_t n=0;
	if (u == 0) {
		n=1;
	}
	else {
		int t=u;
		while (t) {
			++n;
			t/=10;
		}
	}
//cerr << "Attribute::unsignedIntToCharArrayAsDecimal(): n = " << n << endl;
	char *a = new char[n+1];
	for (size_t i=n; i>0; --i) {
//cerr << "Attribute::unsignedIntToCharArrayAsDecimal(): i-1 = " << (i-1) << endl;
		a[i-1] = (u % 10) + '0';
//cerr << "Attribute::unsignedIntToCharArrayAsDecimal(): a[i-1] = " << a[i-1] << endl;
		u/=10;
	}
	a[n]=(char)0;
	return a;
}

//const char*
//AttributeList::MMsgDCF(const char *index,const char *keyword) {
//	const char *result = "";
//	if (list) {
//		char *name = StrDup("");
//		ElementDictionary *dict = getDictionary();
//		SequenceAttribute *seq = (SequenceAttribute *)(getParentSequenceAttribute());
//		if (seq) {
//			int itemNumber = seq->whatItemNumberIsList(this);
//			name = seq->buildFullPathInInstanceToCurrentAttribute(dict);
//			name = String_Cat(name,"[");
//			if (itemNumber != 0) {
//				name = String_Cat(name,unsignedIntToCharArrayAsDecimal(itemNumber));
//			}
//			name = String_Cat(name,"]");
//		}
//		name = String_Cat(name,"/");
//		Tag t;
//		if (dict && dict->getTag(keyword,t)) {
//			name = String_Cat(name,Attribute::getCopyOfKeywordOrPrivateTagRepresentation(t,dict));
//		}
//		else {
//			name = String_Cat(name,keyword);
//		}
//		result = EMSGDC_Instance.message(index,name);	// no String_Use() like macro ? memory leak :(
//	}
//	// else return nothing
//	return result;
//}

const char*
AttributeList::EMsgDCF(const char *index,const char *keyword) {
	const char *result = "";
	if (list) {
		char *name = StrDup("");
		ElementDictionary *dict = getDictionary();
		SequenceAttribute *seq = (SequenceAttribute *)(getParentSequenceAttribute());
		if (seq) {
			int itemNumber = seq->whatItemNumberIsList(this);
			name = seq->buildFullPathInInstanceToCurrentAttribute(dict);
			name = String_Cat(name,"[");
			if (itemNumber != 0) {
				name = String_Cat(name,unsignedIntToCharArrayAsDecimal(itemNumber));
			}
			name = String_Cat(name,"]");
		}
		name = String_Cat(name,"/");
		Tag t;
		if (dict && dict->getTag(keyword,t)) {
			name = String_Cat(name,Attribute::getCopyOfKeywordOrPrivateTagRepresentation(t,dict));
		}
		else {
			name = String_Cat(name,keyword);
		}
		result = EMSGDC_Instance.error(index,name);	// no String_Use() like macro ? memory leak :(
	}
	// else return nothing
	return result;
}

const char*
AttributeList::WMsgDCF(const char *index,const char *keyword) {
	const char *result = "";
	if (list) {
		char *name = StrDup("");
		ElementDictionary *dict = getDictionary();
		SequenceAttribute *seq = (SequenceAttribute *)(getParentSequenceAttribute());
		if (seq) {
			int itemNumber = seq->whatItemNumberIsList(this);
			name = seq->buildFullPathInInstanceToCurrentAttribute(dict);
			name = String_Cat(name,"[");
			if (itemNumber != 0) {
				name = String_Cat(name,unsignedIntToCharArrayAsDecimal(itemNumber));
			}
			name = String_Cat(name,"]");
		}
		name = String_Cat(name,"/");
		Tag t;
		if (dict && dict->getTag(keyword,t)) {
			name = String_Cat(name,Attribute::getCopyOfKeywordOrPrivateTagRepresentation(t,dict));
		}
		else {
			name = String_Cat(name,keyword);
		}
		result = EMSGDC_Instance.warning(index,name);	// no String_Use() like macro ? memory leak :(
	}
	// else return nothing
	return result;
}

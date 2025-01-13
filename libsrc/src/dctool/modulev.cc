static const char *CopyrightIdentifier(void) { return "@(#)modulev.cc Copyright (c) 1993-2024, David A. Clunie DBA PixelMed Publishing. All rights reserved."; }
#include "attr.h"
#include "attrlist.h"
#include "attrseq.h"
#include "attrval.h"
#include "elmdict.h"
#include "elmconst.h"
#include "elmtype.h"
#include "binvalc.h"
#include "strvalc.h"
#include "tagvalc.h"
#include "condnc.h"
#include "mesgtext.h"

#include "module.h"

#include "modulec.h"

static void
LogElementAndModule(const char *module,const char *element,/*const Attribute *attr,ElementDictionary *dict,*/
		TextOutputStream& log)
{
	/*if (attr)         log << " " << MMsgDC(Element) << "=<" << String_Use(attr->buildFullPathInInstanceToCurrentAttribute(dict)) << ">";
	else */if (element) log << " " << MMsgDC(Element) << "=<" << element << ">";
	if (module)       log << " " << MMsgDC(Module)  << "=<" << module  << ">";
}

static void
LogElement(const char *element,const Attribute *attr,AttributeList *list,ElementDictionary *dict,
		TextOutputStream& log)
{
	if (attr) {
		log << "<" << String_Use(attr->buildFullPathInInstanceToCurrentAttribute(dict)) << ">";
	}
	else if (element) {
		log << "<";
		if (list) {
			// follow pattern used internally in AttributeList::getParentSequenceAttribute() for the last sequence item list ...
			SequenceAttribute *seq = (SequenceAttribute *)(list->getParentSequenceAttribute());
			if (seq) {
				log << String_Use(seq->buildFullPathInInstanceToCurrentAttribute(dict));
				log << "[";
				int itemNumber = seq->whatItemNumberIsList(list);
				if (itemNumber != 0) {		// zero is flag that it could not be found
					log << itemNumber;
				}
				log << "]/";
			}
			else {
				log << "/";
			}
		}
		//else will not be preceded by "/", indicating no path found ... could do "//" like XPath :(
		log << element;
		Tag tag;
		if (dict && dict->getTag(element,tag)) {
			log << "(";
			writeZeroPaddedHexNumberWithoutShowBase(log,tag.getGroup(),4);
			log << ",";
			writeZeroPaddedHexNumberWithoutShowBase(log,tag.getElement(),4);
			log << ")";
		}
		log << ">";
	}
}

static void
LogModule(const char *module,
		TextOutputStream& log)
{
	if (module)       log << MMsgDC(Module)  << "=<" << module  << ">";
}

static void
ViolationMessage(const char *error,const char *elementtype,
		const char *module,const char *element,const Attribute *attr,AttributeList *list,ElementDictionary *dict,
		bool verbose,bool newformat,TextOutputStream& log)
{
	(void)verbose;
	log << EMsgDC(Null);
	if (newformat) {
		LogElement(element,attr,list,dict,log);
		log << " - " << error << " for " << elementtype << " - ";
		LogModule(module,log);
	}
	else {
		log << error << " " << elementtype;
		LogElementAndModule(module,element,log);
	}
	log << endl;
}

static void
WarningMessage(const char *error,const char *elementtype,
		const char *module,const char *element,const Attribute *attr,AttributeList *list,ElementDictionary *dict,
		bool verbose,bool newformat,TextOutputStream& log)
{
	(void)verbose;
	log << WMsgDC(Null);
	if (newformat) {
		LogElement(element,attr,list,dict,log);
		log << " - " << error << " for " << elementtype << " - ";
		LogModule(module,log);
	}
	else {
		log << error << " " << elementtype;
		LogElementAndModule(module,element,log);
	}
	log << endl;
}

static void
ValidMessage(const char *elementtype,
		const char *module,const char *element,const Attribute *attr,AttributeList *list,ElementDictionary *dict,
		bool verbose,bool newformat,TextOutputStream& log)
{
	if (verbose) {
		log << MMsgDC(ValidElement);
		if (newformat) {
			LogElement(element,attr,list,dict,log);
			log << " for " << elementtype << " - ";
			LogModule(module,log);
		}
		else {
			log << " - " << elementtype;
			LogElementAndModule(module,element,log);
		}
		log << endl;
	}
}

static bool
verifyRequired(Attribute *attr,
	const char *module,const char *element,
	bool verbose,bool newformat,TextOutputStream& log,
	ElementDictionary *dict,
	AttributeList *list,
	Uint32 multiplicityMin,Uint32 multiplicityMax)
{
	// Normalized Required Data Element

	const char *reason=0;
	if (attr) {
		if (attr->getVL() == 0) {
			reason=MMsgDC(EmptyAttribute);
		}
		else {
			if (!attr->verifyVR(module,element,verbose,newformat,log,dict)) {
				reason=MMsgDC(BadValueRepresentation);
			}
			else {
				if (!attr->verifyVM(module,element,verbose,newformat,log,dict,multiplicityMin,multiplicityMax)) {
					reason=MMsgDC(BadAttributeValueMultiplicity);
				}
			}
		}
	}
	else {
		reason=MMsgDC(MissingAttribute);
	}

	if (reason)
		ViolationMessage(reason,MMsgDC(NormalizedRequired),module,element,attr,list,dict,verbose,newformat,log);
	else if (attr)
		ValidMessage(MMsgDC(NormalizedRequired),module,element,attr,list,dict,verbose,newformat,log);

	return !reason;
}

static bool
verifyType1(Attribute *attr,
	const char *module,const char *element,
	bool verbose,bool newformat,TextOutputStream& log,
	ElementDictionary *dict,
	AttributeList *list,
	Uint32 multiplicityMin,Uint32 multiplicityMax)
{
	// Type 1 - Required Data Element

	const char *reason=0;
	if (attr) {
		if (attr->isEmptyOrHasAllEmptyValues()) {
			reason=MMsgDC(EmptyAttribute);
		}
		else {
			if (!attr->verifyVR(module,element,verbose,newformat,log,dict)) {
				reason=MMsgDC(BadValueRepresentation);
			}
			else {
				if (!attr->verifyVM(module,element,verbose,newformat,log,dict,multiplicityMin,multiplicityMax)) {
					reason=MMsgDC(BadAttributeValueMultiplicity);
				}
			}
		}
	}
	else {
		reason=MMsgDC(MissingAttribute);
	}

	if (reason)
		ViolationMessage(reason,MMsgDC(Type1),module,element,attr,list,dict,verbose,newformat,log);
	else if (attr)
		ValidMessage(MMsgDC(Type1),module,element,attr,list,dict,verbose,newformat,log);

	return !reason;
}

static bool
verifyType1C(Attribute *attr,
	const char *module,const char *element,
	bool verbose,bool newformat,TextOutputStream& log,
	ElementDictionary *dict,
	bool (*condition)(AttributeList *,AttributeList *,AttributeList *),
	bool mbpo,
	AttributeList *list,
	AttributeList *parentlist,
	AttributeList *rootlist,
	Uint32 multiplicityMin,Uint32 multiplicityMax)
{
//cerr << "verifyType1C(): " << element << endl;
	// Type 1C - Conditional Data Element

	Assert(list);

	const char *reason=0;
	if (attr) {
//cerr << "verifyType1C(): " << element << " is present" << endl;
		bool conditionNotSatisfied = false;
		if (condition && !(*condition)(list,parentlist,rootlist)) {
			conditionNotSatisfied=true;
			if (!mbpo) {
				ViolationMessage(MMsgDC(AttributePresentWhenConditionUnsatisfiedWithoutMayBePresentOtherwise),
					MMsgDC(Type1C),module,element,attr,list,dict,verbose,newformat,log);
			}
		}
//cerr << "verifyType1C(): " << element << " conditionNotSatisfied = " << conditionNotSatisfied << endl;
//cerr << "verifyType1C(): " << element << " VL = " << attr->getVL() << endl;
//cerr << "verifyType1C(): " << element << " VM = " << attr->getVM() << endl;
//cerr << "verifyType1C(): " << element << " isEmpty() = " << attr->isEmpty() << endl;
//cerr << "verifyType1C(): " << element << " isEmptyOrHasAllEmptyValues() = " << attr->isEmptyOrHasAllEmptyValues() << endl;
		if (attr->isEmptyOrHasAllEmptyValues()) {
			reason= conditionNotSatisfied ? MMsgDC(EmptyAttributeWhenConditionUnsatisfied) : MMsgDC(EmptyAttribute);
		}
		else {
			if (!attr->verifyVR(module,element,verbose,newformat,log,dict)) {
				reason=MMsgDC(BadValueRepresentation);
			}
			else {
				if (!attr->verifyVM(module,element,verbose,newformat,log,dict,multiplicityMin,multiplicityMax)) {
					reason=MMsgDC(BadAttributeValueMultiplicity);
					attr=0;
				}
			}
		}
	}
	else {
		if (condition && (*condition)(list,parentlist,rootlist))
			reason=MMsgDC(MissingAttribute);
	}

	if (reason)
		ViolationMessage(reason,MMsgDC(Type1C),module,element,attr,list,dict,verbose,newformat,log);
	else if (attr)
		ValidMessage(MMsgDC(Type1C),module,element,attr,list,dict,verbose,newformat,log);

	return !reason;
}

static bool
verifyType2 (Attribute *attr,
	const char *module,const char *element,
	bool verbose,bool newformat,TextOutputStream& log,
	ElementDictionary *dict,
	AttributeList *list,
	Uint32 multiplicityMin,Uint32 multiplicityMax)
{
	// Type 2 - Required Data Element (May be Empty)

	const char *reason=0;
	if (attr) {
		if (attr->getVL() == 0) {
			// may be empty
		}
		else {
			if (!attr->verifyVR(module,element,verbose,newformat,log,dict)) {
				reason=MMsgDC(BadValueRepresentation);
			}
			else {
				if (!attr->verifyVM(module,element,verbose,newformat,log,dict,multiplicityMin,multiplicityMax)) {
					reason=MMsgDC(BadAttributeValueMultiplicity);
				}
			}
		}
	}
	else {
		reason=MMsgDC(MissingAttribute);
	}

	if (reason)
		ViolationMessage(reason,MMsgDC(Type2),module,element,attr,list,dict,verbose,newformat,log);
	else if (attr)
		ValidMessage(MMsgDC(Type2),module,element,attr,list,dict,verbose,newformat,log);

	return !reason;
}

static bool
verifyType2C(Attribute *attr,
	const char *module,const char *element,
	bool verbose,bool newformat,TextOutputStream& log,
	ElementDictionary *dict,
	bool (*condition)(AttributeList *,AttributeList *,AttributeList *),
	bool mbpo,
	AttributeList *list,
	AttributeList *parentlist,
	AttributeList *rootlist,
	Uint32 multiplicityMin,Uint32 multiplicityMax)
{
	// Type 2C - Conditional Data Element (May be Empty)

	Assert(list);

	const char *reason=0;
	if (attr) {
		if (condition && !(*condition)(list,parentlist,rootlist)) {
			if (!mbpo) {
				ViolationMessage(MMsgDC(AttributePresentWhenConditionUnsatisfiedWithoutMayBePresentOtherwise),
					MMsgDC(Type2C),module,element,attr,list,dict,verbose,newformat,log);
			}
		}
		if (attr->getVL() == 0) {
			// may be empty
		}
		else {
			if (!attr->verifyVR(module,element,verbose,newformat,log,dict)) {
				reason=MMsgDC(BadValueRepresentation);
			}
			else {
				if (!attr->verifyVM(module,element,verbose,newformat,log,dict,multiplicityMin,multiplicityMax)) {
					reason=MMsgDC(BadAttributeValueMultiplicity);
				}
			}
		}
	}
	else {
		if (condition && (*condition)(list,parentlist,rootlist))
			reason=MMsgDC(MissingAttribute);
	}

	if (reason)
		ViolationMessage(reason,MMsgDC(Type2C),module,element,attr,list,dict,verbose,newformat,log);
	else if (attr)
		ValidMessage(MMsgDC(Type2C),module,element,attr,list,dict,verbose,newformat,log);

	return !reason;
}

static bool
verifyType3 (Attribute *attr,
	const char *module,const char *element,
	bool verbose,bool newformat,TextOutputStream& log,
	ElementDictionary *dict,
	AttributeList *list,
	Uint32 multiplicityMin,Uint32 multiplicityMax)
{
	// Type 3 - Optional Data Element

	const char *reason=0;
	if (attr) {
		if (attr->getVL() == 0) {
			// may be empty
		}
		else {
			if (!attr->verifyVR(module,element,verbose,newformat,log,dict)) {
				reason=MMsgDC(BadValueRepresentation);
			}
			else {
				if (!attr->verifyVM(module,element,verbose,newformat,log,dict,multiplicityMin,multiplicityMax)) {
					reason=MMsgDC(BadAttributeValueMultiplicity);
				}
			}
		}
	}
	else {
		// May be absent
	}

	if (reason)
		ViolationMessage(reason,MMsgDC(Type3),module,element,attr,list,dict,verbose,newformat,log);
	else if (attr)
		ValidMessage(MMsgDC(Type3),module,element,attr,list,dict,verbose,newformat,log);

	return !reason;
}

static bool
verifyType3C(Attribute *attr,
	const char *module,const char *element,
	bool verbose,bool newformat,TextOutputStream& log,
	ElementDictionary *dict,
	bool (*condition)(AttributeList *,AttributeList *,AttributeList *),
	// mbpo never applies
	AttributeList *list,
	AttributeList *parentlist,
	AttributeList *rootlist,
	Uint32 multiplicityMin,Uint32 multiplicityMax)
{
	// Type 3C - Optional Data Element that can only be present when condition is true

	Assert(list);

	const char *reason=0;
	if (attr) {
		if (condition && !(*condition)(list,parentlist,rootlist)) {
			WarningMessage(MMsgDC(Unexpected),
				MMsgDC(Type3C),module,element,attr,list,dict,verbose,newformat,log);
		}
		if (attr->getVL() == 0) {
			// may be empty
		}
		else {
			if (!attr->verifyVR(module,element,verbose,newformat,log,dict)) {
				reason=MMsgDC(BadValueRepresentation);
			}
			else {
				if (!attr->verifyVM(module,element,verbose,newformat,log,dict,multiplicityMin,multiplicityMax)) {
					reason=MMsgDC(BadAttributeValueMultiplicity);
					attr=0;
				}
			}
		}
	}
	else {
		// May be absent
	}

	if (reason)
		ViolationMessage(reason,MMsgDC(Type3C),module,element,attr,list,dict,verbose,newformat,log);
	else if (attr)
		ValidMessage(MMsgDC(Type3C),module,element,attr,list,dict,verbose,newformat,log);

	return !reason;
}

#include "modulev.h"




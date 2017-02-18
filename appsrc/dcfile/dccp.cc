static const char *CopyrightIdentifier(void) { return "@(#)dccp.cc Copyright (c) 1993-2015, David A. Clunie DBA PixelMed Publishing. All rights reserved."; }
#include "attrmxls.h"
#include "attrseq.h"
#include "mesgtext.h"
#include "dcopt.h"
#include "elmconst.h"

void
keepOnlySelectedLUTSequenceItem(AttributeList &list,Tag lutSequenceTag,int whichLUTItemToKeep,TextOutputStream &log) {
	Attribute *aLUTSequence = list[lutSequenceTag];
	if (aLUTSequence) {
		AttributeList **items;
		int nLUTItems=aLUTSequence->getLists(&items);
		if (whichLUTItemToKeep >= 0 && whichLUTItemToKeep < nLUTItems) {
			AttributeList *itemToKeep = items[whichLUTItemToKeep];
			SequenceAttribute *newLUTSequence = new SequenceAttribute(lutSequenceTag);
			Assert(newLUTSequence);
			(*newLUTSequence)+=itemToKeep;
			list-=lutSequenceTag;
			list+=newLUTSequence;
		}
		else {
			log << WMsgDC("Missing LUT Sequence Item") << " - " << lutSequenceTag << " # " << whichLUTItemToKeep << endl;
		}
	}
	else {
		log << WMsgDC("Missing LUT Sequence") << " - " << lutSequenceTag << endl;
	}
}

// writeTagNumberAndNameToLog is copied from appsrc/dcfile/dciodvfy.cc
// Similar to TextOutputStream& Tag::write(TextOutputStream& stream,ElementDictionary *dict) in libsrc/src/dctool/attrtag.cc
// but without the VR

static void writeTagNumberAndNameToLog(Tag tag,ElementDictionary *dict,TextOutputStream &log) {
	log << "(";
	writeZeroPaddedHexNumber(log,tag.getGroup(),4);
	log << ",";
	writeZeroPaddedHexNumber(log,tag.getElement(),4);
	log << ")";
	const char *desc = NULL;
	if (dict) {
		desc = dict->getDescription(tag);
	}
	if (desc && strlen(desc) > 0 && strcmp(desc,"?") != 0) {
		log << " " << desc;
	}
}

static void writeTagNumberAndNameToLog(Attribute *a,ElementDictionary *dict,TextOutputStream &log) {
	writeTagNumberAndNameToLog(a->getTag(),dict,log);
}

// loopOverListsInSequencesWithLog is copied from libsrc/src/dctool/attrmxls.cc

static bool
loopOverListsInSequencesWithLog(Attribute *a,TextOutputStream &log,
		bool (*func)(AttributeList &,TextOutputStream &))
{
	bool succeeded=true;
	if (strcmp(a->getVR(),"SQ") == 0) {
		AttributeList **al;
		int n;
		if ((n=a->getLists(&al)) > 0) {
			int i;
			for (i=0; i<n; ++i) {
				if (!(*func)(*al[i],log)) succeeded=false;
			}
			delete [] al;
		}
	}
	return succeeded;
}

static bool
fixBadDecimalSeparator(AttributeList &list,TextOutputStream &log) {
	bool success=true;
	AttributeListIterator listi(list);
	while (!listi) {
		Attribute *a=listi();
		Assert(a);
		if (strcmp(a->getVR(),"DS") == 0) {
			int vm = a->getVM();
			int i;
			for (i=0; i<vm; ++i) {
				char *value;
				a->getValue(i,value);
				bool changedsomething=false;
				char *p = value;
				while (*p != 0) {
					if (*p == ',') {
						*p='.';
						changedsomething=true;
					}
					++p;
				}
				if (changedsomething) {
					log << WMsgDC(FixingBadDecimalSeparator) << " in DS VR - ";
					writeTagNumberAndNameToLog(a,list.getDictionary(),log);
					log << " - new value " << (i+1) << " is \"" << value << "\"" << endl;
					a->setValue(i,value);
				}
			}
		}
		if (!::loopOverListsInSequencesWithLog(a,log,&::fixBadDecimalSeparator)) {
			success=false;
		}
		++listi;
	}
	return success;
}

int
main(int argc, char *argv[])
{
	GetNamedOptions 	options(argc,argv);
	DicomInputOptions 	dicom_input_options(options);
	DicomOutputOptions 	dicom_output_options(options);

	bool verbose=options.get("verbose") || options.get("v");
	bool ignorereaderrors=options.get("ignorereaderrors");
	bool removecommandgroup=options.get("removecommandgroup");
	bool fixbaddecimalseparator=options.get("fixbaddecimalseparator");

	int whichVOILUTitem=0;
	bool selectVOILUTitem=options.get("selectvoilutitem",whichVOILUTitem);

	dicom_input_options.done();
	dicom_output_options.done();
	options.done();

	DicomInputOpenerFromOptions input_opener(
		options,dicom_input_options.filename,cin);
	DicomOutputOpenerFromOptions output_opener(
		options,dicom_output_options.filename,cout);

	cerr << dicom_input_options.errors();
	cerr << dicom_output_options.errors();
	cerr << options.errors();
	cerr << input_opener.errors();
	cerr << output_opener.errors();

	if (!dicom_input_options.good()
	 || !dicom_output_options.good()
	 || !options.good()
	 || !input_opener.good()
	 || !output_opener.good()
	 || !options) {
		cerr 	<< MMsgDC(Usage) << ": " << options.command()
			<< dicom_input_options.usage()
			<< dicom_output_options.usage()
			<< " [-v|-verbose]"
			<< " [-ignorereaderrors]"
			<< " [-removecommandgroup]"
			<< " [-selectvoilutitem 0..n-1]"
			<< " [-fixbaddecimalseparator]"
			<< " [" << MMsgDC(InputFile)
				<< "[" << MMsgDC(OutputFile) << "]]"
			<< " <" << MMsgDC(InputFile)
			<< " >" << MMsgDC(OutputFile)
			<< endl;
		exit(1);
	}

	DicomInputStream din(*(istream *)input_opener,
		dicom_input_options.transfersyntaxuid,
		dicom_input_options.usemetaheader);
	DicomOutputStream dout(*(ostream *)output_opener,
		dicom_output_options.transfersyntaxuid,
		dicom_output_options.usemetaheader,
		dicom_output_options.useimplicitmetaheader,
		dicom_output_options.addtiff);

	ManagedAttributeList list;

	bool success=true;
	TextOutputStream  log(cerr);
	if (verbose) log << "******** While reading ... ********" << endl; 
	list.read(din,&log,verbose,0xffffffff,true,dicom_input_options.uselengthtoend,dicom_input_options.ignoreoutofordertags,dicom_input_options.useUSVRForLUTDataIfNotExplicit);

	if (!list.good()) {
		if (!ignorereaderrors) {
			log << list.errors();
			success=false;
		}
		log << EMsgDC(DatasetReadFailed) << endl;
	}

	if (success) {
		// Don't write list warnings yet ...
		// done in usualManagedAttributeListWrite ...
		
		if (removecommandgroup) {
			list.removeCommandGroup();
		}
		
		if (selectVOILUTitem) {
			keepOnlySelectedLUTSequenceItem(list,TagFromName(VOILUTSequence),whichVOILUTitem,log);
		}
		
		if (fixbaddecimalseparator) {
			fixBadDecimalSeparator(list,log);
		}

		if (!usualManagedAttributeListWrite(list,dout,
			dicom_output_options,log,verbose)) success=false;
	}

	return success ? 0 : 1;
}

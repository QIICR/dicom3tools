/* attrmxls.h Copyright (c) 1993-2015, David A. Clunie DBA PixelMed Publishing. All rights reserved. */
#ifndef __Header_attrmxls__
#define __Header_attrmxls__

#include "attr.h"
#include "attrlist.h"
#include "elmdict.h"

#include "errclass.h"

class SequenceAttribute;

class ReadableAttributeList : public AttributeList, public ErrorsInClass {
private:
	DicomInputStream *	stream;
	TextOutputStream *	log;
	bool			verbose;
	Uint32 			byteoffset;

	TextOutputStream& 	writebase(const Tag tag,const char *vr,
					Uint32 vl);
	
	const char *	getValueRepresentation(Tag tag,char *vre,bool& readAsImplicitRegardless);
	Uint32			getValueLength(const char *vr,bool readAsImplicitRegardless);
	void			skipEncapsulatedData(void);
	SequenceAttribute *	readNewSequenceAttribute(Tag tag,Uint32 length,bool ignoreoutofordertags,bool useUSVRForLUTDataIfNotExplicit,bool undefinedLengthUNTreatedAsSequence,const char *sequenceOwner,bool fixBitsDuringRead,bool havePixelRepresentation,Uint16 vPixelRepresentation);
	bool			replaceWithPixelRepresentation(
					const Tag &t,const char *name,
					bool havePixelRepresentation,bool usesigned);
protected:
	bool			setValueRepresentationForThisList(bool havePixelRepresentation,Uint16 vPixelRepresentation);
	bool			setValueRepresentationForThisListAndNestedSequences(bool havePixelRepresentation,Uint16 vPixelRepresentation);
	bool			setValueRepresentationForThisListAndNestedSequences();
public:
	ReadableAttributeList(void);
	virtual ~ReadableAttributeList();

	bool read(DicomInputStream& stream,
		ElementDictionary* dict,
		TextOutputStream *log=0,
		bool verbose=false,
		Uint32 length=0xffffffff,
		bool metaheadercheck=true,
		bool uselengthtoend=false,
		bool ignoreoutofordertags=false,
		bool useUSVRForLUTDataIfNotExplicit=false,
		bool forceImplicit=false,
		bool useStopAtTag=false,
		Tag stopAtTag=Tag(0,0),
		bool nestedWithinSequence=false,
		const char *sequenceOwner=NULL,
		bool fixBitsDuringRead=true,
		bool havePixelRepresentation=false,
		Uint16 vPixelRepresentation=0
		);

	Uint32		   getByteOffset(void) const { return byteoffset; }
};

class ManagedAttributeList : public ReadableAttributeList {
public:
	enum flag_types {
		none = 0,
		metaheader = 1,			// write metaheader (not just dataset)
		addlengths = 2,
		removeprivate = 4,
		removeinstanceuid = 8,
		adddicom = 16,
		adddisclaimer = 32,
		addlengthtoend = 64,
		addtiff = 128,
		dataset = 256,		// write dataset (not just metaheader)
		disambiguateseriesbydescription = 512 };
private:
	friend class TextOutputStream& operator<<
		(TextOutputStream& stream,ManagedAttributeList& list);
	friend class DicomOutputStream& operator<<
		(DicomOutputStream& stream,ManagedAttributeList& list);

	flag_types flags;
	const char *uidstamp;
	const char *instanceCreationDate;
	const char *instanceCreationTime;
	const char *timezoneOffsetFromUTC;
	DicomOutputStream *preparedstream;

	bool removeLengths(void);
	bool removeMetaHeader(bool leaveuid);
	bool removeInstanceUID(void);
	bool removePrivate(void);
	bool addMetaHeader(TransferSyntax *datats,const char *stamp);
	bool addDicom(bool disambiguateseriesbydescription);
	bool addDisclaimer(void);
	bool addLengths(
		TransferSyntax *metats,TransferSyntax *datats,
		bool allgroups,bool toend);
	bool addTiffTrailer(DicomOutputStream& stream,bool metaflag);
	bool setOutputEncoding(TransferSyntax *datats);
public:
	ManagedAttributeList(void);
	virtual ~ManagedAttributeList();

	void removeCommandGroup(void);

	bool clean(flag_types fset=none,flag_types freset=none);

	bool prepare(DicomOutputStream& stream,
		flag_types fset=none,flag_types freset=none,
		const char *stamp=0,
		const char *creationDate=0,
		const char *creationTime=0,
		const char *tzOffset=0);

	bool finalize(DicomOutputStream& stream);

	bool read(DicomInputStream& stream,
		TextOutputStream *log=0,
		bool verbose=false,
		Uint32 length=0xffffffff,
		bool metaheadercheck=true,
		bool uselengthtoend=false,
		bool ignoreoutofordertags=false,
		bool useUSVRForLUTDataIfNotExplicit=false,
		bool useStopAtTag=false,
		Tag stopAtTag=Tag(0,0),
		bool fixBitsDuringRead=true);

	DicomOutputStream& write(DicomOutputStream& stream);
	TextOutputStream&  write(TextOutputStream& stream,bool verbose=false,bool showUsedAndIE=false);

	bool validateVR(TextOutputStream &log);
	bool validateRetired(TextOutputStream &log);
	bool validateUsed(TextOutputStream &log);
	bool validatePrivate(TextOutputStream &log);

	flag_types set(flag_types f)	{ return flags=flag_types(flags|f); }
	flag_types reset(flag_types f)	{ return flags=flag_types(flags&~f); }

	void 		setUIDStamp(const char *s)	{ uidstamp=s; }
	const char *	getUIDStamp(void) const		{ return uidstamp; }
	
	const char *getInstanceCreationDate(void)	{ return instanceCreationDate; }
	const char *getInstanceCreationTime(void)	{ return instanceCreationTime; }
	const char *getTimezoneOffsetFromUTC(void)	{ return timezoneOffsetFromUTC; }
};

#endif /* __Header_attrmxls__ */



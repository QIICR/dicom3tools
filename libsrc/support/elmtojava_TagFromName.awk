#  elmtojava_TagFromName.awk Copyright (c) 1993-2024, David A. Clunie DBA PixelMed Publishing. All rights reserved.
# create XML from element dictionary template 

NR==1	{
	print "/* Copyright (c) 2001-2017, David A. Clunie DBA Pixelmed Publishing. All rights reserved. */"
	print ""
	print "// Automatically generated from template - EDITS WILL BE LOST"
	print ""
	print "package com.pixelmed.dicom;"
	print ""
	print "public class TagFromName {"
	print ""
	print "private static final String identString = \"@(#) $Header: /userland/cvs/dicom3tools/libsrc/support/elmtojava_TagFromName.awk,v 1.13 2024/02/22 23:21:48 dclunie Exp $\";"
	print ""
}

/^[ 	]*[#]/	{}

/^[ 	]*[(]/ {

	match($0,"[(][0-9a-fA-FxX][0-9a-fA-FxX][0-9a-fA-FxX][0-9a-fA-FxX],");
	group=substr($0,RSTART+1,4);

	match($0,",[0-9a-fA-FxX][0-9a-fA-FxX][0-9a-fA-FxX][0-9a-fA-FxX]");
	element=substr($0,RSTART+1,4);

	match($0,"Keyword=\"[^\"]*\"")
	keyword=substr($0,RSTART+length("Keyword=\""),
		RLENGTH-length("Keyword=\"")-1);

	#print "\t@Deprecated"
	print "\tstatic public AttributeTag " keyword " = new AttributeTag(0x" group ",0x" element ");"
}

END {
	print "}"
}


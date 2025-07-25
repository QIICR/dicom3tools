#  elmdict.awk Copyright (c) 1993-2024, David A. Clunie DBA PixelMed Publishing. All rights reserved.
# create C++ code from element dictionary template 

NR==1	{
	print "// Automatically generated from template - EDITS WILL BE LOST"
	print ""
	print "// Generated by elmdict.awk with options " role " " outname
	print ""

	if (role == "constant") {
		print "#ifndef __Header_" outname "__"
		print "#define __Header_" outname "__"
		print ""
	}
	else if (role == "table") {
		print "#ifndef __Header_" outname "__"
		print "#define __Header_" outname "__"
		print ""
		print "static ElementDictionaryTableEntry"
		print "\t\tElementDictionaryTable[] = {"
	}
	else {
		print "Error - role " role " invalid" >"/dev/tty"
		exit 1
	}

	}

/^[ 	]*[#]/	{}

/^[ 	]*[(]/ {

	match($0,"[(][0-9a-fA-FxX][0-9a-fA-FxX][0-9a-fA-FxX][0-9a-fA-FxX],");
	group=substr($0,RSTART+1,4);

	match($0,",[0-9a-fA-FxX][0-9a-fA-FxX][0-9a-fA-FxX][0-9a-fA-FxX]");
	element=substr($0,RSTART+1,4);

	owner=""
	if (match($0,"Owner=\"[^\"]*\""))
		owner=substr($0,RSTART+length("Owner=\""),
			RLENGTH-length("Owner=\"")-1);

	privateblock="0000"	# only 0010 to 00ff are valid
	if (match($0,"PrivateBlock=\"[^\"]*\""))
		privateblock=substr($0,RSTART+length("PrivateBlock=\""),
			RLENGTH-length("PrivateBlock=\"")-1);

	# Transformations must match those in dictionary ... see elmdict.awk,elmdict.tpl,attrtag.cc

	# Note that some are from element 0xxx00 and others from 0xxx10

	if (group == "0020" && element == "31xx") element="3100";	# PS 300 - Source Image IDs

	if (group == "0028" && element == "04x0") element="0410";	# PS 2 - RowsForNthOrderCoefficients
	if (group == "0028" && element == "04x1") element="0411";	# PS 2 - ColumnsForNthOrderCoefficients
	if (group == "0028" && element == "04x2") element="0412";	# PS 2 - CoefficientCoding
	if (group == "0028" && element == "04x3") element="0413";	# PS 2 - CoefficientCodingPointers

	if (group == "0028" && element == "08x0") element="0800";	# PS 2 - CodeLabel
	if (group == "0028" && element == "08x2") element="0802";	# PS 2 - NumberOfTables
	if (group == "0028" && element == "08x3") element="0803";	# PS 2 - CodeTableLocation
	if (group == "0028" && element == "08x4") element="0804";	# PS 2 - BitsForCodeWord
	if (group == "0028" && element == "08x8") element="0808";	# PS 2 - ImageDataLocation

	if (group == "1000" && element == "00x0") element="0010";	# PS 2 - Escape Triplet
	if (group == "1000" && element == "00x1") element="0011";	# PS 2 - Run Length Triplet
	if (group == "1000" && element == "00x2") element="0012";	# PS 2 - Huffman Table Size
	if (group == "1000" && element == "00x3") element="0013";	# PS 2 - Huffman Table Triplet
	if (group == "1000" && element == "00x4") element="0014";	# PS 2 - Shift Table Size
	if (group == "1000" && element == "00x5") element="0015";	# PS 2 - Shift Table Triplet

	if (group == "1010" && element == "xxxx") element="0004";	# PS 2 - Zonal Map (0x0004 to 0xfffe)

	if (group == "50xx") group="5000";				# PS 3 - Curve stuff

	if (group == "60xx") {
		if (owner == "")
			group="6000";					# PS 3 and earlier - Overlay stuff
		else
			group="6001";					# For Papyrus annotations
	}

	if (group == "70xx") {
		if (owner == "")
			group="7000";					# Not actually in use
		else
			group="7001";					# Private DLX TextAnnotaion etc.
	}

	if (group == "7Fxx") group="7F00";				# PS 2 - VariablePixelData

	match($0,"Keyword=\"[^\"]*\"")
	keyword=substr($0,RSTART+length("Keyword=\""),
		RLENGTH-length("Keyword=\"")-1);

	match($0,"Name=\"[^\"]*\"")
	name=substr($0,RSTART+length("Name=\""),
		RLENGTH-length("Name=\"")-1);

	match($0,"VR=\"[^\"]*\"");
	vr=substr($0,RSTART+length("VR=\""),RLENGTH-length("VR=\"")-1);
	if (vr == "US or SS") vr= "XS";
	if (vr == "US or OW") vr= "XO";
	if (vr == "US or SS or OW") vr= "XO";
	if (vr == "US\\US or SS\\US") vr = "XS";
	if (vr == "OW/OB") vr = "OX";

	match($0,"VM=\"[^\"]*\"");
	vm=substr($0,RSTART+length("VM=\""),RLENGTH-length("VM=\"")-1);
	if (vm == "") vm=0;
	vmmin=vmmax=vm;
	if (vm == "n") {
		vmmin=1;
		vmmax="VMUNLIMITED";
	}
	if (match(vm,"-")) {
#print "Matched vm with - " vm >"/dev/tty"
		match(vm,"[0-9]*-");
		vmmin=substr(vm,RSTART,RLENGTH-1);
#print "Matched vmmin = " vmmin >"/dev/tty"
		match(vm,"-[0-9n]*");
		vmmax=substr(vm,RSTART+1,RLENGTH-1);
#print "Matched vmmax = " vmmax >"/dev/tty"
		if (match(vmmax,"[0-9]*n")) vmmax="VMUNLIMITED";		# handle 2-2n, 3-3n, etc. as if just 2-n, 3-n, etc.
#print "Set vmmax to " vmmax >"/dev/tty"
	}

	match($0,"VERS=\"[^\"]*\"");
	version=substr($0,RSTART+length("VERS=\""),RLENGTH-length("VERS=\"")-1);
	
	if (match(version,"RET")) {
		retired="true"
	}
	else {
		retired="false"
	}

	renderAsString="false"
	if (match($0,"RenderAsString=\"[^\"]*\""))
		renderAsString=substr($0,RSTART+length("RenderAsString=\""),
			RLENGTH-length("RenderAsString=\"")-1);

	if (renderAsString == "true" && vr != "OB") {
		print "Warning - (0x" group ",0x" element ",\"" owner "\") renderAsString only valid for OB VR not " vr >"/dev/tty"
	}

	if (role == "constant") {
		if (owner == "") {
			print "#define\t" keyword "_GROUP\t0x" group
			print "#define\t" keyword "_ELEMENT\t0x" element
		}
	}
	else if (role == "table") {
		print "\t0x" group ",0x" element ",0x" privateblock ",\"" vr "\"," vmmin "," vmmax ",\"" owner "\",\"" keyword "\",\"" name "\"," retired "," renderAsString ","
	}

	}

END {
	if (role == "constant") {
		print ""
		print "#endif /* __Header_" outname "__ */"
	}
	if (role == "table") {
		print "\t0, 0, 0, NULL, 0, 0, NULL, NULL, NULL, false, false"
		print "};"
		print ""
		print "#endif /* __Header_" outname "__ */"
	}
}


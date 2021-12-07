#  unkelm.awk Copyright (c) 1993-2021, David A. Clunie DBA PixelMed Publishing. All rights reserved.
/^\([0-9A-Fa-fxX]/ {

	element=$1

	owner=""
	if (match($0,"Owner=\"[^\"]*\""))
		owner=substr($0,RSTART+length("Owner=\""),
			RLENGTH-length("Owner=\"")-1);

	keyword=""
	if (match($0,"Keyword=\"[^\"]*\""))
		keyword=substr($0,RSTART+length("Keyword=\""),
			RLENGTH-length("Keyword=\"")-1);

	privateblock=""
	if (match($0,"PrivateBlock=\"[^\"]*\""))
		privateblock=substr($0,RSTART+length("PrivateBlock=\""),
			RLENGTH-length("PrivateBlock=\"")-1);

	if (length(keyword) == 0 || keyword == "?") {
		print owner "\t" element "\t" privateblock
	}
}


#  wordpart6tabletotpl.awk Copyright (c) 1993-2015, David A. Clunie DBA PixelMed Publishing. All rights reserved.
{FS="|"; keyword=$4; gsub("[ -]*","",keyword); print $1 " VERS=\"3MR\"  VR=\"" $2 "\"   VM=\"" $3 "\"	Keyword=\"" keyword "\"	Name=\"" $5 "\"";}

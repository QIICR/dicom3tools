/* elmpriv.h Copyright (c) 1993-2015, David A. Clunie DBA PixelMed Publishing. All rights reserved. */
#ifndef __Header_elmpriv__
#define __Header_elmpriv__

#include "listsimp.h"

class PrivateOwners : public SimpleList<TagAndOwnerAndBlock *> {
public:
	PrivateOwners(void) : SimpleList<TagAndOwnerAndBlock *>() {}
	~PrivateOwners() {}

	const char *	operator[](Tag tag);

	void	operator+=(const TagAndOwnerAndBlock& to);
};

#endif /* __Header_elmpriv__ */

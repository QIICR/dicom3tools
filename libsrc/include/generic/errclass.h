/* errclass.h Copyright (c) 1993-2015, David A. Clunie DBA PixelMed Publishing. All rights reserved. */
#ifndef __Header_errclass__
#define __Header_errclass__

#if USESTANDARDHEADERSWITHOUTEXTENSION == 1
#include <iomanip>
#else
#include <iomanip.h>
#endif

#if EMITUSINGSTDNAMESPACE == 1
using namespace std;
#endif

class ErrorsInClass {
private:
	char *			errorstring;
protected:
	bool 			good_flag;
	ostrstream 		errorstream;
public:
	ErrorsInClass(void)
		{
			good_flag=true;
			errorstring=0;
			errorstream.setf(std::ios::showbase|std::ios::internal);
		}

	~ErrorsInClass()
		{
			if (errorstring) delete[] errorstring;
		}

	bool		good(void)	{ return good_flag; }

	const char *	errors(void)
		{
			errorstream << ends;
			errorstring=errorstream.str();
			return errorstring ? errorstring : "";
		}
};

#endif /* __Header_errclass__ */

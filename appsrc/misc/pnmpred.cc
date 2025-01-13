static const char *CopyrightIdentifier(void) { return "@(#)pnmpred.cc Copyright (c) 1993-2024, David A. Clunie DBA PixelMed Publishing. All rights reserved."; }
#if USESTANDARDHEADERSWITHOUTEXTENSION == 1
#include <cctype>	// for isdigit()
#else
#include <ctype.h>	// for isdigit()
#endif

#if EMITUSINGSTDNAMESPACE == 1
using namespace std;
#endif

#include "basetype.h"
#include "txstream.h"
#include "ioopt.h"
#include "mesgtext.h"

static
char
pnm_getc(istream &istr)		// 1st non-comment, non-whitespace, 0 on failure
{
	char c;
	while (istr.get(c) && (c == ' ' || c == '\t' || c == '\n'));
	if (!istr) return 0;
	if (c == '#') {		// skip comments
		while (istr.get(c) && c != '\n');
		if (!istr) return 0;
		while (istr.get(c) && (c == ' ' || c == '\t' || c == '\n'));
		if (!istr) return 0;
	}
	return c;
}

static
int
pnm_getu(istream &istr)		// get unsigned value, -1 on failure
{
	char c=pnm_getc(istr);	// skips comments and whitespace
	if(!c || !isdigit(c)) return -1;
	unsigned value=0;
	while (c && isdigit(c)) {
		value*=10;
		value+=(c-'0');
		istr.get(c);
	}
	// discards single trailing white space
	return value;
}

static
Uint16
pnm_geti(istream &istr,Uint16 wordlength)	// get image data value
{
	unsigned char c[2];
	istr.read((char *)c,wordlength);
	Uint16 value;
	// PNM format is little-endian ...
	if (wordlength == 2)
		value=(c[1]<<8)+c[0];
	else
		value=c[0];
	return value;
}

static
void
pnm_puti(ostream &ostr,Uint16 value,Uint16 wordlength)
							// put image data value
{
	unsigned char c[2];
	// PNM format is little-endian ...
	if (wordlength == 2) {
		c[0]=value&0xff;
		c[1]=value>>8;
	}
	else
		c[0]=value;
	ostr.write((char *)c,wordlength);
}

int
main(int argc,char **argv)
{
	bool bad=false;

	GetNamedOptions 	options(argc,argv);
	InputOptions		input_options(options);
	OutputOptions	 	output_options(options);

	bool verbose=options.get("verbose") || options.get("v");

	input_options.done();
	output_options.done();
	options.done();

	InputOpenerFromOptions input_opener(
		options,input_options.filename,cin);
	OutputOpenerFromOptions output_opener(
		options,output_options.filename,cout);

	cerr << input_options.errors();
	cerr << output_options.errors();
	cerr << options.errors();
	cerr << input_opener.errors();
	cerr << output_opener.errors();

	if (!input_options.good()
	 || !output_options.good()
	 || !options.good()
	 || !input_opener.good()
	 || !output_opener.good()
	 || !options
	 || bad) {
		cerr 	<< MMsgDC(Usage) << ": " << options.command()
			<< input_options.usage()
			<< output_options.usage()
			<< " [-v|-verbose]"
			<< " [" << MMsgDC(InputFile)
				<< "[" << MMsgDC(OutputFile) << "]]"
			<< " <" << MMsgDC(InputFile)
			<< " >" << MMsgDC(OutputFile)
			<< endl;
		exit(1);
	}

	istream in(input_opener);
	ostream out(output_opener);

	TextOutputStream log (cerr);

	char magic=pnm_getc(in);
	char format;
	in.get(format);

	if (!in || magic != 'P') {
		log << EMsgDC(UnrecognizedFormat) << " - 'Pn' "
		    << MMsgDC(NotFound) << endl;
		return 1;
	}

	unsigned samplesperpixel;
	switch (format) {
		case '1':	// text PBM
		case '2':	// text PGM
		case '3':	// text PPM
		case '4':	// raw PBM
			log << EMsgDC(Unsupported) << " - 'P"
			    << format << "'"
			    << endl;
			return 1;
			//break;
		case '5':	// raw PGM
			samplesperpixel=1;
			break;
		case '6':	// raw PPM
			samplesperpixel=3;
			break;
		default:
			log << EMsgDC(UnrecognizedFormat) << " - 'P"
			    << format << "'"
			    << endl;
			return 1;
			//break;
	}

	int width = pnm_getu(in);
	int height = pnm_getu(in);
	int maxval = pnm_getu(in);

	if (verbose) {
		log << "format P" << format << endl;
		log << "width " << dec << width << endl;
		log << "height " << dec << height << endl;
		log << "maxval " << dec << maxval << endl;
	}

	if (!in || width == -1 || height == -1 || maxval == -1) {
		log << EMsgDC(UnrecognizedFormat) << endl;
		return 1;
	}

	// Write new PNM header ...

	{
		ostrstream ost;
		ost << "P" << format << "\n" << width << " " << height << "\n"
		    << ((maxval <= 0xff) ? 0xff : 0xffff) << "\n" << '\0';
		char *str=ost.str();
		out.write(str,strlen(str));
		delete str;
	}

	// Last whitespace discarded ... at start of data

	unsigned wordlength = (maxval <= 255) ? 1 : 2;
	Uint16 signmask = (wordlength == 1) ? 0x80 : 0x8000;
	unsigned rowlength=width*samplesperpixel;
	Uint16 *buffer1=new Uint16[rowlength];
	Uint16 *buffer2=new Uint16[rowlength];
	Uint16 *obuffer=new Uint16[rowlength];
	Assert(buffer1);
	Assert(buffer2);
	Assert(obuffer);

	Uint16 *thisrow=buffer1;
	Uint16 *lastrow=0;

	while (height--) {
		Uint16 *ptr;
		unsigned i;
		for (i=0,ptr=thisrow; i<rowlength; ++i) *ptr++=pnm_geti(in,wordlength);
		if (!in) {
			log << EMsgDC(ReadFailed) << endl;
			return 1;
		}

		Uint16 *optr;
		Uint16 *lptr;
		for (i=0,ptr=thisrow,optr=obuffer,lptr=0; i<width; ++i) {
			unsigned s;
			for (s=0; s<samplesperpixel; ++s) {
				optr[s]=(lptr ? ptr[s]-lptr[s] : ptr[s]) ^ signmask;
			}
			lptr=ptr;
			ptr+=samplesperpixel;
			optr+=samplesperpixel;
		}

		for (i=0,optr=obuffer; i<rowlength; ++i) pnm_puti(out,*optr++,wordlength);
		if (!out) {
			log << EMsgDC(WriteFailed) << endl;
			return 1;
		}
	}

	return 0;
}


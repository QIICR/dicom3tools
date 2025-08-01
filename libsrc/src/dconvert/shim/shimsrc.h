/* shimsrc.h Copyright (c) 1993-2024, David A. Clunie DBA PixelMed Publishing. All rights reserved. */
#ifndef __Header_shimsrc__
#define __Header_shimsrc__

class SHIM_PixelDataSource : public SourceBase<Uint16> {
	istream *istr;
	long offset;
	Uint16 rows;
	Uint16 columns;
	Uint16 row;
	Uint16 col;
	Uint16 *buffer;
public:
	SHIM_PixelDataSource(istream& i,long off,Uint16 r,Uint16 c)
			: SourceBase<Uint16>()
		{
			istr=&i;
			offset=off;
			rows=r;
			Assert(rows);
			columns=c;
			Assert(columns);
			row=0;
			col=0;
			buffer=new Uint16[columns];
			Assert(buffer);
		}

	~SHIM_PixelDataSource()
		{
			if (buffer) delete[] buffer;
		}

	size_t read(void)
		{
			if (row == 0) {
				Assert(istr);
				istr->seekg(offset,ios::beg);
			}
			col=0;
			if (!istr->good() || row++ >= rows) return 0;
			Uint16 *ptr=buffer;
			while (col < columns) {
				unsigned char bytes[2];
				istr->read((char *)bytes,2);
				if (!istr->good()) return 0;
				// Big endian ...
				Uint16 pixel;
				pixel=(bytes[0]<<8)|bytes[1];
				*ptr++=pixel; ++col;
			}
			return col;
		}

	const Uint16 *getBuffer(void)		{ return buffer; }
	size_t getBufferCount(void) const	{ return col; }

	int good(void) const	{ return istr && istr->good() && row < rows; }
};

#endif // __Header_shimsrc__

/* attrtypn.h Copyright (c) 1993-2024, David A. Clunie DBA PixelMed Publishing. All rights reserved. */
#ifndef __Header_attrtypn__
#define __Header_attrtypn__

/* need these two for TagFromName() in isSufficientSpaceForOneMoreValue() */
#include "attrtag.h"
#include "elmconst.h"

/* ********************* Numeric Binary Attributes ********************* */

template<class T,int Size>
class NumericBinaryAttribute : public Attribute {
private:
	ValueList<T> values;

	BinaryOutputStream& writeValues(BinaryOutputStream& stream)
		{
			ValueListIterator<T> i(values);
			if (Size == 1) while (!i) { stream.write8((unsigned char)i()); ++i; }
			if (Size == 2) while (!i) { stream.write16((Uint16)i()); ++i; }
			if (Size == 4) while (!i) { stream.write32((Uint32)i()); ++i; }
			if (Size == 8) while (!i) { stream.write64((Uint64)i()); ++i; }
			return stream;
		}

	bool isSufficientSpaceForOneMoreValue(void)
		{
			// logic here is that a short VL VR should never have a VL greater than can be sent in explicit VR (2^16-1 == 65535),
			// with the except of RT DVH (DS) that sometimes must be sent as implicit VR (Mathews, Bosch 2006 Phys. Med. Biol. 51 L11 doi:10.1088/0031-9155/51/5/L01)
			// also allow it in Histogram Data (encountered big one in Adani MG For Proc
			return Size*(getVM()+1) < 65536 || getTag() == TagFromName(DVHData) || getTag() == TagFromName(HistogramData);
		}
public:
	NumericBinaryAttribute(Tag t) : Attribute(t) {}
	virtual ~NumericBinaryAttribute()	{}

	BinaryOutputStream& writeData(BinaryOutputStream& stream)
		{
			return writeValues(stream);
		}

	TextOutputStream& writeData(TextOutputStream& stream)
		{
			const int width=2+Size*2;
			int count=0;
			ValueListIterator<T> i(values);
			while (!i) {
				if (Size == 1) {
					writeZeroPaddedHexNumber(stream,(unsigned short)i() & 0xff,2);
				}	
				else if (Size == 2) {
					writeZeroPaddedHexNumber(stream,(unsigned short)i(),4);
				}
				else {
					writeZeroPaddedHexNumber(stream,(unsigned long)i(),8);
				}
				++i;
				++count;
				if (!i) {
					stream << ",";
					if      (Size == 1 && count%16 == 0) { count=0; stream << "\n\t"; }
					else if (Size == 2 && count%8 == 0)  { count=0; stream << "\n\t"; }
					else if (             count%6 == 0)  { count=0; stream << "\n\t"; }
				}
			}
			return stream;
		}

	TextOutputStream& write(TextOutputStream& stream,ElementDictionary *dict=0,bool verbose=false,bool showUsedAndIE=false)
		{
			Attribute::writeBase(stream,dict,verbose,showUsedAndIE);
			stream << "[";
			writeData(stream);
			stream << "] ";
			return stream;
		}

	BinaryOutputStream& write(BinaryOutputStream& stream)
		{
			Attribute::writeBase(stream);
			writeValues(stream);
			return stream;
		}

	DicomOutputStream& write(DicomOutputStream& stream)
		{
			Attribute::writeBase(stream);
			writeValues(stream);
			return stream;
		}

	BinaryInputStream& read(BinaryInputStream& stream,Uint32 length)
		{
			// Allow short values ... some SPI values
			// are supposed to be UL but are US in some files ...
			// Assert(length%Size == 0);
			unsigned size = (length < Size) ? (unsigned)length : Size;
			Assert(size==0 || size==1 || size==2 || size==4);
			while (length && stream.good()) {
				if (size == 1) {
					Uint16 i=stream.read8();
					addValue(i);
				}
				else if (size == 2) {
					Uint16 i=stream.read16();
					addValue(i);
				}
				else if (size == 4) {
					Uint32 i=stream.read32();
					addValue(i);
				}
				else if (size == 4) {
					Uint64 i=stream.read64();
					addValue(i);
				}
				length-=size;
			}
			return stream;
		}

	bool	isNumeric(void) const		{ return true; }
	bool	isNumericBinary(void) const	{ return true; }

	Uint16	getVM(void) const	{ return values.getVM(); }
	Uint32	getVL(void) const	{ return Size*getVM(); }
	Uint16	getValueSize(void) const	{ return Size; }

	bool	getValue(unsigned index,Uint16& vp) const
		{
			T value;
			bool success=values.getValue(index,value);
			if (success) vp=(Uint16)value;
			return success;
		}
	bool	getValue(unsigned index,Uint32& vp) const
		{
			T value;
			bool success=values.getValue(index,value);
			if (success) vp=(Uint32)value;
			return success;
		}
	bool	getValue(unsigned index,Uint64& vp) const
		{
			T value;
			bool success=values.getValue(index,value);
			if (success) vp=(Uint64)value;
			return success;
		}
	bool	getValue(unsigned index,Int16& vp) const
		{
			T value;
			bool success=values.getValue(index,value);
			if (success) vp=(Int16)value;
			return success;
		}
	bool	getValue(unsigned index,Int32& vp) const
		{
			T value;
			bool success=values.getValue(index,value);
			if (success) vp=(Int32)value;
			return success;
		}
	bool	getValue(unsigned index,Int64& vp) const
		{
			T value;
			bool success=values.getValue(index,value);
			if (success) vp=(Int64)value;
			return success;
		}
	bool	getValue(unsigned index,Float32& vp) const
		{
			T value;
			bool success=values.getValue(index,value);
			if (success) vp=(Float32)value;
			return success;
		}
	bool	getValue(unsigned index,Float64& vp) const
		{
			T value;
			bool success=values.getValue(index,value);
			if (success) vp=(Float64)value;
			return success;
		}
	bool	getValue(unsigned index,Tag& vp) const
		{
			T value;
			bool success=values.getValue(index,value);
			if (success) {
				Uint32 v32=(Uint32)value;
				Tag   t((Uint16)((value>>16)&0xffff),
					(Uint16)(value&0xffff));
				vp=t;
			}
			return success;
		}
	bool	getValue(unsigned index,char * & vp) const
		{
			T value;
			bool success=values.getValue(index,value);
			if (success) {
				ostrstream ost;
				ost << dec << value << ends;
				vp=ost.str();	// copy - needs deletion !!!
			}
			return success;
		}

	void	setValue(unsigned index,Uint16 value)
		{
			values.setValue(index,(T)value);
		}
	void	setValue(unsigned index,Uint32 value)
		{
			values.setValue(index,(T)value);
		}
	void	setValue(unsigned index,Uint64 value)
		{
			values.setValue(index,(T)value);
		}
	void	setValue(unsigned index,Int16 value)
		{
			values.setValue(index,(T)value);
		}
	void	setValue(unsigned index,Int32 value)
		{
			values.setValue(index,(T)value);
		}
	void	setValue(unsigned index,Int64 value)
		{
			values.setValue(index,(T)value);
		}
	void	setValue(unsigned index,Float32 value)
		{
			values.setValue(index,(T)value);
		}
	void	setValue(unsigned index,Float64 value)
		{
			values.setValue(index,(T)value);
		}
	void	setValue(unsigned index,Tag value)
		{
			Uint32 v32=((Uint32)value.getGroup()<<16)
				   |(Uint32)value.getElement();
			values.setValue(index,(T)v32);
		}
	void	setValue(unsigned index,const char *value)
		{
			values.setValue(index,(T)atol(value));
		}

	void	addValue(Uint16 value)
		{
			Assert(isSufficientSpaceForOneMoreValue());
			values.addValue((T)value);
		}
	void	addValue(Uint32 value)
		{
			Assert(isSufficientSpaceForOneMoreValue());
			values.addValue((T)value);
		}
	void	addValue(Uint64 value)
		{
			Assert(isSufficientSpaceForOneMoreValue());
			values.addValue((T)value);
		}
	void	addValue(Int16 value)
		{
			Assert(isSufficientSpaceForOneMoreValue());
			values.addValue((T)value);
		}
	void	addValue(Int32 value)
		{
			Assert(isSufficientSpaceForOneMoreValue());
			values.addValue((T)value);
		}
	void	addValue(Int64 value)
		{
			Assert(isSufficientSpaceForOneMoreValue());
			values.addValue((T)value);
		}
	void	addValue(Float32 value)
		{
			Assert(isSufficientSpaceForOneMoreValue());
			values.addValue((T)value);
		}
	void	addValue(Float64 value)
		{
			Assert(isSufficientSpaceForOneMoreValue());
			values.addValue((T)value);
		}
	void	addValue(Tag value)
		{
			Assert(isSufficientSpaceForOneMoreValue());
			Uint32 v32=((Uint32)value.getGroup()<<16)
				   |(Uint32)value.getElement();
			values.addValue((T)v32);
		}
	void	addValue(const char *value)
		{
			Assert(isSufficientSpaceForOneMoreValue());
			values.addValue((T)atol(value));
		}


	void	addValues(unsigned number,Uint16 *vptr)		{ Attribute::addValues(number,vptr); }
	void	addValues(unsigned number,Uint32 *vptr)		{ Attribute::addValues(number,vptr); }
	void	addValues(unsigned number,Uint64 *vptr)		{ Attribute::addValues(number,vptr); }
	void	addValues(unsigned number,Int16 *vptr)		{ Attribute::addValues(number,vptr); }
	void	addValues(unsigned number,Int32 *vptr)		{ Attribute::addValues(number,vptr); }
	void	addValues(unsigned number,Int64 *vptr)		{ Attribute::addValues(number,vptr); }
	void	addValues(unsigned number,Float32 *vptr)	{ Attribute::addValues(number,vptr); }
	void	addValues(unsigned number,Float64 *vptr)	{ Attribute::addValues(number,vptr); }
	void	addValues(unsigned number,Tag *vptr)		{ Attribute::addValues(number,vptr); }
	void	addValues(unsigned number,const char **vptr)	{ Attribute::addValues(number,vptr); }

	void	addValues(const char *vptr)
		{
			const char *p;
			unsigned number;
			for (number=1,p=vptr; *p; ++p)
				if (*p == '\\') ++number;
			T *tptr = new T[number];
			unsigned i;
			for (i=0,p=vptr; i<number; ++i) {
				tptr[i]=(T)atol(p);
				if ((p=strchr(p,'\\')) != 0) ++p;
			}
			values.addValues(number,tptr);
			if (tptr) delete[] tptr;
		}
};

#endif /* __Header_attrtypn__ */

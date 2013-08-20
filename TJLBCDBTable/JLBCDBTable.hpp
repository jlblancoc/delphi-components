// Borland C++ Builder
// Copyright (c) 1995, 1999 by Borland International
// All rights reserved

// (DO NOT EDIT: machine generated header) 'JLBCDBTable.pas' rev: 5.00

#ifndef JLBCDBTableHPP
#define JLBCDBTableHPP

#pragma delphiheader begin
#pragma option push -w-
#pragma option push -Vx
#include <IniFiles.hpp>	// Pascal unit
#include <StdCtrls.hpp>	// Pascal unit
#include <Classes.hpp>	// Pascal unit
#include <SysUtils.hpp>	// Pascal unit
#include <Messages.hpp>	// Pascal unit
#include <Windows.hpp>	// Pascal unit
#include <SysInit.hpp>	// Pascal unit
#include <System.hpp>	// Pascal unit

//-- user supplied -----------------------------------------------------------

namespace Jlbcdbtable
{
//-- type declarations -------------------------------------------------------
class DELPHICLASS TJLBCDBField;
class PASCALIMPLEMENTATION TJLBCDBField : public System::TObject 
{
	typedef System::TObject inherited;
	
public:
	AnsiString name;
	AnsiString kind;
	int N;
	int M;
public:
	#pragma option push -w-inl
	/* TObject.Create */ inline __fastcall TJLBCDBField(void) : System::TObject() { }
	#pragma option pop
	#pragma option push -w-inl
	/* TObject.Destroy */ inline __fastcall virtual ~TJLBCDBField(void) { }
	#pragma option pop
	
};


class DELPHICLASS TJLBCDBTable;
class PASCALIMPLEMENTATION TJLBCDBTable : public Classes::TComponent 
{
	typedef Classes::TComponent inherited;
	
private:
	bool isActive;
	AnsiString stFileName;
	int cursorPos;
	Inifiles::TIniFile* IFile;
	Classes::TList* lstFields;
	int nCampos;
	int nRegistros;
	void __fastcall SetActive(const bool Value);
	void __fastcall SetFileName(const AnsiString Value);
	void __fastcall CreateIFile(void);
	void __fastcall ExtractNMField(TJLBCDBField* &f);
	
public:
	void __fastcall CreateTable(void);
	void __fastcall Open(void);
	void __fastcall Close(void);
	void __fastcall First(void);
	void __fastcall Last(void);
	void __fastcall Next(void);
	void __fastcall Prior(void);
	bool __fastcall EOF(void);
	int __fastcall FindRegisterByField(int indx, int start, AnsiString txt)/* overload */;
	int __fastcall FindRegisterByField(AnsiString indx, int start, AnsiString txt)/* overload */;
	void __fastcall SetPos(int pos);
	int __fastcall GetCursorPos(void);
	int __fastcall GetRegCount(void);
	void __fastcall AppendRecord(void);
	void __fastcall DeleteRecord(int i);
	void __fastcall GetField(int i, AnsiString &nam, AnsiString &kind, int &n, int &m);
	int __fastcall GetFieldCount(void);
	void __fastcall AddField(AnsiString nam, AnsiString kind);
	int __fastcall FindFieldIndex(AnsiString nam);
	void __fastcall GetFieldByIndex(int i, AnsiString &val)/* overload */;
	void __fastcall GetFieldByIndex(int i, double &val)/* overload */;
	void __fastcall GetFieldByIndex(int i, System::TDateTime &val)/* overload */;
	void __fastcall GetFieldByName(AnsiString field, System::TDateTime &val)/* overload */;
	void __fastcall GetFieldByName(AnsiString field, AnsiString &val)/* overload */;
	void __fastcall GetFieldByname(AnsiString field, double &val)/* overload */;
	void __fastcall SetFieldByIndex(int i, AnsiString val)/* overload */;
	void __fastcall SetFieldByIndex(int i, Extended val)/* overload */;
	void __fastcall SetFieldByIndex(int i, System::TDateTime val)/* overload */;
	void __fastcall SetFieldByName(AnsiString field, System::TDateTime val)/* overload */;
	void __fastcall SetFieldByName(AnsiString field, AnsiString val)/* overload */;
	void __fastcall SetFieldByname(AnsiString field, Extended val)/* overload */;
	
__published:
	__property bool Active = {read=isActive, write=SetActive, default=0};
	__property AnsiString FileName = {read=stFileName, write=SetFileName};
public:
	#pragma option push -w-inl
	/* TComponent.Create */ inline __fastcall virtual TJLBCDBTable(Classes::TComponent* AOwner) : Classes::TComponent(
		AOwner) { }
	#pragma option pop
	#pragma option push -w-inl
	/* TComponent.Destroy */ inline __fastcall virtual ~TJLBCDBTable(void) { }
	#pragma option pop
	
};


//-- var, const, procedure ---------------------------------------------------
extern PACKAGE void __fastcall Register(void);

}	/* namespace Jlbcdbtable */
#if !defined(NO_IMPLICIT_NAMESPACE_USE)
using namespace Jlbcdbtable;
#endif
#pragma option pop	// -w-
#pragma option pop	// -Vx

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// JLBCDBTable

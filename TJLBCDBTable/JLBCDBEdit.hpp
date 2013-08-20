// Borland C++ Builder
// Copyright (c) 1995, 1999 by Borland International
// All rights reserved

// (DO NOT EDIT: machine generated header) 'JLBCDBEdit.pas' rev: 5.00

#ifndef JLBCDBEditHPP
#define JLBCDBEditHPP

#pragma delphiheader begin
#pragma option push -w-
#pragma option push -Vx
#include <StdCtrls.hpp>	// Pascal unit
#include <Controls.hpp>	// Pascal unit
#include <Classes.hpp>	// Pascal unit
#include <Forms.hpp>	// Pascal unit
#include <SysUtils.hpp>	// Pascal unit
#include <Messages.hpp>	// Pascal unit
#include <Windows.hpp>	// Pascal unit
#include <SysInit.hpp>	// Pascal unit
#include <System.hpp>	// Pascal unit

//-- user supplied -----------------------------------------------------------

namespace Jlbcdbedit
{
//-- type declarations -------------------------------------------------------
class DELPHICLASS TJLBCEdit;
class PASCALIMPLEMENTATION TJLBCEdit : public Stdctrls::TEdit 
{
	typedef Stdctrls::TEdit inherited;
	
private:
	Controls::TWinControl* nextone;
	bool vParseComma;
	void __fastcall OnTecla(System::TObject* Sender, char &Key);
	
public:
	__fastcall virtual TJLBCEdit(Classes::TComponent* AOwner);
	
__published:
	__property Controls::TWinControl* NextControl = {read=nextone, write=nextone, default=0};
	__property bool ParseComma = {read=vParseComma, write=vParseComma, default=0};
public:
	#pragma option push -w-inl
	/* TWinControl.CreateParented */ inline __fastcall TJLBCEdit(HWND ParentWindow) : Stdctrls::TEdit(ParentWindow
		) { }
	#pragma option pop
	#pragma option push -w-inl
	/* TWinControl.Destroy */ inline __fastcall virtual ~TJLBCEdit(void) { }
	#pragma option pop
	
};


//-- var, const, procedure ---------------------------------------------------
extern PACKAGE void __fastcall Register(void);

}	/* namespace Jlbcdbedit */
#if !defined(NO_IMPLICIT_NAMESPACE_USE)
using namespace Jlbcdbedit;
#endif
#pragma option pop	// -w-
#pragma option pop	// -Vx

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// JLBCDBEdit

// Borland C++ Builder
// Copyright (c) 1995, 1999 by Borland International
// All rights reserved

// (DO NOT EDIT: machine generated header) 'JLBCDBComboBox.pas' rev: 5.00

#ifndef JLBCDBComboBoxHPP
#define JLBCDBComboBoxHPP

#pragma delphiheader begin
#pragma option push -w-
#pragma option push -Vx
#include <JLBCDBTable.hpp>	// Pascal unit
#include <StdCtrls.hpp>	// Pascal unit
#include <Controls.hpp>	// Pascal unit
#include <Classes.hpp>	// Pascal unit
#include <SysUtils.hpp>	// Pascal unit
#include <Forms.hpp>	// Pascal unit
#include <Messages.hpp>	// Pascal unit
#include <Windows.hpp>	// Pascal unit
#include <SysInit.hpp>	// Pascal unit
#include <System.hpp>	// Pascal unit

//-- user supplied -----------------------------------------------------------

namespace Jlbcdbcombobox
{
//-- type declarations -------------------------------------------------------
class DELPHICLASS TJLBCDBComboBox;
class PASCALIMPLEMENTATION TJLBCDBComboBox : public Stdctrls::TComboBox 
{
	typedef Stdctrls::TComboBox inherited;
	
private:
	Jlbcdbtable::TJLBCDBTable* pTabla;
	AnsiString pCampo;
	Controls::TWinControl* nextone;
	void __fastcall OnTecla(System::TObject* Sender, Word &Key, Classes::TShiftState Shift);
	
public:
	void __fastcall FillCombo(void);
	__fastcall virtual TJLBCDBComboBox(Classes::TComponent* AOwner);
	
__published:
	__property Jlbcdbtable::TJLBCDBTable* SourceTable = {read=pTabla, write=pTabla, default=0};
	__property AnsiString SourceField = {read=pCampo, write=pCampo};
	__property Controls::TWinControl* NextControl = {read=nextone, write=nextone, default=0};
public:
	#pragma option push -w-inl
	/* TCustomComboBox.Destroy */ inline __fastcall virtual ~TJLBCDBComboBox(void) { }
	#pragma option pop
	
public:
	#pragma option push -w-inl
	/* TWinControl.CreateParented */ inline __fastcall TJLBCDBComboBox(HWND ParentWindow) : Stdctrls::TComboBox(
		ParentWindow) { }
	#pragma option pop
	
};


//-- var, const, procedure ---------------------------------------------------
extern PACKAGE void __fastcall Register(void);

}	/* namespace Jlbcdbcombobox */
#if !defined(NO_IMPLICIT_NAMESPACE_USE)
using namespace Jlbcdbcombobox;
#endif
#pragma option pop	// -w-
#pragma option pop	// -Vx

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// JLBCDBComboBox

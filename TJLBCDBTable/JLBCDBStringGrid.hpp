// Borland C++ Builder
// Copyright (c) 1995, 1999 by Borland International
// All rights reserved

// (DO NOT EDIT: machine generated header) 'JLBCDBStringGrid.pas' rev: 5.00

#ifndef JLBCDBStringGridHPP
#define JLBCDBStringGridHPP

#pragma delphiheader begin
#pragma option push -w-
#pragma option push -Vx
#include <JLBCDBTable.hpp>	// Pascal unit
#include <Grids.hpp>	// Pascal unit
#include <Controls.hpp>	// Pascal unit
#include <Classes.hpp>	// Pascal unit
#include <SysUtils.hpp>	// Pascal unit
#include <Messages.hpp>	// Pascal unit
#include <Windows.hpp>	// Pascal unit
#include <Math.hpp>	// Pascal unit
#include <SysInit.hpp>	// Pascal unit
#include <System.hpp>	// Pascal unit

//-- user supplied -----------------------------------------------------------

namespace Jlbcdbstringgrid
{
//-- type declarations -------------------------------------------------------
class DELPHICLASS TJLBCDBStringGrid;
class PASCALIMPLEMENTATION TJLBCDBStringGrid : public Grids::TStringGrid 
{
	typedef Grids::TStringGrid inherited;
	
private:
	Jlbcdbtable::TJLBCDBTable* dbTabla;
	
public:
	void __fastcall FillData(void);
	
__published:
	__property Jlbcdbtable::TJLBCDBTable* DataSource = {read=dbTabla, write=dbTabla};
public:
	#pragma option push -w-inl
	/* TStringGrid.Create */ inline __fastcall virtual TJLBCDBStringGrid(Classes::TComponent* AOwner) : 
		Grids::TStringGrid(AOwner) { }
	#pragma option pop
	#pragma option push -w-inl
	/* TStringGrid.Destroy */ inline __fastcall virtual ~TJLBCDBStringGrid(void) { }
	#pragma option pop
	
public:
	#pragma option push -w-inl
	/* TWinControl.CreateParented */ inline __fastcall TJLBCDBStringGrid(HWND ParentWindow) : Grids::TStringGrid(
		ParentWindow) { }
	#pragma option pop
	
};


//-- var, const, procedure ---------------------------------------------------
extern PACKAGE void __fastcall Register(void);

}	/* namespace Jlbcdbstringgrid */
#if !defined(NO_IMPLICIT_NAMESPACE_USE)
using namespace Jlbcdbstringgrid;
#endif
#pragma option pop	// -w-
#pragma option pop	// -Vx

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// JLBCDBStringGrid

// Borland C++ Builder
// Copyright (c) 1995, 1999 by Borland International
// All rights reserved

// (DO NOT EDIT: machine generated header) 'CoolTrayIcon.pas' rev: 5.00

#ifndef CoolTrayIconHPP
#define CoolTrayIconHPP

#pragma delphiheader begin
#pragma option push -w-
#pragma option push -Vx
#include <ExtCtrls.hpp>	// Pascal unit
#include <ShellAPI.hpp>	// Pascal unit
#include <Menus.hpp>	// Pascal unit
#include <Forms.hpp>	// Pascal unit
#include <Controls.hpp>	// Pascal unit
#include <Graphics.hpp>	// Pascal unit
#include <Classes.hpp>	// Pascal unit
#include <SysUtils.hpp>	// Pascal unit
#include <Messages.hpp>	// Pascal unit
#include <Windows.hpp>	// Pascal unit
#include <SysInit.hpp>	// Pascal unit
#include <System.hpp>	// Pascal unit

//-- user supplied -----------------------------------------------------------

namespace Cooltrayicon
{
//-- type declarations -------------------------------------------------------
typedef void __fastcall (__closure *TCycleEvent)(System::TObject* Sender, int Current);

class DELPHICLASS TCoolTrayIcon;
class PASCALIMPLEMENTATION TCoolTrayIcon : public Classes::TComponent 
{
	typedef Classes::TComponent inherited;
	
private:
	bool FEnabled;
	Graphics::TIcon* FIcon;
	bool FIconVisible;
	AnsiString FHint;
	bool FShowHint;
	Menus::TPopupMenu* FPopupMenu;
	bool FLeftPopup;
	Classes::TNotifyEvent FOnClick;
	Classes::TNotifyEvent FOnDblClick;
	TCycleEvent FOnCycle;
	Controls::TMouseEvent FOnMouseDown;
	Controls::TMouseEvent FOnMouseUp;
	Controls::TMouseMoveEvent FOnMouseMove;
	bool FStartMinimized;
	bool FMinimizeToTray;
	bool FClicked;
	Extctrls::TTimer* CycleTimer;
	bool FDesignPreview;
	bool SettingPreview;
	Controls::TImageList* FIconList;
	bool FCycleIcons;
	unsigned FCycleInterval;
	int IconIndex;
	void *OldAppProc;
	void *NewAppProc;
	void __fastcall SetCycleIcons(bool Value);
	void __fastcall SetDesignPreview(bool Value);
	void __fastcall SetCycleInterval(unsigned Value);
	void __fastcall TimerCycle(System::TObject* Sender);
	void __fastcall HandleIconMessage(Messages::TMessage &Msg);
	bool __fastcall InitIcon(void);
	void __fastcall SetIcon(Graphics::TIcon* Value);
	void __fastcall SetIconVisible(bool Value);
	void __fastcall SetHint(AnsiString Value);
	void __fastcall SetShowHint(bool Value);
	void __fastcall PopupAtCursor(void);
	void __fastcall HookApp(void);
	void __fastcall UnhookApp(void);
	void __fastcall HookAppProc(Messages::TMessage &Message);
	
protected:
	_NOTIFYICONDATAA IconData;
	virtual void __fastcall Loaded(void);
	virtual bool __fastcall ShowIcon(void);
	virtual bool __fastcall HideIcon(void);
	virtual bool __fastcall ModifyIcon(void);
	DYNAMIC void __fastcall Click(void);
	DYNAMIC void __fastcall DblClick(void);
	DYNAMIC void __fastcall CycleIcon(void);
	DYNAMIC void __fastcall MouseDown(Controls::TMouseButton Button, Classes::TShiftState Shift, int X, 
		int Y);
	DYNAMIC void __fastcall MouseUp(Controls::TMouseButton Button, Classes::TShiftState Shift, int X, int 
		Y);
	DYNAMIC void __fastcall MouseMove(Classes::TShiftState Shift, int X, int Y);
	DYNAMIC void __fastcall DoMinimizeToTray(void);
	virtual void __fastcall Notification(Classes::TComponent* AComponent, Classes::TOperation Operation
		);
	
public:                                   
	__property HWND Handle = {read=IconData.hWnd, nodefault};
	__fastcall virtual TCoolTrayIcon(Classes::TComponent* AOwner);
	__fastcall virtual ~TCoolTrayIcon(void);
	void __fastcall ShowMainForm(void);
	void __fastcall HideMainForm(void);
	void __fastcall Refresh(void);
	
__published:
	__property bool DesignPreview = {read=FDesignPreview, write=SetDesignPreview, default=0};
	__property Controls::TImageList* IconList = {read=FIconList, write=FIconList};
	__property bool CycleIcons = {read=FCycleIcons, write=SetCycleIcons, default=0};
	__property unsigned CycleInterval = {read=FCycleInterval, write=SetCycleInterval, nodefault};
	__property bool Enabled = {read=FEnabled, write=FEnabled, default=1};
	__property AnsiString Hint = {read=FHint, write=SetHint};
	__property bool ShowHint = {read=FShowHint, write=SetShowHint, nodefault};
	__property Graphics::TIcon* Icon = {read=FIcon, write=SetIcon, stored=true};
	__property bool IconVisible = {read=FIconVisible, write=SetIconVisible, default=1};
	__property Menus::TPopupMenu* PopupMenu = {read=FPopupMenu, write=FPopupMenu};
	__property bool LeftPopup = {read=FLeftPopup, write=FLeftPopup, default=0};
	__property bool StartMinimized = {read=FStartMinimized, write=FStartMinimized, default=0};
	__property bool MinimizeToTray = {read=FMinimizeToTray, write=FMinimizeToTray, default=0};
	__property Classes::TNotifyEvent OnClick = {read=FOnClick, write=FOnClick};
	__property Classes::TNotifyEvent OnDblClick = {read=FOnDblClick, write=FOnDblClick};
	__property Controls::TMouseEvent OnMouseDown = {read=FOnMouseDown, write=FOnMouseDown};
	__property Controls::TMouseEvent OnMouseUp = {read=FOnMouseUp, write=FOnMouseUp};
	__property Controls::TMouseMoveEvent OnMouseMove = {read=FOnMouseMove, write=FOnMouseMove};
	__property TCycleEvent OnCycle = {read=FOnCycle, write=FOnCycle};
};


//-- var, const, procedure ---------------------------------------------------
static const Word WM_TRAYNOTIFY = 0x800;
static const Shortint IconID = 0x1;
extern PACKAGE void __fastcall Register(void);

}	/* namespace Cooltrayicon */
#if !defined(NO_IMPLICIT_NAMESPACE_USE)
using namespace Cooltrayicon;
#endif
#pragma option pop	// -w-
#pragma option pop	// -Vx

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// CoolTrayIcon

unit RasOneInstComp; 
//                     version  2.0
//
//                   Alexander Rodigin
//
//                     RUSSIA  1999
//
//                    ras@ras.udm.ru
//
interface
uses
  Windows, Messages, Classes, Forms, SysUtils;
//--------------------------------------------------
// The following declaration is necessary because of an error in
// the declaration of BroadcastSystemMessage() in the Windows unit
function BroadcastSystemMessage(Flags: DWORD; Recipients: PDWORD;
  uiMessage: UINT; wParam: WPARAM; lParam: LPARAM): Longint; stdcall;
  external 'user32.dll';

type
  TrasOneInstComp = class(TComponent)
  private
    { Private declarations }
    FEnabled: Boolean;
    FsMutex : string;
    FhMutex : THandle;
    FMessage: string;
    FMesID  : Cardinal;
    FHooked : Boolean;
    FText   : string;
    FTitle  : string;
    FOnAnInst : TNotifyEvent;
    function  AppWindowHook(var M: TMessage): Boolean;
    procedure BroadcastFocusMessage;
  protected
    { Protected declarations }
    procedure CheckAnotherInstance;
    procedure ExitHook;
    procedure Loaded;override;
    function  MutexExists:Boolean;
    procedure SetEnabled(Value:Boolean);
    procedure SetMessage(Value:string);
    procedure SetMutex(Value:string);
  public
    { Public declarations }
    constructor Create( AOwner: TComponent ); override;
    destructor Destroy;override;
  published
    { Published declarations }
    property Enabled:Boolean read FEnabled write SetEnabled default True;
    property Message:string read FMessage write SetMessage;
    property Mutex:string read FsMutex write SetMutex;
    property Text:string read FText write FText;
    property Title:string read FTitle write FTitle;
    property OnAnotherInstance: TNotifyEvent read FOnAnInst write FOnAnInst;
  end;

procedure Register;
//--------------------------------------------------
implementation

type
  OneInstCompError=class(Exception);
//--------------------------------------------------
constructor TrasOneInstComp.Create(AOwner:TComponent);
begin
  inherited Create(AOwner);
  FsMutex :=DateToStr(Date)+'-mutex';
  FMessage:=DateToStr(Date)+'-message'; 
  FEnabled := True;
end; { constructor Create }
//--------------------------------------------------
procedure TrasOneInstComp.Loaded;
begin
  inherited;
  CheckAnotherInstance;
end; { procedure Loaded }
//--------------------------------------------------
procedure TrasOneInstComp.CheckAnotherInstance;
begin
  if Enabled and not (csDesigning in ComponentState) then
  begin
    FMesID:=RegisterWindowMessage(PChar(FMessage));
    if not MutexExists then
    begin
      Application.HookMainWindow(AppWindowHook);
      FHooked:=True;
    end;
  end;
end; { procedure CheckAnotherInstance }
//-------------------------------------------------
function TrasOneInstComp.MutexExists:Boolean;
begin
  FhMutex:=OpenMutex(MUTEX_ALL_ACCESS,False,PChar(FsMutex));
  if FhMutex=0 then //it's a first instance
  begin
    FhMutex:=CreateMutex(nil,False,PChar(FsMutex));
    Result:=False;
  end
  else begin        //it's a second instance
    if Text='' then FText:='You can''t start another instance of that application.';
    if Title='' then FTitle:=Application.Title;
//    MessageBox(Application.Handle,PChar(FText),PChar(FTitle),MB_OK);
    if Assigned(FOnAnInst)then
      FOnAnInst(Self);
    if CloseHandle(FhMutex) then FhMutex:=0;
    BroadcastFocusMessage;
    PostQuitMessage(0);
    Result:=True;
  end
end; { function MutexExists }
//--------------------------------------------------
procedure TrasOneInstComp.SetMutex(Value:string);
begin
  if (csDesigning in ComponentState)or(csLoading in ComponentState) then
  begin
    if FsMutex<>Value then
    begin
      if(Value = '') then
        FsMutex :=DateToStr(Date)+'-mutex'
      else
        FsMutex := Value;
    end
  end
  else
    raise OneInstCompError.Create('you can''t change Mutex property at runtime!');
end; { procedure TrasOneInstComp.SetMutex }
//--------------------------------------------------
procedure TrasOneInstComp.SetEnabled(Value:Boolean);
begin
  if FEnabled<>Value then
  begin
    FEnabled := Value;
    if Value then
      CheckAnotherInstance
    else
      ExitHook;
  end;
end; { procedure SetEnabled }
//-------------------------------------------------
procedure TrasOneInstComp.SetMessage(Value:string);
begin
  if (csDesigning in ComponentState)or(csLoading in ComponentState) then
  begin
    if FMessage<>Value then
    begin
      if Value='' then
        FMessage:=DateToStr(Date)+'-message'
      else
        FMessage:=Value;
    end
  end
  else
    raise OneInstCompError.Create('you can''t change Message property at runtime!');
end; { procedure SetMessage }
//-------------------------------------------------
procedure TrasOneInstComp.BroadcastFocusMessage;
var
  BSMRecipients: DWORD;
begin
  { Don't flash main form }
  Application.ShowMainForm := False;
  { Post message and inform other instance to focus itself }
  BSMRecipients := BSM_APPLICATIONS;
  BroadCastSystemMessage(BSF_IGNORECURRENTTASK or BSF_POSTMESSAGE,
    @BSMRecipients, FMesID, 0, 0);
end; { procedure BroadcastFocusMessage }
//--------------------------------------------------
function TrasOneInstComp.AppWindowHook(var M: TMessage): Boolean;
begin
  if (M.Msg=FMesID) then //our message has arrived
  begin
    { if main form is minimized, normalize it }
    { set focus to application }
    if IsIconic(Application.Handle) then
    begin
      Application.MainForm.WindowState := wsNormal;
      Application.Restore;
    end;
    SetForegroundWindow(Application.MainForm.Handle);
    Result := True;
  end
  else //it's not our message-let app to process it
    Result := False;
end; { function AppWindowHook }
//--------------------------------------------------
procedure TrasOneInstComp.ExitHook;
begin
  if FHooked then
  begin
    Application.UnhookMainWindow(AppWindowHook);
    FHooked:=False;
  end;
  if(FhMutex <> 0) and CloseHandle(FhMutex) then
    FhMutex:=0;
end; { procedure ExitHook }
//-------------------------------------------------
destructor TrasOneInstComp.Destroy;
begin
  ExitHook;
  inherited Destroy;
end; { destructor Destroy }
//--------------------------------------------------
procedure Register;
begin
  RegisterComponents('RAS', [TrasOneInstComp]);
end;

end.

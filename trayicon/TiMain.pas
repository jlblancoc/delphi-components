unit TiMain;

interface

uses
  Windows, Messages, SysUtils, Classes, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, Menus, ImgList, CoolTrayIcon;

type
  TMainForm = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    PopupMenu1: TPopupMenu;
    ShowWindow1: TMenuItem;
    HideWindow1: TMenuItem;
    N1: TMenuItem;
    Exit1: TMenuItem;
    ImageList1: TImageList;
    ImageList2: TImageList;
    ImageList3: TImageList;
    rdoCycle: TRadioGroup;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    GroupBox2: TGroupBox;
    Label3: TLabel;
    Edit1: TEdit;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    CheckBox3: TCheckBox;
    CheckBox4: TCheckBox;
    TrayIcon1: TCoolTrayIcon;
    CheckBox5: TCheckBox;
    procedure FormCreate(Sender: TObject);
    procedure ShowWindow1Click(Sender: TObject);
    procedure HideWindow1Click(Sender: TObject);
    procedure Exit1Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Edit1Change(Sender: TObject);
    procedure CheckBox1Click(Sender: TObject);
    procedure CheckBox2Click(Sender: TObject);
    procedure TrayIcon1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure TrayIcon1MouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);
    procedure CheckBox3Click(Sender: TObject);
    procedure CheckBox4Click(Sender: TObject);
    procedure CheckBox5Click(Sender: TObject);
    procedure rdoCycleClick(Sender: TObject);
  end;

var
  MainForm: TMainForm;

implementation

{$R *.DFM}

procedure TMainForm.FormCreate(Sender: TObject);
begin
  Edit1Change(Self);
  CheckBox1Click(Self);
  CheckBox2Click(Self);
  CheckBox3Click(Self);
  CheckBox4Click(Self);
  CheckBox5Click(Self);
  rdoCycleClick(Self);
  TrayIcon1.Refresh;
end;


procedure TMainForm.ShowWindow1Click(Sender: TObject);
begin
  TrayIcon1.ShowMainForm;
end;


procedure TMainForm.HideWindow1Click(Sender: TObject);
begin
  TrayIcon1.HideMainForm;
end;


procedure TMainForm.Exit1Click(Sender: TObject);
begin
  Close;
end;


procedure TMainForm.Button1Click(Sender: TObject);
begin
  TrayIcon1.HideMainForm;
end;


procedure TMainForm.Button2Click(Sender: TObject);
begin
  TrayIcon1.IconVisible := not TrayIcon1.IconVisible;
end;


procedure TMainForm.Edit1Change(Sender: TObject);
begin
  TrayIcon1.Hint := Edit1.Text;
end;


procedure TMainForm.CheckBox1Click(Sender: TObject);
begin
  TrayIcon1.ShowHint := CheckBox1.Checked;
end;


procedure TMainForm.CheckBox2Click(Sender: TObject);
begin
  if Assigned(PopupMenu1) then
    PopupMenu1.AutoPopup := CheckBox2.Checked;
end;


procedure TMainForm.CheckBox3Click(Sender: TObject);
begin
  TrayIcon1.LeftPopup := CheckBox3.Checked;
end;


procedure TMainForm.CheckBox4Click(Sender: TObject);
begin
  TrayIcon1.Enabled := CheckBox4.Checked;
end;


procedure TMainForm.CheckBox5Click(Sender: TObject);
begin
  TrayIcon1.MinimizeToTray := CheckBox5.Checked;
end;


procedure TMainForm.TrayIcon1MouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if Assigned(PopupMenu1) then
    if not PopupMenu1.AutoPopup then
      MessageDlg('The popup menu is disabled.', mtInformation, [mbOk], 0);
end;


procedure TMainForm.TrayIcon1MouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
  { X and Y coords. are returned in screen coords. I don't know if
    it is possible to convert them to the tray icon's client coords.,
    but it's hardly relevant in any case. }
  Label1.Caption := 'Mouse pos.: ' + IntToStr(X) + ',' + IntToStr(Y);
  Label2.Caption := 'Key status: ';
  if ssShift in Shift then
    Label2.Caption := Label2.Caption + ' Shift ';
  if ssCtrl in Shift then
    Label2.Caption := Label2.Caption + ' Ctrl ';
  if ssAlt in Shift then
    Label2.Caption := Label2.Caption + ' Alt ';
end;


procedure TMainForm.rdoCycleClick(Sender: TObject);
begin
  If rdoCycle.ItemIndex = 0 then
  begin
    TrayIcon1.CycleIcons := False;
    ImageList2.GetIcon(0, TrayIcon1.Icon);
    TrayIcon1.Refresh;            // Remember to refresh
  end
  else
  begin
    case rdoCycle.ItemIndex of
      1: TrayIcon1.IconList := ImageList1;
      2: TrayIcon1.IconList := ImageList3;
      3: TrayIcon1.IconList := ImageList2;
    end;
    TrayIcon1.CycleIcons := True;
  end;
end;

end.


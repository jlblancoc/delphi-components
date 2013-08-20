unit janGridCellNames;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons;

type
  TjanGridCellNamesF = class(TForm)
    NamesList: TListBox;
    edName: TEdit;
    edValue: TEdit;
    btnDelete: TButton;
    btnAdd: TButton;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    btnClearall: TButton;
    StaticText1: TStaticText;
    StaticText2: TStaticText;
    procedure NamesListClick(Sender: TObject);
    procedure btnDeleteClick(Sender: TObject);
    procedure btnAddClick(Sender: TObject);
    procedure btnClearallClick(Sender: TObject);
    procedure NamesListDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure FormShow(Sender: TObject);
  private
    function  GetCellNames:Tstringlist;
    procedure SetCellNames(const Value: TStringlist);
    procedure SetCell(const Value: string);
    function  GetCell:string;
    procedure SetCellName(const Value: string);
    function  GetCellName:string;
    { Private declarations }
  public
    { Public declarations }
    property CellNames:TStringlist read GetCellNames write SetCellNames;
    property CellName:string read GetCellName write SetCellName;
    property Cell:string read GetCell write SetCell;
  end;

var
  janGridCellNamesF: TjanGridCellNamesF;

implementation

{$R *.DFM}

{ TjanGridCellNamesF }

function TjanGridCellNamesF.GetCellNames: Tstringlist;
begin
  result:=TStringlist(Nameslist.items);
end;

procedure TjanGridCellNamesF.SetCellNames(const Value: TStringlist);
begin
  Nameslist.items.Assign(Value);
end;

procedure TjanGridCellNamesF.NamesListClick(Sender: TObject);
var index:integer;
    s:string;
begin
  index:=nameslist.ItemIndex ;
  if index=-1 then exit;
  s:=CellNames.Names [index];
  edName.Text :=s;
  edValue.Text :=CellNames.Values [s];
end;


procedure TjanGridCellNamesF.btnDeleteClick(Sender: TObject);
var index:integer;
begin
 index:=nameslist.ItemIndex ;
 if index=-1 then exit;
 nameslist.Items.Delete (index);
end;

procedure TjanGridCellNamesF.btnAddClick(Sender: TObject);
var index:integer;
begin
  index:=Nameslist.items.IndexOfName (edName.text);
  if index<>-1 then
  begin
    showmessage('Name '+edName.text+' allready exists');
    exit;
  end;
  nameslist.items.Append (edname.text+'='+edvalue.text);
end;

procedure TjanGridCellNamesF.btnClearallClick(Sender: TObject);
begin
  if messagedlg('Clear all names?',mtconfirmation,[mbyes,mbno],0)=mryes then
    nameslist.items.Clear ;
end;

procedure TjanGridCellNamesF.SetCell(const Value: string);
begin
  edValue.text := Value;
end;

procedure TjanGridCellNamesF.SetCellName(const Value: string);
begin
  edName.text := Value;
end;

function TjanGridCellNamesF.GetCell: string;
begin
  result:=edValue.Text ;
end;

function TjanGridCellNamesF.GetCellName: string;
begin
  result:=edName.text;
end;

procedure TjanGridCellNamesF.NamesListDrawItem(Control: TWinControl;
  Index: Integer; Rect: TRect; State: TOwnerDrawState);
var s:string;
begin
  s:=Nameslist.items.names[index];
  Nameslist.Canvas.textrect(rect,rect.left,rect.top,s);
end;

procedure TjanGridCellNamesF.FormShow(Sender: TObject);
var index:integer;
begin
  edname.SetFocus;
  if edname.text<>'' then
  begin
    index:=nameslist.Items.IndexOfName (edname.text);
    if index<>-1 then
      nameslist.itemindex:=index
    else
      nameslist.itemindex:=-1;
  end;
end;

end.

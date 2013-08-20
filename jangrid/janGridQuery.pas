unit janGridQuery;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, janGrid, ExtCtrls;

type
  TjanGridQueryF = class(TForm)
    FieldsList: TListBox;
    querymemo: TMemo;
    oplist: TListBox;
    btnApply: TSpeedButton;
    btnClose: TSpeedButton;
    btnall: TSpeedButton;
    Shape1: TShape;
    procedure oplistClick(Sender: TObject);
    procedure FieldsListClick(Sender: TObject);
    procedure btnApplyClick(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure btnallClick(Sender: TObject);
  private
    FGrid: TjanGrid;
    procedure SetGrid(const Value: TjanGrid);
    { Private declarations }
  public
    { Public declarations }
  published
   property Grid:TjanGrid read FGrid write SetGrid;
  end;

var
  janGridQueryF: TjanGridQueryF;

implementation

{$R *.DFM}
const
  cr = chr(13)+chr(10);
  tab = chr(9);

procedure TjanGridQueryF.oplistClick(Sender: TObject);
begin
 if oplist.itemindex=-1 then exit;
  querymemo.seltext:=' '+oplist.items[oplist.itemindex]+' ';
  querymemo.setfocus;
end;

procedure TjanGridQueryF.FieldsListClick(Sender: TObject);
begin
 if fieldslist.itemindex=-1 then exit;
 querymemo.SelText :='['+fieldslist.items[fieldslist.itemindex]+']';
 querymemo.setfocus;
end;

procedure TjanGridQueryF.SetGrid(const Value: TjanGrid);
begin
  FGrid := Value;
end;

procedure TjanGridQueryF.btnApplyClick(Sender: TObject);
var s:string;
begin
 if assigned(FGrid) then begin
  s:=querymemo.Text ;
  s:=stringreplace(s,cr,' ',[rfreplaceall]);
  Grid.FilterRows (s);
  end;
end;

procedure TjanGridQueryF.btnCloseClick(Sender: TObject);
begin
 close;
end;

procedure TjanGridQueryF.btnallClick(Sender: TObject);
begin
 Grid.ShowRows ;
end;

end.

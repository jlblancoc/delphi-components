unit janGridFormule;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,janGrid,
  StdCtrls, Buttons;

type
  TjanGridFormuleF = class(TForm)
    formule: TMemo;
    btnapply: TSpeedButton;
    btnclose: TSpeedButton;
    ops: TListBox;
    procedure btnapplyClick(Sender: TObject);
    procedure btncloseClick(Sender: TObject);
    procedure opsClick(Sender: TObject);
  private
    FGrid: TjanGrid;
    FCell: Tpoint;
    procedure SetGrid(const Value: TjanGrid);
    procedure SetCell(const Value: Tpoint);
    { Private declarations }
  public
    { Public declarations }
  published
   property Grid: TjanGrid read FGrid write SetGrid;
   property Cell: Tpoint read FCell write SetCell;
  end;

var
  janGridFormuleF: TjanGridFormuleF;

implementation

{$R *.DFM}

{ TjanGridFormuleF }

procedure TjanGridFormuleF.SetCell(const Value: Tpoint);
begin
  FCell := Value;
end;

procedure TjanGridFormuleF.SetGrid(const Value: TjanGrid);
begin
  FGrid := Value;
end;

procedure TjanGridFormuleF.btnapplyClick(Sender: TObject);
begin
 Grid.Cells [Cell.x,Cell.y]:=formule.Text ;
 Grid.FormuleMode :=false;
 Grid.Recalculate ;
 close;

end;

procedure TjanGridFormuleF.btncloseClick(Sender: TObject);
begin
 Grid.FormuleMode :=false;
 close;
end;

procedure TjanGridFormuleF.opsClick(Sender: TObject);
begin
 if ops.itemindex=-1 then exit;
 formule.seltext:=trim(ops.items[ops.itemindex]);
 formule.setfocus;
end;

end.

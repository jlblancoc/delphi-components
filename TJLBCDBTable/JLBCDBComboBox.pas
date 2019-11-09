unit JLBCDBComboBox;

interface

uses
  Windows, Messages, forms,SysUtils, Classes, Controls, StdCtrls,JLBCDBTable;

type
  TJLBCDBComboBox = class(TComboBox)
  private
    pTabla: TJLBCDBTable;
    pCampo: AnsiString;
    nextone : TWinControl;

    procedure OnTecla(Sender: TObject; var Key: Word; Shift: TShiftState) ;

  protected
    { Protected declarations }
  public
    procedure FillCombo;

    constructor Create(AOwner: TComponent); override;


  published
    property SourceTable: TJLBCDBTable read pTabla write pTabla default nil;
    property SourceField: AnsiString read pCampo write pCampo;
    property NextControl: TWinControl read nextone write nextone default nil;

  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('JLBC', [TJLBCDBComboBox]);
end;

{ TJLBCDBComboBox }


{ TJLBCDBComboBox }

// Rellena el combo con los valores de cada registro del campo dado.
//  No selecciona ninguno
constructor TJLBCDBComboBox.Create(AOwner: TComponent);
begin
  inherited;

  OnKeyDown:=Ontecla;

end;

procedure TJLBCDBComboBox.FillCombo;
var
 i,n: Integer;
 aux : AnsiString;
begin //
  Items.Clear;
  n:= pTabla.GetRegCount;

  for i:=1 to n do
  begin
    ptabla.SetPos(i);
    ptabla.GetFieldByName(pcampo,aux);
    Items.Add(aux);
  end;

//  self.Text:='';
//  self.ItemIndex:=-1;
end;

procedure TJLBCDBComboBox.OnTecla(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
 if (Key=VK_RETURN)and(Nextone<>nil) then
 begin
   if (Parent is TForm) then
    TForm(self.Parent).activecontrol:=nextone
   else if (Parent.Parent is TForm) then
    TForm(Parent.Parent).activecontrol:=nextone;

   Key:=0;
 end;
end;

end.

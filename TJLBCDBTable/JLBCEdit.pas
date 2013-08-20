unit JLBCEdit;

interface

uses
  Windows, Messages, SysUtils, forms,Classes, Controls, StdCtrls;

type
  TJLBCEdit = class(TEdit)
  private
   nextone : TWinControl;
   vParseComma : Boolean;
//   procedure OnTecla(Sender: TObject; var Key: Word; Shift: TShiftState) ;
   procedure OnTecla(Sender: TObject; var Key: Char);

  protected
  public

  constructor Create(AOwner: TComponent); override;

  published
    { Published declarations }

    property NextControl: TWinControl read nextone write nextone default nil;
    property ParseComma: Boolean read vParsecomma write vParsecomma  default false;

  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('JLBC', [TJLBCEdit]);
end;

{ TJLBCEdit }

constructor TJLBCEdit.Create(AOwner: TComponent);
begin
  inherited;

//  self.OnKeyDown:=Ontecla;
  self.OnKeyPress:=Ontecla;

end;

procedure TJLBCEdit.OnTecla(Sender: TObject; var Key: Char);
//procedure TJLBCEdit.OnTecla(Sender: TObject; var Key: Word; Shift: TShiftState) ;
begin
 if (Key=char(13){VK_RETURN})and(Nextone<>nil) then
 begin
   TForm(self.Parent).activecontrol:=nextone;
   Key:=char(0);
 end;

 if (MaxLength>0)and(Key in [char(32)..char(127)])and(Nextone<>nil)and(length(text)=MaxLength-1) then
 begin
  TForm(self.Parent).activecontrol:=nextone;
  inherited;
 end;

 if (vParsecomma) then
   if (Key='.')then Key:=',';


end;


end.

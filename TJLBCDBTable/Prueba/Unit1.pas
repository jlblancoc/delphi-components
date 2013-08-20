unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, JLBCDBTable, Grids, JLBCDBStringGrid;

type
  TForm1 = class(TForm)
    Button1: TButton;
    t1: TJLBCDBTable;
    Button2: TButton;
    tb1: TJLBCDBStringGrid;
    Button3: TButton;
    Button4: TButton;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
begin
 t1.CreateTable;
 t1.AddField('NIF','0-9');
 t1.AddField('NOMBRE','0');


end;

procedure TForm1.Button2Click(Sender: TObject);
begin
 t1.AppendRecord;
 t1.SetFieldByIndex(1,'26236270DXD');
 t1.SetFieldByIndex(2,'Manolo el del butano');

end;

procedure TForm1.Button3Click(Sender: TObject);
begin
 tb1.FillData;
end;

procedure TForm1.Button4Click(Sender: TObject);
begin
 t1.Open;
end;

end.
 
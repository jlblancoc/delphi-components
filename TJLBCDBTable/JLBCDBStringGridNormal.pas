unit JLBCDBStringGridNormal;

interface

uses
  Math,Windows, Messages, SysUtils, Classes, Controls, Grids,JLBCDBTable, janGrid;

type
  TJLBCDBStringGrid = class(tjangrid)
  private
   dbTabla : TJLBCDBTable;

  protected
    { Protected declarations }
  public
   procedure FillData;

  published
   property DataSource : TJLBCDBTable read dbTabla write dbTabla;
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('JLBC', [TJLBCDBStringGrid]);
end;


{ TJLBCDBStringGrid }
procedure TJLBCDBStringGrid.FillData;
var
 i,j,aux,aux2   : LongInt;
 nReg,nCam      : LongInt;
 n,k            :String;
begin
 if (dbTabla=nil) then raise Exception.Create('ERROR: No se ha indicado origen de datos para tabla...');

 nReg:=dbtabla.GetRegCount;
 nCam:=dbtabla.GetFieldCount;

 // Nº de filas y columnas:
 ColCount:=1+nCam;
 FixedCols:=1;
 RowCount:=Max(2,1+nReg);
 FixedRows:=1;

 // Rellenar bordes:
 Cells[0,0]:='';
 for i:=1 to nReg do Cells[0,i]:=inttostr(i);


 for i:=1 to nCam do
 begin
  dbTabla.GetField(i,n,k,aux,aux2);
  Cells[i,0]:=n;
  for j:=1 to nReg do
  begin
   dbTabla.SetPos(j);
   dbTabla.GetFieldByIndex(i,n);
   Cells[i,j]:=n;
  end; // Registros

 end; // Campos

 if (nReg=0) then
   for i:=1 to nCam do Cells[i,1]:='';

end;




end.

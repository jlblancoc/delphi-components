{ ************************************************************************
  COMPONENTE: TJLBCDBTable

  USO: Manejo de tablas de datos usando ficheros INI.
       Simple pero sencillo y rapido.

  AUTOR: Jose Luis Blanco Claraco @ 2001-2002

  Tipo de campos: (parametro "kind")

  "0" : Cadena de texto
  "0-N" : Cadena de texto, N caracteres maximo
  "1-N-M": Numerico BCD, N digitos enteros, M decimales. Separador: ","
  "2": Fecha
  
 ************************************************************************ }

unit JLBCDBTable;

interface

uses
  Windows, Messages, SysUtils, Classes,stdctrls,INIFiles;//,dateutils;

type

  TJLBCDBField = class
    name : AnsiString;
    kind : AnsiString;
    N,M  : Integer;
  end;
  PTJLBCDBField= ^TJLBCDBField;

  TJLBCDBTable = class(TComponent)
  private
    { Private declarations }
    isActive            : Boolean;
    stFileName          : AnsiString;
    cursorPos           : LongInt;
    IFile               : TMemINIFile;
    lstFields           : TList;

    nCampos,nRegistros  : LongInt;

//    dPrueba : TEdit;


    procedure SetActive(const Value: Boolean);
    procedure SetFileName(const Value: AnsiString);
    procedure CreateIFile;

    procedure ExtractNMField(var f:TJLBCDBField);

  protected

  public
   { Metodos: }
   destructor Destroy; override;

   procedure CreateTable;
   procedure Open;
   procedure Close;

   procedure First;
   procedure Last;
   procedure Next;
   procedure Prior;
   function  EOF:Boolean;

   function  FindRegisterByField(indx,start: Integer; txt: AnsiString):Integer;overload; { Devuelve el indice del registro }
   function  FindRegisterByField(indx:String;start: Integer; txt: AnsiString):Integer;overload; { Devuelve el indice del registro }

   procedure SetPos(pos: LongInt); { Primero es 1 }
   function  GetCursorPos: LongInt;

   function  GetRegCount: LongInt;
   procedure AppendRecord;
   procedure DeleteRecord(i: Integer);

   procedure GetField(i:LongInt;var nam,kind:String;var n,m:Integer);
   function  GetFieldCount: LongInt;
   procedure AddField(nam,kind: String);
   function  FindFieldIndex(nam: String):Integer;

   procedure  GetFieldByIndex(i: LongInt;var val:AnsiString);overload;
   procedure  GetFieldByIndex(i: LongInt;var val:Double);overload;
   procedure  GetFieldByIndex(i: LongInt;var val:TDateTime);overload;
   procedure  GetFieldByName(field: AnsiString;var val:TDateTime);overload;
   procedure  GetFieldByName(field: AnsiString;var val:AnsiString);overload;
   procedure  GetFieldByname(field: AnsiString;var val:Double);overload;

   procedure  SetFieldByIndex(i: LongInt;val:AnsiString);overload;
   procedure  SetFieldByIndex(i: LongInt;val:Extended);overload;
   procedure  SetFieldByIndex(i: LongInt;val:TDateTime);overload;
   procedure  SetFieldByName(field:String;val:TDateTime);overload;
   procedure  SetFieldByName(field,val:AnsiString);overload;
   procedure  SetFieldByname(field:AnsiString;val:Extended);overload;

   procedure  UpdateFile;


  published
    { Propiedades: }
    property Active: Boolean read isActive write SetActive default false;
    property FileName: AnsiString read stFileName write SetFileName;

//    property Prueba: TEdit read dPrueba write dPrueba;



  end;

procedure Register;

implementation


procedure Register;
begin
  RegisterComponents('JLBC', [TJLBCDBTable]);
end;

procedure TJLBCDBTable.AddField(nam, kind: String);
var
 f: TJLBCDBField;
begin
 if not isActive then raise Exception.Create('JLBCbd: Error al añadir campo, la tabla no esta abierta...');
// if self.nRegistros>0 then raise Exception.Create('JLBCbd: Error al añadir campo, la tabla no esta vacia...');

 Inc(nCampos);

 // Actualizar fichero:
 IFile.WriteInteger('CAMPOS','numero',nCampos);
 IFile.WriteString('CAMPOS','nombre'+inttostr(nCampos),nam);
 IFile.WriteString('CAMPOS','tipo'+inttostr(nCampos),kind);

  // Añadir a estructura en memoria:
  f:= TJLBCDBField.Create;
  f.name:=nam;
  f.kind:=kind;
  ExtractNMField(f);
  lstFields.Add(f);

end;

procedure TJLBCDBTable.AppendRecord;
var
 i: LongInt;
 s: String;

begin
 if not self.isActive then raise Exception.Create('JLBCdb ERROR: Append no valido, la tabla no esta abierta...');
 if ncampos=0 then raise Exception.Create('JLBCdb ERROR: Append no valido, no hay campos...');

 Inc(nRegistros);
 cursorPos:=nRegistros;

 // Guardar numero de registros
 IFile.WriteInteger('META','nregistros',nRegistros);

 // Crear campos vacios:
 s:='r'+inttostr(nRegistros);
 for i:=1 to ncampos do
 begin
  IFile.WriteString(s,'c'+inttostr(i),'');
 end;

end;

procedure TJLBCDBTable.Close;
begin
 if not isActive then Exit;
 
 isActive:=false;

 Ifile.UpdateFile;


 // Liberar mem:
 IFile.Destroy;
 self.lstFields.Destroy;

end;

{ Llamado para crear el fichero o sobreescribirlo, antes de abrirlo: }
procedure TJLBCDBTable.CreateIFile;
begin
 IFile:= TMemIniFile.Create(self.stFileName);
end;

procedure TJLBCDBTable.CreateTable;
begin
 SysUtils.DecimalSeparator:=',';
 SysUtils.ThousandSeparator:='.';
 nCampos:=0;
 nRegistros:=0;
 cursorPos:=0;


 if (isActive) then raise Exception.Create('CreateTable: Error, la tabla esta abierta...');

 // Sobreescribir fichero:
 if (FileExists(self.stFileName)) then DeleteFile(stFileName);

 // Crear tabla con nombre de fichero dado:
 CreateIFile;

 // Crear estructura vacia:
 self.lstFields:= TList.Create;
 IFile.WriteInteger('CAMPOS','numero',0);
 IFile.WriteInteger('META','nregistros',0);

 isActive:=true;

 Ifile.UpdateFile;

end;

{
  Muy mala implementacion: Desplazar todos los siguientes 1 posicion adelante:
   1 = 1º registro:
}
procedure TJLBCDBTable.DeleteRecord(i: Integer);
var
 a,b  : Integer;
 regDest,regOrg,aux    : AnsiString;
begin
 if not self.isActive then raise Exception.Create('JLBCdb ERROR: DeleteRecord no valido, la tabla no esta abierta...');
 if (i<1) or (i>nRegistros) then raise Exception.Create('JLBCdb ERROR: DeleteRecord no valido, indice de registro no valido...');


 if (i<nregistros) then
 begin  // Correr registros i+1,...,nRegistros a i,...,nRegistros-1
  for a:=i to nRegistros-1 do
  begin
   regOrg:='r'+inttostr(a+1);
   regDest:='r'+inttostr(a);
   for b:=1 to nCampos do
   begin
    aux:=IFile.ReadString(regOrg,'c'+inttostr(b),'');
    IFile.WriteString(regDest,'c'+inttostr(b),aux);
   end; // Para cada campo

  end; // Para cada registro

 end;

 // Borrar ultimo registro:
 Dec(nRegistros);

 // Guardar numero de campos:
 IFile.WriteInteger('META','nregistros',nRegistros);

end;


function TJLBCDBTable.EOF: Boolean;
begin
 Result:= (cursorPos = (nRegistros+1));
end;

// Extract N & M from "kind"
procedure TJLBCDBTable.ExtractNMField(var f: TJLBCDBField);
var
 aux,aux2 : String;
begin
 aux:=f.kind;

 // Cadenas -----------------
 if (aux='0') then Exit;

 if (copy(aux,1,1)='0') then
 begin // "0-N"
  delete(aux,1,2);
  f.N:=strtoint(aux);
  Exit;
 end;

 // Fechas -----------------
 if (aux='2') then Exit;

 // Numericos -----------------
 if (copy(aux,1,1)='1') then
 begin // "1-N-M"
  delete(aux,1,2);
  aux2:= copy(aux,pos('-',aux)+1,100);  // M
  f.M:=strtoint(aux2);

  delete(aux,pos('-',aux),100); // N
  f.N:=strtoint(aux);

  Exit;
 end;




end;

procedure TJLBCDBTable.First;
begin
 if not self.isActive then raise Exception.Create('JLBCdb ERROR: First no valido, la tabla no esta abierta...');

 cursorPos:=1;
end;

function TJLBCDBTable.GetCursorPos: LongInt;
begin
 if not self.isActive then raise Exception.Create('JLBCdb ERROR: GetCursorPos no valido, la tabla no esta abierta...');

 Result:=cursorPos;
end;


procedure TJLBCDBTable.GetFieldByIndex(i: Integer; var val: AnsiString);
var
 tmp,frmStr: AnsiString;
 f  : TJLBCDBField;
 n  : Integer;
 extVal : Extended;
begin
 if not self.isActive then raise Exception.Create('JLBCdb ERROR: GetField no valido, la tabla no esta abierta...');
 if (i>nCampos)or(i<1) then raise Exception.Create('JLBCdb ERROR: Campo fuera de rango:'+inttostr(i));
 if (cursorPos>nregistros)or(cursorPos<1) then raise Exception.Create('JLBCdb ERROR: GetField no valid, registro inexistente...');

 tmp:=IFile.ReadString('r'+inttostr(self.cursorPos),'c'+inttostr(i),'');

 val:='';

 // Comprobar formato:
 //  "0" -> Cadena
 //  "0-x" -> Cadena de longitud X:
 f:= TJLBCDBField(lstFields.Items[i-1]);
 if (f.kind='0') then val:=tmp;
 if ( Copy(f.kind,1,2)='0-') then
 begin
   n:=Strtoint(Copy(f.kind,3,100)); // Nº de caracteres:
   val:=copy(tmp,1,n);
 end;

 //  "1-N-M" -> Numerico: N digitos enteros / M decimales
 if ( Copy(f.kind,1,1)='1') then
 begin
   if (tmp='') then tmp:='0';
   extVal:=strtofloat( tmp );

   // Cadena de formato:
   frmStr:='%'+inttostr(f.N);
   frmStr:=frmStr+'.'+inttostr(f.M);

   frmStr:=frmStr+'f';
   
   val:=Format(frmStr,[extVal]);
 end;

 //  "2" -> Fecha:
 if ( f.kind='2') then val:=tmp;

 val:=trim(val);


end;

procedure TJLBCDBTable.GetField(i: Integer; var nam, kind: String; var n,
  m: Integer);
begin
 if not self.isActive then raise Exception.Create('JLBCdb ERROR: GetField no valido, la tabla no esta abierta...');
 if (i>nCampos)or(i<1) then raise Exception.Create('JLBCdb ERROR: Campo fuera de rango:'+inttostr(i));

 nam:=(TJLBCDBField(lstFields.Items[i-1])).name;
 kind:=(TJLBCDBField(lstFields.Items[i-1])).kind;
 n:=(TJLBCDBField(lstFields.Items[i-1])).n;
 m:=(TJLBCDBField(lstFields.Items[i-1])).m;


end;

procedure TJLBCDBTable.GetFieldByIndex(i: Integer; var val: Double);
var
 tmp: AnsiString;
 aux : String;
begin
 if not self.isActive then raise Exception.Create('JLBCdb ERROR: GetField no valido, la tabla no esta abierta...');
 if (i>nCampos)or(i<1) then raise Exception.Create('JLBCdb ERROR: Campo fuera de rango:'+inttostr(i));
 if (cursorPos>nregistros)or(cursorPos<1) then raise Exception.Create('JLBCdb ERROR: GetField no valid, registro inexistente...');

 tmp:=IFile.ReadString('r'+inttostr(self.cursorPos),'c'+inttostr(i),'');

 val:=0;
 // Formato:
 //  "1-N-M" -> N enteros,M decimales
 aux:=(TJLBCDBField(lstFields.Items[i-1])).kind;

 if (copy(aux,1,1)<>'1') then raise Exception.create('JLBCdb ERROR: No se puede pasar campo a numerico...');

 val:= strtofloat(tmp);

end;

function TJLBCDBTable.GetFieldCount: LongInt;
begin
 if not self.isActive then raise Exception.Create('JLBCdb ERROR: GetFieldCount no valido, la tabla no esta abierta...');

 result:=self.nCampos;
end;

function TJLBCDBTable.GetRegCount: LongInt;
begin
 if not self.isActive then raise Exception.Create('JLBCdb ERROR: GetRegCount no valido, la tabla no esta abierta...');

 result:=self.nRegistros;
end;

procedure TJLBCDBTable.Last;
begin
 if not self.isActive then raise Exception.Create('JLBCdb ERROR: Last no valido, la tabla no esta abierta...');

 cursorPos:=nRegistros;
end;

procedure TJLBCDBTable.Next;
begin
 if not self.isActive then raise Exception.Create('JLBCdb ERROR: Next no valido, la tabla no esta abierta...');

 Inc(cursorPos);
 // maxima posicion: FINAL + 1 ,para facilitar uso de EOF:
 if (cursorPos>nRegistros+1) then cursorPos:=nRegistros+1;  

end;

procedure TJLBCDBTable.Open;
var
 i: Integer;
 f: TJLBCDBField;
begin
 SysUtils.DecimalSeparator:=',';
 SysUtils.ThousandSeparator:='.';

 if isActive then Exit;

 // Comprobar q  existe el fichero:
 if not FileEXists(stFileName) then raise Exception.Create('Abrir JLBCdb: No se encuentra fichero:"'+stFileName+'"');

 // Cargar una DB en memoria:
 CreateIFile;
 lstFields:= TList.Create;

 lstFields.Clear;

 // Cargar nº de registros:
 nRegistros:= IFile.ReadInteger('META','nregistros',0);
 if (nRegistros>0) then cursorPos:=1 else cursorPos:=0;

 // Cargar estructura de campos:
 self.nCampos:=IFile.ReadInteger('CAMPOS','numero',0);
 for i:=1 to nCampos do
 begin
  f:= TJLBCDBField.Create;
  f.name:=ifile.ReadString('CAMPOS','nombre'+inttostr(i),'');
  f.kind:=ifile.ReadString('CAMPOS','tipo'+inttostr(i),'');
  ExtractNMField(f);
  lstFields.Add(f);
 end;

 isActive:=true;
end;

procedure TJLBCDBTable.Prior;
begin
 if (cursorPos>1) then dec(cursorPos);
end;

procedure TJLBCDBTable.SetActive(const Value: Boolean);
begin
 if (Value) then Open else Close;
end;

// 1º campo = 0
procedure TJLBCDBTable.SetFieldByIndex(i: Integer; val: AnsiString);
var
 aux,str: AnsiString;
 tmp    : Extended;
begin
 if not self.isActive then raise Exception.Create('JLBCdb ERROR: SetField no valido, la tabla no esta abierta...');
 if (i>nCampos)or(i<1) then raise Exception.Create('JLBCdb ERROR: Campo fuera de rango:'+inttostr(i));
 if (cursorPos>nregistros)or(cursorPos<1) then raise Exception.Create('JLBCdb ERROR: GetField no valid, registro inexistente...');


 str:='';
 // Formato:
 //  "1-N-M" -> N enteros,M decimales
 aux:=(TJLBCDBField(lstFields.Items[i-1])).kind;

 // Permitir poner campos numericos como String si es posible:
 if (copy(aux,1,1)='1') then
 begin
  if (val='') then val:='0';
  tmp:=strtofloat(val);
  self.SetFieldByIndex(i,tmp);
  exit;
 end;

// if (copy(aux,1,1)<>'0') then raise Exception.create('JLBCdb ERROR: SetField, campo no es de texto...');

 if (aux='0')or(aux='2') then str:=val; // textos o fechas

 if (copy(aux,1,2)='0-') then
  str:=copy(val,1,(TJLBCDBField(lstFields.Items[i-1])).n);

 IFile.WriteString('r'+inttostr(self.cursorPos),'c'+inttostr(i),str);

end;

// 1º campo = 0
procedure TJLBCDBTable.SetFieldByIndex(i: Integer; val: Extended);
var
 aux,str: AnsiString;
begin
 if not self.isActive then raise Exception.Create('JLBCdb ERROR: SetField no valido, la tabla no esta abierta...');
 if (i>nCampos)or(i<1) then raise Exception.Create('JLBCdb ERROR: Campo fuera de rango:'+inttostr(i));
 if (cursorPos>nregistros)or(cursorPos<1) then raise Exception.Create('JLBCdb ERROR: GetField no valid, registro inexistente...');

 str:='';
 // Formato:
 //  "1-N-M" -> N enteros,M decimales
 aux:=(TJLBCDBField(lstFields.Items[i-1])).kind;
 if (copy(aux,1,1)<>'1') then raise Exception.create('JLBCdb ERROR: SetField, campo no es numerico...');

 str:=Floattostr(val);

 IFile.WriteString('r'+inttostr(self.cursorPos),'c'+inttostr(i),str);

end;

procedure TJLBCDBTable.SetFileName(const Value: AnsiString);
begin
 if (isActive) then raise Exception.Create('No se puede cambiar fichero a usar :La tabla JLBCDB esta abierta...');

 if (Pos('\',Value)=0) then
  stFileName:='.\'+Value
 else
  stFileName:=Value;
end;

procedure TJLBCDBTable.SetPos(pos: Integer);
begin
 if not self.isActive then raise Exception.Create('JLBCdb ERROR: SetPos no valido, la tabla no esta abierta...');
 if (pos<1) or (pos>nRegistros) then raise Exception.Create('JLBCdb: Error en SetPos, rango no valido:'+inttostr(pos));
 cursorPos:=pos;
end;

{  Busca la posicion (indice) del registro q tenga "txt" como
    campo nº indx, empezando por el registro start, incluido.
     0 =  No encontrado
}
function TJLBCDBTable.FindRegisterByField(indx, start: Integer;
  txt: AnsiString): Integer;
var
 i: Integer;
 cmp : AnsiString;
begin

 for i:=start to nRegistros do
 begin
   SetPos(i);
   self.GetFieldbyindex(indx,cmp);
   if (cmp=txt) then
   begin
     Result:=i;
     Exit;
   end;
 end;

 Result:=0;
 exit;
end;

procedure TJLBCDBTable.SetFieldByName(field, val: AnsiString);
begin
 SetFieldByIndex( FindFieldIndex(field) ,val);
end;

procedure TJLBCDBTable.SetFieldByName(field:ansiString; val: Extended);
begin
 SetFieldByIndex( FindFieldIndex(field) ,val);
end;


// Devuelve el indice (1 el primero) del campo con nombre "nam"
//    insensible a mayusculas-minusculas
function TJLBCDBTable.FindFieldIndex(nam: String):Integer;
var
 i      : integer;
 f      : TJLBCDBField;
begin
 for i:=0 to lstFields.Count-1 do
 begin
  f:=lstFields.items[i];
  if ( 0=AnsiCompareText(f.name,nam)) then
  begin
   Result:=i+1;
   Exit;
  end;
 end;

 raise Exception.Create('JLBCDB Error: No se encuentra campo con nombre: "'+ nam +'"');

end;

procedure TJLBCDBTable.GetFieldByName(field: AnsiString;
  var val: AnsiString);
begin
  self.GetFieldByIndex( FindFieldIndex(field),val);
end;

procedure TJLBCDBTable.GetFieldByName(field: AnsiString; var val: Double);
begin
  self.GetFieldByIndex( FindFieldIndex(field),val);
end;

procedure TJLBCDBTable.GetFieldByIndex(i: Integer; var val: TDateTime);
var
 tmp,aux : String;
begin
 if not self.isActive then raise Exception.Create('JLBCdb ERROR: GetField no valido, la tabla no esta abierta...');
 if (i>nCampos)or(i<1) then raise Exception.Create('JLBCdb ERROR: Campo fuera de rango:'+inttostr(i));
 if (cursorPos>nregistros)or(cursorPos<1) then raise Exception.Create('JLBCdb ERROR: GetField no valid, registro inexistente...');

 tmp:=IFile.ReadString('r'+inttostr(self.cursorPos),'c'+inttostr(i),datetostr(now{today}));

 val:=0;
 // Formato:
 //  "2" -> Fecha
 aux:=(TJLBCDBField(lstFields.Items[i-1])).kind;

 if (aux<>'2') then raise Exception.create('JLBCdb ERROR: No se puede pasar campo a fecha...');

 try
  val:=Strtodate(tmp);
 except
 end;
end;

procedure TJLBCDBTable.GetFieldByName(field: AnsiString;
  var val: TDateTime);
begin
 self.GetFieldByIndex( FindFieldIndex(field),val);
end;

procedure TJLBCDBTable.SetFieldByIndex(i: Integer; val: TDateTime);
var
 aux,str : String;
begin
 if not self.isActive then raise Exception.Create('JLBCdb ERROR: SetField no valido, la tabla no esta abierta...');
 if (i>nCampos)or(i<1) then raise Exception.Create('JLBCdb ERROR: Campo fuera de rango:'+inttostr(i));
 if (cursorPos>nregistros)or(cursorPos<1) then raise Exception.Create('JLBCdb ERROR: GetField no valid, registro inexistente...');


 str:='';
 // Formato:
 //  "2" -> Fecha
 aux:=(TJLBCDBField(lstFields.Items[i-1])).kind;

 if (copy(aux,1,1)<>'2') then raise Exception.create('JLBCdb ERROR: SetField, campo no es de fecha...');

 str:=DateToStr(val);

 IFile.WriteString('r'+inttostr(self.cursorPos),'c'+inttostr(i),str);

end;

procedure TJLBCDBTable.SetFieldByName(field:String; val: TDateTime);
begin
 SetFieldByIndex( FindFieldIndex(field),val);
end;

function TJLBCDBTable.FindRegisterByField(indx: String; start: Integer;
  txt: AnsiString): Integer;
begin
  Result:= FindRegisterByField(FindFieldIndex(indx),start,txt);
end;


procedure TJLBCDBTable.UpdateFile;
begin
        IFile.UpdateFile;
end;


destructor TJLBCDBTable.Destroy; 
begin
        if assigned( IFile) then
        begin
                IFile.UpdateFile;
                IFile.Destroy;
        end;

        if assigned( lstFields) then
                lstFields.Destroy;

        inherited;
end;



end.

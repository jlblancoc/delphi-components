unit janHTMLParser;

{ This code is based upon original code by
  Dennis Spreen - dennis@spreendigital.de
  and is included in this unit with his permission

  23-october-1999
  added by Jan Verhoeven  - jan1.verhoeven@wxs.nl
    procedure GetCSV, to extract a HTML table as a CSV TStringList

  }


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, Buttons;

type THTMLParam = class
     private
      fRaw:string;
      fKey:string;
      fValue:string;
      procedure SetKey(Key:string);
     public
      constructor Create;
      destructor Destroy; override;
     published
      property Key:string read fKey write SetKey;
      property Value:string read fValue;
      property Raw:string read fRaw;
     end;

type THTMLTag = class
     private
      fName:string;
      fRaw:string;
      procedure SetName(Name:string);
     public
      Params:TList;
      constructor Create;
      destructor Destroy; override;
     published
      property Name:string read fName write SetName; // uppercased TAG (without <>)
      property Raw:string read fRaw; // raw TAG (parameters included) as read from input file (without<>)
     end;

type THTMLText = class
     private
      fLine:String;
      fRawLine:string;
      procedure SetLine(Line:string);
     public
      constructor Create;
      destructor Destroy; override;
     published
      property Line:string read fLine write SetLine;   // HTML3.2 Entities and Western Latin-1 Font converted Text
      property Raw:string read fRawLine; // raw text line as read from input file
     end;

type TjanHTMLParser = class(TObject)
     private
       Text:string;
       Tag:string;
       isTag:boolean;
       procedure AddText;
       procedure AddTag;
       procedure GetParsedLines(alist:TStringList);
     public
       parsed:TList;
       Lines:TStringlist;
       constructor Create;
       destructor Destroy; override;
       procedure Execute;
       procedure GetCSV(csvlist:TStringlist);
     published
     end;

implementation



constructor TjanHTMLParser.Create;
begin
 inherited Create;
 Lines:=TStringlist.Create;
 Parsed:=TList.Create;
end;

destructor TjanHTMLParser.Destroy;
begin
 Lines.Free;
 Parsed.Free;
 inherited Destroy;
end;


procedure TjanHTMLParser.AddText;
var HTMLText:THTMLText;

begin
 if not isTag then
  if Text<>'' then
   begin
    HTMLText:=THTMLText.Create;
    HTMLText.Line:=Text;
    Text:='';
    parsed.Add(HTMLText);
   end;
end;


procedure TjanHTMLParser.AddTag;
var HTMLTag:THTMLTag;
begin
 isTag:=false;
 HTMLTag:=THTMLTag.Create;
 HTMLTag.Name:=Tag;
 Tag:='';
 parsed.Add(HTMLTag);
end;



procedure TjanHTMLParser.Execute;
var i:integer;
    s:string;
begin
 Text:='';
 Tag:='';
 isTag:=false;
 for i:= 1 to Lines.Count do
  begin
   s:=Lines[i-1];
   while Length(s)>0 do
    begin
     if s[1]='<' then begin AddText;isTag:=true;end
     else
     if s[1]='>' then AddTag
     else
     if isTag then Tag:=Tag+s[1]
              else Text:=Text+s[1];
     delete(s,1,1);
    end;
   if (not isTag) and (Text<>'') then Text:=Text+#10;
  end;
 if (isTag) and (Tag<>'') then AddTag;
 if (not isTag) and (Text<>'') then AddText;
end;




constructor THTMLTag.Create;
begin
 inherited Create;
 Params:=Tlist.Create;
end;


destructor THTMLTag.Destroy;
var i:integer;
begin
 for i:= Params.Count downto 1 do
 begin
  THTMLparam(Params[i-1]).Free;
  Params.delete(i-1);
 end;
 Params.Free;
 inherited Destroy;
end;



procedure THTMLTag.SetName(Name:string);
var Tag:string;
    param:string;
    HTMLParam:THTMLParam;
    isQuote:boolean;
begin
 fRaw:=Name;
 Params.clear;

 while (Length(Name)>0) and (Name[1]<>' ') do
  begin
   Tag:=Tag+Name[1];
   Delete(Name,1,1);
  end;

 fName:=uppercase(Tag);

 while (Length(Name)>0) do
 begin
  param:='';
  isQuote:=false;
  while (Length(Name)>0) and ( not ((Name[1]=' ') and (isQuote=false))) do
   begin
    if Name[1]='"' then
    IsQuote:=not(IsQuote);
    param:=param+Name[1];
    Delete(Name,1,1);
   end;

  if (Length(Name)>0) and (Name[1]=' ') then Delete(Name,1,1);
  if param<>'' then
   begin
    HTMLParam:=THTMLParam.Create;
    HTMLParam.key:=param;
    params.add(HTMLParam);
   end;
 end;

end;


{$i janHTMLlatin1.pas}

procedure THTMLText.SetLine(Line:string);
var j,i:integer;
    isEntity:boolean;
    Entity:string;
    EnLen,EnPos:integer;
    d,c:integer;
begin
 fRawLine:=Line;
 while pos(#10,Line)>0 do Line[Pos(#10,Line)]:=' ';
 while pos('  ',Line)>0 do delete(Line,pos('  ',Line),1);

 i:=1;
 isEntity:=false;
 EnPos:=0;
 while (i<=Length(Line)) do
  begin
   if Line[i]='&' then begin EnPos:=i;isEntity:=true;Entity:='';end;
   if isEntity then Entity:=Entity+Line[i];
   if isEntity then
   if (Line[i]=';') or (Line[i]=' ') then begin
                         EnLen:=Length(Entity);

                         // charset encoded entity
                         if (EnLen>2) and (Entity[2]='#') then
                          begin
                           delete(Entity,EnLen,1); //delete the ;
                           delete(Entity,1,2); // delete the &#
                           if uppercase(Entity[1])='X' then Entity[1]:='$'; // it's hex (but not supported!!!)
                           if (Length(Entity)<=3) then // we cant convert e.g. cyrillic/chinise capitals
                            begin
                             val(Entity,d,c);
                             if c=0 then // conversion successful
                              begin
                               delete(Line,EnPos,EnLen);
                               insert(Charset[d],Line,EnPos);
                               i:=EnPos; // set new start
                              end;
                            end;
                          end
                          else
                          begin // its an entity
                           j:=1;
                           while (j<=100) do
                            begin
                             if Entity=(Entities[j,1]) then
                              begin
                               delete(Line,EnPos,EnLen);
                               insert(Entities[j,2],Line,Enpos);
                               j:=102; // stop searching
                              end;
                             j:=j+1;
                            end;
                          // reset Line
                          if j=103 then i:=EnPos-1
                                   else i:=EnPos;
                          end;

                         IsEntity:=false;
                       end;
   i:=i+1;
  end;

 fLine:=Line;
end;


procedure THTMLParam.SetKey(Key:string);
begin
 fValue:='';
 fRaw:=Key;
 if pos('=',key)<>0 then
  begin
   fValue:=Key;
   delete(fValue,1,pos('=',key));
   key:=copy(Key,1,pos('=',key)-1);

   if Length(fValue)>1 then
    if (fValue[1]='"') and (fValue[Length(fValue)]='"') then
     begin
      delete(fValue,1,1);
      delete(fValue,Length(fValue),1);
     end;
  end;
 fKey:=uppercase(key);
end;

constructor THTMLParam.Create;
begin
 inherited Create;
end;

destructor THTMLParam.Destroy;
begin
 inherited Destroy;
end;

constructor THTMLText.Create;
begin
 inherited Create;
end;

destructor THTMLText.Destroy;
begin
 inherited Destroy;
end;

procedure TjanHTMLParser.GetParsedLines(alist:TStringlist);
var
  s:string;
  j,i:integer;
  obj:TObject;
  HTMLTag:THTMLTag;
  HTMLParam:THTMLParam;
begin
  for i:= 1 to parsed.count do
  begin
   obj:=parsed[i-1];

   if obj.classtype=THTMLTag then
    begin
     HTMLTag:=THTMLTag(obj);
     s:='TAG: <'+HTMLTag.Name;
     if HTMLTag.Params.count=0 then alist.add(s+'>')
     else
     begin
       alist.add(s);
       for j:= 1 to HTMLTag.Params.count do
       begin
         HTMLParam:=HTMLTag.Params[j-1];
         s:='  P:   '+HTMLParam.key;
         if HTMLParam.value<>'' then s:=s+'=>'+HTMLParam.value;
         if j=HTMLTag.Params.count then s:=s+'>';
         alist.add(s);
       end;
     end;
    end;
   if obj.classtype=THTMLText then alist.add('TXT: '+THTMLText(obj).Line);
  end;
end;



procedure TjanHTMLParser.GetCSV(csvlist: TStringlist);
var
  Hlist:tstringlist;
  aRecord:tstringlist;
  i:integer;
  fieldcount:integer;
  s,Afield:string;
  hasfield:boolean;
  hasrecord:boolean;
  hastable:boolean;
begin
  Hlist:=tstringlist.create;
  GetparsedLines(HList);
  if Hlist.count=0 then
  begin
    Hlist.free;
    exit;
  end;
  aRecord:=tstringlist.create;
  csvlist.clear;
  Afield:='';
  hasfield:=false;
  hasrecord:=false;
  hastable:=false;
  for i:=0 to Hlist.count-1 do
  begin
    s:=Hlist[i];
    if pos('TAG: <TABLE',s)=1 then
    begin
      hastable:=true;
    end;
    if not hastable then continue;

    if pos('TAG: </TABLE>',s)=1 then
      break;

    if pos('TXT:',S)=1 then
    begin
      if hasfield then
      begin
        s:=trimleft(copy(s,6,length(s)));
        Afield:=Afield+s;
      end;
    end
    else if pos('TAG: <TD',s)=1 then
      hasfield:=true
    else if pos('TAG: </TD>',s)=1 then
    begin
      Arecord.Append (Afield);
      AField:='';
      hasfield:=false;
    end
    else if pos('TAG: </TR>',s)=1 then
    begin
       if not hasrecord then
       begin
         fieldcount:=Arecord.Count ;
         hasrecord:=true;
         csvlist.Append (ARecord.commatext);
         Arecord.Clear ;
       end
       else
       begin
         if Arecord.count<fieldcount then
         begin
           repeat
             Arecord.Append ('-');
           until Arecord.count=fieldcount;
         end
         else if Arecord.count>fieldcount then
         begin
           repeat
             arecord.Delete (Arecord.count-1);
           until Arecord.count=fieldcount;
         end;
         csvlist.Append (ARecord.commatext);
         Arecord.Clear ;
       end;
    end;

  end;
  aRecord.free;
  HList.free;
end;

end.

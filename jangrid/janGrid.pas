unit janGrid;

{This component is created by Jan Verhoeven, 29-May-1999
Email: jan1.verhoeven@wxs.nl
URL: http://members.xoom.com/JanVee/freeware.htm

Revision 4: 20-october-1999
    renamed
      TjvStringGrid to TjanGrid
        the jan prefix is now registered at www.href.com in the delphi prefix register

    added
     procedure LoadfromHTML
     procedure SetHeader
       keymapping ctrl+H is SetHeader
     property A1Style
       allows selecting between RC and A1 style headers
     cell references can be both A1 and R1C1 style
     cellnames, give cells a name and refer in formulas to names
       cellnames are autosaved as line 6 in cvt
      procedure AddCellName
      procedure DeleteCellName
      procedure DeleteCellNameRC
      procedure ClearCellNames
      function  FindCellname
      dialog CellNames
      Cellhints show CellName and Formula
    modified
     ToSortType to avoid conflict with Date function

Revision 3: 13-september-1999
    added
     method HideRows
     method Showrows
     method HideColumns
     method ShowColumns
     method autoSizeVisibleRows
     method FilterRows
       syntax: [Fieldname1] operand "FilterValue1"  [Fieldname1] operand "FilterValue1"  etc
     method showquerydialog
     private FOldColWidths
     property KeyMappings
     property KeyMappingsEnabled

    integrated Print/Preview dialog

    added Bands
    added numbers align right

    autosave formatfile .cvf for .csv file
    autoload formatfile .cvf for .csv file when present
      formatfile contains:
       line 0: colwidths as commatext
       line 1: rowheights as commatext
       line 2: gridfont as commatext (name, size)
       line 3: Bands Show,Color,Interval
       line 4: Numbers (right, format)
       line 5: PrintOptions
       line 6: FCellnames name1=B3|name2=AA34 etc. (added in release 4)
Revision 2: 4-september-1999
added
    private FParser
    private FCellValues
    property AutoRecalculate
    property ShowValues
    procedure Recalculate
    property NumberFormat
    property wordwrap
    procedure AutoSizeRows
    procedure SaveToXML
    procedure SaveToHTML

Revision 1: 25-june-1999
added:
    procedure CopyRange;
    procedure CutRange;
    procedure PasteRange;
    procedure ClearRange;
    procedure FillRange;
    procedure DuplicateRow;
    procedure Sort and related properties
    procedure Print;
    procedure PrintPreview(Image: TImage);
}

interface

uses
  Windows,
  Messages,
  SysUtils,
  Classes,
  Graphics,
  Controls,
  Forms,
  Dialogs,
  Grids,
  Extctrls,
  clipbrd,
  printers,
  menus;


type
 TGetVarEvent = procedure(Sender : TObject; VarName : string; var
    Value : Extended; var Found : Boolean) of object;

  TParseErrorEvent = procedure(Sender : TObject; ParseError : Integer)
    of object;

  TAdvanceDirection=(none,right,down);
const
  ParserStackSize = 15;
  MaxFuncNameLen = 5;
  ExpLimit = 11356;
  SqrLimit = 1E2466;
  MaxExpLen = 4;
  TotalErrors = 7;
  ErrParserStack = 1;
  ErrBadRange = 2;
  ErrExpression = 3;
  ErrOperator = 4;
  ErrOpenParen = 5;
  ErrOpCloseParen = 6;
  ErrInvalidNum = 7;

type
  ErrorRange = 0..TotalErrors;

  TokenTypes = (Plus, Minus, Times, Divide, Expo, OParen, CParen, Num,
                Func, EOL, Bad, ERR, Modu);

  TokenRec = record
    State : Byte;
    case Byte of
      0 : (Value : Extended);
      2 : (FuncName : String[MaxFuncNameLen]);
  end; { TokenRec }

type
  TjanMathParser = class(TComponent)
  private
    { Private declarations }
      FInput : string;
      FOnGetVar : TGetVarEvent;
      FOnParseError : TParseErrorEvent;
  protected
    { Protected declarations }
      CurrToken : TokenRec;
      MathError : Boolean;
      Stack : array[1..ParserStackSize] of TokenRec;
      StackTop : 0..ParserStackSize;
      TokenError : ErrorRange;
      TokenLen : Word;
      TokenType : TokenTypes;
    function GotoState(Production : Word) : Word;
    function IsFunc(S : String) : Boolean;
    function IsVar(var Value : Extended) : Boolean;
    function NextToken : TokenTypes;
    procedure Push(Token : TokenRec);
    procedure Pop(var Token : TokenRec);
    procedure Reduce(Reduction : Word);
    procedure Shift(State : Word);
  public
    { Public declarations }
      Position : Word;
      ParseError : Boolean;
      ParseValue : Extended;
    constructor Create(AOwner: TComponent);override;
    procedure Parse;
  published
    { Published declarations }
    property OnGetVar : TGetVarEvent read FOnGetVar write FOnGetVar;
    property OnParseError : TParseErrorEvent read FOnParseError
      write FOnParseError;
    property ParseString : string read FInput write FInput;
  end;


type
  TPrintMode = (pmPrint, pmPreview, pmPageCount);
  ToSortType  = (tstCharacter, tstNumeric, tstDate);
  SortDirType = (Ascending, Descending);
  SortType    = (stRow,stColumn);
  TBorderStyle = bsNone..bsSingle;

 TPrintOptions = class(TPersistent)
  private
    fJobTitle: String;
    fPageTitle: String;
    fPageTitleMargin: Cardinal;
    fCopies: Cardinal;
    fPreviewPage,fFromRow, fToRow: Cardinal;
    fBorderStyle: TBorderStyle;
    fLeftPadding:Cardinal;
    FMarginBottom: Cardinal;
    FMarginLeft: Cardinal;
    FMarginTop: Cardinal;
    FMarginRight: Cardinal;
    FPageFooter: string;
    FDateFormat: string;
    FTimeFormat: string;
    FHeaderSize: Cardinal;
    FFooterSize: Cardinal;
    FOrientation: TPrinterOrientation;
    FLogo: string;
    procedure SetMarginBottom(const Value: Cardinal);
    procedure SetMarginLeft(const Value: Cardinal);
    procedure SetMarginTop(const Value: Cardinal);
    procedure SetMarginRight(const Value: Cardinal);
    procedure SetPageFooter(const Value: string);
    procedure SetDateFormat(const Value: string);
    procedure SetTimeFormat(const Value: string);
    procedure SetFooterSize(const Value: Cardinal);
    procedure SetHeaderSize(const Value: Cardinal);
    procedure SetOrientation(const Value: TPrinterOrientation);
    procedure SetLogo(const Value: string);
  protected
  public

  private
  published
    property Orientation:TPrinterOrientation read FOrientation write SetOrientation;
    property JobTitle: string read fJobTitle write fJobTitle;
    property PageTitle: string read fPageTitle write fPageTitle;
    property Logo:string read FLogo write SetLogo;
    property PageTitleMargin: Cardinal read fpageTitleMargin write fpageTitleMargin;
    property PageFooter:string read FPageFooter write SetPageFooter;
    property HeaderSize:Cardinal read FHeaderSize write SetHeaderSize;
    property FooterSize:Cardinal read FFooterSize write SetFooterSize;
    property DateFormat:string read FDateFormat write SetDateFormat;
    property TimeFormat:string read FTimeFormat write SetTimeFormat;
    property Copies: Cardinal read fCopies write fCopies default 1;
    property FromRow: Cardinal read fFromRow write fFromRow;
    property ToRow: Cardinal read fToRow write fToRow;
    property PreviewPage: Cardinal read fPreviewPage write fPreviewPage;
    property BorderStyle:TBorderstyle read fBorderStyle write fBorderStyle;
    property Leftpadding:Cardinal read fLeftpadding write fLeftpadding;
    property MarginBottom:Cardinal read FMarginBottom write SetMarginBottom;
    property MarginLeft:Cardinal read FMarginLeft write SetMarginLeft;
    property MarginTop:Cardinal read FMarginTop write SetMarginTop;
    property MarginRight:Cardinal read FMarginRight write SetMarginRight;
  end;

  TonSizeChanged=procedure (sender:Tobject;OldColCount, OldRowCount: Longint) of object;

  TGridKeyMappings=class(TPersistent)
  private
    FColumnDelete: TShortCut;
    FColumnInsert: TShortCut;
    FRowInsert: TShortCut;
    FRowDelete: TShortCut;
    FQueryDialog: TshortCut;
    FPrintPreview: TShortCut;
    FFormuleDialog: TShortCut;
    FCellNamesDialog: Tshortcut;
    FSetHeader: Tshortcut;
    procedure SetColumnDelete(const Value: TShortCut);
    procedure SetColumnInsert(const Value: TShortCut);
    procedure SetRowDelete(const Value: TShortCut);
    procedure SetRowInsert(const Value: TShortCut);
    procedure SetPrintPreview(const Value: TShortCut);
    procedure SetQueryDialog(const Value: TshortCut);
    procedure SetFormuledialog(const Value: TShortCut);
    procedure SetCellNamesDialog(const Value: Tshortcut);
    procedure SetSetHeader(const Value: Tshortcut);
   {private declerations}
  protected
   {protected declerations}
  public
   {public declerations}
  published
   {published declerations}
   property RowInsert: TShortCut read FRowInsert write SetRowInsert;
   property RowDelete: TShortCut read FRowDelete write SetRowDelete;
   property ColumnInsert:TShortCut read FColumnInsert write SetColumnInsert;
   property ColumnDelete: TShortCut read FColumnDelete write SetColumnDelete;
   property PrintPreview: TShortCut read FPrintPreview write SetPrintPreview;
   property QueryDialog:TshortCut read FQueryDialog write SetQueryDialog;
   property FormuleDialog:TShortCut read FFormuleDialog write SetFormuleDialog;
   property CellNamesDialog:Tshortcut read FCellNamesDialog write SetCellNamesDialog;
   property SetHeader:Tshortcut read FSetHeader write SetSetHeader;
  end;


  TjanGrid = class(TStringGrid)
  private
    { Private declarations }
    FCellNames:TStringlist;
    FFormuleMode:boolean;
    parserow,parsecol:integer;
    FParser: TjanMathParser;
    FCellValues:array of array of extended;
    FOldColWidths:array of integer;
    FUpdateValues:boolean;
    FParseError:boolean;
    FStartIndex : Integer;
    FEndIndex : Integer;
    FSortIndex : Integer;
    FSortType : ToSortType;
    FCaseSensitiv : Boolean;
    FSortDir : SortDirType;
    FShowMsg : Boolean;
    FHowToSort : SortType;
    FPrintOptions: TPrintOptions;
    FPageCount: Cardinal;
    FAutoSizeMargin: LongInt;
    FRecordList:TStringlist;
    FFieldList:TStringlist;
    FShowValues: boolean;
    FAutoCalculate: boolean;
    FNumberFormat: string;
    FWordWrap: boolean;
    FAdvanceDirection: TAdvanceDirection;
    FHighlightURL: boolean;
    FonSizeChanged: TonSizeChanged;
    FPrintImage:TBitmap;
    FBandsShow: boolean;
    FBandsInterval: integer;
    FBandsColor: TColor;
    FNumbersalRight: boolean;
    FKeyMappings: TGridKeyMappings;
    FKeyMappingsEnabled: Boolean;
    FA1Style: boolean;
    procedure DoShowHint(var HintStr: string; var CanShow: Boolean; var HintInfo: THintInfo);
    function RCtostr(Acol,Arow:integer):string;
    function Ctostr(Acol:integer):string;
    function strtoRC(s:string; var Acol,Arow:integer):boolean;
    procedure SaveToFormat(afile:string);
    procedure SetCellValues;
    procedure ParserGetVar(Sender: TObject; VarName: String;
  var Value: Extended; var Found: Boolean);
    procedure ParserParseError(Sender: TObject;
  ParseError: Integer);
    procedure SetColumnHeaders(const Value: Tstrings);
    function  GetColumnHeaders:Tstrings;
    procedure AutoInitialize;
    procedure QuickSortGrid(sGrid : TStringGrid; StartIdx, EndIdx, SortIdx : Integer);
    procedure BubbleSortGrid(sGrid : TStringGrid; StartIdx, EndIdx, SortIdx : Integer);
    procedure qsortGrid(sGrid : TStringGrid; StartIdx, EndIdx, SortIdx : Integer);
    procedure qsortGridNumeric(sGrid : TStringGrid; StartIdx, EndIdx, SortIdx : Integer);
    procedure qsortGridDate(sGrid : TStringGrid; StartIdx, EndIdx, SortIdx : Integer);
    procedure DrawToCanvas(ACanvas: TCanvas; Mode: TPrintMode; FromRow, ToRow:Integer);
    procedure SetShowValues(const Value: boolean);
    procedure SetAutoCalculate(const Value: boolean);
    procedure SetNumberFormat(const Value: string);
    procedure SetWordWrap(const Value: boolean);
    procedure SetAdvanceDirection(const Value: TAdvanceDirection);
    procedure SetHighlightURL(const Value: boolean);
    procedure SetonSizeChanged(const Value: TonSizeChanged);
    procedure LoadFromFormat(afile: string);
    procedure SetBandsColor(const Value: TColor);
    procedure SetBandsInterval(const Value: integer);
    procedure SetBandsShow(const Value: boolean);
    function booltostr(Abool: boolean): string;
    function strtobool(Astring: string): boolean;
    procedure SetNumbersalRight(const Value: boolean);
    procedure AutoSizeColumnsInt;
    procedure AutoSizeRowsInt;
    procedure AutoSizeHiddenRows;
    procedure AutoSizeRowsEx;
    procedure SetKeyMappings(const Value: TGridKeyMappings);
    procedure SetUpKeyMappings;
    procedure SetKeyMappingsEnabled(const Value: Boolean);
    procedure ApplyFilter;
    function parseFilter(Afilter: string): boolean;
    procedure SetFormuleMode(const Value: boolean);
    procedure SetA1Style(const Value: boolean);
    procedure AddCellName(Aname:string;Acol,Arow:integer);
    procedure DeleteCellName(Aname:string);
    function  FindCellName(Aname:string; var ACol, Arow:integer):boolean;
    procedure ClearCellNames;
    procedure DeleteCellNameRC(acol,arow:integer);
    function  FindCellNameRC(acol,arow:integer;var Aname:string):boolean;
    procedure CSVtoGrid;
  protected
    { Protected declarations }
    procedure SizeChanged(OldColCount, OldRowCount: Longint); override;
    procedure KeyUp(var Key: Word; Shift: TShiftState);override;
    procedure Keydown(var Key: Word; Shift: TShiftState);override;
    procedure KeyPress(var Key: Char);override;
    procedure DrawCell(ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);override;
    function SelectCell(ACol, ARow: Longint):boolean;override;
  public
    { Public declarations }
    ErrorCode : Integer;
    ErrorText : String;

    constructor Create (AOwner:TComponent); override;
    destructor Destroy; override;
    procedure SmoothResize(var Src, Dst: TBitmap);
    procedure UpdatePreview(Acanvas: TCanvas);
    procedure Recalculate;
    procedure LoadFromCSV (Afile:string);
    procedure SaveToCSV (Afile:string);
    procedure SaveToHTML (Afile:string);
    procedure LoadFromHTML (Afile:string);
    procedure SaveToXML (Afile:string);
    procedure ClearNormalCells;
    procedure ClearAllCells;
    procedure InsertRow;
    procedure RowDelete;
    procedure InsertColumn;
    procedure ColumnDelete;
    procedure AppendRow;
    procedure AppendColumn;
    procedure AutoSizeColumns;
    procedure AutoSizeColumn;
    procedure AutoSizeVisibleRows;
    procedure AutoSizeRows;
    procedure AutoSizeRow(ARow:integer);
    procedure CopyRange;
    procedure CutRange;
    procedure PasteRange;
    procedure ClearRange;
    procedure FillRange;
    procedure DuplicateRow;
    function  Sort : Boolean; //execute sort
    procedure Print;
    procedure PrintPreview;
    function  PageCount: Integer;
    procedure HideRows;
    procedure ShowRows;
    procedure ShowColumns;
    procedure HideColumns;
    procedure FilterRows(AFilter:string);
    procedure ShowQueryDialog;
    procedure ShowFormuleDialog;
    procedure ShowCellNamesDialog;
    procedure SetHeader;
  published
    { Published declarations }
    property A1Style:boolean read FA1Style write SetA1Style;
    property KeyMappingsEnabled:Boolean read FKeyMappingsEnabled write SetKeyMappingsEnabled;
    property KeyMappings:TGridKeyMappings read FKeyMappings write SetKeyMappings;
    property NumbersalRight:boolean read FNumbersalRight write SetNumbersalRight;
    property BandsShow: boolean read FBandsShow write SetBandsShow;
    property BandsColor: TColor read FBandsColor write SetBandsColor;
    property BandsInterval: integer read FBandsInterval write SetBandsInterval;
    property HighlightURL:boolean read FHighlightURL write SetHighlightURL;
    property AdvanceDirection:TAdvanceDirection read FAdvanceDirection write SetAdvanceDirection;
    property NumberFormat:string read FNumberFormat write SetNumberFormat;
    property AutoCalculate:boolean read FAutoCalculate write SetAutoCalculate;
    property ShowValues:boolean read FShowValues write SetShowValues;
    property ColumnHeaders:Tstrings read GetColumnHeaders write SetColumnHeaders;
    property StartIndex : Integer read FStartIndex write FStartIndex;
    property EndIndex : Integer read FEndIndex write FEndIndex;
    property SortIndex : Integer read FSortIndex write FSortIndex;
    property SortType : ToSortType read FSortType write FSortType;
    property CaseSensitiv : Boolean read FCaseSensitiv write FCaseSensitiv;
    property SortDirection : SortDirType read FSortDir write FSortDir;
    property HowToSort : SortType read FHowToSort write FHowToSort;
    property ShowMessageOnError : Boolean read FShowMsg write FShowMsg;
    property PrintOptions: TPrintOptions read fPrintOptions write fPrintOptions;
    property AutoSizemargin: LongInt read fAutoSizeMargin write fAutoSizeMargin;
    property WordWrap:boolean read FWordWrap write SetWordWrap;
    property onSizeChanged: TonSizeChanged read FonSizeChanged write SetonSizeChanged;
    property FormuleMode:boolean read FFormuleMode write SetFormuleMode;
  end;




procedure Register;

implementation

uses
  janGridPreview,janGridQuery, janGridFormule,
  janGridCellNames, janHTMLParser;



const
  cr = chr(13)+chr(10);
  tab = chr(9);

   MinErrCode = -4;
   MaxErrCode = 7;
   ErrorTextConst : Array [MinErrCode..MaxErrCode] of string = (
{-4}   'Case Sensitivity ignored for Date Sort.'
{-3}  ,'Case Sensitivity ignored for Numeical Sort.'
{-2}  ,'Column/Row contains non-date values for date sort. Sorted as Character.'
{-1}  ,'Column/Row contains non-numerical values for numeric sort. Sorted as Character.'
{ 0}  ,'Ok'
{ 1}  ,'No StringGrid given'
{ 2}  ,'StartIndex is greater or equal to EndIndex'
{ 3}  ,'StartIndex is less then 0'
{ 4}  ,'StartIndex is greater then number of rows/columns in StringGrid'
{ 5}  ,'EndIndex is greater then number of rows/columns in StringGrid'
{ 6}  ,'Sort Index is less then 0'
{ 7}  ,'Sort Index is greater then number of rows/columns in StringGrid'
   );


Type
 TGridFilterFunc=function(FieldValue,FilterValue:string):boolean;

 TGridFieldFilter=record
  FilterFunc: TGridFilterFunc;
  FilterField: integer;
  FilterValue:string;
  end;

 TGridRowFilter=record
  FilterCount:integer;
  Filters: array[0..9] of TGridFieldFilter;
  end;

var
 GridRowFilter: TGridRowFilter;
 FormuleDialog:TjanGridFormuleF;


procedure Register;
begin
  RegisterComponents('Jans 2', [TjanGrid]);
end;

// Grid filter functions

function filterEQ(FieldValue,FilterValue:string):boolean;
begin
 result:=FieldValue=FilterValue;
end;

function filterNE(FieldValue,FilterValue:string):boolean;
begin
 result:=FieldValue<>FilterValue;
end;

function filterGT(FieldValue,FilterValue:string):boolean;
begin
 result:=FieldValue>FilterValue;
end;

function filterLT(FieldValue,FilterValue:string):boolean;
begin
 result:=FieldValue<FilterValue;
end;

function filterLIKE(FieldValue,FilterValue:string):boolean;
begin
 result:=pos(lowercase(FilterValue),lowercase(FieldValue))>0;
end;

{ TjanGrid }

procedure TjanGrid.AutoInitialize;
var i:integer;
begin
   FStartIndex := 0;
   FEndIndex := 0;
   FSortIndex := 0;
   FSortType := tstCharacter;
   FCaseSensitiv := False;
   FSortDir := Ascending;
   FShowMsg := False;
   FHowToSort := stRow;
   Colwidths[0]:=20;
   font.name:='Arial';
   font.size:=8;
   FPrintOptions.PageFooter:='date|time|page';
   FPrintOptions.DateFormat :='d-mmm-yyyy';
   FprintOptions.TimeFormat :='h:nn am/pm';
   FprintOptions.HeaderSize:=font.size+2;
   FPrintOptions.FooterSize:=font.size-1;
   FUpdateValues:=true;
   BandsShow:=false;
   BandsColor:= rgb(206,250,253);
   BandsInterval:=2;
   setlength(FOldColWidths,colcount);
   for i:=0 to colcount-1 do
    FOldColWidths[i]:=defaultColWidth;
   SetCellValues;
end;


procedure TjanGrid.AppendColumn;
begin
ColCount :=colcount+1;
end;

procedure TjanGrid.AppendRow;
begin
RowCount:=RowCount+1;
end;


procedure TjanGrid.AutoSizeColumnsInt;
var i,j,w0,w:integer;
begin
 for j:=1 to colcount-1 do begin
  w0:=DefaultColWidth ;
  for i:=0 to RowCount -1 do begin
    w:=Canvas.TextWidth (cells[j,i])+AutoSizemargin;
    if w>w0 then w0:=w;
    end;
  colwidths[j]:=w0;
  end;
 colwidths[0]:=20; 
end;

procedure TjanGrid.AutoSizeColumns;
begin
 AutoSizeColumnsInt;
 AutoSizeRowsInt;
end;

constructor TjanGrid.Create(AOwner: TComponent);
begin
  inherited create (AOwner);
// my code
  FRecordlist:=tstringlist.create;
  FFieldlist:=tstringlist.create;
  FCellNames:=TStringList.create;
  FPrintOptions := TPrintOptions.Create;
  FParser:=TjanMathParser.create(self);
  FParser.OnGetVar :=ParserGetVar;
  FParser.OnParseError :=ParserParseError;
  FAutoCalculate:=true;
  FNumberformat:='%.2f';
  FKeyMappings:=TGridKeyMappings.Create ;
  FKeyMappingsEnabled:=true;
  SetUpKeyMappings;
  showhint:=true;
  Application.ShowHint := True;
  Application.OnShowHint := DoShowHint;
  AutoInitialize;
end;

procedure TjanGrid.SetUpKeyMappings;
begin
 FKeyMappings.RowInsert := TextToShortCut('Shift+Ins');
 FKeyMappings.RowDelete :=TextToShortCut('Shift+Del');
 FKeyMappings.ColumnInsert :=TextToShortCut('Ctrl+Shift+Ins');
 FKeyMappings.ColumnDelete :=TextToShortCut('Ctrl+Shift+Del');
 FKeyMappings.PrintPreview :=TextToShortCut('Ctrl+P');
 FKeyMappings.QueryDialog :=TextToShortCut('Ctrl+Q');
 FKeyMappings.FormuleDialog :=TextToShortCut('F3');
 FKeyMappings.CellNamesDialog :=TextToShortCut('Ctrl+N');
 FKeyMappings.SetHeader :=TexttoShortCut('Ctrl+H');
end;

procedure TjanGrid.ColumnDelete;
var i,acol:integer;
begin
 acol:=col;
 showColumns;
 if ColCount > 2 then begin
   DeleteColumn(Col);
   if acol<colcount then
    col:=acol;
   end;
end;


procedure TjanGrid.RowDelete;
var i,arow:integer;
begin
 arow:=row;
 showrows;
 if RowCount > 2 then begin
  DeleteRow(row);
  if arow<rowcount then
   row:=arow;
  end;
end;


destructor TjanGrid.Destroy;
begin
  FFieldlist.free;
  FRecordlist.free;
  FCellNames.free;
  FParser.Free;
  FPrintOptions.Free;
  FKeyMappings.free;
  inherited Destroy;
end;

procedure TjanGrid.ShowColumns;
var i:integer;
begin
 for i:=1 to colcount-1 do
  ColWidths[i]:=FOldColWidths[i];
end;

procedure TjanGrid.InsertColumn;
var Acol,i:integer;
begin
 showColumns;
 Acol:=col;
 ColCount :=ColCount +1;
 setlength(FOldColWidths,colcount);
 for i:=ColCount -2 downto Acol do begin
  cols [i+1]:=cols[i];
  FOldColWidths[i+1]:=  FOldColWidths[i];
  end;
 Colwidths[Acol]:=defaultcolwidth;
 FOldColwidths[Acol]:=defaultcolwidth;
 for i:=0 to RowCount -1 do
  Cells[Acol,i]:='';
 col:=Acol; 
end;


procedure TjanGrid.InsertRow;
var Arow,i:integer;
begin
 Arow:=row;
 RowCount :=RowCount +1;
 for i:=RowCount -2 downto Arow do
  Rows [i+1]:=rows[i];
 for i:=0 to ColCount -1 do
  Cells[i,Arow]:='';
end;

procedure TjanGrid.CSVtoGrid;
var records,fields,i:integer;
begin
 FFieldList.Clear ;
 records:=FRecordList.count;
 if records>0 then begin
  FFieldList.CommaText :=FRecordList[0];
  fields:=FFieldList.count;
  if fields>0 then begin
    FUpdateValues:=false;
    ColCount :=fields+1;
    RowCount :=records;
    for i:=0 to records-1 do begin
      FFieldList.CommaText :=FRecordList[i];
      FFieldList.Insert (0,'');
      Rows [i].assign(FFieldList);
      end;
    end;
  end;
end;

procedure TjanGrid.LoadFromCSV(Afile: string);
begin
  FRecordList.LoadFromFile (Afile);
  CSVtoGrid;
  LoadFromFormat(afile);
  recalculate;
  colwidths[0]:=20;
  FUpdateValues:=true;
end;

procedure TjanGrid.SaveToCSV(Afile: string);
var records,fields,i:integer;
begin
 records:=RowCount ;
 fields:=ColCount ;
 if (records>0) and (fields>0) then begin
  FRecordList.clear;
  for i:=0 to records-1 do begin
    FFieldList.Assign (rows[i]);
    FFieldList.Delete (0);
    FRecordList.Append (FFieldList.commatext);
    end;
  FRecordList.SaveToFile (Afile);
  SaveToFormat(afile);
  end;
end;


procedure TjanGrid.AutoSizeColumn;
var i,w0,w:integer;
begin
 w0:=DefaultColWidth ;
 for i:=0 to RowCount -1 do begin
  w:=Canvas.TextWidth (cells[col,i]);
  if w>w0 then w0:=w;
  end;
 colwidths[col]:=w0+10;
end;

procedure TjanGrid.ClearNormalCells;
var r,c:integer;
begin
 if fixedrows>=rowcount then exit;
 if fixedcols>=colcount then exit;
   for r:=fixedrows to rowcount-1 do
     for c:=fixedcols to colcount-1 do begin
       cells[c,r]:='';
       FCellValues[c,r]:=0;
       end;
end;

procedure TjanGrid.ClearAllCells;
var r,c:integer;
begin
   for r:=0 to rowcount-1 do
     for c:=0 to colcount-1 do begin
       cells[c,r]:='';
       FCellValues[c,r]:=0;
       end;
end;

procedure TjanGrid.SetColumnHeaders(const Value: Tstrings);
begin
  Rows[0].assign(Value);
end;

function TjanGrid.GetColumnHeaders: Tstrings;
begin
 result:=rows[0];
end;

procedure TjanGrid.ClearRange;
var r1,c1,r2,c2,r,c:integer;
begin
 c1:=Selection.Left;
 r1:=selection.top;
 c2:=Selection.Right ;
 r2:=selection.Bottom ;
 if not ((c1>=0)and (r1>=0)and (c2>=c1)and (r2>=r1)) then exit;
 for r:=r1 to r2 do
   for c:=c1 to c2 do
    cells[c,r]:='';
end;

procedure TjanGrid.CopyRange;
var r1,c1,r2,c2,r,c:integer;
    list,flist:tstringlist;
begin
 c1:=Selection.Left;
 r1:=selection.top;
 c2:=Selection.Right ;
 r2:=selection.Bottom ;
 if not ((c1>=0)and (r1>=0)and (c2>=c1)and (r2>=r1)) then exit;
 list:=tstringlist.create;
 flist:=tstringlist.create;
 for r:=r1 to r2 do begin
   flist.clear;
   for c:=c1 to c2 do begin
    flist.append(cells[c,r]);
    end;
   list.append(flist.commatext);
   end;
 clipboard.astext:=list.text;
 flist.free;
 list.free;
end;

procedure TjanGrid.CutRange;
var r1,c1,r2,c2,r,c:integer;
    list,flist:tstringlist;
begin
 c1:=Selection.Left;
 r1:=selection.top;
 c2:=Selection.Right ;
 r2:=selection.Bottom ;
 if not ((c1>=0)and (r1>=0)and (c2>=c1)and (r2>=r1)) then exit;
 list:=tstringlist.create;
 flist:=tstringlist.create;
 for r:=r1 to r2 do begin
   flist.clear;
   for c:=c1 to c2 do begin
    flist.append(cells[c,r]);
    cells[c,r]:='';
    end;
   list.append(flist.commatext);
   end;
 clipboard.astext:=list.text;
 flist.free;
 list.free;
end;

procedure TjanGrid.DuplicateRow;
begin
 if row<(rowcount-1) then begin
  row:=row+1;
  InsertRow;
  rows[row].assign(rows[row-1]);
  end
  else begin
  RowCount :=RowCount +1;
  row:=RowCount-1;
  rows[row].assign(rows[row-1]);
  end;
end;

procedure TjanGrid.FillRange;
var r1,c1,r2,c2,r,c:integer;
    s:string;
begin
 c1:=Selection.Left;
 r1:=selection.top;
 c2:=Selection.Right ;
 r2:=selection.Bottom ;
 if not ((c1>=0)and (r1>=0)and (c2>=c1)and (r2>=r1)) then exit;
 s:=cells[c1,r1];
 for r:=r1 to r2 do
   for c:=c1 to c2 do
    cells[c,r]:=s;
end;

procedure TjanGrid.PasteRange;
var r1,c1,r2,c2,r,c,i,j:integer;
    list,flist:tstringlist;
begin
 if not clipboard.HasFormat(CF_TEXT) then exit;
 if not ((col>=0)and (row>=0)) then exit;
 list:=tstringlist.create;
 flist:=tstringlist.create;
 list.text:=clipboard.AsText ;
 if list.count>0 then begin
  c1:=col;
  r1:=row;
  flist.commatext:=list[0];
  c2:=c1+flist.count-1;
  r2:=r1+list.count-1;
  if c2>(colcount-1) then
    colcount:=c2+1;
  if r2>(rowcount-1) then
    rowcount:=r2+1;
  j:=0;
  for r:=r1 to r2 do begin
   flist.commatext:=list[j];
   i:=0;
   for c:=c1 to c2 do begin
    cells[c,r]:=flist[i];
    inc(i);
    end;
   inc(j);
   end;
 end;
 flist.free;
 list.free;
 AutoSizeColumns;
end;

function TjanGrid.Sort : Boolean;
Var
   CheckForNum, NumCheck, NumErr : Integer;
   StrToChk : String;

begin
   ErrorCode := 0;
   If FStartIndex >= FEndIndex THEN
      ErrorCode := 2
   Else If FStartIndex < 0 THEN
      ErrorCode := 3
   Else If FStartIndex > (RowCount-1) THEN
      ErrorCode := 4
   Else If FEndIndex > (RowCount-1) THEN
      ErrorCode := 5
   Else If FSortIndex < 0 THEN
      ErrorCode := 6
   Else If SortIndex > (ColCount-1) THEN
      ErrorCode := 7
   Else If SortType = tstNumeric THEN
      For CheckForNum := FStartIndex TO FEndIndex DO
      Begin
         If FHowToSort = stRow Then
            Val(Cols[FSortIndex].Strings[CheckForNum],NumCheck,NumErr)
         else
            Val(Rows[FSortIndex].Strings[CheckForNum],NumCheck,NumErr);
         If NumErr <> 0 Then
         Begin
            ErrorCode := -1;
            SortType := tstCharacter
         end
         else
            If CaseSensitiv Then
               ErrorCode := -3;
      end
   Else If SortType = tstDate THEN
   begin
      If CaseSensitiv Then
         ErrorCode := -4;
      For CheckForNum := FStartIndex TO FEndIndex DO
      Begin
         If FHowToSort = stRow Then
            StrToChk := Cols[FSortIndex].Strings[CheckForNum]
         else
            StrToChk := Rows[FSortIndex].Strings[CheckForNum];
         Try
            StrToDate(StrToChk)
         Except On EConvertError do
            begin
               ErrorCode := -2;
               SortType := tstCharacter
            end
         end
      end
   end;

   ErrorText := ErrorTextConst[ErrorCode];
   Result := True;
   If ErrorCode <= 0 Then
   begin
      QuickSortGrid(self, FStartIndex, FEndIndex, FSortIndex);
      If (ErrorCode < 0) And FShowMsg Then
         MessageDlg(ErrorText,mtWarning,[mbOK],0)
   end
   else
   begin
      Result := False;
      If FShowMsg Then
         MessageDlg(ErrorText,mtError,[mbOK],0)
   end
end;

procedure TjanGrid.QuickSortGrid(sGrid : TStringGrid; StartIdx, EndIdx, SortIdx : Integer);
var
   j : Word;
   sortGrid, tempGrid : TStringGrid;

Function UpString(Instring : String) : String;
var
   tel : byte;
   outstring : string;
begin
   OutString := InString;
   FOR tel := 1 TO length(Instring) DO
      OutString[tel] := upcase(OutString[tel]);
   UpString := OutString;
end;

begin
   sortGrid := TStringGrid.Create(Nil);
   sortGrid.RowCount := sGrid.RowCount;
   sortGrid.ColCount := 2;
   for j := StartIdx to EndIdx do
   begin
      sortGrid.Cells[0, j] := IntToStr(j);
      If HowToSort = stRow Then
         sortGrid.Cells[1, j] := sGrid.Cells[SortIdx, j]
      else
         sortGrid.Cells[1, j] := sGrid.Cells[j, SortIdx]
   end;

   If SortType = tstCharacter Then
   begin
      If Not(CaseSensitiv) Then
         For j := StartIdx to EndIdx do
            SortGrid.Cells[1, j] := UpString(SortGrid.Cells[1, j]);
      qsortGrid(sortGrid, StartIdx, EndIdx, 1)
   end
   else if SortType = tstNumeric Then
      qsortGridNumeric(sortGrid, StartIdx, EndIdx, 1)
   else if SortType = tstDate Then
      qsortGridDate(sortGrid, StartIdx, EndIdx, 1);

   tempGrid := TStringGrid.Create(Nil);
   tempGrid.RowCount := sGrid.RowCount;
   tempGrid.ColCount := sGrid.ColCount;
   If HowToSort = stRow Then
   begin
      for j := StartIdx to EndIdx do
         tempGrid.rows[j] :=sGrid.rows[StrToInt(sortGrid.Cells[0,j])];
      for j := StartIdx to EndIdx do
         sGrid.rows[j] := tempGrid.rows[j]
   end
   else
   begin
      for j := StartIdx to EndIdx do
         tempGrid.cols[j] :=sGrid.cols[StrToInt(sortGrid.Cells[0,j])];
      for j := StartIdx to EndIdx do
         sGrid.cols[j] := tempGrid.cols[j]
   end;
   sortGrid.Free;
   If SortDirection = Descending THEN
   begin
      FOR j := EndIdx DOWNTO StartIdx DO
         If HowToSort = stRow THEN
            sGrid.rows[EndIdx-j+StartIdx] := tempGrid.rows[j]
         else
            sGrid.cols[EndIdx-j+StartIdx] := tempGrid.cols[j];
   end;
   tempGrid.Free
end;

procedure TjanGrid.BubbleSortGrid(sGrid : TStringGrid; StartIdx, EndIdx, SortIdx : Integer);
Var
   Idx : Word;
   Changed : Boolean;
   tempRow : TStringList;
   fields, i : Word;

begin
   tempRow :=TStringList.Create;
   fields := sGrid.ColCount;
   repeat
      Changed := False;
      for Idx := StartIdx to EndIdx-1 do
      begin
         if sGrid.Cells[SortIdx, Idx] > sGrid.Cells[SortIdx, Idx+1] then
         begin
            tempRow.Clear;
            for i := 0 to fields - 1 do
               tempRow.Add(sGrid.cells[i, Idx+1]);
            sGrid.rows[Idx+1] := sGrid.rows[Idx];
            for i := 0 to fields - 1 do
               sGrid.cells[i, Idx] := tempRow.Strings[i];
            Changed := True;
         end;
      end;
   until Changed = False;
   tempRow.Free;
end;

procedure TjanGrid.qsortGridNumeric(sGrid : TStringGrid; StartIdx, EndIdx, SortIdx : Integer);
Var
   x, y : Word;
   temp: Extended;
   tempRow : TStringList;
   ind : Word;
   fields, i : Word;
begin
   tempRow :=TStringList.Create;
   fields := sGrid.ColCount;
   if StartIdx < EndIdx then
   begin
      x:= StartIdx;
      y:= EndIdx;
      ind := (StartIdx+EndIdx) div 2;
      temp := StrToFloat(sGrid.cells[SortIdx, ind]);
      while x <= y do
      begin
         while StrToFloat(sGrid.cells[SortIdx, x]) < temp do
            Inc(x);
         while StrToFloat(sGrid.cells[SortIdx, y]) > temp do
            Dec(y);
         if x <= y then
         begin
            tempRow.Clear;
            for i := 0 to fields - 1 do
               tempRow.Add(sGrid.cells[i, x]);
            sGrid.rows[x] := sGrid.rows[y];
            for i := 0 to fields - 1 do
               sGrid.cells[i, y] := tempRow.Strings[i];
            Inc(x);
            Dec(y);
         end;
      end;
      tempRow.Free;
      qsortGridNumeric(sGrid, StartIdx, y, SortIdx);
      qsortGridNumeric(sGrid, x, EndIdx, SortIdx);
   end;
end;

procedure TjanGrid.qsortGridDate(sGrid : TStringGrid; StartIdx, EndIdx, SortIdx : Integer);
Var
   x, y : Word;
   temp: TDateTime;
   tempRow : TStringList;
   ind : Word;
   fields, i : Word;
begin
   tempRow :=TStringList.Create;
   fields := sGrid.ColCount;
   if StartIdx < EndIdx then
   begin
      x:= StartIdx;
      y:= EndIdx;
      ind := (StartIdx+EndIdx) div 2;
      temp := StrToDate(sGrid.cells[SortIdx, ind]);
      while x <= y do
      begin
         while StrToDate(sGrid.cells[SortIdx, x]) < temp do
               Inc(x);
         while StrToDate(sGrid.cells[SortIdx, y]) > temp do
               Dec(y);
         if x <= y then
         begin
            tempRow.Clear;
            for i := 0 to fields - 1 do
               tempRow.Add(sGrid.cells[i, x]);
            sGrid.rows[x] := sGrid.rows[y];
            for i := 0 to fields - 1 do
               sGrid.cells[i, y] := tempRow.Strings[i];
            Inc(x);
            Dec(y);
         end;
      end;
      tempRow.Free;
      qsortGridDate(sGrid, StartIdx, y, SortIdx);
      qsortGridDate(sGrid, x, EndIdx, SortIdx);
   end;
end;

procedure TjanGrid.qsortGrid(sGrid : TStringGrid; StartIdx, EndIdx, SortIdx : Integer);
Var
   x, y : Word;
   temp: String;
   tempRow : TStringList;
   ind : Word;
   fields, i : Word;

begin
   if (EndIdx-StartIdx) < 5 then
      BubbleSortGrid(sGrid, StartIdx, EndIdx, SortIdx)
   else
   begin
      tempRow :=TStringList.Create;
      fields := sGrid.ColCount;
      if StartIdx < EndIdx then
      begin
         x:= StartIdx;
         y:= EndIdx;
         ind := (StartIdx+EndIdx) div 2;
         temp := sGrid.cells[SortIdx, ind];
         while x <= y do
         begin
            while sGrid.cells[SortIdx, x] < temp do
               Inc(x);
            while sGrid.cells[SortIdx, y] > temp do
               Dec(y);
            if x <= y then
            begin
               tempRow.Clear;
               for i := 0 to fields - 1 do
                  tempRow.Add(sGrid.cells[i, x]);
               sGrid.rows[x] := sGrid.rows[y];
               for i := 0 to fields - 1 do
                  sGrid.cells[i, y] := tempRow.Strings[i];
               Inc(x);
               Dec(y);
            end;
         end;
         tempRow.Free;
         qsortGrid(sGrid, StartIdx, y, SortIdx);
         qsortGrid(sGrid, x, EndIdx, SortIdx);
      end;
   end;
end;

function TjanGrid.PageCount: Integer;
begin
  fPageCount := 0;
  DrawToCanvas(nil, pmPageCount, 1,RowCount-1);
  result := fPageCount;
end;

procedure TjanGrid.AutoSizeHiddenRows;
var i:integer;
begin
 for i:=1 to rowcount-1 do
  if rowheights[i]=0 then AutosizeRow(i);
end;

procedure TjanGrid.PrintPreview;
var preview: TjanGridPreviewF;
begin
  fPageCount := 0;
  preview:=TjanGridPreviewF.create(application);
  preview.Grid :=self;
  FPrintImage:=preview.PrintImage ;
  DrawToCanvas(FPrintImage.Canvas, pmPreview, 1,RowCount-1);
  preview.PreviewImage.picture.bitmap.Assign (FprintImage);
  preview.ShowModal;
  preview.free;
end;

procedure TjanGrid.UpdatePreview(Acanvas:TCanvas);
begin
  fPageCount := 0;
  DrawToCanvas(ACanvas, pmPreview, 1,RowCount-1);
end;

procedure TjanGrid.Print;
begin
  AutoSizeHiddenrows;
  if Printer.Printers.Count = 0 then
  begin
    MessageDlg('No Printer is installed', mtError, [mbOK],0);
    Exit;
  end;
  Printer.Title := PrintOptions.fJobTitle;
  Printer.Copies := PrintOptions.fCopies;
  Printer.BeginDoc;
  DrawToCanvas(Printer.Canvas, pmPrint, PrintOptions.FromRow,PrintOptions.ToRow);
  Printer.EndDoc;
end;

procedure TjanGrid.DrawToCanvas(ACanvas: TCanvas; Mode: TPrintMode; FromRow, ToRow: Integer);
var
  PageWidth, PageHeight, PageRow,PageCol,I, iRow, FromCol,ToCol, X,Y: Integer;
  DoPaint,haslogo: Boolean;
  Hheader,Hfooter:integer;
  logopic,logopics:TBitmap;

  function ScaleX(I:Integer): Integer;
  begin
    if Mode = pmPreview then
      Result := I
    else
      Result :=round( I * (GetDeviceCaps(Printer.Handle, LOGPIXELSX) / Screen.PixelsPerInch));
  end;
  function ScaleY(I:Integer): Integer;
  begin
    if Mode = pmPreview then
      Result := I
    else
      Result := round(I * (GetDeviceCaps(Printer.Handle, LOGPIXELSY) / Screen.PixelsPerInch));
  end;

  procedure DrawCells(iRow:Integer);
  var
    iCol,I: Integer;
    R: TRect;
    drs:string;
    nr:boolean;
    v:extended;
  begin
//Alignment must be done another day
    for iCol := FromCol to ToCol do
    begin
     if ColWidths[iCol]<>0 then begin
      //X Offset
      X := scaleX(printoptions.marginleft);
      for I := FromCol to iCol-1 do
        Inc(X, ScaleX(ColWidths[I]+1));
      //Text Rect
      R := Rect(X,Y, X+ScaleX(ColWidths[iCol]), Y+ScaleY(RowHeights[iRow]));
      //Draw on the Canvas
      if DoPaint then begin
        if PrintOptions.BorderStyle =bssingle then begin
          Acanvas.brush.Style :=bsclear;
          Acanvas.Rectangle (r.left,r.top,r.right+ScaleX(2),r.bottom+scaleY(1));
          end;
        drs:=Cells[iCol, iRow];
        nr:=false;
        if FShowValues then
         if drs<>'' then
          if drs[1]='=' then begin
           drs:=format(FNumberFormat,[FCellValues[icol,irow]]);
           if NumbersalRight then nr:=true;
           end;
        if ((irow=0)and(icol>0)) then
         Acanvas.font.style:=Acanvas.Font.style+[fsbold]
         else
         Acanvas.font.style:=Acanvas.Font.style-[fsbold];
        R.left:=R.left+scaleX(PrintOptions.Leftpadding);
        if (FWordWrap and (iCol<>0) and (iRow<>0)) then begin
        if (NumbersalRight and (not nr))then
          try
            v:=strtofloat(drs);
            nr:=true;
            drs:=format(FNumberFormat,[v]);
            except
            // do nothing
            end;
         if nr then
          DrawText(Acanvas.handle,pchar(drs),-1,R,DT_WORDBREAK or DT_RIGHT)
          else
          DrawText(Acanvas.handle,pchar(drs),-1,R,DT_WORDBREAK or DT_LEFT)
         end
         else begin
          if (NumbersalRight and (not nr)) then
          try
            v:=strtofloat(drs);
            nr:=true;
            drs:=format(FNumberFormat,[v]);
            except
            // do nothing
            end;
          if nr then
            DrawText(Acanvas.handle,pchar(drs),-1,R,DT_SINGLELINE or DT_RIGHT)
            else
            DrawText(Acanvas.handle,pchar(drs),-1,R,DT_SINGLELINE or DT_LEFT)
          end;
        end;
     end;
    end;
  Inc(Y, ScaleY(RowHeights[iRow]));
  end;

  procedure DrawTitle; //draw Header and Footer
  var
    S,fstr: String;
    flist:tstringlist;
    fcnt,i:integer;
    tmpfont:tfont;//I have no idea why you can't use gettextwidth when acanvas = printer.canvas, it returns wrong value
  begin
    if DoPaint then
      begin
      ACanvas.Font.Size := FprintOptions.HeaderSize ;
      tmpfont:=font;
      canvas.font := acanvas.font;
      end;
    //Title
    Y := ScaleY(PrintOptions.MarginTop);
    S := PrintOptions.PageTitle;
    HHeader:=canvas.textheight(s);
    if haslogo then if logopic.Height >HHeader then HHeader:=logopic.height;
    if DoPaint then begin
      if haslogo then begin
       Acanvas.Draw(scaleX(printoptions.marginleft),Y,logopics);
       end;
      ACanvas.TextOut( (PageWidth div 2) - (ScaleX(Canvas.TextWidth(S) div 2)), Y, S);
      end;
    Y:=Y+ScaleY(HHeader);
    //Page nr
    S := 'Page '+IntToStr(PageRow);
    if (ToCol < ColCount-1) or (PageCol > 1) then
      S := S+'-'+IntToStr(PageCol);
    fstr:=Printoptions.PageFooter ;
    HFooter:=canvas.textheight(fstr);
    if fstr<>'' then
     if DoPaint then begin
      ACanvas.Font.Size := FprintOptions.FooterSize ;
      canvas.font := acanvas.font;
      HFooter:=canvas.textheight(fstr);
      flist:=tstringlist.create;
      flist.text:=stringreplace(fstr,'|',cr,[rfreplaceall]);
      while flist.count<3 do
       flist.Append ('');
      for i:=0 to 2 do begin
       flist[i]:=stringreplace(flist[i],'date',formatdatetime(PrintOptions.Dateformat,now),[]);
       flist[i]:=stringreplace(flist[i],'time',formatdatetime(PrintOptions.Timeformat,now),[]);
       flist[i]:=stringreplace(flist[i],'page',s,[]);
       end;
      //paint left footer
      if flist[0]<>'' then
       ACanvas.TextOut( scaleX(Printoptions.marginleft+Canvas.TextWidth(flist[0])), PageHeight-ScaleY(PrintOptions.marginbottom+canvas.TextHeight(flist[0])), flist[0]);
      //paint center footer
      if flist[1]<>'' then
       ACanvas.TextOut( (PageWidth div 2)-(scaleX(Canvas.TextWidth(flist[1]))div 2), PageHeight-ScaleY(PrintOptions.marginbottom+canvas.TextHeight(flist[1])), flist[1]);
      //paint right footer
      if flist[2]<>'' then
       ACanvas.TextOut( PageWidth-scaleX(Printoptions.marginright+Canvas.TextWidth(flist[2])+10), PageHeight-ScaleY(PrintOptions.marginbottom+canvas.TextHeight(flist[2])), flist[2]);
      flist.free;
      end;

    if DoPaint then
     begin
      ACanvas.Font.Size := Font.Size;
      canvas.font := tmpfont;//Delphi 4.0 warning is wrong
      end;
    Y := Y+ScaleY(PrintOptions.PageTitleMargin);
    DrawCells(0);
  end;

begin
  //page size
  Printer.Orientation :=PrintOptions.Orientation ;
  PageWidth := Printer.PageWidth;
  PageHeight := Printer.PageHeight;
  if Mode = pmPreview then
  begin
    PageWidth := PageWidth div ((GetDeviceCaps(Printer.Handle, LOGPIXELSX) div Screen.PixelsPerInch));
    PageHeight := PageHeight div ((GetDeviceCaps(Printer.Handle, LOGPIXELSY) div Screen.PixelsPerInch));
    FPrintImage.width:=pagewidth;
    FPrintImage.height:=pageheight;
    ACanvas.Brush.Color := ClWhite;
    ACanvas.FillRect( Rect(0,0,PageWidth,PageHeight));
  end;
    haslogo:=false;
    if printoptions.Logo <>'' then
     if fileexists(printoptions.logo) then begin
      logopic:=tbitmap.create;
      logopic.LoadFromFile (printoptions.logo);
      haslogo:=true;
      logopics:=tbitmap.create;
      logopics.width:=scaleX(logopic.width);
      logopics.height:=scaleY(logopic.height);
      logopic.PixelFormat :=pf24bit;
      logopics.pixelformat:=pf24bit;
      smoothresize(logopic,logopics);
      end;

  if Mode <> pmPageCount then
  begin
    ACanvas.Font := Font;
    ACanvas.Font.Color := clBlack;
  end;
  PageCol := 0;
  FromCol := -1;
  ToCol := -0;
  //scan cols
  repeat
    //Scan missing cols
    if FromCol = ToCol then
      Inc(FromCol)
    else
      FromCol := ToCol+1;
    Inc(ToCol);
    //Get Cols with width that fits page
    X := PrintOptions.MarginLeft ;
    for I := FromCol to ColCount-1 do
    begin
      Inc(X, ScaleX(ColWidths[I]+1));
      if X <= (PageWidth-PrintOptions.MarginRight) then
        ToCol := I;
    end;
    PageRow := 1;
    Inc(PageCol);
    //Mode = PageCount
    Inc(fPageCount);
    //preview mode
    DoPaint := (((Mode = pmPreview) and (fPageCount = PrintOptions.PreviewPage)) or (Mode = pmPrint));
    //Header & Footer
    DrawTitle;
    //Contents
    iRow := FromRow;
    repeat
//      Inc(Y, ScaleY(RowHeights[iRow]));
      if (Y+ScaleY(RowHeights[iRow])) <= (PageHeight-ScaleY(Printoptions.marginbottom+20+HFooter)) then
      begin //draw contents to canvas
        if RowHeights[iRow]<>0 then
         DrawCells(iRow);
        Inc(iRow);
      end
      else//New page
      begin
        if (DoPaint = True) and (Mode = pmPreview) then
          Exit;
        if Mode = pmPrint then
          Printer.NewPage;
        Inc(fPageCount);//pagecount
        DoPaint := (((Mode = pmPreview) and (fPageCount = PrintOptions.PreviewPage)) or (Mode = pmPrint));
        Inc(PageRow);
        DrawTitle;
      end;
      if (iRow = ToRow+1) and (ToCol < ColCount-1) and (Y <= PageHeight-ScaleY(20)) then
      begin
        if (DoPaint = True) and (Mode = pmPreview) then
          Exit;
        if Mode = pmPrint then
          Printer.NewPage;
        DrawTitle;
      end;
    until
      iRow = ToRow+1;
  until
    ToCol = ColCount-1;
  if haslogo then begin
   logopic.free;
   logopics.free;
   end;
end;



procedure TjanGrid.ParserGetVar(Sender: TObject; VarName: String;
  var Value: Extended; var Found: Boolean);
var
   c,r:integer;
 function CellNameToPoint(aname:string; var ac,ar:integer):boolean;
 var cni:integer;
 begin
   result:=false;
   if FCellNames.Count =0 then exit;
   cni:=FCellNames.IndexOfName (aname);
   if cni=-1 then exit;
   if strtoRC(FCellNames.values[aname],ac,ar) then
     result:=true;
 end;

 function VarToPoint(aname:string; var ac,ar:integer):boolean;
 var s,pcs,prs:string;
     pc,pr:integer;
 begin
  s:=lowercase(aname);
  pc:=pos('c',s);
  pr:=pos('r',s);
  if ((pc=0)or(pr=0)) then
    result:=false
    else begin
     if pc>pr then begin
      pcs:=copy(s,pc+1,length(s));
      prs:=copy(s,pr+1,pc-pr-1);
      end
      else begin
      prs:=copy(s,pr+1,length(s));
      pcs:=copy(s,pc+1,pr-pc-1);
      end;
     try
      ac:=strtoint(pcs);
      ar:=strtoint(prs);
      result:=true;
      except
      result:=false;
      end;
     end;
 end;

 function sumrow:extended;
 var c,r:integer;
 begin
  result:=0;
  if parsecol>1 then
   for c:=1 to parsecol-1 do
    result:=result+FCellValues[c,parserow];
 end;

 function avgrow:extended;
 var c,r:integer;
 begin
  result:=0;
  if parsecol>1 then begin
   for c:=1 to parsecol-1 do
    result:=result+FCellValues[c,parserow];
   result:=result / (parsecol-1);
   end;
 end;

 function minrow:extended;
 var c,r:integer;
 begin
  result:=FCellValues[1,parserow];
  if parsecol>1 then begin
   for c:=1 to parsecol-1 do
    if FCellValues[c,parserow]<result then
     result:=FCellValues[c,parserow];
   end;
 end;

 function maxrow:extended;
 var c,r:integer;
 begin
  result:=0;
  if parsecol>1 then begin
   for c:=1 to parsecol-1 do
    if FCellValues[c,parserow]>result then
     result:=FCellValues[c,parserow];
   end;
 end;


 function sumcol:extended;
 var c,r:integer;
 begin
  result:=0;
  if parserow>1 then
   for r:=1 to parserow-1 do
    result:=result+FCellValues[parsecol,r];
 end;

 function avgcol:extended;
 var c,r:integer;
 begin
  result:=0;
  if parserow>1 then begin
   for r:=1 to parserow-1 do
    result:=result+FCellValues[parsecol,r];
   result:=result / (parserow-1);
   end;
 end;

 function mincol:extended;
 var c,r:integer;
 begin
  result:=FCellValues[parsecol,1];
  if parserow>1 then begin
   for r:=1 to parserow-1 do
    if FCellValues[parsecol,r]<result then
     result:=FCellValues[parsecol,r];
   end;
 end;

 function maxcol:extended;
 var c,r:integer;
 begin
  result:=0;
  if parserow>1 then begin
   for r:=1 to parserow-1 do
    if FCellValues[parsecol,r]>result then
     result:=FCellValues[parsecol,r];
   end;
 end;


begin
 found:=true;
 if CellNameToPoint(VarName,c,r) then
  value:=FCellValues[c,r]
 else if strtoRC(uppercase(VarName),c,r) then
  value:=FCellValues[c,r]
 else if VarToPoint(VarName,c,r) then
  value:=FCellValues[c,r]
 else if lowercase(VarName)='pi' then
 // check for special functions and constants
   value:=pi
  else if lowercase(VarName)='sumrow' then
   value:=sumrow
  else if lowercase(VarName)='sumcol' then
   value:=sumcol
  else if lowercase(VarName)='avgrow' then
   value:=avgrow
  else if lowercase(VarName)='avgcol' then
   value:=avgcol
  else if lowercase(VarName)='minrow' then
   value:=minrow
  else if lowercase(VarName)='maxrow' then
   value:=maxrow
  else if lowercase(VarName)='mincol' then
   value:=mincol
  else if lowercase(VarName)='maxcol' then
   value:=maxcol
  else
  found:=false;
end;

procedure TjanGrid.ParserParseError(Sender: TObject;
  ParseError: Integer);
begin
 FParseError:=true;
end;

procedure TjanGrid.Recalculate;
var r1,r2,c1,c2,r,c:integer;
    s:string;
begin
 r1:=fixedrows;
 r2:=rowcount-1;
 c1:=fixedcols;
 c2:=colcount-1;
 if ((r1>r2)or(c1>c2)) then exit;
 SetCellValues;
 for r:=r1 to r2 do
  for c:=c1 to c2 do begin
   parsecol:=c;
   parserow:=r;
   s:=cells[c,r];
   if (s<>'') and (s[1]='=') then begin
    s:=copy(s,2,length(s));
    FParser.ParseString :=s;
    FparseError:=false;
    Fparser.Parse ;
    if not FParseError then
     FCellValues[c,r]:=Fparser.ParseValue
     else begin
      showmessage('Error in: '+s);
      row:=r;
      col:=c;
      exit;
      end;
    end;
   end;
 if FshowValues then invalidate;
end;

procedure TjanGrid.SetCellValues;
var c,r:integer;
begin
 setlength(FCellValues,colcount,rowcount);
 for r:=0 to rowcount-1 do
  for c:=0 to colcount-1 do begin
    try
     FCellValues[c,r]:=strtofloat(Cells[c,r]);
     except
     FCellValues[c,r]:=0;
     end;
    end;
end;


procedure TjanGrid.SetShowValues(const Value: boolean);
begin
  if value<>FShowValues then begin
   FShowValues := Value;
   if value then Recalculate
    else invalidate;
   end;
end;

procedure TjanGrid.DrawCell(ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState);
var s:string;
    v:extended;
    nr:boolean;
begin
 nr:=false;
 s:=cells[acol,arow];
 canvas.font.style:=canvas.Font.style-[fsbold];
 canvas.font.style:=canvas.Font.style-[fsunderline];

 if (Row= ARow) and (ACol>0) then
        canvas.font.color:=clWhite
 else
        canvas.font.color:=clblack;

 rect.Left:=rect.Left+ 3;
 rect.top:=rect.top+ 3;


 if Bandsshow and (acol<>0) and (arow<>0) and ((arow mod BandsInterval)=0) then begin
  canvas.brush.color:=BandsColor;
  canvas.FillRect (rect);
  end;
 if FShowValues then
  if ((s<>'') and (s[1]='=')) then begin
   canvas.font.color:=clred;
   s:=format(FNumberFormat,[FCellValues[acol,arow]]);
   if NumbersalRight then nr:=true;
   end;
 if FHighlightURL then
  if s<>'' then
  if ((pos('mailto:',lowercase(s))=1) or (pos('http:',lowercase(s))=1)) then begin
   canvas.font.color:=clblue;
   canvas.font.style:=canvas.Font.style+[fsunderline];
   end;
 if (FWordWrap and(acol<>0)and (arow<>0))then begin
 canvas.FillRect (rect);
 if (NumbersalRight and(not nr))then
  try
   v:=strtofloat(s);
   nr:=true;
   s:=format(FNumberFormat,[v]);
   except
   // do nothing
   end;
 if nr then
 DrawText(canvas.handle,pchar(s),-1,rect,DT_wordbreak or DT_RIGHT)
 else
 DrawText(canvas.handle,pchar(s),-1,rect,DT_wordbreak);
 end
 else if ((acol<>0)and(arow<>0)) then begin
 if (NumbersalRight and (not nr)) then
  try
   v:=strtofloat(s);
   nr:=true;
   s:=format(FNumberFormat,[v]);
   except
   // do nothing
   end;
  if nr then
  DrawText(canvas.handle,pchar(s),-1,rect,DT_SINGLELINE or DT_RIGHT)
  else
  canvas.TextRect(rect,rect.left,rect.top,s);
  end;
 if ((arow=0)and(acol>0)) then begin
  canvas.font.style:=canvas.Font.style+[fsbold];
  canvas.TextRect(rect,rect.left,rect.top,s);
  canvas.font.style:=canvas.Font.style-[fsbold];
  if FA1Style then
    s:=Ctostr(acol)
  else
    s:=inttostr(acol);
  rect.right:=rect.Right -2;
//  DrawText(canvas.handle,pchar(s),-1,rect,DT_SINGLELINE OR DT_BOTTOM OR DT_RIGHT);
  end;
 if acol=0 then begin
   s:=inttostr(arow);
  rect.right:=rect.Right -2;
  DrawText(canvas.handle,pchar(s),-1,rect,DT_SINGLELINE OR DT_BOTTOM OR DT_RIGHT);
  end;
  if assigned(ondrawcell) then
   onDrawCell(self, ACol, ARow, Rect, State);
end;

procedure TjanGrid.AutoSizeRowsEx;
var i:integer;
begin
 for i:=1 to rowcount-1 do
  if rowheights[i]<>0 then autosizerow(i);
end;

procedure TjanGrid.KeyPress(var Key: Char);
begin
 if key=char(vk_return) then begin
   if FAutoCalculate then recalculate;
   autosizerowsEx;
   case FAdvanceDirection of
    right:
     if col<(colcount-1) then col:=col+1
      else if row<(rowcount-1) then begin
       col:=1;
       row:=row+1;
       end;
    down:
     if row<(rowcount-1) then row:=row+1
      else if col<(colcount-1) then begin
       row:=1;
       col:=col+1;
       end;
     end;
   end;
  if assigned(onkeypress) then
   onkeypress(self,key);
end;

procedure TjanGrid.SetAutoCalculate(const Value: boolean);
begin
  if value<>FAutoCalculate then begin
   FAutoCalculate := Value;
   if value then recalculate;
   end;
end;

procedure TjanGrid.SetNumberFormat(const Value: string);
begin
  if value<>FNumberFormat then begin
   FNumberFormat := Value;
   recalculate;
   end;
end;



const
  Letters : set of Char = ['A'..'Z', 'a'..'z'];
  Numbers : set of Char = ['0'..'9'];

constructor TjanMathParser.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  { defaults }
  FInput := '';
end;

function TjanMathParser.GotoState(Production : Word) : Word;
{ Finds the new state based on the just-completed production and the
   top state. }
var
  State : Word;
begin
  State := Stack[StackTop].State;
  if (Production <= 3) then
  begin
    case State of
      0 : GotoState := 1;
      9 : GotoState := 19;
      20 : GotoState := 28;
    end; { case }
  end
  else if Production <= 6 then
  begin
    case State of
      0, 9, 20 : GotoState := 2;
      12 : GotoState := 21;
      13 : GotoState := 22;
    end; { case }
  end
  else if (Production <= 8) or (Production = 100) then
  begin
    case State of
      0, 9, 12, 13, 20 : GotoState := 3;
      14 : GotoState := 23;
      15 : GotoState := 24;
      16 : GotoState := 25;
      40 : GotoState := 80;
    end; { case }
  end
  else if Production <= 10 then
  begin
    case State of
      0, 9, 12..16, 20, 40 : GotoState := 4;
    end; { case }
  end
  else if Production <= 12 then
  begin
    case State of
      0, 9, 12..16, 20, 40 : GotoState := 6;
      5 : GotoState := 17;
    end; { case }
  end
  else begin
    case State of
      0, 5, 9, 12..16, 20, 40 : GotoState := 8;
    end; { case }
  end;
end; { GotoState }

function TjanMathParser.IsFunc(S : String) : Boolean;
{ Checks to see if the parser is about to read a function }
var
  P, SLen : Word;
  FuncName : string;
begin
  P := Position;
  FuncName := '';
  while (P <= Length(FInput)) and (FInput[P] in ['A'..'Z', 'a'..'z', '0'..'9',
    '_']) do
  begin
    FuncName := FuncName + FInput[P];
    Inc(P);
  end; { while }
  if Uppercase(FuncName) = S
    then begin
           SLen := Length(S);
           CurrToken.FuncName := UpperCase(Copy(FInput, Position, SLen));
           Inc(Position, SLen);
           IsFunc := True;
         end { if }
    else IsFunc := False;
end; { IsFunc }

function TjanMathParser.IsVar(var Value : Extended) : Boolean;
var
  VarName : string;
  VarFound : Boolean;
begin
  VarFound := False;
  VarName := '';
  while (Position <= Length(FInput)) and (FInput[Position] in ['A'..'Z',
    'a'..'z', '0'..'9', '_']) do
  begin
    VarName := VarName + FInput[Position];
    Inc(Position);
  end; { while }
  if Assigned(FOnGetVar)
    then FOnGetVar(Self, VarName, Value, VarFound);
  IsVar := VarFound;
end; { IsVar }

function TjanMathParser.NextToken : TokenTypes;
{ Gets the next Token from the Input stream }
var
  NumString : String[80];
  FormLen, Place, TLen, NumLen : Word;
  Check : Integer;
  Ch, FirstChar : Char;
  Decimal : Boolean;
begin
   while (Position <= Length(FInput)) and (FInput[Position] = ' ') do
     Inc(Position);
   TokenLen := Position;
   if Position > Length(FInput) then
   begin
     NextToken := EOL;
     TokenLen := 0;
     Exit;
   end; { if }
   Ch := UpCase(FInput[Position]);
   if Ch in ['!'] then
   begin
      NextToken := ERR;
      TokenLen := 0;
      Exit;
   end; { if }
   if Ch in ['0'..'9', '.'] then
   begin
     NumString := '';
     TLen := Position;
     Decimal := False;
     while (TLen <= Length(FInput)) and
           ((FInput[TLen] in ['0'..'9']) or
            ((FInput[TLen] = '.') and (not Decimal))) do
     begin
       NumString := NumString + FInput[TLen];
       if Ch = '.' then
         Decimal := True;
       Inc(TLen);
     end; { while }
     if (TLen = 2) and (Ch = '.') then
     begin
       NextToken := BAD;
       TokenLen := 0;
       Exit;
     end; { if }
     if (TLen <= Length(FInput)) and (UpCase(FInput[TLen]) = 'E') then
     begin
       NumString := NumString + 'E';
       Inc(TLen);
       if FInput[TLen] in ['+', '-'] then
       begin
         NumString := NumString + FInput[TLen];
         Inc(TLen);
       end; { if }
       NumLen := 1;
       while (TLen <= Length(FInput)) and (FInput[TLen] in ['0'..'9']) and
             (NumLen <= MaxExpLen) do
       begin
         NumString := NumString + FInput[TLen];
         Inc(NumLen);
         Inc(TLen);
       end; { while }
     end; { if }
     if NumString[1] = '.' then
       NumString := '0' + NumString;
     Val(NumString, CurrToken.Value, Check);
     if Check <> 0 then
       begin
         MathError := True;
         TokenError := ErrInvalidNum;
         Inc(Position, Pred(Check));
       end { if }
     else
       begin
         NextToken := NUM;
         Inc(Position, System.Length(NumString));
         TokenLen := Position - TokenLen;
       end; { else }
     Exit;
   end { if }
   else if Ch in Letters then
   begin
     if IsFunc('ABS') or
        IsFunc('ATAN') or
        IsFunc('COS') or
        IsFunc('EXP') or
        IsFunc('LN') or
        IsFunc('ROUND') or
        IsFunc('SIN') or
        IsFunc('SQRT') or
        IsFunc('SQR') or
        IsFunc('TRUNC') then
     begin
       NextToken := FUNC;
       TokenLen := Position - TokenLen;
       Exit;
     end; { if }
     if IsFunc('MOD') then
     begin
       NextToken := MODU;
       TokenLen := Position - TokenLen;
       Exit;
     end; { if }
     if IsVar(CurrToken.Value)
       then begin
              NextToken := NUM;
              TokenLen := Position - TokenLen;
              Exit;
            end { if }
       else begin
              NextToken := BAD;
              TokenLen := 0;
              Exit;
            end; { else }
   end { if }
   else begin
     case Ch of
       '+' : NextToken := PLUS;
       '-' : NextToken := MINUS;
       '*' : NextToken := TIMES;
       '/' : NextToken := DIVIDE;
       '^' : NextToken := EXPO;
       '(' : NextToken := OPAREN;
       ')' : NextToken := CPAREN;
       else begin
         NextToken := BAD;
         TokenLen := 0;
         Exit;
       end; { case else }
     end; { case }
     Inc(Position);
     TokenLen := Position - TokenLen;
     Exit;
   end; { else if }
end; { NextToken }

procedure TjanMathParser.Pop(var Token : TokenRec);
{ Pops the top Token off of the stack }
begin
  Token := Stack[StackTop];
  Dec(StackTop);
end; { Pop }

procedure TjanMathParser.Push(Token : TokenRec);
{ Pushes a new Token onto the stack }
begin
  if StackTop = ParserStackSize then
    TokenError := ErrParserStack
  else begin
    Inc(StackTop);
    Stack[StackTop] := Token;
  end; { else }
end; { Push }

procedure TjanMathParser.Parse;
{ Parses an input stream }
var
  FirstToken : TokenRec;
  Accepted : Boolean;
begin
  Position := 1;
  StackTop := 0;
  TokenError := 0;
  MathError := False;
  ParseError := False;
  Accepted := False;
  FirstToken.State := 0;
  FirstToken.Value := 0;
  Push(FirstToken);
  TokenType := NextToken;
  repeat
    case Stack[StackTop].State of
      0, 9, 12..16, 20, 40 : begin
        if TokenType = NUM then
          Shift(10)
        else if TokenType = FUNC then
          Shift(11)
        else if TokenType = MINUS then
          Shift(5)
        else if TokenType = OPAREN then
          Shift(9)
        else if TokenType = ERR then
          begin
             MathError := True;
             Accepted := True;
          end { else if }
        else begin
          TokenError := ErrExpression;
          Dec(Position, TokenLen);
        end; { else }
      end; { case of }
      1 : begin
        if TokenType = EOL then
          Accepted := True
        else if TokenType = PLUS then
          Shift(12)
        else if TokenType = MINUS then
          Shift(13)
        else begin
          TokenError := ErrOperator;
          Dec(Position, TokenLen);
        end; { else }
      end; { case of }
      2 : begin
        if TokenType = TIMES then
          Shift(14)
        else if TokenType = DIVIDE then
          Shift(15)
        else
          Reduce(3);
      end; { case of }
      3 : begin
       if TokenType = MODU then
         Shift(40)
       else
         Reduce(6);
      end; { case of }
      4 : begin
       if TokenType = EXPO then
         Shift(16)
       else
         Reduce(8);
      end; { case of }
      5 : begin
        if TokenType = NUM then
          Shift(10)
        else if TokenType = FUNC then
          Shift(11)
        else if TokenType = OPAREN then
          Shift(9)
        else
          begin
            TokenError := ErrExpression;
            Dec(Position, TokenLen);
          end; { else }
      end; { case of }
      6 : Reduce(10);
      7 : Reduce(13);
      8 : Reduce(12);
      10 : Reduce(15);
      11 : begin
        if TokenType = OPAREN then
          Shift(20)
        else
          begin
            TokenError := ErrOpenParen;
            Dec(Position, TokenLen);
          end; { else }
      end; { case of }
      17 : Reduce(9);
      18 : raise Exception.Create('Bad token state');
      19 : begin
        if TokenType = PLUS then
          Shift(12)
        else if TokenType = MINUS then
          Shift(13)
        else if TokenType = CPAREN then
          Shift(27)
        else
          begin
            TokenError := ErrOpCloseParen;
            Dec(Position, TokenLen);
          end;
      end; { case of }
      21 : begin
        if TokenType = TIMES then
          Shift(14)
        else if TokenType = DIVIDE then
          Shift(15)
        else
          Reduce(1);
      end; { case of }
      22 : begin
        if TokenType = TIMES then
          Shift(14)
        else if TokenType = DIVIDE then
          Shift(15)
        else
          Reduce(2);
      end; { case of }
      23 : Reduce(4);
      24 : Reduce(5);
      25 : Reduce(7);
      26 : Reduce(11);
      27 : Reduce(14);
      28 : begin
        if TokenType = PLUS then
          Shift(12)
        else if TokenType = MINUS then
          Shift(13)
        else if TokenType = CPAREN then
          Shift(29)
        else
          begin
            TokenError := ErrOpCloseParen;
            Dec(Position, TokenLen);
          end; { else }
      end; { case of }
      29 : Reduce(16);
      80 : Reduce(100);
    end; { case }
  until Accepted or (TokenError <> 0);
  if TokenError <> 0 then
  begin
      if TokenError = ErrBadRange then
        Dec(Position, TokenLen);
      if Assigned(FOnParseError)
        then FOnParseError(Self, TokenError);
  end; { if }
  if MathError or (TokenError <> 0) then
  begin
    ParseError := True;
    ParseValue := 0;
    Exit;
  end; { if }
  ParseError := False;
  ParseValue := Stack[StackTop].Value;
end; { Parse }

procedure TjanMathParser.Reduce(Reduction : Word);
{ Completes a reduction }
var
  Token1, Token2 : TokenRec;
begin
  case Reduction of
    1 : begin
      Pop(Token1);
      Pop(Token2);
      Pop(Token2);
      CurrToken.Value := Token1.Value + Token2.Value;
    end;
    2 : begin
      Pop(Token1);
      Pop(Token2);
      Pop(Token2);
      CurrToken.Value := Token2.Value - Token1.Value;
    end;
    4 : begin
      Pop(Token1);
      Pop(Token2);
      Pop(Token2);
      CurrToken.Value := Token1.Value * Token2.Value;
    end;
    5 : begin
      Pop(Token1);
      Pop(Token2);
      Pop(Token2);
      if Token1.Value = 0 then
        MathError := True
      else
        CurrToken.Value := Token2.Value / Token1.Value;
    end;

    { MOD operator }
    100 : begin
      Pop(Token1);
      Pop(Token2);
      Pop(Token2);
      if Token1.Value = 0 then
        MathError := True
      else
        CurrToken.Value := Round(Token2.Value) mod Round(Token1.Value);
    end;

    7 : begin
      Pop(Token1);
      Pop(Token2);
      Pop(Token2);
      if Token2.Value <= 0 then
        MathError := True
      else if (Token1.Value * Ln(Token2.Value) < -ExpLimit) or
              (Token1.Value * Ln(Token2.Value) > ExpLimit) then
        MathError := True
      else
        CurrToken.Value := Exp(Token1.Value * Ln(Token2.Value));
    end;
    9 : begin
      Pop(Token1);
      Pop(Token2);
      CurrToken.Value := -Token1.Value;
    end;
    11 : raise Exception.Create('Invalid reduction');
    13 : raise Exception.Create('Invalid reduction');
    14 : begin
      Pop(Token1);
      Pop(CurrToken);
      Pop(Token1);
    end;
    16 : begin
      Pop(Token1);
      Pop(CurrToken);
      Pop(Token1);
      Pop(Token1);
      if Token1.FuncName = 'ABS' then
        CurrToken.Value := Abs(CurrToken.Value)
      else if Token1.FuncName = 'ATAN' then
        CurrToken.Value := ArcTan(CurrToken.Value)
      else if Token1.FuncName = 'COS' then
      begin
         if (CurrToken.Value < -9E18) or (CurrToken.Value > 9E18) then
            MathError := True
         else
            CurrToken.Value := Cos(CurrToken.Value)
      end {...if Token1.FuncName = 'SIN' }
      else if Token1.FuncName = 'EXP' then
      begin
        if (CurrToken.Value < -ExpLimit) or (CurrToken.Value > ExpLimit) then
          MathError := True
        else
          CurrToken.Value := Exp(CurrToken.Value);
      end
      else if Token1.FuncName = 'LN' then
      begin
        if CurrToken.Value <= 0 then
          MathError := True
        else
          CurrToken.Value := Ln(CurrToken.Value);
      end
      else if Token1.FuncName = 'ROUND' then
      begin
        if (CurrToken.Value < -1E9) or (CurrToken.Value > 1E9) then
          MathError := True
        else
          CurrToken.Value := Round(CurrToken.Value);
      end
      else if Token1.FuncName = 'SIN' then
      begin
         if (CurrToken.Value < -9E18) or (CurrToken.Value > 9E18) then
            MathError := True
         else
            CurrToken.Value := Sin(CurrToken.Value)
      end {...if Token1.FuncName = 'SIN' }
      else if Token1.FuncName = 'SQRT' then
      begin
        if CurrToken.Value < 0 then
          MathError := True
        else
          CurrToken.Value := Sqrt(CurrToken.Value);
      end
      else if Token1.FuncName = 'SQR' then
      begin
        if (CurrToken.Value < -SQRLIMIT) or (CurrToken.Value > SQRLIMIT) then
          MathError := True
        else
          CurrToken.Value := Sqr(CurrToken.Value);
      end
      else if Token1.FuncName = 'TRUNC' then
      begin
        if (CurrToken.Value < -1E9) or (CurrToken.Value > 1E9) then
          MathError := True
        else
          CurrToken.Value := Trunc(CurrToken.Value);
      end;
    end;
    3, 6, 8, 10, 12, 15 : Pop(CurrToken);
  end; { case }
  CurrToken.State := GotoState(Reduction);
  Push(CurrToken);
end; { Reduce }

procedure TjanMathParser.Shift(State : Word);
{ Shifts a Token onto the stack }
begin
  CurrToken.State := State;
  Push(CurrToken);
  TokenType := NextToken;
end; { Shift }


{ TjanGridPreview }


procedure TjanGrid.SetWordWrap(const Value: boolean);
begin
  if value<>FWordWrap then begin
   FWordWrap := Value;
   invalidate;
   end;
end;

procedure TjanGrid.AutoSizeRowsInt;
var r:integer;
begin
 for r:=1 to rowcount-1 do
  AutoSizeRow(r);
end;


procedure TjanGrid.AutoSizeRows;
begin
 AutoSizeRowsInt;
end;

procedure TjanGrid.AutoSizeRow(ARow: integer);
var c,maxh,h:integer;
    R:trect;
    s:string;
begin
 maxh:=defaultrowheight;
 for c:=0 to colcount-1 do begin
  s:=cells[c,Arow];
  if FShowvalues then
   if s<>'' then
    if s[1]='=' then
     s:=floattostr(FCellValues[c,arow]);
  R:=CellRect (c,Arow);
  drawtext(canvas.handle,pchar(s),-1,R,DT_CALCRECT or DT_WORDBREAK);
  h:=R.bottom-R.top+1;
  if h>maxh then maxh:=h;
  end;
 RowHeights [Arow]:=maxh;
end;

procedure TjanGrid.SaveToXML(Afile: string);
var alist:tstringlist;
    c,r:integer;
    ld,rd,ss:string;
begin
 alist:=tstringlist.create;
 rd:=changefileext(extractfilename(afile),'');
 ld:=rd+'s';
 alist.append('<?xml version="1.0"?>');
 alist.append('<'+ld+'>');
 for r:=1 to rowcount-1 do begin
   alist.Append ('<'+rd+'>');
  for c:=1 to colcount-1 do begin
   ss:=cells[c,r];
   if FshowValues then
    if ss<>'' then
     if ss[1]='=' then
      ss:=floattostr(FCellValues[c,r]);
   alist.append('<'+cells[c,0]+'>'+ss+'</'+cells[c,0]+'>');
   end;
   alist.Append ('</'+rd+'>');
  end;
 alist.append('</'+ld+'>');
 alist.SaveToFile (afile);
 alist.free;
end;

procedure TjanGrid.SaveToHTML(Afile: string);
var alist:tstringlist;
    c,r:integer;
    ld,rd,ss:string;
begin
 alist:=tstringlist.create;
 rd:=changefileext(extractfilename(afile),'');
 ld:=rd+'s';
 alist.append('<html><head><title>'+rd+'</title><head>');
 alist.append('<body>');
 alist.append('<table border=1 width=100%>');
 for r:=1 to rowcount-1 do begin
   alist.Append ('<tr>');
  for c:=1 to colcount-1 do begin
   ss:=cells[c,r];
   if FshowValues then
    if ss<>'' then
     if ss[1]='=' then
      ss:=floattostr(FCellValues[c,r]);
   if ss='' then ss:=' ';
   alist.append('<td>'+ss+'</td>');
   end;
   alist.Append ('</tr>');
  end;
 alist.append('</table>');
 alist.append('</body></html>');
 alist.SaveToFile (afile);
 alist.free;
end;

procedure TjanGrid.SetAdvanceDirection(
  const Value: TAdvanceDirection);
begin
  FAdvanceDirection := Value;
end;

procedure TjanGrid.SetHighlightURL(const Value: boolean);
begin
  if value<>FHighlightURL then begin
   FHighlightURL := Value;
   invalidate;
   end;
end;


procedure TjanGrid.SizeChanged(OldColCount, OldRowCount: Integer);
var i:integer;
begin
 setlength(FOldcolwidths,colcount);
 for i:=0 to colcount-1 do
  if colwidths[i]<>0 then FOldColWidths[i]:=colWidths[i];
 AutoSizeRows;
 if FUpdateValues then
  SetCellValues;
 if assigned(FonSizeChanged) then
  FonSizeChanged(self,OldColCount,OldRowCount);
end;

procedure TjanGrid.SetonSizeChanged(const Value: TonSizeChanged);
begin
  FonSizeChanged := Value;
end;

function TjanGrid.booltostr(Abool:boolean):string;
begin
 if abool then result:='true'
  else result:='false';
end;

function TjanGrid.strtobool(Astring:string):boolean;
begin
 if astring='true' then result:=true
  else result:=false;
end;

procedure TjanGrid.SaveToFormat(afile:string);
var flist:tstringlist;
    rlist:tstringlist;
    i:integer;
    s:string;
begin
 afile:=changefileext(afile,'.cvf');
 flist:=tstringlist.create;
 rlist:=tstringlist.create;
 rlist.clear;
 for i:=0 to colcount-1 do
  rlist.Append (inttostr(colwidths[i]));
 flist.Append (rlist.commatext);
 rlist.clear;
 for i:=0 to rowcount-1 do
  rlist.append(inttostr(rowheights[i]));
 flist.Append (rlist.commatext);
 rlist.clear;
 rlist.append(font.name);
 rlist.append(inttostr(font.size));
 flist.append(rlist.commatext);
 //bands
 rlist.clear;
 rlist.append(booltostr(BandsShow));
 rlist.append(colortostring(BandsColor));
 rlist.append(inttostr(BandsInterval));
 flist.append(rlist.commatext);
 // numbers
 rlist.Clear ;
 rlist.append(booltostr(NumbersalRight));
 rlist.Append(numberformat);
 rlist.Append(booltostr(showvalues));
 flist.append(rlist.commatext);
 // printoptions
 rlist.clear;
 with PrintOptions do begin
  if orientation=poPortrait then rlist.append('portrait') else rlist.append('landscape');
  rlist.append(JobTitle);
  rlist.append(PageTitle);
  rlist.append(inttostr(PageTitleMargin));
  rlist.append(PageFooter);
  rlist.append(inttostr(HeaderSize));
  rlist.append(inttostr(FooterSize));
  rlist.append(DateFormat);
  rlist.append(TimeFormat);
  if BorderStyle=bsnone then rlist.append('none') else rlist.append('single');
  rlist.append(inttostr(LeftPadding));
  rlist.append(inttostr(MarginBottom));
  rlist.append(inttostr(MarginLeft));
  rlist.append(inttostr(MarginRight));
  rlist.append(inttostr(MarginTop));
  if Logo='' then rlist.Append ('nil') else rlist.append(logo);
  end;
 flist.append(rlist.commatext);
 // FCellNames
 s:=FCellNames.Text ;
 s:=stringreplace(s,cr,'|',[rfreplaceall]);
 flist.Append (s);
 flist.SaveToFile (afile);
 rlist.free;
 flist.free;
end;

procedure TjanGrid.LoadFromFormat(afile:string);
var flist:tstringlist;
    rlist:tstringlist;
    i,v,c:integer;
    s:string;
begin
 afile:=changefileext(afile,'.cvf');
 if not fileexists(afile) then begin
  autosizecolumns;
  exit;
  end;
 flist:=tstringlist.create;
 rlist:=tstringlist.create;
 flist.LoadFromFile (afile);
 if flist.count<1 then exit;
 // column widths
 repeat
  rlist.commatext:=flist[0];
  if rlist.count<>colcount then break;
  for i:=0 to colcount-1 do
   colwidths[i]:=strtointdef(rlist[i],DefaultColWidth);
 until true;
 if flist.count<2 then exit;
 // row heigths
 repeat
  rlist.commatext:=flist[1];
  if rlist.count<>rowcount then break;
  for i:=0 to rowcount-1 do
   rowheights[i]:=strtointdef(rlist[i],DefaultRowHeight);
 until true;
 if flist.count<3 then exit;
  // grid font
 repeat
  rlist.commatext:=flist[2];
  if rlist.count<1 then break;
  try
   font.name:=rlist[0];
   except
   font.name:='Arial';
   end;
 if rlist.count<2 then break;
 v:=strtointdef(rlist[1],8);
 if (v<8) or (v>72) then v:=8;
 font.size:=v;
 until true;
 if flist.count<4 then exit;
  // bands
 repeat
  rlist.commatext:=flist[3];
  if rlist.count<1 then break;
  BandsShow:=strtobool(rlist[0]);
  if rlist.count<2 then break;
  BandsColor:=stringtocolor(rlist[1]);
  if rlist.count<3 then break;
  BandsInterval:=strtoint(rlist[2]);
 until true;
 if flist.count<5 then exit;
  // numbers
 repeat
  rlist.commatext:=flist[4];
  if rlist.count<1 then break;
  NumbersalRight:=strtobool(rlist[0]);
  if rlist.count<2 then break;
  Numberformat:=rlist[1];
  if rlist.count<3 then break;
  ShowValues:=strtobool(rlist[2]);
 until true;
 if flist.count<6 then exit;
  // printoptions
 repeat
 rlist.commatext:=flist[5];
 with PrintOptions do begin
  c:=rlist.count;
  if c<1 then break;
   if rlist[0]='portrait' then Orientation:=poportrait else Orientation:=polandscape;
  if c<2 then break;
   JobTitle:=rlist[1];
  if c<3 then break;
   PageTitle:=rlist[2];
  if c<4 then break;
   PageTitleMargin:=strtointdef(rlist[3],PageTitleMargin);
  if c<5 then break;
   PageFooter:=rlist[4];
  if c<6 then break;
   HeaderSize:=strtointdef(rlist[5],HeaderSize);
  if c<7 then break;
   FooterSize:=strtointdef(rlist[6],FooterSize);
  if c<8 then break;
   DateFormat:=rlist[7];
  if c<9 then break;
   TimeFormat:=rlist[8];
  if c<10 then break;
   if rlist[9]='none' then BorderStyle:=bsnone else BorderStyle:=bssingle;
  if c<11 then break;
   LeftPadding:=strtointdef(rlist[10],LeftPadding);
  if c<12 then break;
   MarginBottom:=strtointdef(rlist[11],MarginBottom);
  if c<13 then break;
   MarginLeft:=strtointdef(rlist[12],MarginLeft);
  if c<14 then break;
   Marginright:=strtointdef(rlist[13],MarginRight);
  if c<15 then break;
   MarginTop:=strtointdef(rlist[14],MarginTop);
  if c<16 then break;
   if rlist[15]='nil' then Logo:='' else logo:=rlist[15];
  end;
 until true;
 if flist.count<7 then exit;
  // CellNames
 s:=Flist[6];
 s:=stringreplace(s,'|',cr,[rfreplaceall]);
 FCellnames.Text :=s;
 rlist.free;
 flist.free;
end;


procedure TjanGrid.SetBandsColor(const Value: TColor);
begin
  if value<>FBandsColor then begin
   FBandsColor := Value;
   invalidate;
   end;
end;

procedure TjanGrid.SetBandsInterval(const Value: integer);
begin
  if value<>FBandsInterval then begin
   FBandsInterval := Value;
   invalidate;
   end;
end;

procedure TjanGrid.SetBandsShow(const Value: boolean);
begin
  if value<>FBandsshow then begin
   FBandsShow := Value;
   invalidate;
   end;
end;

procedure TjanGrid.SetNumbersalRight(const Value: boolean);
begin
  if value<>FNumbersalRight then begin
   FNumbersalRight := Value;
   invalidate;
   end;
end;



procedure TjanGrid.ShowRows;
begin
 AutosizeHiddenrows;
end;

procedure TjanGrid.HideRows;
var r1,r2,r,c:integer;
begin
 r1:=selection.top;
 r2:=selection.Bottom ;
 if not ((r1>=0)and (r2>=r1)) then exit;
 if (r1=1) then inc(r1);
 if r1>r2 then exit;
 for r:=r1 to r2 do
  rowheights[r]:=0;
end;

procedure TjanGrid.KeyUp(var Key: Word; Shift: TShiftState);
var newcol,newrow:integer;

 function DownVisible(Arow:integer):integer;
 var i:integer;
 begin
 result:=-1;
 for i:=arow to rowcount-1 do
   if rowheights[i]<>0 then begin
    result:=i;
    exit;
    end;
 end;

 function UpVisible(Arow:integer):integer;
 var i:integer;
 begin
 result:=-1;
 for i:=arow downto 1 do
   if rowheights[i]<>0 then begin
    result:=i;
    exit;
    end;
 end;

 function RightVisible(Acol:integer):integer;
 var i:integer;
 begin
 result:=-1;
 for i:=acol to colcount-1 do
   if colwidths[i]<>0 then begin
    result:=i;
    exit;
    end;
 end;

 function LeftVisible(Acol:integer):integer;
 var i:integer;
 begin
 result:=-1;
 for i:=acol downto 1 do
   if colwidths[i]<>0 then begin
    result:=i;
    exit;
    end;
 end;

begin
  inherited;
  if rowheights[row]=0 then begin
   if key=vk_down then begin
     newrow:=downvisible(row);
     if newrow<>-1 then row:=newrow
     else begin
      newrow:=upvisible(row);
      if newrow<>-1 then row:=newrow;
      end;
    end
    else if key=vk_up then begin
     newrow:=upvisible(row);
     if newrow<>-1 then row:=newrow
     else begin
      newrow:=downvisible(row);
      if newrow<>-1 then row:=newrow;
      end;
    end;
   end;
  if colwidths[col]=0 then begin
   if key=vk_right then begin
     newcol:=rightvisible(col);
     if newcol<>-1 then col:=newcol
     else begin
      newcol:=Leftvisible(col);
      if newcol<>-1 then col:=newcol;
      end;
    end
    else if key=vk_Left then begin
     newcol:=Leftvisible(col);
     if newcol<>-1 then col:=newcol
     else begin
      newcol:=rightvisible(col);
      if newcol<>-1 then col:=newcol;
      end;
    end;
   end;
  if assigned( onKeyup) then
      onkeyup(self,key, shift);
end;

procedure TjanGrid.AutoSizeVisibleRows;
begin
 autoSizeRowsEx;
end;

procedure TjanGrid.HideColumns;
var c1,c2,c:integer;
begin
 c1:=selection.Left;
 c2:=selection.Right ;
 if not ((c1>1)and (c2>=c1)) then exit;
 for c:=c1 to c2 do begin
   if colwidths[c]<>0 then
    FOldColwidths[c]:=colwidths[c];
   colwidths[c]:=0;
   end;
end;

procedure TjanGrid.Keydown(var Key: Word; Shift: TShiftState);
var Mkey,Dkey:word;
    MShift: TshiftState;
  function MRowInsert:boolean;
  begin
  ShortCutToKey(  KeyMappings.RowInsert ,Mkey,MShift);
  result:=((Mkey=Dkey) and (MShift=Shift));
  end;

  function MRowDelete:boolean;
  begin
  ShortCutToKey(  KeyMappings.RowDelete ,Mkey,MShift);
  result:=((Mkey=Dkey) and (MShift=Shift));
  end;

  function MColumnInsert:boolean;
  begin
  ShortCutToKey(  KeyMappings.ColumnInsert ,Mkey,MShift);
  result:=((Mkey=Dkey) and (MShift=Shift));
  end;

  function MColumnDelete:boolean;
  begin
  ShortCutToKey(  KeyMappings.ColumnDelete ,Mkey,MShift);
  result:=((Mkey=Dkey) and (MShift=Shift));
  end;

  function MPrintPreview:boolean;
  begin
  ShortCutToKey(  KeyMappings.PrintPreview ,Mkey,MShift);
  result:=((Mkey=Dkey) and (MShift=Shift));
  end;

  function MQueryDialog:boolean;
  begin
  ShortCutToKey(  KeyMappings.QueryDialog ,Mkey,MShift);
  result:=((Mkey=Dkey) and (MShift=Shift));
  end;

  function MFormuleDialog:boolean;
  begin
  ShortCutToKey(  KeyMappings.FormuleDialog ,Mkey,MShift);
  result:=((Mkey=Dkey) and (MShift=Shift));
  end;

  function MCellNamesDialog:boolean;
  begin
  ShortCutToKey(  KeyMappings.CellNamesDialog ,Mkey,MShift);
  result:=((Mkey=Dkey) and (MShift=Shift));
  end;

  function MSetHeader:boolean;
  begin
  ShortCutToKey(  KeyMappings.SetHeader ,Mkey,MShift);
  result:=((Mkey=Dkey) and (MShift=Shift));
  end;


begin
  if KeyMappingsEnabled then begin
   Dkey:=key;
   key:=0;
   if MRowInsert then InsertRow
   else if MRowDelete then RowDelete
   else if MColumnInsert then InsertColumn
   else if MColumndelete then ColumnDelete
   else if MPrintPreview then PrintPreview
   else if MQueryDialog then ShowQueryDialog
   else if MFormuleDialog then ShowFormuleDialog
   else if MCellNamesDialog then ShowCellNamesDialog
   else if MSetHeader then SetHeader
   else key:=Dkey;
  end;
  inherited;
  if key<>0 then
   if assigned( onKeyDown) then
     onkeyDown(self,key, shift);
end;


procedure TjanGrid.ShowFormuleDialog;
begin
 if ((col=0) or (row=0)) then exit;
 if not assigned(FormuleDialog) then
  FormuleDialog:=TjanGridFormuleF.Create (application);
  Formuledialog.Grid:=self;
  FormuleDialog.Cell :=point(col,row);
  Formuledialog.formule.text:=cells[col,row];
  FFormuleMode:=true;
  FormuleDialog.show;
end;

procedure TjanGrid.SetKeyMappings(const Value: TGridKeyMappings);
begin
  FKeyMappings := Value;
end;

procedure TjanGrid.SetKeyMappingsEnabled(const Value: Boolean);
begin
  FKeyMappingsEnabled := Value;
end;

function TjanGrid.parseFilter(Afilter:string):boolean;
var op,s:string;
    f : TGridFilterFunc;
    fieldnr,i,p:integer;
    Fieldname,Filtervalue:string;
begin
 result:=false;
 GridRowFilter.FilterCount :=0;
 s:=trim(Afilter);
 if s='' then exit;
 // parse field name
 repeat
 p:=pos('[',s);

 if p=0 then exit;
 s:=copy(s,p+1,length(s));
 p:=pos(']',s);
 if p=0 then exit;
 Fieldname:=copy(s,1,p-1);
 s:=trim(copy(s,p+1,length(s)));
 if FieldName='' then exit;
 // find fieldnumber
 FieldNr:=0;
 for i:=1 to colcount-1 do
  if cells[i,0]=Fieldname then begin
   Fieldnr:=i;
   Break;
   end;
 if fieldnr=0 then exit;
 // we have the field number, now check operand
 p:=pos('"',s); // " marks the beginning of the filter value
 if p=0 then exit;
 op:=lowercase(trim(copy(s,1,p-1)));
 s:=copy(s,p+1,length(s));
 p:=pos('"',s); // find the end of the filtervalue
 if p=0 then exit;
 FilterValue:=copy(s,1,p-1);
 s:=trim(copy(s,p+1,length(s)));
 if op='=' then
  f :=filterEQ
 else if op='<>' then
  f :=filterNE
 else if op='>' then
  f :=filterGT
 else if op='<' then
  f :=filterLT
 else if op='like' then
  f :=filterLIKE
  else exit;
 inc(GridRowFilter.FilterCount);
 if (GridRowFilter.FilterCount>9) then begin
  showmessage('Filter too complex');
  GridRowFilter.FilterCount:=0;
  exit;
  end;
 GridrowFilter.Filters[Gridrowfilter.FilterCount-1].FilterFunc :=f;
 GridrowFilter.Filters[Gridrowfilter.FilterCount-1].FilterField :=FieldNr;
 GridrowFilter.Filters[Gridrowfilter.FilterCount-1].FilterValue :=FilterValue;
 until s='';
 result:=true;
end;

procedure TjanGrid.ApplyFilter;
var arow,fi,fc,Filterfield:integer;
    FieldValue,FilterValue:string;
    fn:TGridFilterFunc;
    CanHide:boolean;
begin
 if GridRowFilter.FilterCount =0 then exit;
 fc:=GridRowFilter.FilterCount;
  for arow:=1 to rowcount-1 do begin
   CanHide:=false;
   for fi:=0 to fc-1 do begin
    fn:= GridRowFilter.Filters [fi].FilterFunc ;
    FilterValue:=GridRowFilter.Filters [fi].FilterValue ;
    filterField:=GridRowFilter.Filters [fi].FilterField ;
    FieldValue:=cells[FilterField,arow];
    if not fn(FieldValue,FilterValue) then begin
     CanHide:=true;
     break;
     end;
    end;
   if CanHide then rowheights[arow]:=0;
   end;
end;

procedure TjanGrid.FilterRows(AFilter: string);
begin
 if parseFilter(AFilter) then
  ApplyFilter;
end;

procedure TjanGrid.ShowQueryDialog;
var q:TjanGridQueryF;
begin
 q:=TjanGridQueryF.Create (application);
 q.FieldsList.Items.Assign (rows[0]);
 q.FieldsList.Items.Delete (0);
 q.Grid :=self;
 q.ShowModal ;
end;


function TjanGrid.SelectCell(ACol, ARow: Integer): boolean;
var Canselect:boolean;
  s:string;
begin
 CanSelect:=true;
 if FFormuleMode then
  if assigned(FormuleDialog) then begin
   if FA1Style then
     s:=RCtostr(acol,arow)
   else
     s:='c'+inttostr(acol)+'r'+inttostr(arow);
   FormuleDialog.formule.seltext:=s;
   end;
 if assigned(onselectcell) then
  onselectcell(self,acol,arow,CanSelect);
 result:=Canselect;
end;

procedure TjanGrid.SetFormuleMode(const Value: boolean);
begin
  FFormuleMode := Value;
end;

function TjanGrid.RCtostr(Acol,Arow: integer): string;
var c1,c2:integer;
    s:string;
begin
  c1:=Acol div 26;
  c2:= Acol mod 26;
  if c2=0 then
  begin
    c2:=26;
    if c1>0 then dec(c1);
  end;
  if c1>0 then
   s:=chr(c1+$40)+chr(c2+$40)
  else
   s:=chr(c2+$40);
  s:=s+inttostr(Arow);
  result :=s;
end;

function TjanGrid.strtoRC(s: string; var Acol,Arow: integer): boolean;
var s1,s2:integer;
    c1,r1:integer;
begin
  s:=uppercase(s);
  s1:=0;
  s2:=0;
  if s[1] in ['A'..'Z'] then
  begin
    s1:=ord(s[1])-$40;
    s:=copy(s,2,length(s));
  end;
  if s[1] in ['A'..'Z'] then
  begin
    s2:=ord(s[1])-$40;
    s:=copy(s,2,length(s));
  end;
  try
   r1:=strtoint(s);
   if s2<>0 then
   begin
     c1:=26*s1+s2;
   end
   else
   begin
     c1:=s1;
   end;
   ACol:=c1;
   Arow:=r1;
   result:=true;
   except
   result:=false;
   end;
end;

function TjanGrid.Ctostr(Acol: integer): string;
var c1,c2:integer;
    s:string;
begin
  c1:=Acol div 26;
  c2:= Acol mod 26;
  if c2=0 then
  begin
    c2:=26;
    if c1>0 then dec(c1);
  end;
  if c1>0 then
   s:=chr(c1+$40)+chr(c2+$40)
  else
   s:=chr(c2+$40);
  result :=s;
end;

procedure TjanGrid.SetA1Style(const Value: boolean);
begin
  if value<>FA1Style then
  begin
    FA1Style := Value;
    invalidate;
  end;
end;

procedure TjanGrid.AddCellName(Aname: string; Acol, Arow: integer);
begin
  if FCellNames.IndexOf (Aname)=-1 then
    FCellNames.Append (Aname+'='+RCtoStr(acol,arow));
end;

procedure TjanGrid.ClearCellNames;
begin
  FCellNames.Clear ;
end;

procedure TjanGrid.DeleteCellName(Aname: string);
var index:integer;
begin
  index:=FCellNames.IndexOfName (Aname);
  if index<>-1 then
    FCellNames.Delete (index);
end;

function TjanGrid.FindCellName(Aname: string; var ACol,
  Arow: integer): boolean;
var index:integer;
begin
  result:=false;
  index:=FCellNames.IndexOfName (Aname);
  if index=-1 then exit;
  if strToRC(FCellNames.values[aname],acol,arow) then
    result:=true;
end;

procedure TjanGrid.DeleteCellNameRC(acol, arow: integer);
var c,r,i:integer;
    s,rcs:string;
begin
  if FCellNames.Count =0 then exit;
  rcs:=RCTostr(acol,arow);
  for i:=0 to FCellNames.count-1 do
  begin
    s:=FCellnames.Names [i];
    if FCellNames.values[s]=rcs then
    begin
      FCellNames.Delete(i);
      exit;
    end;
  end;
end;

procedure TjanGrid.ShowCellNamesDialog;
var
 CNDialog: TjanGridCellNamesF;
 aname:string;
 s:string;
 acol,arow:integer;
begin
 CNDialog:=TjanGridCellNamesF.Create (application);
 CNdialog.CellNames.Assign (FCellNames);
 if FindCellNameRC(col,row,aname) then
   CNdialog.CellName :=aname
 else
   CNdialog.cellName:='';  
 CNdialog.Cell :=RCtostr(col,row);
 if CNDialog.ShowModal =mrOK then
 begin
   FCellnames.Assign (CNDialog.cellnames);
   s:=CNDialog.cell;
   if s<>'' then
     if strtoRC(s,acol,arow) then
     begin
       col:=acol;
       row:=arow;
     end;
 end;
 CNDialog.free;
end;

function TjanGrid.FindCellNameRC(acol, arow: integer;
  var Aname: string): boolean;
var c,r,i:integer;
    s,rcs:string;
begin
  result:=false;
  if FCellNames.Count =0 then exit;
  rcs:=RCTostr(acol,arow);
  for i:=0 to FCellNames.count-1 do
  begin
    s:=FCellnames.Names [i];
    if FCellNames.values[s]=rcs then
    begin
      aname:=s;
      result:=true;
      exit;
    end;
  end;
end;

procedure TjanGrid.DoShowHint(var HintStr: string;
  var CanShow: Boolean; var HintInfo: THintInfo);
var acol,arow,x,y:integer;
    aname,s,ds:string;
begin
  if HintInfo.HintControl = self then begin
   x:=HintInfo.CursorPos.x;
   y:=HintInfo.cursorPos.y;
   MouseToCell (x,y,acol,arow);
   canshow:=false;
   if ((acol<0)or(arow<0)) then exit;
   s:='';
   if findcellnameRC(acol,arow,aname) then
   begin
     s:=aname;
     hintinfo.HintColor:=$00D9FF;
   end;
   if ((acol>=0)and (arow>=0)) then begin
    ds:=cells[acol,arow];
    if ds<>'' then
     if ds[1]='=' then
     begin
       if s='' then
         s:=ds
       else
         s:=s+cr+ds;
     end;
    if s<>'' then begin
     Hintinfo.CursorRect :=CellRect (acol,arow);
     Hintstr:=s;
     canshow:=true;
     end;
    end;
   end;
end;




procedure TjanGrid.LoadFromHTML(Afile: string);
var
  hp:TjanHTMLParser;
begin
  try
    hp:=TjanHTMLParser.Create;
    hp.Lines.LoadFromFile (afile);
    hp.Execute ;
    hp.GetCSV (FRecordList);
    CSVtoGrid;
    recalculate;
    colwidths[0]:=20;
    FUpdateValues:=true;
  finally
    hp.Free;
  end;
end;

procedure TjanGrid.SetHeader;
var i:integer;
begin
  if row>=1 then
  begin
    for i:=1 to colcount-1 do
      cells[i,0]:=cells[i,row];
  end;
end;

{ TPrintOptions }


procedure TPrintOptions.SetDateFormat(const Value: string);
begin
  FDateFormat := Value;
end;

procedure TPrintOptions.SetFooterSize(const Value: Cardinal);
begin
  FFooterSize := Value;
end;

procedure TPrintOptions.SetHeaderSize(const Value: Cardinal);
begin
  FHeaderSize := Value;
end;

procedure TPrintOptions.SetLogo(const Value: string);
begin
  FLogo := Value;
end;

procedure TPrintOptions.SetMarginBottom(const Value: Cardinal);
begin
  FMarginBottom := Value;
end;

procedure TPrintOptions.SetMarginLeft(const Value: Cardinal);
begin
  FMarginLeft := Value;
end;

procedure TPrintOptions.SetMarginRight(const Value: Cardinal);
begin
  FMarginRight := Value;
end;

procedure TPrintOptions.SetMarginTop(const Value: Cardinal);
begin
  FMarginTop := Value;
end;

procedure TPrintOptions.SetOrientation(const Value: TPrinterOrientation);
begin
  FOrientation := Value;
end;

procedure TPrintOptions.SetPageFooter(const Value: string);
begin
  FPageFooter := Value;
end;

procedure TPrintOptions.SetTimeFormat(const Value: string);
begin
  FTimeFormat := Value;
end;

procedure TjanGrid.SmoothResize(var Src, Dst: TBitmap);
var
x,y,xP,yP,
yP2,xP2:     Integer;
Read,Read2:  PByteArray;
t,z,z2,iz2:  Integer;
pc:PBytearray;
w1,w2,w3,w4: Integer;
Col1r,col1g,col1b,Col2r,col2g,col2b:   byte;
begin
  xP2:=((src.Width-1)shl 15)div Dst.Width;
  yP2:=((src.Height-1)shl 15)div Dst.Height;
  yP:=0;
  for y:=0 to Dst.Height-1 do
  begin
    xP:=0;
    Read:=src.ScanLine[yP shr 15];
    if yP shr 16<src.Height-1 then
      Read2:=src.ScanLine [yP shr 15+1]
    else
      Read2:=src.ScanLine [yP shr 15];
    pc:=Dst.scanline[y];
    z2:=yP and $7FFF;
    iz2:=$8000-z2;
    for x:=0 to Dst.Width-1 do
    begin
      t:=xP shr 15;
      Col1r:=Read[t*3];
      Col1g:=Read[t*3+1];
      Col1b:=Read[t*3+2];
      Col2r:=Read2[t*3];
      Col2g:=Read2[t*3+1];
      Col2b:=Read2[t*3+2];
      z:=xP and $7FFF;
      w2:=(z*iz2)shr 15;
      w1:=iz2-w2;
      w4:=(z*z2)shr 15;
      w3:=z2-w4;
      pc[x*3+2]:=
        (Col1b*w1+Read[(t+1)*3+2]*w2+
         Col2b*w3+Read2[(t+1)*3+2]*w4)shr 15;
      pc[x*3+1]:=
        (Col1g*w1+Read[(t+1)*3+1]*w2+
         Col2g*w3+Read2[(t+1)*3+1]*w4)shr 15;
      pc[x*3]:=
        (Col1r*w1+Read2[(t+1)*3]*w2+
         Col2r*w3+Read2[(t+1)*3]*w4)shr 15;
      Inc(xP,xP2);
    end;
    Inc(yP,yP2);
  end;
end;


{ TGridKeyMappings }

procedure TGridKeyMappings.SetFormuleDialog(const Value: TShortCut);
begin
  FFormuleDialog := Value;
end;

procedure TGridKeyMappings.SetColumnDelete(const Value: TShortCut);
begin
  FColumnDelete := Value;
end;

procedure TGridKeyMappings.SetColumnInsert(const Value: TShortCut);
begin
  FColumnInsert := Value;
end;

procedure TGridKeyMappings.SetPrintPreview(const Value: TShortCut);
begin
  FPrintPreview := Value;
end;

procedure TGridKeyMappings.SetQueryDialog(const Value: TshortCut);
begin
  FQueryDialog := Value;
end;

procedure TGridKeyMappings.SetRowDelete(const Value: TShortCut);
begin
  FRowDelete := Value;
end;

procedure TGridKeyMappings.SetRowInsert(const Value: TShortCut);
begin
  FRowInsert := Value;
end;

procedure TGridKeyMappings.SetCellNamesDialog(const Value: Tshortcut);
begin
  FCellNamesDialog := Value;
end;

procedure TGridKeyMappings.SetSetHeader(const Value: Tshortcut);
begin
  FSetHeader := Value;
end;

end.

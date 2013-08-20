unit janGridPreview;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls,janGrid, StdCtrls, Spin, ComCtrls, Buttons,printers,
  ExtDlgs;

type
  TjanGridPreviewF = class(TForm)
    ScrollBox1: TScrollBox;
    PreviewImage: TImage;
    Panel1: TPanel;
    Header: TEdit;
    Headers: TListBox;
    Margin: TSpinEdit;
    ckborders: TCheckBox;
    Margins: TListBox;
    btnprint: TSpeedButton;
    previewpage: TSpinEdit;
    btnshow: TSpeedButton;
    lblpages: TLabel;
    cklive: TCheckBox;
    btnsetup: TSpeedButton;
    PrinterSetupDialog1: TPrinterSetupDialog;
    btnfull: TSpeedButton;
    OpenPictureDialog1: TOpenPictureDialog;
    btnpic: TSpeedButton;
    procedure btnshowClick(Sender: TObject);
    procedure MarginsClick(Sender: TObject);
    procedure btnprintClick(Sender: TObject);
    procedure MarginChange(Sender: TObject);
    procedure HeaderChange(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure ckbordersClick(Sender: TObject);
    procedure previewpageChange(Sender: TObject);
    procedure HeadersClick(Sender: TObject);
    procedure ckliveClick(Sender: TObject);
    procedure btnsetupClick(Sender: TObject);
    procedure btnfullClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure PreviewImageClick(Sender: TObject);
    procedure btnpicClick(Sender: TObject);
  private
    FGrid: TjanGrid;
    FPrintImage: TBitmap;
    procedure SetGrid(const Value: TjanGrid);
    procedure FullSize;
    procedure SetPrintImage(const Value: TBitmap);
    procedure Zoom(factor: extended);
    { Private declarations }
  public
    { Public declarations }
  published
   property Grid:TjanGrid read FGrid write SetGrid;
   property PrintImage:TBitmap read FPrintImage write SetPrintImage;
  end;

var
  janGridPreviewF: TjanGridPreviewF;

implementation

{$R *.DFM}

{ TjansgPreviewF }

procedure TjanGridPreviewF.SetGrid(const Value: TjanGrid);
begin
  FGrid := Value;
end;

procedure TjanGridPreviewF.btnshowClick(Sender: TObject);
begin
 if assigned(FGrid) then begin
  FGrid.UpdatePreview (FprintImage.canvas);
  PreviewImage.picture.bitmap.Assign (FprintImage);
  end;
end;

procedure TjanGridPreviewF.MarginsClick(Sender: TObject);
var index:integer;
begin
 index:=margins.itemindex;
 if index=-1 then exit;
 if index=0 then
  margin.Value:=Grid.PrintOptions.MarginTop
  else if index=1 then
  margin.value:=Grid.PrintOptions.PageTitleMargin
  else if index=2 then
  margin.value:=Grid.PrintOptions.MarginLeft
  else if index=3 then
  margin.value:=Grid.PrintOptions.MarginRight
  else if index=4 then
  margin.value:=Grid.PrintOptions.MarginBottom
  else if index=5 then
  margin.value:=Grid.PrintOptions.Leftpadding
  else if index=6 then
  margin.value:=Grid.PrintOptions.HeaderSize
  else if index=7 then
  margin.value:=Grid.PrintOptions.FooterSize ;
  if index>5 then begin
   margin.MinValue :=6;
   margin.MaxValue:=72;
   end
   else begin
   margin.MinValue :=0;
   margin.MaxValue :=400;
   end;
end;

procedure TjanGridPreviewF.btnprintClick(Sender: TObject);
begin
 Grid.Print ;
end;

procedure TjanGridPreviewF.MarginChange(Sender: TObject);
var index:integer;
begin
 index:=margins.ItemIndex ;
 if index=-1 then exit;
 if index=0 then
  Grid.PrintOptions.MarginTop :=margin.Value
  else if index=1 then
  Grid.PrintOptions.PageTitleMargin :=margin.value
  else if index=2 then
  Grid.PrintOptions.MarginLeft :=margin.value
  else if index=3 then
  Grid.PrintOptions.MarginRight :=margin.value
  else if index=4 then
  Grid.PrintOptions.MarginBottom :=margin.value
  else if index=5 then
  Grid.PrintOptions.Leftpadding :=margin.value
  else if index=6 then
  Grid.PrintOptions.HeaderSize :=margin.value
  else if index=7 then
  Grid.PrintOptions.FooterSize :=margin.value;
 if cklive.checked then btnshow.Click ;  
end;
  
procedure TjanGridPreviewF.HeaderChange(Sender: TObject);
var index:integer;
begin
 index:=headers.ItemIndex ;
 if index=-1 then exit;
 if index=0 then
  Grid.PrintOptions.PageTitle  :=header.text
  else if index=1 then
  Grid.PrintOptions.PageFooter  :=header.text
  else if index=2 then
  Grid.PrintOptions.DateFormat :=header.text
  else if index=3 then
  Grid.PrintOptions.TimeFormat :=header.text
  else if index=4 then
  Grid.PrintOptions.Logo :=header.text;
 if cklive.checked then btnshow.Click ;
end;

procedure TjanGridPreviewF.FormShow(Sender: TObject);
begin
  Header.text :=Grid.PrintOptions.PageTitle ;
  Margin.Value :=Grid.Printoptions.margintop ;
  Margins.itemindex:=0;
  previewpage.MaxValue :=Grid.PageCount ;
  lblpages.caption:='of '+inttostr(previewpage.maxvalue);
  Grid.PrintOptions.PreviewPage :=1;
  previewpage.value:=1;
  ckBorders.Checked :=(Grid.printoptions.borderstyle=bssingle);
  header.text:=Grid.PrintOptions.PageTitle ;
  headers.itemindex:=0;
end;

procedure TjanGridPreviewF.ckbordersClick(Sender: TObject);
begin
 if ckborders.checked then
 Grid.PrintOptions.BorderStyle :=bssingle
 else
 Grid.PrintOptions.BorderStyle :=bsnone;
 if cklive.checked then btnshow.Click ; 
end;

procedure TjanGridPreviewF.previewpageChange(Sender: TObject);
begin
 if previewpage.value<previewpage.MinValue then
  previewpage.value:=previewpage.MinValue;
 if previewpage.value>previewpage.MaxValue then
  previewpage.value:=previewpage.MaxValue;
 Grid.PrintOptions.PreviewPage :=previewpage.Value ;
 if cklive.checked then btnshow.Click ; 
end;

procedure TjanGridPreviewF.HeadersClick(Sender: TObject);
var index:integer;
begin
 index:=headers.itemindex;
 if index=-1 then exit;
 if index=0 then
  header.text:=Grid.PrintOptions.PageTitle
  else if index=1 then
  header.text:=Grid.PrintOptions.PageFooter
  else if index=2 then
  header.text:=Grid.PrintOptions.DateFormat
  else if index=3 then
  header.text:=Grid.PrintOptions.TimeFormat
  else if index=4 then
  header.text:=Grid.printoptions.Logo;

end;

procedure TjanGridPreviewF.ckliveClick(Sender: TObject);
begin
 if cklive.checked then btnshow.Click ;
end;

procedure TjanGridPreviewF.btnsetupClick(Sender: TObject);
begin
 if printersetupdialog1.Execute then begin
  Grid.PrintOptions.Orientation :=printer.Orientation;
  if cklive.checked then btnshow.Click ;
  end;
end;



procedure TjanGridPreviewF.FullSize;
var bm:tbitmap;
    w,h:integer;
begin
 w:=printimage.width;
 h:=printImage.Height ;
 bm:=tbitmap.create;
 bm.Width :=scrollbox1.ClientWidth ;
 bm.height:=round(h/w*bm.width);
 PrintImage.PixelFormat:=pf24bit;
 bm.PixelFormat :=pf24bit;
 FGrid.smoothresize(FprintImage,bm);
 previewimage.picture.bitmap.assign(bm);
 bm.free;
end;

procedure TjanGridPreviewF.btnfullClick(Sender: TObject);
begin
 FullSize;
end;

procedure TjanGridPreviewF.SetPrintImage(const Value: TBitmap);
begin
  FPrintImage := Value;
end;

procedure TjanGridPreviewF.FormCreate(Sender: TObject);
begin
 FprintImage:=TBitmap.Create ;
end;

procedure TjanGridPreviewF.FormDestroy(Sender: TObject);
begin
 FPrintImage.free;
end;

procedure TjanGridPreviewF.PreviewImageClick(Sender: TObject);
var w,h,w1,h1:integer;
begin
 w1:=PreviewImage.picture.bitmap.width;
 w:=FPrintImage.width;
 if (round(w*0.8)<w1) then begin
  PreviewImage.Picture.Bitmap.Assign (FPrintImage);
  end
  else begin
  Zoom(w1/w/0.8);
  end;
end;

procedure TjanGridPreviewF.Zoom(factor:extended);
var bm:tbitmap;
    w,h:integer;
begin
 w:=printimage.width;
 h:=printImage.Height ;
 bm:=tbitmap.create;
 bm.Width :=round(factor*w);
 bm.height:=round(h/w*bm.width);
 PrintImage.PixelFormat:=pf24bit;
 bm.PixelFormat :=pf24bit;
 FGrid.smoothresize(FprintImage,bm);
 previewimage.picture.bitmap.assign(bm);
 bm.free;
end;

procedure TjanGridPreviewF.btnpicClick(Sender: TObject);
begin
 if openpicturedialog1.Execute then
  if headers.itemindex=4 then begin
   header.text:=openpicturedialog1.filename;
   Grid.PrintOptions.Logo :=openpicturedialog1.filename;;
   end;
end;

end.

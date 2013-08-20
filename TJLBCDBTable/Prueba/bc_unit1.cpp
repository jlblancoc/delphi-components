//---------------------------------------------------------------------------

#include <vcl.h>
#pragma hdrstop

#include "bc_unit1.h"
//---------------------------------------------------------------------------
#pragma package(smart_init)
#pragma link "JLBCDBStringGrid"
#pragma link "JLBCDBTable"
#pragma resource "*.dfm"
TForm1 *Form1;
//---------------------------------------------------------------------------
__fastcall TForm1::TForm1(TComponent* Owner)
        : TForm(Owner)
{
}
//---------------------------------------------------------------------------
void __fastcall TForm1::Button1Click(TObject *Sender)
{
 t1->Open();
 tb1->FillData();

}
//---------------------------------------------------------------------------

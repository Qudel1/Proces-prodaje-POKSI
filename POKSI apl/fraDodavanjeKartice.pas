unit fraDodavanjeKartice;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Layouts, FMX.Objects, FMX.ScrollBox, FMX.Controls.Presentation, FMX.Edit;

type
  TfraDodavanjeKartice = class(TFrame)
    layoutRoot: TLayout;
    layoutHeader: TLayout;
    btnZatvori: TButton;
    lblTitle: TLabel;
    layoutFooter: TLayout;
    rectFooterBg: TRectangle;
    btnNastavi: TButton;
    vertScroll: TVertScrollBox;
    lblOpis: TLabel;
    lblImeVlasnika: TLabel;
    rectImeVlasnika: TRectangle;
    editImeVlasnika: TEdit;
    lblCVV: TLabel;
    rectCVV: TRectangle;
    editCVV: TEdit;
    lblBanka: TLabel;
    rectBanka: TRectangle;
    editBanka: TEdit;
    lblBrojKartice: TLabel;
    rectBrojKartice: TRectangle;
    editBrojKartice: TEdit;
    lblBrojRacuna: TLabel;
    rectBrojRacuna: TRectangle;
    editBrojRacuna: TEdit;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.fmx}

end.

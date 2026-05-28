unit fraFiskalniRacun;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Layouts, FMX.Objects, FMX.ScrollBox, FMX.Controls.Presentation, FMX.Edit;

type
  TfraFiskalniRacun = class(TFrame)
    layoutRoot: TLayout;
    layoutHeader: TLayout;
    btnNazad: TButton;
    lblTitle: TLabel;
    btnDownload: TButton;
    layoutFooter: TLayout;
    layoutAkcije: TLayout;
    btnPreuzmi: TButton;
    btnPosalje: TButton;
    btnPodeli: TButton;
    rectBtnPregledaj: TRectangle;
    btnPregledaj: TButton;
    vertScroll: TVertScrollBox;
    layoutPOKSIHeader: TLayout;
    lblPOKSI: TLabel;
    layoutPOKSIRight: TLayout;
    lblRacunBr: TLabel;
    lblDatum: TLabel;
    lblPenzion: TLabel;
    rectDivider1: TRectangle;
    lblProdavac: TLabel;
    layoutProd1: TLayout;
    lblProd1L: TLabel;
    lblProd1R: TLabel;
    layoutProd2: TLayout;
    lblProd2L: TLabel;
    lblProd2R: TLabel;
    rectDivider2: TRectangle;
    lblKupac: TLabel;
    layoutKup1: TLayout;
    lblKup1L: TLabel;
    lblKup1R: TLabel;
    layoutKup2: TLayout;
    lblKup2L: TLabel;
    lblKup2R: TLabel;
    rectDivider3: TRectangle;
    lblStavke: TLabel;
    layoutS1: TLayout;
    lblS1L: TLabel;
    lblS1R: TLabel;
    layoutS2: TLayout;
    lblS2L: TLabel;
    lblS2R: TLabel;
    layoutS3: TLayout;
    lblS3L: TLabel;
    lblS3R: TLabel;
    layoutS4: TLayout;
    lblS4L: TLabel;
    lblS4R: TLabel;
    rectDivider4: TRectangle;
    layoutMedjutim: TLayout;
    lblMedjutimT: TLabel;
    lblMedjutimV: TLabel;
    layoutPopust: TLayout;
    lblPopustT: TLabel;
    lblPopustV: TLabel;
    layoutPDV: TLayout;
    lblPDVT: TLabel;
    lblPDVV: TLabel;
    layoutUkupno: TLayout;
    lblUkupnoT: TLabel;
    lblUkupnoV: TLabel;
    rectDivider5: TRectangle;
    layoutNacinPlacanja: TLayout;
    lblNacinT: TLabel;
    lblNacinV: TLabel;
    layoutStatus: TLayout;
    lblStatusT: TLabel;
    lblStatusV: TLabel;
    rectQR: TRectangle;
    lblQR: TLabel;
    lblQRSub: TLabel;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.fmx}

end.

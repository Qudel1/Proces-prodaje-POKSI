unit fraPredracun;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Layouts, FMX.Objects, FMX.ScrollBox, FMX.Controls.Presentation, FMX.Edit;

type
  TfraPredracun = class(TFrame)
    layoutRoot: TLayout;
    layoutHeader: TLayout;
    btnNazad: TButton;
    layoutHeaderText: TLayout;
    lblTitle: TLabel;
    lblPodTitle: TLabel;
    layoutFooter: TLayout;
    rectFooterBg: TRectangle;
    btnPlatiPotvrdi: TButton;
    vertScroll: TVertScrollBox;
    lblKorisnikLjubimac: TLabel;
    rectKorisnik: TRectangle;
    lblKorisnikIme: TLabel;
    lblKorisnikEmail: TLabel;
    lblKorisnikLjubimacInfo: TLabel;
    lblDetaljiBoravka: TLabel;
    layoutDatum: TLayout;
    lblDatumText: TLabel;
    lblDatumVal: TLabel;
    layoutBoks: TLayout;
    lblBoksText: TLabel;
    lblBoksVal: TLabel;
    layoutTrajanje: TLayout;
    lblTrajanjeText: TLabel;
    lblTrajanjeVal: TLabel;
    lblUkljuceneUsluge: TLabel;
    rectHrana: TRectangle;
    lblHranaText: TLabel;
    lblHranaCena: TLabel;
    rectKupanje: TRectangle;
    lblKupanjeText: TLabel;
    lblKupanjeCena: TLabel;
    rectVeterinar: TRectangle;
    lblVeterinarText: TLabel;
    lblVeterinarCena: TLabel;
    lblIznosPlacanja: TLabel;
    layoutSmestaj: TLayout;
    lblSmestajText: TLabel;
    lblSmestajVal: TLabel;
    layoutUsluge: TLayout;
    lblUslugeText: TLabel;
    lblUslugeVal: TLabel;
    layoutPopust: TLayout;
    lblPopustText: TLabel;
    lblPopustVal: TLabel;
    layoutPorez: TLayout;
    lblPorezText: TLabel;
    lblPorezVal: TLabel;
    layoutUkupno: TLayout;
    lblUkupnoText: TLabel;
    lblUkupnoVal: TLabel;
    rectBrojRezervacije: TRectangle;
    lblBrojRezLabel: TLabel;
    lblBrojRezVal: TLabel;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.fmx}

end.

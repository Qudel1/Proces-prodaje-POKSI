unit fraRezervacija;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Layouts, FMX.Objects, FMX.ScrollBox, FMX.Controls.Presentation, FMX.Edit;

type
  TfraRezervacija = class(TFrame)
    layoutRoot: TLayout;
    layoutHeader: TLayout;
    btnZatvori: TButton;
    lblTitle: TLabel;
    layoutFooter: TLayout;
    rectFooterBg: TRectangle;
    btnPlati: TButton;
    vertScroll: TVertScrollBox;
    lblLicniPodaci: TLabel;
    rectOdaberi: TRectangle;
    lblOdaberi: TLabel;
    lblOdaberiArrow: TLabel;
    lblNazivObjekta: TLabel;
    rectNazivObjekta: TRectangle;
    lblNazivObjektaVal: TLabel;
    lblLokacija: TLabel;
    rectLokacija: TRectangle;
    lblLokacijaVal: TLabel;
    lblOtvoriMapu: TLabel;
    lblIDKorisnika: TLabel;
    rectIDKorisnika: TRectangle;
    lblIDVal: TLabel;
    lblKontakt: TLabel;
    rectEmail: TRectangle;
    lblEmailVal: TLabel;
    rectPhone: TRectangle;
    lblPhoneVal: TLabel;
    lblDatumBoravka: TLabel;
    rectDolazak: TRectangle;
    lblDolazakVal: TLabel;
    lblIzaberiDatum1: TLabel;
    rectOdlazak: TRectangle;
    lblOdlazakVal: TLabel;
    lblIzaberiDatum2: TLabel;
    layoutSobeHeader: TLayout;
    lblSobeLjubimci: TLabel;
    lblSobePromeni: TLabel;
    rectBoks: TRectangle;
    lblBoksText: TLabel;
    lblBoksArrow: TLabel;
    rectLjubimci: TRectangle;
    lblLjubimciText: TLabel;
    lblLjubimciArrow: TLabel;
    layoutPlacanjeHeader: TLayout;
    lblPlacanje: TLabel;
    lblPlacanjePromeni: TLabel;
    rectMastercard: TRectangle;
    lblMastercardText: TLabel;
    rectVisa: TRectangle;
    lblVisaText: TLabel;
    rectKes: TRectangle;
    lblKesText: TLabel;
    layoutIznosiHeader: TLayout;
    rectDivider: TRectangle;
    layoutMedjutim: TLayout;
    lblMedjutimText: TLabel;
    lblMedjutimVal: TLabel;
    layoutNaziv: TLayout;
    lblNazivText: TLabel;
    layoutUkupno: TLayout;
    lblUkupnoText: TLabel;
    lblUkupnoVal: TLabel;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.fmx}

end.

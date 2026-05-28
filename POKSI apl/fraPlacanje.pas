unit fraPlacanje;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Layouts, FMX.Objects, FMX.ScrollBox, FMX.Controls.Presentation, FMX.Edit;

type
  TfraPlacanje = class(TFrame)
    layoutRoot: TLayout;
    layoutHeader: TLayout;
    btnNazad: TButton;
    lblTitle: TLabel;
    btnDodajKarticu: TButton;
    layoutFooter: TLayout;
    rectFooterBg: TRectangle;
    btnPotvrdi: TButton;
    vertScroll: TVertScrollBox;
    lblVasaKartica: TLabel;
    rectKartica: TRectangle;
    lblKarticaIznos: TLabel;
    lblKarticaName: TLabel;
    lblKarticaExp: TLabel;
    lblNacinPlacanja: TLabel;
    rectMastercard: TRectangle;
    lblMastercardText: TLabel;
    rbMastercard: TRadioButton;
    rectKes: TRectangle;
    lblKesText: TLabel;
    rbKes: TRadioButton;
    rectVisa: TRectangle;
    lblVisaText: TLabel;
    rbVisa: TRadioButton;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.fmx}

end.

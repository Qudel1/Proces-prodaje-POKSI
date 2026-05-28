unit fraDodatneInf;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Layouts, FMX.Objects, FMX.ScrollBox, FMX.Controls.Presentation, FMX.Edit;

type
  TfraDodatneInf = class(TFrame)
    layoutRoot: TLayout;
    layoutHeader: TLayout;
    btnZatvori: TButton;
    lblTitle: TLabel;
    vertScroll: TVertScrollBox;
    lblLicniPodaci: TLabel;
    lblIme: TLabel;
    rectIme: TRectangle;
    lblImeVal: TLabel;
    lblPrezime: TLabel;
    rectPrezime: TRectangle;
    lblPrezimeVal: TLabel;
    lblAdresa: TLabel;
    rectAdresa: TRectangle;
    lblAdresaVal: TLabel;
    lblIDKorisnika: TLabel;
    rectID: TRectangle;
    lblIDVal: TLabel;
    lblKontakt: TLabel;
    lblEmail: TLabel;
    rectEmail: TRectangle;
    lblEmailVal: TLabel;
    lblPhone: TLabel;
    rectPhone: TRectangle;
    lblPhoneVal: TLabel;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Edit5: TEdit;
    Edit6: TEdit;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.fmx}

end.

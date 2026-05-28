unit fraPotvrda;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Layouts, FMX.Objects, FMX.ScrollBox, FMX.Controls.Presentation, FMX.Edit;

type
  TfraPotvrda = class(TFrame)
    layoutRoot: TLayout;
    layoutHeader: TLayout;
    btnZatvori: TButton;
    lblTitle: TLabel;
    layoutFooter: TLayout;
    rectFooterBg: TRectangle;
    btnNastavi: TButton;
    vertScroll: TVertScrollBox;
    lblOpis: TLabel;
    lblPodaciOKartici: TLabel;
    rectRed1: TRectangle;
    lblRed1: TLabel;
    rectRed2: TRectangle;
    lblRed2: TLabel;
    rectRed3: TRectangle;
    lblRed3: TLabel;
    rectRed4: TRectangle;
    lblRed4: TLabel;
    rectRed5: TRectangle;
    lblRed5: TLabel;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.fmx}

end.

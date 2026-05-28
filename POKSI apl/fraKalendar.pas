unit fraKalendar;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Layouts, FMX.Objects, FMX.Controls.Presentation;

type
  TfraKalendar = class(TFrame)
    layoutRoot: TLayout;
    layoutHeader: TLayout;
    lblX: TLabel;
    lblTitle: TLabel;
    layoutDolaziOdlazak: TLayout;
    rectDolazak: TRectangle;
    lblDolazakIkona: TLabel;
    lblDolazakDatum: TLabel;
    rectOdlazak: TRectangle;
    lblOdlazakIkona: TLabel;
    lblOdlazakDatum: TLabel;
    layoutMesecNav: TLayout;
    btnPrevMesec: TButton;
    lblMesecGodina: TLabel;
    btnNextMesec: TButton;
    layoutDaniNedelje: TLayout;
    lblS1: TLabel;
    lblM: TLabel;
    lblT1: TLabel;
    lblW: TLabel;
    lblT2: TLabel;
    lblF: TLabel;
    lblS2: TLabel;
    gridKalendar: TGridLayout;
    rectD1: TRectangle;
    lblD1: TLabel;
    rectD2: TRectangle;
    lblD2: TLabel;
    rectD3: TRectangle;
    lblD3: TLabel;
    rectD4: TRectangle;
    lblD4: TLabel;
    rectD5: TRectangle;
    lblD5: TLabel;
    rectD6: TRectangle;
    lblD6: TLabel;
    rectD7: TRectangle;
    lblD7: TLabel;
    rectD8: TRectangle;
    lblD8: TLabel;
    rectD9: TRectangle;
    lblD9: TLabel;
    rectD10: TRectangle;
    lblD10: TLabel;
    rectD11: TRectangle;
    lblD11: TLabel;
    rectD12: TRectangle;
    lblD12: TLabel;
    rectD13: TRectangle;
    lblD13: TLabel;
    rectD14: TRectangle;
    lblD14: TLabel;
    rectD15: TRectangle;
    lblD15: TLabel;
    rectD16: TRectangle;
    lblD16: TLabel;
    rectD17: TRectangle;
    lblD17: TLabel;
    rectD18: TRectangle;
    lblD18: TLabel;
    rectD19: TRectangle;
    lblD19: TLabel;
    rectD20: TRectangle;
    lblD20: TLabel;
    rectD21: TRectangle;
    lblD21: TLabel;
    rectD22: TRectangle;
    lblD22: TLabel;
    rectD23: TRectangle;
    lblD23: TLabel;
    rectD24: TRectangle;
    lblD24: TLabel;
    rectD25: TRectangle;
    lblD25: TLabel;
    rectD26: TRectangle;
    lblD26: TLabel;
    rectD27: TRectangle;
    lblD27: TLabel;
    rectD28: TRectangle;
    lblD28: TLabel;
    rectD29: TRectangle;
    lblD29: TLabel;
    rectD30: TRectangle;
    lblD30: TLabel;
    rectD31: TRectangle;
    lblD31: TLabel;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.fmx}

end.

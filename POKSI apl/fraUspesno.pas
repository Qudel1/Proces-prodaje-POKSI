unit fraUspesno;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Layouts, FMX.Objects, FMX.ScrollBox, FMX.Controls.Presentation, FMX.Edit;

type
  TfraUspesno = class(TFrame)
    layoutRoot: TLayout;
    vertScroll: TVertScrollBox;
    rectCheckmark: TRectangle;
    lblCheck: TLabel;
    lblUspesno: TLabel;
    lblPoruka: TLabel;
    lblStatusNotif: TLabel;
    rectEmail: TRectangle;
    lblEmailNaslov: TLabel;
    lblEmailSub: TLabel;
    lblEmailStatus: TLabel;
    rectSMS: TRectangle;
    lblSMSNaslov: TLabel;
    lblSMSSub: TLabel;
    lblSMSStatus: TLabel;
    rectKalendar: TRectangle;
    lblKalendarNaslov: TLabel;
    lblKalendarSub: TLabel;
    lblKalendarStatus: TLabel;
    rectOsoblje: TRectangle;
    lblOsobljeNaslov: TLabel;
    lblOsobljeSub: TLabel;
    lblOsobljeStatus: TLabel;
    rectBrojRezervacije: TRectangle;
    lblBrojRez: TLabel;
    rectBtnPregledaj: TRectangle;
    btnPregledaj: TButton;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.fmx}

end.

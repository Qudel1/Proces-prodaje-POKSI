unit fraUspesno;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Layouts, FMX.Objects, FMX.ScrollBox, FMX.Controls.Presentation, FMX.Edit,
  FireDAC.Comp.Client, uNavFrames, uUserStore, uKorpa;

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

    procedure btnPregledajClick(Sender: TObject);
    procedure btnNazadClick(Sender: TObject);
    procedure Loaded; override;
    procedure FrameEnter(Sender: TObject);
  private
    FBtnNazad: TButton;
    procedure Popuni;
  public
  end;

implementation

{$R *.fmx}

uses
  fraFiskalniRacun;

procedure TfraUspesno.Popuni;
begin
  if AktivniRacunBroj <> '' then
    lblBrojRez.Text := AktivniRacunBroj;

  lblPoruka.Text :=
    'Va' + #353 + 'a rezervacija je potvr' + #273 + 'ena. Detalji su poslati na sledece kanale.';
  lblEmailSub.Text := 'Poslato na ' + LoggedUserEmail;
  lblSMSSub.Text   := 'Poslato na ' + LoggedUserPhone;

  if IzabraniBoksText <> '' then
    lblOsobljeSub.Text := 'Radni nalog generisan za ' + IzabraniBoksText
  else
    lblOsobljeSub.Text := 'Radni nalog generisan';
end;

procedure TfraUspesno.Loaded;
begin
  inherited;
  if not Assigned(FBtnNazad) then
  begin
    FBtnNazad := TButton.Create(Self);
    FBtnNazad.Parent := layoutRoot;
    FBtnNazad.Position.X := 16;
    FBtnNazad.Position.Y := 12;
    FBtnNazad.Width := 44;
    FBtnNazad.Height := 40;
    FBtnNazad.Text := #10094;
    FBtnNazad.Font.Size := 18;
    FBtnNazad.OnClick := btnNazadClick;
    FBtnNazad.BringToFront;
  end;
  Popuni;
end;

procedure TfraUspesno.FrameEnter(Sender: TObject);
begin
  Popuni;
end;

procedure TfraUspesno.btnPregledajClick(Sender: TObject);
begin
  TNavFrames.Go(TfraFiskalniRacun.Create(nil));
end;

procedure TfraUspesno.btnNazadClick(Sender: TObject);
begin
  KorpaOcisti;
  TNavFrames.Back;
end;

end.

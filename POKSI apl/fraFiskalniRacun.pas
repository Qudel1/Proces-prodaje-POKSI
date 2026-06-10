unit fraFiskalniRacun;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  System.DateUtils,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Layouts, FMX.Objects, FMX.ScrollBox, FMX.Controls.Presentation, FMX.Edit,
  FireDAC.Comp.Client, uNavFrames, uKorpa, uUserStore;

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

    procedure btnNazadClick(Sender: TObject);
    procedure btnPregledajClick(Sender: TObject);
    procedure btnPreuzmiClick(Sender: TObject);
    procedure btnPosaljeClick(Sender: TObject);
    procedure btnPodeliClick(Sender: TObject);
    procedure Loaded; override;
    procedure FrameEnter(Sender: TObject);
  private
    procedure Popuni;
  public
  end;

implementation

{$R *.fmx}

uses
  fraHome;

procedure TfraFiskalniRacun.Popuni;
var
  Lvls: array[0..3] of TLabel;
  Rvls: array[0..3] of TLabel;
  i, r, idx: Integer;
  G: TSesijaRacun;
  nadjen: Boolean;
begin
  nadjen := False;
  idx := -1;
  for i := 0 to High(SesijaRacuni) do
    if SesijaRacuni[i].BrojRacuna = AktivniRacunBroj then
    begin
      idx := i;
      nadjen := True;
      Break;
    end;
  if nadjen then
    G := SesijaRacuni[idx];

  lblPOKSI.Text := 'POKSI';
  if nadjen then
  begin
    lblRacunBr.Text := 'Racun br: ' + G.BrojRacuna;
    lblDatum.Text   := G.Datum;
  end
  else
  begin
    lblRacunBr.Text := 'Racun br: -';
    lblDatum.Text   := FormatDateTime('dd.mm.yyyy - hh:nn', Now);
  end;
  lblPenzion.Text := 'Pansion za ku' + #263 + 'ne ljubimce';

  lblProd1L.Text := 'POKSI d.o.o';      lblProd1R.Text := 'PIB: 109876543';
  lblProd2L.Text := 'Kralja Petra 12, Kragujevac'; lblProd2R.Text := 'MB: 21567890';

  lblKup1L.Text := LoggedUsername;      lblKup1R.Text := 'ID: ' + LoggedUserId.ToString;
  lblKup2L.Text := LoggedUserEmail;     lblKup2R.Text := LoggedUserPhone;

  Lvls[0]:=lblS1L; Lvls[1]:=lblS2L; Lvls[2]:=lblS3L; Lvls[3]:=lblS4L;
  Rvls[0]:=lblS1R; Rvls[1]:=lblS2R; Rvls[2]:=lblS3R; Rvls[3]:=lblS4R;
  for i := 0 to 3 do begin Lvls[i].Text := ''; Rvls[i].Text := ''; end;

  if nadjen then
  begin
    if G.LjubimacIme <> '' then
      Lvls[0].Text := 'Ljubimac: ' + G.LjubimacIme + ' (' + G.LjubimacBreed + ')'
    else
      Lvls[0].Text := 'Ljubimac: -';
    Rvls[0].Text := G.BoksText;

    Lvls[1].Text := 'Sme' + #353 + 'taj + obroci (' + G.Noci.ToString + ' no' + #263 + 'i)';
    Rvls[1].Text := '$' + FormatFloat('0.00', G.Smestaj);

    r := 2;
    for i := 0 to High(G.Stavke) do
    begin
      if r > 3 then Break;
      Lvls[r].Text := G.Stavke[i].Naziv + ' (x' + G.Stavke[i].Kolicina.ToString + ')';
      Rvls[r].Text := '$' + FormatFloat('0.00', G.Stavke[i].Cena);
      Inc(r);
    end;

    lblMedjutimT.Text := 'Me' + #273 + 'uzbir';
    lblMedjutimV.Text := '$' + FormatFloat('0.00', G.Smestaj + G.UslugeIznos);
    lblPopustT.Text := 'Popust';
    if G.Popust > 0 then
      lblPopustV.Text := '-$' + FormatFloat('0.00', G.Popust)
    else
      lblPopustV.Text := '$0.00';
    lblPDVT.Text := 'PDV (10%)';
    lblPDVV.Text := '$' + FormatFloat('0.00', G.Porez);
    lblUkupnoT.Text := 'UKUPNO';
    lblUkupnoV.Text := '$' + FormatFloat('0.00', G.Ukupno);

    lblNacinV.Text := G.Metoda;
  end
  else
  begin
    lblMedjutimT.Text := 'Me' + #273 + 'uzbir'; lblMedjutimV.Text := '$0.00';
    lblPopustT.Text := 'Popust'; lblPopustV.Text := '$0.00';
    lblPDVT.Text := 'PDV (10%)'; lblPDVV.Text := '$0.00';
    lblUkupnoT.Text := 'UKUPNO'; lblUkupnoV.Text := '$0.00';
    lblNacinV.Text := TfraPlacanje_OdabranaMetoda;
  end;

  lblStatusT.Text := 'Status';
  lblStatusV.Text := 'PLA' + #262 + 'ENO';

  if nadjen then
    lblQRSub.Text := 'POK QR - ' + G.BrojRacuna
  else
    lblQRSub.Text := '';
end;

procedure TfraFiskalniRacun.Loaded;
begin
  inherited;
  Popuni;
end;

procedure TfraFiskalniRacun.FrameEnter(Sender: TObject);
begin
  Popuni;
end;

procedure TfraFiskalniRacun.btnNazadClick(Sender: TObject);
begin
  TNavFrames.Back;
end;

procedure TfraFiskalniRacun.btnPregledajClick(Sender: TObject);
begin
  KorpaOcisti;
  TNavFrames.Go(TFrame5.Create(nil));
end;

procedure TfraFiskalniRacun.btnPreuzmiClick(Sender: TObject);
begin
  ShowMessage('Ra' + #269 + 'un preuzet (PDF).');
end;

procedure TfraFiskalniRacun.btnPosaljeClick(Sender: TObject);
begin
  ShowMessage('Ra' + #269 + 'un poslat na ' + LoggedUserEmail);
end;

procedure TfraFiskalniRacun.btnPodeliClick(Sender: TObject);
begin
  ShowMessage('Deljenje ra' + #269 + 'una...');
end;

end.

unit fraKorpa;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Layouts, FMX.Objects, FMX.ScrollBox, FMX.Memo, FMX.Edit, FMX.ListBox,
  FMX.Controls.Presentation;

type
  TfraKorpa = class(TFrame)
    // Root layout
    layoutRoot: TLayout;

    // Header
    layoutHeader: TLayout;
    lblTitle: TLabel;
    lblStavke: TLabel;

    // Scroll area
    vertScroll: TVertScrollBox;

    // --- SMESTAJ SEKCIJA ---
    lblSmestaj: TLabel;
    rectSmestaj: TRectangle;
    lblSmestajNaziv: TLabel;
    lblSmestajDatum: TLabel;
    lblSmestajCena: TLabel;

    // --- USLUGE SEKCIJA ---
    lblUsluge: TLabel;

    // Hrana item
    rectHrana: TRectangle;
    lblHranaNaziv: TLabel;
    lblHranaOpis: TLabel;
    lblHranaCena: TLabel;
    layoutHranaSteper: TLayout;
    btnHranaMinus: TButton;
    lblHranaKolicina: TLabel;
    btnHranaPlus: TButton;

    // Kupanje item
    rectKupanje: TRectangle;
    lblKupanjeNaziv: TLabel;
    lblKupanjeCena: TLabel;
    layoutKupanjeSteper: TLayout;
    btnKupanjeMinus: TButton;
    lblKupanjeKolicina: TLabel;
    btnKupanjePlus: TButton;

    // Veterinar item
    rectVeterinar: TRectangle;
    lblVeterinarNaziv: TLabel;
    lblVeterinarCena: TLabel;
    layoutVeterinarSteper: TLayout;
    btnVeterinarMinus: TButton;
    lblVeterinarKolicina: TLabel;
    btnVeterinarPlus: TButton;

    // --- PROMO KOD ---
    lblPromoKod: TLabel;
    rectPromo: TRectangle;
    editPromo: TEdit;
    lblPromoPopust: TLabel;

    // --- PREGLED IZNOSA ---
    lblPregledIznosa: TLabel;
    layoutMedjutim: TLayout;
    lblMedjutimText: TLabel;
    lblMedjutimVal: TLabel;
    layoutPopust: TLayout;
    lblPopustText: TLabel;
    lblPopustVal: TLabel;
    layoutPorez: TLayout;
    lblPorezText: TLabel;
    lblPorezVal: TLabel;
    layoutUkupno: TLayout;
    lblUkupnoText: TLabel;
    lblUkupnoVal: TLabel;

    // --- SOBE I LJUBIMCI ---
    layoutSobeLjubimciHeader: TLayout;
    lblSobeLjubimci: TLabel;
    lblSobePromeni: TLabel;
    rectBoks: TRectangle;
    lblBoksText: TLabel;
    lblBoksArrow: TLabel;
    rectLjubimci: TRectangle;
    lblLjubimciText: TLabel;
    lblLjubimciArrow: TLabel;

    // --- PLACANJE ---
    layoutPlacanjeHeader: TLayout;
    lblPlacanje: TLabel;
    lblPlacanjePromeni: TLabel;
    rectMastercard: TRectangle;
    lblMastercardText: TLabel;
    rectVisa: TRectangle;
    lblVisaText: TLabel;

    // --- FOOTER BUTTON ---
    layoutFooter: TLayout;
    btnNastavi: TButton;

  private
    procedure SetupUI;
    procedure SetupHeader;
    procedure SetupSmestaj;
    procedure SetupUsluge;
    procedure SetupPromoKod;
    procedure SetupPregledIznosa;
    procedure SetupSobeLjubimci;
    procedure SetupPlacanje;
    procedure SetupFooter;
    procedure StyleRect(ARect: TRectangle; ARadius: Single; AFillColor: TAlphaColor; ABorderColor: TAlphaColor);
    procedure StyleLabel(ALabel: TLabel; AText: string; AFontSize: Single; ABold: Boolean; AColor: TAlphaColor);
  public
    constructor Create(AOwner: TComponent); override;
  end;

implementation

{$R *.fmx}

constructor TfraKorpa.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  SetupUI;
end;

procedure TfraKorpa.StyleRect(ARect: TRectangle; ARadius: Single; AFillColor: TAlphaColor; ABorderColor: TAlphaColor);
begin
  ARect.XRadius := ARadius;
  ARect.YRadius := ARadius;
  ARect.Fill.Color := AFillColor;
  if ABorderColor = TAlphaColors.Null then
    ARect.Stroke.Kind := TBrushKind.None
  else
  begin
    ARect.Stroke.Kind := TBrushKind.Solid;
    ARect.Stroke.Color := ABorderColor;
    ARect.Stroke.Thickness := 1;
  end;
end;

procedure TfraKorpa.StyleLabel(ALabel: TLabel; AText: string; AFontSize: Single; ABold: Boolean; AColor: TAlphaColor);
begin
  ALabel.Text := AText;
  ALabel.Font.Size := AFontSize;
  if ABold then
    ALabel.Font.Style := [TFontStyle.fsBold]
  else
    ALabel.Font.Style := [];
  ALabel.FontColor := AColor;
  ALabel.AutoSize := True;
end;

procedure TfraKorpa.SetupUI;
begin
  // Frame size
  Self.Width := 390;
  Self.Height := 844;

  // Root layout
  layoutRoot := TLayout.Create(Self);
  layoutRoot.Parent := Self;
  layoutRoot.Align := TAlignLayout.Client;

  SetupHeader;
  SetupSmestaj;
  SetupUsluge;
  SetupPromoKod;
  SetupPregledIznosa;
  SetupSobeLjubimci;
  SetupPlacanje;
  SetupFooter;
end;

procedure TfraKorpa.SetupHeader;
begin
  layoutHeader := TLayout.Create(Self);
  layoutHeader.Parent := layoutRoot;
  layoutHeader.Align := TAlignLayout.Top;
  layoutHeader.Height := 60;
  layoutHeader.Padding.Left := 16;
  layoutHeader.Padding.Right := 16;
  layoutHeader.Padding.Top := 12;

  lblTitle := TLabel.Create(Self);
  lblTitle.Parent := layoutHeader;
  lblTitle.Align := TAlignLayout.Left;
  StyleLabel(lblTitle, 'Korpa', 22, True, TAlphaColors.Black);

  lblStavke := TLabel.Create(Self);
  lblStavke.Parent := layoutHeader;
  lblStavke.Align := TAlignLayout.Right;
  StyleLabel(lblStavke, '2 stavke', 14, False, $FFFFC107);

  // Scroll box - postavljen ispod headera, iznad footera
  vertScroll := TVertScrollBox.Create(Self);
  vertScroll.Parent := layoutRoot;
  vertScroll.Align := TAlignLayout.Client;
  vertScroll.Padding.Left := 16;
  vertScroll.Padding.Right := 16;
  vertScroll.Padding.Bottom := 8;
  vertScroll.ShowScrollBars := False;
end;

procedure TfraKorpa.SetupSmestaj;
begin
  lblSmestaj := TLabel.Create(Self);
  lblSmestaj.Parent := vertScroll;
  lblSmestaj.Align := TAlignLayout.Top;
  lblSmestaj.Height := 32;
  lblSmestaj.Margins.Top := 8;
  StyleLabel(lblSmestaj, 'Smeštaj', 16, True, TAlphaColors.Black);

  rectSmestaj := TRectangle.Create(Self);
  rectSmestaj.Parent := vertScroll;
  rectSmestaj.Align := TAlignLayout.Top;
  rectSmestaj.Height := 72;
  rectSmestaj.Margins.Top := 4;
  rectSmestaj.Margins.Bottom := 4;
  StyleRect(rectSmestaj, 12, TAlphaColors.White, $FFE0E0E0);

  lblSmestajNaziv := TLabel.Create(Self);
  lblSmestajNaziv.Parent := rectSmestaj;
  lblSmestajNaziv.Position.X := 56;
  lblSmestajNaziv.Position.Y := 10;
  lblSmestajNaziv.Width := 220;
  StyleLabel(lblSmestajNaziv, 'Unutrašnji boks P7', 14, True, TAlphaColors.Black);

  lblSmestajDatum := TLabel.Create(Self);
  lblSmestajDatum.Parent := rectSmestaj;
  lblSmestajDatum.Position.X := 56;
  lblSmestajDatum.Position.Y := 32;
  lblSmestajDatum.Width := 220;
  StyleLabel(lblSmestajDatum, '25/12/2021 — 27/12/2021 · 2 noći', 11, False, $FF888888);

  lblSmestajCena := TLabel.Create(Self);
  lblSmestajCena.Parent := rectSmestaj;
  lblSmestajCena.Position.X := 310;
  lblSmestajCena.Position.Y := 10;
  lblSmestajCena.Width := 60;
  StyleLabel(lblSmestajCena, '$80', 14, True, TAlphaColors.Black);
end;

procedure TfraKorpa.SetupUsluge;

  procedure MakeUslugeItem(var ARect: TRectangle; var ALblNaziv, ALblCena: TLabel;
    var ALayout: TLayout; var ABtnMinus: TButton; var ALblKol: TLabel; var ABtnPlus: TButton;
    ANaziv, ACena: string; ATopMargin: Single);
  begin
    ARect := TRectangle.Create(Self);
    ARect.Parent := vertScroll;
    ARect.Align := TAlignLayout.Top;
    ARect.Height := 68;
    ARect.Margins.Top := ATopMargin;
    ARect.Margins.Bottom := 4;
    StyleRect(ARect, 12, TAlphaColors.White, $FFE0E0E0);

    ALblNaziv := TLabel.Create(Self);
    ALblNaziv.Parent := ARect;
    ALblNaziv.Position.X := 56;
    ALblNaziv.Position.Y := 10;
    ALblNaziv.Width := 180;
    StyleLabel(ALblNaziv, ANaziv, 13, True, TAlphaColors.Black);

    ALblCena := TLabel.Create(Self);
    ALblCena.Parent := ARect;
    ALblCena.Position.X := 310;
    ALblCena.Position.Y := 10;
    ALblCena.Width := 50;
    StyleLabel(ALblCena, ACena, 13, True, TAlphaColors.Black);

    // Stepper
    ALayout := TLayout.Create(Self);
    ALayout.Parent := ARect;
    ALayout.Position.X := 56;
    ALayout.Position.Y := 36;
    ALayout.Width := 90;
    ALayout.Height := 28;

    ABtnMinus := TButton.Create(Self);
    ABtnMinus.Parent := ALayout;
    ABtnMinus.Align := TAlignLayout.Left;
    ABtnMinus.Width := 28;
    ABtnMinus.Height := 28;
    ABtnMinus.Text := '−';
    ABtnMinus.StyleLookup := 'buttonstyle';

    ALblKol := TLabel.Create(Self);
    ALblKol.Parent := ALayout;
    ALblKol.Align := TAlignLayout.Client;
    ALblKol.Text := '1';
    ALblKol.TextSettings.HorzAlign := TTextAlign.Center;
    ALblKol.Font.Size := 13;

    ABtnPlus := TButton.Create(Self);
    ABtnPlus.Parent := ALayout;
    ABtnPlus.Align := TAlignLayout.Right;
    ABtnPlus.Width := 28;
    ABtnPlus.Height := 28;
    ABtnPlus.Text := '+';
  end;

begin
  lblUsluge := TLabel.Create(Self);
  lblUsluge.Parent := vertScroll;
  lblUsluge.Align := TAlignLayout.Top;
  lblUsluge.Height := 32;
  lblUsluge.Margins.Top := 12;
  StyleLabel(lblUsluge, 'Usluge', 16, True, TAlphaColors.Black);

  MakeUslugeItem(rectHrana, lblHranaNaziv, lblHranaCena,
    layoutHranaSteper, btnHranaMinus, lblHranaKolicina, btnHranaPlus,
    'Hrana — Junior granule', '$48', 4);
  lblHranaKolicina.Text := '4';

  MakeUslugeItem(rectKupanje, lblKupanjeNaziv, lblKupanjeCena,
    layoutKupanjeSteper, btnKupanjeMinus, lblKupanjeKolicina, btnKupanjePlus,
    'Kupanje i nega', '$34', 4);

  MakeUslugeItem(rectVeterinar, lblVeterinarNaziv, lblVeterinarCena,
    layoutVeterinarSteper, btnVeterinarMinus, lblVeterinarKolicina, btnVeterinarPlus,
    'Veterinarski pregled', '$40', 4);
end;

procedure TfraKorpa.SetupPromoKod;
begin
  lblPromoKod := TLabel.Create(Self);
  lblPromoKod.Parent := vertScroll;
  lblPromoKod.Align := TAlignLayout.Top;
  lblPromoKod.Height := 32;
  lblPromoKod.Margins.Top := 12;
  StyleLabel(lblPromoKod, 'Promo kod', 16, True, TAlphaColors.Black);

  rectPromo := TRectangle.Create(Self);
  rectPromo.Parent := vertScroll;
  rectPromo.Align := TAlignLayout.Top;
  rectPromo.Height := 48;
  rectPromo.Margins.Top := 4;
  StyleRect(rectPromo, 10, TAlphaColors.White, $FFE0E0E0);

  editPromo := TEdit.Create(Self);
  editPromo.Parent := rectPromo;
  editPromo.Align := TAlignLayout.Client;
  editPromo.Margins.Left := 12;
  editPromo.Text := 'POKSI20';
  editPromo.Font.Size := 14;
  editPromo.StyleLookup := 'editstyle';

  lblPromoPopust := TLabel.Create(Self);
  lblPromoPopust.Parent := rectPromo;
  lblPromoPopust.Align := TAlignLayout.Right;
  lblPromoPopust.Width := 50;
  lblPromoPopust.Margins.Right := 12;
  StyleLabel(lblPromoPopust, '-20%', 13, True, $FF4CAF50);
end;

procedure TfraKorpa.SetupPregledIznosa;

  procedure MakeRow(var ALayout: TLayout; var ALblText, ALblVal: TLabel;
    AText, AVal: string; AValColor: TAlphaColor; ATopMargin: Single);
  begin
    ALayout := TLayout.Create(Self);
    ALayout.Parent := vertScroll;
    ALayout.Align := TAlignLayout.Top;
    ALayout.Height := 26;
    ALayout.Margins.Top := ATopMargin;

    ALblText := TLabel.Create(Self);
    ALblText.Parent := ALayout;
    ALblText.Align := TAlignLayout.Left;
    StyleLabel(ALblText, AText, 13, False, $FF555555);

    ALblVal := TLabel.Create(Self);
    ALblVal.Parent := ALayout;
    ALblVal.Align := TAlignLayout.Right;
    StyleLabel(ALblVal, AVal, 13, AValColor = $FFFFC107, AValColor);
  end;

begin
  lblPregledIznosa := TLabel.Create(Self);
  lblPregledIznosa.Parent := vertScroll;
  lblPregledIznosa.Align := TAlignLayout.Top;
  lblPregledIznosa.Height := 32;
  lblPregledIznosa.Margins.Top := 12;
  StyleLabel(lblPregledIznosa, 'Pregled iznosa', 16, True, TAlphaColors.Black);

  MakeRow(layoutMedjutim, lblMedjutimText, lblMedjutimVal,
    'Međutim', '$202.00', $FF333333, 4);
  MakeRow(layoutPopust, lblPopustText, lblPopustVal,
    'Popust (POKSI20)', '-$40.40', $FFE53935, 2);
  MakeRow(layoutPorez, lblPorezText, lblPorezVal,
    'Porez (10%)', '$16.16', $FF333333, 2);
  MakeRow(layoutUkupno, lblUkupnoText, lblUkupnoVal,
    'Ukupno', '$177.76', $FFFFC107, 4);
  lblUkupnoText.Font.Style := [TFontStyle.fsBold];
  lblUkupnoVal.Font.Style := [TFontStyle.fsBold];
  lblUkupnoVal.Font.Size := 15;
end;

procedure TfraKorpa.SetupSobeLjubimci;

  procedure MakeArrowItem(var ARect: TRectangle; var ALblText, ALblArrow: TLabel;
    AText: string; ATopMargin: Single);
  begin
    ARect := TRectangle.Create(Self);
    ARect.Parent := vertScroll;
    ARect.Align := TAlignLayout.Top;
    ARect.Height := 50;
    ARect.Margins.Top := ATopMargin;
    ARect.Margins.Bottom := 2;
    StyleRect(ARect, 10, TAlphaColors.White, $FFE0E0E0);

    ALblText := TLabel.Create(Self);
    ALblText.Parent := ARect;
    ALblText.Align := TAlignLayout.Left;
    ALblText.Margins.Left := 16;
    StyleLabel(ALblText, AText, 14, False, TAlphaColors.Black);

    ALblArrow := TLabel.Create(Self);
    ALblArrow.Parent := ARect;
    ALblArrow.Align := TAlignLayout.Right;
    ALblArrow.Margins.Right := 16;
    StyleLabel(ALblArrow, '›', 20, False, $FF888888);
  end;

begin
  layoutSobeLjubimciHeader := TLayout.Create(Self);
  layoutSobeLjubimciHeader.Parent := vertScroll;
  layoutSobeLjubimciHeader.Align := TAlignLayout.Top;
  layoutSobeLjubimciHeader.Height := 36;
  layoutSobeLjubimciHeader.Margins.Top := 14;

  lblSobeLjubimci := TLabel.Create(Self);
  lblSobeLjubimci.Parent := layoutSobeLjubimciHeader;
  lblSobeLjubimci.Align := TAlignLayout.Left;
  StyleLabel(lblSobeLjubimci, 'Sobe i ljubimci', 16, True, TAlphaColors.Black);

  lblSobePromeni := TLabel.Create(Self);
  lblSobePromeni.Parent := layoutSobeLjubimciHeader;
  lblSobePromeni.Align := TAlignLayout.Right;
  StyleLabel(lblSobePromeni, 'Promeni', 13, False, $FFFFC107);

  MakeArrowItem(rectBoks, lblBoksText, lblBoksArrow, 'Boks', 4);
  MakeArrowItem(rectLjubimci, lblLjubimciText, lblLjubimciArrow, 'Ljubimci', 4);
end;

procedure TfraKorpa.SetupPlacanje;

  procedure MakePayItem(var ARect: TRectangle; var ALblText: TLabel;
    AText: string; ATopMargin: Single);
  begin
    ARect := TRectangle.Create(Self);
    ARect.Parent := vertScroll;
    ARect.Align := TAlignLayout.Top;
    ARect.Height := 50;
    ARect.Margins.Top := ATopMargin;
    ARect.Margins.Bottom := 2;
    StyleRect(ARect, 10, TAlphaColors.White, $FFE0E0E0);

    ALblText := TLabel.Create(Self);
    ALblText.Parent := ARect;
    ALblText.Align := TAlignLayout.Left;
    ALblText.Margins.Left := 52;
    StyleLabel(ALblText, AText, 14, False, TAlphaColors.Black);
  end;

begin
  layoutPlacanjeHeader := TLayout.Create(Self);
  layoutPlacanjeHeader.Parent := vertScroll;
  layoutPlacanjeHeader.Align := TAlignLayout.Top;
  layoutPlacanjeHeader.Height := 36;
  layoutPlacanjeHeader.Margins.Top := 14;

  lblPlacanje := TLabel.Create(Self);
  lblPlacanje.Parent := layoutPlacanjeHeader;
  lblPlacanje.Align := TAlignLayout.Left;
  StyleLabel(lblPlacanje, 'Kacenje', 16, True, TAlphaColors.Black);

  lblPlacanjePromeni := TLabel.Create(Self);
  lblPlacanjePromeni.Parent := layoutPlacanjeHeader;
  lblPlacanjePromeni.Align := TAlignLayout.Right;
  StyleLabel(lblPlacanjePromeni, 'Promeni', 13, False, $FFFFC107);

  MakePayItem(rectMastercard, lblMastercardText, 'Master Card', 4);
  MakePayItem(rectVisa, lblVisaText, 'Visa', 4);

  // Mala prazna oblast na dnu scroll-a
  with TLayout.Create(Self) do
  begin
    Parent := vertScroll;
    Align := TAlignLayout.Top;
    Height := 16;
  end;
end;

procedure TfraKorpa.SetupFooter;
begin
  layoutFooter := TLayout.Create(Self);
  layoutFooter.Parent := layoutRoot;
  layoutFooter.Align := TAlignLayout.Bottom;
  layoutFooter.Height := 80;
  layoutFooter.Padding.Left := 16;
  layoutFooter.Padding.Right := 16;
  layoutFooter.Padding.Top := 12;
  layoutFooter.Padding.Bottom := 16;

  btnNastavi := TButton.Create(Self);
  btnNastavi.Parent := layoutFooter;
  btnNastavi.Align := TAlignLayout.Client;
  btnNastavi.Text := 'Nastavi na plaćanje';
  btnNastavi.Font.Size := 16;
  btnNastavi.Font.Style := [TFontStyle.fsBold];
  btnNastavi.StyleLookup := 'buttonstyle';

  // Tamna pozadina dugmeta
  with TRectangle.Create(Self) do
  begin
    Parent := layoutFooter;
    Align := TAlignLayout.Client;
    XRadius := 12;
    YRadius := 12;
    Fill.Color := $FF1C1C2E;
    Stroke.Kind := TBrushKind.None;
    HitTest := False;
    BringToFront;
  end;

  btnNastavi.BringToFront;
  btnNastavi.FontColor := TAlphaColors.White;
end;

end.

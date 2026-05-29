unit fraKorpa;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Layouts, FMX.Objects, FMX.ScrollBox, FMX.Edit,
  FMX.Controls.Presentation, uKorpa, uNavFrames;

type
  TfraKorpa = class(TFrame)
    procedure FrameEnter(Sender: TObject);
    procedure btnNastaviClick(Sender: TObject);
    procedure btnBackClick(Sender: TObject);
    procedure editPromoChange(Sender: TObject);
    procedure btnMinusClick(Sender: TObject);
    procedure btnPlusClick(Sender: TObject);
  private
    FVertScroll:     TVertScrollBox;
    FLblStavke:      TLabel;
    FEditPromo:      TEdit;
    FLblPromoPopust: TLabel;
    FLblMedjutim:    TLabel;
    FLblPopust:      TLabel;
    FLblPorez:       TLabel;
    FLblUkupno:      TLabel;

    FRowRect:  array[0..5] of TRectangle;
    FRowNaz:   array[0..5] of TLabel;
    FRowCena:  array[0..5] of TLabel;
    FRowKol:   array[0..5] of TLabel;
    FRowBtnM:  array[0..5] of TButton;
    FRowBtnP:  array[0..5] of TButton;

    procedure BuildUI;
    procedure BuildRow(AIdx: Integer);
    procedure RefreshKorpa;
    procedure RefreshIznosi;
  public
    constructor Create(AOwner: TComponent); override;
  end;

implementation

{$R *.fmx}

uses
  fraRezervacija;

// ── Helpers ───────────────────────────────────────────────────────────────────

function NewLabel(AParent: TFmxObject; const ATxt: string;
  ASz: Single; ABold: Boolean; AClr: TAlphaColor): TLabel;
begin
  Result := TLabel.Create(AParent);
  Result.Parent := AParent;
  Result.Text := ATxt;
  Result.Font.Size := ASz;
  if ABold then
    Result.Font.Style := [TFontStyle.fsBold]
  else
    Result.Font.Style := [];
  Result.FontColor := AClr;
  Result.AutoSize := True;
end;

function NewRect(AParent: TFmxObject; AH, ATop: Single): TRectangle;
begin
  Result := TRectangle.Create(AParent);
  Result.Parent := AParent;
  Result.Align := TAlignLayout.Top;
  Result.Height := AH;
  Result.Margins.Top := ATop;
  Result.Margins.Bottom := 4;
  Result.XRadius := 12;
  Result.YRadius := 12;
  Result.Fill.Color := TAlphaColors.White;
  Result.Stroke.Kind := TBrushKind.Solid;
  Result.Stroke.Color := $FFE0E0E0;
  Result.Stroke.Thickness := 1;
end;

function NewLayout(AParent: TFmxObject; AW, AH: Single): TLayout;
begin
  Result := TLayout.Create(AParent);
  Result.Parent := AParent;
  Result.Width := AW;
  Result.Height := AH;
end;

// ── BuildRow ──────────────────────────────────────────────────────────────────

procedure TfraKorpa.BuildRow(AIdx: Integer);
var
  R: TRectangle;
  Lay: TLayout;
  BM, BP: TButton;
  LN, LC, LK: TLabel;
begin
  R := NewRect(FVertScroll, 68, 4);
  R.Visible := False;

  LN := NewLabel(R, '', 14, True, TAlphaColors.Black);
  LN.Position.X := 12;
  LN.Position.Y := 8;
  LN.Width := 210;
  LN.AutoSize := False;

  LC := NewLabel(R, '', 13, True, $FFFFC107);
  LC.Position.X := 290;
  LC.Position.Y := 8;
  LC.Width := 60;
  LC.AutoSize := False;
  LC.TextSettings.HorzAlign := TTextAlign.Trailing;

  Lay := NewLayout(R, 90, 28);
  Lay.Position.X := 12;
  Lay.Position.Y := 34;

  BM := TButton.Create(R);
  BM.Parent := Lay;
  BM.Align := TAlignLayout.Left;
  BM.Width := 28;
  BM.Text := '-';
  BM.Tag := AIdx;
  BM.OnClick := btnMinusClick;

  LK := TLabel.Create(R);
  LK.Parent := Lay;
  LK.Align := TAlignLayout.Client;
  LK.Text := '1';
  LK.TextSettings.HorzAlign := TTextAlign.Center;
  LK.Font.Size := 13;

  BP := TButton.Create(R);
  BP.Parent := Lay;
  BP.Align := TAlignLayout.Right;
  BP.Width := 28;
  BP.Text := '+';
  BP.Tag := AIdx;
  BP.OnClick := btnPlusClick;

  FRowRect[AIdx] := R;
  FRowNaz[AIdx]  := LN;
  FRowCena[AIdx] := LC;
  FRowKol[AIdx]  := LK;
  FRowBtnM[AIdx] := BM;
  FRowBtnP[AIdx] := BP;
end;

// ── BuildUI ───────────────────────────────────────────────────────────────────

procedure TfraKorpa.BuildUI;
var
  Root, LayH, LayFoot, LayRow: TLayout;
  LH: TLabel;
  RPromo: TRectangle;
  BtnNastavi, BtnBack: TButton;
  i: Integer;
begin
  Self.Width  := 390;
  Self.Height := 844;

  Root := TLayout.Create(Self);
  Root.Parent := Self;
  Root.Align := TAlignLayout.Client;

  // ── Header ──
  LayH := NewLayout(Root, 390, 60);
  LayH.Align := TAlignLayout.Top;
  LayH.Padding.Left  := 16;
  LayH.Padding.Right := 16;
  LayH.Padding.Top   := 12;

  // Back dugme
  BtnBack := TButton.Create(Self);
  BtnBack.Parent := LayH;
  BtnBack.Align := TAlignLayout.Left;
  BtnBack.Width := 40;
  BtnBack.Text := #8592;
  BtnBack.Font.Size := 18;
  BtnBack.OnClick := btnBackClick;

  // Naslov
  LH := NewLabel(LayH, 'Korpa', 22, True, TAlphaColors.Black);
  LH.Align := TAlignLayout.Client;

  // Broj stavki (desno, zuto)
  FLblStavke := NewLabel(LayH, '0 stavki', 14, False, $FFFFC107);
  FLblStavke.Align := TAlignLayout.Right;
  FLblStavke.AutoSize := False;
  FLblStavke.Width := 70;
  FLblStavke.TextSettings.HorzAlign := TTextAlign.Trailing;

  // ── Footer ──
  LayFoot := NewLayout(Root, 390, 80);
  LayFoot.Align := TAlignLayout.Bottom;
  LayFoot.Padding.Left   := 16;
  LayFoot.Padding.Right  := 16;
  LayFoot.Padding.Top    := 12;
  LayFoot.Padding.Bottom := 16;

  BtnNastavi := TButton.Create(Self);
  BtnNastavi.Parent := LayFoot;
  BtnNastavi.Align := TAlignLayout.Client;
  BtnNastavi.Text := 'Nastavi na pla' + #263 + 'anje';
  BtnNastavi.Font.Size := 16;
  BtnNastavi.Font.Style := [TFontStyle.fsBold];
  BtnNastavi.FontColor := TAlphaColors.White;
  BtnNastavi.OnClick := btnNastaviClick;

  // ── Scroll ──
  FVertScroll := TVertScrollBox.Create(Self);
  FVertScroll.Parent := Root;
  FVertScroll.Align := TAlignLayout.Client;
  FVertScroll.Padding.Left   := 16;
  FVertScroll.Padding.Right  := 16;
  FVertScroll.Padding.Bottom := 8;
  FVertScroll.ShowScrollBars := False;

  // Smestaj header
  LH := NewLabel(FVertScroll, 'Sme' + #353 + 'taj', 16, True, TAlphaColors.Black);
  LH.Align := TAlignLayout.Top;
  LH.Height := 32;
  LH.Margins.Top := 8;
  LH.AutoSize := False;

  // Usluge header
  LH := NewLabel(FVertScroll, 'Usluge', 16, True, TAlphaColors.Black);
  LH.Align := TAlignLayout.Top;
  LH.Height := 32;
  LH.Margins.Top := 12;
  LH.AutoSize := False;

  // Dinamicki redovi za usluge
  for i := 0 to 5 do
    BuildRow(i);

  // Promo kod
  LH := NewLabel(FVertScroll, 'Promo kod', 16, True, TAlphaColors.Black);
  LH.Align := TAlignLayout.Top;
  LH.Height := 32;
  LH.Margins.Top := 12;
  LH.AutoSize := False;

  RPromo := NewRect(FVertScroll, 48, 4);
  RPromo.XRadius := 10;
  RPromo.YRadius := 10;

  FEditPromo := TEdit.Create(Self);
  FEditPromo.Parent := RPromo;
  FEditPromo.Align := TAlignLayout.Client;
  FEditPromo.Margins.Left := 12;
  FEditPromo.Margins.Right := 70;
  FEditPromo.Font.Size := 14;
  FEditPromo.OnChange := editPromoChange;

  FLblPromoPopust := NewLabel(RPromo, '', 13, True, $FF4CAF50);
  FLblPromoPopust.Align := TAlignLayout.Right;
  FLblPromoPopust.Width := 60;
  FLblPromoPopust.AutoSize := False;
  FLblPromoPopust.Margins.Right := 12;
  FLblPromoPopust.TextSettings.HorzAlign := TTextAlign.Trailing;
  FLblPromoPopust.TextSettings.VertAlign := TTextAlign.Center;

  // Pregled iznosa
  LH := NewLabel(FVertScroll, 'Pregled iznosa', 16, True, TAlphaColors.Black);
  LH.Align := TAlignLayout.Top;
  LH.Height := 32;
  LH.Margins.Top := 12;
  LH.AutoSize := False;

  LayRow := NewLayout(FVertScroll, 358, 26);
  LayRow.Align := TAlignLayout.Top;
  LayRow.Margins.Top := 3;
  NewLabel(LayRow, 'Me' + #273 + 'utim', 13, False, $FF555555).Align := TAlignLayout.Left;
  FLblMedjutim := NewLabel(LayRow, '$0.00', 13, False, $FF333333);
  FLblMedjutim.Align := TAlignLayout.Right;
  FLblMedjutim.TextSettings.HorzAlign := TTextAlign.Trailing;

  LayRow := NewLayout(FVertScroll, 358, 26);
  LayRow.Align := TAlignLayout.Top;
  LayRow.Margins.Top := 3;
  NewLabel(LayRow, 'Popust', 13, False, $FF555555).Align := TAlignLayout.Left;
  FLblPopust := NewLabel(LayRow, '$0.00', 13, False, $FFE53935);
  FLblPopust.Align := TAlignLayout.Right;
  FLblPopust.TextSettings.HorzAlign := TTextAlign.Trailing;

  LayRow := NewLayout(FVertScroll, 358, 26);
  LayRow.Align := TAlignLayout.Top;
  LayRow.Margins.Top := 3;
  NewLabel(LayRow, 'Porez (10%)', 13, False, $FF555555).Align := TAlignLayout.Left;
  FLblPorez := NewLabel(LayRow, '$0.00', 13, False, $FF333333);
  FLblPorez.Align := TAlignLayout.Right;
  FLblPorez.TextSettings.HorzAlign := TTextAlign.Trailing;

  LayRow := NewLayout(FVertScroll, 358, 26);
  LayRow.Align := TAlignLayout.Top;
  LayRow.Margins.Top := 5;
  LayRow.Margins.Bottom := 16;
  NewLabel(LayRow, 'Ukupno', 14, True, $FF333333).Align := TAlignLayout.Left;
  FLblUkupno := NewLabel(LayRow, '$0.00', 14, True, $FFFFC107);
  FLblUkupno.Align := TAlignLayout.Right;
  FLblUkupno.TextSettings.HorzAlign := TTextAlign.Trailing;
end;

constructor TfraKorpa.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  BuildUI;
  RefreshKorpa; // Odmah popuni kad se kreira
end;

// ── Refresh ───────────────────────────────────────────────────────────────────

procedure TfraKorpa.RefreshIznosi;
var
  Osnova, Popust, Porez, Ukupno: Double;
  n: Integer;
begin
  Osnova := KorpaUkupno;
  Popust := KorpaPopust(FEditPromo.Text);
  Porez  := (Osnova - Popust) * 0.10;
  Ukupno := Osnova - Popust + Porez;

  FLblMedjutim.Text := '$' + FormatFloat('0.00', Osnova);

  if Popust > 0 then
  begin
    FLblPopust.Text      := '-$' + FormatFloat('0.00', Popust);
    FLblPromoPopust.Text := '-' + FormatFloat('0', KorpaPopustProcent(FEditPromo.Text) * 100) + '%';
  end
  else
  begin
    FLblPopust.Text      := '$0.00';
    FLblPromoPopust.Text := '';
  end;

  FLblPorez.Text  := '$' + FormatFloat('0.00', Porez);
  FLblUkupno.Text := '$' + FormatFloat('0.00', Ukupno);

  n := KorpaBrojStavki;
  FLblStavke.Text := n.ToString + ' stavki';
end;

procedure TfraKorpa.RefreshKorpa;
var
  i, r, n: Integer;
begin
  n := KorpaBrojStavki;

  for i := 0 to 5 do
    FRowRect[i].Visible := False;

  r := 0;
  for i := 0 to High(KorpaItems) do
  begin
    if KorpaItems[i].ServiceId = 0 then Continue;
    if r > 5 then Break;
    FRowRect[r].Visible := True;
    FRowNaz[r].Text     := KorpaItems[i].Naziv;
    FRowCena[r].Text    := '$' + FormatFloat('0.##', KorpaItems[i].Cena);
    FRowKol[r].Text     := KorpaItems[i].Kolicina.ToString;
    FRowBtnM[r].Tag     := i;
    FRowBtnP[r].Tag     := i;
    Inc(r);
  end;

  RefreshIznosi;
end;

// ── Events ────────────────────────────────────────────────────────────────────

procedure TfraKorpa.FrameEnter(Sender: TObject);
begin
  RefreshKorpa;
end;

procedure TfraKorpa.editPromoChange(Sender: TObject);
begin
  RefreshIznosi;
end;

procedure TfraKorpa.btnMinusClick(Sender: TObject);
var
  idx: Integer;
begin
  idx := (Sender as TButton).Tag;
  if idx > High(KorpaItems) then Exit;
  KorpaSetKolicina(KorpaItems[idx].ServiceId, KorpaItems[idx].Kolicina - 1);
  RefreshKorpa;
end;

procedure TfraKorpa.btnPlusClick(Sender: TObject);
var
  idx: Integer;
begin
  idx := (Sender as TButton).Tag;
  if idx > High(KorpaItems) then Exit;
  KorpaSetKolicina(KorpaItems[idx].ServiceId, KorpaItems[idx].Kolicina + 1);
  RefreshKorpa;
end;

procedure TfraKorpa.btnNastaviClick(Sender: TObject);
begin
  if KorpaBrojStavki = 0 then
  begin
    ShowMessage('Korpa je prazna. Dodajte usluge.');
    Exit;
  end;
  TNavFrames.Go(TfraRezervacija.Create(nil));
end;

procedure TfraKorpa.btnBackClick(Sender: TObject);
begin
  TNavFrames.Back;
end;

end.

unit fraKalendar;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  System.DateUtils,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Layouts, FMX.Objects, FMX.Controls.Presentation,
  uNavFrames, uUserStore;

type
  TfraKalendar = class(TFrame)
    layoutRoot: TLayout;
    layoutHeader: TLayout;
    lblX: TButton;
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
    gridKalendar: TLayout;
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

    procedure lblXClick(Sender: TObject);
    procedure btnPrevMesecClick(Sender: TObject);
    procedure btnNextMesecClick(Sender: TObject);
    procedure Loaded; override;
    procedure FrameEnter(Sender: TObject);

  private
    FPrikazMesec: Integer;
    FPrikazGodina: Integer;
    FRects: array[1..31] of TRectangle;
    FLbls:  array[1..31] of TLabel;

    FCellRects: array of TRectangle;
    FCellLbls:  array of TLabel;
    FCellDan:   array of Integer;
    FDynBuilt:  Boolean;

    procedure MapirajKomponente;
    procedure HideDesignCells;
    procedure RefreshKalendar;
    procedure DanKlik(Sender: TObject);
    procedure StilDana(ARect: TRectangle; ALbl: TLabel; ASelektovan, AUOpsegu, AValidan: Boolean);
  public
  end;

implementation

{$R *.fmx}

uses
  fraRezervacija;

procedure TfraKalendar.MapirajKomponente;
var
  i: Integer;
  R: TRectangle;
  L: TLabel;
begin
  HideDesignCells;

  if FDynBuilt then Exit;
  SetLength(FCellRects, 42);
  SetLength(FCellLbls, 42);
  SetLength(FCellDan, 42);
  for i := 0 to 41 do
  begin
    R := TRectangle.Create(Self);
    R.Parent := gridKalendar;
    R.Position.X := 16 + (i mod 7) * 51;
    R.Position.Y := (i div 7) * 48;
    R.Width := 51;
    R.Height := 46;
    R.Fill.Kind := TBrushKind.None;
    R.Stroke.Kind := TBrushKind.None;
    R.HitTest := False;
    R.OnClick := DanKlik;

    L := TLabel.Create(Self);
    L.Parent := R;
    L.Align := TAlignLayout.Client;
    L.Font.Size := 14;
    L.TextSettings.HorzAlign := TTextAlign.Center;
    L.HitTest := False;
    L.Text := '';

    FCellRects[i] := R;
    FCellLbls[i]  := L;
    FCellDan[i]   := 0;
  end;
  FDynBuilt := True;
end;

procedure TfraKalendar.HideDesignCells;
var
  arr: array[1..31] of TRectangle;
  i: Integer;
begin
  arr[1]:=rectD1; arr[2]:=rectD2; arr[3]:=rectD3; arr[4]:=rectD4; arr[5]:=rectD5;
  arr[6]:=rectD6; arr[7]:=rectD7; arr[8]:=rectD8; arr[9]:=rectD9; arr[10]:=rectD10;
  arr[11]:=rectD11; arr[12]:=rectD12; arr[13]:=rectD13; arr[14]:=rectD14; arr[15]:=rectD15;
  arr[16]:=rectD16; arr[17]:=rectD17; arr[18]:=rectD18; arr[19]:=rectD19; arr[20]:=rectD20;
  arr[21]:=rectD21; arr[22]:=rectD22; arr[23]:=rectD23; arr[24]:=rectD24; arr[25]:=rectD25;
  arr[26]:=rectD26; arr[27]:=rectD27; arr[28]:=rectD28; arr[29]:=rectD29; arr[30]:=rectD30;
  arr[31]:=rectD31;
  for i := 1 to 31 do
    if Assigned(arr[i]) then
      arr[i].Visible := False;
end;

procedure TfraKalendar.StilDana(ARect: TRectangle; ALbl: TLabel;
  ASelektovan, AUOpsegu, AValidan: Boolean);
begin
  if not AValidan then
  begin
    ARect.Fill.Kind := TBrushKind.None;
    ALbl.Text := '';
    ARect.HitTest := False;
    Exit;
  end;
  ARect.HitTest := True;
  if ASelektovan then
  begin
    ARect.Fill.Kind := TBrushKind.Solid;
    ARect.Fill.Color := $FF1C1C2E;
    ARect.XRadius := 20; ARect.YRadius := 20;
    ALbl.FontColor := TAlphaColors.White;
    ALbl.Font.Style := [TFontStyle.fsBold];
  end
  else if AUOpsegu then
  begin
    ARect.Fill.Kind := TBrushKind.Solid;
    ARect.Fill.Color := $FFE8E8E8;
    ARect.XRadius := 0; ARect.YRadius := 0;
    ALbl.FontColor := $FF333333;
    ALbl.Font.Style := [];
  end
  else
  begin
    ARect.Fill.Kind := TBrushKind.None;
    ALbl.FontColor := $FF333333;
    ALbl.Font.Style := [];
  end;
end;

procedure TfraKalendar.RefreshKalendar;
var
  i, d, brDana, offset: Integer;
  prviDan: TDateTime;
  datum: TDateTime;
  sel, opseg: Boolean;
  mesnaziv: array[1..12] of string;
begin
  mesnaziv[1]:='Januar'; mesnaziv[2]:='Februar'; mesnaziv[3]:='Mart';
  mesnaziv[4]:='April'; mesnaziv[5]:='Maj'; mesnaziv[6]:='Jun';
  mesnaziv[7]:='Jul'; mesnaziv[8]:='Avgust'; mesnaziv[9]:='Septembar';
  mesnaziv[10]:='Oktobar'; mesnaziv[11]:='Novembar'; mesnaziv[12]:='Decembar';

  lblMesecGodina.Text := mesnaziv[FPrikazMesec] + ' ' + FPrikazGodina.ToString;
  brDana := DaysInAMonth(FPrikazGodina, FPrikazMesec);

  prviDan := EncodeDate(FPrikazGodina, FPrikazMesec, 1);
  offset := DayOfWeek(prviDan) - 1;

  for i := 0 to High(FCellRects) do
  begin
    FCellDan[i] := 0;
    FCellLbls[i].Text := '';
    FCellRects[i].Fill.Kind := TBrushKind.None;
    FCellRects[i].HitTest := False;
    FCellLbls[i].Font.Style := [];
  end;

  for d := 1 to brDana do
  begin
    i := offset + (d - 1);
    if i > High(FCellRects) then Break;
    FCellDan[i] := d;
    FCellLbls[i].Text := d.ToString;
    datum := EncodeDate(FPrikazGodina, FPrikazMesec, d);

    sel := ((KalendarDatumOd > 0) and (Trunc(datum) = Trunc(KalendarDatumOd))) or
           ((KalendarDatumDo > 0) and (Trunc(datum) = Trunc(KalendarDatumDo)));
    opseg := (KalendarDatumOd > 0) and (KalendarDatumDo > 0) and
             (datum > KalendarDatumOd) and (datum < KalendarDatumDo);

    StilDana(FCellRects[i], FCellLbls[i], sel, opseg, True);
    FCellRects[i].HitTest := True;
  end;

  if KalendarDatumOd > 0 then
    lblDolazakDatum.Text := FormatDateTime('dd/mm/yyyy', KalendarDatumOd)
  else
    lblDolazakDatum.Text := 'Dolazak';
  if KalendarDatumDo > 0 then
    lblOdlazakDatum.Text := FormatDateTime('dd/mm/yyyy', KalendarDatumDo)
  else
    lblOdlazakDatum.Text := 'Odlazak';
end;

procedure TfraKalendar.DanKlik(Sender: TObject);
var
  i, d: Integer;
  datum: TDateTime;
begin
  d := 0;
  for i := 0 to High(FCellRects) do
    if FCellRects[i] = Sender then
    begin
      d := FCellDan[i];
      Break;
    end;
  if d = 0 then Exit;
  datum := EncodeDate(FPrikazGodina, FPrikazMesec, d);

  if (KalendarDatumOd = 0) or (KalendarDatumDo > 0) then
  begin
    KalendarDatumOd := datum;
    KalendarDatumDo := 0;
  end
  else
  begin
    if datum < KalendarDatumOd then
    begin
      KalendarDatumDo := KalendarDatumOd;
      KalendarDatumOd := datum;
    end
    else
      KalendarDatumDo := datum;
  end;

  RefreshKalendar;

  if (KalendarDatumOd > 0) and (KalendarDatumDo > 0) then
    TNavFrames.Back;
end;

procedure TfraKalendar.Loaded;
begin
  inherited;
  MapirajKomponente;
  if KalendarDatumOd > 0 then
  begin
    FPrikazMesec := MonthOf(KalendarDatumOd);
    FPrikazGodina := YearOf(KalendarDatumOd);
  end
  else
  begin
    FPrikazMesec := MonthOf(Now);
    FPrikazGodina := YearOf(Now);
  end;
  RefreshKalendar;
end;

procedure TfraKalendar.FrameEnter(Sender: TObject);
begin
  RefreshKalendar;
end;

procedure TfraKalendar.lblXClick(Sender: TObject);
begin
  TNavFrames.Back;
end;

procedure TfraKalendar.btnPrevMesecClick(Sender: TObject);
begin
  Dec(FPrikazMesec);
  if FPrikazMesec < 1 then
  begin
    FPrikazMesec := 12;
    Dec(FPrikazGodina);
  end;
  RefreshKalendar;
end;

procedure TfraKalendar.btnNextMesecClick(Sender: TObject);
begin
  Inc(FPrikazMesec);
  if FPrikazMesec > 12 then
  begin
    FPrikazMesec := 1;
    Inc(FPrikazGodina);
  end;
  RefreshKalendar;
end;

end.

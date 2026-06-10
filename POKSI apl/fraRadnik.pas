unit fraRadnik;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Layouts, FMX.Objects, FMX.ScrollBox, FMX.Controls.Presentation,
  FireDAC.Comp.Client, uNavFrames, uUserStore;

type
  TfraRadnik = class(TFrame)
    layoutRoot: TLayout;
    layoutHeader: TLayout;
    btnNazad: TButton;
    lblTitle: TLabel;
    vertScroll: TVertScrollBox;

    procedure btnNazadClick(Sender: TObject);
    procedure FrameEnter(Sender: TObject);
    procedure RedRezervacijaClick(Sender: TObject);
  private
    FNextY: Single;
    procedure BuildUI;
    procedure OcistiIzvestaje;
    procedure RefreshIzvestaji;
    procedure PrikaziDetaljeRezervacije(ARezId: Integer);
    function  NovaSekcija(const ANaslov: string): TRectangle;
    procedure DodajRed(ABox: TRectangle; const ALevo, ADesno: string; ABold: Boolean);
    procedure DodajRed2(ABox: TRectangle; const AGlavni, ADetalj, ADesno: string;
      ARezId: Integer);
  public
    constructor Create(AOwner: TComponent); override;
  end;

implementation

{$R *.fmx}

constructor TfraRadnik.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  BuildUI;
  RefreshIzvestaji;
  Self.OnEnter := FrameEnter;
end;

procedure TfraRadnik.BuildUI;
begin
  Self.Width := 390;
  Self.Height := 844;

  layoutRoot := TLayout.Create(Self);
  layoutRoot.Parent := Self;
  layoutRoot.Align := TAlignLayout.Client;

  layoutHeader := TLayout.Create(Self);
  layoutHeader.Parent := layoutRoot;
  layoutHeader.Align := TAlignLayout.Top;
  layoutHeader.Height := 56;
  layoutHeader.Padding.Left := 16;
  layoutHeader.Padding.Right := 16;
  layoutHeader.Padding.Top := 12;

  btnNazad := TButton.Create(Self);
  btnNazad.Parent := layoutHeader;
  btnNazad.Align := TAlignLayout.Left;
  btnNazad.Width := 44;
  btnNazad.Height := 40;
  btnNazad.Text := #10094;
  btnNazad.OnClick := btnNazadClick;

  lblTitle := TLabel.Create(Self);
  lblTitle.Parent := layoutHeader;
  lblTitle.Align := TAlignLayout.Client;
  lblTitle.Text := 'Pregled prodaje';
  lblTitle.StyledSettings := lblTitle.StyledSettings -
    [TStyledSetting.Size, TStyledSetting.Style];
  lblTitle.Font.Size := 18;
  lblTitle.Font.Style := [TFontStyle.fsBold];
  lblTitle.TextSettings.HorzAlign := TTextAlign.Center;

  vertScroll := TVertScrollBox.Create(Self);
  vertScroll.Parent := layoutRoot;
  vertScroll.Align := TAlignLayout.Client;
  vertScroll.Padding.Bottom := 16;
end;

procedure TfraRadnik.OcistiIzvestaje;
var
  i: Integer;
begin
  for i := vertScroll.Content.ChildrenCount - 1 downto 0 do
    vertScroll.Content.Children[i].Free;
end;

function TfraRadnik.NovaSekcija(const ANaslov: string): TRectangle;
var
  T: TLabel;
begin
  T := TLabel.Create(Self);
  T.Parent := vertScroll;
  T.Position.Y := FNextY;
  T.Align := TAlignLayout.Top;
  T.Height := 28;
  T.Margins.Left := 16;
  T.Margins.Right := 16;
  T.Margins.Top := 10;
  T.Text := ANaslov;
  T.StyledSettings := T.StyledSettings - [TStyledSetting.Size, TStyledSetting.Style];
  T.Font.Size := 16;
  T.Font.Style := [TFontStyle.fsBold];
  FNextY := FNextY + 1;

  Result := TRectangle.Create(Self);
  Result.Parent := vertScroll;
  Result.Position.Y := FNextY;
  Result.Align := TAlignLayout.Top;
  Result.Height := 12;
  Result.Margins.Left := 16;
  Result.Margins.Right := 16;
  Result.Margins.Bottom := 4;
  Result.Padding.Top := 6;
  Result.Stroke.Color := $FFE3E3E6;
  Result.Fill.Color := $FFF7F7F8;
  Result.XRadius := 10;
  Result.YRadius := 10;
  FNextY := FNextY + 1;
end;

procedure TfraRadnik.DodajRed(ABox: TRectangle; const ALevo, ADesno: string;
  ABold: Boolean);
var
  Red: TLayout;
  L, D: TLabel;
begin
  Red := TLayout.Create(Self);
  Red.Parent := ABox;
  Red.Position.Y := ABox.Height;
  Red.Align := TAlignLayout.Top;
  Red.Height := 24;
  Red.Margins.Left := 12;
  Red.Margins.Right := 12;
  Red.Margins.Top := 2;

  D := TLabel.Create(Self);
  D.Parent := Red;
  D.Align := TAlignLayout.Right;
  D.Width := 110;
  D.Text := ADesno;
  D.StyledSettings := D.StyledSettings - [TStyledSetting.Size, TStyledSetting.Style];
  D.Font.Size := 13;
  if ABold then D.Font.Style := [TFontStyle.fsBold];
  D.TextSettings.HorzAlign := TTextAlign.Trailing;
  D.TextSettings.VertAlign := TTextAlign.Center;

  L := TLabel.Create(Self);
  L.Parent := Red;
  L.Align := TAlignLayout.Client;
  L.Text := ALevo;
  L.StyledSettings := L.StyledSettings - [TStyledSetting.Size, TStyledSetting.Style];
  L.Font.Size := 13;
  if ABold then L.Font.Style := [TFontStyle.fsBold];
  L.TextSettings.VertAlign := TTextAlign.Center;

  ABox.Height := ABox.Height + 26;
end;

procedure TfraRadnik.DodajRed2(ABox: TRectangle; const AGlavni, ADetalj,
  ADesno: string; ARezId: Integer);
var
  Red, Col: TLayout;
  G, Det, D: TLabel;
begin
  Red := TLayout.Create(Self);
  Red.Parent := ABox;
  Red.Position.Y := ABox.Height;
  Red.Align := TAlignLayout.Top;
  Red.Height := 40;
  Red.Margins.Left := 12;
  Red.Margins.Right := 12;
  Red.Margins.Top := 2;
  if ARezId > 0 then
  begin
    Red.Tag := ARezId;
    Red.HitTest := True;
    Red.Cursor := crHandPoint;
    Red.OnClick := RedRezervacijaClick;
  end;

  D := TLabel.Create(Self);
  D.Parent := Red;
  D.Align := TAlignLayout.Right;
  D.Width := 80;
  D.Text := ADesno;
  D.StyledSettings := D.StyledSettings - [TStyledSetting.Size, TStyledSetting.Style];
  D.Font.Size := 13;
  D.Font.Style := [TFontStyle.fsBold];
  D.TextSettings.HorzAlign := TTextAlign.Trailing;
  D.TextSettings.VertAlign := TTextAlign.Center;

  Col := TLayout.Create(Self);
  Col.Parent := Red;
  Col.Align := TAlignLayout.Client;

  G := TLabel.Create(Self);
  G.Parent := Col;
  G.Position.Y := 0;
  G.Align := TAlignLayout.Top;
  G.Height := 20;
  G.Text := AGlavni;
  G.StyledSettings := G.StyledSettings - [TStyledSetting.Size];
  G.Font.Size := 13;

  Det := TLabel.Create(Self);
  Det.Parent := Col;
  Det.Position.Y := 20;
  Det.Align := TAlignLayout.Top;
  Det.Height := 16;
  Det.Text := ADetalj;
  Det.StyledSettings := Det.StyledSettings -
    [TStyledSetting.Size, TStyledSetting.FontColor];
  Det.Font.Size := 11;
  Det.FontColor := $FF8A8A8E;

  ABox.Height := ABox.Height + 44;
end;

procedure TfraRadnik.RefreshIzvestaji;
var
  Q: TFDQuery;
  Box: TRectangle;
  BrRez: Integer;
  Suma: Double;
  Ima: Boolean;
begin
  if DB = nil then Exit;
  OcistiIzvestaje;
  FNextY := 0;

  Q := TFDQuery.Create(nil);
  try
    Q.Connection := DB;

    try
      Box := NovaSekcija('Ukupan promet');
      Q.SQL.Text := 'SELECT COUNT(*) FROM rezervacija';
      Q.Open;
      BrRez := Q.Fields[0].AsInteger;
      Q.Close;
      Q.SQL.Text := 'SELECT IFNULL(SUM(ukupan_iznos), 0) FROM faktura';
      Q.Open;
      Suma := Q.Fields[0].AsFloat;
      Q.Close;
      DodajRed(Box, 'Broj rezervacija', BrRez.ToString, False);
      DodajRed(Box, 'Ukupan promet', '$' + FormatFloat('0.00', Suma), True);
      Q.SQL.Text :=
        'SELECT metoda, COUNT(*), IFNULL(SUM(iznos), 0) FROM placanje ' +
        'GROUP BY metoda ORDER BY metoda';
      Q.Open;
      while not Q.Eof do
      begin
        DodajRed(Box,
          Q.Fields[0].AsString + ' (' + Q.Fields[1].AsString + 'x)',
          '$' + FormatFloat('0.00', Q.Fields[2].AsFloat), False);
        Q.Next;
      end;
      Q.Close;
    except
    end;

    try
      Box := NovaSekcija('Prodato po usluzi');
      Ima := False;
      Q.SQL.Text :=
        'SELECT naziv, SUM(kolicina), SUM(cena_stavke * kolicina) ' +
        'FROM stavka_korpe WHERE naziv IS NOT NULL ' +
        'GROUP BY naziv ORDER BY SUM(kolicina) DESC';
      Q.Open;
      while not Q.Eof do
      begin
        Ima := True;
        DodajRed(Box,
          Q.Fields[0].AsString + '  (x' + Q.Fields[1].AsString + ')',
          '$' + FormatFloat('0.00', Q.Fields[2].AsFloat), False);
        Q.Next;
      end;
      Q.Close;
      if not Ima then
        DodajRed(Box, 'Nema prodatih usluga', '', False);
    except
    end;

    try
      Box := NovaSekcija('Zauzetost boksova');
      Ima := False;
      Q.SQL.Text :=
        'SELECT napomena, COUNT(*) FROM rezervacija ' +
        'WHERE napomena IS NOT NULL AND napomena <> '''' ' +
        'GROUP BY napomena ORDER BY COUNT(*) DESC';
      Q.Open;
      while not Q.Eof do
      begin
        Ima := True;
        DodajRed(Box, Q.Fields[0].AsString,
          Q.Fields[1].AsString + ' rez.', False);
        Q.Next;
      end;
      Q.Close;
      if not Ima then
        DodajRed(Box, 'Nema podataka o boksevima', '', False);
    except
    end;

    try
      Box := NovaSekcija('Sve rezervacije');
      Ima := False;
      Q.SQL.Text :=
        'SELECT r.id, IFNULL(p.name, ''-'') AS ljubimac, ' +
        'IFNULL(r.napomena, '''') AS boks, ' +
        'IFNULL(r.datum_od, '''') AS dod, IFNULL(r.datum_do, '''') AS ddo, ' +
        'IFNULL(pl.iznos, 0) AS iznos, IFNULL(pl.metoda, '''') AS metoda ' +
        'FROM rezervacija r ' +
        'LEFT JOIN pets p ON p.id = r.pet_id ' +
        'LEFT JOIN placanje pl ON pl.rezervacija_id = r.id ' +
        'ORDER BY r.id DESC';
      Q.Open;
      while not Q.Eof do
      begin
        Ima := True;
        DodajRed2(Box,
          '#' + Q.FieldByName('id').AsString + '  ' +
            Q.FieldByName('ljubimac').AsString + '  -  ' +
            Q.FieldByName('boks').AsString,
          Q.FieldByName('dod').AsString + ' do ' +
            Q.FieldByName('ddo').AsString + '   ' +
            Q.FieldByName('metoda').AsString,
          '$' + FormatFloat('0.00', Q.FieldByName('iznos').AsFloat),
          Q.FieldByName('id').AsInteger);
        Q.Next;
      end;
      Q.Close;
      if not Ima then
        DodajRed(Box, 'Nema rezervacija', '', False);
    except
    end;
  finally
    Q.Free;
  end;
end;

procedure TfraRadnik.PrikaziDetaljeRezervacije(ARezId: Integer);
var
  Q: TFDQuery;
  S, Metoda, DatumPl, Fakt: string;
  Iznos: Double;
  ImaUsluga: Boolean;
begin
  if DB = nil then Exit;
  Q := TFDQuery.Create(nil);
  try
    Q.Connection := DB;
    Q.SQL.Text :=
      'SELECT r.id, IFNULL(r.status, ''-'') AS status, ' +
      'IFNULL(p.name, ''-'') AS ljubimac, IFNULL(p.breed, '''') AS rasa, ' +
      'IFNULL(r.napomena, ''-'') AS boks, ' +
      'IFNULL(r.datum_od, ''-'') AS dod, IFNULL(r.datum_do, ''-'') AS ddo, ' +
      'IFNULL(pl.iznos, 0) AS iznos, IFNULL(pl.metoda, ''-'') AS metoda, ' +
      'IFNULL(pl.datum, ''-'') AS datum_pl, ' +
      'IFNULL(f.br_fakture, ''-'') AS fakt ' +
      'FROM rezervacija r ' +
      'LEFT JOIN pets p ON p.id = r.pet_id ' +
      'LEFT JOIN placanje pl ON pl.rezervacija_id = r.id ' +
      'LEFT JOIN faktura f ON f.placanje_id = pl.id ' +
      'WHERE r.id = :id';
    Q.ParamByName('id').AsInteger := ARezId;
    Q.Open;
    if Q.IsEmpty then
    begin
      Q.Close;
      Exit;
    end;

    S := 'Rezervacija #' + Q.FieldByName('id').AsString + sLineBreak +
         'Status: ' + Q.FieldByName('status').AsString + sLineBreak + sLineBreak +
         'Ljubimac: ' + Q.FieldByName('ljubimac').AsString;
    if Q.FieldByName('rasa').AsString <> '' then
      S := S + ' (' + Q.FieldByName('rasa').AsString + ')';
    S := S + sLineBreak +
         'Boks: ' + Q.FieldByName('boks').AsString + sLineBreak +
         'Period: ' + Q.FieldByName('dod').AsString + ' do ' +
         Q.FieldByName('ddo').AsString + sLineBreak + sLineBreak;

    Iznos   := Q.FieldByName('iznos').AsFloat;
    Metoda  := Q.FieldByName('metoda').AsString;
    DatumPl := Q.FieldByName('datum_pl').AsString;
    Fakt    := Q.FieldByName('fakt').AsString;
    Q.Close;

    S := S + 'Usluge:' + sLineBreak;
    ImaUsluga := False;
    Q.SQL.Text :=
      'SELECT naziv, kolicina, cena_stavke FROM stavka_korpe ' +
      'WHERE rezervacija_id = :id AND naziv IS NOT NULL';
    Q.ParamByName('id').AsInteger := ARezId;
    Q.Open;
    while not Q.Eof do
    begin
      ImaUsluga := True;
      S := S + '   - ' + Q.FieldByName('naziv').AsString +
           ' (x' + Q.FieldByName('kolicina').AsString + ')  $' +
           FormatFloat('0.00', Q.FieldByName('cena_stavke').AsFloat *
             Q.FieldByName('kolicina').AsInteger) + sLineBreak;
      Q.Next;
    end;
    Q.Close;
    if not ImaUsluga then
      S := S + '   Nema dodatnih usluga' + sLineBreak;

    S := S + sLineBreak +
         'Iznos: $' + FormatFloat('0.00', Iznos) + sLineBreak +
         'Metoda pla' + #263 + 'anja: ' + Metoda + sLineBreak +
         'Datum pla' + #263 + 'anja: ' + DatumPl + sLineBreak +
         'Ra' + #269 + 'un br: ' + Fakt;

    ShowMessage(S);
  finally
    Q.Free;
  end;
end;

procedure TfraRadnik.RedRezervacijaClick(Sender: TObject);
begin
  if Sender is TFmxObject then
    PrikaziDetaljeRezervacije(TFmxObject(Sender).Tag);
end;

procedure TfraRadnik.FrameEnter(Sender: TObject);
begin
  RefreshIzvestaji;
end;

procedure TfraRadnik.btnNazadClick(Sender: TObject);
begin
  TNavFrames.Back;
end;

end.

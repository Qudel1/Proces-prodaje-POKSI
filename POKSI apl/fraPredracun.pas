unit fraPredracun;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  System.DateUtils,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Layouts, FMX.Objects, FMX.ScrollBox, FMX.Controls.Presentation, FMX.Edit,
  FireDAC.Comp.Client, uNavFrames, uKorpa, uUserStore;

type
  TfraPredracun = class(TFrame)
    layoutRoot: TLayout;
    layoutHeader: TLayout;
    btnNazad: TButton;
    layoutHeaderText: TLayout;
    lblTitle: TLabel;
    lblPodTitle: TLabel;
    layoutFooter: TLayout;
    rectFooterBg: TRectangle;
    btnPlatiPotvrdi: TButton;
    vertScroll: TVertScrollBox;
    lblKorisnikLjubimac: TLabel;
    rectKorisnik: TRectangle;
    lblKorisnikIme: TLabel;
    lblKorisnikEmail: TLabel;
    lblKorisnikLjubimacInfo: TLabel;
    lblDetaljiBoravka: TLabel;
    layoutDatum: TLayout;
    lblDatumText: TLabel;
    lblDatumVal: TLabel;
    layoutBoks: TLayout;
    lblBoksText: TLabel;
    lblBoksVal: TLabel;
    layoutTrajanje: TLayout;
    lblTrajanjeText: TLabel;
    lblTrajanjeVal: TLabel;
    lblUkljuceneUsluge: TLabel;
    rectHrana: TRectangle;
    lblHranaText: TLabel;
    lblHranaCena: TLabel;
    rectKupanje: TRectangle;
    lblKupanjeText: TLabel;
    lblKupanjeCena: TLabel;
    rectVeterinar: TRectangle;
    lblVeterinarText: TLabel;
    lblVeterinarCena: TLabel;
    lblIznosPlacanja: TLabel;
    layoutSmestaj: TLayout;
    lblSmestajText: TLabel;
    lblSmestajVal: TLabel;
    layoutUsluge: TLayout;
    lblUslugeText: TLabel;
    lblUslugeVal: TLabel;
    layoutPopust: TLayout;
    lblPopustText: TLabel;
    lblPopustVal: TLabel;
    layoutPorez: TLayout;
    lblPorezText: TLabel;
    lblPorezVal: TLabel;
    layoutUkupno: TLayout;
    lblUkupnoText: TLabel;
    lblUkupnoVal: TLabel;
    rectBrojRezervacije: TRectangle;
    lblBrojRezLabel: TLabel;
    lblBrojRezVal: TLabel;

    procedure btnNazadClick(Sender: TObject);
    procedure btnPlatiPotvrdiClick(Sender: TObject);
    procedure Loaded; override;
    procedure FrameEnter(Sender: TObject);
  private
    FBrojRez: string;
    FSmestaj: Double;   // smestaj + obroci
    FUsluge:  Double;
    FPopust:  Double;
    FPorez:   Double;
    FUkupno:  Double;
    FNoci:    Integer;
    procedure Popuni;
    function  BrojNoci: Integer;
    function  SacuvajURezervaciju: Boolean;
    procedure SacuvajURacunSesije;
  public
  end;

implementation

{$R *.fmx}

uses
  fraUspesno;

function TfraPredracun.BrojNoci: Integer;
begin
  if (KalendarDatumOd > 0) and (KalendarDatumDo > 0) then
    Result := DaysBetween(KalendarDatumOd, KalendarDatumDo)
  else
    Result := 1;
  if Result < 1 then Result := 1;
end;

procedure TfraPredracun.Popuni;
var
  Smestaj, Obroci, Usluge, Osnova, Popust, Porez, Ukupno: Double;
  Procenat: Double;
  Noci: Integer;
  rects: array[0..2] of TRectangle;
  txts:  array[0..2] of TLabel;
  cenas: array[0..2] of TLabel;
  i, r, PetIdx: Integer;
begin
  PetIdx := ActivePetIndex;

  // Korisnik + ljubimac
  lblKorisnikIme.Text   := LoggedUsername;
  lblKorisnikEmail.Text := LoggedUserEmail;
  if (PetIdx >= 0) and (PetIdx <= High(Pets)) and (Pets[PetIdx].Id <> 0) then
    lblKorisnikLjubimacInfo.Text :=
      Pets[PetIdx].Name + ' - ' +
      Pets[PetIdx].Breed + ' - ' +
      Pets[PetIdx].Age
  else
    lblKorisnikLjubimacInfo.Text := '';

  // Boravak
  Noci := BrojNoci;
  if (KalendarDatumOd > 0) and (KalendarDatumDo > 0) then
    lblDatumVal.Text := FormatDateTime('dd/mm', KalendarDatumOd) + ' - ' +
                        FormatDateTime('dd/mm/yyyy', KalendarDatumDo)
  else
    lblDatumVal.Text := '-';
  lblBoksVal.Text := IzabraniBoksText;
  lblTrajanjeVal.Text := Noci.ToString + ' no' + #263 + 'i';

  // Usluge - mapiraj na 3 reda
  rects[0]:=rectHrana; rects[1]:=rectKupanje; rects[2]:=rectVeterinar;
  txts[0]:=lblHranaText; txts[1]:=lblKupanjeText; txts[2]:=lblVeterinarText;
  cenas[0]:=lblHranaCena; cenas[1]:=lblKupanjeCena; cenas[2]:=lblVeterinarCena;

  for i := 0 to 2 do rects[i].Visible := False;
  r := 0;
  for i := 0 to High(KorpaItems) do
  begin
    if r > 2 then Break;
    if KorpaItems[i].ServiceId = 0 then Continue;
    rects[r].Visible := True;
    txts[r].Text  := KorpaItems[i].Naziv;
    cenas[r].Text := '$' + FormatFloat('0.##', KorpaItems[i].Cena * KorpaItems[i].Kolicina);
    Inc(r);
  end;

  // ── Iznosi ──
  // Smestaj: $3 po noci. Obavezan obrok: $2 po danu (svaki dan boravka).
  Smestaj := Noci * 3.0;
  Obroci  := Noci * 2.0;
  Usluge  := KorpaUkupno;
  Osnova  := Smestaj + Obroci + Usluge;

  Procenat := KorpaPopustProcent(PromoKod);
  Popust   := Osnova * Procenat;
  Porez    := (Osnova - Popust) * 0.10;
  Ukupno   := Osnova - Popust + Porez;

  lblSmestajText.Text := 'Sme' + #353 + 'taj (' + Noci.ToString + ' no' + #263 + 'i) + obroci';
  lblSmestajVal.Text  := '$' + FormatFloat('0.00', Smestaj + Obroci);
  lblUslugeVal.Text   := '$' + FormatFloat('0.00', Usluge);
  if Popust > 0 then
  begin
    lblPopustText.Text := 'Popust (' + FormatFloat('0', Procenat * 100) + '%)';
    lblPopustVal.Text  := '-$' + FormatFloat('0.00', Popust);
  end
  else
  begin
    lblPopustText.Text := 'Popust';
    lblPopustVal.Text  := '$0.00';
  end;
  lblPorezVal.Text  := '$' + FormatFloat('0.00', Porez);
  lblUkupnoVal.Text := '$' + FormatFloat('0.00', Ukupno);

  UkupanIznos := Ukupno;
  PrimenjeniPopust := Popust;

  // Sacuvaj razlaganje za fiskalni racun / istoriju
  FSmestaj := Smestaj + Obroci;
  FUsluge  := Usluge;
  FPopust  := Popust;
  FPorez   := Porez;
  FUkupno  := Ukupno;
  FNoci    := Noci;

  // Broj rezervacije - nasumican, pamti se za ovu sesiju predracuna
  if FBrojRez = '' then
    FBrojRez := 'POK-' + FormatDateTime('yyyy', Now) + '-' +
                Format('%.6d', [Random(1000000)]);
  lblBrojRezVal.Text := FBrojRez;
end;

function TfraPredracun.SacuvajURezervaciju: Boolean;
var
  Q: TFDQuery;
  rezId, placId, PetIdx, i: Integer;
begin
  Result := False;
  PetIdx := ActivePetIndex;
  Q := TFDQuery.Create(nil);
  try
    Q.Connection := DB;

    // rezervacija
    // boks_id izostavljamo (default NULL) - nemamo mapiranje oznake (P2) na ID.
    // pet_id ukljucujemo samo ako je validan, inace ide kao NULL (default).
    if (PetIdx >= 0) and (PetIdx <= High(Pets)) and (Pets[PetIdx].Id <> 0) then
    begin
      Q.SQL.Text :=
        'INSERT INTO rezervacija (pet_id, datum_od, datum_do, status, napomena) ' +
        'VALUES (:pet, :od, :do, ''potvrdjena'', :nap)';
      Q.ParamByName('pet').AsInteger := Pets[PetIdx].Id;
    end
    else
      Q.SQL.Text :=
        'INSERT INTO rezervacija (datum_od, datum_do, status, napomena) ' +
        'VALUES (:od, :do, ''potvrdjena'', :nap)';
    Q.ParamByName('od').AsString := FormatDateTime('yyyy-mm-dd', KalendarDatumOd);
    Q.ParamByName('do').AsString := FormatDateTime('yyyy-mm-dd', KalendarDatumDo);
    Q.ParamByName('nap').AsString := IzabraniBoksText;
    Q.ExecSQL;

    // dobij id
    Q.SQL.Text := 'SELECT last_insert_rowid()';
    Q.Open;
    rezId := Q.Fields[0].AsInteger;
    Q.Close;
    AktivnaRezervacijaId := rezId;

    // placanje
    Q.SQL.Text :=
      'INSERT INTO placanje (rezervacija_id, iznos, metoda, datum, status) ' +
      'VALUES (:rez, :iznos, :metoda, :datum, ''placeno'')';
    Q.ParamByName('rez').AsInteger := rezId;
    Q.ParamByName('iznos').AsFloat := UkupanIznos;
    Q.ParamByName('metoda').AsString := TfraPlacanje_OdabranaMetoda;
    Q.ParamByName('datum').AsString := FormatDateTime('yyyy-mm-dd hh:nn', Now);
    Q.ExecSQL;

    Q.SQL.Text := 'SELECT last_insert_rowid()';
    Q.Open;
    placId := Q.Fields[0].AsInteger;
    Q.Close;

    // faktura
    Q.SQL.Text :=
      'INSERT INTO faktura (placanje_id, br_fakture, ukupan_iznos, datum_izdavanja, status) ' +
      'VALUES (:plac, :br, :iznos, :datum, ''izdata'')';
    Q.ParamByName('plac').AsInteger := placId;
    Q.ParamByName('br').AsString := FBrojRez;
    Q.ParamByName('iznos').AsFloat := UkupanIznos;
    Q.ParamByName('datum').AsString := FormatDateTime('yyyy-mm-dd hh:nn', Now);
    Q.ExecSQL;

    Result := True;

    // Oznaci boks kao zauzet u ovoj sesiji (npr "Unutrasnji P7" -> "P7")
    if IzabraniBoksText <> '' then
    begin
      i := IzabraniBoksText.LastIndexOf(' ');
      if i >= 0 then
        SesijaDodajZauzet(IzabraniBoksText.Substring(i + 1))
      else
        SesijaDodajZauzet(IzabraniBoksText);
    end;

    // Sastavi kompletan racun i sacuvaj u istoriju SESIJE (sa svim detaljima)
    SacuvajURacunSesije;
  except
    on E: Exception do
      ShowMessage('Gre' + #353 + 'ka pri snimanju: ' + E.Message);
  end;
  Q.Free;
end;

procedure TfraPredracun.SacuvajURacunSesije;
var
  R: TSesijaRacun;
  i, n, PetIdx: Integer;
begin
  PetIdx := ActivePetIndex;

  R.BrojRacuna := FBrojRez;
  R.Datum      := FormatDateTime('yyyy-mm-dd hh:nn', Now);
  if (PetIdx >= 0) and (PetIdx <= High(Pets)) and (Pets[PetIdx].Id <> 0) then
  begin
    R.LjubimacIme   := Pets[PetIdx].Name;
    R.LjubimacBreed := Pets[PetIdx].Breed;
  end
  else
  begin
    R.LjubimacIme   := '';
    R.LjubimacBreed := '';
  end;
  R.BoksText := IzabraniBoksText;
  R.DatumOd  := KalendarDatumOd;
  R.DatumDo  := KalendarDatumDo;
  R.Noci     := FNoci;
  R.Smestaj  := FSmestaj;
  R.UslugeIznos := FUsluge;
  R.Popust   := FPopust;
  R.Porez    := FPorez;
  R.Ukupno   := FUkupno;
  R.Metoda   := TfraPlacanje_OdabranaMetoda;

  // Kopiraj stavke iz korpe
  n := 0;
  SetLength(R.Stavke, KorpaBrojStavki);
  for i := 0 to High(KorpaItems) do
  begin
    if KorpaItems[i].ServiceId = 0 then Continue;
    if n > High(R.Stavke) then Break;
    R.Stavke[n].Naziv    := KorpaItems[i].Naziv;
    R.Stavke[n].Kolicina := KorpaItems[i].Kolicina;
    R.Stavke[n].Cena     := KorpaItems[i].Cena * KorpaItems[i].Kolicina;
    Inc(n);
  end;

  SesijaDodajRacun(R);
  AktivniRacunBroj := R.BrojRacuna;
end;

procedure TfraPredracun.Loaded;
begin
  inherited;
  Randomize;
  FBrojRez := '';
  Popuni;
end;

procedure TfraPredracun.FrameEnter(Sender: TObject);
begin
  Popuni;
end;

procedure TfraPredracun.btnNazadClick(Sender: TObject);
begin
  TNavFrames.Back;
end;

procedure TfraPredracun.btnPlatiPotvrdiClick(Sender: TObject);
begin
  if SacuvajURezervaciju then
    TNavFrames.Go(TfraUspesno.Create(nil));
end;

end.

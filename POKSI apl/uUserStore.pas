unit uUserStore;

interface

uses
  System.SysUtils, System.Generics.Collections,
  FireDAC.Comp.Client, uPetModel;

type

  TRacunStavka = record
    Naziv:    string;
    Kolicina: Integer;
    Cena:     Double;
  end;


  TSesijaRacun = record
    BrojRacuna:  string;
    Datum:       string;
    LjubimacIme: string;
    LjubimacBreed: string;
    BoksText:    string;
    DatumOd:     TDateTime;
    DatumDo:     TDateTime;
    Noci:        Integer;
    Smestaj:     Double;
    UslugeIznos: Double;
    Popust:      Double;
    Porez:       Double;
    Ukupno:      Double;
    Metoda:      string;
    Stavke:      array of TRacunStavka;
  end;

var
  DB: TFDConnection;
  Pets: array[0..9] of TPet;
  ActivePetIndex: Integer = -1;

  LoggedUserId:      Integer;
  LoggedUsername:    string;
  LoggedUserEmail:   string;
  LoggedUserPhone:   string;
  LoggedUserPrezime: string;
  LoggedUserAdresa:  string;
  LoggedUserIme:     string;

  AktivnaKorpaId: Integer = 0;
  AktivnaRezervacijaId: Integer = 0;
  UkupanIznos: Double = 0;
  PrimenjeniPopust: Double = 0;
  KalendarDatumOd: TDateTime = 0;
  KalendarDatumDo: TDateTime = 0;
  IzabraniUnutrasnjiId: Integer = 0;
  IzabraniSpoljasId: Integer = 0;
  TfraPlacanje_OdabranaMetoda: string = 'Kartica';

  IzabraniBoksText: string = '';

  SesijaZauzetiBoks: array of string;

  RezervacijaPetIndex: Integer = -1;

  KarticaBroj: string = '';
  KarticaTip: string = '';
  PromoKod: string = '';


  SesijaRacuni: array of TSesijaRacun;

  AktivniRacunBroj: string = '';


procedure UserStoreClear;
procedure UserStoreLoad(AId: Integer; const AUsername, AEmail, APhone: string);
function  MaskCard(const ABroj: string): string;
function  CardEnding(const ABroj: string): string;
procedure SesijaDodajZauzet(const AOznaka: string);
function  SesijaJeZauzet(const AOznaka: string): Boolean;
procedure SesijaDodajRacun(const ARacun: TSesijaRacun);
procedure SesijaResetuj;

implementation

procedure UserStoreClear;
begin
  LoggedUserId    := 0;
  LoggedUsername  := '';
  LoggedUserEmail := '';
  LoggedUserPhone := '';
  LoggedUserPrezime := '';
  LoggedUserAdresa  := '';
  IzabraniBoksText := '';
  RezervacijaPetIndex := -1;
  KarticaBroj := '';
  KarticaTip := '';
  PromoKod := '';
  KalendarDatumOd := 0;
  KalendarDatumDo := 0;
end;

procedure UserStoreLoad(AId: Integer; const AUsername, AEmail, APhone: string);
begin
  LoggedUserId    := AId;
  LoggedUsername  := AUsername;
  LoggedUserEmail := AEmail;
  LoggedUserPhone := APhone;
end;

function MaskCard(const ABroj: string): string;
var clean: string; i: Integer;
begin
  clean := '';
  for i := 1 to Length(ABroj) do
    if CharInSet(ABroj[i], ['0'..'9']) then
      clean := clean + ABroj[i];
  if Length(clean) >= 4 then
    Result := '**** ' + Copy(clean, Length(clean) - 3, 4)
  else
    Result := ABroj;
end;

function CardEnding(const ABroj: string): string;
var clean: string; i: Integer;
begin
  clean := '';
  for i := 1 to Length(ABroj) do
    if CharInSet(ABroj[i], ['0'..'9']) then
      clean := clean + ABroj[i];
  if Length(clean) >= 4 then
    Result := Copy(clean, Length(clean) - 3, 4)
  else
    Result := clean;
end;

function SesijaJeZauzet(const AOznaka: string): Boolean;
var i: Integer;
begin
  Result := False;
  for i := 0 to High(SesijaZauzetiBoks) do
    if SesijaZauzetiBoks[i] = AOznaka then Exit(True);
end;

procedure SesijaDodajZauzet(const AOznaka: string);
begin
  if AOznaka = '' then Exit;
  if SesijaJeZauzet(AOznaka) then Exit;
  SetLength(SesijaZauzetiBoks, Length(SesijaZauzetiBoks) + 1);
  SesijaZauzetiBoks[High(SesijaZauzetiBoks)] := AOznaka;
end;

procedure SesijaDodajRacun(const ARacun: TSesijaRacun);
begin
  SetLength(SesijaRacuni, Length(SesijaRacuni) + 1);
  SesijaRacuni[High(SesijaRacuni)] := ARacun;
end;

procedure SesijaResetuj;
begin
  SetLength(SesijaZauzetiBoks, 0);
  SetLength(SesijaRacuni, 0);
end;

end.

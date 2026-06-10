unit uKorpa;

interface

type
  TKorpaItem = record
    ServiceId: Integer;
    Naziv:     string;
    Kategorija:string;
    Cena:      Double;
    Kolicina:  Integer;
    Napomena:  string;
  end;

var
  KorpaItems: array[0..9] of TKorpaItem;

procedure KorpaDodaj(AId: Integer; const ANaziv, AKat: string;
  ACena: Double; const ANapomena: string);
procedure KorpaSetKolicina(AServiceId: Integer; AKolicina: Integer);
procedure KorpaObrisi(AServiceId: Integer);
procedure KorpaOcisti;
function  KorpaUkupno: Double;
function  KorpaBrojStavki: Integer;
function  KorpaPopust(const AKod: string): Double;
function  KorpaPopustProcent(const AKod: string): Double;

implementation

uses
  System.SysUtils;

procedure KorpaDodaj(AId: Integer; const ANaziv, AKat: string;
  ACena: Double; const ANapomena: string);
var
  i, FreeIdx: Integer;
begin
  // Provjeri da li vec postoji
  for i := 0 to High(KorpaItems) do
  begin
    if KorpaItems[i].ServiceId = AId then
    begin
      Inc(KorpaItems[i].Kolicina);
      Exit;
    end;
  end;

  // Nadji slobodan slot
  FreeIdx := -1;
  for i := 0 to High(KorpaItems) do
    if KorpaItems[i].ServiceId = 0 then
    begin
      FreeIdx := i;
      Break;
    end;

  if FreeIdx = -1 then Exit; // Korpa puna

  KorpaItems[FreeIdx].ServiceId  := AId;
  KorpaItems[FreeIdx].Naziv      := ANaziv;
  KorpaItems[FreeIdx].Kategorija := AKat;
  KorpaItems[FreeIdx].Cena       := ACena;
  KorpaItems[FreeIdx].Kolicina   := 1;
  KorpaItems[FreeIdx].Napomena   := ANapomena;
end;

procedure KorpaSetKolicina(AServiceId: Integer; AKolicina: Integer);
var
  i: Integer;
begin
  for i := 0 to High(KorpaItems) do
  begin
    if KorpaItems[i].ServiceId = AServiceId then
    begin
      if AKolicina <= 0 then
        KorpaObrisi(AServiceId)
      else
        KorpaItems[i].Kolicina := AKolicina;
      Exit;
    end;
  end;
end;

procedure KorpaObrisi(AServiceId: Integer);
var
  i: Integer;
begin
  for i := 0 to High(KorpaItems) do
    if KorpaItems[i].ServiceId = AServiceId then
    begin
      KorpaItems[i].ServiceId  := 0;
      KorpaItems[i].Naziv      := '';
      KorpaItems[i].Kategorija := '';
      KorpaItems[i].Cena       := 0;
      KorpaItems[i].Kolicina   := 0;
      KorpaItems[i].Napomena   := '';
      Exit;
    end;
end;

procedure KorpaOcisti;
var
  i: Integer;
begin
  for i := 0 to High(KorpaItems) do
  begin
    KorpaItems[i].ServiceId  := 0;
    KorpaItems[i].Naziv      := '';
    KorpaItems[i].Kategorija := '';
    KorpaItems[i].Cena       := 0;
    KorpaItems[i].Kolicina   := 0;
    KorpaItems[i].Napomena   := '';
  end;
end;

function KorpaUkupno: Double;
var
  i: Integer;
begin
  Result := 0;
  for i := 0 to High(KorpaItems) do
    if KorpaItems[i].ServiceId <> 0 then
      Result := Result + (KorpaItems[i].Cena * KorpaItems[i].Kolicina);
end;

function KorpaBrojStavki: Integer;
var
  i: Integer;
begin
  Result := 0;
  for i := 0 to High(KorpaItems) do
    if KorpaItems[i].ServiceId <> 0 then
      Inc(Result);
end;

function KorpaPopustProcent(const AKod: string): Double;
begin
  Result := 0;
  if UpperCase(Trim(AKod)) = 'POKSI20' then Result := 0.20
  else if UpperCase(Trim(AKod)) = 'POKSI10' then Result := 0.10;
end;

function KorpaPopust(const AKod: string): Double;
begin
  Result := KorpaUkupno * KorpaPopustProcent(AKod);
end;

end.

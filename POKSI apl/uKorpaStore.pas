unit uKorpaStore;

interface

uses
  System.Generics.Collections;

type
  TKorpaStavka = record
    ID: Integer;
    Naziv: string;
    CenaStr: string;
    Cena: Double;
    Kolicina: Integer;
  end;

  TKorpa = class
  private
    class var FStavke: TList<TKorpaStavka>;
  public
    class constructor Create;
    class destructor Destroy;
    class procedure DodajStavku(const AStavka: TKorpaStavka);
    class function  Stavke: TList<TKorpaStavka>;
    class function  BrojStavki: Integer;
    class function  Ukupno: Double;
    class procedure Isprazni;
  end;

implementation

{ TKorpa }

class constructor TKorpa.Create;
begin
  FStavke := TList<TKorpaStavka>.Create;
end;

class destructor TKorpa.Destroy;
begin
  FStavke.Free;
end;

class procedure TKorpa.DodajStavku(const AStavka: TKorpaStavka);
var
  I: Integer;
  S: TKorpaStavka;
begin
  { ako vec postoji ista usluga, povecaj kolicinu }
  for I := 0 to FStavke.Count - 1 do
    if FStavke[I].ID = AStavka.ID then
    begin
      S := FStavke[I];
      Inc(S.Kolicina, AStavka.Kolicina);
      FStavke[I] := S;
      Exit;
    end;
  FStavke.Add(AStavka);
end;

class function TKorpa.Stavke: TList<TKorpaStavka>;
begin
  Result := FStavke;
end;

class function TKorpa.BrojStavki: Integer;
begin
  Result := FStavke.Count;
end;

class function TKorpa.Ukupno: Double;
var
  I: Integer;
begin
  Result := 0;
  for I := 0 to FStavke.Count - 1 do
    Result := Result + FStavke[I].Cena * FStavke[I].Kolicina;
end;

class procedure TKorpa.Isprazni;
begin
  FStavke.Clear;
end;

end.

unit frmMain;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Layouts,
  uNavFrames, fraWelcome, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt, FireDAC.UI.Intf,
  FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Phys, FireDAC.Phys.SQLite,
  FireDAC.Phys.SQLiteDef, FireDAC.Stan.ExprFuncs,
  FireDAC.Phys.SQLiteWrapper.Stat, FireDAC.FMXUI.Wait, Data.DB,
  FireDAC.Comp.Client, FireDAC.Comp.DataSet, uUserStore, fraHome;

type
  TForm5 = class(TForm)
    layHost: TLayout;
    FDQuery1: TFDQuery;
    FDConnection1: TFDConnection;
    procedure FormCreate(Sender: TObject);
  private
    procedure LoadPetsFromDB;
  public
  end;

var
  Form5: TForm5;

implementation

{$R *.fmx}

procedure TForm5.FormCreate(Sender: TObject);
var
  Stream: TResourceStream;
begin
  FDConnection1.Connected := True;
  DB := FDConnection1;


  FDQuery1.SQL.Text :=
    'CREATE TABLE IF NOT EXISTS users (' +
    'id INTEGER PRIMARY KEY AUTOINCREMENT,' +
    'username TEXT UNIQUE,' +
    'email TEXT UNIQUE,' +
    'phone TEXT,' +
    'password TEXT)';
  FDQuery1.ExecSQL;

  FDQuery1.SQL.Text :=
    'CREATE TABLE IF NOT EXISTS pets (' +
    'id INTEGER PRIMARY KEY AUTOINCREMENT,' +
    'name TEXT,' +
    'species TEXT,' +
    'breed TEXT,' +
    'age TEXT,' +
    'image_blob BLOB)';
  FDQuery1.ExecSQL;

  FDQuery1.SQL.Text :=
    'CREATE TABLE IF NOT EXISTS korpa (' +
    'id INTEGER PRIMARY KEY AUTOINCREMENT,' +
    'user_id INTEGER,' +
    'datum_kreiranja TEXT,' +
    'status TEXT DEFAULT ''aktivna'',' +
    'ukupan_iznos REAL DEFAULT 0)';
  FDQuery1.ExecSQL;

  FDQuery1.SQL.Text :=
    'CREATE TABLE IF NOT EXISTS usluge (' +
    'id INTEGER PRIMARY KEY AUTOINCREMENT,' +
    'naziv TEXT,' +
    'kategorija TEXT,' +
    'cena REAL,' +
    'trajanje TEXT)';
  FDQuery1.ExecSQL;

  FDQuery1.SQL.Text :=
    'CREATE TABLE IF NOT EXISTS stavka_korpe (' +
    'id INTEGER PRIMARY KEY AUTOINCREMENT,' +
    'korpa_id INTEGER,' +
    'usluga_id INTEGER,' +
    'kolicina INTEGER DEFAULT 1,' +
    'cena_stavke REAL,' +
    'FOREIGN KEY(korpa_id) REFERENCES korpa(id),' +
    'FOREIGN KEY(usluga_id) REFERENCES usluge(id))';
  FDQuery1.ExecSQL;

  FDQuery1.SQL.Text :=
    'CREATE TABLE IF NOT EXISTS boksevi (' +
    'id INTEGER PRIMARY KEY AUTOINCREMENT,' +
    'br INTEGER,' +
    'tip TEXT,' +
    'kapacitet INTEGER,' +
    'dostupan INTEGER DEFAULT 1)';
  FDQuery1.ExecSQL;

  FDQuery1.SQL.Text :=
    'CREATE TABLE IF NOT EXISTS rezervacija (' +
    'id INTEGER PRIMARY KEY AUTOINCREMENT,' +
    'pet_id INTEGER,' +
    'boks_id INTEGER,' +
    'datum_od TEXT,' +
    'datum_do TEXT,' +
    'status TEXT DEFAULT ''ceka'',' +
    'napomena TEXT,' +
    'FOREIGN KEY(pet_id) REFERENCES pets(id),' +
    'FOREIGN KEY(boks_id) REFERENCES boksevi(id))';
  FDQuery1.ExecSQL;

  FDQuery1.SQL.Text :=
    'CREATE TABLE IF NOT EXISTS placanje (' +
    'id INTEGER PRIMARY KEY AUTOINCREMENT,' +
    'rezervacija_id INTEGER,' +
    'iznos REAL,' +
    'metoda TEXT,' +
    'datum TEXT,' +
    'status TEXT DEFAULT ''na cekanju'',' +
    'FOREIGN KEY(rezervacija_id) REFERENCES rezervacija(id))';
  FDQuery1.ExecSQL;

  FDQuery1.SQL.Text :=
    'CREATE TABLE IF NOT EXISTS faktura (' +
    'id INTEGER PRIMARY KEY AUTOINCREMENT,' +
    'placanje_id INTEGER,' +
    'br_fakture TEXT,' +
    'ukupan_iznos REAL,' +
    'datum_izdavanja TEXT,' +
    'status TEXT DEFAULT ''izdata'',' +
    'FOREIGN KEY(placanje_id) REFERENCES placanje(id))';
  FDQuery1.ExecSQL;

  FDQuery1.SQL.Text :=
    'CREATE TABLE IF NOT EXISTS kuponi (' +
    'id INTEGER PRIMARY KEY AUTOINCREMENT,' +
    'kod TEXT UNIQUE,' +
    'popust REAL,' +
    'aktivan INTEGER DEFAULT 1)';
  FDQuery1.ExecSQL;


  FDQuery1.SQL.Text := 'SELECT COUNT(*) FROM pets';
  FDQuery1.Open;
  if FDQuery1.Fields[0].AsInteger = 0 then
  begin
    FDQuery1.Close;
    FDQuery1.SQL.Text :=
      'INSERT INTO pets (name, species, breed, age, image_blob) ' +
      'VALUES (:name, :species, :breed, :age, :img)';

    FDQuery1.ParamByName('name').AsString    := 'Fido';
    FDQuery1.ParamByName('species').AsString := 'pas';
    FDQuery1.ParamByName('breed').AsString   := 'Labrador';
    FDQuery1.ParamByName('age').AsString     := '3 godine';
    Stream := TResourceStream.Create(HInstance, 'PngImage_1', RT_RCDATA);
    try
      FDQuery1.ParamByName('img').LoadFromStream(Stream, ftBlob);
    finally
      Stream.Free;
    end;
    FDQuery1.ExecSQL;

    FDQuery1.ParamByName('name').AsString    := 'Gus';
    FDQuery1.ParamByName('species').AsString := 'guster';
    FDQuery1.ParamByName('breed').AsString   := 'Zeleni guster';
    FDQuery1.ParamByName('age').AsString     := '1 godina';
    Stream := TResourceStream.Create(HInstance, 'PngImage_2', RT_RCDATA);
    try
      FDQuery1.ParamByName('img').LoadFromStream(Stream, ftBlob);
    finally
      Stream.Free;
    end;
    FDQuery1.ExecSQL;

    FDQuery1.ParamByName('name').AsString    := 'Maca';
    FDQuery1.ParamByName('species').AsString := 'macka';
    FDQuery1.ParamByName('breed').AsString   := 'Persijska macka';
    FDQuery1.ParamByName('age').AsString     := '2 godine';
    Stream := TResourceStream.Create(HInstance, 'PngImage_3', RT_RCDATA);
    try
      FDQuery1.ParamByName('img').LoadFromStream(Stream, ftBlob);
    finally
      Stream.Free;
    end;
    FDQuery1.ExecSQL;
  end
  else
    FDQuery1.Close;


  FDQuery1.SQL.Text := 'SELECT COUNT(*) FROM usluge';
  FDQuery1.Open;
  if FDQuery1.Fields[0].AsInteger = 0 then
  begin
    FDQuery1.Close;

    FDQuery1.SQL.Text :=
      'INSERT INTO usluge (naziv, kategorija, cena, trajanje) ' +
      'VALUES (''Hranjenje'', ''Nega'', 500, ''1x dnevno'')';
    FDQuery1.ExecSQL;

    FDQuery1.SQL.Text :=
      'INSERT INTO usluge (naziv, kategorija, cena, trajanje) ' +
      'VALUES (''Sisanje'', ''Grooming'', 1500, ''1-2h'')';
    FDQuery1.ExecSQL;

    FDQuery1.SQL.Text :=
      'INSERT INTO usluge (naziv, kategorija, cena, trajanje) ' +
      'VALUES (''Vet pregled'', ''Zdravlje'', 2000, ''30min'')';
    FDQuery1.ExecSQL;

    FDQuery1.SQL.Text :=
      'INSERT INTO usluge (naziv, kategorija, cena, trajanje) ' +
      'VALUES (''Dresura'', ''Trening'', 1200, ''1h'')';
    FDQuery1.ExecSQL;

    FDQuery1.SQL.Text :=
      'INSERT INTO usluge (naziv, kategorija, cena, trajanje) ' +
      'VALUES (''Setnja'', ''Aktivnost'', 400, ''30min'')';
    FDQuery1.ExecSQL;
  end
  else
    FDQuery1.Close;


  FDQuery1.SQL.Text := 'SELECT COUNT(*) FROM boksevi';
  FDQuery1.Open;
  if FDQuery1.Fields[0].AsInteger = 0 then
  begin
    FDQuery1.Close;

    FDQuery1.SQL.Text :=
      'INSERT INTO boksevi (br, tip, kapacitet, dostupan) ' +
      'VALUES (1, ''Unutrasnji'', 1, 1)';
    FDQuery1.ExecSQL;

    FDQuery1.SQL.Text :=
      'INSERT INTO boksevi (br, tip, kapacitet, dostupan) ' +
      'VALUES (2, ''Unutrasnji'', 1, 1)';
    FDQuery1.ExecSQL;

    FDQuery1.SQL.Text :=
      'INSERT INTO boksevi (br, tip, kapacitet, dostupan) ' +
      'VALUES (3, ''Spoljni'', 2, 1)';
    FDQuery1.ExecSQL;

    FDQuery1.SQL.Text :=
      'INSERT INTO boksevi (br, tip, kapacitet, dostupan) ' +
      'VALUES (4, ''Spoljni'', 1, 1)';
    FDQuery1.ExecSQL;
  end
  else
    FDQuery1.Close;


  FDQuery1.SQL.Text :=
    'INSERT OR IGNORE INTO kuponi (kod, popust, aktivan) ' +
    'VALUES (''POKSI10'', 0.10, 1)';
  FDQuery1.ExecSQL;


  LoadPetsFromDB;

  TNavFrames.Init(layHost);
  TNavFrames.Go(TFrame1.Create(nil));
end;

procedure TForm5.LoadPetsFromDB;
var
  Q: TFDQuery;
  i: Integer;
begin
  Q := TFDQuery.Create(nil);
  try
    Q.Connection := DB;
    Q.SQL.Text :=
      'SELECT id, name, species, breed, age, image_blob FROM pets ORDER BY id';
    Q.Open;
    i := 0;
    while (not Q.Eof) and (i <= High(Pets)) do
    begin
      Pets[i].Id       := Q.FieldByName('id').AsInteger;
      Pets[i].Name     := Q.FieldByName('name').AsString;
      Pets[i].Species  := Q.FieldByName('species').AsString;
      Pets[i].Breed    := Q.FieldByName('breed').AsString;
      Pets[i].Age      := Q.FieldByName('age').AsString;
      Pets[i].ImageBlob := Q.FieldByName('image_blob').AsBytes;
      Inc(i);
      Q.Next;
    end;
  finally
    Q.Free;
  end;
end;

end.

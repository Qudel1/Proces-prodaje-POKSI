unit fraUsluge;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Objects, FMX.Controls.Presentation, FMX.Layouts, FMX.Edit, FMX.ListBox,
  FireDAC.Comp.Client, uUserStore, uNavFrames;

type
  TServiceItem = record
    Id: Integer;
    Naziv: string;
    Kategorija: string;
    Cena: Double;
    Opis: string;
  end;

  TFrame6 = class(TFrame)
    Layout1: TLayout;
    Layout2: TLayout;
    Label1: TLabel;
    Image1: TImage;
    Image2: TImage;
    Rectangle1: TRectangle;
    Edit1: TEdit;
    Layout3: TLayout;
    HorzScrollBox1: THorzScrollBox;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    Layout4: TLayout;
    Label2: TLabel;
    GridLayout1: TGridLayout;
    Rectangle3: TRectangle;
    Rectangle4: TRectangle;
    Rectangle5: TRectangle;
    Rectangle6: TRectangle;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    ListBox1: TListBox;

    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Edit1Change(Sender: TObject);
    procedure ListBox1ItemClick(const Sender: TCustomListBox;
      const Item: TListBoxItem);
    procedure Image2Click(Sender: TObject);
    procedure Image3Click(Sender: TObject);
    procedure Image4Click(Sender: TObject);
    procedure FrameEnter(Sender: TObject);
    procedure Loaded; override;

  private
    FServices: array of TServiceItem;
    FActiveKategorija: string;

    procedure LoadServicesFromDB;
    procedure RefreshList;
    procedure RefreshGrid;
    procedure SetKategorija(const AKat: string);
    procedure OpenDetalji(AIdx: Integer);
  public
  end;

implementation

{$R *.fmx}

uses
  fraDetaljiUsluge, fraKorpa, fraHome, fraRezervacijaPocetak;


procedure TFrame6.LoadServicesFromDB;
begin
  SetLength(FServices, 6);

  FServices[0].Id := 1; FServices[0].Naziv := 'Super-premium granule';
  FServices[0].Kategorija := 'Hrana'; FServices[0].Cena := 13;
  FServices[0].Opis := 'Junior, 2 obroka dnevno';

  FServices[1].Id := 2; FServices[1].Naziv := 'Kupanje i nega dlake';
  FServices[1].Kategorija := 'Salon'; FServices[1].Cena := 28;
  FServices[1].Opis := 'Sa balzamom i susenjem';

  FServices[2].Id := 3; FServices[2].Naziv := 'Veterinarski pregled';
  FServices[2].Kategorija := 'Veterinar'; FServices[2].Cena := 40;
  FServices[2].Opis := 'Sa potvrdom o zdravstvenom stanju';

  FServices[3].Id := 4; FServices[3].Naziv := 'Osnovna dresura';
  FServices[3].Kategorija := 'Dresura'; FServices[3].Cena := 35;
  FServices[3].Opis := 'Sedni, lezi, idi, ostani - 60 min';

  FServices[4].Id := 5; FServices[4].Naziv := 'Sisanje dlake';
  FServices[4].Kategorija := 'Salon'; FServices[4].Cena := 22;
  FServices[4].Opis := 'Kompletno sisanje i finishing';

  FServices[5].Id := 6; FServices[5].Naziv := 'Premium obrok';
  FServices[5].Kategorija := 'Hrana'; FServices[5].Cena := 18;
  FServices[5].Opis := 'Senior formula, 3 obroka dnevno';
end;


procedure TFrame6.RefreshGrid;
var
  Cats: array[0..3] of string;
  MinCena: array[0..3] of Double;
  LblNaz: array[0..3] of TLabel;
  LblCena: array[0..3] of TLabel;
  i, j: Integer;
begin
  Cats[0] := 'Hrana';   Cats[1] := 'Salon';
  Cats[2] := 'Veterinar'; Cats[3] := 'Dresura';

  for i := 0 to 3 do MinCena[i] := 9999;

  for i := 0 to High(FServices) do
    for j := 0 to 3 do
      if (FServices[i].Kategorija = Cats[j]) and (FServices[i].Cena < MinCena[j]) then
        MinCena[j] := FServices[i].Cena;

  if not Assigned(Label3) then Exit;
  LblNaz[0]  := Label3;  LblNaz[1]  := Label5;
  LblNaz[2]  := Label7;  LblNaz[3]  := Label9;
  LblCena[0] := Label4;  LblCena[1] := Label6;
  LblCena[2] := Label8;  LblCena[3] := Label10;

  for i := 0 to 3 do
  begin
    if Assigned(LblNaz[i])  then LblNaz[i].Text  := Cats[i];
    if Assigned(LblCena[i]) then
    begin
      if MinCena[i] < 9999 then
        LblCena[i].Text := 'od $' + FormatFloat('0', MinCena[i])
      else
        LblCena[i].Text := '';
    end;
  end;
end;


procedure TFrame6.RefreshList;
var
  i: Integer;
  Item: TListBoxItem;
  LblC: TLabel;
begin
  if not Assigned(ListBox1) then Exit;
  ListBox1.BeginUpdate;
  try
    ListBox1.Clear;
    for i := 0 to High(FServices) do
    begin
      if (FActiveKategorija <> 'Sve') and (FServices[i].Kategorija <> FActiveKategorija) then
        Continue;
      if Assigned(Edit1) and (Edit1.Text <> '') then
        if Pos(LowerCase(Edit1.Text), LowerCase(FServices[i].Naziv)) = 0 then
          Continue;

      Item := TListBoxItem.Create(ListBox1);
      Item.Text := FServices[i].Naziv;
      Item.ItemData.Detail := FServices[i].Opis;
      Item.Tag := i;
      ListBox1.AddObject(Item);

      LblC := TLabel.Create(Item);
      LblC.Parent := Item;
      LblC.Align := TAlignLayout.Right;
      LblC.Width := 50;
      LblC.Margins.Right := 8;
      LblC.Text := '$' + FormatFloat('0.##', FServices[i].Cena);
      LblC.Font.Size := 13;
      LblC.Font.Style := [TFontStyle.fsBold];
      LblC.FontColor := $FFFFC107;
      LblC.TextSettings.HorzAlign := TTextAlign.Trailing;
      LblC.TextSettings.VertAlign := TTextAlign.Center;
    end;
  finally
    ListBox1.EndUpdate;
  end;
end;


procedure TFrame6.SetKategorija(const AKat: string);
begin
  FActiveKategorija := AKat;
  RefreshList;
end;


procedure TFrame6.OpenDetalji(AIdx: Integer);
var
  Fra: TfraDetaljiUsluge;
begin
  if (AIdx < 0) or (AIdx > High(FServices)) then Exit;
  Fra := TfraDetaljiUsluge.Create(nil);
  Fra.SetUsluga(
    FServices[AIdx].Id,
    FServices[AIdx].Naziv,
    FServices[AIdx].Kategorija,
    FServices[AIdx].Opis,
    FServices[AIdx].Cena
  );
  TNavFrames.Go(Fra);
end;


procedure TFrame6.Loaded;
begin
  inherited;
  FActiveKategorija := 'Sve';
  LoadServicesFromDB;
  RefreshList;
  RefreshGrid;
end;

procedure TFrame6.FrameEnter(Sender: TObject);
begin
  if FActiveKategorija = '' then
    FActiveKategorija := 'Sve';
  LoadServicesFromDB;
  if Assigned(ListBox1) then
    RefreshList;
  RefreshGrid;
end;


procedure TFrame6.Button1Click(Sender: TObject);
begin SetKategorija('Sve'); end;

procedure TFrame6.Button2Click(Sender: TObject);
begin SetKategorija('Hrana'); end;

procedure TFrame6.Button3Click(Sender: TObject);
begin SetKategorija('Salon'); end;

procedure TFrame6.Button4Click(Sender: TObject);
begin SetKategorija('Veterinar'); end;

procedure TFrame6.Button5Click(Sender: TObject);
begin SetKategorija('Dresura'); end;

procedure TFrame6.Edit1Change(Sender: TObject);
begin
  RefreshList;
end;

procedure TFrame6.ListBox1ItemClick(const Sender: TCustomListBox;
  const Item: TListBoxItem);
begin
  OpenDetalji(Item.Tag);
end;

procedure TFrame6.Image2Click(Sender: TObject);
begin
  TNavFrames.Go(TfraKorpa.Create(nil));
end;

procedure TFrame6.Image3Click(Sender: TObject);
begin
  TNavFrames.Go(TFrame5.Create(nil));
end;

procedure TFrame6.Image4Click(Sender: TObject);
begin
  TNavFrames.Go(TFrame9.Create(nil));
end;

end.

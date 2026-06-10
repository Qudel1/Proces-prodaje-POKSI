unit fraDetaljiUsluge;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Layouts, FMX.Objects, FMX.ScrollBox, FMX.Memo, FMX.Controls.Presentation,
  FMX.Memo.Types, uKorpa, uNavFrames;

type
  TOpcija = record
    Naziv: string;
    Cena: Double;
  end;

  TfraDetaljiUsluge = class(TFrame)
    layoutRoot: TLayout;
    layoutHeader: TLayout;
    lblBackArrow: TButton;
    lblTitle: TLabel;
    layoutFooter: TLayout;
    btnDodajUKorpu: TButton;
    vertScroll: TVertScrollBox;
    layoutIkona: TLayout;
    lblIkona: TLabel;
    lblNazivUsluge: TLabel;
    layoutRating: TLayout;
    lblUdaljenost: TLabel;
    lblRating: TLabel;
    lblCena: TLabel;
    lblOpisHeader: TLabel;
    lblOpisTekst: TLabel;
    lblDodatneOpcije: TLabel;
    rectOpcija1: TRectangle;
    lblOpcija1Text: TLabel;
    lblOpcija1Cena: TLabel;
    rectOpcija2: TRectangle;
    lblOpcija2Text: TLabel;
    lblOpcija2Cena: TLabel;
    rectOpcija3: TRectangle;
    lblOpcija3Text: TLabel;
    lblOpcija3Cena: TLabel;
    rectOpcija4: TRectangle;
    lblOpcija4Text: TLabel;
    lblOpcija4Cena: TLabel;
    lblPosebneNapomene: TLabel;
    memoNapomene: TMemo;

    procedure lblBackArrowClick(Sender: TObject);
    procedure btnDodajUKorpuClick(Sender: TObject);
    procedure rectOpcija1Click(Sender: TObject);
    procedure rectOpcija2Click(Sender: TObject);
    procedure rectOpcija3Click(Sender: TObject);
    procedure rectOpcija4Click(Sender: TObject);

  private
    FServiceId:   Integer;
    FNaziv:       string;
    FKategorija:  string;
    FBaseCena:    Double;
    FDodatakCena: Double;
    FOpcije:      array[0..3] of TOpcija;

    procedure RecalcCena;
    procedure ToggleOpcija(ARectangle: TRectangle; AOpcIdx: Integer);
    procedure PostaviOpcijeZaKategoriju(const AKat: string);
  public
    procedure SetUsluga(AId: Integer; const ANaziv, AKat, AOpisKrat: string;
      ACena: Double);
  end;

implementation

{$R *.fmx}

uses
  fraKorpa;

procedure TfraDetaljiUsluge.PostaviOpcijeZaKategoriju(const AKat: string);

  procedure SetOp(AIdx: Integer; const ANaz: string; ACena: Double);
  begin
    FOpcije[AIdx].Naziv := ANaz;
    FOpcije[AIdx].Cena  := ACena;
  end;

  procedure ApplyToRect(ARect: TRectangle; ALblTxt, ALblCena: TLabel; AIdx: Integer);
  begin
    if FOpcije[AIdx].Naziv = '' then
    begin
      ARect.Visible := False;
    end
    else
    begin
      ARect.Visible    := True;
      ALblTxt.Text     := FOpcije[AIdx].Naziv;
      if FOpcije[AIdx].Cena = 0 then
        ALblCena.Text  := '+$0'
      else
        ALblCena.Text  := '+$' + FormatFloat('0.##', FOpcije[AIdx].Cena);
    end;
  end;

begin
  SetOp(0, '', 0); SetOp(1, '', 0); SetOp(2, '', 0); SetOp(3, '', 0);

  if AKat = 'Salon' then
  begin
    SetOp(0, 'Sisanje dlake',         0);
    SetOp(1, 'Podsisavanje noktiju',  6);
    SetOp(2, 'Parfem za psa',         4);
    SetOp(3, 'Tretman protiv buva',  10);
  end
  else if AKat = 'Hrana' then
  begin
    SetOp(0, 'Obrok ujutru',          0);
    SetOp(1, 'Obrok u podne',         3);
    SetOp(2, 'Obrok uvece',           3);
    SetOp(3, 'Vitaminski dodatak',    5);
  end
  else if AKat = 'Veterinar' then
  begin
    SetOp(0, 'Osnovni pregled',       0);
    SetOp(1, 'Analiza krvi',         15);
    SetOp(2, 'Vakcinacija',          20);
    SetOp(3, 'Potvrda o zdravlju',    8);
  end
  else if AKat = 'Dresura' then
  begin
    SetOp(0, 'Osnovna komanda',       0);
    SetOp(1, 'Agility trening',      12);
    SetOp(2, 'Socijalizacija',        8);
    SetOp(3, 'Individualni trener',  20);
  end
  else
  begin
    SetOp(0, 'Osnovna usluga',        0);
    SetOp(1, 'Premium paket',        10);
  end;

  ApplyToRect(rectOpcija1, lblOpcija1Text, lblOpcija1Cena, 0);
  ApplyToRect(rectOpcija2, lblOpcija2Text, lblOpcija2Cena, 1);
  ApplyToRect(rectOpcija3, lblOpcija3Text, lblOpcija3Cena, 2);
  ApplyToRect(rectOpcija4, lblOpcija4Text, lblOpcija4Cena, 3);
end;


procedure TfraDetaljiUsluge.RecalcCena;
var
  Total: Double;
begin
  Total := FBaseCena + FDodatakCena;
  lblCena.Text := '$' + FormatFloat('0.##', Total);
  btnDodajUKorpu.Text :=
    'Dodaj u korpu ' + #8212 + ' $' + FormatFloat('0.##', Total);
end;


procedure TfraDetaljiUsluge.ToggleOpcija(ARectangle: TRectangle; AOpcIdx: Integer);
var
  Selektovan: Boolean;
begin
  Selektovan := ARectangle.Stroke.Kind = TBrushKind.Solid;
  if Selektovan then
  begin
    ARectangle.Stroke.Kind := TBrushKind.None;
    FDodatakCena := FDodatakCena - FOpcije[AOpcIdx].Cena;
  end
  else
  begin
    ARectangle.Stroke.Kind      := TBrushKind.Solid;
    ARectangle.Stroke.Color     := $FF4CAF50;
    ARectangle.Stroke.Thickness := 2;
    FDodatakCena := FDodatakCena + FOpcije[AOpcIdx].Cena;
  end;
  RecalcCena;
end;


procedure TfraDetaljiUsluge.SetUsluga(AId: Integer;
  const ANaziv, AKat, AOpisKrat: string; ACena: Double);
begin
  FServiceId   := AId;
  FNaziv       := ANaziv;
  FKategorija  := AKat;
  FBaseCena    := ACena;
  FDodatakCena := 0;

  lblNazivUsluge.Text := ANaziv;
  lblOpisTekst.Text   := AOpisKrat;

  rectOpcija1.Stroke.Kind := TBrushKind.None;
  rectOpcija2.Stroke.Kind := TBrushKind.None;
  rectOpcija3.Stroke.Kind := TBrushKind.None;
  rectOpcija4.Stroke.Kind := TBrushKind.None;

  PostaviOpcijeZaKategoriju(AKat);

  memoNapomene.Text := '';
  RecalcCena;
end;


procedure TfraDetaljiUsluge.lblBackArrowClick(Sender: TObject);
begin
  TNavFrames.Back;
end;

procedure TfraDetaljiUsluge.btnDodajUKorpuClick(Sender: TObject);
var
  TotalCena: Double;
begin
  TotalCena := FBaseCena + FDodatakCena;
  KorpaDodaj(FServiceId, FNaziv, FKategorija, TotalCena, memoNapomene.Text);
  TNavFrames.Back;
end;

procedure TfraDetaljiUsluge.rectOpcija1Click(Sender: TObject);
begin
  ToggleOpcija(rectOpcija1, 0);
end;

procedure TfraDetaljiUsluge.rectOpcija2Click(Sender: TObject);
begin
  ToggleOpcija(rectOpcija2, 1);
end;

procedure TfraDetaljiUsluge.rectOpcija3Click(Sender: TObject);
begin
  ToggleOpcija(rectOpcija3, 2);
end;

procedure TfraDetaljiUsluge.rectOpcija4Click(Sender: TObject);
begin
  ToggleOpcija(rectOpcija4, 3);
end;

end.

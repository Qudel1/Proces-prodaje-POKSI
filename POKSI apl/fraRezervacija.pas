unit fraRezervacija;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  System.DateUtils,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Layouts, FMX.Objects, FMX.ScrollBox, FMX.Controls.Presentation, FMX.Edit,
  uNavFrames, uKorpa, uUserStore;

type
  TfraRezervacija = class(TFrame)
    layoutRoot: TLayout;
    layoutHeader: TLayout;
    btnZatvori: TButton;
    lblTitle: TLabel;
    layoutFooter: TLayout;
    rectFooterBg: TRectangle;
    btnPlati: TButton;
    vertScroll: TVertScrollBox;
    lblLicniPodaci: TLabel;
    rectOdaberi: TRectangle;
    lblOdaberi: TLabel;
    lblOdaberiArrow: TLabel;
    lblNazivObjekta: TLabel;
    rectNazivObjekta: TRectangle;
    lblNazivObjektaVal: TLabel;
    lblLokacija: TLabel;
    rectLokacija: TRectangle;
    lblLokacijaVal: TLabel;
    lblOtvoriMapu: TLabel;
    lblIDKorisnika: TLabel;
    rectIDKorisnika: TRectangle;
    lblIDVal: TLabel;
    lblKontakt: TLabel;
    rectEmail: TRectangle;
    lblEmailVal: TLabel;
    rectPhone: TRectangle;
    lblPhoneVal: TLabel;
    lblDatumBoravka: TLabel;
    rectDolazak: TRectangle;
    lblDolazakVal: TLabel;
    lblIzaberiDatum1: TLabel;
    rectOdlazak: TRectangle;
    lblOdlazakVal: TLabel;
    lblIzaberiDatum2: TLabel;
    layoutSobeHeader: TLayout;
    lblSobeLjubimci: TLabel;
    lblSobePromeni: TLabel;
    rectBoks: TRectangle;
    lblBoksText: TLabel;
    lblBoksArrow: TLabel;
    rectLjubimci: TRectangle;
    lblLjubimciText: TLabel;
    lblLjubimciArrow: TLabel;
    layoutPlacanjeHeader: TLayout;
    lblPlacanje: TLabel;
    lblPlacanjePromeni: TLabel;
    rectMastercard: TRectangle;
    lblMastercardText: TLabel;
    rectVisa: TRectangle;
    lblVisaText: TLabel;
    rectKes: TRectangle;
    lblKesText: TLabel;
    layoutIznosiHeader: TLayout;
    rectDivider: TRectangle;
    layoutMedjutim: TLayout;
    lblMedjutimText: TLabel;
    lblMedjutimVal: TLabel;
    layoutNaziv: TLayout;
    lblNazivText: TLabel;
    layoutUkupno: TLayout;
    lblUkupnoText: TLabel;
    lblUkupnoVal: TLabel;

    procedure btnZatvoriClick(Sender: TObject);
    procedure btnPlatiClick(Sender: TObject);
    procedure rectDolazakClick(Sender: TObject);
    procedure rectOdlazakClick(Sender: TObject);
    procedure rectBoksClick(Sender: TObject);
    procedure rectLjubimciClick(Sender: TObject);
    procedure rectMastercardClick(Sender: TObject);
    procedure rectVisaClick(Sender: TObject);
    procedure rectKesClick(Sender: TObject);
    procedure rectOdaberiClick(Sender: TObject);
    procedure lblPlacanjePromeniClick(Sender: TObject);
    procedure Loaded; override;
    procedure FrameEnter(Sender: TObject);

  private
    FLblPopustVal: TLabel;
    procedure PopuniSve;
    procedure PopuniKorisnika;
    procedure PopuniDatume;
    procedure PopuniBoksLjubimca;
    procedure PopuniPlacanje;
    procedure PopuniIznose;
    procedure SelektujMetodu(const AMetoda: string);
  public
  end;

implementation

{$R *.fmx}

uses
  fraKalendar, fraUnutrasnjiB, fraDodavanjeKartice, fraPredracun, fraDodatneInf;


procedure TfraRezervacija.PopuniKorisnika;
var
  prikazIme: string;
begin
  if LoggedUserId > 0 then
  begin
    if LoggedUserIme <> '' then
      prikazIme := LoggedUserIme
    else
      prikazIme := LoggedUsername;

    lblOdaberi.Text  := prikazIme;
    lblIDVal.Text    := LoggedUserId.ToString;
    lblEmailVal.Text := 'Ime: ' + prikazIme;
    lblPhoneVal.Text := 'Br. telefona: ' + LoggedUserPhone;
  end
  else
  begin
    lblOdaberi.Text  := 'Odaberi';
    lblIDVal.Text    := '';
    lblEmailVal.Text := 'Ime:';
    lblPhoneVal.Text := 'Br. telefona:';
  end;

  lblNazivObjektaVal.Text := 'Pansion Poksi';

  lblLokacija.Visible := False;
  rectLokacija.Visible := False;
end;

procedure TfraRezervacija.PopuniDatume;
begin
  if KalendarDatumOd > 0 then
  begin
    lblDolazakVal.Text := FormatDateTime('dd/mm/yyyy', KalendarDatumOd);
    lblIzaberiDatum1.Text := 'Promeni';
  end
  else
  begin
    lblDolazakVal.Text := 'Dolazak';
    lblIzaberiDatum1.Text := 'Izaberi datum';
  end;

  if KalendarDatumDo > 0 then
  begin
    lblOdlazakVal.Text := FormatDateTime('dd/mm/yyyy', KalendarDatumDo);
    lblIzaberiDatum2.Text := 'Promeni';
  end
  else
  begin
    lblOdlazakVal.Text := 'Odlazak';
    lblIzaberiDatum2.Text := 'Izaberi datum';
  end;
end;

procedure TfraRezervacija.PopuniBoksLjubimca;
var
  vrsta, oznaka: string;
  ok: Boolean;
begin
  if IzabraniBoksText <> '' then
  begin
    vrsta := '';
    if (ActivePetIndex >= 0) and (ActivePetIndex <= High(Pets)) and
       (Pets[ActivePetIndex].Id <> 0) then
      vrsta := LowerCase(Pets[ActivePetIndex].Species);

    ok := True;
    if Pos('Unutra', IzabraniBoksText) > 0 then
    begin
      oznaka := Copy(IzabraniBoksText, Length(IzabraniBoksText) - 1, 2);
      oznaka := Trim(oznaka);
      if Length(oznaka) > 0 then
      begin
        if vrsta = 'guster' then
          ok := False
        else if (oznaka[1] = 'P') and (vrsta = 'macka') then
          ok := False
        else if (oznaka[1] = 'M') and (vrsta = 'pas') then
          ok := False;
      end;
    end;
    if not ok then
      IzabraniBoksText := '';
  end;

  if IzabraniBoksText <> '' then
    lblBoksText.Text := IzabraniBoksText
  else
    lblBoksText.Text := 'Izaberi boks';

  if (ActivePetIndex >= 0) and (ActivePetIndex <= High(Pets)) and
     (Pets[ActivePetIndex].Id <> 0) then
  begin
    RezervacijaPetIndex := ActivePetIndex;
    lblLjubimciText.Text := Pets[ActivePetIndex].Name + ' - ' + Pets[ActivePetIndex].Breed;
  end
  else
    lblLjubimciText.Text := 'Izaberi ljubimca';
end;

procedure TfraRezervacija.SelektujMetodu(const AMetoda: string);
begin
  TfraPlacanje_OdabranaMetoda := AMetoda;
  rectMastercard.Stroke.Kind := TBrushKind.Solid;
  rectMastercard.Stroke.Color := $FFE0E0E0;
  rectMastercard.Stroke.Thickness := 1;
  rectKes.Stroke.Kind := TBrushKind.Solid;
  rectKes.Stroke.Color := $FFE0E0E0;
  rectKes.Stroke.Thickness := 1;

  if AMetoda = 'Kes' then
  begin
    rectKes.Stroke.Color := $FF1C1C2E;
    rectKes.Stroke.Thickness := 2;
  end
  else
  begin
    rectMastercard.Stroke.Color := $FF1C1C2E;
    rectMastercard.Stroke.Thickness := 2;
  end;
end;

procedure TfraRezervacija.PopuniPlacanje;
begin
  rectVisa.Visible := False;

  if KarticaBroj <> '' then
    lblMastercardText.Text := 'Kartica koja se zavr' + #353 + 'ava na ' + CardEnding(KarticaBroj)
  else
    lblMastercardText.Text := 'Kartica';

  lblKesText.Text := 'Ke' + #353;

  if TfraPlacanje_OdabranaMetoda <> 'Kes' then
    TfraPlacanje_OdabranaMetoda := 'Kartica';

  SelektujMetodu(TfraPlacanje_OdabranaMetoda);
end;

procedure TfraRezervacija.PopuniIznose;
var
  Osnova, Popust, Porez, Ukupno: Double;
begin
  Osnova := KorpaUkupno;
  Popust := KorpaPopust(PromoKod);
  Porez  := (Osnova - Popust) * 0.10;
  Ukupno := Osnova - Popust + Porez;

  UkupanIznos := Ukupno;
  PrimenjeniPopust := Popust;

  lblMedjutimText.Text := 'Me' + #273 + 'uzbir';
  lblMedjutimVal.Text  := '$' + FormatFloat('0.00', Osnova);

  if Assigned(layoutNaziv) then
    layoutNaziv.Visible := True;
  if Assigned(lblNazivText) then
  begin
    lblNazivText.Text := 'Popust';
    lblNazivText.TextSettings.FontColor := $FF555555;
  end;

  if not Assigned(FLblPopustVal) then
  begin
    FLblPopustVal := TLabel.Create(Self);
    FLblPopustVal.Parent := layoutNaziv;
    FLblPopustVal.Align := TAlignLayout.Right;
    FLblPopustVal.Width := 100;
    FLblPopustVal.AutoSize := False;
    FLblPopustVal.Font.Size := 13;
    FLblPopustVal.FontColor := $FFE53935;
    FLblPopustVal.TextSettings.HorzAlign := TTextAlign.Trailing;
  end;
  if Popust > 0 then
    FLblPopustVal.Text := '-$' + FormatFloat('0.00', Popust)
  else
    FLblPopustVal.Text := '$0.00';

  lblUkupnoText.Text := 'Ukupno';
  lblUkupnoVal.Text  := '$' + FormatFloat('0.00', Ukupno);
end;

procedure TfraRezervacija.PopuniSve;
begin
  PopuniKorisnika;
  PopuniDatume;
  PopuniBoksLjubimca;
  PopuniPlacanje;
  PopuniIznose;
end;


procedure TfraRezervacija.Loaded;
begin
  inherited;
  PopuniSve;
end;

procedure TfraRezervacija.FrameEnter(Sender: TObject);
begin
  PopuniSve;
end;


procedure TfraRezervacija.btnZatvoriClick(Sender: TObject);
begin
  TNavFrames.Back;
end;

procedure TfraRezervacija.rectDolazakClick(Sender: TObject);
begin
  TNavFrames.Go(TfraKalendar.Create(nil));
end;

procedure TfraRezervacija.rectOdlazakClick(Sender: TObject);
begin
  TNavFrames.Go(TfraKalendar.Create(nil));
end;

procedure TfraRezervacija.rectBoksClick(Sender: TObject);
begin
  TNavFrames.Go(TfraUnutrasnjiB.Create(nil));
end;

procedure TfraRezervacija.rectOdaberiClick(Sender: TObject);
begin
  TNavFrames.Go(TfraDodatneInf.Create(nil));
end;

procedure TfraRezervacija.rectLjubimciClick(Sender: TObject);
begin
  if (ActivePetIndex >= 0) and (ActivePetIndex <= High(Pets)) and
     (Pets[ActivePetIndex].Id <> 0) then
    ShowMessage('Ljubimac se menja na po' + #269 + 'etnom ekranu rezervacije.')
  else
    ShowMessage('Prvo izaberite ljubimca na po' + #269 + 'etnom ekranu.');
end;

procedure TfraRezervacija.rectMastercardClick(Sender: TObject);
begin
  if TfraPlacanje_OdabranaMetoda = 'Kartica' then
    TNavFrames.Go(TfraDodavanjeKartice.Create(nil))
  else
    SelektujMetodu('Kartica');
end;

procedure TfraRezervacija.rectVisaClick(Sender: TObject);
begin
  SelektujMetodu('Kartica');
end;

procedure TfraRezervacija.rectKesClick(Sender: TObject);
begin
  SelektujMetodu('Kes');
end;

procedure TfraRezervacija.lblPlacanjePromeniClick(Sender: TObject);
begin
  TNavFrames.Go(TfraDodavanjeKartice.Create(nil));
end;

procedure TfraRezervacija.btnPlatiClick(Sender: TObject);
begin
  if KalendarDatumOd = 0 then
  begin
    ShowMessage('Izaberite datum dolaska.');
    Exit;
  end;
  if (ActivePetIndex < 0) or (ActivePetIndex > High(Pets)) or
     (Pets[ActivePetIndex].Id = 0) then
  begin
    ShowMessage('Izaberite ljubimca.');
    Exit;
  end;
  if IzabraniBoksText = '' then
  begin
    ShowMessage('Izaberite boks.');
    Exit;
  end;

  TNavFrames.Go(TfraPredracun.Create(nil));
end;

end.

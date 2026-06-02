unit fraDodatneInf;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Layouts, FMX.Objects, FMX.ScrollBox, FMX.Controls.Presentation, FMX.Edit,
  uNavFrames, uUserStore, FireDAC.Comp.Client;

type
  TfraDodatneInf = class(TFrame)
    layoutRoot: TLayout;
    layoutHeader: TLayout;
    btnZatvori: TButton;
    lblTitle: TLabel;
    vertScroll: TVertScrollBox;
    lblLicniPodaci: TLabel;
    lblIme: TLabel;
    rectIme: TRectangle;
    lblImeVal: TLabel;
    lblPrezime: TLabel;
    rectPrezime: TRectangle;
    lblPrezimeVal: TLabel;
    lblAdresa: TLabel;
    rectAdresa: TRectangle;
    lblAdresaVal: TLabel;
    lblIDKorisnika: TLabel;
    rectID: TRectangle;
    lblIDVal: TLabel;
    lblKontakt: TLabel;
    lblEmail: TLabel;
    rectEmail: TRectangle;
    lblEmailVal: TLabel;
    lblPhone: TLabel;
    rectPhone: TRectangle;
    lblPhoneVal: TLabel;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Edit5: TEdit;
    Edit6: TEdit;

    procedure btnZatvoriClick(Sender: TObject);
    procedure Loaded; override;
    procedure FrameEnter(Sender: TObject);

  private
    procedure PopuniPodatke;
    procedure SacuvajPromene;
  public
  end;

implementation

{$R *.fmx}

procedure TfraDodatneInf.PopuniPodatke;
begin
  if LoggedUserId = 0 then
  begin
    // Nema ulogovanog korisnika — prazna forma
    if Assigned(Edit1) then Edit1.Text := '';
    if Assigned(Edit2) then Edit2.Text := '';
    if Assigned(Edit3) then Edit3.Text := '';
    if Assigned(Edit5) then Edit5.Text := '';
    if Assigned(Edit6) then Edit6.Text := '';
    lblIDVal.Text    := '';
    lblEmailVal.Text := '';
    lblPhoneVal.Text := '';
    Exit;
  end;

  // Edit polja za izmenu
  // Edit1 = Username/Ime, Edit2 = Prezime (ako postoji), Edit3 = Adresa
  // Edit5 = Email, Edit6 = Telefon
  if Assigned(Edit1) then Edit1.Text := LoggedUserIme;
  if Assigned(Edit2) then Edit2.Text := LoggedUserPrezime;
  if Assigned(Edit3) then Edit3.Text := LoggedUserAdresa;
  if Assigned(Edit5) then Edit5.Text := LoggedUserEmail;
  if Assigned(Edit6) then Edit6.Text := LoggedUserPhone;

  // Read-only labele
  lblIDVal.Text    := LoggedUserId.ToString;
  lblEmailVal.Text := LoggedUserEmail;
  lblPhoneVal.Text := LoggedUserPhone;
end;

procedure TfraDodatneInf.SacuvajPromene;
var Q: TFDQuery;
begin
  if LoggedUserId = 0 then Exit;
  if not Assigned(Edit5) then Exit;

  Q := TFDQuery.Create(nil);
  try
    Q.Connection := DB;
    // Username se NIKAD ne menja ovde (jedinstven, koristi se za login).
    // Ime/prezime/adresa/email/telefon se cuvaju.
    Q.SQL.Text :=
      'UPDATE users SET ime = :im, email = :e, phone = :p, ' +
      'prezime = :pr, adresa = :ad WHERE id = :id';
    Q.ParamByName('im').AsString := Edit1.Text;
    Q.ParamByName('e').AsString  := Edit5.Text;
    Q.ParamByName('p').AsString  := Edit6.Text;
    Q.ParamByName('pr').AsString := Edit2.Text;
    Q.ParamByName('ad').AsString := Edit3.Text;
    Q.ParamByName('id').AsInteger := LoggedUserId;
    Q.ExecSQL;

    // Ažuriraj store (username ostaje netaknut!)
    LoggedUserIme     := Edit1.Text;
    LoggedUserEmail   := Edit5.Text;
    LoggedUserPhone   := Edit6.Text;
    LoggedUserPrezime := Edit2.Text;
    LoggedUserAdresa  := Edit3.Text;
  except
    on E: Exception do
      ShowMessage('Gre' + #353 + 'ka: ' + E.Message);
  end;
  Q.Free;
end;

procedure TfraDodatneInf.Loaded;
begin
  inherited;
  PopuniPodatke;
end;

procedure TfraDodatneInf.FrameEnter(Sender: TObject);
begin
  PopuniPodatke;
end;

procedure TfraDodatneInf.btnZatvoriClick(Sender: TObject);
begin
  SacuvajPromene;
  TNavFrames.Back;
end;

end.

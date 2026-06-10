unit fraLogin;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Edit, FMX.Objects, FMX.Controls.Presentation, FMX.Layouts, uNavFrames,
  fraForgot, fraRegister, FireDAC.Comp.Client, uUserStore, fraHome, fraRadnik;

type
  TFrame2 = class(TFrame)
    Layout1: TLayout;
    Label1: TLabel;
    rectCard: TRectangle;
    edtUsername: TEdit;
    edtPassword: TEdit;
    rectLoginButton: TRectangle;
    Label2: TLabel;
    lblForgot: TLabel;
    lbNoAcc: TLabel;
    lblRegister: TLabel;
    procedure lblForgotClick(Sender: TObject);
    procedure lblRegisterClick(Sender: TObject);
    procedure rectLoginButtonClick(Sender: TObject);
  private
  public
  end;

implementation

{$R *.fmx}

procedure TFrame2.lblForgotClick(Sender: TObject);
begin
  TNavFrames.Go(TFrame3.Create(nil));
end;

procedure TFrame2.lblRegisterClick(Sender: TObject);
begin
  TNavFrames.Go(TFrame4.Create(nil));
end;

procedure TFrame2.rectLoginButtonClick(Sender: TObject);
var
  Q: TFDQuery;
begin
  if Trim(edtUsername.Text) = '' then
  begin
    ShowMessage('Unesite korisni' + #269 + 'ko ime ili email');
    Exit;
  end;

  if Trim(edtPassword.Text) = '' then
  begin
    ShowMessage('Unesite lozinku');
    Exit;
  end;

  if (LowerCase(Trim(edtUsername.Text)) = 'admin') and (edtPassword.Text = 'admin') then
  begin
    UserStoreLoad(0, 'admin', 'admin@poksi.rs', '');
    SesijaResetuj;
    TNavFrames.Go(TfraRadnik.Create(nil));
    Exit;
  end;

  Q := TFDQuery.Create(nil);
  try
    Q.Connection := DB;
    Q.SQL.Text :=
      'SELECT id, username, email, phone, prezime, adresa, ime, ' +
      'kartica_broj, kartica_tip FROM users ' +
      'WHERE (lower(username) = lower(:u) OR lower(email) = lower(:u)) ' +
      'AND password = :p';
    Q.ParamByName('u').AsString := Trim(edtUsername.Text);
    Q.ParamByName('p').AsString := edtPassword.Text;
    Q.Open;

    if Q.IsEmpty then
    begin
      ShowMessage('Pogre' + #353 + 'an username/email ili lozinka');
      Exit;
    end;

    UserStoreLoad(
      Q.FieldByName('id').AsInteger,
      Q.FieldByName('username').AsString,
      Q.FieldByName('email').AsString,
      Q.FieldByName('phone').AsString
    );
    LoggedUserPrezime := Q.FieldByName('prezime').AsString;
    LoggedUserAdresa  := Q.FieldByName('adresa').AsString;
    LoggedUserIme     := Q.FieldByName('ime').AsString;
    KarticaBroj       := Q.FieldByName('kartica_broj').AsString;
    KarticaTip        := Q.FieldByName('kartica_tip').AsString;

    SesijaResetuj;

    TNavFrames.Go(TFrame5.Create(nil));

  except
    on E: Exception do
      ShowMessage('Gre' + #353 + 'ka: ' + E.Message);
  end;
  Q.Free;
end;

end.

unit fraDodavanjeKartice;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Layouts, FMX.Objects, FMX.ScrollBox, FMX.Controls.Presentation, FMX.Edit,
  FireDAC.Comp.Client, uNavFrames, uUserStore;

type
  TfraDodavanjeKartice = class(TFrame)
    layoutRoot: TLayout;
    layoutHeader: TLayout;
    btnZatvori: TButton;
    lblTitle: TLabel;
    layoutFooter: TLayout;
    rectFooterBg: TRectangle;
    btnNastavi: TButton;
    vertScroll: TVertScrollBox;
    lblOpis: TLabel;
    lblImeVlasnika: TLabel;
    rectImeVlasnika: TRectangle;
    editImeVlasnika: TEdit;
    lblCVV: TLabel;
    rectCVV: TRectangle;
    editCVV: TEdit;
    lblBanka: TLabel;
    rectBanka: TRectangle;
    editBanka: TEdit;
    lblBrojKartice: TLabel;
    rectBrojKartice: TRectangle;
    editBrojKartice: TEdit;
    lblBrojRacuna: TLabel;
    rectBrojRacuna: TRectangle;
    editBrojRacuna: TEdit;

    procedure btnZatvoriClick(Sender: TObject);
    procedure btnNastaviClick(Sender: TObject);
    procedure Loaded; override;
    procedure FrameEnter(Sender: TObject);
  private
    function PrepoznajTip(const ABroj: string): string;
    procedure Popuni;
  public
  end;

implementation

{$R *.fmx}

function TfraDodavanjeKartice.PrepoznajTip(const ABroj: string): string;
var clean: string; i: Integer;
begin
  clean := '';
  for i := 1 to Length(ABroj) do
    if CharInSet(ABroj[i], ['0'..'9']) then clean := clean + ABroj[i];
  // Vrlo gruba detekcija: 4 = Visa, 5 = Mastercard
  if (Length(clean) > 0) and (clean[1] = '4') then
    Result := 'Visa'
  else
    Result := 'Mastercard';
end;

procedure TfraDodavanjeKartice.Popuni;
begin
  // Ako kartica vec postoji, prikazi postojeci broj radi izmene
  if KarticaBroj <> '' then
    editBrojKartice.Text := KarticaBroj;
end;

procedure TfraDodavanjeKartice.Loaded;
begin
  inherited;
  Popuni;
end;

procedure TfraDodavanjeKartice.FrameEnter(Sender: TObject);
begin
  Popuni;
end;

procedure TfraDodavanjeKartice.btnZatvoriClick(Sender: TObject);
begin
  TNavFrames.Back;
end;

procedure TfraDodavanjeKartice.btnNastaviClick(Sender: TObject);
var
  Q: TFDQuery;
begin
  if Trim(editBrojKartice.Text) = '' then
  begin
    ShowMessage('Unesite broj kartice.');
    Exit;
  end;

  KarticaBroj := editBrojKartice.Text;
  KarticaTip  := PrepoznajTip(editBrojKartice.Text);
  // U rezervaciji imamo jednu opciju "Kartica"
  TfraPlacanje_OdabranaMetoda := 'Kartica';

  // Sacuvaj karticu za ovaj nalog (pamti se kao login)
  if LoggedUserId > 0 then
  begin
    Q := TFDQuery.Create(nil);
    try
      Q.Connection := DB;
      Q.SQL.Text :=
        'UPDATE users SET kartica_broj = :b, kartica_tip = :t WHERE id = :id';
      Q.ParamByName('b').AsString  := KarticaBroj;
      Q.ParamByName('t').AsString  := KarticaTip;
      Q.ParamByName('id').AsInteger := LoggedUserId;
      Q.ExecSQL;
    except
      on E: Exception do
        ShowMessage('Gre' + #353 + 'ka pri snimanju kartice: ' + E.Message);
    end;
    Q.Free;
  end;

  ShowMessage('Kartica sa' + #269 + 'uvana!');
  TNavFrames.Back;
end;

end.

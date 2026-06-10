unit fraSpoljasnjiBoksevi;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Layouts, FMX.Objects, FMX.ScrollBox, FMX.Controls.Presentation,
  uNavFrames, uUserStore;

type
  TfraSpoljasnjiBoksevi = class(TFrame)
    layoutRoot: TLayout;
    layoutHeader: TLayout;
    lblX: TButton;
    lblTitle: TLabel;
    lblHomeIkona: TButton;
    layoutFooter: TLayout;
    btnSacuvaj: TButton;
    vertScroll: TVertScrollBox;
    gridNBoksevi: TGridLayout;
    rectN0: TRectangle;
    lblN0: TLabel;
    rectN1: TRectangle;
    lblN1: TLabel;
    rectN2: TRectangle;
    lblN2: TLabel;
    rectN3: TRectangle;
    lblN3: TLabel;
    rectN4: TRectangle;
    lblN4: TLabel;
    rectN5: TRectangle;
    lblN5: TLabel;
    rectN6: TRectangle;
    lblN6: TLabel;
    rectN7: TRectangle;
    lblN7: TLabel;
    rectN8: TRectangle;
    lblN8: TLabel;
    rectN9: TRectangle;
    lblN9: TLabel;
    rectN10: TRectangle;
    lblN10: TLabel;
    rectN11: TRectangle;
    lblN11: TLabel;
    rectN12: TRectangle;
    lblN12: TLabel;
    rectN13: TRectangle;
    lblN13: TLabel;
    rectN14: TRectangle;
    lblN14: TLabel;
    rectN15: TRectangle;
    lblN15: TLabel;

    procedure lblXClick(Sender: TObject);
    procedure lblHomeIkonaClick(Sender: TObject);
    procedure btnSacuvajClick(Sender: TObject);
    procedure Loaded; override;

  private
    FZauzeti: array of string;
    FSelektovan: string;
    FRects: array of TRectangle;
    FLbls:  array of TLabel;

    function  JeZauzet(const AOznaka: string): Boolean;
    procedure StilBoks(ARect: TRectangle; ALbl: TLabel; const AOznaka: string);
    procedure RefreshBoksevi;
    procedure BoksKlik(Sender: TObject);
    procedure DodajBoks(ARect: TRectangle; ALbl: TLabel);
  public
  end;

implementation

{$R *.fmx}

uses
  fraUnutrasnjiB, fraRezervacija;

function TfraSpoljasnjiBoksevi.JeZauzet(const AOznaka: string): Boolean;
var i: Integer;
begin
  Result := False;
  for i := 0 to High(FZauzeti) do
    if FZauzeti[i] = AOznaka then Exit(True);
  if SesijaJeZauzet(AOznaka) then Exit(True);
end;

procedure TfraSpoljasnjiBoksevi.DodajBoks(ARect: TRectangle; ALbl: TLabel);
var n: Integer;
begin
  n := Length(FRects);
  SetLength(FRects, n + 1);
  SetLength(FLbls, n + 1);
  FRects[n] := ARect;
  FLbls[n]  := ALbl;
  ARect.OnClick := BoksKlik;
end;

procedure TfraSpoljasnjiBoksevi.StilBoks(ARect: TRectangle; ALbl: TLabel; const AOznaka: string);
begin
  ARect.XRadius := 8; ARect.YRadius := 8;
  ARect.Stroke.Kind := TBrushKind.None;
  if JeZauzet(AOznaka) then
  begin
    ARect.Fill.Color := $FFE53935;
    ALbl.FontColor := TAlphaColors.White;
    ARect.HitTest := False;
  end
  else if FSelektovan = AOznaka then
  begin
    ARect.Fill.Color := $FF1C1C2E;
    ALbl.FontColor := TAlphaColors.White;
    ARect.HitTest := True;
  end
  else
  begin
    ARect.Fill.Color := $FFE8E8E8;
    ALbl.FontColor := $FF333333;
    ARect.HitTest := True;
  end;
end;

procedure TfraSpoljasnjiBoksevi.RefreshBoksevi;
var i: Integer;
begin
  for i := 0 to High(FRects) do
    StilBoks(FRects[i], FLbls[i], FLbls[i].Text);
end;

procedure TfraSpoljasnjiBoksevi.BoksKlik(Sender: TObject);
var i: Integer; oznaka: string;
begin
  for i := 0 to High(FRects) do
    if FRects[i] = Sender then
    begin
      oznaka := FLbls[i].Text;
      if JeZauzet(oznaka) then Exit;
      FSelektovan := oznaka;
      IzabraniBoksText := 'Spolja' + #353 + 'nji ' + FSelektovan;
      TNavFrames.Back;
      Exit;
    end;
end;

procedure TfraSpoljasnjiBoksevi.Loaded;
begin
  inherited;
  FZauzeti := ['N3', 'N9'];
  FSelektovan := '';

  SetLength(FRects, 0);
  SetLength(FLbls, 0);
  DodajBoks(rectN0, lblN0);  DodajBoks(rectN1, lblN1);  DodajBoks(rectN2, lblN2);
  DodajBoks(rectN3, lblN3);  DodajBoks(rectN4, lblN4);  DodajBoks(rectN5, lblN5);
  DodajBoks(rectN6, lblN6);  DodajBoks(rectN7, lblN7);  DodajBoks(rectN8, lblN8);
  DodajBoks(rectN9, lblN9);  DodajBoks(rectN10, lblN10); DodajBoks(rectN11, lblN11);
  DodajBoks(rectN12, lblN12); DodajBoks(rectN13, lblN13); DodajBoks(rectN14, lblN14);
  DodajBoks(rectN15, lblN15);

  RefreshBoksevi;
end;

procedure TfraSpoljasnjiBoksevi.lblXClick(Sender: TObject);
begin
  TNavFrames.Back;
end;

procedure TfraSpoljasnjiBoksevi.lblHomeIkonaClick(Sender: TObject);
begin
  TNavFrames.GoReplace(TfraUnutrasnjiB.Create(nil));
end;

procedure TfraSpoljasnjiBoksevi.btnSacuvajClick(Sender: TObject);
begin
  if FSelektovan = '' then
  begin
    ShowMessage('Izaberite boks.');
    Exit;
  end;
  IzabraniBoksText := 'Spolja' + #353 + 'nji ' + FSelektovan;
  TNavFrames.Back;
end;

end.

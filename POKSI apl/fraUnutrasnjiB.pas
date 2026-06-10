unit fraUnutrasnjiB;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Layouts, FMX.Objects, FMX.ScrollBox, FMX.Controls.Presentation,
  uNavFrames, uUserStore;

type
  TfraUnutrasnjiB = class(TFrame)
    layoutRoot: TLayout;
    layoutHeader: TLayout;
    lblX: TButton;
    lblTitle: TLabel;
    lblHomeIkona: TButton;
    layoutFooter: TLayout;
    btnSacuvaj: TButton;
    vertScroll: TVertScrollBox;
    lblMackaP: TLabel;
    lblSekcijaPas: TLabel;
    gridPBoksevi: TGridLayout;
    rectP0: TRectangle;
    lblP0: TLabel;
    rectP1: TRectangle;
    lblP1: TLabel;
    rectP2: TRectangle;
    lblP2: TLabel;
    rectP3: TRectangle;
    lblP3: TLabel;
    rectP4: TRectangle;
    lblP4: TLabel;
    rectP5: TRectangle;
    lblP5: TLabel;
    rectP6: TRectangle;
    lblP6: TLabel;
    rectP7: TRectangle;
    lblP7: TLabel;
    rectP8: TRectangle;
    lblP8: TLabel;
    rectP9: TRectangle;
    lblP9: TLabel;
    lblMackaM: TLabel;
    lblSekcijaMacka: TLabel;
    gridMBoksevi: TGridLayout;
    rectM0: TRectangle;
    lblM0: TLabel;
    rectM1: TRectangle;
    lblM1: TLabel;
    rectM2: TRectangle;
    lblM2: TLabel;
    rectM3: TRectangle;
    lblM3: TLabel;
    rectM4: TRectangle;
    lblM4: TLabel;
    rectM5: TRectangle;
    lblM5: TLabel;
    rectM6: TRectangle;
    lblM6: TLabel;
    rectM7: TRectangle;
    lblM7: TLabel;
    rectM8: TRectangle;
    lblM8: TLabel;
    rectM9: TRectangle;
    lblM9: TLabel;

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
    function  DozvoljenBoks(const AOznaka: string): Boolean;
    procedure StilBoks(ARect: TRectangle; ALbl: TLabel; const AOznaka: string);
    procedure RefreshBoksevi;
    procedure BoksKlik(Sender: TObject);
    procedure DodajBoks(ARect: TRectangle; ALbl: TLabel);
  public
  end;

implementation

{$R *.fmx}

uses
  fraSpoljasnjiBoksevi, fraRezervacija;

function TfraUnutrasnjiB.JeZauzet(const AOznaka: string): Boolean;
var i: Integer;
begin
  Result := False;
  for i := 0 to High(FZauzeti) do
    if FZauzeti[i] = AOznaka then Exit(True);
  if SesijaJeZauzet(AOznaka) then Exit(True);
end;

function TfraUnutrasnjiB.DozvoljenBoks(const AOznaka: string): Boolean;
var vrsta: string;
begin
  vrsta := '';
  if (ActivePetIndex >= 0) and (ActivePetIndex <= High(Pets)) and
     (Pets[ActivePetIndex].Id <> 0) then
    vrsta := LowerCase(Pets[ActivePetIndex].Species);

  if vrsta = 'guster' then
    Exit(False);

  if (Length(AOznaka) > 0) and (AOznaka[1] = 'P') then
    Result := (vrsta = '') or (vrsta = 'pas')
  else if (Length(AOznaka) > 0) and (AOznaka[1] = 'M') then
    Result := (vrsta = '') or (vrsta = 'macka')
  else
    Result := True;
end;

procedure TfraUnutrasnjiB.DodajBoks(ARect: TRectangle; ALbl: TLabel);
var n: Integer;
begin
  n := Length(FRects);
  SetLength(FRects, n + 1);
  SetLength(FLbls, n + 1);
  FRects[n] := ARect;
  FLbls[n]  := ALbl;
  ARect.OnClick := BoksKlik;
end;

procedure TfraUnutrasnjiB.StilBoks(ARect: TRectangle; ALbl: TLabel; const AOznaka: string);
begin
  ARect.XRadius := 8; ARect.YRadius := 8;
  ARect.Stroke.Kind := TBrushKind.None;
  if JeZauzet(AOznaka) then
  begin
    ARect.Fill.Color := $FFE53935;
    ALbl.FontColor := TAlphaColors.White;
    ARect.HitTest := False;
  end
  else if not DozvoljenBoks(AOznaka) then
  begin
    ARect.Fill.Color := $FFF0F0F0;
    ALbl.FontColor := $FFBBBBBB;
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

procedure TfraUnutrasnjiB.RefreshBoksevi;
var i: Integer;
begin
  for i := 0 to High(FRects) do
    StilBoks(FRects[i], FLbls[i], FLbls[i].Text);
end;

procedure TfraUnutrasnjiB.BoksKlik(Sender: TObject);
var i: Integer; oznaka: string;
begin
  for i := 0 to High(FRects) do
    if FRects[i] = Sender then
    begin
      oznaka := FLbls[i].Text;
      if JeZauzet(oznaka) then Exit;

      if not DozvoljenBoks(oznaka) then
      begin
        ShowMessage('Ovaj boks nije za izabranog ljubimca.');
        Exit;
      end;

      FSelektovan := oznaka;
      IzabraniBoksText := 'Unutra' + #353 + 'nji ' + FSelektovan;
      TNavFrames.Back;
      Exit;
    end;
end;

procedure TfraUnutrasnjiB.Loaded;
begin
  inherited;
  FZauzeti := ['P3', 'P9', 'M1', 'M5'];
  FSelektovan := '';

  SetLength(FRects, 0);
  SetLength(FLbls, 0);
  DodajBoks(rectP0, lblP0); DodajBoks(rectP1, lblP1); DodajBoks(rectP2, lblP2);
  DodajBoks(rectP3, lblP3); DodajBoks(rectP4, lblP4); DodajBoks(rectP5, lblP5);
  DodajBoks(rectP6, lblP6); DodajBoks(rectP7, lblP7); DodajBoks(rectP8, lblP8);
  DodajBoks(rectP9, lblP9);
  DodajBoks(rectM0, lblM0); DodajBoks(rectM1, lblM1); DodajBoks(rectM2, lblM2);
  DodajBoks(rectM3, lblM3); DodajBoks(rectM4, lblM4); DodajBoks(rectM5, lblM5);
  DodajBoks(rectM6, lblM6); DodajBoks(rectM7, lblM7); DodajBoks(rectM8, lblM8);
  DodajBoks(rectM9, lblM9);

  RefreshBoksevi;
end;

procedure TfraUnutrasnjiB.lblXClick(Sender: TObject);
begin
  TNavFrames.Back;
end;

procedure TfraUnutrasnjiB.lblHomeIkonaClick(Sender: TObject);
begin
  TNavFrames.GoReplace(TfraSpoljasnjiBoksevi.Create(nil));
end;

procedure TfraUnutrasnjiB.btnSacuvajClick(Sender: TObject);
begin
  if FSelektovan = '' then
  begin
    ShowMessage('Izaberite boks.');
    Exit;
  end;
  IzabraniBoksText := 'Unutra' + #353 + 'nji ' + FSelektovan;
  TNavFrames.Back;
end;

end.

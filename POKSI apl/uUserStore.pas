unit uUserStore;

interface

uses
  System.SysUtils, System.Generics.Collections,
  FireDAC.Comp.Client, uPetModel;

var
  Pets: array[0..9] of TPet;
  ActivePetIndex: Integer = -1;
  DB: TFDConnection;
  LoggedUserId: Integer = 0;
  AktivnaKorpaId: Integer = 0;
  AktivnaRezervacijaId: Integer = 0;
  UkupanIznos: Double = 0;
  PrimenjeniPopust: Double = 0;
  KalendarDatumOd: TDateTime = 0;
  IzabraniUnutrasnjiId: Integer = 0;
  IzabraniSpoljasId: Integer = 0;
  KalendarDatumDo: TDateTime = 0;
  TfraPlacanje_OdabranaMetoda: string = 'Mastercard';

implementation

end.

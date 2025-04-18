program Besuchererfassung;

uses
  Vcl.Forms,
  uMain in 'uMain.pas' {fMain},
  uDBFunctions in 'uDBFunctions.pas',
  uAnmeldung in 'uAnmeldung.pas' {fAnmeldung},
  uBesuchererfassung in 'uBesuchererfassung.pas' {fBesuchererfassung},
  uChipkartenausgabe in 'uChipkartenausgabe.pas' {fChipkartenausgabe},
  uBenutzer in 'uBenutzer.pas' {fBenutzer},
  uFirstStart in 'uFirstStart.pas' {fFirstStart},
  uHilfe in 'uHilfe.pas' {fHilfe},
  uAusweisarten in 'uAusweisarten.pas' {fAusweisarten},
  uStaaten in 'uStaaten.pas' {fStaaten},
  uBesucheranmeldung in 'uBesucheranmeldung.pas' {fBesucheranmeldung},
  uBesuchersuche in 'uBesuchersuche.pas' {fBesuchersuche},
  uChipkartenruecknahme in 'uChipkartenruecknahme.pas' {fChipkartenruecknahme},
  uNewAusstellungsstaat in 'uNewAusstellungsstaat.pas' {fNewAusstellungsstaat},
  uAbout in 'uAbout.pas' {fAbout},
  uBesucheranmeldungEdit in 'uBesucheranmeldungEdit.pas' {fBesucheranmeldungEdit},
  uFunktionen in 'uFunktionen.pas',
  uBesucherdatenEdit in 'uBesucherdatenEdit.pas' {fBesucherdatenEdit},
  uChipkartenausgabeEdit in 'uChipkartenausgabeEdit.pas' {fChipkartenausgabeEdit},
  uPasswortabfrage in 'uPasswortabfrage.pas' {fPasswortabfrage},
  uSettings in 'uSettings.pas' {fSettings};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.Title := 'Besucherverwaltung';
  Application.CreateForm(TfMain, fMain);
  Application.CreateForm(TfAnmeldung, fAnmeldung);
  Application.CreateForm(TfBesuchererfassung, fBesuchererfassung);
  Application.CreateForm(TfChipkartenausgabe, fChipkartenausgabe);
  Application.CreateForm(TfBenutzer, fBenutzer);
  Application.CreateForm(TfFirstStart, fFirstStart);
  Application.CreateForm(TfHilfe, fHilfe);
  Application.CreateForm(TfAusweisarten, fAusweisarten);
  Application.CreateForm(TfStaaten, fStaaten);
  Application.CreateForm(TfBesucheranmeldung, fBesucheranmeldung);
  Application.CreateForm(TfBesuchersuche, fBesuchersuche);
  Application.CreateForm(TfChipkartenruecknahme, fChipkartenruecknahme);
  Application.CreateForm(TfNewAusstellungsstaat, fNewAusstellungsstaat);
  Application.CreateForm(TfAbout, fAbout);
  Application.CreateForm(TfBesucheranmeldungEdit, fBesucheranmeldungEdit);
  Application.CreateForm(TfBesucherdatenEdit, fBesucherdatenEdit);
  Application.CreateForm(TfChipkartenausgabeEdit, fChipkartenausgabeEdit);
  Application.CreateForm(TfPasswortabfrage, fPasswortabfrage);
  Application.CreateForm(TfSettings, fSettings);
  Application.Run;
end.

unit Cartons;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ComCtrls, Vcl.ImgList,
  Vcl.ExtCtrls, Vcl.TabNotBk, SpTBXItem, SpTBXControls, Vcl.Menus, INIFiles;


type
  TForm1 = class(TForm)
    Panel1: TPanel;
    ListView1: TListView;
    ClasseCombo: TComboBox;
    TabbedNotebook1: TTabbedNotebook;
    Panel2: TPanel;
    BouttonR: TButton;
    BoutonJ: TButton;
    BoutonV: TButton;
    Panel3: TPanel;
    BoutonSupprimer: TButton;
    BoutonAjouter: TButton;
    SpeedButton: TSpTBXSpeedButton;
    EditionClasse: TButton;
    Edit1: TEdit;
    SupprClasse: TButton;
    MoyenneR: TLabel;
    MoyenneV: TLabel;
    MoyenneJ: TLabel;
    Panel4: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    Vert: TLabel;
    Rouge: TLabel;
    Jaune: TLabel;
    procedure ListView1Compare(Sender: TObject; Item1, Item2: TListItem;
      Data: Integer; var Compare: Integer);
    procedure ListView1ColumnClick(Sender: TObject; Column: TListColumn);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BoutonVClick(Sender: TObject);
    procedure Panel2Resize(Sender: TObject);
    procedure BoutonJClick(Sender: TObject);
    procedure BouttonRClick(Sender: TObject);
    procedure ClasseComboChange(Sender: TObject);
    procedure Panel3Resize(Sender: TObject);
    procedure BoutonSupprimerClick(Sender: TObject);
    procedure BoutonAjouterClick(Sender: TObject);
    procedure SpeedButtonClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure Edit1Change(Sender: TObject);
    procedure EditionClasseClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure SupprClasseClick(Sender: TObject);
    procedure Panel4Resize(Sender: TObject);
  private
    { Déclarations privées }
    procedure CalculMoyenne;
    procedure SommesPoints;
  public
    { Déclarations publiques }
  end;

var
  Form1: TForm1;
  procedure parseValue(AValue: String; var Col0, Col1, Col2: String);
  procedure SaveToFile(AListView: TListView; AFileName: string);
  procedure LoadFromFile(AListView: TListView; AFileName: string);

implementation

{$R *.dfm}

uses Unit2;

var
  ColumnToSort: Integer;


procedure TForm1.BoutonAjouterClick(Sender: TObject);
var Item: TListItem;
begin
  Item := ListView1.Items.Add;
  Item.Caption := 'Nouvel élève';
  Item.SubItems.Add('0');
  Item.SubItems.Add('0');
  Item.SubItems.Add('0');
//  Item.Selected := true;
  Item.EditCaption;
  SaveToFile(ListView1, IntToStr(ClasseCombo.ItemIndex) + '.csv');
  CalculMoyenne;
  SommesPoints;
end;

procedure TForm1.BoutonJClick(Sender: TObject);
begin
  if ListView1.Selected <> nil then
    ListView1.Selected.SubItems[1] := IntToStr(StrToInt(ListView1.Selected.SubItems[1]) + 1);
    CalculMoyenne;
    SommesPoints;
end;

procedure TForm1.BoutonSupprimerClick(Sender: TObject);
begin
  if (ListView1.Selected <> nil)
  and (Vcl.Dialogs.MessageDlg('Etes-vous sûr de vouloir effacer ' + ListView1.Selected.Caption + ' ?', mtConfirmation, [mbYes, mbNo], 0, mbNo) = mrYes) then
    ListView1.Selected.Delete;
    CalculMoyenne;
    SommesPoints;

end;

procedure TForm1.BoutonVClick(Sender: TObject);
begin
  if ListView1.Selected <> nil then begin
    ListView1.Selected.SubItems[0] := IntToStr(StrToInt(ListView1.Selected.SubItems[0]) + 1);
    CalculMoyenne;
    SommesPoints;
  end;
end;

procedure TForm1.BouttonRClick(Sender: TObject);
begin
  if ListView1.Selected <> nil then begin
    ListView1.Selected.SubItems[2] := IntToStr(StrToInt(ListView1.Selected.SubItems[2]) + 1);
    CalculMoyenne;
    SommesPoints;
  end;
end;

procedure TForm1.SommesPoints;
var
    i: Integer;
    VertS: Integer;
    JauneS: Integer;
    RougeS: Integer;
    NbrsVert: Integer;
    NbrsJaune: Integer;
    NbrsRouge: Integer;
    PerCentVert: Integer;
    PerCentJaune: Integer;
    PerCentRouge: Integer;
begin
    VertS := 0;
    JauneS := 0;
    RougeS := 0;
    NbrsVert := 0;
    NbrsJaune := 0;
    NbrsRouge := 0;
    if ListView1.Items.Count <> 0 then
    begin
    for i := 0 to ListView1.Items.Count -1 do begin
        VertS := VertS + StrToInt(ListView1.Items[i].SubItems[0]);
        JauneS := JauneS + StrToInt(ListView1.Items[i].SubItems[1]);
        RougeS := RougeS + StrToInt(ListView1.Items[i].SubItems[2]);
        if StrToInt(ListView1.Items[i].SubItems[0]) <> 0 then
            NbrsVert := NbrsVert + 1;
        if StrToInt(ListView1.Items[i].SubItems[1]) <> 0 then
            NbrsJaune := NbrsJaune + 1;
        if StrToInt(ListView1.Items[i].SubItems[2]) <> 0 then
            NbrsRouge := NbrsRouge + 1;
    end;

    PerCentVert := (NbrsVert * 100) div ListView1.Items.Count;
    PerCentJaune := (NbrsJaune * 100) div ListView1.Items.Count;
    PerCentRouge := (NbrsRouge * 100) div ListView1.Items.Count;
    Vert.Caption := IntToStr(VertS) + ' Verts     '  + IntToStr(PerCentVert) + '%' + ' des élèves ont des Verts';
    Jaune.Caption := IntToStr(JauneS) + ' Jaunes      ' + IntToStr(PerCentJaune) + '%' + ' des élèves ont des Jaunes';
    Rouge.Caption := IntToStr(RougeS) + ' Rouges      ' + IntToStr(PerCentRouge) + '%' + ' des élèves ont des Rouges';
end;
end;

procedure TForm1.CalculMoyenne;
var
    SommeVerte: Integer;
    SommeJaune: Integer;
    SommeRouge: Integer;
    MoyenneVerte: Real;
    MoyenneJaune: Real;
    MoyenneRouge: Real;
    i: Integer;
begin
    for i := 0 to Listview1.Items.Count -1 do
  begin
      Label2.Caption := IntToStr(ListView1.Items.Count) + ' élèves';
      if StrToInt(ListView1.Items[i].SubItems[0]) <> 0 then
      SommeVerte := SommeVerte +1;
      if StrToInt(ListView1.Items[i].SubItems[1]) <> 0 then
      SommeJaune := SommeJaune +1;
      if StrToInt(ListView1.Items[i].SubItems[2]) <> 0 then
      SommeRouge := SommeRouge +1;
      MoyenneV.Caption := IntToStr(SommeVerte)  + '/' + IntToStr(ListView1.Items.Count);
      MoyenneJ.Caption := IntToStr(SommeJaune)  + '/' + IntToStr(ListView1.Items.Count);
      MoyenneR.Caption := IntToStr(SommeRouge)  + '/' + IntToStr(ListView1.Items.Count);
  end;

end;

procedure TForm1.ClasseComboChange(Sender: TObject);
begin
  if ClasseCombo.Tag >= 0 then
    begin
      SaveToFile(ListView1, ClasseCombo.Items[ClasseCombo.Tag] + '.csv' );
    end;
  LoadFromFile(ListView1, ClasseCombo.Items[ClasseCombo.ItemIndex] + '.csv' );
  ClasseCombo.Tag := ClasseCombo.ItemIndex;
  SupprClasse.Enabled := true;
  CalculMoyenne;
  SommesPoints;
  Label2.Left := Panel4.Width div 2 - Label2.Width div 2;
  Jaune.Left := Panel4.Width div 2 - Jaune.Width div 2;



end;

procedure TForm1.Edit1Change(Sender: TObject);
begin
    editionclasse.Enabled := true;
end;

procedure TForm1.EditionClasseClick(Sender: TObject);
begin
    ClasseCombo.Items.Add( Edit1.Text );
    SaveToFile(ListView1, IntToStr(ClasseCombo.ItemIndex) + '.csv');
    ClasseCombo.ItemIndex := ClasseCombo.Items.Count -1;
    SaveToFile(ListView1, ( Edit1.Text + '.csv' ));
    ClasseComboChange(Sender);
    LoadFromFile(ListView1, ExtractFilePath(Application.ExeName) + Edit1.Text + '.csv' );
    ListView1.Items.Clear;
    CalculMoyenne;
    SommesPoints;
    Edit1.Text := '';
    SupprClasse.Enabled := true;
end;
procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
var
  Ini: TIniFile;
begin
  try
    Ini := TIniFile.Create(ChangeFileExt( Application.ExeName, '.INI' ));

    Ini.WriteInteger('Position', 'Left', Form1.Left);
    Ini.WriteInteger('Position', 'Top', Form1.Top);
    Ini.WriteInteger('Position', 'Width', Form1.Width);
    Ini.WriteInteger('Position', 'Height', Form1.Height);
    SaveToFile(ListView1, ChangeFileExt( ClasseCombo.Items[ClasseCombo.ItemIndex], '.csv' ));
    ClasseCombo.Items.SaveToFile( 'Classes.txt');
  finally
  Ini.Free;
  end;
end;

procedure TForm1.FormResize(Sender: TObject);
begin
   SpeedButton.Left := Form1.Width - SpeedButton.Width - SpeedButton.Width div 2 + 3;
   SpeedButton.Top := Panel4.Top - SpeedButton.Height;
end;

procedure TForm1.FormShow(Sender: TObject);
var
  Ini: TIniFile;
begin
  Ini := TIniFile.Create(ChangeFileExt( Application.ExeName, '.INI' ));
  try
    Form1.Left := Ini.ReadInteger('Position', 'Left', Form1.Left);
    Form1.Top := Ini.ReadInteger('Position', 'Top', Form1.Top);
    Form1.Width := Ini.ReadInteger('Position', 'Width', Form1.Width);
    Form1.Height := Ini.ReadInteger('Position', 'Height', Form1.Height);
  finally
    Ini.Free;
  end;

  ClasseCombo.Items.LoadFromFile( 'Classes.txt' );
end;

procedure TForm1.ListView1ColumnClick(Sender: TObject; Column: TListColumn);
begin
  ColumnToSort := Column.Index;
  (Sender as TCustomListView).AlphaSort;
  CalculMoyenne;
  SommesPoints;

end;

procedure TForm1.ListView1Compare(Sender: TObject; Item1, Item2: TListItem;
  Data: Integer; var Compare: Integer);
var
  ix: integer;
begin
  if ColumnToSort = 0 then
    Compare := CompareText(Item1.Caption,Item2.Caption)
  else begin
   ix := ColumnToSort - 1;
   Compare := -CompareText(Item1.SubItems[ix],Item2.SubItems[ix]);
  end;
end;

procedure TForm1.Panel2Resize(Sender: TObject);
begin
  BoutonJ.Left := Panel1.Width div 2 - BoutonJ.Width div 2;
  MoyenneJ.Left := Panel1.Width div 2 - MoyenneJ.Width div 2;
  MoyenneR.Left := BouttonR.Left - 39;
  MoyenneV.Left := BoutonV.Left + 79;
  CalculMoyenne;
  SommesPoints;

end;

procedure TForm1.Panel3Resize(Sender: TObject);
begin
  BoutonSupprimer.Left := Panel3.Width div 3 - BoutonSupprimer.Width div 2;
  BoutonAjouter.Left := Panel3.Width - Panel3.Width div 3 - BoutonAjouter.Width div 2;
  editionclasse.Left := Panel1.Width div 2 - editionclasse.Width div 2;
  Edit1.Left := Panel1.Width div 2 - Edit1.Width div 2;
  SupprClasse.Left := Panel1.Width div 2 - SupprClasse.Width div 2;
  CalculMoyenne;
  SommesPoints;


end;

procedure TForm1.Panel4Resize(Sender: TObject);
begin
    Label1.Left := Panel4.Width div 2 - Label1.Width div 2;
    Label2.Left := Panel4.Width div 2 - Label2.Width div 2;
    Jaune.Left := Panel4.Width div 2 - Jaune.Width div 2;
    CalculMoyenne;
    SommesPoints;
end;

procedure TForm1.SpeedButtonClick(Sender: TObject);
begin
    Form2.Show;
    CalculMoyenne;
    SommesPoints;

end;

procedure TForm1.SupprClasseClick(Sender: TObject);
begin
    if (Vcl.Dialogs.MessageDlg('Etes-vous sûr de vouloir effacer cette classe ?' , mtConfirmation, [mbYes, mbNo], 0, mbNo) = mrYes) then
        begin
            ListView1.Items.Clear;
            ClasseCombo.Items.Delete(ClasseCombo.ItemIndex);
            CalculMoyenne;
            SommesPoints;

        end;
end;

procedure LoadFromFile(AListView: TListView; AFileName: string);
var
 I : Integer;
 SL: TStringList;
 Item: TListItem;
 Col0, Col1, Col2: String;
begin
  SL:= TStringList.Create;
  try
    SL.LoadFromFile(AFileName);
    AListView.Items.BeginUpdate;
    AListView.Items.Clear;
    for I:=  0 to SL.Count - 1 do begin
      if SL.Names[I] <> '' then begin
        Item:= AlistView.Items.Add;
        Item.Caption:= SL.Names[I];
        parseValue(SL.ValueFromIndex[I], Col0, Col1, Col2);
        Item.SubItems.Add(Col0);
        Item.SubItems.Add(Col1);
        Item.SubItems.Add(Col2);
      end;
    end;
    AListView.Items.EndUpdate;
  finally
   SL.Free;
  end;
end;

procedure SaveToFile(AListView: TListView; AFileName: string);
var
 I: Integer;
 SL: TStringList;
begin
 SL:= TStringList.Create;
 for I := 0 to AListView.Items.Count - 1 do
 begin
  SL.Add(AlistView.Items[I].Caption + '=' +
         AlistView.Items[I].SubItems[0] + ',' +
         AlistView.Items[I].SubItems[1] + ',' +
         AlistView.Items[I].SubItems[2])
 end;
 try
  SL.SaveToFile(AFileName);
 finally
   SL.Free;
 end;
end;

 procedure parseValue(AValue: String; var Col0, Col1, Col2: String);
 var
  I: Integer;
  S: String;
  L: TStringList;
 begin
  L:= TStringList.Create;
  try
  for I:= 1 to length(AValue) do
  begin
   if AValue[I] <> ',' then
    S:= S + AValue[I]
   else
   begin
    L.Add(S);
    S:= '';
   end;
  end;
  L.Add(S);
  Col0:= L[0];
  Col1:= L[1];
  Col2:= L[2];
  finally
   L.Free;
  end;
 end;
end.

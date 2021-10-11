unit Unitmain;

//////////////////////////////
// Dark Skull Software      //
// http://www.darkskull.net //
//////////////////////////////

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, ExtCtrls;

const
  DEGCOLORS = 100; // nombre de couleurs pour le dégradé
  
type
  TFormMain = class(TForm)
    GroupBoxColors: TGroupBox;
    ListBoxColors: TListBox;
    GroupBoxGradient: TGroupBox;
    PaintBox: TPaintBox;
    GroupBoxResult: TGroupBox;
    ButtonAdd: TButton;
    ButtonDel: TButton;
    ButtonModify: TButton;
    MemoResult: TMemo;
    ColorDialog: TColorDialog;
    GroupBoxParams: TGroupBox;
    LabelResult: TLabel;
    EditText: TEdit;
    GroupBoxApercu: TGroupBox;
    RichEditPreview: TRichEdit;
    CheckBoxBold: TCheckBox;
    CheckBoxItalic: TCheckBox;
    CheckBoxUnderline: TCheckBox;
    CheckBoxStrikeOut: TCheckBox;
    procedure PaintBoxPaint(Sender: TObject);
    procedure ButtonAddClick(Sender: TObject);
    procedure ListBoxColorsDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure ListBoxColorsClick(Sender: TObject);
    procedure ButtonDelClick(Sender: TObject);
    procedure ButtonModifyClick(Sender: TObject);
    procedure EditTextChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure CheckBoxClick(Sender: TObject);
  private
    { Déclarations privées }
    procedure DeleteColor(const index: integer);
    procedure UpdateListBox;
    procedure BuildGradient;
    procedure GenerateText;
  public
    { Déclarations publiques }
    // composantes du dégradé
    Red:   array[0..DEGCOLORS-1] of byte;
    Green: array[0..DEGCOLORS-1] of byte;
    Blue:  array[0..DEGCOLORS-1] of byte;
    // couleurs choisies par l'utilisateur
    DefinedColors: array of TColor;
  end;

var
  FormMain: TFormMain;

implementation

{$R *.dfm}

// Affiche le code HTML en Hexa d'une couleur
function RGBToHex(const c: TColor): string;
begin
  Result := IntToHex(GetRValue(c), 2)
          + IntToHex(GetGValue(c), 2)
          + IntToHex(GetBValue(c), 2);
end;

procedure TFormMain.DeleteColor(const index: integer);
var
  i: integer;
begin
  for i := index to (Length(DefinedColors) - 2) do
    begin
      DefinedColors[i] := DefinedColors[i + 1];
    end;
  SetLength(DefinedColors, Length(DefinedColors) - 1);
end;

procedure TFormMain.UpdateListBox;
var
  i: integer;
begin
  ListboxColors.Clear;
  if Length(DefinedColors) > 0 then
    begin
      for i := 0 to Pred(Length(DefinedColors)) do
        begin
          ListBoxColors.Items.Add(RGBToHex(DefinedColors[i]));
        end;
    end;
end;


procedure TFormMain.PaintBoxPaint(Sender: TObject);
var
  i: integer;
begin
  if Length(DefinedColors) = 0 then
    begin
      PaintBox.Canvas.Brush.Color := clBlack;
      PaintBox.Canvas.FillRect(PaintBox.ClientRect);
    end
  else if Length(DefinedColors) = 1 then
    begin
      PaintBox.Canvas.Brush.Color := DefinedColors[0];
      PaintBox.Canvas.FillRect(PaintBox.ClientRect);
    end
  else
    begin
      for i := 0 to DEGCOLORS-1 do
        begin
          PaintBox.Canvas.Pen.Color := rgb(Red[i], Green[i], Blue[i]);
          PaintBox.Canvas.MoveTo(i, 0);
          PaintBox.Canvas.LineTo(i, PaintBox.ClientHeight);
        end;
    end;
end;

procedure TFormMain.ButtonAddClick(Sender: TObject);
var
  l: integer;
begin
  // on ajoute une couleur
  if ColorDialog.Execute then
    begin
      l := Length(DefinedColors);
      SetLength(DefinedColors, l + 1);
      DefinedColors[l] := ColorDialog.Color;
      UpdateListBox;
      BuildGradient;
      PaintBoxPaint(PaintBox);
      GenerateText;      
    end;
end;

procedure TFormMain.ListBoxColorsDrawItem(Control: TWinControl;
  Index: Integer; Rect: TRect; State: TOwnerDrawState);
var
  L: TListbox;
begin
  // on récupère la listbox
  L :=(Control as TListBox);
  // on efface le fond
  if odSelected in State then
    begin
      L.Canvas.Brush.Color := clHighlight;
      L.Canvas.Pen.Color := clHighlightText;
    end
  else
    begin
      L.Canvas.Brush.Color := clWindow;
      L.Canvas.Pen.Color := clWindowText;
    end;
  L.Canvas.FillRect(Rect);
  // on dessine la couleur
  L.Canvas.Brush.Color := DefinedColors[Index];
  L.Canvas.Rectangle(Rect.Left + 3, Rect.Top + 2, Rect.Left + 18, Rect.Bottom - 2);
  // on affiche le texte
  if odSelected in State then
    begin
      L.Canvas.Brush.Color := clHighlight;
      L.Canvas.Font.Color := clHighlightText;
    end
  else
    begin
      L.Canvas.Brush.Color := clWindow;
      L.Canvas.Font.Color := clWindowText;
    end;
  L.Canvas.TextOut(Rect.Left + 25, Rect.Top + 1, L.Items[Index]);
end;

procedure TFormMain.ListBoxColorsClick(Sender: TObject);
var
  b: boolean;
begin
  b := not (ListBoxColors.ItemIndex = (-1));
  ButtonDel.Enabled := b;
  ButtonModify.Enabled := b;
end;

procedure TFormMain.ButtonDelClick(Sender: TObject);
begin
  DeleteColor(ListBoxColors.ItemIndex);
  UpdateListBox;
  BuildGradient;
  PaintBoxPaint(PaintBox);
  GenerateText;  
  ButtonDel.Enabled := false;
  ButtonModify.Enabled := false;
end;

procedure TFormMain.ButtonModifyClick(Sender: TObject);
begin
  ColorDialog.Color := DefinedColors[ListBoxColors.ItemIndex];
  if ColorDialog.Execute then
    begin
      DefinedColors[ListBoxColors.ItemIndex] := ColorDialog.Color;
      UpdateListBox;
      BuildGradient;
      PaintBoxPaint(PaintBox);
      GenerateText;      
      ButtonDel.Enabled := false;
      ButtonModify.Enabled := false;
    end;
end;

procedure TFormMain.BuildGradient;
var
  nbcol: integer;   // nombre de couleurs
  subsize: integer; // nombre de couleurs par dégradé
  i, j: integer;
  // couleurs aux extrémités
  r1, g1, b1: byte;
  r2, g2, b2: byte;
begin
  nbcol := Length(DefinedColors);
  if (nbcol = 0) then exit;
  if (nbcol = 1) then exit;
  subsize := DEGCOLORS div (nbcol - 1);
  for i := 0 to (nbcol - 2) do
    begin
      r1 := GetRValue(DefinedColors[i]);
      g1 := GetGValue(DefinedColors[i]);
      b1 := GetBValue(DefinedColors[i]);
      r2 := GetRValue(DefinedColors[i + 1]);
      g2 := GetGValue(DefinedColors[i + 1]);
      b2 := GetBValue(DefinedColors[i + 1]);
      for j := 0 to pred(subsize) do
        begin
          Red[i * subsize + j]   := Round(r1 + (r2 - r1) * j / subsize);
          Green[i * subsize + j] := Round(g1 + (g2 - g1) * j / subsize);
          Blue[i * subsize + j]  := Round(b1 + (b2 - b1) * j / subsize);
        end;
    end;
  for i := (subsize * (nbcol - 1)) to Pred(DEGCOLORS) do
    begin
      Red[i] := GetRValue(DefinedColors[nbcol - 1]);
      Green[i] := GetGValue(DefinedColors[nbcol - 1]);
      Blue[i] := GetBValue(DefinedColors[nbcol - 1]);
    end;
end;

procedure TFormMain.GenerateText;
var
  i: integer;        // variable de parcours
  ltext: integer;    // longueur du texte
  nbcolors: integer; // nombre de couleurs
  icolor: integer;   // indice de la couleur utilisée
  col: TColor;       // couleur
begin
  MemoResult.Text := '';
  RichEditPreview.Text := '';
  nbcolors := Length(DefinedColors);
  ltext := Length(EditText.Text);
  // paramètres de début
  if CheckBoxBold.Checked then MemoResult.Text := MemoResult.Text + '<b>';
  if CheckBoxItalic.Checked then MemoResult.Text := MemoResult.Text + '<i>';
  if CheckBoxUnderline.Checked then MemoResult.Text := MemoResult.Text + '<u>';
  if CheckBoxStrikeOut.Checked then MemoResult.Text := MemoResult.Text + '<strike>';
  // paramètres du RichEdit
  RichEditPreview.DefAttributes.Style := [];
  if CheckBoxBold.Checked then RichEditPreview.DefAttributes.Style := RichEditPreview.DefAttributes.Style + [fsBold];
  if CheckBoxItalic.Checked then RichEditPreview.DefAttributes.Style := RichEditPreview.DefAttributes.Style + [fsItalic];
  if CheckBoxUnderLine.Checked then RichEditPreview.DefAttributes.Style := RichEditPreview.DefAttributes.Style + [fsUnderline];
  if CheckBoxStrikeOut.Checked then RichEditPreview.DefAttributes.Style := RichEditPreview.DefAttributes.Style + [fsStrikeOut];
  // le texte
  if (nbcolors = 0) then
    begin
      MemoResult.Text := MemoResult.Text + EditText.Text;
      RichEditPreview.DefAttributes.Color := clWindowText;
      RichEditPreview.Lines.Text := EditText.Text;
    end
  else if (nbcolors = 1) then
    begin
      MemoResult.Text := MemoResult.Text + '<font color="#' + RGBToHex(DefinedColors[0]) + '">' + EditText.Text + '</font>';
      RichEditPreview.DefAttributes.Color := Definedcolors[0];
      RichEditPreview.Text := EditText.Text;
    end
  else
    begin
      RichEditPreview.DefAttributes.Color := DefinedColors[0];
      for i := 1 to ltext do
        begin
          icolor := Round(i / ltext * DEGCOLORS) - 1;
          col := rgb(Red[icolor], Green[icolor], Blue[icolor]);
          MemoResult.Text := MemoResult.Text + '<font color="#' + RGBToHex(col) + '">' + EditText.Text[i] + '</font>';
          RichEditPreview.SelText := EditText.Text[i];
          if not (i = 1) then RichEditPreview.SelAttributes.Color := col;
        end;
    end;
  // paramètres de fin
  if CheckBoxBold.Checked then MemoResult.Text := MemoResult.Text + '</b>';
  if CheckBoxItalic.Checked then MemoResult.Text := MemoResult.Text + '</i>';
  if CheckBoxUnderline.Checked then MemoResult.Text := MemoResult.Text + '</u>';
  if CheckBoxStrikeOut.Checked then MemoResult.Text := MemoResult.Text + '</strike>';
end;

procedure TFormMain.EditTextChange(Sender: TObject);
begin
  GenerateText;
end;

procedure TFormMain.FormCreate(Sender: TObject);
begin
  GenerateText;
end;

procedure TFormMain.CheckBoxClick(Sender: TObject);
begin
  GenerateText;
end;

end.

object FormMain: TFormMain
  Left = 227
  Top = 132
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'HTML Fade'
  ClientHeight = 514
  ClientWidth = 495
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -14
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 120
  TextHeight = 16
  object GroupBoxColors: TGroupBox
    Left = 0
    Top = 0
    Width = 326
    Height = 169
    Caption = ' Color choise '
    TabOrder = 0
    object ListBoxColors: TListBox
      Left = 10
      Top = 20
      Width = 168
      Height = 139
      Style = lbOwnerDrawFixed
      ItemHeight = 16
      TabOrder = 0
      OnClick = ListBoxColorsClick
      OnDrawItem = ListBoxColorsDrawItem
    end
    object ButtonAdd: TButton
      Left = 207
      Top = 30
      Width = 92
      Height = 30
      Caption = 'Ajouter'
      Default = True
      TabOrder = 1
      OnClick = ButtonAddClick
    end
    object ButtonDel: TButton
      Left = 207
      Top = 69
      Width = 92
      Height = 31
      Caption = 'Supprimer'
      Enabled = False
      TabOrder = 2
      OnClick = ButtonDelClick
    end
    object ButtonModify: TButton
      Left = 207
      Top = 108
      Width = 92
      Height = 31
      Caption = 'Modifier'
      Enabled = False
      TabOrder = 3
      OnClick = ButtonModifyClick
    end
  end
  object GroupBoxGradient: TGroupBox
    Left = 335
    Top = 0
    Width = 159
    Height = 169
    Caption = ' Gradient '
    TabOrder = 1
    object PaintBox: TPaintBox
      Left = 20
      Top = 30
      Width = 123
      Height = 123
      OnPaint = PaintBoxPaint
    end
  end
  object GroupBoxResult: TGroupBox
    Left = 0
    Top = 294
    Width = 494
    Height = 123
    Caption = ' Result '
    TabOrder = 2
    object MemoResult: TMemo
      Left = 10
      Top = 20
      Width = 474
      Height = 93
      ReadOnly = True
      TabOrder = 0
    end
  end
  object GroupBoxParams: TGroupBox
    Left = 0
    Top = 176
    Width = 494
    Height = 111
    Caption = ' Params '
    TabOrder = 3
    object LabelResult: TLabel
      Left = 10
      Top = 20
      Width = 40
      Height = 16
      Caption = 'Texte :'
    end
    object EditText: TEdit
      Left = 59
      Top = 20
      Width = 425
      Height = 24
      TabOrder = 0
      Text = 'Delphi Sources . RU - Delphi Sources . RU - Delphi Sources . RU'
      OnChange = EditTextChange
    end
    object CheckBoxBold: TCheckBox
      Left = 128
      Top = 59
      Width = 119
      Height = 21
      Caption = 'Gras'
      TabOrder = 1
      OnClick = CheckBoxClick
    end
    object CheckBoxItalic: TCheckBox
      Left = 128
      Top = 79
      Width = 119
      Height = 21
      Caption = 'Italique'
      TabOrder = 2
      OnClick = CheckBoxClick
    end
    object CheckBoxUnderline: TCheckBox
      Left = 354
      Top = 59
      Width = 120
      Height = 21
      Caption = 'Souligne'
      TabOrder = 3
      OnClick = CheckBoxClick
    end
    object CheckBoxStrikeOut: TCheckBox
      Left = 354
      Top = 79
      Width = 120
      Height = 21
      Caption = 'Barre'
      TabOrder = 4
      OnClick = CheckBoxClick
    end
  end
  object GroupBoxApercu: TGroupBox
    Left = 0
    Top = 422
    Width = 494
    Height = 89
    Caption = ' Sample '
    TabOrder = 4
    object RichEditPreview: TRichEdit
      Left = 10
      Top = 20
      Width = 474
      Height = 60
      ReadOnly = True
      TabOrder = 0
    end
  end
  object ColorDialog: TColorDialog
    Left = 16
    Top = 24
  end
end

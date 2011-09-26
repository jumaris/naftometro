object Form1: TForm1
  Left = 365
  Top = 114
  Width = 764
  Height = 563
  Caption = 'Form1'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object pbM: TPaintBox
    Left = 0
    Top = 0
    Width = 563
    Height = 525
    Align = alClient
    OnPaint = pbMPaint
  end
  object Panel1: TPanel
    Left = 563
    Top = 0
    Width = 185
    Height = 525
    Align = alRight
    TabOrder = 0
    object lbl1: TLabel
      Left = 16
      Top = 8
      Width = 32
      Height = 13
      Caption = #1044#1083#1080#1085#1072
    end
    object lbl2: TLabel
      Left = 48
      Top = 200
      Width = 85
      Height = 13
      Caption = #1053#1072#1082#1083#1086#1085' (* 0,001)'
    end
    object lbl3: TLabel
      Left = 16
      Top = 112
      Width = 36
      Height = 13
      Caption = #1056#1072#1076#1080#1091#1089
    end
    object lbl4: TLabel
      Left = 104
      Top = 112
      Width = 24
      Height = 13
      Caption = #1059#1075#1086#1083
    end
    object lbl5: TLabel
      Left = 96
      Top = 8
      Width = 54
      Height = 13
      Caption = 'Id '#1089#1090#1072#1085#1094#1080#1080
    end
    object lbl6: TLabel
      Left = 32
      Top = 272
      Width = 112
      Height = 13
      Caption = #1044#1083#1080#1085#1072' '#1082#1072#1084#1077#1088#1099' '#1089#1098#1077#1079#1076#1072
    end
    object lbl7: TLabel
      Left = 104
      Top = 368
      Width = 71
      Height = 13
      Caption = #1053#1072#1087#1088#1072#1074#1083#1077#1085#1080#1077':'
    end
    object btn1: TButton
      Left = 16
      Top = 48
      Width = 147
      Height = 25
      Caption = #1055#1088#1103#1084#1086#1081' '#1091#1095#1072#1089#1090#1086#1082
      TabOrder = 0
      OnClick = btn1Click
    end
    object edt1: TEdit
      Left = 8
      Top = 24
      Width = 73
      Height = 21
      TabOrder = 1
      Text = '0'
    end
    object btn2: TButton
      Left = 40
      Top = 152
      Width = 105
      Height = 25
      Caption = #1055#1086#1074#1086#1088#1086#1090
      TabOrder = 2
      OnClick = btn2Click
    end
    object edt3: TEdit
      Left = 8
      Top = 128
      Width = 73
      Height = 21
      TabOrder = 3
      Text = '0'
    end
    object edt4: TEdit
      Left = 96
      Top = 128
      Width = 73
      Height = 21
      TabOrder = 4
      Text = '0'
    end
    object btn3: TButton
      Left = 56
      Top = 440
      Width = 75
      Height = 25
      Caption = #1042' '#1092#1072#1081#1083'!'
      TabOrder = 5
      OnClick = btn3Click
    end
    object btn4: TButton
      Left = 32
      Top = 480
      Width = 123
      Height = 33
      Caption = #1054#1090#1084#1077#1085#1080#1090#1100' '#1087#1086#1089#1083#1077#1076#1085#1077#1077'!!!'
      TabOrder = 6
      OnClick = btn4Click
    end
    object se1: TSpinEdit
      Left = 32
      Top = 216
      Width = 121
      Height = 22
      MaxValue = 60
      MinValue = -60
      TabOrder = 7
      Value = 0
    end
    object Edit1: TEdit
      Left = 96
      Top = 24
      Width = 73
      Height = 21
      TabOrder = 8
      Text = '0'
    end
    object edt2: TEdit
      Left = 8
      Top = 296
      Width = 73
      Height = 21
      TabOrder = 9
      Text = '0'
    end
    object btn5: TButton
      Left = 96
      Top = 296
      Width = 75
      Height = 25
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100
      TabOrder = 10
      OnClick = btn5Click
    end
    object se2: TSpinEdit
      Left = 8
      Top = 368
      Width = 81
      Height = 22
      MaxValue = 0
      MinValue = 0
      TabOrder = 11
      Value = 0
    end
    object btn6: TButton
      Left = 8
      Top = 392
      Width = 81
      Height = 25
      Caption = #1042#1099#1073#1088#1072#1090#1100' '#1090#1086#1095#1082#1091
      TabOrder = 12
      OnClick = btn6Click
    end
    object rb1: TRadioButton
      Left = 96
      Top = 384
      Width = 113
      Height = 17
      Caption = #1042#1087#1077#1088#1105#1076
      Checked = True
      TabOrder = 13
      TabStop = True
      OnClick = rb1Click
    end
    object rb2: TRadioButton
      Left = 96
      Top = 400
      Width = 113
      Height = 17
      Caption = #1053#1072#1079#1072#1076
      TabOrder = 14
      OnClick = rb2Click
    end
  end
end

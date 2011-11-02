object MainForm: TMainForm
  Left = 434
  Top = 35
  Width = 882
  Height = 594
  Caption = #1053#1072#1092#1090#1086#1084#1077#1090#1088#1086
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -14
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Icon.Data = {
    0000010001002020100000000000E80200001600000028000000200000004000
    0000010004000000000080020000000000000000000000000000000000000000
    000000008000008000000080800080000000800080008080000080808000C0C0
    C0000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF000000
    0000070000000000007000000000000000001111111111111111000000000000
    0000007000000000070000000000000000000070000000000700000000000000
    0000011111111111111000000000000000000007000000007000000000000000
    0000000700000000700000000000000000000001111111111000000000000000
    0007777777777777777770000000000000CCCCCCCCCCCCCCCCCCCC0000000000
    0CCCCCCCCCCCCCCCCCCCCCC000000000CCCCCCCCCCCCCCCCCCCCCCCC00000000
    CCCCBBCCCCCCCCCCCCBBCCCC00000000CCCCBBCCCCCCCCCCCCBBCCCC00000000
    CCCCCCCCCCCCCCCCCCCCCCCC00000000CCCCCCCCCCCCCCCCCCCCCCCC00000000
    CCCC0000000CC0000000CCCC00000000CCCC0000000CC0000000CCCC00000000
    CCCC0000000CC0000000CCCC00000000CCCC0000000CC0000000CCCC00000000
    CCCC0000000CC0000000CCCC00000000CCCCCCCCCCCCCCCCCCCCCCCC00000000
    CCCCCCCCCCCCCCCCCCCCCCCC00000000CCCCCCCCBBCBBCBBCCCCCCCC00000000
    CCCCCCCCBBCBBCBBCCCCCCCC00000000CCCCCCCCCCCCCCCCCCCCCCCC00000000
    0CCCCCCCCCCCCCCCCCCCCCC00000000000CCCCCCCCCCCCCCCCCCCC0000000000
    0000000000000000000000000000000000000000000000000000000000000000
    0000000000000000000000000000000000000000000000000000000000000000
    0000000000000000000000000000000000000000000000000000000000000000
    0000000000000000000000000000000000000000000000000000000000000000
    0000000000000000000000000000000000000000000000000000000000000000
    000000000000000000000000000000000000000000000000000000000000}
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnResize = FormResize
  PixelsPerInch = 120
  TextHeight = 16
  object Vp: TPanel
    Left = 0
    Top = 0
    Width = 874
    Height = 150
    Align = alTop
    TabOrder = 0
    object MPODZ: TMediaPlayer
      Left = 20
      Top = 59
      Width = 307
      Height = 37
      AutoOpen = True
      FileName = 'media/odz.mp3'
      Visible = False
      TabOrder = 0
    end
    object mmoLoadProg: TMemo
      Left = 20
      Top = 10
      Width = 218
      Height = 178
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -28
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
      Visible = False
    end
  end
  object Bp: TPanel
    Left = 630
    Top = 150
    Width = 244
    Height = 412
    Align = alRight
    TabOrder = 1
    Visible = False
    object Vl: TLabel
      Left = 10
      Top = 20
      Width = 75
      Height = 24
      Caption = 'Velocity'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -18
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Cl: TLabel
      Left = 10
      Top = 138
      Width = 52
      Height = 24
      Caption = 'Coord'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -18
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object RL: TLabel
      Left = 10
      Top = 167
      Width = 64
      Height = 24
      Caption = 'Ruchka'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -18
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object PL: TLabel
      Left = 10
      Top = 197
      Width = 75
      Height = 24
      Caption = 'Pressure'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -18
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object LK: TLabel
      Left = 10
      Top = 226
      Width = 39
      Height = 24
      Caption = 'Kran'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -18
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object AOS: TLabel
      Left = 10
      Top = 502
      Width = 212
      Height = 25
      Caption = ' '#1040#1054#1057' '#1040#1082#1090#1080#1074#1080#1088#1086#1074#1072#1085#1072'! '
      Color = clRed
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clYellow
      Font.Height = -20
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentColor = False
      ParentFont = False
      Visible = False
    end
    object RevL: TLabel
      Left = 10
      Top = 256
      Width = 43
      Height = 24
      Caption = 'RevL'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -18
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object LimL: TLabel
      Left = 10
      Top = 49
      Width = 38
      Height = 24
      Caption = 'Limit'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -18
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object LFlim: TLabel
      Left = 10
      Top = 79
      Width = 79
      Height = 24
      Caption = 'Futurelim'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -18
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object ALS: TLabel
      Left = 10
      Top = 473
      Width = 212
      Height = 25
      Caption = ' '#1040#1051#1057'-'#1040#1056#1057' '#1085#1077#1075#1086#1076#1091#1077#1090'! '
      Color = clRed
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clYellow
      Font.Height = -20
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentColor = False
      ParentFont = False
      Visible = False
    end
    object LabelStrelka: TLabel
      Left = 10
      Top = 346
      Width = 24
      Height = 26
      Caption = '<--'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -23
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object LT: TLabel
      Left = 10
      Top = 108
      Width = 43
      Height = 24
      Caption = 'Time'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -18
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object LabelPause: TLabel
      Left = 10
      Top = 315
      Width = 52
      Height = 24
      Caption = #1055#1072#1091#1079#1072
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -18
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      Visible = False
    end
    object LabelI: TLabel
      Left = 10
      Top = 286
      Width = 50
      Height = 24
      Caption = 'LabelI'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -18
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object RP: TLabel
      Left = 10
      Top = 532
      Width = 178
      Height = 25
      Caption = ' '#1056#1077#1083#1077' '#1087#1077#1088#1075#1088#1091#1079#1082#1080'! '
      Color = clRed
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clYellow
      Font.Height = -20
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentColor = False
      ParentFont = False
      Visible = False
    end
    object Label2: TLabel
      Left = 10
      Top = 384
      Width = 50
      Height = 24
      Caption = 'LabelI'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -18
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object Label3: TLabel
      Left = 10
      Top = 414
      Width = 50
      Height = 24
      Caption = 'LabelI'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -18
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object Label4: TLabel
      Left = 10
      Top = 443
      Width = 50
      Height = 24
      Caption = 'LabelI'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -18
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
  end
  object Mp: TPanel
    Left = 0
    Top = 150
    Width = 630
    Height = 412
    Align = alClient
    TabOrder = 2
    object btnStart: TBitBtn
      Left = 69
      Top = 49
      Width = 218
      Height = 61
      Caption = #1053#1072#1095#1072#1090#1100' '#1080#1075#1088#1091
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -23
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      OnClick = btnStartClick
    end
    object mmoKeys: TMemo
      Left = 543
      Top = 20
      Width = 385
      Height = 424
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -23
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      Lines.Strings = (
        'W - '#1088#1077#1074#1077#1088#1089' '#1074#1087#1077#1088#1105#1076
        'S - '#1088#1077#1074#1077#1088#1089' '#1085#1072#1079#1072#1076
        'A - '#1091#1084#1077#1085#1100#1096#1077#1085#1080#1077' '#1056#1059#1055
        'D - '#1091#1074#1077#1083#1080#1095#1077#1085#1080#1077' '#1056#1059#1055
        'B - '#1059#1084#1077#1085#1100#1096#1080#1090#1100' '#1089#1074#1077#1090' '#1092#1072#1088
        'N - '#1059#1074#1077#1083#1080#1095#1080#1090#1100' '#1089#1074#1077#1090' '#1092#1072#1088
        'M - '#1055#1077#1088#1077#1074#1077#1089#1090#1080' '#1089#1090#1088#1077#1083#1082#1091
        'P - '#1055#1072#1091#1079#1072
        'Esc - '#1074#1099#1093#1086#1076' '#1074' '#1084#1077#1085#1102
        'O - '#1054#1073#1098#1103#1074#1083#1077#1085#1080#1077' '#1074' '#1089#1072#1083#1086#1085
        'K - '#1059#1084#1077#1085#1100#1096#1080#1090#1100' '#1087#1085#1077#1074#1084#1086#1090#1086#1088#1084#1086#1079
        'L - '#1059#1074#1077#1083#1080#1095#1080#1090#1100' '#1087#1085#1077#1074#1084#1086#1090#1086#1088#1084#1086#1079
        '; - '#1069#1082#1089#1090#1088#1077#1085#1085#1086#1077' '#1090#1086#1088#1084#1086#1078#1077#1085#1080#1077
        'C - '#1057#1084#1077#1085#1072' '#1082#1072#1073#1080#1085#1099)
      ParentFont = False
      TabOrder = 1
      Visible = False
    end
    object btnKeys: TButton
      Left = 69
      Top = 148
      Width = 218
      Height = 60
      Caption = #1059#1087#1088#1072#1074#1083#1077#1085#1080#1077
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -23
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 2
      OnClick = btnKeysClick
    end
    object btnAutors: TButton
      Left = 69
      Top = 246
      Width = 218
      Height = 60
      Caption = #1040#1074#1090#1086#1088#1099' '#1080#1075#1088#1099
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -23
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 3
      OnClick = btnAutorsClick
    end
    object mmoAutors: TMemo
      Left = 543
      Top = 20
      Width = 385
      Height = 454
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -23
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      Lines.Strings = (
        #1056#1091#1082#1086#1074#1086#1076#1080#1090#1077#1083' '#1087#1088#1086#1077#1082#1090#1072
        #1043#1083#1072#1074#1085#1099#1081' '#1073#1099#1076#1083#1086#1087#1088#1086#1075#1077#1088
        #1048#1042#1040#1053' '#1044#1040#1042#1067#1044#1054#1042
        ''
        #1053#1077#1087#1086#1089#1088#1077#1076#1089#1090#1074#1077#1085#1085#1099#1077' '#1087#1086#1084#1086#1097#1085#1080#1082#1080
        #1041#1059#1056#1071#1050#1054#1042' '#1052#1048#1061#1040#1048#1051
        #1054#1051#1045#1043' '#1050#1056#1059#1058#1050#1048#1053
        #1056#1059#1057#1051#1040#1053' '#1050#1054#1058#1059#1053#1054#1042
        #1050#1048#1056#1048#1051#1051' '#1050#1054#1047#1051#1054#1042
        ''
        #1054#1090#1076#1077#1083#1100#1085#1086#1077' '#1089#1087#1072#1089#1080#1073#1086
        'http://subwaytalks.ru'
        ''
        #1057#1072#1081#1090' '#1087#1088#1086#1077#1082#1090#1072
        'http://sdusi.ru/?prj=19')
      ParentFont = False
      TabOrder = 4
      Visible = False
    end
  end
  object TiPhys: TTimer
    Interval = 20
    OnTimer = TiPhysTimer
    Left = 45
    Top = 8
  end
  object TiPaint: TTimer
    Interval = 20
    OnTimer = TiPaintTimer
    Left = 13
    Top = 8
  end
end

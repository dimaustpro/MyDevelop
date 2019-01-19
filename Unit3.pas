unit Unit3;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls, FMX.Memo,
  ClientModuleUnit1, FMX.Controls.Presentation, DBXJSON, System.JSON, Datasnap.DSCommon,
  FMX.ScrollBox, FMX.Edit, AndroidApi.JNI.Media, System.IOUtils,
  FMX.TabControl;

type
  TMyCallback = class(TDBXCallback)
  public
    function Execute(const Arg: TJSONValue): TJSONValue; override;
  end;

  TForm3 = class(TForm)
    DSClientCallbackChannelManager1: TDSClientCallbackChannelManager;
    MemoLog: TMemo;
    ButtonBroadcast: TButton;
    EditMsg: TEdit;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ButtonBroadcastClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormSaveState(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
  private
    { Private declarations }
    FMyCallbackName:string;
    procedure QueueLogMsg(const s:string);
    procedure Beep();
  public
    { Public declarations }
    procedure LogMsg(const s:string);
  end;

var
  Form3: TForm3;
  ToneGenerator: JToneGenerator;

implementation
uses DSProxy; // for “TDSTunnelSession”
         //uses DSProxy; // <- for “TDSAdminClient”


{$R *.fmx}
{$R *.LgXhdpiPh.fmx ANDROID}
{$R *.Windows.fmx MSWINDOWS}

procedure TForm3.Button1Click(Sender: TObject);
begin
  ClientModule1.ServerMethods1Client.LogString('button 1');
end;

procedure TForm3.Button2Click(Sender: TObject);
begin
  ClientModule1.ServerMethods1Client.LogString('button 2');
end;

procedure TForm3.ButtonBroadcastClick(Sender: TObject);
var AClient: TDSAdminClient;
begin
  AClient := TDSAdminClient.Create(ClientModule1.SQLConnection1.DBXConnection);
  try
    AClient.BroadcastToChannel(
      DSClientCallbackChannelManager1.ChannelName,
      TJSONString.Create(EditMsg.Text)
    );
  finally
    AClient.Free;
  end;
end;

procedure TForm3.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  inherited;
  {$IFDEF ANDROID}
  if assigned(ToneGenerator) then
    ToneGenerator.release;
  {$ENDIF}
end;

procedure TForm3.FormCreate(Sender: TObject);
var
  R: TBinaryReader;
begin
  DSClientCallbackChannelManager1.ManagerId :=
    TDSSessionHelper.GenerateSessionId;

  FMyCallbackName :=
    TDSSessionHelper.GenerateSessionId;

  DSClientCallbackChannelManager1.RegisterCallback(
    FMyCallbackName,
    TMyCallback.Create
  );

  SaveState.StoragePath := TPath.GetHomePath;
  if SaveState.Stream.Size > 0 then
  begin
    // Recover previously typed text in Edit1 control.
    R := TBinaryReader.Create(SaveState.Stream);
    try
      EditMsg.Text := R.ReadString;
    finally
      R.Free;
    end;
  end;
end;

procedure TForm3.FormSaveState(Sender: TObject);
var
  W: TBinaryWriter;
begin
  SaveState.Stream.Clear;
  // Current state is only saved when something was edited.
  // If nothing has changed, the state will be removed this way.
  if EditMsg.Text.Length > 0 then
  begin
    // Save typed text in Edit1 control.
    W := TBinaryWriter.Create(SaveState.Stream);
    try
      W.Write(EditMsg.Text);
    finally
      W.Free;
    end;
  end;
end;

procedure TForm3.FormShow(Sender: TObject);
begin
  inherited;
  {$IFDEF ANDROID}
  ToneGenerator:=nil;
  {$ENDIF}
  //TabControl1.TabIndex:=0;
  //timer1.Enabled:=true;
end;

{ TMyCallback }

function TMyCallback.Execute(const Arg: TJSONValue): TJSONValue;
begin
  Form3.QueueLogMsg(Arg.ToString);
  Form3.beep();
  Result := TJSONTrue.Create;
end;

procedure TForm3.QueueLogMsg(const s: string);
begin
  TThread.Queue(nil,
    procedure
    begin
      Form3.LogMsg(s)
    end
  );
end;

procedure TForm3.Timer1Timer(Sender: TObject);
begin
  //TabControl1.TabIndex:=1;
  //Timer1.Enabled:=false;
  EditMsg.Text:='TEST';
  Form3.ButtonBroadcastClick(Form3);
end;

procedure TForm3.LogMsg(const s: string);
begin
  MemoLog.Lines.Add(DateTimeToStr(Now) + ': ' + s);
end;

procedure TForm3.beep;
var
  Volume: Integer;
  StreamType: Integer;
  ToneType: Integer;
begin
  {$IFDEF ANDROID}
  if not assigned(ToneGenerator) then
  begin
    Volume:= TJToneGenerator.JavaClass.MAX_VOLUME; // çàäàåì ãðîìêîñòü
    StreamType:= TJAudioManager.JavaClass.STREAM_NOTIFICATION;
    ToneType:= TJToneGenerator.JavaClass.TONE_CDMA_ABBR_ALERT; // òèï çâóêà
    ToneGenerator:= TJToneGenerator.JavaClass.init(StreamType, Volume);
  end;
  ToneGenerator.startTone(ToneType,500);
  {$ENDIF}
end;
end.

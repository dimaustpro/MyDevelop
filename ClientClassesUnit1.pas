// 
// Created by the DataSnap proxy generator.
// 07.01.2019 15:32:47
// 

unit ClientClassesUnit1;

interface

uses System.JSON, Data.DBXCommon, Data.DBXClient, Data.DBXDataSnap, Data.DBXJSON, Datasnap.DSProxy, System.Classes, System.SysUtils, Data.DB, Data.SqlExpr, Data.DBXDBReaders, Data.DBXCDSReaders, Data.DBXJSONReflect;

type
  TServerMethods1Client = class(TDSAdminClient)
  private
    FEchoStringCommand: TDBXCommand;
    FReverseStringCommand: TDBXCommand;
    FLogStringCommand: TDBXCommand;
  public
    constructor Create(ADBXConnection: TDBXConnection); overload;
    constructor Create(ADBXConnection: TDBXConnection; AInstanceOwner: Boolean); overload;
    destructor Destroy; override;
    function EchoString(Value: string): string;
    function ReverseString(Value: string): string;
    function LogString(Value: string): string;
  end;

implementation

function TServerMethods1Client.EchoString(Value: string): string;
begin
  if FEchoStringCommand = nil then
  begin
    FEchoStringCommand := FDBXConnection.CreateCommand;
    FEchoStringCommand.CommandType := TDBXCommandTypes.DSServerMethod;
    FEchoStringCommand.Text := 'TServerMethods1.EchoString';
    FEchoStringCommand.Prepare;
  end;
  FEchoStringCommand.Parameters[0].Value.SetWideString(Value);
  FEchoStringCommand.ExecuteUpdate;
  Result := FEchoStringCommand.Parameters[1].Value.GetWideString;
end;

function TServerMethods1Client.ReverseString(Value: string): string;
begin
  if FReverseStringCommand = nil then
  begin
    FReverseStringCommand := FDBXConnection.CreateCommand;
    FReverseStringCommand.CommandType := TDBXCommandTypes.DSServerMethod;
    FReverseStringCommand.Text := 'TServerMethods1.ReverseString';
    FReverseStringCommand.Prepare;
  end;
  FReverseStringCommand.Parameters[0].Value.SetWideString(Value);
  FReverseStringCommand.ExecuteUpdate;
  Result := FReverseStringCommand.Parameters[1].Value.GetWideString;
end;

function TServerMethods1Client.LogString(Value: string): string;
begin
  if FLogStringCommand = nil then
  begin
    FLogStringCommand := FDBXConnection.CreateCommand;
    FLogStringCommand.CommandType := TDBXCommandTypes.DSServerMethod;
    FLogStringCommand.Text := 'TServerMethods1.LogString';
    FLogStringCommand.Prepare;
  end;
  FLogStringCommand.Parameters[0].Value.SetWideString(Value);
  FLogStringCommand.ExecuteUpdate;
  Result := FLogStringCommand.Parameters[1].Value.GetWideString;
end;

constructor TServerMethods1Client.Create(ADBXConnection: TDBXConnection);
begin
  inherited Create(ADBXConnection);
end;

constructor TServerMethods1Client.Create(ADBXConnection: TDBXConnection; AInstanceOwner: Boolean);
begin
  inherited Create(ADBXConnection, AInstanceOwner);
end;

destructor TServerMethods1Client.Destroy;
begin
  FEchoStringCommand.DisposeOf;
  FReverseStringCommand.DisposeOf;
  FLogStringCommand.DisposeOf;
  inherited;
end;

end.

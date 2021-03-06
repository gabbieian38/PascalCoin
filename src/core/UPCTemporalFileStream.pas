unit UPCTemporalFileStream;

{ Copyright (c) 2020 by Albert Molina

  Distributed under the MIT software license, see the accompanying file LICENSE
  or visit http://www.opensource.org/licenses/mit-license.php.

  This unit is a part of the PascalCoin Project, an infinitely scalable
  cryptocurrency. Find us here:
  Web: https://www.pascalcoin.org
  Source: https://github.com/PascalCoin/PascalCoin

  If you like it, consider a donation using Bitcoin:
  16K3HCZRhFUtM8GdWRcfKeaa6KsuyxZaYk

  THIS LICENSE HEADER MUST NOT BE REMOVED.
}

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

uses
  Classes, {$IFnDEF FPC}Windows,{$ENDIF} SysUtils;
{$I ./../config.inc}

Type
  { TPCTemporalFileStream }

  TPCTemporalFileStream = Class(TFileStream)
  private
    FTemporalFileName : String;
  protected
  public
    Constructor Create(const AInitialName : String); reintroduce;
    Destructor Destroy; override;
  End;

implementation

Uses ULog, UNode;

{ TPCTemporalFileStream }

constructor TPCTemporalFileStream.Create(const AInitialName : String);
var LFolder, LTime, LFileName : String;
  i : Integer;
begin
  FTemporalFileName:= '';
  LFolder := TNode.GetPascalCoinDataFolder+PathDelim+'Temp';
  ForceDirectories(LFolder);
  i := 0;
  repeat
    LTime := FormatDateTime('yyyymmddhhnnsszzz',Now);
    if i>0 then begin
      Sleep(1);
      LFileName := LFolder + PathDelim + AInitialName + LTime +'_'+ IntToStr(i) + '.tmp';
    end else begin
      LFileName := LFolder + PathDelim + AInitialName + LTime + '.tmp';
    end;
    inc(i);
  until (Not (FileExists(LFileName)) or (i>5000));
  TLog.NewLog(ltdebug,ClassName,Format('Creating a new Temporal file Stream: %s',[LFileName]));
  inherited Create(LFileName,fmCreate+fmShareDenyWrite);
  FTemporalFileName:=LFileName;
end;

destructor TPCTemporalFileStream.Destroy;
var LSize : Integer;
begin
  LSize := Size;
  inherited Destroy;
  if FTemporalFileName<>'' then begin
    TLog.NewLog(ltdebug,ClassName,Format('Deleting a Temporal file Stream (%d bytes): %s',[LSize, FTemporalFileName]));
    DeleteFile(FTemporalFileName);
  end;
end;

end.

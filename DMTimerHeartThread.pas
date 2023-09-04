unit DMTimerHeartThread;

interface

uses
  SysUtils, Classes
  {$IFDEF MSWINDOWS} , Windows, Messages {$ENDIF}
  ,DMTimerThread
  ;
const
    WM_HEART_SHAPE_UPDATE = WM_USER + 101;
type

  TDMTimerHeartThread = class(TDMTimerThread)
  private
    procedure SetName;
//    procedure Execute;
  protected
    procedure CreateInternals;   override;
    procedure ExecuteCustomCode; override;
  end;

implementation


{$IFDEF MSWINDOWS}
type
  TThreadNameInfo = record
    FType: LongWord;     // must be 0x1000
    FName: PChar;        // pointer to name (in user address space)
    FThreadID: LongWord; // thread ID (-1 indicates caller thread)
    FFlags: LongWord;    // reserved for future use, must be zero
  end;
{$ENDIF}

{ TDMTimerHeartThread }

procedure TDMTimerHeartThread.SetName;
{$IFDEF MSWINDOWS}
var
  ThreadNameInfo: TThreadNameInfo;
{$ENDIF}
begin
{$IFDEF MSWINDOWS}
  ThreadNameInfo.FType := $1000;
  ThreadNameInfo.FName := 'DMTimerHeartThread';
  ThreadNameInfo.FThreadID := $FFFFFFFF;
  ThreadNameInfo.FFlags := 0;

  try
    RaiseException( $406D1388, 0, sizeof(ThreadNameInfo) div sizeof(LongWord), @ThreadNameInfo );
  except
  end;
{$ENDIF}
end;

//procedure TDMTimerHeartThread.Execute;
//begin
//  SetName;
//  { Place thread code here }
//end;

procedure TDMTimerHeartThread.CreateInternals;
begin
  SetName;
  inherited;

end;

procedure TDMTimerHeartThread.ExecuteCustomCode;
begin
  inherited;

end;

end.

unit DMTimerThread;

interface
uses
    SysUtils, Classes,Windows,Messages
    ,MessagePumpSleepThread
    ,TimerDM_
    ;

type

    TDMTimerThread = class(TMessagePumpSleepThread)
    private
        fMainFormHandle: HWND;
        fTimerDM: TDataModule;
    protected
        procedure CreateInternals;                      override;
        procedure DestroyInternals;                     override;
    public
        constructor Create(const MainFormHandle: HWND; const ALoopDelay: Cardinal); overload; virtual;
    end;

implementation

{ TDMTimerThread }

procedure TDMTimerThread.CreateInternals;  // in context of the thread
begin
  inherited;
  fTimerDM := TTimerDM.Create(nil);
  TTimerDM(fTimerDM).MainFormHandle := fMainFormHandle;
end;

procedure TDMTimerThread.DestroyInternals; // still in context of the thread
begin
  inherited;
  fTimerDM.Free;
  PostMessage(fMainFormHandle, WM_UPDATE_HEART, 0, 1);
end;

constructor TDMTimerThread.Create(const MainFormHandle: HWND; const ALoopDelay: Cardinal);
begin
    fMainFormHandle := MainFormHandle;
    inherited Create(ALoopDelay);
end;


end.

unit MessagePumpSleepThread;

interface
uses
    SysUtils, Classes,Windows,Messages
    ;

type
    //
    // Example of thread able to process messages in its own context
    // If you need to process external message, use WindowHandle property
    // and override WndProc
    //
    TMessagePumpSleepThread = class(TThread)
    private
       fWindowHandle: HWND;
       fLoopDelay: cardinal;
       fCoInitializeResult: HRESULT;
       fLastCustomRun: TDateTime;
    protected
        procedure CreateInternals;                      virtual;
        procedure DestroyInternals;                     virtual;
        procedure DoMessage(const AMsg: TMsg);
        procedure Execute; override;
        procedure ExecuteCustomCode;                    virtual;
        procedure ProcessAllMessages;
        function  ProcessMessage(var AMsg: TMsg): Boolean;
        procedure WndProc(var AMessage: TMessage);
        procedure ExecuteCustomException;               virtual;
    public
        constructor Create(const ALoopDelay: Cardinal); overload; virtual;
        destructor Destroy; override;
        procedure TerminateRequest;                     virtual;

        property WindowHandle: HWND read fWindowHandle;
    end;

implementation
uses
      ActiveX
    ;

{ TMessagePumpSleepThread }

constructor TMessagePumpSleepThread.Create(const ALoopDelay: Cardinal);
begin
      FLoopDelay := ALoopDelay;
      FreeOnTerminate := FALSE;
      inherited Create(FALSE); // immediate start;
end;

destructor TMessagePumpSleepThread.Destroy;
begin
  if WindowHandle > 0 then
    Classes.DeallocateHWnd(WindowHandle);

  inherited;
end;

procedure TMessagePumpSleepThread.CreateInternals;
begin

end;

procedure TMessagePumpSleepThread.DestroyInternals;
begin

end;

procedure TMessagePumpSleepThread.Execute;
var
    Msg: TMsg;
begin
    FWindowHandle := Classes.AllocateHWnd(WndProc);
	  Sleep(0);
//  inherited; nothing to inherit from
    PeekMessage(Msg, 0, 0, 0, PM_NOREMOVE);
    try
        fCoInitializeResult := CoInitialize(nil);
        if Terminated then
              Exit;

        CreateInternals;

        while not Terminated do
        begin
            try
                ProcessAllMessages;

                if ((Now - fLastCustomRun) * 24 * 60 * 60 * 1000.0) > fLoopDelay then
                begin
                    ExecuteCustomCode;
                    fLastCustomRun := Now;
                end;
            except
               on E: Exception do
               begin
                   ExecuteCustomException();
               end;
            end;
            Sleep(10);
        end;

        Sleep(10);
        ProcessAllMessages;
        DestroyInternals;

    finally
       case fCoInitializeResult of
          S_OK,S_FALSE: CoUninitialize;
       end;
    end;

end;

procedure TMessagePumpSleepThread.ExecuteCustomCode;
begin

end;


procedure TMessagePumpSleepThread.DoMessage(const AMsg: TMsg);
var
  Msg: TMessage;
begin
  FillChar(Msg, SizeOf(TMessage), 0);

  Msg.Msg := AMsg.message;
  Msg.wParam := AMsg.wParam;
  Msg.lParam := AMsg.lParam;

  WndProc(Msg);
end;

procedure TMessagePumpSleepThread.ProcessAllMessages;
var
  Msg: TMsg;
begin
  while ProcessMessage(Msg) do;
end;

function TMessagePumpSleepThread.ProcessMessage(var AMsg: TMsg): Boolean;
begin
  Result := False;
  FillChar(AMsg, SizeOf(TMsg), 0);

  if PeekMessage(AMsg, 0, 0, 0, PM_REMOVE) then
  begin
    Result := True;

    if AMsg.Message <> WM_QUIT then
      if AMsg.hwnd = 0 then
        DoMessage(AMsg) // Thread message.
      else
      begin
        // Window message.
        TranslateMessage(AMsg);
        DispatchMessage(AMsg);
      end
    else
      Terminate;
  end;
end;



procedure TMessagePumpSleepThread.TerminateRequest;
begin

end;


procedure TMessagePumpSleepThread.WndProc(var AMessage: TMessage);
begin
  // Override in descendant class.
  AMessage.Result := DefWindowProc(WindowHandle, AMessage.Msg, AMessage.WParam, AMessage.LParam);
end;

procedure TMessagePumpSleepThread.ExecuteCustomException;
begin

end;

end.

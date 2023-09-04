unit StarterThreadDemoForm_;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ImgList, ExtCtrls
  ,DMTimerThread
  ,TimerDM_      // declaration of WM_UPDATE_HEART = WM_USER + 111;
  ;

type
  TStarterThreadDemoForm = class(TForm)
    bThreadTerminate: TButton;
    bThreadCreate: TButton;
    ImageList1: TImageList;
    Image1: TImage;
    procedure bDMDestroyClick(Sender: TObject);
    procedure bThreadCreateClick(Sender: TObject);
    procedure bThreadTerminateClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    jImageIndex: integer;
    fDM: TDataModule;
    fDMTimerThread: TThread;

    procedure UpdateHeartMessage(var aMsg: TMessage); message WM_UPDATE_HEART;
    procedure UpdateHeart;
  public
    { Public declarations }
  end;

var
  StarterThreadDemoForm: TStarterThreadDemoForm;

implementation

{$R *.dfm}

procedure TStarterThreadDemoForm.bDMDestroyClick(Sender: TObject);
begin
    FreeAndNil(fDM);
end;

procedure TStarterThreadDemoForm.bThreadCreateClick(Sender: TObject);
begin
    if Not Assigned(fDMTimerThread) then
        fDMTimerThread := TDMTimerThread.Create(Self.Handle, 200);
end;

procedure TStarterThreadDemoForm.bThreadTerminateClick(Sender: TObject);
begin
    if Assigned(fDMTimerThread) then
    begin
        fDMTimerThread.Terminate;
        fDMTimerThread.WaitFor;
        FreeAndNil(fDMTimerThread);
    end;
end;

procedure TStarterThreadDemoForm.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
    bDMDestroyClick(nil);
    bThreadTerminateClick(nil);
end;

procedure TStarterThreadDemoForm.FormCreate(Sender: TObject);
begin
   jImageIndex := 0;
end;

procedure TStarterThreadDemoForm.UpdateHeart;
begin
    Image1.Picture := nil;
    Image1.Repaint;
    Inc(jImageIndex);
    jImageIndex := jImageIndex mod ImageList1.Count;
    ImageList1.GetBitmap(jImageIndex,Image1.Picture.Bitmap);
    Image1.Repaint;
end;

procedure TStarterThreadDemoForm.UpdateHeartMessage(var aMsg: TMessage);
begin
    if aMsg.LParam = 0 then
        UpdateHeart
    else
    begin
      Image1.Picture := nil;
      Image1.Repaint;
    end;
end;

end.

{

TheUserman : Simple User Manager (userman) Mikrotik

Author        : Ahmad Tauhid
Description   : Aplikasi manajemen user hotspot mikrotik
Date          : 01/05/2018
Version       : 3.2.1 stable (codename : Ramadhan)
Web Blog      : http://theuserman.blogspot.co.id

Dibangun menggunakan Bahasa Pemrograman Objek Pascal dan dicompile dengan IDE Lazarus v1.6.4.

Aplikasi ini merupakan implementasi dari MikroTik RouterOS API Client yang ditulis oleh Pavel Skuratovich (chupaka@gmail.com)

Free JPDF Pascal yang ditulis oleh Jean Patrick (jpsoft-sac-pa@hotmail.com) digunakan untuk membuat file PDF

Jika ada hal yang ingin ditanyakan silahkan hubungi kami melalui (ahmad.tauhid.cp@gmail.com)

License : anda dapat memodifikasi source code ini tapi tidak diperkenankan menghapus informasi author ini.
          jadilah orang yang cerdas dan hargailah jerih payah kami.

}

unit ulog;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  StdCtrls, Buttons,RouterOSAPI, ssl_openssl, bahasa;

type

  { TFLog }

  TFLog = class(TForm)
    BReload: TBitBtn;
    BClose: TBitBtn;
    MLog: TMemo;
    PanelBawah: TPanel;
    procedure BCloseClick(Sender: TObject);
    procedure BReloadClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { private declarations }
              ROS : TRosApiClient;
      ResListen: TRosApiResult;
  public
    { public declarations }
  end;

var
  FLog: TFLog;

implementation

uses UUtama;

{$R *.lfm}

{ TFLog }

procedure TFLog.BCloseClick(Sender: TObject);
begin
  FUtama.BackGround.Visible:=True;
  Close;
end;

procedure TFLog.BReloadClick(Sender: TObject);
var
  Res : TRosApiResult;
  i, j: Integer;
begin
    if (FUtama.LTLS.Caption='TRUE') then
       ROS.SSLConnect(FUtama.LIP.Caption, FUtama.LUser.Caption, FUtama.LPass.Caption) else
       ROS.Connect(FUtama.LIP.Caption, FUtama.LUser.Caption, FUtama.LPass.Caption);

    Res := ROS.Query(['/log/print'], True);

    if ROS.LastError <> '' then
    MessageDlg('ERROR : ' + ROS.LastError,mtError,[mbok],0);

 FLog.MLog.Lines.Clear;
  while not Res.Eof do
  begin
  FLog.MLog.Lines.Add(Res.ValueByName['time']+' : '+Res.ValueByName['message']);
  Res.Next;
  end;
end;

procedure TFLog.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin

end;

procedure TFLog.FormCreate(Sender: TObject);
begin
  ROS := TRosApiClient.Create;
ResListen := nil;
  FLog.BReload.Caption:=Gunakan(CekBahasa(),'GLOBAL','BRefresh');
  FLog.BClose.Caption:=Gunakan(CekBahasa(),'GLOBAL','BClose');
end;

procedure TFLog.FormDestroy(Sender: TObject);
begin
  ROS.Free;
end;



end.


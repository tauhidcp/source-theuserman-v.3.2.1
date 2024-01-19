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

unit UUbahPassword;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  Buttons, StdCtrls, RouterOSAPI, ssl_openssl, bahasa;

type

  { TFUbahPassword }

  TFUbahPassword = class(TForm)
    BUbahPassword: TBitBtn;
    EPassLama: TEdit;
    EKonfirmPass: TEdit;
    EPassBaru: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    PanelAtas: TPanel;
    PanelBawah: TPanel;
    PanelTengah: TPanel;
    procedure BUbahPasswordClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  FUbahPassword: TFUbahPassword;

implementation

uses UUtama;

{$R *.lfm}

{ TFUbahPassword }

procedure TFUbahPassword.FormClose(Sender: TObject;
  var CloseAction: TCloseAction);
begin
  EPassLama.Text:='';
  EPassBaru.Text:='';
  EKonfirmPass.Text:='';
end;

procedure TFUbahPassword.FormCreate(Sender: TObject);
begin
  FUbahPassword.Caption:=Gunakan(CekBahasa(),'CHANGEPASSWORD','FTitle');
  FUbahPassword.PanelAtas.Caption:=Gunakan(CekBahasa(),'CHANGEPASSWORD','FTitle');
  FUbahPassword.Label1.Caption:=Gunakan(CekBahasa(),'CHANGEPASSWORD','OldPass');
  FUbahPassword.Label2.Caption:=Gunakan(CekBahasa(),'CHANGEPASSWORD','NewPass');
  FUbahPassword.Label3.Caption:=Gunakan(CekBahasa(),'CHANGEPASSWORD','ConfPass');
  FUbahPassword.BUbahPassword.Caption:=Gunakan(CekBahasa(),'CHANGEPASSWORD','BReplace');

end;

procedure TFUbahPassword.BUbahPasswordClick(Sender: TObject);
var
  Res : TRosApiResult;
  f : Boolean;
  ROS : TRosApiClient;
  j       : integer;
  pa        : array of AnsiString;
  perintah  : array[1..4] of String;
  s         : String;
begin
  ROS := TRosApiClient.Create;
      // Koneksi
    if (FUtama.LTLS.Caption='TRUE') then
       ROS.SSLConnect(FUtama.LIP.Caption, FUtama.LUser.Caption, FUtama.LPass.Caption) else
       ROS.Connect(FUtama.LIP.Caption, FUtama.LUser.Caption, FUtama.LPass.Caption);

  if ((EPassBaru.Text='') or (EKonfirmPass.Text='')) then
     MessageDlg(Gunakan(CekBahasa(),'CHANGEPASSWORD','WarningBlank'),mtWarning,[mbok],0) else
       if (EPassBaru.Text=EKonfirmPass.Text) then
       begin
        // Pecah Perintah Kedalam Array
        perintah[1]:='/password';
        perintah[2]:='=old-password='+EPassLama.Text;
        perintah[3]:='=new-password='+EPassBaru.Text;
        perintah[4]:='=confirm-new-password='+EKonfirmPass.Text;
        // Menyimpan Perintah Kedalam Variabel pa
        SetLength(pa, 0);
        for j := 1 to 4 do
        begin
          s := Trim(perintah[j]);
          if s <> '' then
          begin
            SetLength(pa, High(pa) + 2);
            pa[High(pa)] := s;
          end;
        end;
        // Eksekusi Perintah
        if High(pa) >= 0 then
          ROS.Execute(pa)
          else
          begin
            MessageDlg('ERROR : ' + ROS.LastError,mtWarning,[mbok],0);
            Exit;
          end;
        // Cek Apakah ada Error
        if ROS.LastError <> '' then begin
        if (ROS.LastError='failure: Bad old password!') then
        MessageDlg(Gunakan(CekBahasa(),'CHANGEPASSWORD','PassError'),mtWarning,[mbok],0);
        end else begin
        MessageDlg(Gunakan(CekBahasa(),'CHANGEPASSWORD','ChangeSuccess'),mtInformation,[mbok],0);
        FUtama.LPass.Caption:=EKonfirmPass.Text;
        end;
       end else MessageDlg(Gunakan(CekBahasa(),'CHANGEPASSWORD','PassNotSame'),mtWarning,[mbok],0);
       ROS.Free;
  end;

procedure TFUbahPassword.FormShow(Sender: TObject);
begin
  EPassLama.SetFocus;
end;

end.


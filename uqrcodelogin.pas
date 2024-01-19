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

unit uqrcodelogin;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  Buttons, StdCtrls, bahasa, inifiles, RouterOSAPI, ssl_openssl, encode_decode;

type

  { TFQRCodeLogin }

  TFQRCodeLogin = class(TForm)
    BSimpanPengaturan: TBitBtn;
    EHotspotAddress: TEdit;
    LHotspotAddress: TLabel;
    PanelAtas: TPanel;
    PanelBawah: TPanel;
    PanelTengah: TPanel;
    procedure BSimpanPengaturanClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  FQRCodeLogin: TFQRCodeLogin;

implementation

uses UUtama;

{$R *.lfm}

{ TFQRCodeLogin }

procedure TFQRCodeLogin.FormCreate(Sender: TObject);
begin
  FQRCodeLogin.Caption:=Gunakan(CekBahasa(),'QRCodeLogin','FTitle');
  FQRCodeLogin.PanelAtas.Caption:=Gunakan(CekBahasa(),'QRCodeLogin','FTitle');
  FQRCodeLogin.LHotspotAddress.Caption:=Gunakan(CekBahasa(),'QRCodeLogin','HotspotAddress');
  FQRCodeLogin.BSimpanPengaturan.Caption:=Gunakan(CekBahasa(),'QRCodeLogin','BSave');
end;

procedure TFQRCodeLogin.BSimpanPengaturanClick(Sender: TObject);
var
  Res : TRosApiResult;
  ROS : TRosApiClient;
  j       : integer;
  pa        : array of AnsiString;
  perintah  : array[1..3] of String;
  s         : String;
  myinifile   : TIniFile;
  alamat : String;
begin
  ROS := TRosApiClient.Create;
      // Koneksi
    if (FUtama.LTLS.Caption='TRUE') then
       ROS.SSLConnect(FUtama.LIP.Caption, FUtama.LUser.Caption, FUtama.LPass.Caption) else
       ROS.Connect(FUtama.LIP.Caption, FUtama.LUser.Caption, FUtama.LPass.Caption);

  if (EHotspotAddress.Text='') then
     alamat := '' else
       //begin
       alamat := GSMEncode7Bit(GSMEncode7Bit(GSMEncode7Bit(EHotspotAddress.Text)));
        // Simpan di File Ini
        if (FileExists(ExtractFilePath(Application.exename)+'config.ini')) then
        begin
         myinifile := TIniFile.Create(ExtractFilePath(Application.ExeName) + 'config.ini');
          with myinifile do begin
          WriteString('CONFIG','HotspotAddress',alamat);
          Free;
          end;
        end;
        // Edit Hotspot Profile
        Res := ROS.Query(['/ip/hotspot/profile/print'], True);
        if ROS.LastError <> '' then
        MessageDlg('ERROR : ' + ROS.LastError,mtError,[mbok],0);

        while not Res.Eof do
        begin
        // Pecah Perintah Kedalam Array
        perintah[1]:='/ip/hotspot/profile/set';
        perintah[2]:='=login-by=http-pap,http-chap,cookie';
        perintah[3]:='=.id='+Res.ValueByName['.id'];
        // Menyimpan Perintah Kedalam Variabel pa
        SetLength(pa, 0);
        for j := 1 to 3 do
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
        if ROS.LastError <> '' then
        MessageDlg('Error : '+ROS.LastError,mtError,[mbok],0);
        Res.Next;
       end;
         MessageDlg(Gunakan(CekBahasa(),'QRCodeLogin','SaveSuccess'),mtInformation,[mbok],0);
       //end;
ROS.Free;
end;

procedure TFQRCodeLogin.FormShow(Sender: TObject);
begin
  if (FileExists(ExtractFilePath(Application.exename)+'config.ini')) then
   begin
   myinifile := TIniFile.Create(ExtractFilePath(Application.ExeName) + 'config.ini');
      with myinifile do begin
      EHotspotAddress.Text:=GSMDecode7Bit(GSMDecode7Bit(GSMDecode7Bit(ReadString('CONFIG','HotspotAddress','0'))));
      Free;
      end;
   end;
end;

end.


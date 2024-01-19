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

unit ULogin;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  StdCtrls, Buttons, RouterOSAPI, UUtama, IniFiles, ssl_openssl, bahasa, encode_decode;

type

  { TFLogin }

  TFLogin = class(TForm)
    BLogin: TBitBtn;
    BBatal: TBitBtn;
    CkTLS: TCheckBox;
    CkSimpanInfo: TCheckBox;
    EIPAddress: TEdit;
    EUserLogin: TEdit;
    EPassword: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    PanelAtas: TPanel;
    PanelBawah: TPanel;
    PanelTengah: TPanel;
    procedure BBatalClick(Sender: TObject);
    procedure BLoginClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  FLogin: TFLogin;
  myinifile   : TIniFile;
implementation

{$R *.lfm}

{ TFLogin }

procedure TFLogin.FormShow(Sender: TObject);
begin
  CkSimpanInfo.Checked:=True;
  EIPAddress.SetFocus;
end;

procedure TFLogin.FormCreate(Sender: TObject);
begin
if (FileExists(ExtractFilePath(Application.exename)+'config.ini')) then
 begin
 myinifile := TIniFile.Create(ExtractFilePath(Application.ExeName) + 'config.ini');
    with myinifile do begin
    EIPAddress.Text := GSMDecode7Bit(GSMDecode7Bit(ReadString('CONFIG','IPAddress','0')));
    EUserLogin.Text := GSMDecode7Bit(GSMDecode7Bit(ReadString('CONFIG','UserLogin','0')));
    EPassword.Text := GSMDecode7Bit(GSMDecode7Bit(GSMDecode7Bit(ReadString('CONFIG','Password','0'))));
    if (GSMDecode7Bit(GSMDecode7Bit(ReadString('CONFIG','TLS','0')))='TRUE') then CkTLS.Checked:=True;
    Free;
    end;
 end
 else begin
 myinifile := Tinifile.Create(ExtractFilePath(Application.exename)+'config.ini');
 with myinifile do begin
 WriteString('CONFIG','IPAddress','');
 WriteString('CONFIG','UserLogin','');
 WriteString('CONFIG','Password','');
 WriteString('CONFIG','TLS','');
 WriteString('CONFIG','Language',GSMEncode7Bit(GSMEncode7Bit('default')));
 WriteString('CONFIG','Template',GSMEncode7Bit(GSMEncode7Bit('default')));
 WriteString('CONFIG','HotspotAddress','');
 WriteString('CONFIG','Validity','');
 WriteString('CONFIG','ValidityInterval','');
 WriteString('CONFIG','VoucherColumn',GSMEncode7Bit(GSMEncode7Bit('Dua')));
 WriteString('VOUCHER','UserLogin',GSMEncode7Bit('Yes'));
 WriteString('VOUCHER','Password',GSMEncode7Bit('Yes'));
 WriteString('VOUCHER','Price',GSMEncode7Bit('Yes'));
 WriteString('VOUCHER','Validity',GSMEncode7Bit('Yes'));
 WriteString('VOUCHER','TimeLimit',GSMEncode7Bit('Yes'));
 WriteString('HTMLTEMPLATE','Header',GSMEncode7Bit('<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"><html xmlns="http://www.w3.org/1999/xhtml"><head><title>HTML Voucher</title></head><body>'));
 WriteString('HTMLTEMPLATE','Row',GSMEncode7Bit('<table align="center" style="color: black; font-size: 11px;"><tr height="5px"><td colspan="3"></td></tr><tr><td>Username :</td><td><b>%username%</b></td></tr><tr><td>Password :</td><td><font face="courier new"><b>%password%</b></font></td></tr><tr><td>Time Limit :</td><td><b>%timelimit%</b></td></tr><tr><td>Validity :</td><td><font face="courier new"><b>%validity%</b></font></td></tr><tr><td>Price :</td><td><font face="courier new"><b>%price%</b></font></td></tr><tr height="5px"><td colspan="3"></td></tr></table>'));
 WriteString('HTMLTEMPLATE','Footer',GSMEncode7Bit('</body></html>'));
 Free;
 end;
end;
 // Setup Bahasa
 FLogin.Caption:=Gunakan(CekBahasa(),'LOGIN','FormTitle')+' (theuserman v3.2.1) - stable';
 FLogin.PanelAtas.Caption:=Gunakan(CekBahasa(),'LOGIN','Title');
 FLogin.Label1.Caption:=Gunakan(CekBahasa(),'LOGIN','IPAddress');
 FLogin.Label2.Caption:=Gunakan(CekBahasa(),'LOGIN','UserLogin');
 FLogin.Label3.Caption:=Gunakan(CekBahasa(),'LOGIN','Password');
 FLogin.CkTLS.Caption:=Gunakan(CekBahasa(),'LOGIN','TLS');
 FLogin.CkSimpanInfo.Caption:=Gunakan(CekBahasa(),'LOGIN','SaveInfoLogin');
 FLogin.BLogin.Caption:=Gunakan(CekBahasa(),'LOGIN','BLogin');
 FLogin.BBatal.Caption:=Gunakan(CekBahasa(),'LOGIN','BExit');
 end;
procedure TFLogin.BLoginClick(Sender: TObject);
var
  Res         : TRosApiResult;
  f           : Boolean;
  ROS         : TRosApiClient;
begin
  ROS         := TRosApiClient.Create;
  // Cek Inputan
  if ((EIPAddress.Text='') or (EUserLogin.Text='')) then
     MessageDlg(Gunakan(CekBahasa(),'LOGIN','WarningBlank'),mtWarning,[mbok],0)
     else begin
      if (CkTLS.Checked=True) then
      f := ROS.SSLConnect(EIPAddress.Text, EUserLogin.Text, EPassword.Text)
      else
      f := ROS.Connect(EIPAddress.Text, EUserLogin.Text, EPassword.Text);
      if f then
      begin
       // Simpan Info Login
        if CkSimpanInfo.Checked=True then
        begin
         myinifile := Tinifile.Create(ExtractFilePath(Application.exename)+'config.ini');
         with myinifile do begin
         WriteString('CONFIG','IPAddress',GSMEncode7Bit(GSMEncode7Bit(EIPAddress.Text)));
         WriteString('CONFIG','UserLogin',GSMEncode7Bit(GSMEncode7Bit(EUserLogin.Text)));
         WriteString('CONFIG','Password',GSMEncode7Bit(GSMEncode7Bit(GSMEncode7Bit(EPassword.Text))));
         if (CkTLS.Checked=True) then WriteString('CONFIG','TLS',GSMEncode7Bit(GSMEncode7Bit('TRUE'))) else WriteString('CONFIG','TLS',GSMEncode7Bit(GSMEncode7Bit('FALSE')));
         Free;
         end;
        end;
        if (CkTLS.Checked=True) then FUtama.LTLS.Caption:='TRUE' else FUtama.LTLS.Caption:='FALSE';
        // Set Value Form Utama
        Res := ROS.Query(['/system/resource/print'], True);
        FUtama.StatusBar.Panels[0].Text:=' '+Gunakan(CekBahasa(),'MAIN','StatusIP')+' : '+EIPAddress.Text;
        FUtama.StatusBar.Panels[1].Text:=' '+Gunakan(CekBahasa(),'MAIN','StatusLogin')+' : '+EUserLogin.Text;
        FUtama.StatusBar.Panels[2].Text:=' '+Gunakan(CekBahasa(),'MAIN','StatusRouter')+' : '+Res['version'];
        FUtama.LIP.Caption:=EIPAddress.Text;
        FUtama.LUser.Caption:=EUserLogin.Text;
        FUtama.LPass.Caption:=EPassword.Text;
        FLogin.Visible:=False;
        FUtama.Show;
        Res.Free;
        ROS.Free;
      end
      else
      begin
        MessageDlg(Gunakan(CekBahasa(),'LOGIN','WarningError')+' '+ ROS.LastError,mtError,[mbok],0);
        Exit;
      end;
     end;
  end;

procedure TFLogin.BBatalClick(Sender: TObject);
begin
Application.Terminate;
end;

end.


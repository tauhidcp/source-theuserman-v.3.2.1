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

unit uselectitem;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls, bahasa,
  encode_decode, IniFiles;

type

  { TFSelectItem }

  TFSelectItem = class(TForm)
    CkLimit: TCheckBox;
    CkUser: TCheckBox;
    CkPass: TCheckBox;
    CKPrice: TCheckBox;
    CkValidity: TCheckBox;
    GItemExport: TGroupBox;
    procedure CkLimitClick(Sender: TObject);
    procedure CkPassClick(Sender: TObject);
    procedure CKPriceClick(Sender: TObject);
    procedure CkUserClick(Sender: TObject);
    procedure CkValidityClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  FSelectItem: TFSelectItem;


implementation

{$R *.lfm}

{ TFSelectItem }

procedure TFSelectItem.FormShow(Sender: TObject);
var
  myinifile   : TIniFile;
begin
  if (FileExists(ExtractFilePath(Application.exename)+'config.ini')) then
 begin
 myinifile := TIniFile.Create(ExtractFilePath(Application.ExeName) + 'config.ini');
    with myinifile do begin
    if (GSMDecode7Bit(ReadString('VOUCHER','UserLogin','0'))='Yes') then CkUser.Checked:=True;
    if (GSMDecode7Bit(ReadString('VOUCHER','Password','0'))='Yes') then CkPass.Checked:=True;
    if (GSMDecode7Bit(ReadString('VOUCHER','Price','0'))='Yes') then CKPrice.Checked:=True;
    if (GSMDecode7Bit(ReadString('VOUCHER','Validity','0'))='Yes') then CkValidity.Checked:=True;
    if (GSMDecode7Bit(ReadString('VOUCHER','TimeLimit','0'))='Yes') then CkLimit.Checked:=True;
    end;
 myinifile.Free;
 end;
end;

procedure TFSelectItem.CkUserClick(Sender: TObject);
var
  myinifile   : TIniFile;
begin
  if (FileExists(ExtractFilePath(Application.exename)+'config.ini')) then
 begin
 myinifile := TIniFile.Create(ExtractFilePath(Application.ExeName) + 'config.ini');
    with myinifile do begin
    if CkUser.Checked=True then begin
    WriteString('VOUCHER','UserLogin',GSMEncode7Bit('Yes'));
    end else
    if CkUser.Checked=False then begin
    WriteString('VOUCHER','UserLogin',GSMEncode7Bit('No'));
    end;
    Free;
    end;
 end;
end;

procedure TFSelectItem.CkValidityClick(Sender: TObject);
var
  myinifile   : TIniFile;
begin
if (FileExists(ExtractFilePath(Application.exename)+'config.ini')) then
 begin
 myinifile := TIniFile.Create(ExtractFilePath(Application.ExeName) + 'config.ini');
    with myinifile do begin
    if CkValidity.Checked=True then begin
    WriteString('VOUCHER','Validity',GSMEncode7Bit('Yes'));
    end else
    if CkValidity.Checked=False then begin
    WriteString('VOUCHER','Validity',GSMEncode7Bit('No'));
    end;
    Free;
    end;
 end;
end;

procedure TFSelectItem.FormCreate(Sender: TObject);
begin
  FSelectItem.Caption:=Gunakan(CekBahasa(),'SelectItem','FTitle');
  FSelectItem.GItemExport.Caption:=Gunakan(CekBahasa(),'SelectItem','ItemToExport');
  FSelectItem.CkUser.Caption:=Gunakan(CekBahasa(),'SelectItem','UserLogin');
  FSelectItem.CkPass.Caption:=Gunakan(CekBahasa(),'SelectItem','Password');
  FSelectItem.CkValidity.Caption:=Gunakan(CekBahasa(),'SelectItem','Validity');
  FSelectItem.CkLimit.Caption:=Gunakan(CekBahasa(),'SelectItem','TimeLimit');
  FSelectItem.CKPrice.Caption:=Gunakan(CekBahasa(),'SelectItem','Price');
end;

procedure TFSelectItem.CkPassClick(Sender: TObject);
var
  myinifile   : TIniFile;
begin
    if (FileExists(ExtractFilePath(Application.exename)+'config.ini')) then
 begin
 myinifile := TIniFile.Create(ExtractFilePath(Application.ExeName) + 'config.ini');
    with myinifile do begin
    if CkPass.Checked=True then begin
    WriteString('VOUCHER','Password',GSMEncode7Bit('Yes'));
    end else
    if CkPass.Checked=False then begin
    WriteString('VOUCHER','Password',GSMEncode7Bit('No'));
    end;
    Free;
    end;
 end;
end;

procedure TFSelectItem.CkLimitClick(Sender: TObject);
var
  myinifile   : TIniFile;
begin
  if (FileExists(ExtractFilePath(Application.exename)+'config.ini')) then
 begin
 myinifile := TIniFile.Create(ExtractFilePath(Application.ExeName) + 'config.ini');
    with myinifile do begin
    if CkLimit.Checked=True then begin
    WriteString('VOUCHER','TimeLimit',GSMEncode7Bit('Yes'));
    end else
    if CkLimit.Checked=False then begin
    WriteString('VOUCHER','TimeLimit',GSMEncode7Bit('No'));
    end;
    Free;
    end;
 end;
end;

procedure TFSelectItem.CKPriceClick(Sender: TObject);
var
  myinifile   : TIniFile;
begin
    if (FileExists(ExtractFilePath(Application.exename)+'config.ini')) then
 begin
 myinifile := TIniFile.Create(ExtractFilePath(Application.ExeName) + 'config.ini');
    with myinifile do begin
    if CKPrice.Checked=True then begin
    WriteString('VOUCHER','Price',GSMEncode7Bit('Yes'));
    end else
    if CKPrice.Checked=False then begin
    WriteString('VOUCHER','Price',GSMEncode7Bit('No'));
    end;
    Free;
    end;
 end;
end;

end.


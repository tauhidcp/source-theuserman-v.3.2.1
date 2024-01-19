{

TheUserman : Simple User Manager (userman) Mikrotik

Author        : Ahmad Tauhid
Description   : Aplikasi manajemen user hotspot mikrotik
Date          : 07/04/2018
Version       : 3.1.0 stable (codename : Santri)
Web Blog      : http://theuserman.blogspot.co.id

Dibangun menggunakan Bahasa Pemrograman Objek Pascal dan dicompile dengan IDE Lazarus v1.6.4.

Aplikasi ini merupakan implementasi dari MikroTik RouterOS API Client yang ditulis oleh Pavel Skuratovich (chupaka@gmail.com)

Free JPDF Pascal yang ditulis oleh Jean Patrick (jpsoft-sac-pa@hotmail.com) digunakan untuk membuat file PDF

Jika ada hal yang ingin ditanyakan silahkan hubungi kami melalui (ahmad.tauhid.cp@gmail.com)

License : anda dapat memodifikasi source code ini tapi tidak diperkenankan menghapus informasi author ini.
          jadilah orang yang cerdas dan hargailah jerih payah kami.

}

unit bahasa;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, IniFiles, encode_decode;

   function Gunakan(nama : string; lokasi : string; keterangan:string) : string;
   function CekBahasa() : String;

var
  myinifile   : TIniFile;

implementation

function Gunakan(nama: string; lokasi: string; keterangan: string): string;
begin
  Result := '';
  if ((nama='') or (nama=GSMEncode7Bit(GSMEncode7Bit('default')))) then
  begin
  if (FileExists(GetCurrentDir+'/language/English [EN].ini')) then
  begin
  myinifile := TIniFile.Create(GetCurrentDir+'/language/English [EN].ini');
  with myinifile do begin
  Result := ReadString(lokasi,keterangan,'0');
  Free;
  end;
  end;
  end else begin
  if (FileExists(GetCurrentDir+'/language/'+GSMDecode7Bit(GSMDecode7Bit(nama))+'.ini')) then
    begin
    myinifile := TIniFile.Create(GetCurrentDir+'/language/'+GSMDecode7Bit(GSMDecode7Bit(nama))+'.ini');
    with myinifile do begin
    Result := ReadString(lokasi,keterangan,'0');
    Free;
    end;
    end;
  end;
end;

function CekBahasa(): String;
begin
  Result := 'default';
  if (FileExists(GetCurrentDir+'/config.ini')) then
   begin
   myinifile := TIniFile.Create(GetCurrentDir+'/config.ini');
   with myinifile do begin
   Result := ReadString('CONFIG','Language','0');
   Free;
   end;
   end;
end;



end.


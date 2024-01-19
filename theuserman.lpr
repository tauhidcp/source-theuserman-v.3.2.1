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

program theuserman;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, uutama, ULogin, UDataLimitBW, UTambahLimitBW,
  UDataUserHotspot, UDataUserHotspotAktif, UTambahUserHotspot,
  UGenerateUserHotspot, UEksportHapusByGroup, UUbahPassword, UTemplateVoucher,
  bahasa, uqrcodelogin, uqrlogin, uquota, encode_decode, ulog, uselectitem,
  uselectcolumn, uhtmltemplate, uvalidityinstall, laz_synapse;

{$R *.res}

begin
  RequireDerivedFormResource:=True;
  Application.Initialize;
  Application.CreateForm(TFLogin, FLogin);
  Application.CreateForm(TFUtama, FUtama);
  Application.CreateForm(TFTambahLimitBW, FTambahLimitBW);
  Application.CreateForm(TFTambahUserHotspot, FTambahUserHotspot);
  Application.CreateForm(TFGenerateUserHotspot, FGenerateUserHotspot);
  Application.CreateForm(TFEksportHapusByGroup, FEksportHapusByGroup);
  Application.CreateForm(TFUbahPassword, FUbahPassword);
  Application.CreateForm(TFTemplateVoucher, FTemplateVoucher);
  Application.CreateForm(TFQRCodeLogin, FQRCodeLogin);
  Application.CreateForm(TFQRLogin, FQRLogin);
  Application.CreateForm(TFQuota, FQuota);
  Application.CreateForm(TFSelectItem, FSelectItem);
  Application.CreateForm(TFCustomVoucherColumn, FCustomVoucherColumn);
  Application.CreateForm(TFHTMLTemplate, FHTMLTemplate);
  Application.CreateForm(TFValidityInstall, FValidityInstall);
  Application.CreateForm(TFDataLimitBW, FDataLimitBW);
  Application.CreateForm(TFDataUserHotspot, FDataUserHotspot);
  Application.CreateForm(TFDataUserHotspotAktif, FDataUserHotspotAktif);
  Application.CreateForm(TFLog, FLog);
  Application.Run;
end.


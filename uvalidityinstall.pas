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

unit uvalidityinstall;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  StdCtrls, Buttons, RouterOSAPI, ssl_openssl, bahasa, inifiles, encode_decode;

type

  { TFValidityInstall }

  TFValidityInstall = class(TForm)
    BSimpan: TBitBtn;
    CbInterval: TComboBox;
    GroupInt: TGroupBox;
    procedure BSimpanClick(Sender: TObject);
    procedure CbIntervalKeyPress(Sender: TObject; var Key: char);
    procedure FormShow(Sender: TObject);
   // procedure RadioGroup1Click(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  FValidityInstall: TFValidityInstall;

implementation

uses
  uutama;

{$R *.lfm}

{ TFValidityInstall }


procedure TFValidityInstall.BSimpanClick(Sender: TObject);
var
Res,Ras : TRosApiResult;
pa        : array of AnsiString;
perintah : array[1..9] of String;
perintahx : array[1..3] of String;
perintahs : array[1..10] of String;
i,j,k : integer;
s,bulan, interval : String;
ROS       : TRosApiClient;
begin
      ROS := TRosApiClient.Create;

 if (CbInterval.Text='') or (CbInterval.Text=Gunakan(CekBahasa(),'ValidityInstall','IntervalSelect')) then
    MessageDlg(Gunakan(CekBahasa(),'ValidityInstall','ValidWarning'),mtError,[mbok],0) else
    begin

    if CbInterval.ItemIndex=0 then
    interval:='00:01:00' else
    if CbInterval.ItemIndex=1 then
    interval:='01:00:00' else
    if CbInterval.ItemIndex=2 then
    interval:='24:00:00';

      if (FUtama.LTLS.Caption='TRUE') then
      ROS.SSLConnect(FUtama.LIP.Caption, FUtama.LUser.Caption, FUtama.LPass.Caption) else
      ROS.Connect(FUtama.LIP.Caption, FUtama.LUser.Caption, FUtama.LPass.Caption);

      case FormatDateTime('MM',Now) of
      '01' : bulan := 'jan';
      '02' : bulan := 'feb';
      '03' : bulan := 'mar';
      '04' : bulan := 'apr';
      '05' : bulan := 'may';
      '06' : bulan := 'jun';
      '07' : bulan := 'jul';
      '08' : bulan := 'aug';
      '09' : bulan := 'sep';
      '10' : bulan := 'oct';
      '11' : bulan := 'nov';
      '12' : bulan := 'dec';
      end;
     {Install Validity}
     if (BSimpan.Caption='Install') then
     begin
     // Edit User Profile
     Res := ROS.Query(['/ip/hotspot/user/profile/print'], True);
        if ROS.LastError <> '' then
        MessageDlg('ERROR : ' + ROS.LastError,mtError,[mbok],0);

        while not Res.Eof do
        begin
        // Pecah Perintah Kedalam Array
        perintahx[1]:='/ip/hotspot/user/profile/set';
        perintahx[2]:='=on-login={'+sLineBreak+':if ( [ /ip hotspot user get $user comment ] != "" ) do={'+sLineBreak+' :local datex [/ip hotspot user get $user comment ]'+sLineBreak+':local pecah [:toarray [:pick $datex ([:find $datex ":"]+1) [:len $datex]]]'+sLineBreak+':local tgl [:pick $pecah 1]'+sLineBreak+':if ([:len $tgl] != 0) do={'+sLineBreak+':local komen [:pick $datex 0 [:find $datex ":"]]'+sLineBreak+':local harga [:pick $pecah 0]'+sLineBreak+':local date [ /system clock get date ]'+sLineBreak+':local days $tgl'+sLineBreak+':local mdays  {31;28;31;30;31;30;31;31;30;31;30;31}'+sLineBreak+':local months {"jan"=1;"feb"=2;"mar"=3;"apr"=4;"may"=5;"jun"=6;"jul"=7;"aug"=8;"sep"=9;"oct"=10;"nov"=11;"dec"=12}'+sLineBreak+':local monthr  {"jan";"feb";"mar";"apr";"may";"jun";"jul";"aug";"sep";"oct";"nov";"dec"}'+sLineBreak+':local dd  [:tonum [:pick $date 4 6]]'+sLineBreak+':local yy [:tonum [:pick $date 7 11]]'+sLineBreak+':local month [:pick $date 0 3]'+sLineBreak+':local mm (:$months->$month)'+sLineBreak+':set dd ($dd+$days)'+sLineBreak+':local dm [:pick $mdays ($mm-1)]'+sLineBreak+':if ($mm=2 && (($yy&3=0 && ($yy/100*100 != $yy)) || $yy/400*400=$yy) ) do={ :set dm 29 }'+sLineBreak+':while ($dd>$dm) do={'+sLineBreak+':set dd ($dd-$dm)'+sLineBreak+':set mm ($mm+1)'+sLineBreak+':if ($mm>12) do={'+sLineBreak+':set mm 1'+sLineBreak+':set yy ($yy+1)'+sLineBreak+'}'+sLineBreak+':set dm [:pick $mdays ($mm-1)]'+sLineBreak+':if ($mm=2 &&  (($yy&3=0 && ($yy/100*100 != $yy)) || $yy/400*400=$yy) ) do={ :set dm 29 }'+sLineBreak+'};'+sLineBreak+':local res "$[:pick $monthr ($mm-1)]/"'+sLineBreak+':if ($dd<10) do={ :set res ($res."0") }'+sLineBreak+':set $res "$res$dd/$yy"'+sLineBreak+':local waktu [/system clock get time]'+sLineBreak+'[ /ip hotspot user set $user comment="$komen : \"$harga\" $res - $waktu" ]'+sLineBreak+'}'+sLineBreak+'}'+sLineBreak+'}';
        perintahx[3]:='=.id='+Res.ValueByName['.id'];
        // Menyimpan Perintah Kedalam Variabel pa
        SetLength(pa, 0);
        for j := 1 to 3 do
        begin
          s := Trim(perintahx[j]);
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
  // End Edit User Profile
  // Pecah Perintah Kedalam Array
  perintah[1]:='/system/scheduler/add';
  perintah[2]:='=comment=[The Userman] User Hotspot Validator';
  perintah[3]:='=disabled=no';
  perintah[4]:='=name=the-userman-validity';
  perintah[5]:='=policy=ftp,reboot,read,write,policy,test,winbox,password,sniff,sensitive';
  perintah[6]:='=start-date='+bulan+'/'+FormatDateTime('dd/yyyy',Now);
  perintah[7]:='=start-time='+FormatDateTime('hh:mm:ss',Now);
  perintah[8]:='=interval='+interval;
  perintah[9]:='=on-event={'+sLineBreak+':global today'+sLineBreak+'{'+sLineBreak+':local date [ /system clock get date ]'+sLineBreak+':local montharray ( "jan","feb","mar","apr","may","jun","jul","aug","sep","oct","nov","dec" )'+sLineBreak+':local monthdays ( 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31 )'+sLineBreak+':local days [ :pick $date 4 6 ]'+sLineBreak+':local monthtxt [ :pick $date 0 3 ]'+sLineBreak+':local year [ :pick $date 7 11 ]'+sLineBreak+':local months ([ :find $montharray $monthtxt]  )'+sLineBreak+':for nodays from=0 to=$months do={'+sLineBreak+':set days ( $days + [ :pick $monthdays $nodays ] )'+sLineBreak+'}'+sLineBreak+':set days ($days + $year * 365)'+sLineBreak+':set today $days'+sLineBreak+'}'+sLineBreak+':foreach i in [/ip hotspot user find where disabled=no ] do={'+sLineBreak+':if ([ :find [/ip hotspot user get $i comment ] ] = 0 ) do={'+sLineBreak+':local date [/ip hotspot user get $i comment ]'+sLineBreak+':local pecah [:toarray [:pick $date ([:find $date ":"]+1) [:len $date]]]'+sLineBreak+':local tgl [:pick $pecah 1]'+sLineBreak+':local tglx [:pick $tgl 0 [:find $tgl "-"]]'+sLineBreak+':local waktux [:toarray [:pick $tgl ([:find $tgl "-"]+1) [:len $tgl]]]'+sLineBreak+':local tahun [ :pick $tglx 7 11 ]'+sLineBreak+':if ([:len $tahun] != 0) do={'+sLineBreak+':local montharray ( "jan","feb","mar","apr","may","jun","jul","aug","sep","oct","nov","dec" )'+sLineBreak+':local monthdays ( 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31 )'+sLineBreak+':local days [ :pick $tglx 4 6 ]'+sLineBreak+':local monthtxt [ :pick $tglx 0 3 ]'+sLineBreak+':local year [ :pick $tglx 7 11 ]'+sLineBreak+':local months ( [ :find $montharray $monthtxt ] )'+sLineBreak+':for nodays from=0 to=$months do={'+sLineBreak+':set days ( $days + [ :pick $monthdays $nodays ] )'+sLineBreak+'}'+sLineBreak+':set days ($days + $year * 365)'+sLineBreak+':if ( $days <= $today ) do={'+sLineBreak+':local waktu [/system clock get time]'+sLineBreak+':if ( $waktu >= $waktux ) do={'+sLineBreak+':local name [/ip hotspot user get $i name]'+sLineBreak+':log info "user $name di disabel karena masa valid sudah habis"'+sLineBreak+'[ /ip hotspot user disable $i ]'+sLineBreak+'[ /ip hotspot active remove [find where user=$name] ]'+sLineBreak+'}'+sLineBreak+'}'+sLineBreak+'}'+sLineBreak+'}'+sLineBreak+'}'+sLineBreak+'}';
  // Menyimpan Perintah Kedalam Variabel pa
  SetLength(pa, 0);
  for i := 1 to 9 do
  begin
    s := Trim(perintah[i]);
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
   myinifile := Tinifile.Create(ExtractFilePath(Application.exename)+'config.ini');
   with myinifile do begin
   WriteString('CONFIG','Validity',GSMEncode7Bit(GSMEncode7Bit('YES')));
   WriteString('CONFIG','ValidityInterval',GSMEncode7Bit(GSMEncode7Bit(CbInterval.Text)));
   Free;
   end;
  // Cek Apakah ada Error
  if ROS.LastError <> '' then
  if (ROS.LastError='failure: item with this name already exists') then
     begin
      // Update Validity
     Res := ROS.Query(['/system/scheduler/print'], True);
        if ROS.LastError <> '' then
        MessageDlg('ERROR : ' + ROS.LastError,mtError,[mbok],0);

        while not Res.Eof do
        begin
        if (Res.ValueByName['name']='the-userman-validity') then
        begin
        // Pecah Perintah Kedalam Array
        perintahs[1]:='/system/scheduler/set';
        perintahs[2]:='=comment=[The Userman] User Hotspot Validator';
        perintahs[3]:='=disabled=no';
        perintahs[4]:='=name=the-userman-validity';
        perintahs[5]:='=policy=ftp,reboot,read,write,policy,test,winbox,password,sniff,sensitive';
        perintahs[6]:='=start-date='+bulan+'/'+FormatDateTime('dd/yyyy',Now);
        perintahs[7]:='=start-time='+FormatDateTime('hh:mm:ss',Now);
        perintah[8]:='=interval='+interval;
        perintahs[9]:='=on-event={'+sLineBreak+':global today'+sLineBreak+'{'+sLineBreak+':local date [ /system clock get date ]'+sLineBreak+':local montharray ( "jan","feb","mar","apr","may","jun","jul","aug","sep","oct","nov","dec" )'+sLineBreak+':local monthdays ( 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31 )'+sLineBreak+':local days [ :pick $date 4 6 ]'+sLineBreak+':local monthtxt [ :pick $date 0 3 ]'+sLineBreak+':local year [ :pick $date 7 11 ]'+sLineBreak+':local months ([ :find $montharray $monthtxt]  )'+sLineBreak+':for nodays from=0 to=$months do={'+sLineBreak+':set days ( $days + [ :pick $monthdays $nodays ] )'+sLineBreak+'}'+sLineBreak+':set days ($days + $year * 365)'+sLineBreak+':set today $days'+sLineBreak+'}'+sLineBreak+':foreach i in [/ip hotspot user find where disabled=no ] do={'+sLineBreak+':if ([ :find [/ip hotspot user get $i comment ] ] = 0 ) do={'+sLineBreak+':local date [/ip hotspot user get $i comment ]'+sLineBreak+':local pecah [:toarray [:pick $date ([:find $date ":"]+1) [:len $date]]]'+sLineBreak+':local tgl [:pick $pecah 1]'+sLineBreak+':local tglx [:pick $tgl 0 [:find $tgl "-"]]'+sLineBreak+':local waktux [:toarray [:pick $tgl ([:find $tgl "-"]+1) [:len $tgl]]]'+sLineBreak+':local tahun [ :pick $tglx 7 11 ]'+sLineBreak+':if ([:len $tahun] != 0) do={'+sLineBreak+':local montharray ( "jan","feb","mar","apr","may","jun","jul","aug","sep","oct","nov","dec" )'+sLineBreak+':local monthdays ( 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31 )'+sLineBreak+':local days [ :pick $tglx 4 6 ]'+sLineBreak+':local monthtxt [ :pick $tglx 0 3 ]'+sLineBreak+':local year [ :pick $tglx 7 11 ]'+sLineBreak+':local months ( [ :find $montharray $monthtxt ] )'+sLineBreak+':for nodays from=0 to=$months do={'+sLineBreak+':set days ( $days + [ :pick $monthdays $nodays ] )'+sLineBreak+'}'+sLineBreak+':set days ($days + $year * 365)'+sLineBreak+':if ( $days <= $today ) do={'+sLineBreak+':local waktu [/system clock get time]'+sLineBreak+':if ( $waktu >= $waktux ) do={'+sLineBreak+':local name [/ip hotspot user get $i name]'+sLineBreak+':log info "user $name di disabel karena masa valid sudah habis"'+sLineBreak+'[ /ip hotspot user disable $i ]'+sLineBreak+'[ /ip hotspot active remove [find where user=$name] ]'+sLineBreak+'}'+sLineBreak+'}'+sLineBreak+'}'+sLineBreak+'}'+sLineBreak+'}'+sLineBreak+'}';
        perintahs[10]:='=.id='+Res.ValueByName['.id'];
        // Menyimpan Perintah Kedalam Variabel pa
        SetLength(pa, 0);
        for k := 1 to 10 do
        begin
          s := Trim(perintahs[k]);
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
        end;
        Res.Next;
       end;
      // End Update
      MessageDlg(Gunakan(CekBahasa(),'MAIN','VALIDITYEXISTS'),mtInformation,[mbok],0)
     end else
  MessageDlg('ERROR : ' + ROS.LastError,mtError,[mbok],0)
  else
    begin
    MessageDlg(Gunakan(CekBahasa(),'MAIN','VALIDITYSUCCESS'),mtInformation,[mbok],0);
    end;
    BSimpan.Caption:='Uninstall';
    end else
    {Uninstall Validity}
    if (BSimpan.Caption='Uninstall') then
    begin

    // Edit User Profile
     Res := ROS.Query(['/ip/hotspot/user/profile/print'], True);
        if ROS.LastError <> '' then
        MessageDlg('ERROR : ' + ROS.LastError,mtError,[mbok],0);

        while not Res.Eof do
        begin
        // Pecah Perintah Kedalam Array
        perintahx[1]:='/ip/hotspot/user/profile/set';
        perintahx[2]:='=on-login=';
        perintahx[3]:='=.id='+Res.ValueByName['.id'];
        // Menyimpan Perintah Kedalam Variabel pa
        SetLength(pa, 0);
        for j := 1 to 3 do
        begin
          s := Trim(perintahx[j]);
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
  // End Edit User Profile

       Ras := ROS.Query(['/system/scheduler/print'], True);
        if ROS.LastError <> '' then
        MessageDlg('ERROR : ' + ROS.LastError,mtError,[mbok],0);

        while not Ras.Eof do
        begin
        if (Ras.ValueByName['name']='the-userman-validity') then
        begin
        perintahs[1]:='/system/scheduler/remove';
        perintahs[2]:='=.id='+Ras.ValueByName['.id'];
        // Menyimpan Perintah Kedalam Variabel pa
        SetLength(pa, 0);
        for k := 1 to 2 do
        begin
          s := Trim(perintahs[k]);
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
        end;
       Ras.Next;
       end;

      MessageDlg(Gunakan(CekBahasa(),'MAIN','ValidRemove'),mtInformation,[mbok],0);

      myinifile := Tinifile.Create(ExtractFilePath(Application.exename)+'config.ini');
      with myinifile do begin
      WriteString('CONFIG','Validity','');
      WriteString('CONFIG','ValidityInterval','');
      Free;
      end;

      BSimpan.Caption:='Install';
     end;
    end;
    ROS.Free;
end;

procedure TFValidityInstall.CbIntervalKeyPress(Sender: TObject; var Key: char);
begin
  key:=#0;
end;

procedure TFValidityInstall.FormShow(Sender: TObject);
var
  myinifile   : TIniFile;
begin
  // Cek Apakah ada Validity atau tidak
  myinifile := TIniFile.Create(ExtractFilePath(Application.ExeName) + 'config.ini');
    with myinifile do
    begin

    if not (GSMDecode7Bit(GSMDecode7Bit(ReadString('CONFIG','ValidityInterval','0')))='') then
       CbInterval.Text:=GSMDecode7Bit(GSMDecode7Bit(ReadString('CONFIG','ValidityInterval','0')))
       else
       CbInterval.Text:=Gunakan(CekBahasa(),'ValidityInstall','IntervalSelect');

    if GSMDecode7Bit(GSMDecode7Bit(ReadString('CONFIG','Validity','0')))='YES' then
       BSimpan.Caption:=Gunakan(CekBahasa(),'ValidityInstall','Uninstall')
       else
       BSimpan.Caption:=Gunakan(CekBahasa(),'ValidityInstall','Install');
    Free;

    end;

    CbInterval.Items.Clear;
    CbInterval.Items.Add(Gunakan(CekBahasa(),'ValidityInstall','IntervalMenit'));
    CbInterval.Items.Add(Gunakan(CekBahasa(),'ValidityInstall','IntervalJam'));
    CbInterval.Items.Add(Gunakan(CekBahasa(),'ValidityInstall','IntervalHari'));
    GroupInt.Caption:=Gunakan(CekBahasa(),'ValidityInstall','Group');
    Caption:=Gunakan(CekBahasa(),'ValidityInstall','FTitle');
end;



end.


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

unit uquota;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  Buttons, StdCtrls, ComCtrls, bahasa, RouterOSAPI, ssl_openssl;

type

  { TFQuota }

  TFQuota = class(TForm)
    BSaveQuota: TBitBtn;
    CPilih: TComboBox;
    ETotal: TEdit;
    EDownload: TEdit;
    EUpload: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    LStatus: TLabel;
    PanelAtas: TPanel;
    PanelBawah: TPanel;
    PanelTengah: TPanel;
    ProgressBar: TProgressBar;
    procedure BSaveQuotaClick(Sender: TObject);
    procedure CPilihKeyPress(Sender: TObject; var Key: char);
    procedure EDownloadKeyPress(Sender: TObject; var Key: char);
    procedure ETotalKeyPress(Sender: TObject; var Key: char);
    procedure EUploadKeyPress(Sender: TObject; var Key: char);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  FQuota: TFQuota;
  iArray : array of String;

implementation

 uses UUtama, UdataUserHotspot;

{$R *.lfm}

{ TFQuota }

 procedure Split(Delimiter: Char; Str: string; ListOfStrings: TStrings) ;
 begin
    ListOfStrings.Clear;
    ListOfStrings.Delimiter       := Delimiter;
    ListOfStrings.StrictDelimiter := True; // Requires D2006 or newer.
    ListOfStrings.DelimitedText   := Str;
 end;

procedure TFQuota.FormCreate(Sender: TObject);
begin
  FQuota.Caption:=Gunakan(CekBahasa(),'QuotaLimit','FTitle');
  PanelAtas.Caption:=Gunakan(CekBahasa(),'QuotaLimit','Title');
  Label1.Caption:=Gunakan(CekBahasa(),'QuotaLimit','UploadLimit');
  Label2.Caption:=Gunakan(CekBahasa(),'QuotaLimit','DownloadLimit');
  Label3.Caption:=Gunakan(CekBahasa(),'QuotaLimit','TotalLimit');
  BSaveQuota.Caption:=Gunakan(CekBahasa(),'QuotaLimit','Bsave');
end;

procedure TFQuota.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  EUpload.Text:='';
  EDownload.Text:='';
  ETotal.Text:='';
end;

procedure TFQuota.BSaveQuotaClick(Sender: TObject);
var
  Ras : TRosApiResult;
  f : Boolean;
  ROS : TRosApiClient;
  j,i       : integer;
  pa,pb        : array of AnsiString;
  perintah  : array[1..5] of String;
  s,t         : String;
  ketres    : String;
Hasil1, Hasil2 : TStringList;
begin
  ROS := TRosApiClient.Create;
      // Koneksi
    if (FUtama.LTLS.Caption='TRUE') then
       ROS.SSLConnect(FUtama.LIP.Caption, FUtama.LUser.Caption, FUtama.LPass.Caption) else
       ROS.Connect(FUtama.LIP.Caption, FUtama.LUser.Caption, FUtama.LPass.Caption);

  if (EUpload.Text='') or (EDownload.Text='') or (ETotal.Text='') then
     MessageDlg(Gunakan(CekBahasa(),'QuotaLimit','SaveBlank'),mtWarning,[mbok],0) else
     if (LStatus.Caption='ALL') then
        begin
        Ras := ROS.Query(['/ip/hotspot/user/print'], True);
        ProgressBar.Show;
        ProgressBar.Max:=Ras.RowsCount;
        for i := 1 to Ras.RowsCount do begin
        ProgressBar.Position:=i;
        // Pecah Perintah Kedalam Array
        perintah[1]:='/ip/hotspot/user/set';
        perintah[2]:='=limit-bytes-in='+FloatToStr((StrToInt64(EDownload.Text)*1024)*1024);
        perintah[3]:='=limit-bytes-out='+FloatToStr((StrToInt64(EUpload.Text)*1024)*1024);
        perintah[4]:='=limit-bytes-total='+FloatToStr((StrToInt64(ETotal.Text)*1024)*1024);
        perintah[5]:='=.id='+Ras.ValueByName['.id'];
        // Menyimpan Perintah Kedalam Variabel pa
        SetLength(pa, 0);
        for j := 1 to 5 do
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
        Ras.Next;
        end;
        ProgressBar.Hide;
        MessageDlg(Gunakan(CekBahasa(),'QuotaLimit','SaveSuccess'),mtInformation,[mbok],0);
        end else
        if LStatus.Caption='BW' then
        if CPilih.Text=Gunakan(CekBahasa(),'GLOBAL','SelectGroup') then
        MessageDlg(Gunakan(CekBahasa(),'QuotaLimit','SaveBlank'),mtWarning,[mbok],0)
        else
        begin
        // Pecah Perintah Kedalam Array
         perintah[1]:='/ip/hotspot/user/print';
         perintah[2]:='?profile='+CPilih.Text;
         SetLength(pb, 0);
         for j := 1 to 2 do
         begin
         t := Trim(perintah[j]);
         if t <> '' then
         begin
         SetLength(pb, High(pb) + 2);
         pb[High(pb)] := t;
         end;
         end;
         //Eksekusi Perintah
           if High(pb) >= 0 then
           Ras := ROS.Query(pb,True)
           else
           begin
           MessageDlg('ERROR : ' + ROS.LastError,mtWarning,[mbok],0);
           Exit;
           end;
           // Cek Apakah ada Error
           if ROS.LastError <> '' then
           MessageDlg('ERROR : ' + ROS.LastError,mtError,[mbok],0);
           ProgressBar.Show;
           ProgressBar.Max:=Ras.RowsCount;
           for i := 1 to Ras.RowsCount do begin
           ProgressBar.Position:=i;
                // Pecah Perintah Kedalam Array
                perintah[1]:='/ip/hotspot/user/set';
                perintah[2]:='=limit-bytes-in='+FloatToStr((StrToInt64(EDownload.Text)*1024)*1024);
                perintah[3]:='=limit-bytes-out='+FloatToStr((StrToInt64(EUpload.Text)*1024)*1024);
                perintah[4]:='=limit-bytes-total='+FloatToStr((StrToInt64(ETotal.Text)*1024)*1024);
                perintah[5]:='=.id='+Ras.ValueByName['.id'];
                // Menyimpan Perintah Kedalam Variabel pa
                SetLength(pa, 0);
                for j := 1 to 5 do
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
                Ras.Next;
                end;
           ProgressBar.Hide;
        MessageDlg(Gunakan(CekBahasa(),'QuotaLimit','SaveSuccess'),mtInformation,[mbok],0);
        end else
        if LStatus.Caption='CM' then
        if CPilih.Text=Gunakan(CekBahasa(),'GLOBAL','SelectComent') then
        MessageDlg(Gunakan(CekBahasa(),'QuotaLimit','SaveBlank'),mtWarning,[mbok],0)
        else
        begin
         Ras := ROS.Query(['/ip/hotspot/user/print'], True);

  	  if (Ras.RowsCount > 0) then
  	    begin
            ProgressBar.Show;
            ProgressBar.Max:=Ras.RowsCount;
  	    for i := 1 to Ras.RowsCount do
  	       begin
            ProgressBar.Position:=i;
  		   // Pecah Komentar Ras
  		   try
  		   Hasil1 := TStringList.Create;
  		   Hasil2 := TStringList.Create;
  		   Split('"', Ras.ValueByName['comment'], Hasil1);
  	       if (Hasil1.Count>1) then
  		   begin
  		   Split(':', Hasil1[0], Hasil2);
  		   ketres := Hasil2[0];
  		   end else
  		   begin
  		   ketres := Ras.ValueByName['comment'];
  		   end;
  		   except
  		   end;
  		   // Cek Apakah Komentar Sama
  	       if (Trim(ketres)=CPilih.Text) then
  		   begin
                   // Pecah Perintah Kedalam Array
                   perintah[1]:='/ip/hotspot/user/set';
                   perintah[2]:='=limit-bytes-in='+FloatToStr((StrToInt64(EDownload.Text)*1024)*1024);
                   perintah[3]:='=limit-bytes-out='+FloatToStr((StrToInt64(EUpload.Text)*1024)*1024);
                   perintah[4]:='=limit-bytes-total='+FloatToStr((StrToInt64(ETotal.Text)*1024)*1024);
                   perintah[5]:='=.id='+Ras.ValueByName['.id'];
  		   // Menyimpan Perintah Kedalam Variabel pa
  		   SetLength(pa, 0);
  		   for j := 1 to 5 do
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
  		   MessageDlg('ERROR : ' + ROS.LastError,mtError,[mbok],0);
  		   end;
                   Sleep(10);
  		   Ras.Next;
  	       end;
            end;
          ProgressBar.Hide;
         MessageDlg(Gunakan(CekBahasa(),'QuotaLimit','SaveSuccess'),mtInformation,[mbok],0);
        end;
        FDataUserHotspot.FormShow(Sender);
        ROS.Free;
  end;

procedure TFQuota.CPilihKeyPress(Sender: TObject; var Key: char);
begin
  Key:=#0;
end;

procedure TFQuota.EDownloadKeyPress(Sender: TObject; var Key: char);
begin
      if not (key in['0'..'9',#8,#13,#32]) then
 begin
 key:=#0;
 end;
end;

procedure TFQuota.ETotalKeyPress(Sender: TObject; var Key: char);
begin
      if not (key in['0'..'9',#8,#13,#32]) then
 begin
 key:=#0;
 end;
end;

procedure TFQuota.EUploadKeyPress(Sender: TObject; var Key: char);
begin
      if not (key in['0'..'9',#8,#13,#32]) then
 begin
 key:=#0;
 end;
end;

procedure TFQuota.FormShow(Sender: TObject);
var
  Res : TRosApiResult;
  i, pos, last: integer;
  newNumber: boolean;
  ROS       : TRosApiClient;
  rArray : array of String;
  ketres : String;
  Hasil1, Hasil2 : TStringList;
  begin
  EUpload.SetFocus;

  if not (LStatus.Caption='ALL') then
  begin
   ROS := TRosApiClient.Create;
   if (LStatus.Caption='BW') then
   begin
    if (FUtama.LTLS.Caption='TRUE') then
       ROS.SSLConnect(FUtama.LIP.Caption, FUtama.LUser.Caption, FUtama.LPass.Caption) else
       ROS.Connect(FUtama.LIP.Caption, FUtama.LUser.Caption, FUtama.LPass.Caption);

    Res := ROS.Query(['/ip/hotspot/user/profile/print'], True);
    if ROS.LastError <> '' then
    MessageDlg('ERROR : ' + ROS.LastError,mtError,[mbok],0);
    CPilih.Items.Clear;

  while not Res.Eof do
  begin
    for i := 1 to Res.RowsCount do
    begin
      CPilih.Items.Add(Res.ValueByName['name']);
      Res.Next;
    end;
  end;
  end else
  if (LStatus.Caption='CM') then
  begin
   if (FUtama.LTLS.Caption='TRUE') then
      ROS.SSLConnect(FUtama.LIP.Caption, FUtama.LUser.Caption, FUtama.LPass.Caption) else
      ROS.Connect(FUtama.LIP.Caption, FUtama.LUser.Caption, FUtama.LPass.Caption);

   Res := ROS.Query(['/ip/hotspot/user/print'], True);

   if ROS.LastError <> '' then
   MessageDlg('ERROR : ' + ROS.LastError,mtError,[mbok],0);
   CPilih.Items.Clear;

   if (Res.RowsCount>0) then
   begin

      SetLength(iArray,Res.RowsCount);
      SetLength(rArray,Res.RowsCount);

     for i := 0 to Res.RowsCount-1 do
     begin
     try

        Hasil1 := TStringList.Create;
        Hasil2 := TStringList.Create;

        Split('"', Res.ValueByName['comment'], Hasil1);
        if (Hasil1.Count>1) then
        begin
        Split(':', Hasil1[0], Hasil2);
        ketres := Hasil2[0];
        end else
        ketres := Res.ValueByName['comment'];
     except end;
       iArray[i] := Trim(ketres);
       Res.Next;
       end;
  // Remove Duplicate Comment dari iArray
  i          := 0;
  rArray[0]  := iArray[0];
  last       := 0;
  pos        := 0;

  while pos < high(iArray) do
  begin
    inc(pos);
    newNumber := true;
    for i := low(rArray) to last do
      if iArray[pos] = rArray[i] then
      begin
        newNumber := false;
	break;
      end;
    if newNumber then
    begin
      inc(last);
      rArray[last] := iArray[pos];
    end;
  end;
  i:=1;
  for i := low(rArray) to last do
  begin
  if not (rArray[i]='') then
    CPilih.Items.Add(rArray[i]);
  end;
 end;
      end;
    Res.Free;
    ROS.Free;
   end;
   end;
end.


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

unit UDataUserHotspot;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  Buttons, Grids, StdCtrls, Menus, RouterOSAPI, ssl_openssl, bahasa, ComObj, Variants;

type

  { TFDataUserHotspot }

  TFDataUserHotspot = class(TForm)
    BClose: TBitBtn;
    BEdit: TBitBtn;
    BHapus: TBitBtn;
    BGenerate: TBitBtn;
    BHapusCounter: TBitBtn;
    BImp: TBitBtn;
    BTambah: TBitBtn;
    GridUserHotspot: TStringGrid;
    LID: TLabel;
    LIndex: TLabel;
    LHarga: TLabel;
    LValid: TLabel;
    LPassword: TLabel;
    LUptime: TLabel;
    LComment: TLabel;
    LNama: TLabel;
    LLimitUptime: TLabel;
    LProfile: TLabel;
    MenuEdit: TMenuItem;
    MenuHapusCounter: TMenuItem;
    MenuHapus: TMenuItem;
    OpenExcel: TOpenDialog;
    PanelJmlUser: TPanel;
    PanelAtas: TPanel;
    PanelBawah: TPanel;
    PanelTengah: TPanel;
    PopupMenuDaftarUserHotspot: TPopupMenu;
    GridImport: TStringGrid;
    procedure BCloseClick(Sender: TObject);
    procedure BEditClick(Sender: TObject);
    procedure BGenerateClick(Sender: TObject);
    procedure BHapusClick(Sender: TObject);
    procedure BHapusCounterClick(Sender: TObject);
    procedure BImpClick(Sender: TObject);
    procedure BTambahClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    //procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
   // procedure GridUserHotspotClick(Sender: TObject);
    procedure GridUserHotspotDrawCell(Sender: TObject; aCol, aRow: Integer;
      aRect: TRect; aState: TGridDrawState);
    procedure GridUserHotspotPrepareCanvas(sender: TObject; aCol,
      aRow: Integer; aState: TGridDrawState);
    procedure GridUserHotspotSelectCell(Sender: TObject; aCol, aRow: Integer;
      var CanSelect: Boolean);
    procedure GridUserHotspotSelection(Sender: TObject; aCol, aRow: Integer);
    //procedure GridUserHotspotTopLeftChanged(Sender: TObject);
   // procedure MemoIndexChange(Sender: TObject);
    procedure MenuEditClick(Sender: TObject);
    procedure MenuHapusClick(Sender: TObject);
    procedure MenuHapusCounterClick(Sender: TObject);
   // procedure gridcheckboxMouseDown(Sender: TObject;
        //      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
  private
      ROS : TRosApiClient;
      ResListen: TRosApiResult;
    { private declarations }
  public
    { public declarations }
  end;

var
  FDataUserHotspot: TFDataUserHotspot;
  totpilih : string;

implementation

uses UUtama, UTambahUserHotspot, UGenerateUserHotspot;

{$R *.lfm}

{ TFDataUserHotspot }

procedure Split(Delimiter: Char; Str: string; ListOfStrings: TStrings) ;
begin
   ListOfStrings.Clear;
   ListOfStrings.Delimiter       := Delimiter;
   ListOfStrings.StrictDelimiter := True; // Requires D2006 or newer.
   ListOfStrings.DelimitedText   := Str;
end;

procedure LoadCSV(Filename: string; sg: TStringGrid);
var
   i, j, Position, count, edt1: integer;
   temp, tempField : string;
   FieldDel: char;
   Data: TStringList;
begin
  Data := TStringList.Create;
  FieldDel := ';';
  Data.LoadFromFile(Filename);
  temp :=  Data[1];
  count := 0;
  for i:= 1 to length(temp) do
    if copy(temp,i,1) =  FieldDel then
      inc(count);
  edt1 := count+1;
  sg.ColCount := 30;
  sg.RowCount := Data.Count +1;
  sg.FixedCols := 0;
  for i := 0 to Data.Count - 1 do
    begin;
      temp :=  Data[i];
      if copy(temp,length(temp),1) <> FieldDel then
        temp := temp + FieldDel;
      while Pos('"', temp) > 0 do
        begin
          Delete(temp,Pos('"', temp),1);
        end;
      for j := 1 to edt1 do
      begin
        Position := Pos(FieldDel,temp);
        tempField := copy(temp,0,Position-1);
        sg.Cells[j-1,i+1] := tempField;
        Delete(temp,1,length(tempField)+1);
      end;
    end;
    Data.Free;
end;

procedure TFDataUserHotspot.BCloseClick(Sender: TObject);
begin
FDataUserHotspot.CleanupInstance;
FUtama.BackGround.Visible:=True;
FDataUserHotspot.Close;
end;

procedure TFDataUserHotspot.BEditClick(Sender: TObject);
begin
     if (LID.Caption='') then
        MessageDlg(Gunakan(CekBahasa(),'HOTSPOTUSER','SelectTableWarning'),mtWarning,[mbok],0) else
       begin
       FTambahUserHotspot.Caption:=Gunakan(CekBahasa(),'ADDHOTSPOTUSER','EFTitle');
       FTambahUserHotspot.PanelAtas.Caption:=Gunakan(CekBahasa(),'ADDHOTSPOTUSER','EFTitle');
       FTambahUserHotspot.BBaru.Caption:=Gunakan(CekBahasa(),'GLOBAL','BClear');
       FTambahUserHotspot.LID.Caption:=LID.Caption;
       FTambahUserHotspot.EUsername.Text:=LNama.Caption;
       FTambahUserHotspot.EPassword.Text:=LPassword.Caption;
       FTambahUserHotspot.MKeterangan.Clear;
       FTambahUserHotspot.MKeterangan.Lines.Add(LComment.Caption);
       FTambahUserHotspot.CGLBW.Text:=LProfile.Caption;
       FTambahUserHotspot.LHarga.Caption:=LHarga.Caption;
       FTambahUserHotspot.LValid.Caption:=LValid.Caption;
       FTambahUserHotspot.BSimpan.Caption:=Gunakan(CekBahasa(),'GLOBAL','BUpdate');
       FTambahUserHotspot.UserAction.Caption:='Update';
       FTambahUserHotspot.ShowModal;
       end;
end;

procedure TFDataUserHotspot.BGenerateClick(Sender: TObject);
begin
FGenerateUserHotspot.CBServer.Text:=Gunakan(CekBahasa(),'GLOBAL','Select');
FGenerateUserHotspot.CPanjangUser.Text:=Gunakan(CekBahasa(),'GLOBAL','Select');
FGenerateUserHotspot.CPanjangPass.Text:=Gunakan(CekBahasa(),'GLOBAL','Select');
FGenerateUserHotspot.CGLBW.Text:=Gunakan(CekBahasa(),'GLOBAL','SelectGroup');
FGenerateUserHotspot.CLimitWaktu.Text:=Gunakan(CekBahasa(),'GLOBAL','Select');
FGenerateUserHotspot.ShowModal;
end;

procedure TFDataUserHotspot.BHapusClick(Sender: TObject);
var
  pa: array of AnsiString;
  perintah : array[1..2] of String;
  s : String;
  i,j : integer;
  pec : TStringList;
begin
  pec := TStringList.Create;
  Split('-', totpilih, pec);

  if (pec.Count > 1) then
     begin
     if MessageDlg(Gunakan(CekBahasa(),'HOTSPOTUSER','DelUserConfirmMany')+' ?',mtConfirmation,[mbyes,mbno],0)=mrYes then
    begin
    for j := 0 to (pec.Count-1) do begin
    // Pecah Perintah Kedalam Array
    perintah[1]:='/ip/hotspot/user/remove';
    perintah[2]:='=.id='+GridUserHotspot.Cells[2,StrToInt(trim(pec[j]))];
    // Menyimpan Perintah Kedalam Variabel pa
    SetLength(pa, 0);
    for i := 1 to 2 do
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

    // Cek Apakah ada Error
    if ROS.LastError <> '' then
    MessageDlg('ERROR : ' + ROS.LastError,mtError,[mbok],0);

    end;
  FDataUserHotspot.FormShow(Sender);

      end else Abort;
    end else
  if (LID.Caption='') then
     MessageDlg(Gunakan(CekBahasa(),'HOTSPOTUSER','SelectTableWarning'),mtWarning,[mbok],0) else
       if MessageDlg(Gunakan(CekBahasa(),'HOTSPOTUSER','DelUserConfirm')+' "'+LNama.Caption+'"?',mtConfirmation,[mbyes,mbno],0)=mrYes then
    begin
    // Pecah Perintah Kedalam Array
    perintah[1]:='/ip/hotspot/user/remove';
    perintah[2]:='=.id='+LID.Caption;
    // Menyimpan Perintah Kedalam Variabel pa
    SetLength(pa, 0);
    for i := 1 to 2 do
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

    if ROS.LastError <> '' then
    MessageDlg('ERROR : ' + ROS.LastError,mtError,[mbok],0);

      FDataUserHotspot.FormShow(Sender);
      end else Abort;
    end;

procedure TFDataUserHotspot.BHapusCounterClick(Sender: TObject);
var
  pa: array of AnsiString;
  perintah : array[1..2] of String;
  s : String;
  i,j : integer;
  pec : TStringList;
begin
  pec := TStringList.Create;
  Split('-', totpilih, pec);

  if (pec.Count > 1) then
     begin
     if MessageDlg(Gunakan(CekBahasa(),'HOTSPOTUSER','CCounterConfirmMany_1')+'? '+Gunakan(CekBahasa(),'HOTSPOTUSER','CCounterConfirmMany_2'),mtConfirmation,[mbyes,mbno],0)=mrYes then
  begin
  for j := 0 to (pec.Count-1) do begin
  // Pecah Perintah Kedalam Array
  perintah[1]:='/ip/hotspot/user/reset-counters';
  perintah[2]:='=.id='+GridUserHotspot.Cells[2,StrToInt(trim(pec[j]))];
  // Menyimpan Perintah Kedalam Variabel pa
  SetLength(pa, 0);
  for i := 1 to 2 do
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
  // Cek Apakah ada Error
  if ROS.LastError <> '' then
  MessageDlg('ERROR : ' + ROS.LastError,mtError,[mbok],0);
  end;
    FormShow(Sender);
    end else Abort;
     end else
  if (LID.Caption='') then
     MessageDlg(Gunakan(CekBahasa(),'HOTSPOTUSER','SelectTableWarning'),mtWarning,[mbok],0) else
       if MessageDlg(Gunakan(CekBahasa(),'HOTSPOTUSER','CCounterConfirm_1')+' "'+LNama.Caption+'"? '+Gunakan(CekBahasa(),'HOTSPOTUSER','CCounterConfirm_2'),mtConfirmation,[mbyes,mbno],0)=mrYes then
    begin
    // Pecah Perintah Kedalam Array
    perintah[1]:='/ip/hotspot/user/reset-counters';
    perintah[2]:='=.id='+LID.Caption;
    // Menyimpan Perintah Kedalam Variabel pa
    SetLength(pa, 0);
    for i := 1 to 2 do
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
    // Cek Apakah ada Error
    if ROS.LastError <> '' then
    MessageDlg('ERROR : ' + ROS.LastError,mtError,[mbok],0)
    else
      FormShow(Sender)
      end else Abort;
    end;

procedure TFDataUserHotspot.BImpClick(Sender: TObject);
var
  pa: array of AnsiString;
  perintah : array[1..7] of String;
  i,ulang,j : integer;
  s : String;
begin
  if OpenExcel.Execute then
  begin
  LoadCSV(OpenExcel.FileName, GridImport);
  // Tambahkan ke RouterBoard
  if (FUtama.LTLS.Caption='TRUE') then
       ROS.SSLConnect(FUtama.LIP.Caption, FUtama.LUser.Caption, FUtama.LPass.Caption) else
       ROS.Connect(FUtama.LIP.Caption, FUtama.LUser.Caption, FUtama.LPass.Caption);

    FUtama.ProgressBar.Max:=GridImport.RowCount-1;
    FUtama.ProgressBar.Visible:=True;
    for j := 1 to GridImport.RowCount-1 do begin
    FUtama.ProgressBar.Position:=i;
    // Pecah Perintah Kedalam Array
    perintah[1]:='/ip/hotspot/user/add';
    perintah[2]:='=server='+GridImport.Cells[0,j];
    perintah[3]:='=name='+GridImport.Cells[1,j];
    perintah[4]:='=profile='+GridImport.Cells[2,j];
    perintah[5]:='=password='+GridImport.Cells[3,j];
    perintah[6]:='=comment='+GridImport.Cells[4,j];
    perintah[7]:='=disabled=no';
    ulang := 7;
    // Menyimpan Perintah Kedalam Variabel pa
    SetLength(pa, 0);
    for i := 1 to ulang do
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
    // Cek Apakah ada Error
    if ROS.LastError <> '' then
    MessageDlg('ERROR : ' + ROS.LastError,mtError,[mbok],0);
    Sleep(10);
    end;
    FUtama.ProgressBar.Visible:=False;
    MessageDlg(Gunakan(CekBahasa(),'ADDHOTSPOTUSER','ImportSuccess'),mtInformation,[mbok],0);
    FDataUserHotspot.FormShow(Sender);
  end;
end;

procedure TFDataUserHotspot.BTambahClick(Sender: TObject);
begin
 FTambahUserHotspot.CBServer.Text:=Gunakan(CekBahasa(),'GLOBAL','Select');
 FTambahUserHotspot.Caption:=Gunakan(CekBahasa(),'ADDHOTSPOTUSER','AFTitle');
 FTambahUserHotspot.PanelAtas.Caption:=Gunakan(CekBahasa(),'ADDHOTSPOTUSER','AFTitle');
 FTambahUserHotspot.BBaru.Caption:=Gunakan(CekBahasa(),'GLOBAL','BNew');
 FTambahUserHotspot.LID.Caption:='';
 FTambahUserHotspot.EUsername.Text:='';
 FTambahUserHotspot.EPassword.Text:='';
 FTambahUserHotspot.MKeterangan.Lines.Clear;
 FTambahUserHotspot.CGLBW.Text:=Gunakan(CekBahasa(),'GLOBAL','SelectGroup');
 FTambahUserHotspot.BSimpan.Caption:=Gunakan(CekBahasa(),'GLOBAL','BSave');
 FTambahUserHotspot.UserAction.Caption:='Save';
 FTambahUserHotspot.ShowModal;
end;

procedure TFDataUserHotspot.FormClose(Sender: TObject;
  var CloseAction: TCloseAction);
begin
end;


procedure TFDataUserHotspot.FormCreate(Sender: TObject);
begin
ROS := TRosApiClient.Create;
ResListen := nil;
FDataUserHotspot.PanelAtas.Caption:=Gunakan(CekBahasa(),'HOTSPOTUSER','FTitle');
FDataUserHotspot.BGenerate.Caption:=Gunakan(CekBahasa(),'HOTSPOTUSER','BGenerate');
FDataUserHotspot.BHapusCounter.Caption:=Gunakan(CekBahasa(),'HOTSPOTUSER','BCCounter');
FDataUserHotspot.BTambah.Caption:=Gunakan(CekBahasa(),'GLOBAL','BAdd');
FDataUserHotspot.BEdit.Caption:=Gunakan(CekBahasa(),'GLOBAL','BEdit');
FDataUserHotspot.MenuEdit.Caption:=Gunakan(CekBahasa(),'GLOBAL','BEdit');
FDataUserHotspot.MenuHapusCounter.Caption:=Gunakan(CekBahasa(),'HOTSPOTUSER','BCCounter');
FDataUserHotspot.BHapus.Caption:=Gunakan(CekBahasa(),'GLOBAL','BDelete');
FDataUserHotspot.MenuHapus.Caption:=Gunakan(CekBahasa(),'GLOBAL','BDelete');
FDataUserHotspot.BClose.Caption:=Gunakan(CekBahasa(),'GLOBAL','BClose');
FDataUserHotspot.BImp.Caption:=Gunakan(CekBahasa(),'HOTSPOTUSER','BImp');
end;

procedure TFDataUserHotspot.FormDestroy(Sender: TObject);
begin
  ROS.Free;
end;

procedure TFDataUserHotspot.FormShow(Sender: TObject);
var
  Res : TRosApiResult;
  i, j: Integer;
  keterangan, harga, berlaku, idx, uppx, downpx : String;
  Hasil1, Hasil2 : TStringList;
  upx, downx, totx : double;
begin

  FDataUserHotspot.LID.Caption:='';
  FDataUserHotspot.LNama.Caption:='';
  FDataUserHotspot.LLimitUptime.Caption:='';
  FDataUserHotspot.LProfile.Caption:='';
  FDataUserHotspot.LUptime.Caption:='';
  FDataUserHotspot.LPassword.Caption:='';
  FDataUserHotspot.LComment.Caption:='';

  if (FUtama.LTLS.Caption='TRUE') then
     ROS.SSLConnect(FUtama.LIP.Caption, FUtama.LUser.Caption, FUtama.LPass.Caption) else
     ROS.Connect(FUtama.LIP.Caption, FUtama.LUser.Caption, FUtama.LPass.Caption);

    Res := ROS.Query(['/ip/hotspot/user/print'], True);

    if ROS.LastError <> '' then
    MessageDlg('ERROR : ' + ROS.LastError,mtError,[mbok],0);
    PanelJmlUser.Caption:=Gunakan(CekBahasa(),'HOTSPOTUSER','PUserCount')+' '+IntToStr(Res.RowsCount);
    GridUserHotspot.RowCount := Res.RowsCount+1;

    // Ukuran Kolom
    FDataUserHotspot.GridUserHotspot.ColCount := 17;
    FDataUserHotspot.GridUserHotspot.ColWidths[0]:=10;
    FDataUserHotspot.GridUserHotspot.ColWidths[1]:=27;
    FDataUserHotspot.GridUserHotspot.ColWidths[2]:=30;
    FDataUserHotspot.GridUserHotspot.ColWidths[3]:=FUtama.Width div 14;
    FDataUserHotspot.GridUserHotspot.ColWidths[4]:=FUtama.Width div 14;
    FDataUserHotspot.GridUserHotspot.ColWidths[5]:=FUtama.Width div 14;
    FDataUserHotspot.GridUserHotspot.ColWidths[6]:=FUtama.Width div 14;
    FDataUserHotspot.GridUserHotspot.ColWidths[7]:=FUtama.Width div 14;
    FDataUserHotspot.GridUserHotspot.ColWidths[8]:=FUtama.Width div 14;
    FDataUserHotspot.GridUserHotspot.ColWidths[9]:=FUtama.Width div 14;
    FDataUserHotspot.GridUserHotspot.ColWidths[10]:=FUtama.Width div 14;
    FDataUserHotspot.GridUserHotspot.ColWidths[11]:=FUtama.Width div 14;
    FDataUserHotspot.GridUserHotspot.ColWidths[12]:=FUtama.Width div 14;
    FDataUserHotspot.GridUserHotspot.ColWidths[13]:=FUtama.Width div 14;
    FDataUserHotspot.GridUserHotspot.ColWidths[14]:=FUtama.Width div 14;
    FDataUserHotspot.GridUserHotspot.ColWidths[15]:=FUtama.Width div 14;
    FDataUserHotspot.GridUserHotspot.ColWidths[16]:=FUtama.Width div 14;
    // Nama Kolom
    GridUserHotspot.Cells[0,0] := '';
    GridUserHotspot.Cells[1,0] := '#';
    GridUserHotspot.Cells[2,0] := Gunakan(CekBahasa(),'HOTSPOTUSER','ID');
    GridUserHotspot.Cells[3,0] := Gunakan(CekBahasa(),'HOTSPOTUSER','UserLogin');
    GridUserHotspot.Cells[4,0] := Gunakan(CekBahasa(),'HOTSPOTUSER','BandwidthLimitation');
    GridUserHotspot.Cells[5,0] := Gunakan(CekBahasa(),'HOTSPOTUSER','TimeLimit');
    GridUserHotspot.Cells[6,0] := Gunakan(CekBahasa(),'HOTSPOTUSER','Password');
    GridUserHotspot.Cells[7,0] := Gunakan(CekBahasa(),'HOTSPOTUSER','Price');
    GridUserHotspot.Cells[8,0] := Gunakan(CekBahasa(),'HOTSPOTUSER','Valid');
    GridUserHotspot.Cells[9,0] := Gunakan(CekBahasa(),'HOTSPOTUSER','Uptime');
    GridUserHotspot.Cells[10,0] := Gunakan(CekBahasa(),'HOTSPOTUSER','Comment');
    GridUserHotspot.Cells[11,0] := Gunakan(CekBahasa(),'HOTSPOTUSER','Disable');
    GridUserHotspot.Cells[12,0] := Gunakan(CekBahasa(),'HOTSPOTUSER','UploadLimit');
    GridUserHotspot.Cells[13,0] := Gunakan(CekBahasa(),'HOTSPOTUSER','DownloadLimit');
    GridUserHotspot.Cells[14,0] := Gunakan(CekBahasa(),'HOTSPOTUSER','TotalLimit');
    GridUserHotspot.Cells[15,0] := Gunakan(CekBahasa(),'HOTSPOTUSER','ByteIn');
    GridUserHotspot.Cells[16,0] := Gunakan(CekBahasa(),'HOTSPOTUSER','ByteOut');
    j := 1;

    for i := 1 to Res.RowsCount do
    begin

    try
    Hasil1 := TStringList.Create;
    Hasil2 := TStringList.Create;
    Split('"', Res.ValueByName['comment'], Hasil1);
    if (Hasil1.Count>1) then
    begin
    harga      := Hasil1[1];
    berlaku    := Hasil1[2];
    Split(':', Hasil1[0], Hasil2);
    keterangan := Hasil2[0];
    end else
    begin
    harga      := '-';
    berlaku    := '-';
    keterangan := Res.ValueByName['comment'];
    end;
    except
    end;

    if Res.ValueByName['limit-bytes-out'] <> '' then
    upx := StrToFloat(Res.ValueByName['limit-bytes-out']) / 1024 / 1024;

    if Res.ValueByName['limit-bytes-in'] <> '' then
    downx := StrToFloat(Res.ValueByName['limit-bytes-in']) / 1024 / 1024;

    if Res.ValueByName['limit-bytes-total'] <> '' then
    totx := StrToFloat(Res.ValueByName['limit-bytes-total']) / 1024 / 1024;

    if StrToFloat(Res.ValueByName['bytes-out']) >= 1048576 then
    uppx := FormatFloat('#.##',StrToFloat(Res.ValueByName['bytes-out']) / 1024 / 1024)+' Mb' else
    if StrToFloat(Res.ValueByName['bytes-out']) >= 1024 then
    uppx := FormatFloat('#.##',StrToFloat(Res.ValueByName['bytes-out']) / 1024)+' Kb' else
    uppx := FloatToStr(StrToFloat(Res.ValueByName['bytes-out']))+' Byte';

    if StrToFloat(Res.ValueByName['bytes-in']) >= 1048576 then
    downpx := FormatFloat('#.##',StrToFloat(Res.ValueByName['bytes-in']) / 1024 / 1024)+' Mb' else
    if StrToFloat(Res.ValueByName['bytes-in']) >= 1024 then
    downpx := FormatFloat('#.##',StrToFloat(Res.ValueByName['bytes-in']) / 1024)+' Kb' else
    downpx := FloatToStr(StrToFloat(Res.ValueByName['bytes-in']))+' Byte';

    GridUserHotspot.Cells[0,j] := '';
    GridUserHotspot.Cells[1,j] := IntToStr(j);
    GridUserHotspot.Cells[2,j] := Res.ValueByName['.id'];
    GridUserHotspot.Cells[3,j] := Res.ValueByName['name'];
    GridUserHotspot.Cells[4,j] := Res.ValueByName['profile'];
    GridUserHotspot.Cells[5,j] := Res.ValueByName['limit-uptime'];
    GridUserHotspot.Cells[6,j] := Res.ValueByName['password'];
    GridUserHotspot.Cells[7,j] := harga;
    GridUserHotspot.Cells[8,j] := berlaku;
    GridUserHotspot.Cells[9,j] := Res.ValueByName['uptime'];
    GridUserHotspot.Cells[10,j] := keterangan;
    GridUserHotspot.Cells[11,j] := Res.ValueByName['disabled'];
    GridUserHotspot.Cells[12,j] := FloatToStr(upx)+' Mb'; // upload
    GridUserHotspot.Cells[13,j] := FloatToStr(downx)+' Mb'; // download
    GridUserHotspot.Cells[14,j] := FloatToStr(totx)+' Mb'; // total
    GridUserHotspot.Cells[15,j] := downpx; // total download
    GridUserHotspot.Cells[16,j] := uppx; // total upload
    j := j+1;
    GridUserHotspot.Refresh;

    upx:=0;
    downx:=0;
    totx:=0;
    uppx:='';
    downpx:='';

    Res.Next;

    end;

  Res.Free;
 // GridUserHotspot.Options := GridUserHotspot.Options + [goRowSelect];
end;

procedure TFDataUserHotspot.GridUserHotspotDrawCell(Sender: TObject; aCol,
  aRow: Integer; aRect: TRect; aState: TGridDrawState);
begin

    if GridUserHotspot.Cells[5,aRow] = GridUserHotspot.Cells[9,aRow] then
    begin
    GridUserHotspot.Canvas.Brush.Color:=clRed;
    GridUserHotspot.Canvas.Font.Color:=clBlack;
    end else
    if GridUserHotspot.Cells[11,aRow] = 'true' then
    begin
    GridUserHotspot.Canvas.Brush.Color:=clYellow;
    GridUserHotspot.Canvas.Font.Color:=clBlack;
    end else
    begin
    if ARow mod 2 = 0 then
    GridUserHotspot.Canvas.Brush.Color := clSilver
    else begin
    GridUserHotspot.SelectedColor:=clHighlight;
    GridUserHotspot.Options := GridUserHotspot.Options + [goDrawFocusSelected];
    end;
    end;
end;

procedure TFDataUserHotspot.GridUserHotspotPrepareCanvas(sender: TObject; aCol,
  aRow: Integer; aState: TGridDrawState);
begin
     if GridUserHotspot.Cells[5,aRow] = GridUserHotspot.Cells[9,aRow] then
     begin
     GridUserHotspot.Canvas.Brush.Color:=clRed;
     GridUserHotspot.Canvas.Font.Color:=clBlack;
     end else
     if GridUserHotspot.Cells[11,aRow] = 'true' then
     begin
     GridUserHotspot.Canvas.Brush.Color:=clYellow;
     GridUserHotspot.Canvas.Font.Color:=clBlack;
     end else
     begin
     if ARow mod 2 = 0 then
     GridUserHotspot.Canvas.Brush.Color := clSilver
     else begin
     GridUserHotspot.SelectedColor:=clHighlight;
     GridUserHotspot.Options := GridUserHotspot.Options + [goDrawFocusSelected];
     end;
     end;
     GridUserHotspot.Options := GridUserHotspot.Options + [goRowSelect];
end;

procedure TFDataUserHotspot.GridUserHotspotSelectCell(Sender: TObject; aCol,
  aRow: Integer; var CanSelect: Boolean);
begin
  LID.Caption:=GridUserHotspot.Cells[2,aRow];
  LNama.Caption:=GridUserHotspot.Cells[3,aRow];
  LProfile.Caption:=GridUserHotspot.Cells[4,aRow];
  LLimitUptime.Caption:=GridUserHotspot.Cells[5,aRow];
  LPassword.Caption:=GridUserHotspot.Cells[6,aRow];
  LUptime.Caption:=GridUserHotspot.Cells[7,aRow];
  LComment.Caption:=GridUserHotspot.Cells[10,aRow];
  LHarga.Caption:=GridUserHotspot.Cells[7,aRow];
  LValid.Caption:=GridUserHotspot.Cells[8,aRow];
end;

procedure TFDataUserHotspot.GridUserHotspotSelection(Sender: TObject; aCol,
  aRow: Integer);
var
  s : String;
  i: Integer;
  sel: TGridRect;
begin
  totpilih:='';
  for i:=0 to GridUserHotspot.SelectedRangeCount-1 do begin
    sel := GridUserHotspot.SelectedRange[i];
    if (goRowSelect in GridUserHotspot.Options) then begin
      if (sel.Top = sel.Bottom) then
        s := Format('%d', [sel.Top])
      else
        s := Format('%d-%d', [sel.Top, sel.Bottom]);
    end;
    totpilih := totpilih + s ;
  end;
end;

procedure TFDataUserHotspot.MenuEditClick(Sender: TObject);
begin
  BEditClick(Sender);
end;

procedure TFDataUserHotspot.MenuHapusClick(Sender: TObject);
begin
BHapusClick(Sender);
end;

procedure TFDataUserHotspot.MenuHapusCounterClick(Sender: TObject);
begin
BHapusCounterClick(Sender);
end;



end.


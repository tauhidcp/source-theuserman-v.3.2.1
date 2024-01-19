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

unit encode_decode;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils;

function GSMDecode7Bit(Value: string): WideString;
function GSMEncode7Bit(const Value: WideString): string;

implementation

// Encode dan Decode 7 Bit
const
  Alphabet7Escape: byte = $1B; // 27
  Alphabet7Bit: array[0..127] of word = (
      {0    1    2    3    4    5    6    7    8    9    A    B    C    D    E    F}
{0}   64, 163,  36, 165, 232, 233, 249, 236, 242, 199,  10, 216, 248,  13, 197, 229,
{1} $394,  95,$3A6,$393,$39B,$3A9,$3A0,$3A8,$3A3,$398,$39E,  27, 198, 230, 223, 201,
{2}   32,  33,  34,  35, 164,  37,  38,  39,  40,  41,  42,  43,  44,  45,  46,  47,
{3}   48,  49,  50,  51,  52,  53,  54,  55,  56,  57,  58,  59,  60,  61,  62,  63,
{4}  161,  65,  66,  67,  68,  69,  70,  71,  72,  73,  74,  75,  76,  77,  78,  79,
{5}   80,  81,  82,  83,  84,  85,  86,  87,  88,  89,  90, 196, 214, 209, 220, 167,
{6}  191,  97,  98,  99, 100, 101, 102, 103, 104, 105, 106, 107, 108, 109, 110, 111,
{7}  112, 113, 114, 115, 116, 117, 118, 119, 120, 121, 122, 228, 246, 241, 252, 224);

{ 7BIT helper functions }

function Unpack7Bit(const Value: string): string;
var
  i,j: Integer;
  x,leftover,octet: byte;
  c,septets: string;
begin
  Result := '';
  j := Round(Length(Value) / 2) - 1;
  septets := '';
  x := 1;
  leftover := 0;
  for i := 0 to j do begin
    c := copy(Value, (i*2)+1, 2);
    if not (c[1] in ['0'..'9','A'..'F']) then // do not localize
      break;
    if (Length(c) = 2) and not (c[2] in ['0'..'9','A'..'F']) then // do not localize
      Delete(c,2,1);
    octet := StrToInt('$' + c);
    septets := septets + Chr(((octet and ($FF shr x)) shl (x - 1)) or leftover);
    leftover := (octet and (not ($FF shr x))) shr (8 - x);
    x := x + 1;
    if x = 8 then begin
      if (i <> j) or (leftover <> 0) then
        septets := septets + Chr(leftover);
      x := 1;
      leftover := 0;
    end;
  end;
  Result := septets;
end;

function Pack7Bit(const Value: string): string;
var
  i,j: integer;
  x,nextChr: byte;
  septets,Octet: string;
begin
  Result := '';
  septets := Value;
  x := 0;
  j := length(septets);
  for i := 1 to j do begin
    if x < 7 then begin
      if i = j then
        nextChr := 0
      else
        nextChr := Ord(septets[i+1]);
      Octet := IntToHex(((nextChr and (not ($FF shl (x+1)))) shl (7-x)) or (Ord(septets[i]) shr x),2);
      Result := Result + Octet;
      x := x + 1;
    end
    else
      x := 0;
  end;
end;

function AlphabetIndex7Bit(AChar: WideChar): integer;
var
  i: integer;
  w: word;
begin
  Result := -1;
  w := Ord(AChar);
  for i := 0 to 127 do
    if Alphabet7Bit[i] = w then begin
      Result := i;
      break;
    end;
end;

function EscapeIndex7Bit(AChar: WideChar): integer;
begin
  case Ord(AChar) of
    12,27,91,92,93,94,123,124,125,126,8364:
      Result := Ord(AChar);
    else
      Result := -1;
  end;
end;

function Is7Bit(AChar: WideChar): boolean;
begin
  Result := (AlphabetIndex7Bit(AChar) <> -1) or (EscapeIndex7Bit(AChar) <> -1);
end;

function Encode7Bit(const Value: WideString): string;
var
  item: char;
  septets: string;
  i,j: integer;
  len: integer;
begin
  Result := '';
  septets := '';
  len := Length(Value);
  i := 1;
  while i <= len do begin
    j := AlphabetIndex7Bit(Value[i]);
    if j = -1 then begin
      { not in alphabet, so look for escape sequence }
      case EscapeIndex7Bit(Value[i]) of
         12: item := chr(10); { FORM FEED }
         27: item := chr(27); { next escape table }
         91: item := chr(60);
         92: item := chr(47);
         93: item := chr(62);
         94: item := chr(20);
        123: item := chr(40);
        124: item := chr(64);
        125: item := chr(41);
        126: item := chr(61);
       8364: item := chr(101); { Euro sign }
        else
          item := chr(63);
      end;
      septets := septets + chr(Alphabet7Escape);
    end
    else
      item := chr(j);
    septets := septets + item;
    inc(i);
  end;
  Result := septets;
end;

{ 7BIT }

function GSMLength7Bit(const Value: WideString): integer;
begin
  Result := Length(Encode7Bit(Value));
end;

function GSMDecode7Bit(Value: string): WideString;
var
  i,j,k,len: integer;
  w: word;
begin
  Result := '';
  Value := Unpack7Bit(Value);
  len := Length(Value);
  i := 1;
  while i <= len do begin
    j := Byte(Value[i]);
    if j <= 127 then w := Alphabet7Bit[j]
      else w := 0; { should error here? }
    if j = Alphabet7Escape then begin
      inc(i);
      if i > len then break;
      case Byte(Value[i]) of
        10: w := 12; { FORM FEED }
        20: w := 94;
        27: w := 32;
        40: w := 123;
        41: w := 125;
        47: w := 92;
        60: w := 91;
        61: w := 126;
        62: w := 93;
        64: w := 124;
       101: w := 8364; { Euro sign }
       else begin  w := 63;
       end;
      end; {case}
    end
    else begin
        if (j = 0) and (i < len) and (Byte(Value[i+1]) = 0) then begin
        k := i+2;
        while (k <= len) and (Byte(Value[k]) = 0) do inc(k); // 0x00 up to the...
        if (k > len) or // ...end of (fixed byte length) message -or- FORM FEED
          ((k < len) and (Byte(Value[k]) = Alphabet7Escape) and ((Byte(Value[k+1]) = 10))) then begin
          i := k-1;
          w := 0; // NULL unicode char
        end;
      end;
    end;
    Result := Result + WideChar(w);
    inc(i);
  end;
end;

function GSMEncode7Bit(const Value: WideString): string;
begin
  Result := Pack7Bit(Encode7Bit(Value));
end;

// End Encode & Decode

end.


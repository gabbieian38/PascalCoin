unit HlpRIPEMD320;

{$I HashLib.inc}

interface

uses
{$IFDEF DELPHI2010}
  SysUtils, // to get rid of compiler hint "not inlined" on Delphi 2010.
{$ENDIF DELPHI2010}
  HlpMDBase,
{$IFDEF DELPHI}
  HlpBitConverter,
  HlpHashBuffer,
  HlpHash,
{$ENDIF DELPHI}
  HlpBits,
  HlpConverters,
  HlpIHash,
  HlpIHashInfo;

type
  TRIPEMD320 = class sealed(TMDBase, ITransformBlock)

  strict protected
    procedure TransformBlock(AData: PByte; ADataLength: Int32;
      AIndex: Int32); override;

  public
    constructor Create();
    procedure Initialize(); override;
    function Clone(): IHash; override;

  end;

implementation

{ TRIPEMD320 }

function TRIPEMD320.Clone(): IHash;
var
  LHashInstance: TRIPEMD320;
begin
  LHashInstance := TRIPEMD320.Create();
  LHashInstance.FState := System.Copy(FState);
  LHashInstance.FBuffer := FBuffer.Clone();
  LHashInstance.FProcessedBytesCount := FProcessedBytesCount;
  result := LHashInstance as IHash;
  result.BufferSize := BufferSize;
end;

constructor TRIPEMD320.Create;
begin
  Inherited Create(10, 40);
end;

procedure TRIPEMD320.Initialize;
begin
  FState[4] := $C3D2E1F0;
  FState[5] := $76543210;
  FState[6] := $FEDCBA98;
  FState[7] := $89ABCDEF;
  FState[8] := $01234567;
  FState[9] := $3C2D1E0F;

  Inherited Initialize();

end;

procedure TRIPEMD320.TransformBlock(AData: PByte; ADataLength: Int32;
  AIndex: Int32);
var
  a, b, c, d, e, aa, bb, cc, dd, ee: UInt32;
  LData: array [0 .. 15] of UInt32;
begin
  TConverters.le32_copy(AData, AIndex, @(LData[0]), 0, ADataLength);

  a := FState[0];
  b := FState[1];
  c := FState[2];
  d := FState[3];
  e := FState[4];
  aa := FState[5];
  bb := FState[6];
  cc := FState[7];
  dd := FState[8];
  ee := FState[9];

  a := a + (LData[0] + (b xor c xor d));
  a := TBits.RotateLeft32(a, 11) + e;
  c := TBits.RotateLeft32(c, 10);
  e := e + (LData[1] + (a xor b xor c));
  e := TBits.RotateLeft32(e, 14) + d;
  b := TBits.RotateLeft32(b, 10);
  d := d + (LData[2] + (e xor a xor b));
  d := TBits.RotateLeft32(d, 15) + c;
  a := TBits.RotateLeft32(a, 10);
  c := c + (LData[3] + (d xor e xor a));
  c := TBits.RotateLeft32(c, 12) + b;
  e := TBits.RotateLeft32(e, 10);
  b := b + (LData[4] + (c xor d xor e));
  b := TBits.RotateLeft32(b, 5) + a;
  d := TBits.RotateLeft32(d, 10);
  a := a + (LData[5] + (b xor c xor d));
  a := TBits.RotateLeft32(a, 8) + e;
  c := TBits.RotateLeft32(c, 10);
  e := e + (LData[6] + (a xor b xor c));
  e := TBits.RotateLeft32(e, 7) + d;
  b := TBits.RotateLeft32(b, 10);
  d := d + (LData[7] + (e xor a xor b));
  d := TBits.RotateLeft32(d, 9) + c;
  a := TBits.RotateLeft32(a, 10);
  c := c + (LData[8] + (d xor e xor a));
  c := TBits.RotateLeft32(c, 11) + b;
  e := TBits.RotateLeft32(e, 10);
  b := b + (LData[9] + (c xor d xor e));
  b := TBits.RotateLeft32(b, 13) + a;
  d := TBits.RotateLeft32(d, 10);
  a := a + (LData[10] + (b xor c xor d));
  a := TBits.RotateLeft32(a, 14) + e;
  c := TBits.RotateLeft32(c, 10);
  e := e + (LData[11] + (a xor b xor c));
  e := TBits.RotateLeft32(e, 15) + d;
  b := TBits.RotateLeft32(b, 10);
  d := d + (LData[12] + (e xor a xor b));
  d := TBits.RotateLeft32(d, 6) + c;
  a := TBits.RotateLeft32(a, 10);
  c := c + (LData[13] + (d xor e xor a));
  c := TBits.RotateLeft32(c, 7) + b;
  e := TBits.RotateLeft32(e, 10);
  b := b + (LData[14] + (c xor d xor e));
  b := TBits.RotateLeft32(b, 9) + a;
  d := TBits.RotateLeft32(d, 10);
  a := a + (LData[15] + (b xor c xor d));
  a := TBits.RotateLeft32(a, 8) + e;
  c := TBits.RotateLeft32(c, 10);

  aa := aa + (LData[5] + C1 + (bb xor (cc or not dd)));
  aa := TBits.RotateLeft32(aa, 8) + ee;
  cc := TBits.RotateLeft32(cc, 10);
  ee := ee + (LData[14] + C1 + (aa xor (bb or not cc)));
  ee := TBits.RotateLeft32(ee, 9) + dd;
  bb := TBits.RotateLeft32(bb, 10);
  dd := dd + (LData[7] + C1 + (ee xor (aa or not bb)));
  dd := TBits.RotateLeft32(dd, 9) + cc;
  aa := TBits.RotateLeft32(aa, 10);
  cc := cc + (LData[0] + C1 + (dd xor (ee or not aa)));
  cc := TBits.RotateLeft32(cc, 11) + bb;
  ee := TBits.RotateLeft32(ee, 10);
  bb := bb + (LData[9] + C1 + (cc xor (dd or not ee)));
  bb := TBits.RotateLeft32(bb, 13) + aa;
  dd := TBits.RotateLeft32(dd, 10);
  aa := aa + (LData[2] + C1 + (bb xor (cc or not dd)));
  aa := TBits.RotateLeft32(aa, 15) + ee;
  cc := TBits.RotateLeft32(cc, 10);
  ee := ee + (LData[11] + C1 + (aa xor (bb or not cc)));
  ee := TBits.RotateLeft32(ee, 15) + dd;
  bb := TBits.RotateLeft32(bb, 10);
  dd := dd + (LData[4] + C1 + (ee xor (aa or not bb)));
  dd := TBits.RotateLeft32(dd, 5) + cc;
  aa := TBits.RotateLeft32(aa, 10);
  cc := cc + (LData[13] + C1 + (dd xor (ee or not aa)));
  cc := TBits.RotateLeft32(cc, 7) + bb;
  ee := TBits.RotateLeft32(ee, 10);
  bb := bb + (LData[6] + C1 + (cc xor (dd or not ee)));
  bb := TBits.RotateLeft32(bb, 7) + aa;
  dd := TBits.RotateLeft32(dd, 10);
  aa := aa + (LData[15] + C1 + (bb xor (cc or not dd)));
  aa := TBits.RotateLeft32(aa, 8) + ee;
  cc := TBits.RotateLeft32(cc, 10);
  ee := ee + (LData[8] + C1 + (aa xor (bb or not cc)));
  ee := TBits.RotateLeft32(ee, 11) + dd;
  bb := TBits.RotateLeft32(bb, 10);
  dd := dd + (LData[1] + C1 + (ee xor (aa or not bb)));
  dd := TBits.RotateLeft32(dd, 14) + cc;
  aa := TBits.RotateLeft32(aa, 10);
  cc := cc + (LData[10] + C1 + (dd xor (ee or not aa)));
  cc := TBits.RotateLeft32(cc, 14) + bb;
  ee := TBits.RotateLeft32(ee, 10);
  bb := bb + (LData[3] + C1 + (cc xor (dd or not ee)));
  bb := TBits.RotateLeft32(bb, 12) + aa;
  dd := TBits.RotateLeft32(dd, 10);
  aa := aa + (LData[12] + C1 + (bb xor (cc or not dd)));
  aa := TBits.RotateLeft32(aa, 6) + ee;
  cc := TBits.RotateLeft32(cc, 10);

  e := e + (LData[7] + C2 + ((aa and b) or (not aa and c)));
  e := TBits.RotateLeft32(e, 7) + d;
  b := TBits.RotateLeft32(b, 10);
  d := d + (LData[4] + C2 + ((e and aa) or (not e and b)));
  d := TBits.RotateLeft32(d, 6) + c;
  aa := TBits.RotateLeft32(aa, 10);
  c := c + (LData[13] + C2 + ((d and e) or (not d and aa)));
  c := TBits.RotateLeft32(c, 8) + b;
  e := TBits.RotateLeft32(e, 10);
  b := b + (LData[1] + C2 + ((c and d) or (not c and e)));
  b := TBits.RotateLeft32(b, 13) + aa;
  d := TBits.RotateLeft32(d, 10);
  aa := aa + (LData[10] + C2 + ((b and c) or (not b and d)));
  aa := TBits.RotateLeft32(aa, 11) + e;
  c := TBits.RotateLeft32(c, 10);
  e := e + (LData[6] + C2 + ((aa and b) or (not aa and c)));
  e := TBits.RotateLeft32(e, 9) + d;
  b := TBits.RotateLeft32(b, 10);
  d := d + (LData[15] + C2 + ((e and aa) or (not e and b)));
  d := TBits.RotateLeft32(d, 7) + c;
  aa := TBits.RotateLeft32(aa, 10);
  c := c + (LData[3] + C2 + ((d and e) or (not d and aa)));
  c := TBits.RotateLeft32(c, 15) + b;
  e := TBits.RotateLeft32(e, 10);
  b := b + (LData[12] + C2 + ((c and d) or (not c and e)));
  b := TBits.RotateLeft32(b, 7) + aa;
  d := TBits.RotateLeft32(d, 10);
  aa := aa + (LData[0] + C2 + ((b and c) or (not b and d)));
  aa := TBits.RotateLeft32(aa, 12) + e;
  c := TBits.RotateLeft32(c, 10);
  e := e + (LData[9] + C2 + ((aa and b) or (not aa and c)));
  e := TBits.RotateLeft32(e, 15) + d;
  b := TBits.RotateLeft32(b, 10);
  d := d + (LData[5] + C2 + ((e and aa) or (not e and b)));
  d := TBits.RotateLeft32(d, 9) + c;
  aa := TBits.RotateLeft32(aa, 10);
  c := c + (LData[2] + C2 + ((d and e) or (not d and aa)));
  c := TBits.RotateLeft32(c, 11) + b;
  e := TBits.RotateLeft32(e, 10);
  b := b + (LData[14] + C2 + ((c and d) or (not c and e)));
  b := TBits.RotateLeft32(b, 7) + aa;
  d := TBits.RotateLeft32(d, 10);
  aa := aa + (LData[11] + C2 + ((b and c) or (not b and d)));
  aa := TBits.RotateLeft32(aa, 13) + e;
  c := TBits.RotateLeft32(c, 10);
  e := e + (LData[8] + C2 + ((aa and b) or (not aa and c)));
  e := TBits.RotateLeft32(e, 12) + d;
  b := TBits.RotateLeft32(b, 10);

  ee := ee + (LData[6] + C3 + ((a and cc) or (bb and not cc)));
  ee := TBits.RotateLeft32(ee, 9) + dd;
  bb := TBits.RotateLeft32(bb, 10);
  dd := dd + (LData[11] + C3 + ((ee and bb) or (a and not bb)));
  dd := TBits.RotateLeft32(dd, 13) + cc;
  a := TBits.RotateLeft32(a, 10);
  cc := cc + (LData[3] + C3 + ((dd and a) or (ee and not a)));
  cc := TBits.RotateLeft32(cc, 15) + bb;
  ee := TBits.RotateLeft32(ee, 10);
  bb := bb + (LData[7] + C3 + ((cc and ee) or (dd and not ee)));
  bb := TBits.RotateLeft32(bb, 7) + a;
  dd := TBits.RotateLeft32(dd, 10);
  a := a + (LData[0] + C3 + ((bb and dd) or (cc and not dd)));
  a := TBits.RotateLeft32(a, 12) + ee;
  cc := TBits.RotateLeft32(cc, 10);
  ee := ee + (LData[13] + C3 + ((a and cc) or (bb and not cc)));
  ee := TBits.RotateLeft32(ee, 8) + dd;
  bb := TBits.RotateLeft32(bb, 10);
  dd := dd + (LData[5] + C3 + ((ee and bb) or (a and not bb)));
  dd := TBits.RotateLeft32(dd, 9) + cc;
  a := TBits.RotateLeft32(a, 10);
  cc := cc + (LData[10] + C3 + ((dd and a) or (ee and not a)));
  cc := TBits.RotateLeft32(cc, 11) + bb;
  ee := TBits.RotateLeft32(ee, 10);
  bb := bb + (LData[14] + C3 + ((cc and ee) or (dd and not ee)));
  bb := TBits.RotateLeft32(bb, 7) + a;
  dd := TBits.RotateLeft32(dd, 10);
  a := a + (LData[15] + C3 + ((bb and dd) or (cc and not dd)));
  a := TBits.RotateLeft32(a, 7) + ee;
  cc := TBits.RotateLeft32(cc, 10);
  ee := ee + (LData[8] + C3 + ((a and cc) or (bb and not cc)));
  ee := TBits.RotateLeft32(ee, 12) + dd;
  bb := TBits.RotateLeft32(bb, 10);
  dd := dd + (LData[12] + C3 + ((ee and bb) or (a and not bb)));
  dd := TBits.RotateLeft32(dd, 7) + cc;
  a := TBits.RotateLeft32(a, 10);
  cc := cc + (LData[4] + C3 + ((dd and a) or (ee and not a)));
  cc := TBits.RotateLeft32(cc, 6) + bb;
  ee := TBits.RotateLeft32(ee, 10);
  bb := bb + (LData[9] + C3 + ((cc and ee) or (dd and not ee)));
  bb := TBits.RotateLeft32(bb, 15) + a;
  dd := TBits.RotateLeft32(dd, 10);
  a := a + (LData[1] + C3 + ((bb and dd) or (cc and not dd)));
  a := TBits.RotateLeft32(a, 13) + ee;
  cc := TBits.RotateLeft32(cc, 10);
  ee := ee + (LData[2] + C3 + ((a and cc) or (bb and not cc)));
  ee := TBits.RotateLeft32(ee, 11) + dd;
  bb := TBits.RotateLeft32(bb, 10);

  d := d + (LData[3] + C4 + ((e or not aa) xor bb));
  d := TBits.RotateLeft32(d, 11) + c;
  aa := TBits.RotateLeft32(aa, 10);
  c := c + (LData[10] + C4 + ((d or not e) xor aa));
  c := TBits.RotateLeft32(c, 13) + bb;
  e := TBits.RotateLeft32(e, 10);
  bb := bb + (LData[14] + C4 + ((c or not d) xor e));
  bb := TBits.RotateLeft32(bb, 6) + aa;
  d := TBits.RotateLeft32(d, 10);
  aa := aa + (LData[4] + C4 + ((bb or not c) xor d));
  aa := TBits.RotateLeft32(aa, 7) + e;
  c := TBits.RotateLeft32(c, 10);
  e := e + (LData[9] + C4 + ((aa or not bb) xor c));
  e := TBits.RotateLeft32(e, 14) + d;
  bb := TBits.RotateLeft32(bb, 10);
  d := d + (LData[15] + C4 + ((e or not aa) xor bb));
  d := TBits.RotateLeft32(d, 9) + c;
  aa := TBits.RotateLeft32(aa, 10);
  c := c + (LData[8] + C4 + ((d or not e) xor aa));
  c := TBits.RotateLeft32(c, 13) + bb;
  e := TBits.RotateLeft32(e, 10);
  bb := bb + (LData[1] + C4 + ((c or not d) xor e));
  bb := TBits.RotateLeft32(bb, 15) + aa;
  d := TBits.RotateLeft32(d, 10);
  aa := aa + (LData[2] + C4 + ((bb or not c) xor d));
  aa := TBits.RotateLeft32(aa, 14) + e;
  c := TBits.RotateLeft32(c, 10);
  e := e + (LData[7] + C4 + ((aa or not bb) xor c));
  e := TBits.RotateLeft32(e, 8) + d;
  bb := TBits.RotateLeft32(bb, 10);
  d := d + (LData[0] + C4 + ((e or not aa) xor bb));
  d := TBits.RotateLeft32(d, 13) + c;
  aa := TBits.RotateLeft32(aa, 10);
  c := c + (LData[6] + C4 + ((d or not e) xor aa));
  c := TBits.RotateLeft32(c, 6) + bb;
  e := TBits.RotateLeft32(e, 10);
  bb := bb + (LData[13] + C4 + ((c or not d) xor e));
  bb := TBits.RotateLeft32(bb, 5) + aa;
  d := TBits.RotateLeft32(d, 10);
  aa := aa + (LData[11] + C4 + ((bb or not c) xor d));
  aa := TBits.RotateLeft32(aa, 12) + e;
  c := TBits.RotateLeft32(c, 10);
  e := e + (LData[5] + C4 + ((aa or not bb) xor c));
  e := TBits.RotateLeft32(e, 7) + d;
  bb := TBits.RotateLeft32(bb, 10);
  d := d + (LData[12] + C4 + ((e or not aa) xor bb));
  d := TBits.RotateLeft32(d, 5) + c;
  aa := TBits.RotateLeft32(aa, 10);

  dd := dd + (LData[15] + C5 + ((ee or not a) xor b));
  dd := TBits.RotateLeft32(dd, 9) + cc;
  a := TBits.RotateLeft32(a, 10);
  cc := cc + (LData[5] + C5 + ((dd or not ee) xor a));
  cc := TBits.RotateLeft32(cc, 7) + b;
  ee := TBits.RotateLeft32(ee, 10);
  b := b + (LData[1] + C5 + ((cc or not dd) xor ee));
  b := TBits.RotateLeft32(b, 15) + a;
  dd := TBits.RotateLeft32(dd, 10);
  a := a + (LData[3] + C5 + ((b or not cc) xor dd));
  a := TBits.RotateLeft32(a, 11) + ee;
  cc := TBits.RotateLeft32(cc, 10);
  ee := ee + (LData[7] + C5 + ((a or not b) xor cc));
  ee := TBits.RotateLeft32(ee, 8) + dd;
  b := TBits.RotateLeft32(b, 10);
  dd := dd + (LData[14] + C5 + ((ee or not a) xor b));
  dd := TBits.RotateLeft32(dd, 6) + cc;
  a := TBits.RotateLeft32(a, 10);
  cc := cc + (LData[6] + C5 + ((dd or not ee) xor a));
  cc := TBits.RotateLeft32(cc, 6) + b;
  ee := TBits.RotateLeft32(ee, 10);
  b := b + (LData[9] + C5 + ((cc or not dd) xor ee));
  b := TBits.RotateLeft32(b, 14) + a;
  dd := TBits.RotateLeft32(dd, 10);
  a := a + (LData[11] + C5 + ((b or not cc) xor dd));
  a := TBits.RotateLeft32(a, 12) + ee;
  cc := TBits.RotateLeft32(cc, 10);
  ee := ee + (LData[8] + C5 + ((a or not b) xor cc));
  ee := TBits.RotateLeft32(ee, 13) + dd;
  b := TBits.RotateLeft32(b, 10);
  dd := dd + (LData[12] + C5 + ((ee or not a) xor b));
  dd := TBits.RotateLeft32(dd, 5) + cc;
  a := TBits.RotateLeft32(a, 10);
  cc := cc + (LData[2] + C5 + ((dd or not ee) xor a));
  cc := TBits.RotateLeft32(cc, 14) + b;
  ee := TBits.RotateLeft32(ee, 10);
  b := b + (LData[10] + C5 + ((cc or not dd) xor ee));
  b := TBits.RotateLeft32(b, 13) + a;
  dd := TBits.RotateLeft32(dd, 10);
  a := a + (LData[0] + C5 + ((b or not cc) xor dd));
  a := TBits.RotateLeft32(a, 13) + ee;
  cc := TBits.RotateLeft32(cc, 10);
  ee := ee + (LData[4] + C5 + ((a or not b) xor cc));
  ee := TBits.RotateLeft32(ee, 7) + dd;
  b := TBits.RotateLeft32(b, 10);
  dd := dd + (LData[13] + C5 + ((ee or not a) xor b));
  dd := TBits.RotateLeft32(dd, 5) + cc;
  a := TBits.RotateLeft32(a, 10);

  cc := cc + (LData[1] + C6 + ((d and aa) or (e and not aa)));
  cc := TBits.RotateLeft32(cc, 11) + bb;
  e := TBits.RotateLeft32(e, 10);
  bb := bb + (LData[9] + C6 + ((cc and e) or (d and not e)));
  bb := TBits.RotateLeft32(bb, 12) + aa;
  d := TBits.RotateLeft32(d, 10);
  aa := aa + (LData[11] + C6 + ((bb and d) or (cc and not d)));
  aa := TBits.RotateLeft32(aa, 14) + e;
  cc := TBits.RotateLeft32(cc, 10);
  e := e + (LData[10] + C6 + ((aa and cc) or (bb and not cc)));
  e := TBits.RotateLeft32(e, 15) + d;
  bb := TBits.RotateLeft32(bb, 10);
  d := d + (LData[0] + C6 + ((e and bb) or (aa and not bb)));
  d := TBits.RotateLeft32(d, 14) + cc;
  aa := TBits.RotateLeft32(aa, 10);
  cc := cc + (LData[8] + C6 + ((d and aa) or (e and not aa)));
  cc := TBits.RotateLeft32(cc, 15) + bb;
  e := TBits.RotateLeft32(e, 10);
  bb := bb + (LData[12] + C6 + ((cc and e) or (d and not e)));
  bb := TBits.RotateLeft32(bb, 9) + aa;
  d := TBits.RotateLeft32(d, 10);
  aa := aa + (LData[4] + C6 + ((bb and d) or (cc and not d)));
  aa := TBits.RotateLeft32(aa, 8) + e;
  cc := TBits.RotateLeft32(cc, 10);
  e := e + (LData[13] + C6 + ((aa and cc) or (bb and not cc)));
  e := TBits.RotateLeft32(e, 9) + d;
  bb := TBits.RotateLeft32(bb, 10);
  d := d + (LData[3] + C6 + ((e and bb) or (aa and not bb)));
  d := TBits.RotateLeft32(d, 14) + cc;
  aa := TBits.RotateLeft32(aa, 10);
  cc := cc + (LData[7] + C6 + ((d and aa) or (e and not aa)));
  cc := TBits.RotateLeft32(cc, 5) + bb;
  e := TBits.RotateLeft32(e, 10);
  bb := bb + (LData[15] + C6 + ((cc and e) or (d and not e)));
  bb := TBits.RotateLeft32(bb, 6) + aa;
  d := TBits.RotateLeft32(d, 10);
  aa := aa + (LData[14] + C6 + ((bb and d) or (cc and not d)));
  aa := TBits.RotateLeft32(aa, 8) + e;
  cc := TBits.RotateLeft32(cc, 10);
  e := e + (LData[5] + C6 + ((aa and cc) or (bb and not cc)));
  e := TBits.RotateLeft32(e, 6) + d;
  bb := TBits.RotateLeft32(bb, 10);
  d := d + (LData[6] + C6 + ((e and bb) or (aa and not bb)));
  d := TBits.RotateLeft32(d, 5) + cc;
  aa := TBits.RotateLeft32(aa, 10);
  cc := cc + (LData[2] + C6 + ((d and aa) or (e and not aa)));
  cc := TBits.RotateLeft32(cc, 12) + bb;
  e := TBits.RotateLeft32(e, 10);

  c := c + (LData[8] + C7 + ((dd and ee) or (not dd and a)));
  c := TBits.RotateLeft32(c, 15) + b;
  ee := TBits.RotateLeft32(ee, 10);
  b := b + (LData[6] + C7 + ((c and dd) or (not c and ee)));
  b := TBits.RotateLeft32(b, 5) + a;
  dd := TBits.RotateLeft32(dd, 10);
  a := a + (LData[4] + C7 + ((b and c) or (not b and dd)));
  a := TBits.RotateLeft32(a, 8) + ee;
  c := TBits.RotateLeft32(c, 10);
  ee := ee + (LData[1] + C7 + ((a and b) or (not a and c)));
  ee := TBits.RotateLeft32(ee, 11) + dd;
  b := TBits.RotateLeft32(b, 10);
  dd := dd + (LData[3] + C7 + ((ee and a) or (not ee and b)));
  dd := TBits.RotateLeft32(dd, 14) + c;
  a := TBits.RotateLeft32(a, 10);
  c := c + (LData[11] + C7 + ((dd and ee) or (not dd and a)));
  c := TBits.RotateLeft32(c, 14) + b;
  ee := TBits.RotateLeft32(ee, 10);
  b := b + (LData[15] + C7 + ((c and dd) or (not c and ee)));
  b := TBits.RotateLeft32(b, 6) + a;
  dd := TBits.RotateLeft32(dd, 10);
  a := a + (LData[0] + C7 + ((b and c) or (not b and dd)));
  a := TBits.RotateLeft32(a, 14) + ee;
  c := TBits.RotateLeft32(c, 10);
  ee := ee + (LData[5] + C7 + ((a and b) or (not a and c)));
  ee := TBits.RotateLeft32(ee, 6) + dd;
  b := TBits.RotateLeft32(b, 10);
  dd := dd + (LData[12] + C7 + ((ee and a) or (not ee and b)));
  dd := TBits.RotateLeft32(dd, 9) + c;
  a := TBits.RotateLeft32(a, 10);
  c := c + (LData[2] + C7 + ((dd and ee) or (not dd and a)));
  c := TBits.RotateLeft32(c, 12) + b;
  ee := TBits.RotateLeft32(ee, 10);
  b := b + (LData[13] + C7 + ((c and dd) or (not c and ee)));
  b := TBits.RotateLeft32(b, 9) + a;
  dd := TBits.RotateLeft32(dd, 10);
  a := a + (LData[9] + C7 + ((b and c) or (not b and dd)));
  a := TBits.RotateLeft32(a, 12) + ee;
  c := TBits.RotateLeft32(c, 10);
  ee := ee + (LData[7] + C7 + ((a and b) or (not a and c)));
  ee := TBits.RotateLeft32(ee, 5) + dd;
  b := TBits.RotateLeft32(b, 10);
  dd := dd + (LData[10] + C7 + ((ee and a) or (not ee and b)));
  dd := TBits.RotateLeft32(dd, 15) + c;
  a := TBits.RotateLeft32(a, 10);
  c := c + (LData[14] + C7 + ((dd and ee) or (not dd and a)));
  c := TBits.RotateLeft32(c, 8) + b;
  ee := TBits.RotateLeft32(ee, 10);

  bb := bb + (LData[4] + C8 + (cc xor (dd or not e)));
  bb := TBits.RotateLeft32(bb, 9) + aa;
  dd := TBits.RotateLeft32(dd, 10);
  aa := aa + (LData[0] + C8 + (bb xor (cc or not dd)));
  aa := TBits.RotateLeft32(aa, 15) + e;
  cc := TBits.RotateLeft32(cc, 10);
  e := e + (LData[5] + C8 + (aa xor (bb or not cc)));
  e := TBits.RotateLeft32(e, 5) + dd;
  bb := TBits.RotateLeft32(bb, 10);
  dd := dd + (LData[9] + C8 + (e xor (aa or not bb)));
  dd := TBits.RotateLeft32(dd, 11) + cc;
  aa := TBits.RotateLeft32(aa, 10);
  cc := cc + (LData[7] + C8 + (dd xor (e or not aa)));
  cc := TBits.RotateLeft32(cc, 6) + bb;
  e := TBits.RotateLeft32(e, 10);
  bb := bb + (LData[12] + C8 + (cc xor (dd or not e)));
  bb := TBits.RotateLeft32(bb, 8) + aa;
  dd := TBits.RotateLeft32(dd, 10);
  aa := aa + (LData[2] + C8 + (bb xor (cc or not dd)));
  aa := TBits.RotateLeft32(aa, 13) + e;
  cc := TBits.RotateLeft32(cc, 10);
  e := e + (LData[10] + C8 + (aa xor (bb or not cc)));
  e := TBits.RotateLeft32(e, 12) + dd;
  bb := TBits.RotateLeft32(bb, 10);
  dd := dd + (LData[14] + C8 + (e xor (aa or not bb)));
  dd := TBits.RotateLeft32(dd, 5) + cc;
  aa := TBits.RotateLeft32(aa, 10);
  cc := cc + (LData[1] + C8 + (dd xor (e or not aa)));
  cc := TBits.RotateLeft32(cc, 12) + bb;
  e := TBits.RotateLeft32(e, 10);
  bb := bb + (LData[3] + C8 + (cc xor (dd or not e)));
  bb := TBits.RotateLeft32(bb, 13) + aa;
  dd := TBits.RotateLeft32(dd, 10);
  aa := aa + (LData[8] + C8 + (bb xor (cc or not dd)));
  aa := TBits.RotateLeft32(aa, 14) + e;
  cc := TBits.RotateLeft32(cc, 10);
  e := e + (LData[11] + C8 + (aa xor (bb or not cc)));
  e := TBits.RotateLeft32(e, 11) + dd;
  bb := TBits.RotateLeft32(bb, 10);
  dd := dd + (LData[6] + C8 + (e xor (aa or not bb)));
  dd := TBits.RotateLeft32(dd, 8) + cc;
  aa := TBits.RotateLeft32(aa, 10);
  cc := cc + (LData[15] + C8 + (dd xor (e or not aa)));
  cc := TBits.RotateLeft32(cc, 5) + bb;
  e := TBits.RotateLeft32(e, 10);
  bb := bb + (LData[13] + C8 + (cc xor (dd or not e)));
  bb := TBits.RotateLeft32(bb, 6) + aa;
  dd := TBits.RotateLeft32(dd, 10);

  b := b + (LData[12] + (c xor d xor ee));
  b := TBits.RotateLeft32(b, 8) + a;
  d := TBits.RotateLeft32(d, 10);
  a := a + (LData[15] + (b xor c xor d));
  a := TBits.RotateLeft32(a, 5) + ee;
  c := TBits.RotateLeft32(c, 10);
  ee := ee + (LData[10] + (a xor b xor c));
  ee := TBits.RotateLeft32(ee, 12) + d;
  b := TBits.RotateLeft32(b, 10);
  d := d + (LData[4] + (ee xor a xor b));
  d := TBits.RotateLeft32(d, 9) + c;
  a := TBits.RotateLeft32(a, 10);
  c := c + (LData[1] + (d xor ee xor a));
  c := TBits.RotateLeft32(c, 12) + b;
  ee := TBits.RotateLeft32(ee, 10);
  b := b + (LData[5] + (c xor d xor ee));
  b := TBits.RotateLeft32(b, 5) + a;
  d := TBits.RotateLeft32(d, 10);
  a := a + (LData[8] + (b xor c xor d));
  a := TBits.RotateLeft32(a, 14) + ee;
  c := TBits.RotateLeft32(c, 10);
  ee := ee + (LData[7] + (a xor b xor c));
  ee := TBits.RotateLeft32(ee, 6) + d;
  b := TBits.RotateLeft32(b, 10);
  d := d + (LData[6] + (ee xor a xor b));
  d := TBits.RotateLeft32(d, 8) + c;
  a := TBits.RotateLeft32(a, 10);
  c := c + (LData[2] + (d xor ee xor a));
  c := TBits.RotateLeft32(c, 13) + b;
  ee := TBits.RotateLeft32(ee, 10);
  b := b + (LData[13] + (c xor d xor ee));
  b := TBits.RotateLeft32(b, 6) + a;
  d := TBits.RotateLeft32(d, 10);
  a := a + (LData[14] + (b xor c xor d));
  a := TBits.RotateLeft32(a, 5) + ee;
  c := TBits.RotateLeft32(c, 10);
  ee := ee + (LData[0] + (a xor b xor c));
  ee := TBits.RotateLeft32(ee, 15) + d;
  b := TBits.RotateLeft32(b, 10);
  d := d + (LData[3] + (ee xor a xor b));
  d := TBits.RotateLeft32(d, 13) + c;
  a := TBits.RotateLeft32(a, 10);
  c := c + (LData[9] + (d xor ee xor a));
  c := TBits.RotateLeft32(c, 11) + b;
  ee := TBits.RotateLeft32(ee, 10);
  b := b + (LData[11] + (c xor d xor ee));
  b := TBits.RotateLeft32(b, 11) + a;
  d := TBits.RotateLeft32(d, 10);

  FState[0] := FState[0] + aa;
  FState[1] := FState[1] + bb;
  FState[2] := FState[2] + cc;
  FState[3] := FState[3] + dd;
  FState[4] := FState[4] + ee;
  FState[5] := FState[5] + a;
  FState[6] := FState[6] + b;
  FState[7] := FState[7] + c;
  FState[8] := FState[8] + d;
  FState[9] := FState[9] + e;

  System.FillChar(LData, System.SizeOf(LData), UInt32(0));
end;

end.

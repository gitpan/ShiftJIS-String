#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#define isSJ1BT(i)  (0x00<=(i) && (i)<=0x7F || 0xA1<=(i) && (i)<=0xDF)
#define isSJ1ST(i)  (0x81<=(i) && (i)<=0x9F || 0xE0<=(i) && (i)<=0xFC)
#define isSJ2ND(i)  (0x40<=(i) && (i)<=0x7E || 0x80<=(i) && (i)<=0xFC)

#define isSJ1OKp(p)   (isSJ1BT(*(p)))
#define isSJ2OKp(p)   (isSJ1ST(*(p)) && isSJ2ND(*((p)+1)))
#define isSJ2BTp(p,e) (isSJ1ST(*(p)) && (((p)+1) < (e)))

#define SJIS_BYTES_PER_ROW (376) /* 94 * 2 * 2; for mkrange */
#define SJIS_VIDUAL_MAX    (4)   /* for visualize_char() */

/* Roman */
#define isSJ_CNTRL(c)  ((0x00<=(c) && (c)<=0x1F) || (c)==0x7F)
#define isSJ_SPACE(c)  ((c)==0x20)
#define isSJ_LOWER(c)  (0x61<=(c) && (c)<=0x7A)
#define isSJ_UPPER(c)  (0x41<=(c) && (c)<=0x5A)
#define isSJ_BACKp(p)  ((*(p))==0x5C && ((*((p)+1)==0x5C) || (*((p)+1)==0x2D)))
#define isSJ_RANGEp(p) ((*(p))==0x2D)

/* ZENKAKU KANA */
#define SJIS_DIFF_HIRA_KATA    (0x5E)
#define isSJ_HI1ST(c)  (0x82==(c))
#define isSJ_HI2ND1(c) (0x9F<=(c) && (c)<=0xDD)
#define isSJ_HI2ND2(c) (0xDE<=(c) && (c)<=0xF1)
#define isSJ_HI2ND(c)  (0x9F<=(c) && (c)<=0xF1)
#define isSJ_KA1ST(c)  (0x83==(c))
#define isSJ_KA2ND1(c) (0x40<=(c) && (c)<=0x7E)
#define isSJ_KA2ND2(c) (0x80<=(c) && (c)<=0x93)
#define isSJ_KA2ND(c)  (isSJ_KA2ND1(c) || isSJ_KA2ND2(c))
#define isSJ_KA2ND_VU(c) ((c)==0x94)
#define isSJ_KA2ND_KA(c) ((c)==0x95)
#define isSJ_KA2ND_KE(c) ((c)==0x96)
#define isSJ_KA2ND_X(c) ((0x40<=(c) && (c)<=0x7E) || (0x80<=(c) && (c)<=0x96))

#define isSJ_HI_VUp(p)   (*(p)==0x82 && (*((p)+1) == 0xA4) \
	&& (*((p)+2) == 0x81) && (*((p)+3) == 0x4A) )

#define isSJ_HI_ITERp(p) (*(p)==0x81 && (*((p)+1) == 0x54 || *((p)+1) == 0x55))
#define isSJ_KA_ITERp(p) (*(p)==0x81 && (*((p)+1) == 0x52 || *((p)+1) == 0x53))
#define SJIS_DIFF_HIRA_KATA_ITER  (2)

#define isSJ_ZKPCT2ND(c) ((c)==0x41 || (c)==0x42 || (c)==0x45 || \
       (c)==0x4A || (c)==0x4B || (c)==0x5B || (c)==0x75 || (c)==0x76)

#define isSJ_ZSPACEp(p) (*(p)==0x81 && *((p)+1) == 0x40)

/* HANKAKU KANA */
#define isSJ_HKPCT(c) ((0xA1<=(c) && (c)<=0xA5) || (c)==0xB0 || \
		     (c)==0xDE || (c)==0xDF)
#define isSJ_HKANA(c) ((0xA6<=(c) && (c)<=0xAF) || (0xB1<=(c) && (c)<=0xDD))
#define isSJ_HKATO(c) ( 0xB6<=(c) && (c)<=0xC4)
#define isSJ_HHAHO(c) ( 0xCA<=(c) && (c)<=0xCE)
#define isSJ_HTEN2(c) ((c)==0xDE)
#define isSJ_HMARU(c) ((c)==0xDF)
#define isSJ_H_VUp(p) ((*(p))==0xB3 && (*((p)+1))==0xDE)

/* 0xA0 to 0xDF : JIS X 0201 => Trailing byte : JIS X 0208 */
static STDCHAR SJIS_HKANA_TRAIL[] = {
    0x00, 0x42, 0x75, 0x76, 0x41, 0x45, 0x92, 0x40,
    0x42, 0x44, 0x46, 0x48, 0x83, 0x85, 0x87, 0x62,
    0x5B, 0x41, 0x43, 0x45, 0x47, 0x49, 0x4A, 0x4C,
    0x4E, 0x50, 0x52, 0x54, 0x56, 0x58, 0x5A, 0x5C,
    0x5E, 0x60, 0x63, 0x65, 0x67, 0x69, 0x6A, 0x6B,
    0x6C, 0x6D, 0x6E, 0x71, 0x74, 0x77, 0x7A, 0x7D,
    0x7E, 0x80, 0x81, 0x82, 0x84, 0x86, 0x88, 0x89,
    0x8A, 0x8B, 0x8C, 0x8D, 0x8F, 0x93, 0x4A, 0x4B,
};

/* Trailing byte 0x40 to 0x96 : JIS X 0208 => JIS X 0201 */
static U16 SJIS_ZKATA_TRAIL[] = {
    0xA7,   0xB1,   0xA8,   0xB2,   0xA9,   0xB3,   0xAA,   0xB4,
    0xAB,   0xB5,   0xB6,   0xB6DE, 0xB7,   0xB7DE, 0xB8,   0xB8DE,
    0xB9,   0xB9DE, 0xBA,   0xBADE, 0xBB,   0xBBDE, 0xBC,   0xBCDE,
    0xBD,   0xBDDE, 0xBE,   0xBEDE, 0xBF,   0xBFDE, 0xC0,   0xC0DE,
    0xC1,   0xC1DE, 0xAF,   0xC2,   0xC2DE, 0xC3,   0xC3DE, 0xC4,
    0xC4DE, 0xC5,   0xC6,   0xC7,   0xC8,   0xC9,   0xCA,   0xCADE,
    0xCADF, 0xCB,   0xCBDE, 0xCBDF, 0xCC,   0xCCDE, 0xCCDF, 0xCD,
    0xCDDE, 0xCDDF, 0xCE,   0xCEDE, 0xCEDF, 0xCF,   0xD0,   0x00,
    0xD1,   0xD2,   0xD3,   0xAC,   0xD4,   0xAD,   0xD5,   0xAE,
    0xD6,   0xD7,   0xD8,   0xD9,   0xDA,   0xDB,   0xDC,   0xDC,
    0xB2,   0xB4,   0xA6,   0xDD,   0xB3DE, 0xB6,   0xB9
};

/* Trailing byte 0x9F to 0xF1 : JIS X 0208 => JIS X 0201 */
static U16 SJIS_ZHIRA_TRAIL[] = {
    0xA7,   0xB1,   0xA8,   0xB2,   0xA9,   0xB3,   0xAA,   0xB4,
    0xAB,   0xB5,   0xB6,   0xB6DE, 0xB7,   0xB7DE, 0xB8,   0xB8DE,
    0xB9,   0xB9DE, 0xBA,   0xBADE, 0xBB,   0xBBDE, 0xBC,   0xBCDE,
    0xBD,   0xBDDE, 0xBE,   0xBEDE, 0xBF,   0xBFDE, 0xC0,   0xC0DE,
    0xC1,   0xC1DE, 0xAF,   0xC2,   0xC2DE, 0xC3,   0xC3DE, 0xC4,
    0xC4DE, 0xC5,   0xC6,   0xC7,   0xC8,   0xC9,   0xCA,   0xCADE,
    0xCADF, 0xCB,   0xCBDE, 0xCBDF, 0xCC,   0xCCDE, 0xCCDF, 0xCD,
    0xCDDE, 0xCDDF, 0xCE,   0xCEDE, 0xCEDF, 0xCF,   0xD0,   0xD1,
    0xD2,   0xD3,   0xAC,   0xD4,   0xAD,   0xD5,   0xAE,   0xD6,
    0xD7,   0xD8,   0xD9,   0xDA,   0xDB,   0xDC,   0xDC,   0xB2,
    0xB4,   0xA6,   0xDD
};

static int issjis(U8 * str, STRLEN byte)
{
    U8 *p, *e;

    e = str + byte;
    for (p = str; p < e;) {
	if (isSJ1OKp(p)) ++p;
	else if (isSJ2OKp(p)) p+=2;
	else return(0);
    }
    return(1);
}

static I32 length (U8* str, STRLEN byte)
{
    U8 *p, *e;
    I32 len = 0;

    e = str + byte;
    for (p = str; p < e; ++p, ++len)
	if (isSJ2BTp(p,e)) ++p;
    return len;
}

static void bytelist
 (U8 *s, STRLEN byte, U8 *one, U8 *two, STRLEN *olp, STRLEN *tlp)
{
    U8 *e, *p, *o, *t;

    o = one;
    t = two;
    e = s + byte;
    for (p = s; p < e; ) {
	if (isSJ2BTp(p,e)) {
	    *t++ = *p++;
	    *t++ = *p++;
	} else { *o++ = *p++; }
    }
    *tlp = t - two;
    *olp = o - one;
    *o = *t = '\0';
}

static char* strNchr (U8 * s, STRLEN byte, U8* mbc, int n)
{
    U8 *e, *p;

    e = s + byte;
    for (p = s; p < e; p += n)
	if (memEQ(p,mbc,n)) return (char*)p;
    return NULL;
}


/*
 * internal for mkrange
 * a, b should be 0 or 0x81-0x9F or 0xE0-0xFC
 */
static int diff_by_lead (U8 a, U8 b)
{
    U8 min, max;

    if (a == b) return SJIS_BYTES_PER_ROW;
    if (a < b) { min = a; max = b; } else { min = b; max = a; }
    if (min == 0) min = 0x80;
    return (SJIS_BYTES_PER_ROW * 
	(max - min + 1 - ((max <= 0x9F || 0xE0 <= min) ? 0 : 0x40))
    );
}

/*
 * internal for mkrange
 */
static U8* range_expand (U8* d, U16 fr, U16 to)
{
    int i, ini, fin;

    if (fr <= 0x7F) {
	ini = fr;
	fin = 0x7F < to ? 0x7F : to;
	for (i = ini; i <= fin; i++) *d++ = (U8)i;
    }
    if (fr <= 0xDF) {
	ini = fr < 0xA1 ? 0xA1 : fr;
	fin = 0xDF < to ? 0xDF : to;
	for (i = ini; i <= fin; i++) *d++ = (U8)i;
    }
    ini = fr < 0x8140 ? 0x8140 : fr;
    fin = 0xFCFC < to ? 0xFCFC : to;
    if (ini <= fin) {
	U8 r, c, iniL, iniT, finL, finT;
	iniL = (U8)(ini >> 8);
	iniT = (U8)(ini & 0xFF);
	finL = (U8)(fin >> 8);
	finT = (U8)(fin & 0xFF);
	if (iniT < 0x40) iniT = 0x40;
	if (finT > 0xFC) finT = 0xFC;

	if (iniL == finL) {
	    for (c = iniT; c <= finT; c++) {
		if (c == 0x7F) continue;
		*d++ = iniL;
		*d++ = c;
	    }
	} else {
	    for (c = iniT; c <= 0xFC; c++) {
		if (c == 0x7F) continue;
		*d++ = iniL;
		*d++ = c;
	    }
	    for (r = iniL+1; r < finL; r++) {
	        if (0xA0 <= r && r <= 0xDF) continue;
		for (c = 0x40; c <= 0xFC; c++) {
		    if (c == 0x7F) continue;
		    *d++ = r;
		    *d++ = c;
		}
	    }
	    for (c = 0x40; c <= finT; c++) {
		if (c == 0x7F) continue;
		*d++ = finL;
		*d++ = c;
	    }
	}
    }
    return d;
}


/*
 * internal for mkrange
 */
static U8* range_expand_rev (U8* d, U16 fr, U16 to)
{
    int i, ini, fin;

    ini = 0xFCFC < fr ? 0xFCFC : fr;
    fin = to < 0x8140 ? 0x8140 : to;
    if (ini >= fin) {
	U8 r, c, iniL, iniT, finL, finT;
	iniL = (U8)(ini >> 8);
	iniT = (U8)(ini & 0xFF);
	finL = (U8)(fin >> 8);
	finT = (U8)(fin & 0xFF);
	if (iniT > 0xFC) iniT = 0xFC;
	if (finT < 0x40) finT = 0x40;

	if (iniL == finL) {
	    for (c = iniT; c >= finT; c--) {
		if (c == 0x7F) continue;
		*d++ = iniL;
		*d++ = c;
	    }
	} else {
	    for (c = iniT; c >= 0x40; c--) {
		if (c == 0x7F) continue;
		*d++ = iniL;
		*d++ = c;
	    }
	    for (r = iniL-1; r > finL; r--) {
	        if (0xA0 <= r && r <= 0xDF) continue;
		for (c = 0xFC; c >= 0x40; c--) {
		    if (c == 0x7F) continue;
		    *d++ = r;
		    *d++ = c;
		}
	    }
	    for (c = 0xFC; c >= finT; c--) {
		if (c == 0x7F) continue;
		*d++ = finL;
		*d++ = c;
	    }
	}
    }
    if (to <= 0xDF) {
	ini = fr > 0xDF ? 0xDF : fr;
	fin = to < 0xA1 ? 0xA1 : to;
	for (i = ini; i >= fin; i--) *d++ = (U8)i;
    }
    if (to <= 0x7F) {
	ini = fr > 0x7F ? 0x7F : fr;
	fin = to;
	for (i = ini; i >= fin; i--) *d++ = (U8)i;
    }
    return d;
}


/*
 * for error message
 */
static U8* vidualize_char (U8* d, U16 c)
{
    if (isSJ_CNTRL(c)) {
	*d++ = '\\';
	if (c) {
	    *d++ = 'x';
	    *d++ = "0123456789ABCDEF"[ (c >> 4) & 0xF ];
	    *d++ = "0123456789ABCDEF"[  c       & 0xF ];
	}
	else *d++ = '0';
    } else if (c <= 0xFF) {
	*d++ = (c & 0xFF);
    } else {
	    *d++ = (c >> 8) & 0xFF;
	    *d++ =  c       & 0xFF;
    }
    return d;
}

/********

for strtr_mktable.
the first 256bytes: index[256];
the next 2 bytes:   tolast[2]
the following: tochar[2] in 400 bytes per 1 fromchar row.

*********/

/* 256 + 2 */
#define SJIS_StrtrIndexPad    (258)

/* at least,
 * for single-byte 0x00..0x7F and 0xA1..0xDF (191 chars) => 382 bytes
 * for double-byte 0x40..0x7E and 0x80..0xFC (188 chars) => 376 bytes
 */
#define SJIS_StrtrBytesPerRow (400)

#define SJIS_StrtrUndefByte (0xFF)
#define SJIS_StrtrDelByte   (0xFE)

/* row-cell is of "fromchar" */
static U8* strtr_tochar_ptr(U8* tbl, U8 row, U8 cell)
{
    U8 idx, *ip;

    idx = tbl[row];
    if (idx == SJIS_StrtrUndefByte) return NULL;
    ip = tbl + SJIS_StrtrIndexPad + (idx * SJIS_StrtrBytesPerRow);

    if (row) {
	if (!isSJ2ND(cell)) return NULL;
	ip += 2 * (cell - 0x40 - (0x80 <= cell));
    } else {
	if (!isSJ1BT(cell)) return NULL;
	ip += 2 * (cell - 0x21 * (0xA1 <= cell));
    }
    return ip;
}


MODULE = ShiftJIS::String	PACKAGE = ShiftJIS::String

void
issjis(...)
  PREINIT:
    I32 i;
    U8 *s;
    STRLEN byte;
  CODE:
    for (i = 0; i < items; i++) {
	s = (U8*)SvPV(ST(i), byte);
	if (issjis(s, byte) == 0) XSRETURN_NO;
    }
    XSRETURN_YES;


SV*
length(arg)
    SV *arg
  PROTOTYPE: $
  PREINIT:
    U8 *s;
    STRLEN byte;
  CODE:
    s = (U8*)SvPV(arg,byte);
    RETVAL = newSViv(length(s,byte));
  OUTPUT:
    RETVAL


SV*
strrev(src)
    SV *src
  PROTOTYPE: $
  PREINIT:
    U8 *s, *p, *q, *e;
    STRLEN byte;
    SV *dst;
  CODE:
    s = (U8*)SvPV(src,byte);

    dst = byte ? newSV(byte) : newSVpvn("",0);
    (void)SvPOK_only(dst);
    SvCUR_set(dst, byte);
    q = (U8*)SvEND(dst);

    for (p = s, e = s + byte; p < e;) {
	if (isSJ2BTp(p,e)) {
	   q -= 2;
	   q[0] = *p++;
	   q[1] = *p++;
	} else {
	   *--q = *p++;
	}
    }
    RETVAL = dst;
  OUTPUT:
    RETVAL

SV*
strspn(src, search)
    SV * src
    SV * search
  PROTOTYPE: $$
  ALIAS:
    strcspn = 1
  PREINIT:
    U8 *s, *p, *e, *lst, *one, *two;
    STRLEN sbyte, lbyte, ol = 0, tl = 0, cnt = 0;
  CODE:
    s = (U8*)SvPV(src,sbyte);
    e = s + sbyte;
    lst = (U8*)SvPV(search,lbyte);
    New(0, one, lbyte + 1, U8);
    New(0, two, lbyte + 1, U8);
    bytelist(lst,lbyte,one,two,&ol,&tl);
    for (p = s; p < e; ) {
	if (isSJ2BTp(p,e)) {
	   if ((!ix) != (strNchr(two,tl,p,2) != NULL)) break;
	   cnt++; p+=2;
	} else {
	   if ((!ix) != (strNchr(one,ol,p,1) != NULL)) break;
	   cnt++; p++;
	}
    }
    Safefree(one);
    Safefree(two);
    RETVAL = newSVuv(cnt);
  OUTPUT:
    RETVAL



I32
index(src,sub,pos=-0)
    SV * src
    SV * sub
    I32  pos
  PROTOTYPE: $$;$
  ALIAS:
    rindex = 1
  PREINIT:
    U8 *s, *e, *b, *p;
    STRLEN sbyte, bbyte;
    I32 slen, cnt;
  CODE:
    s = (U8*)SvPV(src,sbyte);
    b = (U8*)SvPV(sub,bbyte);
    slen = length(s,sbyte);

    if (ix == 0) {
	if (items == 2) pos = 0;
	if (bbyte == 0) XSRETURN_IV(pos <= 0 ? 0 : slen <= pos ? slen : pos);
	if (slen < pos) XSRETURN_IV(-1);
    } else {
	if (items == 2) pos = slen;
	if (bbyte == 0) XSRETURN_IV(pos <= 0 ? 0 : slen <= pos ? slen : pos);
	if (pos  <   0) XSRETURN_IV(-1);
    }
    cnt = 0;
    RETVAL = -1;
    e = s + sbyte - (bbyte - 1); /* p must be followed by bbyte */
    for (p = s; p < e; ++p) {
	if (ix ? cnt <= pos : pos <= cnt) {
	    if (*p == *b && memEQ(p,b,bbyte)) {
		RETVAL = cnt;
		if (ix == 0) break;
	    }
	}
	if (isSJ2BTp(p,e)) ++p;
	++cnt;
    }
  OUTPUT:
    RETVAL


void
possubstr (src,off,len=-0,rep=&PL_sv_undef)
    SV* src
    I32 off
    I32 len
    SV* rep
  PROTOTYPE: $$;$$
  PREINIT:
    U8 *s, *e, *p, *p_ini, *p_fin;
    STRLEN sbyte;
    I32 slen, ini, fin, cnt;
    bool except = FALSE;
  PPCODE:
    s = SvROK(src)
	? (U8*)SvPV_force(SvRV(src), sbyte)
	: (U8*)SvPV(src, sbyte);

    e = s + sbyte;
    slen = length(s,sbyte);
    if (slen < off) except = TRUE;

    if (items == 2) {
	len = slen - off;
    } else {
	if (off + slen < 0 && len + slen < 0) except = TRUE;
        else if (0 <= len && off + len + slen < 0) except = TRUE;
    }
    if (except) {
       if (items > 3) croak("ShiftJIS::String outside of string in substr");
       else XSRETURN_UNDEF;
    }
    ini = off < 0 ? slen + off : off;
    fin = len < 0 ? slen + len : ini + len;
    if (ini < 0)    ini = 0;
    if (ini > fin)  fin = ini;
    if (slen < ini) ini = slen;
    if (slen < fin) fin = slen;

    p_ini = (ini == 0) ? s : NULL;
    p_fin = (fin == 0) ? s : NULL;

    for (p = s, cnt = 0; p < e; ) {
	if (fin <= cnt) break; /* never ini > fin */
	if (isSJ2BTp(p,e)) ++p;
	++p; ++cnt;
	if (cnt == ini) p_ini = p;
	if (cnt == fin) p_fin = p;
    }
    XPUSHs(sv_2mortal(newSViv(p_ini - s)));
    XPUSHs(sv_2mortal(newSViv(p_fin - p_ini)));


SV *
hiXka(src)
    SV * src
  PROTOTYPE: $
  ALIAS:
    hi2ka = 1
    ka2hi = 2
  PREINIT:
    U8 *s, *p, *e, *d;
    STRLEN byte;
    SV* dst;
    I32 cnt = 0;
  CODE:
    s = SvROK(src)
	? (U8*)SvPV_force(SvRV(src), byte)
	: (U8*)SvPV(src, byte);

    dst = byte ? newSV(2 * byte) : newSVpvn("",0);
    (void)SvPOK_only(dst);
    d = (U8*)SvPVX(dst);

    for (p = s, e = s + byte; p < e;) {
	if (isSJ2BTp(p,e)) {
	    if (ix != 2) {
		if(isSJ_HI_VUp(p)) {
		    *d++ = *p++ + 1;
		    *d++ = 0x94;
		    p+=3; ++cnt; continue;
		} else if (isSJ_HI1ST(*p) && isSJ_HI2ND(*(p+1))) {
		    *d++ = *p++ + 1;
		    *d++ = *p - (SJIS_DIFF_HIRA_KATA + isSJ_HI2ND1(*p));
		    p++; ++cnt; continue;
		} else if (isSJ_HI_ITERp(p)) {
		    *d++ = *p++;
		    *d++ = *p - SJIS_DIFF_HIRA_KATA_ITER;
		    p++; ++cnt; continue;
		}
	    }
	    if (ix != 1) {
		if (isSJ_KA1ST(*p)) {
		    if (isSJ_KA2ND(*(p+1))) {
			*d++ = *p++ - 1;
			*d++ = *p + (SJIS_DIFF_HIRA_KATA + isSJ_KA2ND1(*p));
			p++; ++cnt; continue;
		    } else if (isSJ_KA2ND_VU(*(p+1))) {
			*d++ = *p++ - 1;
			*d++ = 0xA4;
			*d++ = 0x81;
			*d++ = 0x4A;
			p++; ++cnt; continue;
		    } else if (isSJ_KA2ND_KA(*(p+1))) {
			*d++ = *p++ - 1;
			*d++ = 0xA9;
			p++; ++cnt; continue;
		    } else if (isSJ_KA2ND_KE(*(p+1))) {
			*d++ = *p++ - 1;
			*d++ = 0xAF;
			p++; ++cnt; continue;
		    }
		} else if (isSJ_KA_ITERp(p)) {
		    *d++ = *p++;
		    *d++ = *p + SJIS_DIFF_HIRA_KATA_ITER;
		    p++; ++cnt; continue;
		}
	    }
	    *d++ = *p++;
	    *d++ = *p++;
	} else {
	    *d++ = *p++;
	}
    }
    SvCUR_set(dst, d - (U8*)SvPVX(dst));

    if (SvROK(src)) {
	RETVAL = newSViv(cnt);
	sv_setsv(SvRV(src), dst);
    } else {
	RETVAL = dst;
    }
  OUTPUT:
    RETVAL


SV *
kanaH2Z(src)
    SV * src
  PROTOTYPE: $
  ALIAS:
    kataH2Z = 1
  PREINIT:
    U8 *s, *p, *e, *d;
    STRLEN byte;
    SV* dst;
    I32 cnt = 0;
  CODE:
    s = SvROK(src)
	? (U8*)SvPV_force(SvRV(src), byte)
	: (U8*)SvPV(src, byte);

    dst = byte ? newSV(2 * byte) : newSVpvn("",0);
    (void)SvPOK_only(dst);
    d = (U8*)SvPVX(dst);

    for (p = s, e = s + byte; p < e;) {
	if (isSJ2BTp(p,e)) {
	    *d++ = *p++;
	    *d++ = *p++;
	} else if (isSJ_HKPCT(*p)) {
	    *d++ = 0x81;
	    *d++ = (U8)SJIS_HKANA_TRAIL[ *p++ - 0xA0 ];
	    ++cnt;
	} else if (isSJ_HKANA(*p)) {
	    *d++ = 0x83;
	    *d   = (U8)SJIS_HKANA_TRAIL[ *p - 0xA0 ];
	    if (isSJ_HKATO(*p) && isSJ_HTEN2(*(p+1))) ++*d,  p++;
	    else if (isSJ_H_VUp(p)) *d = 148, p++;
	    else if (isSJ_HHAHO(*p)) {
		if      (isSJ_HTEN2(*(p+1))) ++*d,  p++;
		else if (isSJ_HMARU(*(p+1))) *d+=2, p++;
	    }
	    ++d; ++p; ++cnt;
	} else { /* single-byte char except KANA */
	    *d++ = *p++;
	}
    }
    SvCUR_set(dst, d - (U8*)SvPVX(dst));

    if (SvROK(src)) {
	RETVAL = newSViv(cnt);
	sv_setsv(SvRV(src), dst);
    } else {
	RETVAL = dst;
    }
  OUTPUT:
    RETVAL




SV *
kanaZ2H(src)
    SV * src
  PROTOTYPE: $
  ALIAS:
    kataZ2H = 1
  PREINIT:
    U8 *s, *p, *e, *d;
    STRLEN byte;
    SV* dst;
    U16 uv;
    I32 cnt = 0;
  CODE:
    s = SvROK(src)
	? (U8*)SvPV_force(SvRV(src), byte)
	: (U8*)SvPV(src, byte);

    dst = byte ? newSV(byte) : newSVpvn("",0);
    (void)SvPOK_only(dst);
    d = (U8*)SvPVX(dst);


    for (p = s, e = s + byte; p < e; ) {
	if (isSJ2BTp(p,e)) {
	    if (isSJ_HI_VUp(p)) {
		if (ix == 1) {
		    *d++ = *p++; /* not replaced */
		    *d++ = *p++;
		    *d++ = *p++;
		    *d++ = *p++;
		} else {
		    *d++ = 0xB3;
		    *d++ = 0xDE;
		    p += 4; ++cnt;
		}
	    } else if (ix != 1 && isSJ_HI1ST(*p) && isSJ_HI2ND(*(p+1))) {
		uv = SJIS_ZHIRA_TRAIL[ *++p - 0x9F ];
		if(0xFF < uv) *d++ = uv >> 8;
		if(uv) *d++ = (U8)(uv & 0xFF);
		++p; ++cnt;
	    } else if (isSJ_KA1ST(*p) && isSJ_KA2ND_X(*(p+1))) {
		uv = SJIS_ZKATA_TRAIL[ *++p - 0x40 ];
		if(0xFF < uv) *d++ = uv >> 8;
		if(uv) *d++ = (U8)(uv & 0xFF);
		++p; ++cnt;
	    } else if (*p == 0x81 && isSJ_ZKPCT2ND(*(p+1))) {
		switch (*++p) {
		    case 0x41: *d++ = 0xA4; break;
		    case 0x42: *d++ = 0xA1; break;
		    case 0x45: *d++ = 0xA5; break;
		    case 0x4A: *d++ = 0xDE; break;
		    case 0x4B: *d++ = 0xDF; break;
		    case 0x5B: *d++ = 0xB0; break;
		    case 0x75: *d++ = 0xA2; break;
		    case 0x76: *d++ = 0xA3; break;
		}
		++p; ++cnt;
	    } else {
		*d++ = *p++;
		*d++ = *p++;
	    }
	} else {
	    *d++ = *p++;
	}
    }
    SvCUR_set(dst, d - (U8*)SvPVX(dst));

    if (SvROK(src)) {
	RETVAL = newSViv(cnt);
	sv_setsv(SvRV(src), dst);
    } else {
	RETVAL = dst;
    }
  OUTPUT:
    RETVAL


SV *
spaceH2Z(src)
    SV * src
  PROTOTYPE: $
  PREINIT:
    U8 *s, *p, *e, *d;
    STRLEN byte;
    SV* dst;
    I32 cnt = 0;
  CODE:
    s = SvROK(src)
	? (U8*)SvPV_force(SvRV(src), byte)
	: (U8*)SvPV(src, byte);

    dst = byte ? newSV(2 * byte) : newSVpvn("",0);
    (void)SvPOK_only(dst);
    d = (U8*)SvPVX(dst);

    for (p = s, e = s + byte; p < e;) {
	if (isSJ2BTp(p,e)) {
	    *d++ = *p++;
	    *d++ = *p++;
	} else if (isSJ_SPACE(*p)) {
	    *d++ = 0x81;
	    *d++ = 0x40;
	    ++p; ++cnt;
	} else {
	    *d++ = *p++;
	}
    }
    SvCUR_set(dst, d - (U8*)SvPVX(dst));

    if (SvROK(src)) {
	RETVAL = newSViv(cnt);
	sv_setsv(SvRV(src), dst);
    } else {
	RETVAL = dst;
    }
  OUTPUT:
    RETVAL



SV *
spaceZ2H(src)
    SV * src
  PROTOTYPE: $
  PREINIT:
    U8 *s, *p, *e, *d;
    STRLEN byte;
    SV* dst;
    U16 uv;
    I32 cnt = 0;
  CODE:
    s = SvROK(src)
	? (U8*)SvPV_force(SvRV(src), byte)
	: (U8*)SvPV(src, byte);

    dst = byte ? newSV(byte) : newSVpvn("",0);
    (void)SvPOK_only(dst);
    d = (U8*)SvPVX(dst);

    for (p = s, e = s + byte; p < e; ) {
	if (isSJ2BTp(p,e)) {
	    if (isSJ_ZSPACEp(p)) {
	        *d++ = 0x20;
		p += 2; ++cnt;
	    } else {
		*d++ = *p++;
		*d++ = *p++;
	    }
	} else {
	    *d++ = *p++;
	}
    }
    SvCUR_set(dst, d - (U8*)SvPVX(dst));

    if (SvROK(src)) {
	RETVAL = newSViv(cnt);
	sv_setsv(SvRV(src), dst);
    } else {
	RETVAL = dst;
    }
  OUTPUT:
    RETVAL


SV *
toupper(src)
    SV * src
  PROTOTYPE: $
  ALIAS:
    tolower = 1
  PREINIT:
    U8 *s, *p, *e, *d;
    STRLEN byte;
    SV* dst;
    I32 cnt = 0;
  CODE:
    s = SvROK(src)
	? (U8*)SvPV_force(SvRV(src), byte)
	: (U8*)SvPV(src, byte);

    dst = byte ? newSV(byte) : newSVpvn("",0);
    (void)SvPOK_only(dst);
    d = (U8*)SvPVX(dst);

    for (p = s, e = s + byte; p < e; ) {
	if (isSJ2BTp(p,e)) {
	    *d++ = *p++;
	    *d++ = *p++;
	} else if (ix == 0 && isSJ_LOWER(*p)) {
	    *d++ = *p++ - 0x20;
	    ++cnt;
	} else if (ix == 1 && isSJ_UPPER(*p)) {
	    *d++ = *p++ + 0x20;
	    ++cnt;
	} else {
	    *d++ = *p++;
	}
    }
    SvCUR_set(dst, d - (U8*)SvPVX(dst));

    if (SvROK(src)) {
	RETVAL = newSViv(cnt);
	sv_setsv(SvRV(src), dst);
    } else {
	RETVAL = dst;
    }
  OUTPUT:
    RETVAL


void
mkrange(src, rev = &PL_sv_undef)
    SV * src
    SV * rev
  PROTOTYPE: $;$
  PREINIT:
    U8 *s, *p, *e, *d;
    U8 lastL = 0, iniL, iniT, finL, finT;
    STRLEN sbyte, dbyte, dstcur;
    SV* dst;
    U16 fr, to;
    bool isReverse, doReverse, isrange;
  PPCODE:
    isReverse = SvTRUE(rev);

    s = (U8*)SvPV(src, sbyte);
    e = s + sbyte;

    dbyte = sbyte + 1;
    dst = sv_2mortal(newSV(dbyte));
    (void)SvPOK_only(dst);
    d = (U8*)SvPVX(dst);

    p = s;
    if (*p == '-') *d++ = *p++;

    isrange = FALSE;
    while (p < e) {
	if (isrange) {
	    iniL = lastL;
	    iniT = *(d-1);
	    doReverse = FALSE;

	    if (isSJ_BACKp(p)) {
		++p; /* skip '\\' */
		finL = 0;
		finT = *p++;
	    } else if (isSJ2BTp(p,e)) {
		finL = *p++;
		finT = *p++;
	    } else {
		finL = 0;
		finT = *p++;
	    }

	    fr = (iniL << 8) | iniT;
	    to = (finL << 8) | finT;

	    if (fr > to) {
		if (isReverse) doReverse = TRUE;
		else {
		    char *m; char msg[SJIS_VIDUAL_MAX * 2 + 2];
		    m = msg;
		    m = (char*)vidualize_char((U8*)m, fr);
		    *m++ = '-';
		    m = (char*)vidualize_char((U8*)m, to);
		    *m++ = '\0';
		    croak("ShiftJIS::String Invalid character range %s", msg);
		}
	    }
	    dbyte += diff_by_lead(iniL, finL);
	    dstcur = d - (U8*)SvPVX(dst);
	    d = (U8*)SvGROW(dst,dbyte);
	    d += dstcur;

	    if (doReverse) {
		d = range_expand_rev(d, fr - 1, to); /* skip the first */
	    } else {
		d = range_expand(d, fr + 1, to); /* skip the first */
	    }
	    isrange = FALSE;

	} else {
	    if (isSJ_BACKp(p)) {
		lastL = 0;
		++p;
		*d++ = *p++;
	    } else if (isSJ2BTp(p,e)) {
		lastL = *p;
		*d++ = *p++;
		*d++ = *p++;
	    } else if (isSJ_RANGEp(p)) {
		++p;
		if (p < e) isrange = TRUE; else *d++ = '-';
	    } else {
		lastL = 0;
		*d++ = *p++;
	    }
	}
    }
    SvCUR_set(dst, d - (U8*)SvPVX(dst));

    if (GIMME_V != G_ARRAY) {
	XPUSHs(dst);
    } else {
	I32 dlen;
	STRLEN c = 0;
	d = (U8*)SvPV(dst,dbyte);
	e = d + dbyte;
	dlen = length(d, dbyte);
        EXTEND(SP, dlen);
	for(p = d; p < e; p += c) {
	    c = isSJ2BTp(p,e) ? 2 : 1;
	    PUSHs(sv_2mortal(newSVpvn(p,c)));
	}
    }


SV*
strtr_light (src, table, mod = "")
    SV * src;
    SV * table;
    char * mod;
  PROTOTYPE: $$;$
  PREINIT:
    SV *dst;
    bool mod_c, mod_d, mod_s, found;
    int modes, tlen, cnt;
    U8 *p, *e, *s, *d, *tbl, idx;
    STRLEN byte, tblbyte;
    U8 fr[2], *to, tolast[2], pre[2], tmp[2];
    STRLEN fbyte, tbyte, lbyte, prebyte, tmpbyte;
  CODE:
    s = SvROK(src)
	? (U8*)SvPV_force(SvRV(src), byte)
	: (U8*)SvPV(src, byte);

    tbl = (U8*)SvPV(table, tblbyte);

    if (tblbyte < SJIS_StrtrIndexPad)
	croak("ShiftJIS::String Panic! too short table in strtr_light");
    idx = (tblbyte - SJIS_StrtrIndexPad) / SJIS_StrtrBytesPerRow;

    for (p = tbl, e = tbl + 256; p < e; p++)
	if (*p != SJIS_StrtrUndefByte && idx <= *p)
	    croak("ShiftJIS::String Panic! index is broken in strtr_light");

    tolast[0] = tbl[SJIS_StrtrIndexPad - 2];
    tolast[1] = tbl[SJIS_StrtrIndexPad - 1];
    lbyte = (*tolast == SJIS_StrtrUndefByte) ? 0 : *tolast ? 2 : 1;

    /* now only bool, not a string-length */
    tlen = (*tolast != SJIS_StrtrUndefByte);

    mod_c = strchr(mod,'c') != NULL;
    mod_d = strchr(mod,'d') != NULL;
    mod_s = strchr(mod,'s') != NULL;
    modes = (mod_s << 2) | (mod_d << 1) | mod_c;

    dst = byte ? newSV(2 * byte) : newSVpvn("",0);
    (void)SvPOK_only(dst);
    d = (U8*)SvPVX(dst);

    pre[0] = pre[1] = prebyte = 0;
    tmp[0] = tmp[1] = tmpbyte = 0;

    for (p = s, e = s + byte, cnt = 0; p < e; ) {
	if (isSJ2BTp(p,e)) {
	    fr[0] = *p++;
	    fr[1] = *p++;
	    fbyte = 2;
	} else {
	    fr[0] = 0;
	    fr[1] = *p++;
	    fbyte = 1;
	}

	found = FALSE;
	tbyte = 0;
	to = strtr_tochar_ptr(tbl, fr[0], fr[1]);

	if (to != NULL && *to != SJIS_StrtrUndefByte) {
	    found = TRUE;
	    tbyte = (*to == SJIS_StrtrDelByte) ? 0 : (*to != 0) ? 2 : 1;
	}

	if(mod_c ^ found) cnt++;

	switch (modes) {
	    case 0 : /* c: false, d: false, s: false */
	    case 2 : /* c: false, d: true,  s: false */

		if (found) {
		    if (tbyte > 1) *d++ = to[0];
		    if (tbyte > 0) *d++ = to[1];
		} else {
		    if (fbyte > 1) *d++ = fr[0];
		    if (fbyte > 0) *d++ = fr[1];
		}
		break;

	    case 1 : /* c: true, d: false, s: false */

		if (!found && tlen) {
		    if (lbyte > 1) *d++ = tolast[0];
		    if (lbyte > 0) *d++ = tolast[1];
		} else {
		    if (fbyte > 1) *d++ = fr[0];
		    if (fbyte > 0) *d++ = fr[1];
		}
		break;

	    case 3 : /* c: true, d: true, s: false */
	    case 7 : /* c: true, d: true, s: true  */

		if (found) {
		    if (fbyte > 1) *d++ = fr[0];
		    if (fbyte > 0) *d++ = fr[1];
		}
		break;

	    case 4 : /* c: false, d: false, s: true */
	    case 6 : /* c: false, d: true,  s: true */

		if (!found) {
		    pre[0] = pre[1] = prebyte = 0;
		    if (fbyte > 1) *d++ = fr[0];
		    if (fbyte > 0) *d++ = fr[1];
	        } else if (tbyte && memNE(pre, to, 2)) {
		    if (tbyte > 1) *d++ = to[0];
		    if (tbyte > 0) *d++ = to[1];
		    pre[0]  = to[0];
		    pre[1]  = to[1];
		    prebyte = tbyte;
	        }
		break;

	    case 5 : /* c: true, d: false, s: true */

		if (found) {
		    pre[0] = pre[1] = prebyte = 0;
		    if (fbyte > 1) *d++ = fr[0];
		    if (fbyte > 0) *d++ = fr[1];
		} else {
		    tmp[0] = tmp[1] = tmpbyte = 0;
		    if (tlen) {
			if (lbyte > 1) tmp[0] = tolast[0];
			if (lbyte > 0) tmp[1] = tolast[1];
			tmpbyte = lbyte;
		    } else {
			if (fbyte > 1) tmp[0] = fr[0];
			if (fbyte > 0) tmp[1] = fr[1];
			tmpbyte = fbyte;
		    }
		    if (memNE(tmp, pre, 2)) {
			if (tmpbyte > 1) *d++ = tmp[0];
			if (tmpbyte > 0) *d++ = tmp[1];
			pre[0]  = tmp[0];
			pre[1]  = tmp[1];
			prebyte = tmpbyte;
		    }
		}
		break;

	    default :
		croak("ShiftJIS::String Panic! Invalid closure in trclosure");
		break;
	}
    }
    SvCUR_set(dst, d - (U8*)SvPVX(dst));

    if (SvROK(src)) {
	RETVAL = newSViv(cnt);
	sv_setsv(SvRV(src), dst);
    } else {
	RETVAL = dst;
    }
  OUTPUT:
    RETVAL



SV*
strtr_mktable (search, replace, mod = "")
    SV * search;
    SV * replace;
    char * mod;
  PROTOTYPE: $$;$
  PREINIT:
    SV *dst;
    bool mod_c, mod_d;
    U8 *p, *d, *dend, *f, *fend, *t, *tend, *here;
    STRLEN dbyte, fbyte, tbyte;
    U8 idx = 0, fr[2], to[2], tolast[2];
  CODE:

    f = (U8*)SvPV(search,  fbyte);
    fend = f + fbyte;
    t = (U8*)SvPV(replace, tbyte);
    tend = t + tbyte;

    tolast[0] = tolast[1] = SJIS_StrtrUndefByte;
    if (tbyte == 0) t = NULL;

    mod_c = strchr(mod,'c') != NULL;
    mod_d = strchr(mod,'d') != NULL;

    dbyte = SJIS_StrtrIndexPad;
    dst = newSV(dbyte + 1);
    (void)SvPOK_only(dst);
    d = (U8*)SvPVX(dst);

    p = d;
    dend = d + SJIS_StrtrIndexPad;
    while(p < dend) *p++ = SJIS_StrtrUndefByte;

    while (f < fend) {
	if (isSJ2BTp(f,fend)) {
	    *fr = *f++;
	    f++;
	} else {
	    *fr = 0;
	    f++;
	}
	if (d[*fr] == SJIS_StrtrUndefByte) {
	    dbyte += SJIS_StrtrBytesPerRow;
	    d[*fr] = idx++;
	}
    }

    d = (U8*)SvGROW(dst, dbyte + 1);
    if (!d) croak("ShiftJIS::String Panic in strtr_mktable");

    p = d + SJIS_StrtrIndexPad;
    dend = d + dbyte;
    while(p < dend) *p++ = SJIS_StrtrUndefByte;

    f = (U8*)SvPVX(search);

    while (f < fend) {
	if (isSJ2BTp(f,fend)) {
	    fr[0] = *f++;
	    fr[1] = *f++;
	} else {
	    fr[0] = 0;
	    fr[1] = *f++;
	}

	if (t && t < tend) {
	    if (isSJ2BTp(t,tend)) {
		to[0] = *t++;
		to[1] = *t++;
	    } else {
		to[0]  = 0;
		to[1] = *t++;
	    }
	}

	here = strtr_tochar_ptr(d, fr[0], fr[1]);

	if (here && *here == SJIS_StrtrUndefByte) {
	    if (tbyte) {
		if (t) {
		    here[0] = to[0];
		    here[1] = to[1];
		} else if (!mod_d) {
		    here[0] = tolast[0];
		    here[1] = tolast[1];
		} else {
		    here[0] = here[1] = SJIS_StrtrDelByte;
		}
	    } else {
		if (!mod_d || mod_c) {
		    here[0] = fr[0];
		    here[1] = fr[1];
		} else {
		    here[0] = here[1] = SJIS_StrtrDelByte;
		}
	    }
	}

	if (t && t >= tend) {
	    t = NULL;
	    tolast[0] = to[0];
	    tolast[1] = to[1];
	}
    }

    while (t && t < tend) {
	if (isSJ2BTp(t,tend)) {
	    tolast[0] = *t++;
	    tolast[1] = *t++;
	} else {
	    tolast[0] = 0;
	    tolast[1] = *t++;
	}
    }

    d[SJIS_StrtrIndexPad - 2] = tolast[0];
    d[SJIS_StrtrIndexPad - 1] = tolast[1];

    SvCUR_set(dst, dbyte);
    RETVAL = dst;
  OUTPUT:
    RETVAL

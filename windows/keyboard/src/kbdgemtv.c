/*
 * kbdgemtv.dll — Georgian (Ergonomic, Mtavruli) keyboard layout for Windows.
 * Generated tables: kbdgemtv_tables.inc (from kbdgemtv.klc, which comes from xkb ge-custom).
 * Structures follow kbd.h (Windows DDK), KBD_VERSION 1.
 *
 * Build variants:
 *   native x64 / arm64 / x86 : ordinary pointers
 *   -DKBD_WOW64 (x86 code)   : 64-bit pointer slots (KBD_LONG_POINTER == __ptr64)
 */
typedef unsigned char  BYTE;
typedef unsigned short USHORT, WORD;
typedef unsigned int   DWORD;
typedef unsigned short WCHAR;

#ifdef KBD_WOW64
#define P(T) union { T *p; unsigned long long _pad; }
#define PI(x) { .p = (x) }
#else
#define P(T) T *
#define PI(x) (x)
#endif

#define CAPLOK       0x01
#define CAPLOKALTGR  0x04
#define WCH_NONE     0xF000
#define SHFT_INVALID 0x0F
#define KBDSHIFT 1
#define KBDCTRL  2
#define KBDALT   4
#define KBDEXT      0x0100
#define KBDMULTIVK  0x0200
#define KBDSPECIAL  0x0400
#define KBDNUMPAD   0x0800
#define KLLF_ALTGR  0x0001
#define KBD_VERSION 1

typedef struct { BYTE Vk; BYTE ModBits; } VK_TO_BIT;
typedef struct { P(const VK_TO_BIT) pVkToBit; WORD wMaxModBits; BYTE ModNumber[8]; } MODIFIERS;
typedef struct { BYTE VirtualKey; BYTE Attributes; WCHAR wch[1]; } VK_TO_WCHARS1;
typedef struct { BYTE VirtualKey; BYTE Attributes; WCHAR wch[5]; } VK_TO_WCHARS5;
typedef struct { P(const void) pVkToWchars; BYTE nModifications; BYTE cbSize; } VK_TO_WCHAR_TABLE;
typedef struct { BYTE vsc; P(const WCHAR) pwsz; } VSC_LPWSTR;
typedef struct { BYTE Vsc; USHORT Vk; } VSC_VK;

typedef struct {
    P(const MODIFIERS)         pCharModifiers;
    P(const VK_TO_WCHAR_TABLE) pVkToWcharTable;
    P(const void)              pDeadKey;
    P(const VSC_LPWSTR)        pKeyNames;
    P(const VSC_LPWSTR)        pKeyNamesExt;
    P(const void)              pKeyNamesDead;
    P(const USHORT)            pusVSCtoVK;
    BYTE                       bMaxVSCtoVK;
    P(const VSC_VK)            pVSCtoVK_E0;
    P(const VSC_VK)            pVSCtoVK_E1;
    DWORD                      fLocaleFlags;
    BYTE                       nLgMax;
    BYTE                       cbLgEntry;
    P(const void)              pLigature;
    DWORD                      dwType;
    DWORD                      dwSubType;
} KBDTABLES;

/* ---- scan code -> virtual key (US 101/102 positions) ---- */
#define N 0xFF
#define NP (KBDSPECIAL|KBDNUMPAD)
static const USHORT ausVSCtoVK[] = {
 /*00*/ N, 0x1B, '1','2','3','4','5','6','7','8','9','0', 0xBD, 0xBB, 0x08, 0x09,
 /*10*/ 'Q','W','E','R','T','Y','U','I','O','P', 0xDB, 0xDD, 0x0D, 0xA2, 'A','S',
 /*20*/ 'D','F','G','H','J','K','L', 0xBA, 0xDE, 0xC0, 0xA0, 0xDC, 'Z','X','C','V',
 /*30*/ 'B','N','M', 0xBC, 0xBE, 0xBF, 0xA1|KBDEXT, 0x6A|KBDMULTIVK, 0xA4, 0x20, 0x14,
        0x70,0x71,0x72,0x73,0x74,
 /*40*/ 0x75,0x76,0x77,0x78,0x79, 0x90|KBDEXT|KBDMULTIVK, 0x91|KBDMULTIVK,
        0x24|NP, 0x26|NP, 0x21|NP, 0x6D, 0x25|NP, 0x0C|NP, 0x27|NP, 0x6B, 0x23|NP,
 /*50*/ 0x28|NP, 0x22|NP, 0x2D|NP, 0x2E|NP, 0x2C, N, 0xE2, 0x7A, 0x7B, 0x0C, 0xEE, 0xF1, 0xEA, 0xF9, 0xF5, 0xF3,
 /*60*/ N, N, 0xFB, 0x2F, 0x7C,0x7D,0x7E,0x7F,0x80,0x81,0x82,0x83,0x84,0x85,0x86, 0xED,
 /*70*/ N, 0xE9, N, 0xC1, N, N, 0x87, N, N, N, N, 0xEB, 0x09, N, 0xC2, 0xEC,
};

static const VSC_VK aE0VscToVk[] = {
 {0x10,0xB1|KBDEXT},{0x19,0xB0|KBDEXT},{0x1D,0xA3|KBDEXT},{0x20,0xAD|KBDEXT},
 {0x21,0xB7|KBDEXT},{0x22,0xB3|KBDEXT},{0x24,0xB2|KBDEXT},{0x2E,0xAE|KBDEXT},
 {0x30,0xAF|KBDEXT},{0x32,0xAC|KBDEXT},{0x35,0x6F|KBDEXT},{0x37,0x2C|KBDEXT},
 {0x38,0xA5|KBDEXT},{0x47,0x24|KBDEXT},{0x48,0x26|KBDEXT},{0x49,0x21|KBDEXT},
 {0x4B,0x25|KBDEXT},{0x4D,0x27|KBDEXT},{0x4F,0x23|KBDEXT},{0x50,0x28|KBDEXT},
 {0x51,0x22|KBDEXT},{0x52,0x2D|KBDEXT},{0x53,0x2E|KBDEXT},{0x5B,0x5B|KBDEXT},
 {0x5C,0x5C|KBDEXT},{0x5D,0x5D|KBDEXT},{0x5F,0x5F|KBDEXT},{0x65,0xAA|KBDEXT},
 {0x66,0xAB|KBDEXT},{0x67,0xA8|KBDEXT},{0x68,0xA9|KBDEXT},{0x69,0xA7|KBDEXT},
 {0x6A,0xA6|KBDEXT},{0x6B,0xB6|KBDEXT},{0x6C,0xB4|KBDEXT},{0x6D,0xB5|KBDEXT},
 {0x1C,0x0D|KBDEXT},{0x46,0x03|KBDEXT},
 {0,0}
};
static const VSC_VK aE1VscToVk[] = { {0x1D, 0x13}, {0,0} };

/* ---- modifiers: columns 0=base 1=Shift 2=Ctrl 3=Ctrl+Alt(AltGr) 4=Shift+AltGr ---- */
static const VK_TO_BIT aVkToBits[] = {
 {0x10, KBDSHIFT}, {0x11, KBDCTRL}, {0x12, KBDALT}, {0, 0}
};
static const MODIFIERS CharModifiers = {
 PI(aVkToBits), 7,
 { 0, 1, 2, SHFT_INVALID, SHFT_INVALID, SHFT_INVALID, 3, 4 }
};

#include "kbdgemtv_tables.inc"   /* build.sh აგენერირებს: tools/klc2c.py */

static const VK_TO_WCHAR_TABLE aVkToWcharTable[] = {
 { PI(aVkToWch5), 5, sizeof(VK_TO_WCHARS5) },
 { PI(aVkToWch1), 1, sizeof(VK_TO_WCHARS1) },   /* numpad last */
 { PI(0), 0, 0 }
};

/* ---- key names ---- */
#define K(sc, s) { sc, PI(s) }
static const VSC_LPWSTR aKeyNames[] = {
 K(0x01,u"Esc"), K(0x0e,u"Backspace"), K(0x0f,u"Tab"), K(0x1c,u"Enter"), K(0x1d,u"Ctrl"),
 K(0x2a,u"Shift"), K(0x36,u"Right Shift"), K(0x37,u"Num *"), K(0x38,u"Alt"), K(0x39,u"Space"),
 K(0x3a,u"Caps Lock"), K(0x3b,u"F1"), K(0x3c,u"F2"), K(0x3d,u"F3"), K(0x3e,u"F4"), K(0x3f,u"F5"),
 K(0x40,u"F6"), K(0x41,u"F7"), K(0x42,u"F8"), K(0x43,u"F9"), K(0x44,u"F10"), K(0x45,u"Pause"),
 K(0x46,u"Scroll Lock"), K(0x47,u"Num 7"), K(0x48,u"Num 8"), K(0x49,u"Num 9"), K(0x4a,u"Num -"),
 K(0x4b,u"Num 4"), K(0x4c,u"Num 5"), K(0x4d,u"Num 6"), K(0x4e,u"Num +"), K(0x4f,u"Num 1"),
 K(0x50,u"Num 2"), K(0x51,u"Num 3"), K(0x52,u"Num 0"), K(0x53,u"Num Del"), K(0x54,u"Sys Req"),
 K(0x57,u"F11"), K(0x58,u"F12"), K(0x7c,u"F13"), K(0x7d,u"F14"), K(0x7e,u"F15"), K(0x7f,u"F16"),
 { 0, PI(0) }
};
static const VSC_LPWSTR aKeyNamesExt[] = {
 K(0x1c,u"Num Enter"), K(0x1d,u"Right Ctrl"), K(0x35,u"Num /"), K(0x37,u"Prnt Scrn"),
 K(0x38,u"Right Alt"), K(0x45,u"Num Lock"), K(0x46,u"Break"), K(0x47,u"Home"), K(0x48,u"Up"),
 K(0x49,u"Page Up"), K(0x4b,u"Left"), K(0x4d,u"Right"), K(0x4f,u"End"), K(0x50,u"Down"),
 K(0x51,u"Page Down"), K(0x52,u"Insert"), K(0x53,u"Delete"), K(0x56,u"Help"),
 K(0x5b,u"Left Windows"), K(0x5c,u"Right Windows"), K(0x5d,u"Application"),
 { 0, PI(0) }
};

static const KBDTABLES KbdTables = {
 PI(&CharModifiers),
 PI(aVkToWcharTable),
 PI(0),                    /* no dead keys */
 PI(aKeyNames),
 PI(aKeyNamesExt),
 PI(0),
 PI(ausVSCtoVK),
 sizeof(ausVSCtoVK) / sizeof(ausVSCtoVK[0]),
 PI(aE0VscToVk),
 PI(aE1VscToVk),
 (KBD_VERSION << 16) | KLLF_ALTGR,
 0, 0, PI(0),              /* no ligatures */
 4, 0                      /* IBM enhanced 101/102 */
};

__declspec(dllexport) const KBDTABLES *KbdLayerDescriptor(void)
{
    return &KbdTables;
}

_Static_assert(sizeof(ausVSCtoVK) / sizeof(ausVSCtoVK[0]) == 0x80, "VSC table size");
#if defined(KBD_WOW64) || defined(__x86_64__) || defined(__aarch64__)
_Static_assert(sizeof(KBDTABLES) == 104, "KBDTABLES 64-bit layout");
_Static_assert(sizeof(VK_TO_WCHAR_TABLE) == 16, "VK_TO_WCHAR_TABLE 64-bit layout");
_Static_assert(sizeof(VSC_LPWSTR) == 16, "VSC_LPWSTR 64-bit layout");
#endif

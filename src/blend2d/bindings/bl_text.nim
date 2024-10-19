# Copyright (c) 2017-2024 The Blend2D Authors
#
# This software is provided 'as-is', without any express or
# implied warranty. In no event will the authors be held liable
# for any damages arising from the use of this software.
#
# Permission is granted to anyone to use this software for any purpose,
# including commercial applications, and to alter it and redistribute it
# freely, subject to the following restrictions:
# 
# The origin of this software must not be misrepresented; you must not
# claim that you wrote the original software. If you use this software in
# a product, an acknowledgment in the product documentation would be
# appreciated but is not required.
#
# Altered source versions must be plainly marked as such, and must not
# be misrepresented as being the original software.
#
# This notice may not be removed or altered from any source distribution.
# 
#
# blend2d-nim is a Nim wrapper for the libblend2d library
# providing low-level & high-level API for rendering 2D graphics.
#
# (c) 2024 George Lemon | ZLib License
#     Made by Humans from OpenPeeps
#     https://github.com/openpeeps/blend2d-nim

import ./bl_globals
from ./bl_geometry import BLPoint, BLBox, BLPointI, BLBoxI,
  BLMatrix2D, BLPathCore, BLPathSinkFunc

from ./bl_filesystem import BLFileReadFlags

type
  Type_blend2dh2* {.bycopy, header: blend2dHeader, importc: "struct Type_blend2dh2".} = object
    familyKind*, serifStyle*, weight*,
      proportion*, contrast*, strokeVariation*,
      armStyle*, letterform*, midline*, xHeight*: uint8
  Type_blend2dh3* {.bycopy, header: blend2dHeader, importc: "struct Type_blend2dh3".} = object
    familyKind*, toolKind*, weight*,
      spacing*, aspectRatio*, contrast*,
      topology*, form*, finials*, xAscent*: uint8
  Type_blend2dh4* {.bycopy, header: blend2dHeader, importc: "struct Type_blend2dh4".} = object
    familyKind*, decorativeClass*, weight*,
      aspect*, contrast*, serifVariant*, treatment*,
      lining*, topology*, characterRange*: uint8
  Type_blend2dh5* {.bycopy, header: blend2dHeader, importc: "struct Type_blend2dh5".} = object
    familyKind*, symbolKind*,
      weight*, spacing*, aspectRatioAndContrast*,
      aspectRatio94*, aspectRatio119*, aspectRatio157*,
      aspectRatio163*, aspectRatio211*: uint8

{.push importc, header: blend2dHeader.}
type
  BLTextEncoding* {.size: sizeof(uint32).} = enum
    BL_TEXT_ENCODING_UTF8   ## UTF-8 encoding.
    BL_TEXT_ENCODING_UTF16  ## UTF-16 encoding (native endian).
    BL_TEXT_ENCODING_UTF32  ## UTF-32 encoding (native endian).
    BL_TEXT_ENCODING_LATIN1 ## LATIN1 encoding (one byte per character).
    BL_TEXT_ENCODING_WCHAR  ## Platform native wchar_t (or Windows WCHAR) encoding, alias to either UTF-32, UTF-16, or UTF-8 depending on sizeof(wchar_t).
    BL_TEXT_ENCODING_MAX_VALUE  ## Maximum value of BLTextEncoding.

  BLFontDataFlags* {.size: sizeof(uint32).} = enum
    BL_FONT_DATA_NO_FLAGS # No flags

  BLOrientation* {.size: sizeof(uint32).} = enum
    BL_ORIENTATION_HORIZONTAL, BL_ORIENTATION_VERTICAL,
    BL_ORIENTATION_MAX_VALUE

  BLFontFaceType* {.size: sizeof(uint32).} = enum
    BL_FONT_FACE_TYPE_NONE, BL_FONT_FACE_TYPE_OPENTYPE,
    BL_FONT_FACE_TYPE_MAX_VALUE

  BLFontStretch* {.size: sizeof(uint32).} = enum
    BL_FONT_STRETCH_ULTRA_CONDENSED
    BL_FONT_STRETCH_EXTRA_CONDENSED
    BL_FONT_STRETCH_CONDENSED
    BL_FONT_STRETCH_SEMI_CONDENSED
    BL_FONT_STRETCH_NORMAL
    BL_FONT_STRETCH_SEMI_EXPANDED
    BL_FONT_STRETCH_EXPANDED
    BL_FONT_STRETCH_EXTRA_EXPANDED
    BL_FONT_STRETCH_ULTRA_EXPANDED
    BL_FONT_STRETCH_MAX_VALUE

  BLFontStyle* {.size: sizeof(uint32).} = enum
    BL_FONT_STYLE_NORMAL, BL_FONT_STYLE_OBLIQUE,
    BL_FONT_STYLE_ITALIC, BL_FONT_STYLE_MAX_VALUE

  BLFontWeight* {.size: sizeof(uint32).} = enum
    BL_FONT_WEIGHT_THIN ## Thin weight (100)
    BL_FONT_WEIGHT_EXTRA_LIGHT ## Extra light weight (200)
    BL_FONT_WEIGHT_LIGHT ## Light weight (300)
    BL_FONT_WEIGHT_SEMI_LIGHT ## Semi light weight (350)
    BL_FONT_WEIGHT_NORMAL ## Normal weight (400)
    BL_FONT_WEIGHT_MEDIUM ## Medium weight (500)
    BL_FONT_WEIGHT_SEMI_BOLD ## Semi bold weight (600)
    BL_FONT_WEIGHT_BOLD ## Bold weight (700)
    BL_FONT_WEIGHT_EXTRA_BOLD ## Extra bold weight (800)
    BL_FONT_WEIGHT_BLACK ## Black weight (900)
    BL_FONT_WEIGHT_EXTRA_BLACK ## Extra black weight (950).

  BLFontStringId* {.size: sizeof(uint32).} = enum
    BL_FONT_STRING_ID_COPYRIGHT_NOTICE ## Copyright notice.
    BL_FONT_STRING_ID_FAMILY_NAME ## Font family name.
    BL_FONT_STRING_ID_SUBFAMILY_NAME ## Font subfamily name.
    BL_FONT_STRING_ID_UNIQUE_IDENTIFIER ## Unique font identifier.
    BL_FONT_STRING_ID_FULL_NAME ## Full font name that reflects all family and relevant subfamily descriptors.
    BL_FONT_STRING_ID_VERSION_STRING ## Version string. Should begin with the synta Version <number>.<number>.
    BL_FONT_STRING_ID_POST_SCRIPT_NAME ## PostScript name for the font.
    BL_FONT_STRING_ID_TRADEMARK ## Trademark notice/information for this font.
    BL_FONT_STRING_ID_MANUFACTURER_NAME ## Manufacturer name.
    BL_FONT_STRING_ID_DESIGNER_NAME ## Name of the designer of the typeface.
    BL_FONT_STRING_ID_DESCRIPTION ## Description of the typeface.
    BL_FONT_STRING_ID_VENDOR_URL ## URL of font vendor.
    BL_FONT_STRING_ID_DESIGNER_URL ## URL of typeface designer.
    BL_FONT_STRING_ID_LICENSE_DESCRIPTION ## Description of how the font may be legally used.
    BL_FONT_STRING_ID_LICENSE_INFO_URL ## URL where additional licensing information can be found.
    BL_FONT_STRING_ID_RESERVED ## Reserved.
    BL_FONT_STRING_ID_TYPOGRAPHIC_FAMILY_NAME ## Typographic family name.
    BL_FONT_STRING_ID_TYPOGRAPHIC_SUBFAMILY_NAME ## Typographic subfamily name.
    BL_FONT_STRING_ID_COMPATIBLE_FULL_NAME ## Compatible full name (MAC only).
    BL_FONT_STRING_ID_SAMPLE_TEXT ## Sample text - font name or any other text from the designer.
    BL_FONT_STRING_ID_POST_SCRIPT_CID_NAME ## PostScript CID findfont name.
    BL_FONT_STRING_ID_WWS_FAMILY_NAME ## WWS family name.
    BL_FONT_STRING_ID_WWS_SUBFAMILY_NAME ## WWS subfamily name.
    BL_FONT_STRING_ID_LIGHT_BACKGROUND_PALETTE ## Light background palette.
    BL_FONT_STRING_ID_DARK_BACKGROUND_PALETTE ## Dark background palette.
    BL_FONT_STRING_ID_VARIATIONS_POST_SCRIPT_PREFIX ## Variations PostScript name prefix.
    BL_FONT_STRING_ID_COMMON_MAX_VALUE ## Count of common font string ids.
    BL_FONT_STRING_ID_CUSTOM_START_INDEX ## Start of custom font string ids.
  
  BLFontUnicodeCoverageIndex* {.size: sizeof(uint32).} = enum
    BL_FONT_UC_INDEX_BASIC_LATIN ## [000000-00007F] Basic Latin.
    BL_FONT_UC_INDEX_LATIN1_SUPPLEMENT ## [000080-0000FF] Latin-1 Supplement.
    BL_FONT_UC_INDEX_LATIN_EXTENDED_A ## [000100-00017F] Latin Extended-A.
    BL_FONT_UC_INDEX_LATIN_EXTENDED_B ## [000180-00024F] Latin Extended-B.
    BL_FONT_UC_INDEX_IPA_EXTENSIONS ## [000250-0002AF] IPA Extensions. [001D00-001D7F] Phonetic Extensions. [001D80-001DBF] Phonetic Extensions Supplement.
    BL_FONT_UC_INDEX_SPACING_MODIFIER_LETTERS ## [0002B0-0002FF] Spacing Modifier Letters. [00A700-00A71F] Modifier Tone Letters. [001DC0-001DFF] Combining Diacritical Marks Supplement.
    BL_FONT_UC_INDEX_COMBINING_DIACRITICAL_MARKS ## [000300-00036F] Combining Diacritical Marks.
    BL_FONT_UC_INDEX_GREEK_AND_COPTIC ## [000370-0003FF] Greek and Coptic.
    BL_FONT_UC_INDEX_COPTIC ## [002C80-002CFF] Coptic.
    BL_FONT_UC_INDEX_CYRILLIC ## [000400-0004FF] Cyrillic. [000500-00052F] Cyrillic Supplement. [002DE0-002DFF] Cyrillic Extended-A. [00A640-00A69F] Cyrillic Extended-B.
    BL_FONT_UC_INDEX_ARMENIAN ## [000530-00058F] Armenian.
    BL_FONT_UC_INDEX_HEBREW ## [000590-0005FF] Hebrew.
    BL_FONT_UC_INDEX_VAI ## [00A500-00A63F] Vai.
    BL_FONT_UC_INDEX_ARABIC ## [000600-0006FF] Arabic. [000750-00077F] Arabic Supplement.
    BL_FONT_UC_INDEX_NKO ## [0007C0-0007FF] NKo.
    BL_FONT_UC_INDEX_DEVANAGARI ## [000900-00097F] Devanagari.
    BL_FONT_UC_INDEX_BENGALI ## [000980-0009FF] Bengali.
    BL_FONT_UC_INDEX_GURMUKHI ## [000A00-000A7F] Gurmukhi.
    BL_FONT_UC_INDEX_GUJARATI ## [000A80-000AFF] Gujarati.
    BL_FONT_UC_INDEX_ORIYA ## [000B00-000B7F] Oriya.
    BL_FONT_UC_INDEX_TAMIL ## [000B80-000BFF] Tamil.
    BL_FONT_UC_INDEX_TELUGU ## [000C00-000C7F] Telugu.
    BL_FONT_UC_INDEX_KANNADA ## [000C80-000CFF] Kannada.
    BL_FONT_UC_INDEX_MALAYALAM ## [000D00-000D7F] Malayalam.
    BL_FONT_UC_INDEX_THAI ## [000E00-000E7F] Thai.
    BL_FONT_UC_INDEX_LAO ## [000E80-000EFF] Lao.
    BL_FONT_UC_INDEX_GEORGIAN ## [0010A0-0010FF] Georgian. [002D00-002D2F] Georgian Supplement.
    BL_FONT_UC_INDEX_BALINESE ## [001B00-001B7F] Balinese.
    BL_FONT_UC_INDEX_HANGUL_JAMO ## [001100-0011FF] Hangul Jamo.
    BL_FONT_UC_INDEX_LATIN_EXTENDED_ADDITIONAL ## [001E00-001EFF] Latin Extended Additional. [002C60-002C7F] Latin Extended-C. [00A720-00A7FF] Latin Extended-D.
    BL_FONT_UC_INDEX_GREEK_EXTENDED ## [001F00-001FFF] Greek Extended.
    BL_FONT_UC_INDEX_GENERAL_PUNCTUATION ## [002000-00206F] General Punctuation. [002E00-002E7F] Supplemental Punctuation.
    BL_FONT_UC_INDEX_SUPERSCRIPTS_AND_SUBSCRIPTS ## [002070-00209F] Superscripts And Subscripts.
    BL_FONT_UC_INDEX_CURRENCY_SYMBOLS ## [0020A0-0020CF] Currency Symbols.
    BL_FONT_UC_INDEX_COMBINING_DIACRITICAL_MARKS_FOR_SYMBOLS ## [0020D0-0020FF] Combining Diacritical Marks For Symbols.
    BL_FONT_UC_INDEX_LETTERLIKE_SYMBOLS ## [002100-00214F] Letterlike Symbols.
    BL_FONT_UC_INDEX_NUMBER_FORMS ## [002150-00218F] Number Forms.
    BL_FONT_UC_INDEX_ARROWS ## [002190-0021FF] Arrows. [0027F0-0027FF] Supplemental Arrows-A. [002900-00297F] Supplemental Arrows-B. [002B00-002BFF] Miscellaneous Symbols and Arrows.
    BL_FONT_UC_INDEX_MATHEMATICAL_OPERATORS ## [002200-0022FF] Mathematical Operators. [002A00-002AFF] Supplemental Mathematical Operators. [0027C0-0027EF] Miscellaneous Mathematical Symbols-A. [002980-0029FF] Miscellaneous Mathematical Symbols-B.
    BL_FONT_UC_INDEX_MISCELLANEOUS_TECHNICAL ## [002300-0023FF] Miscellaneous Technical.
    BL_FONT_UC_INDEX_CONTROL_PICTURES ## [002400-00243F] Control Pictures.
    BL_FONT_UC_INDEX_OPTICAL_CHARACTER_RECOGNITION ## [002440-00245F] Optical Character Recognition.
    BL_FONT_UC_INDEX_ENCLOSED_ALPHANUMERICS ## [002460-0024FF] Enclosed Alphanumerics.
    BL_FONT_UC_INDEX_BOX_DRAWING ## [002500-00257F] Box Drawing.
    BL_FONT_UC_INDEX_BLOCK_ELEMENTS ## [002580-00259F] Block Elements.
    BL_FONT_UC_INDEX_GEOMETRIC_SHAPES ## [0025A0-0025FF] Geometric Shapes.
    BL_FONT_UC_INDEX_MISCELLANEOUS_SYMBOLS ## [002600-0026FF] Miscellaneous Symbols.
    BL_FONT_UC_INDEX_DINGBATS ## [002700-0027BF] Dingbats.
    BL_FONT_UC_INDEX_CJK_SYMBOLS_AND_PUNCTUATION ## [003000-00303F] CJK Symbols And Punctuation.
    BL_FONT_UC_INDEX_HIRAGANA ## [003040-00309F] Hiragana.
    BL_FONT_UC_INDEX_KATAKANA ## [0030A0-0030FF] Katakana. [0031F0-0031FF] Katakana Phonetic Extensions.
    BL_FONT_UC_INDEX_BOPOMOFO ## [003100-00312F] Bopomofo. [0031A0-0031BF] Bopomofo Extended.
    BL_FONT_UC_INDEX_HANGUL_COMPATIBILITY_JAMO ## [003130-00318F] Hangul Compatibility Jamo.
    BL_FONT_UC_INDEX_PHAGS_PA ## [00A840-00A87F] Phags-pa.
    BL_FONT_UC_INDEX_ENCLOSED_CJK_LETTERS_AND_MONTHS ## [003200-0032FF] Enclosed CJK Letters And Months.
    BL_FONT_UC_INDEX_CJK_COMPATIBILITY ## [003300-0033FF] CJK Compatibility.
    BL_FONT_UC_INDEX_HANGUL_SYLLABLES ## [00AC00-00D7AF] Hangul Syllables.
    BL_FONT_UC_INDEX_NON_PLANE ## [00D800-00DFFF] Non-Plane 0 *.
    BL_FONT_UC_INDEX_PHOENICIAN ## [010900-01091F] Phoenician.
    BL_FONT_UC_INDEX_CJK_UNIFIED_IDEOGRAPHS ## [004E00-009FFF] CJK Unified Ideographs. [002E80-002EFF] CJK Radicals Supplement. [002F00-002FDF] Kangxi Radicals. [002FF0-002FFF] Ideographic Description Characters. [003400-004DBF] CJK Unified Ideographs Extension A. [020000-02A6DF] CJK Unified Ideographs Extension B. [003190-00319F] Kanbun.
    BL_FONT_UC_INDEX_PRIVATE_USE_PLANE0 ## [00E000-00F8FF] Private Use (Plane 0).
    BL_FONT_UC_INDEX_CJK_STROKES ## [0031C0-0031EF] CJK Strokes. [00F900-00FAFF] CJK Compatibility Ideographs. [02F800-02FA1F] CJK Compatibility Ideographs Supplement.
    BL_FONT_UC_INDEX_ALPHABETIC_PRESENTATION_FORMS ## [00FB00-00FB4F] Alphabetic Presentation Forms.
    BL_FONT_UC_INDEX_ARABIC_PRESENTATION_FORMS_A ## [00FB50-00FDFF] Arabic Presentation Forms-A.
    BL_FONT_UC_INDEX_COMBINING_HALF_MARKS ## [00FE20-00FE2F] Combining Half Marks.
    BL_FONT_UC_INDEX_VERTICAL_FORMS ## [00FE10-00FE1F] Vertical Forms. [00FE30-00FE4F] CJK Compatibility Forms.
    BL_FONT_UC_INDEX_SMALL_FORM_VARIANTS ## [00FE50-00FE6F] Small Form Variants.
    BL_FONT_UC_INDEX_ARABIC_PRESENTATION_FORMS_B ## [00FE70-00FEFF] Arabic Presentation Forms-B.
    BL_FONT_UC_INDEX_HALFWIDTH_AND_FULLWIDTH_FORMS ## [00FF00-00FFEF] Halfwidth And Fullwidth Forms.
    BL_FONT_UC_INDEX_SPECIALS ## [00FFF0-00FFFF] Specials.
    BL_FONT_UC_INDEX_TIBETAN ## [000F00-000FFF] Tibetan.
    BL_FONT_UC_INDEX_SYRIAC ## [000700-00074F] Syriac.
    BL_FONT_UC_INDEX_THAANA ## [000780-0007BF] Thaana.
    BL_FONT_UC_INDEX_SINHALA ## [000D80-000DFF] Sinhala.
    BL_FONT_UC_INDEX_MYANMAR ## [001000-00109F] Myanmar.
    BL_FONT_UC_INDEX_ETHIOPIC ## [001200-00137F] Ethiopic. [001380-00139F] Ethiopic Supplement. [002D80-002DDF] Ethiopic Extended.
    BL_FONT_UC_INDEX_CHEROKEE ## [0013A0-0013FF] Cherokee.
    BL_FONT_UC_INDEX_UNIFIED_CANADIAN_ABORIGINAL_SYLLABICS ## [001400-00167F] Unified Canadian Aboriginal Syllabics.
    BL_FONT_UC_INDEX_OGHAM ## [001680-00169F] Ogham.
    BL_FONT_UC_INDEX_RUNIC ## [0016A0-0016FF] Runic.
    BL_FONT_UC_INDEX_KHMER ## [001780-0017FF] Khmer. [0019E0-0019FF] Khmer Symbols.
    BL_FONT_UC_INDEX_MONGOLIAN ## [001800-0018AF] Mongolian.
    BL_FONT_UC_INDEX_BRAILLE_PATTERNS ## [002800-0028FF] Braille Patterns.
    BL_FONT_UC_INDEX_YI_SYLLABLES_AND_RADICALS ## [00A000-00A48F] Yi Syllables. [00A490-00A4CF] Yi Radicals.
    BL_FONT_UC_INDEX_TAGALOG_HANUNOO_BUHID_TAGBANWA ## [001700-00171F] Tagalog. [001720-00173F] Hanunoo. [001740-00175F] Buhid. [001760-00177F] Tagbanwa.
    BL_FONT_UC_INDEX_OLD_ITALIC ## [010300-01032F] Old Italic.
    BL_FONT_UC_INDEX_GOTHIC ## [010330-01034F] Gothic.
    BL_FONT_UC_INDEX_DESERET ## [010400-01044F] Deseret.
    BL_FONT_UC_INDEX_MUSICAL_SYMBOLS ## [01D000-01D0FF] Byzantine Musical Symbols. [01D100-01D1FF] Musical Symbols. [01D200-01D24F] Ancient Greek Musical Notation.
    BL_FONT_UC_INDEX_MATHEMATICAL_ALPHANUMERIC_SYMBOLS ## [01D400-01D7FF] Mathematical Alphanumeric Symbols.
    BL_FONT_UC_INDEX_PRIVATE_USE_PLANE_15_16 ## [0F0000-0FFFFD] Private Use (Plane 15). [100000-10FFFD] Private Use (Plane 16).
    BL_FONT_UC_INDEX_VARIATION_SELECTORS ## [00FE00-00FE0F] Variation Selectors. [0E0100-0E01EF] Variation Selectors Supplement.
    BL_FONT_UC_INDEX_TAGS ## [0E0000-0E007F] Tags.
    BL_FONT_UC_INDEX_LIMBU ## [001900-00194F] Limbu.
    BL_FONT_UC_INDEX_TAI_LE ## [001950-00197F] Tai Le.
    BL_FONT_UC_INDEX_NEW_TAI_LUE ## [001980-0019DF] New Tai Lue.
    BL_FONT_UC_INDEX_BUGINESE ## [001A00-001A1F] Buginese.
    BL_FONT_UC_INDEX_GLAGOLITIC ## [002C00-002C5F] Glagolitic.
    BL_FONT_UC_INDEX_TIFINAGH ## [002D30-002D7F] Tifinagh.
    BL_FONT_UC_INDEX_YIJING_HEXAGRAM_SYMBOLS ## [004DC0-004DFF] Yijing Hexagram Symbols.
    BL_FONT_UC_INDEX_SYLOTI_NAGRI ## [00A800-00A82F] Syloti Nagri.
    BL_FONT_UC_INDEX_LINEAR_B_SYLLABARY_AND_IDEOGRAMS ## [010000-01007F] Linear B Syllabary. [010080-0100FF] Linear B Ideograms. [010100-01013F] Aegean Numbers.
    BL_FONT_UC_INDEX_ANCIENT_GREEK_NUMBERS ## [010140-01018F] Ancient Greek Numbers.
    BL_FONT_UC_INDEX_UGARITIC ## [010380-01039F] Ugaritic.
    BL_FONT_UC_INDEX_OLD_PERSIAN ## [0103A0-0103DF] Old Persian.
    BL_FONT_UC_INDEX_SHAVIAN ## [010450-01047F] Shavian.
    BL_FONT_UC_INDEX_OSMANYA ## [010480-0104AF] Osmanya.
    BL_FONT_UC_INDEX_CYPRIOT_SYLLABARY ## [010800-01083F] Cypriot Syllabary.
    BL_FONT_UC_INDEX_KHAROSHTHI ## [010A00-010A5F] Kharoshthi.
    BL_FONT_UC_INDEX_TAI_XUAN_JING_SYMBOLS ## [01D300-01D35F] Tai Xuan Jing Symbols.
    BL_FONT_UC_INDEX_CUNEIFORM ## [012000-0123FF] Cuneiform. [012400-01247F] Cuneiform Numbers and Punctuation.
    BL_FONT_UC_INDEX_COUNTING_ROD_NUMERALS ## [01D360-01D37F] Counting Rod Numerals.
    BL_FONT_UC_INDEX_SUNDANESE ## [001B80-001BBF] Sundanese.
    BL_FONT_UC_INDEX_LEPCHA ## [001C00-001C4F] Lepcha.
    BL_FONT_UC_INDEX_OL_CHIKI ## [001C50-001C7F] Ol Chiki.
    BL_FONT_UC_INDEX_SAURASHTRA ## [00A880-00A8DF] Saurashtra.
    BL_FONT_UC_INDEX_KAYAH_LI ## [00A900-00A92F] Kayah Li.
    BL_FONT_UC_INDEX_REJANG ## [00A930-00A95F] Rejang.
    BL_FONT_UC_INDEX_CHAM ## [00AA00-00AA5F] Cham.
    BL_FONT_UC_INDEX_ANCIENT_SYMBOLS ## [010190-0101CF] Ancient Symbols.
    BL_FONT_UC_INDEX_PHAISTOS_DISC ## [0101D0-0101FF] Phaistos Disc.
    BL_FONT_UC_INDEX_CARIAN_LYCIAN_LYDIAN ## [0102A0-0102DF] Carian. [010280-01029F] Lycian. [010920-01093F] Lydian.
    BL_FONT_UC_INDEX_DOMINO_AND_MAHJONG_TILES ## [01F030-01F09F] Domino Tiles. [01F000-01F02F] Mahjong Tiles.
    BL_FONT_UC_INDEX_INTERNAL_USAGE_123 ## Reserved for internal usage (123).
    BL_FONT_UC_INDEX_INTERNAL_USAGE_124 ## Reserved for internal usage (124).
    BL_FONT_UC_INDEX_INTERNAL_USAGE_125 ## Reserved for internal usage (125).
    BL_FONT_UC_INDEX_INTERNAL_USAGE_126 ## Reserved for internal usage (126).
    BL_FONT_UC_INDEX_INTERNAL_USAGE_127 ## Reserved for internal usage (127).
    BL_FONT_UC_INDEX_MAX_VALUE ## Maximum value of BLFontUnicodeCoverageIndex.

  BLTextDirection* {.size: sizeof(uint32).} = enum
    BL_TEXT_DIRECTION_LTR ## Left-to-right direction.
    BL_TEXT_DIRECTION_RTL ## Right-to-left direction.
    BL_TEXT_DIRECTION_MAX_VALUE ## Maximum value of BLTextDirection.

  BLFontFaceFlags* {.size: sizeof(uint32).} = enum
    BL_FONT_FACE_NO_FLAGS ## No flags.
    BL_FONT_FACE_FLAG_TYPOGRAPHIC_NAMES ## Font uses typographic family and subfamily names.
    BL_FONT_FACE_FLAG_TYPOGRAPHIC_METRICS ## Font uses typographic metrics.
    BL_FONT_FACE_FLAG_CHAR_TO_GLYPH_MAPPING ## Character to glyph mapping is available.
    BL_FONT_FACE_FLAG_HORIZONTAL_METIRCS ## Horizontal glyph metrics (advances, side bearings) is available.
    BL_FONT_FACE_FLAG_VERTICAL_METRICS ## Vertical glyph metrics (advances, side bearings) is available.
    BL_FONT_FACE_FLAG_HORIZONTAL_KERNING ## Legacy horizontal kerning feature ('kern' table with horizontal kerning data).
    BL_FONT_FACE_FLAG_VERTICAL_KERNING ## Legacy vertical kerning feature ('kern' table with vertical kerning data).
    BL_FONT_FACE_FLAG_OPENTYPE_FEATURES ## OpenType features (GDEF, GPOS, GSUB) are available.
    BL_FONT_FACE_FLAG_PANOSE_DATA ## Panose classification is available.
    BL_FONT_FACE_FLAG_UNICODE_COVERAGE ## Unicode coverage information is available.
    BL_FONT_FACE_FLAG_BASELINE_Y_EQUALS_0 ## Baseline for font at y equals 0.
    BL_FONT_FACE_FLAG_LSB_POINT_X_EQUALS_0 ## Left sidebearing point at x == 0 (TT only).
    BL_FONT_FACE_FLAG_VARIATION_SEQUENCES ## Unicode variation sequences feature is available.
    BL_FONT_FACE_FLAG_OPENTYPE_VARIATIONS ## OpenType Font Variations feature is available.
    BL_FONT_FACE_FLAG_SYMBOL_FONT ## This is a symbol font.
    BL_FONT_FACE_FLAG_LAST_RESORT_FONT ## This is a last resort font.

  BLFontFaceDiagFlags* {.size: sizeof(uint32).} = enum
    BL_FONT_FACE_DIAG_NO_FLAGS ## No flags.
    BL_FONT_FACE_DIAG_WRONG_NAME_DATA ## Wrong data in 'name' table.
    BL_FONT_FACE_DIAG_FIXED_NAME_DATA ## Fixed data read from 'name' table and possibly fixed font family/subfamily name.
    BL_FONT_FACE_DIAG_WRONG_KERN_DATA ## Wrong data in 'kern' table [kerning disabled].
    BL_FONT_FACE_DIAG_FIXED_KERN_DATA ## Fixed data read from 'kern' table so it can be used.
    BL_FONT_FACE_DIAG_WRONG_CMAP_DATA ## Wrong data in 'cmap' table.
    BL_FONT_FACE_DIAG_WRONG_CMAP_FORMAT ## Wrong format in 'cmap' (sub)table.

  BLFontOutlineType* {.size: sizeof(uint32).} = enum
    BL_FONT_OUTLINE_TYPE_NONE ## None.
    BL_FONT_OUTLINE_TYPE_TRUETYPE ## Truetype outlines.
    BL_FONT_OUTLINE_TYPE_CFF ## OpenType (CFF) outlines.
    BL_FONT_OUTLINE_TYPE_CFF2 ## OpenType (CFF2) outlines with font variations support.
    BL_FONT_OUTLINE_TYPE_MAX_VALUE ## Maximum value of BLFontOutlineType.

  BLGlyphRunFlags* {.size: sizeof(uint32).} = enum
    BL_GLYPH_RUN_NO_FLAGS ## No flags.
    BL_GLYPH_RUN_FLAG_UCS4_CONTENT ## Glyph-run contains UCS-4 string and not glyphs (glyph-buffer only).
    BL_GLYPH_RUN_FLAG_INVALID_TEXT ## Glyph-run was created from text that was not a valid unicode.
    BL_GLYPH_RUN_FLAG_UNDEFINED_GLYPHS ## Not the whole text was mapped to glyphs (contains undefined glyphs).
    BL_GLYPH_RUN_FLAG_INVALID_FONT_DATA ## Encountered invalid font data during text / glyph processing.
  
  BLGlyphPlacementType* {.size: sizeof(uint32).} = enum
    BL_GLYPH_PLACEMENT_TYPE_NONE ## No placement (custom handling by BLPathSinkFunc).
    BL_GLYPH_PLACEMENT_TYPE_ADVANCE_OFFSET ## Each glyph has a BLGlyphPlacement (advance + offset).
    BL_GLYPH_PLACEMENT_TYPE_DESIGN_UNITS ## Each glyph has a BLPoint offset in design-space units.
    BL_GLYPH_PLACEMENT_TYPE_USER_UNITS ## Each glyph has a BLPoint offset in user-space units.
    BL_GLYPH_PLACEMENT_TYPE_ABSOLUTE_UNITS ## Each glyph has a BLPoint offset in absolute units.
    BL_GLYPH_PLACEMENT_TYPE_MAX_VALUE ## Maximum value of BLGlyphPlacementType.

  BLFontCore* {.bycopy.} = object
    d*: BLObjectDetail

  BLFontImpl* {.bycopy.} = object
    face*: BLFontFaceCore
    weight*: uint16
    stretch*: uint8
    style*: uint8
    reserved*: uint32
    metrics*: BLFontMetrics
    matrix*: BLFontMatrix
    featureSettings*: BLFontFeatureSettingsCore
    variationSettings*: BLFontVariationSettingsCore

  BLFontDataCore* {.bycopy.} = object
    d*: BLObjectDetail

  BLFontDataImpl* {.bycopy.} = object
    virt*: ptr BLFontDataVirt
    faceType*: uint8
    faceCount*: uint32
    flags*: uint32

  BLFontDataVirt* {.bycopy.} = object
    base*: BLObjectVirtBase
    getTableTags*: proc (impl: ptr BLFontDataImpl; faceIndex: uint32;
                         `out`: ptr BLArrayCore): BLResult {.cdecl.}
    getTables*: proc (impl: ptr BLFontDataImpl; faceIndex: uint32;
                      dst: ptr BLFontTable; tags: ptr BLTag; n: uint): uint {.
        cdecl.}
  
  BLFontFaceCore* {.bycopy.} = object
    d*: BLObjectDetail

  BLFontManagerCore* {.bycopy.} = object
    d*: BLObjectDetail

  BLFontManagerVirt* {.bycopy.} = object
    base*: BLObjectVirtBase

  BLGlyphId* = uint32

  BLGlyphBufferCore* {.bycopy.} = object
    ## Glyph buffer
    impl*: ptr BLGlyphBufferImpl

  BLGlyphBufferImpl* {.bycopy.} = object
    content*: ptr uint32
    placementData*: ptr BLGlyphPlacement
    size*: uint
    reserved*: uint32
    flags*: uint32
    glyphRun*: BLGlyphRun
    infoData*: ptr BLGlyphInfo

  BLGlyphInfo* {.bycopy.} = object
    cluster*: uint32
    reserved*: uint32

  BLGlyphMappingState* {.bycopy.} = object
    glyphCount*: uint
    undefinedFirst*: uint
    undefinedCount*: uint

  BLGlyphOutlineSinkInfo* {.bycopy.} = object
    ## Information passed to a BLPathSinkFunc sink by BLFont::getGlyphOutlines().
    glyphIndex*: uint
    contourCount*: uint

  BLGlyphPlacement* {.bycopy.} = object
    ## Provides information about glyph offset (x/y) and advance (x/y).
    placement*: BLPointI
    advance*: BLPointI
  
  BLGlyphRun* {.bycopy.} = object
    glyphData*: pointer
    placementData*: pointer
    size*: uint
    reserved*: uint8
    placementType*: uint8
      ## Type of placement, see \ref BLGlyphPlacementType.
    glyphAdvance*: int8
      ## Advance of glyphData array.
    placementAdvance*: int8
      ## Advance of placementData array.
    flags*: uint32
      ## Glyph-run flags.

  BLFontUnicodeCoverage* {.bycopy.} = object
    data*: array[4, uint32]
  
  BLFontFaceInfo* {.bycopy.} = object
    faceType*: uint8
    outlineType*: uint8
      ## Type of outlines used by the font face, see \ref BLFontOutlineType.
    reserved8*: array[2, uint8]
    glyphCount*: uint32
      ## Number of glyphs provided by this font face.
    revision*: uint32
      ## Revision (read from 'head' table, represented as 16.16 fixed point).
    faceIndex*: uint32
      ## Face face index in a TTF/OTF collection or zero if not part of a collection.
    faceFlags*: uint32
      ## Font face flags, see \ref BLFontFaceFlags
    diagFlags*: uint32
      ## Font face diagnostic flags, see \ref BLFontFaceDiagFlags.
    reserved*: array[2, uint32]
      ## Reserved for future use, set to zero.

  BLFontQueryProperties* {.bycopy.} = object
    style*, weight*, stretch*: uint32

  BLFontFeatureItem* {.bycopy.} = object
    tag*: BLTag
    value*: uint32

  BLFontFeatureSettingsCore* {.bycopy.} = object
    d*: BLObjectDetail

  BLFontFeatureSettingsView* {.bycopy.} = object
    data*: ptr BLFontFeatureItem
    size*: uint
    ssoData*: array[36, BLFontFeatureItem]
  
  BLFontDesignMetrics* {.bycopy.} = object
    unitsPerEm*, lowestPPEM*,
      lineGap*, xHeight*, capHeight*, ascent*,
      vAscent*, descent*, vDescent*,
      hMinLSB*, vMinLSB*, hMinTSB*,
      vMinTSB*, hMaxAdvance*, vMaxAdvance*: cint
    ascentByOrientation*, descentByOrientation,
      minLSBByOrientation, minTSBByOrientation,
      maxAdvanceByOrientation*: array[2, cint]
    glyphBoundingBox*: BLBoxI
    underlinePosition*, underlineThickness*,
      strikethroughPosition*, strikethroughThickness*: cint

  BLFontMatrix* {.bycopy.} = object
    m*: array[4, cdouble]
    m00*, m01*, m10*, m11*: cdouble
  
  BLFontMetrics* {.bycopy.} = object ## ```
                                                              ##   ! Scaled BLFontDesignMetrics based on font size and other properties.
                                                              ## ```
    size*: cfloat            ## ```
                             ##   ! Font size.
                             ## ```
    ascent*: cfloat          ## ```
                             ##   ! Font ascent (horizontal orientation).
                             ## ```
    vAscent*: cfloat         ## ```
                             ##   ! Font ascent (vertical orientation).
                             ## ```
    descent*: cfloat         ## ```
                             ##   ! Font descent (horizontal orientation).
                             ## ```
    vDescent*: cfloat        ## ```
                             ##   ! Font descent (vertical orientation).
                             ## ```
    ascentByOrientation*: array[2, cfloat]
    descentByOrientation*: array[2, cfloat]
    lineGap*: cfloat         ## ```
                             ##   ! Line gap.
                             ## ```
    xHeight*: cfloat ## ```
                     ##   ! Distance between the baseline and the mean line of lower-case letters.
                     ## ```
    capHeight*: cfloat ## ```
                       ##   ! Maximum height of a capital letter above the baseline.
                       ## ```
    xMin*: cfloat            ## ```
                             ##   ! Minimum x, reported by the font.
                             ## ```
    yMin*: cfloat            ## ```
                             ##   ! Minimum y, reported by the font.
                             ## ```
    xMax*: cfloat            ## ```
                             ##   ! Maximum x, reported by the font.
                             ## ```
    yMax*: cfloat            ## ```
                             ##   ! Maximum y, reported by the font.
                             ## ```
    underlinePosition*: cfloat ## ```
                               ##   ! Text underline position.
                               ## ```
    underlineThickness*: cfloat ## ```
                                ##   ! Text underline thickness.
                                ## ```
    strikethroughPosition*: cfloat ## ```
                                   ##   ! Text strikethrough position.
                                   ## ```
    strikethroughThickness*: cfloat ## ```
                                    ##   ! Text strikethrough thickness.
                                    ## ```
  BLFontPanose* {.bycopy.} = object ## ```
                                                             ##   ! Font PANOSE classification.
                                                             ## ```
    data*: array[10, uint8]
    familyKind*: uint8
    text*: Type_blend2dh2
    script*: Type_blend2dh3
    decorative*: Type_blend2dh4
    symbol*: Type_blend2dh5
  
  BLFontTable* {.bycopy.} = object
    data*: ptr uint8
    size*: uint

  BLFontVariationItem* {.bycopy.} = object
    tag*: BLTag
      ## Variation tag (32-bit).
    value*: cfloat
      ## Variation value. note values outside of [0, 1] range are invalid.
  
  BLFontVariationSettingsCore* {.bycopy.} = object
    d*: BLObjectDetail

  BLFontVariationSettingsImpl* {.bycopy.} = object
    data*: ptr BLFontVariationItem
    size*, capacity*: uint
  
  BLFontVariationSettingsView* {.bycopy.} = object
    data*: ptr BLFontVariationItem
    size*: uint
    ssoData*: array[3, BLFontVariationItem]

  BLTextMetrics* {.bycopy.} = object
    advance*, leadingBearing*,
      trailingBearing*: BLPoint
    boundingBox*: BLBox

var BL_FONT_FEATURE_INVALID_VALUE*: uint32
{.pop.}

{.push importc, cdecl, header: blend2dHeader.}
#
# BLFont API
#
proc blFontInit*(self: ptr BLFontCore): BLResult
proc blFontInitMove*(self: ptr BLFontCore; other: ptr BLFontCore): BLResult
proc blFontInitWeak*(self: ptr BLFontCore; other: ptr BLFontCore): BLResult
proc blFontDestroy*(self: ptr BLFontCore): BLResult
proc blFontReset*(self: ptr BLFontCore): BLResult
proc blFontAssignMove*(self: ptr BLFontCore; other: ptr BLFontCore): BLResult
proc blFontAssignWeak*(self: ptr BLFontCore; other: ptr BLFontCore): BLResult
proc blFontEquals*(a: ptr BLFontCore; b: ptr BLFontCore): bool
proc blFontCreateFromFace*(self: ptr BLFontCore; face: ptr BLFontFaceCore;
                           size: cfloat): BLResult
proc blFontCreateFromFaceWithSettings*(self: ptr BLFontCore;
                                       face: ptr BLFontFaceCore; size: cfloat;
    featureSettings: ptr BLFontFeatureSettingsCore; variationSettings: ptr BLFontVariationSettingsCore): BLResult
proc blFontGetFace*(self: ptr BLFontCore; `out`: ptr BLFontFaceCore): BLResult
proc blFontGetSize*(self: ptr BLFontCore): cfloat
proc blFontSetSize*(self: ptr BLFontCore; size: cfloat): BLResult
proc blFontGetMetrics*(self: ptr BLFontCore; `out`: ptr BLFontMetrics): BLResult
proc blFontGetMatrix*(self: ptr BLFontCore; `out`: ptr BLFontMatrix): BLResult
proc blFontGetDesignMetrics*(self: ptr BLFontCore;
                             `out`: ptr BLFontDesignMetrics): BLResult
proc blFontGetFeatureSettings*(self: ptr BLFontCore;
                               `out`: ptr BLFontFeatureSettingsCore): BLResult
proc blFontSetFeatureSettings*(self: ptr BLFontCore;
                               featureSettings: ptr BLFontFeatureSettingsCore): BLResult
proc blFontResetFeatureSettings*(self: ptr BLFontCore): BLResult
proc blFontGetVariationSettings*(self: ptr BLFontCore;
                                 `out`: ptr BLFontVariationSettingsCore): BLResult
proc blFontSetVariationSettings*(self: ptr BLFontCore; variationSettings: ptr BLFontVariationSettingsCore): BLResult
proc blFontResetVariationSettings*(self: ptr BLFontCore): BLResult
proc blFontShape*(self: ptr BLFontCore; gb: ptr BLGlyphBufferCore): BLResult
proc blFontMapTextToGlyphs*(self: ptr BLFontCore; gb: ptr BLGlyphBufferCore;
                            stateOut: ptr BLGlyphMappingState): BLResult
proc blFontPositionGlyphs*(self: ptr BLFontCore; gb: ptr BLGlyphBufferCore): BLResult
proc blFontApplyKerning*(self: ptr BLFontCore; gb: ptr BLGlyphBufferCore): BLResult
proc blFontApplyGSub*(self: ptr BLFontCore; gb: ptr BLGlyphBufferCore; lookups: ptr BLBitArrayCore): BLResult
proc blFontApplyGPos*(self: ptr BLFontCore; gb: ptr BLGlyphBufferCore; lookups: ptr BLBitArrayCore): BLResult
proc blFontGetTextMetrics*(self: ptr BLFontCore; gb: ptr BLGlyphBufferCore; `out`: ptr BLTextMetrics): BLResult
proc blFontGetGlyphBounds*(self: ptr BLFontCore; glyphData: ptr uint32;
    glyphAdvance: ptr int; `out`: ptr BLBoxI; count: uint): BLResult

proc blFontGetGlyphAdvances*(self: ptr BLFontCore; glyphData: ptr uint32;
    glyphAdvance: ptr int; `out`: ptr BLGlyphPlacement; count: uint): BLResult

proc blFontGetGlyphOutlines*(self: ptr BLFontCore; glyphId: BLGlyphId;
    userTransform: ptr BLMatrix2D; `out`: ptr BLPathCore;
    sink: BLPathSinkFunc; userData: pointer): BLResult

proc blFontGetGlyphRunOutlines*(self: ptr BLFontCore; glyphRun: ptr BLGlyphRun;
    userTransform: ptr BLMatrix2D; `out`: ptr BLPathCore;
    sink: BLPathSinkFunc; userData: pointer): BLResult

#
# BLFontFeatureSettings API
#
proc blFontFeatureSettingsInit*(self: ptr BLFontFeatureSettingsCore): BLResult
proc blFontFeatureSettingsInitMove*(self: ptr BLFontFeatureSettingsCore;
                                    other: ptr BLFontFeatureSettingsCore): BLResult
proc blFontFeatureSettingsInitWeak*(self: ptr BLFontFeatureSettingsCore;
                                    other: ptr BLFontFeatureSettingsCore): BLResult
proc blFontFeatureSettingsDestroy*(self: ptr BLFontFeatureSettingsCore): BLResult
proc blFontFeatureSettingsReset*(self: ptr BLFontFeatureSettingsCore): BLResult
proc blFontFeatureSettingsClear*(self: ptr BLFontFeatureSettingsCore): BLResult
proc blFontFeatureSettingsShrink*(self: ptr BLFontFeatureSettingsCore): BLResult
proc blFontFeatureSettingsAssignMove*(self: ptr BLFontFeatureSettingsCore;
                                      other: ptr BLFontFeatureSettingsCore): BLResult
proc blFontFeatureSettingsAssignWeak*(self: ptr BLFontFeatureSettingsCore;
                                      other: ptr BLFontFeatureSettingsCore): BLResult
proc blFontFeatureSettingsGetSize*(self: ptr BLFontFeatureSettingsCore): uint
proc blFontFeatureSettingsGetCapacity*(self: ptr BLFontFeatureSettingsCore): uint
proc blFontFeatureSettingsGetView*(self: ptr BLFontFeatureSettingsCore;
                                   `out`: ptr BLFontFeatureSettingsView): BLResult
proc blFontFeatureSettingsHasValue*(self: ptr BLFontFeatureSettingsCore;
                                    featureTag: BLTag): bool
proc blFontFeatureSettingsGetValue*(self: ptr BLFontFeatureSettingsCore;
                                    featureTag: BLTag): uint32
proc blFontFeatureSettingsSetValue*(self: ptr BLFontFeatureSettingsCore;
                                    featureTag: BLTag; value: uint32): BLResult
proc blFontFeatureSettingsRemoveValue*(self: ptr BLFontFeatureSettingsCore;
                                       featureTag: BLTag): BLResult
proc blFontFeatureSettingsEquals*(a: ptr BLFontFeatureSettingsCore;
                                  b: ptr BLFontFeatureSettingsCore): bool

#
# BLFontManager API
#
proc blFontManagerInit*(self: ptr BLFontManagerCore): BLResult
proc blFontManagerInitMove*(self: ptr BLFontManagerCore; other: ptr BLFontManagerCore): BLResult
proc blFontManagerInitWeak*(self: ptr BLFontManagerCore; other: ptr BLFontManagerCore): BLResult
proc blFontManagerInitNew*(self: ptr BLFontManagerCore): BLResult
proc blFontManagerDestroy*(self: ptr BLFontManagerCore): BLResult
proc blFontManagerReset*(self: ptr BLFontManagerCore): BLResult
proc blFontManagerAssignMove*(self: ptr BLFontManagerCore; other: ptr BLFontManagerCore): BLResult
proc blFontManagerAssignWeak*(self: ptr BLFontManagerCore;
                              other: ptr BLFontManagerCore): BLResult
proc blFontManagerCreate*(self: ptr BLFontManagerCore): BLResult
proc blFontManagerGetFaceCount*(self: ptr BLFontManagerCore): uint
proc blFontManagerGetFamilyCount*(self: ptr BLFontManagerCore): uint
proc blFontManagerHasFace*(self: ptr BLFontManagerCore; face: ptr BLFontFaceCore): bool
proc blFontManagerAddFace*(self: ptr BLFontManagerCore; face: ptr BLFontFaceCore): BLResult
proc blFontManagerQueryFace*(self: ptr BLFontManagerCore; name: cstring;
                             nameSize: uint;
                             properties: ptr BLFontQueryProperties;
                             `out`: ptr BLFontFaceCore): BLResult
proc blFontManagerQueryFacesByFamilyName*(self: ptr BLFontManagerCore;
    name: cstring; nameSize: uint; `out`: ptr BLArrayCore): BLResult
proc blFontManagerEquals*(a: ptr BLFontManagerCore; b: ptr BLFontManagerCore): bool


# BLFontVariationSettings API
#
proc blFontVariationSettingsInit*(self: ptr BLFontVariationSettingsCore): BLResult
proc blFontVariationSettingsInitMove*(self: ptr BLFontVariationSettingsCore; other: ptr BLFontVariationSettingsCore): BLResult
proc blFontVariationSettingsInitWeak*(self: ptr BLFontVariationSettingsCore;other: ptr BLFontVariationSettingsCore): BLResult
proc blFontVariationSettingsDestroy*(self: ptr BLFontVariationSettingsCore): BLResult
proc blFontVariationSettingsReset*(self: ptr BLFontVariationSettingsCore): BLResult
proc blFontVariationSettingsClear*(self: ptr BLFontVariationSettingsCore): BLResult
proc blFontVariationSettingsShrink*(self: ptr BLFontVariationSettingsCore): BLResult
proc blFontVariationSettingsAssignMove*(self: ptr BLFontVariationSettingsCore; other: ptr BLFontVariationSettingsCore): BLResult
proc blFontVariationSettingsAssignWeak*(self: ptr BLFontVariationSettingsCore;other: ptr BLFontVariationSettingsCore): BLResult
proc blFontVariationSettingsGetSize*(self: ptr BLFontVariationSettingsCore): uint
proc blFontVariationSettingsGetCapacity*(self: ptr BLFontVariationSettingsCore): uint
proc blFontVariationSettingsGetView*(self: ptr BLFontVariationSettingsCore;`out`: ptr BLFontVariationSettingsView): BLResult
proc blFontVariationSettingsHasValue*(self: ptr BLFontVariationSettingsCore;variationTag: BLTag): bool
proc blFontVariationSettingsGetValue*(self: ptr BLFontVariationSettingsCore;variationTag: BLTag): cfloat
proc blFontVariationSettingsSetValue*(self: ptr BLFontVariationSettingsCore;variationTag: BLTag; value: cfloat): BLResult
proc blFontVariationSettingsRemoveValue*(self: ptr BLFontVariationSettingsCore;variationTag: BLTag): BLResult
proc blFontVariationSettingsEquals*(a: ptr BLFontVariationSettingsCore;b: ptr BLFontVariationSettingsCore): bool

#
# BLFontData API
#
proc blFontDataInit*(self: ptr BLFontDataCore): BLResult
proc blFontDataInitMove*(self: ptr BLFontDataCore; other: ptr BLFontDataCore): BLResult
proc blFontDataInitWeak*(self: ptr BLFontDataCore; other: ptr BLFontDataCore): BLResult
proc blFontDataDestroy*(self: ptr BLFontDataCore): BLResult
proc blFontDataReset*(self: ptr BLFontDataCore): BLResult
proc blFontDataAssignMove*(self: ptr BLFontDataCore; other: ptr BLFontDataCore): BLResult
proc blFontDataAssignWeak*(self: ptr BLFontDataCore; other: ptr BLFontDataCore): BLResult
proc blFontDataCreateFromFile*(self: ptr BLFontDataCore; fileName: cstring; readFlags: BLFileReadFlags): BLResult
proc blFontDataCreateFromDataArray*(self: ptr BLFontDataCore; dataArray: ptr BLArrayCore): BLResult
proc blFontDataCreateFromData*(self: ptr BLFontDataCore; data: pointer;dataSize: uint; destroyFunc: BLDestroyExternalDataFunc; userData: pointer): BLResult
proc blFontDataEquals*(a: ptr BLFontDataCore; b: ptr BLFontDataCore): bool
proc blFontDataGetFaceCount*(self: ptr BLFontDataCore): uint32
proc blFontDataGetFaceType*(self: ptr BLFontDataCore): BLFontFaceType
proc blFontDataGetFlags*(self: ptr BLFontDataCore): BLFontDataFlags
proc blFontDataGetTableTags*(self: ptr BLFontDataCore; faceIndex: uint32;dst: ptr BLArrayCore): BLResult
proc blFontDataGetTables*(self: ptr BLFontDataCore; faceIndex: uint32; dst: ptr BLFontTable; tags: ptr BLTag; count: uint): uint

#
# BLFontFace API
#
proc blFontFaceInit*(self: ptr BLFontFaceCore): BLResult
proc blFontFaceInitMove*(self: ptr BLFontFaceCore; other: ptr BLFontFaceCore): BLResult
proc blFontFaceInitWeak*(self: ptr BLFontFaceCore; other: ptr BLFontFaceCore): BLResult
proc blFontFaceDestroy*(self: ptr BLFontFaceCore): BLResult
proc blFontFaceReset*(self: ptr BLFontFaceCore): BLResult
proc blFontFaceAssignMove*(self: ptr BLFontFaceCore; other: ptr BLFontFaceCore): BLResult
proc blFontFaceAssignWeak*(self: ptr BLFontFaceCore; other: ptr BLFontFaceCore): BLResult
proc blFontFaceEquals*(a: ptr BLFontFaceCore; b: ptr BLFontFaceCore): bool
proc blFontFaceCreateFromFile*(self: ptr BLFontFaceCore; fileName: cstring; readFlags: BLFileReadFlags): BLResult
proc blFontFaceCreateFromData*(self: ptr BLFontFaceCore;fontData: ptr BLFontDataCore; faceIndex: uint32): BLResult
proc blFontFaceGetFullName*(self: ptr BLFontFaceCore; `out`: ptr BLStringCore): BLResult
proc blFontFaceGetFamilyName*(self: ptr BLFontFaceCore; `out`: ptr BLStringCore): BLResult
proc blFontFaceGetSubfamilyName*(self: ptr BLFontFaceCore;`out`: ptr BLStringCore): BLResult
proc blFontFaceGetPostScriptName*(self: ptr BLFontFaceCore;`out`: ptr BLStringCore): BLResult
proc blFontFaceGetFaceInfo*(self: ptr BLFontFaceCore; `out`: ptr BLFontFaceInfo): BLResult
proc blFontFaceGetDesignMetrics*(self: ptr BLFontFaceCore; `out`: ptr BLFontDesignMetrics): BLResult
proc blFontFaceGetUnicodeCoverage*(self: ptr BLFontFaceCore;`out`: ptr BLFontUnicodeCoverage): BLResult
proc blFontFaceGetCharacterCoverage*(self: ptr BLFontFaceCore;`out`: ptr BLBitSetCore): BLResult
proc blFontFaceHasScriptTag*(self: ptr BLFontFaceCore; scriptTag: BLTag): bool
proc blFontFaceHasFeatureTag*(self: ptr BLFontFaceCore; featureTag: BLTag): bool
proc blFontFaceHasVariationTag*(self: ptr BLFontFaceCore; variationTag: BLTag): bool
proc blFontFaceGetScriptTags*(self: ptr BLFontFaceCore; `out`: ptr BLArrayCore): BLResult
proc blFontFaceGetFeatureTags*(self: ptr BLFontFaceCore; `out`: ptr BLArrayCore): BLResult
proc blFontFaceGetVariationTags*(self: ptr BLFontFaceCore;`out`: ptr BLArrayCore): BLResult

#
# BLGlyphBuffer API
#
proc blGlyphBufferInit*(self: ptr BLGlyphBufferCore): BLResult
proc blGlyphBufferInitMove*(self: ptr BLGlyphBufferCore; other: ptr BLGlyphBufferCore): BLResult
proc blGlyphBufferDestroy*(self: ptr BLGlyphBufferCore): BLResult
proc blGlyphBufferReset*(self: ptr BLGlyphBufferCore): BLResult
proc blGlyphBufferClear*(self: ptr BLGlyphBufferCore): BLResult
proc blGlyphBufferGetSize*(self: ptr BLGlyphBufferCore): uint
proc blGlyphBufferGetFlags*(self: ptr BLGlyphBufferCore): uint32
proc blGlyphBufferGetGlyphRun*(self: ptr BLGlyphBufferCore): ptr BLGlyphRun
proc blGlyphBufferGetContent*(self: ptr BLGlyphBufferCore): ptr uint32
proc blGlyphBufferGetInfoData*(self: ptr BLGlyphBufferCore): ptr BLGlyphInfo
proc blGlyphBufferGetPlacementData*(self: ptr BLGlyphBufferCore): ptr BLGlyphPlacement
proc blGlyphBufferSetText*(self: ptr BLGlyphBufferCore; textData: pointer; size: uint; encoding: BLTextEncoding): BLResult
proc blGlyphBufferSetGlyphs*(self: ptr BLGlyphBufferCore; glyphData: ptr uint32; size: uint): BLResult
proc blGlyphBufferSetGlyphsFromStruct*(self: ptr BLGlyphBufferCore; glyphData: pointer; size: uint; glyphIdSize: uint; glyphIdAdvance: ptr int): BLResult
proc blGlyphBufferSetDebugSink*(self: ptr BLGlyphBufferCore; sink: BLDebugMessageSinkFunc; userData: pointer): BLResult
proc blGlyphBufferResetDebugSink*(self: ptr BLGlyphBufferCore): BLResult
{.pop.}
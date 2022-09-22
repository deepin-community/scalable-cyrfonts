#!/usr/bin/awk -f

#insertion sort of A[1..n]
function isort( A, n,    i, j, hold)
{
  for( i = 2 ; i <= n ; i++)
    {
      j = i;
      hold = A[i];
      for(j=i; A[j-1] > hold; j--)
	A[j] = A[j-1];
      A[j] = hold;
    }
}

function defomaencoding(xencoding) {
  if(toupper(xencoding)=="MICROSOFT-CP1251") {
    return "CP1251";
  } else {
    return toupper(xencoding);
  }
}

BEGIN {
  if (cat=="scale-ttf" || cat=="alias-ttf") {
    fontformat="ttf";
  } else if (cat=="scale-cid" || cat=="alias-cid") {
    fontformat="cid";
  } else {
    fontformat="pfb";
  }
  if (cat=="type1") {
    print "category type1";
  } else if (cat=="ttf") {
    print "category truetype";
  } else if (cat=="cid") {
    print "category cid";
  }
  if (pkg=="t1-cyrillic") {
    fontdirectory="/usr/share/fonts/X11/Type1";
  } else if (pkg=="t1-teams") {
    fontdirectory="/usr/share/fonts/X11/Type1";
  } else if (pkg=="t1-oldslavic") {
    fontdirectory="/usr/share/fonts/X11/Type1";
  }
  cyrencodings[1] = "iso8859-5";
  cyrencodings[2] = "microsoft-cp1251";
  cyrencodings[3] = "koi8-r";
  cyrencodings[4] = "koi8-u";
  cyrencodings[5] = "iso10646-1";
}

{
  family=$3;
  if (pkg=="t1-cyrillic" && !(family=="Free_Times" || family=="Free_Helvetian" || family=="Free_Helvetian_Condensed" || family=="Free_Courier" || family=="Free_Avant_Garde" || family=="Free_Paladin" || family=="Free_Schoolbook" || family=="Free_Bookman" || family=="Free_Chancery")) next;
  if (pkg=="t1-teams" && family!="Teams") next;
  if (pkg=="t1-oldslavic" && family!="OldSlavic") next;
  file=$1;
  font=$2;
  full=$4;
  weight=$5;
  foundry=$6;
  xfoundry=foundry;
  gsub("_", " ", xfoundry);
  if (weight=="Book"||weight=="Normal"||weight=="Roman") {
    weight="Medium";
  }
  if (weight=="Demi") {
    weight="Demibold";
  }
  xweight=weight;
  if (xweight=="Light") {
    xweight="Medium";
  }
  if (xweight=="Demibold") {
    xweight="Bold";
  }
  if (xweight=="Medium") {
    texweight="r";
  } else if (xweight=="Bold") {
    texweight="b";
  } else {
    texweight="error";
  }
  if (family=="Free_Courier") {
    generalfamily="Typewriter";
  } else if (family=="Free_Helvetian"||family=="Free_Avant_Garde") {
    generalfamily="SansSerif";
  } else {
    generalfamily="Roman";
  }
  xfamily=family;
  gsub("_", " ", xfamily);
  oldfamily="";
  if (family=="Free_Courier") {
    oldfamily="Courier";
  } else if (family=="Free_Times") {
    oldfamily="Times";
  } else if (family=="Free_Helvetian") {
    oldfamily="Helvetica";
  } else if (family=="Free_Helvetian_Condensed") {
    oldfamily="Helvetica";
  } else if (family=="Free_Avant_Garde") {
    oldfamily="Avant Garde Gothic";
  } else if (family=="Free_Paladin") {
    oldfamily="Palatino";
  } else if (family=="Free_Schoolbook") {
    oldfamily="New Century Schoolbook";
  } else if (family=="Free_Bookman") {
    oldfamily="Bookman";
  } else if (family=="Free_Chancery") {
    oldfamily="Chancery";
  } 
  if (family=="Free_Courier") {
    width="Fixed";
  } else {
    width="Variable";
  }
  if (generalfamily=="SansSerif"||family=="Teams") {
    shape="NoSerif";
  } else {
    shape="Serif";
  }
  if (full ~ /Italic/) {
    shape=shape " Italic";
  } else if (full ~ /Oblique/) {
    shape=shape " Oblique";
  } else {
    shape=shape " Upright";
  }
  if (full ~ /Condensed/) {
    shape=shape " Condensed";
    texwidth="c";
  } else {
    texwidth="";
  }
  numxencodings=split($0,xencoding)-6;
  if (shape ~ /Upright/) {
    xslant="r";
    texslant="";
  } else if (shape ~ /Italic/) {
    xslant="i";
    texslant="i";
  } else if (shape ~ /Oblique/) {
    xslant="o";
    texslant="o";
  } else {
    xslant="error";
    texslant="error";
  }
  if (shape ~ /Condensed/) {
    xwidth="condensed";
  } else {
    xwidth="normal";
  }
  if (width=="Fixed") {
    xspacing="m";
  } else {
    xspacing="p";
  }
  if (family=="Free_Avant_Garde") {
    texname="fag";
  } else if (family=="Free_Bookman") {
    texname="fbk";
  } else if (family=="Free_Schoolbook") {
    texname="fsb";
  } else if (family=="Free_Helvetian") {
    texname="fhv";
  } else if (family=="Free_Helvetian_Condensed") {
    texname="fhv";
  } else if (family=="Free_Times") {
    texname="ftm";
  } else if (family=="Free_Courier") {
    texname="fcr";
  } else if (family=="Free_Paladin") {
    texname="fpl";
  } else if (family=="Teams") {
    texname="fta";
  } else if (family=="Free_Chancery") {
    texname="fzc";
  } else if (family=="OldSlavic") {
    texname="fsj";
  } else {
    texname="error";
  }
  charsets="";
  for(i=1; i<=numxencodings; i++) {
    charsets=charsets " " defomaencoding(xencoding[6+i]);
  }
  if (cat=="type1") {
    printf "begin %s/%s.%s\n", fontdirectory, file, fontformat;
    printf "  FaceNum = %s\n", numxencodings;
    printf "  Inherit = Family GeneralFamily Weight Width Shape Priority\n";
    printf "  FontName = %s\n", font;
    printf "  Charset = ISO10646-1\n";
    printf "  Family = %s\n", family;
    printf "  GeneralFamily = %s\n", generalfamily;
    printf "  Weight = %s\n", weight;
    printf "  Width = %s\n", width;
    printf "  Shape = %s\n", shape;
#      if (texname != "error") {
#	printf "  TeX-Name = %s\n", texname;
#	printf "  TeX-Fontencoding = 6r\n";
    #      }
    printf "  Priority = 20\n";
    printf "  X-FontName = -%s-%s-%s-%s-%s--0-0-0-0-%s-0-%s\n", foundry, family, xweight, xslant, xwidth, xspacing, "iso10646-1";
    for(i=1; i<=numxencodings; i++) {
      printf "\n";
      printf "  Charset%s = %s\n", i, defomaencoding(xencoding[6+i]);
      printf "  X-FontName%s = -%s-%s-%s-%s-%s--0-0-0-0-%s-0-%s\n", i, foundry, family, xweight, xslant, xwidth, xspacing, xencoding[6+i];
    }
    printf "end\n";
  } else if (cat=="ttf") {
    printf "begin %s/%s.ttf\n", fontdirectory, file;
    printf "  FontName = %s\n", font;
    printf "  Charset = %s ISO10646-1\n", charsets;
    printf "  UniCharset = %s\n", charsets;
    printf "  Family = %s\n", family;
    printf "  Encoding = Unicode\n";
    printf "  GeneralFamily = %s\n", generalfamily;
    printf "  Weight = %s\n", weight;
    printf "  Width = %s\n", width;
    printf "  Shape = %s\n", shape;
    printf "  Priority = 18\n"; # Type1 fonts are preferred
    printf "  X-Foundry = %s\n", foundry;
    printf "  X-Weight = %s\n", xweight;
    printf "  X-Slant = %s\n", xslant;
    printf "  X-Width = %s\n", xwidth;
    printf "  X-Spacing = %s\n", xspacing;
    printf "end\n";
  } else if (cat=="cid") {
    printf "begin %s/%s.cid\n", fontdirectory, file;
    printf "  FontName = %s\n", font;
    printf "  CIDRegistry = Debian\n";
    printf "  CIDOrdering = AlphOmeg\n";
    printf "  CIDSupplement = 0\n";
    printf "  Charset = %s ISO10646-1\n", charsets;
    printf "  UniCharset = %s\n", charsets;
    printf "  Family = %s\n", family;
    printf "  GeneralFamily = %s\n", generalfamily;
    printf "  Weight = %s\n", weight;
    printf "  Width = %s\n", width;
    printf "  Shape = %s\n", shape;
    printf "  Priority = 21\n"; # Preferred over Type1 fonts
    printf "  AFM = %s/%s.afm\n", fontdirectory, file;
    printf "  X-Foundry = %s\n", foundry;
    printf "  X-Weight = %s\n", xweight;
    printf "  X-Slant = %s\n", xslant;
    printf "  X-Width = %s\n", xwidth;
    printf "  X-Spacing = %s\n", xspacing;
    printf "end\n";
  } else if (cat=="scale" || cat=="scale-ttf") {
    for(i=1; i<=numxencodings; i++) {
      num_lines=num_lines+1;
      lines[num_lines] = sprintf("%s.%s -%s-%s-%s-%s-%s--0-0-0-0-%s-0-%s", file, fontformat, xfoundry, xfamily, xweight, xslant, xwidth, xspacing, xencoding[6+i]);
    }
    if (cat=="scale" || cat=="scale-ttf") {
      num_lines=num_lines+1;
      lines[num_lines] = sprintf("%s.%s -%s-%s-%s-%s-%s--0-0-0-0-%s-0-%s", file, fontformat, xfoundry, xfamily, xweight, xslant, xwidth, xspacing, "ISO10646-1");
    }
  } else if (cat=="alias" || cat=="alias-ttf") {
    if (oldfamily!="") {
      for(i=1; i<=numxencodings; i++) {
	newfont = sprintf("-%s-%s-%s-%s-%s--0-0-0-0-%s-0-%s", xfoundry, xfamily, xweight, xslant, xwidth, xspacing, xencoding[6+i]);
	oldfont = sprintf("-%s-%s-%s-%s-%s--0-0-0-0-%s-0-%s", xfoundry, oldfamily, xweight, xslant, xwidth, xspacing, xencoding[6+i]);
	num_lines=num_lines+1;
	lines[num_lines] = "! \"" oldfont "\" \"" newfont "\"";
      }
      newfont = sprintf("-%s-%s-%s-%s-%s--0-0-0-0-%s-0-%s", xfoundry, xfamily, xweight, xslant, xwidth, xspacing, "ISO10646-1");
      oldfont = sprintf("-%s-%s-%s-%s-%s--0-0-0-0-%s-0-%s", foundry, oldfamily, xweight, xslant, xwidth, xspacing, "ISO10646-1");
      num_lines=num_lines+1;
      lines[num_lines] = "! \"" oldfont "\" \"" newfont "\"";
    }
    if ((family=="Free_Courier" || family=="Free_Times" || 
	 family=="Free_Helvetian") && xwidth=="normal") {
      for(i in cyrencodings) {
	xenc=cyrencodings[i];
	xlfd_orig = sprintf("\"-%s-%s-%s-%s-%s--0-0-0-0-%s-0-%s\"", xfoundry, xfamily, xweight, xslant, xwidth, xspacing, xenc);
	xlfd_alias1 = sprintf("\"-%s-%s-%s-%s-%s--0-0-0-0-%s-0-%s\"", "RFX", oldfamily, xweight, xslant, xwidth, xspacing, xenc);
	xlfd_alias2 = sprintf("\"-%s-%s-%s-%s-%s--0-0-0-0-%s-0-%s\"", "Cronyx", oldfamily, xweight, xslant, xwidth, xspacing, xenc);
	num_lines=num_lines+1;
	lines[num_lines] = xlfd_alias1 " " xlfd_orig;
	num_lines=num_lines+1;
	lines[num_lines] = xlfd_alias2 " " xlfd_orig;
      }
    }
  } else if (cat=="fontforge") {
    if (texname != "error") {
      print file, font, family, full, weight, texname texweight texslant, texwidth;
    }
  } else if (cat=="texfontmap") {
    if (texname != "error") {
      fontmap[texname texweight texslant "6r" texwidth] = font "CyrTeX \" TeXBaseCyrillic ReEncodeFont \" <6r.enc <" texname texweight texslant "6w" texwidth ".pfb";
      fontmap[texname texweight texslant "8r" texwidth] = font "LatTeX \" TeXBase1Encoding ReEncodeFont \" <8r.enc <" texname texweight texslant "8a" texwidth ".pfb";
      if (texslant=="" && fontmap[texname texweight "o6r" texwidth] == "") {
	fontmap[texname texweight "o6r" texwidth] = font "CyrTeX \" .167 SlantFont TeXBaseCyrillic ReEncodeFont \" <6r.enc <" texname texweight texslant "6w" texwidth ".pfb";
      }
      if (texslant=="" && fontmap[texname texweight "o8r" texwidth] == "") {
	fontmap[texname texweight "o8r" texwidth] = font "LatTeX \" .167 SlantFont TeXBase1Encoding ReEncodeFont \" <8r.enc <" texname texweight texslant "8a" texwidth ".pfb";
      }
    }
  } else if (cat=="fontnames") {
    print file;
  } else if (cat=="test") {
    print xweight, xslant;
  }
}

END {
  if (cat=="scale" || cat=="scale-ttf") {
    print num_lines;
    for(i=1; i<=num_lines; i++) {
      print lines[i];
    }
  } else if (cat=="alias" || cat=="alias-ttf") {
    isort(lines, numlines);
    for(i=1; i<=num_lines; i++) {
      print lines[i];
    }
  } else if (cat=="texfontmap") {
    for(i in fontmap) {
      print i, fontmap[i];
    }
  }
}

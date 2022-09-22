#    Copyright (C) 2001,2002,2003 Anton Kirilov Zinoviev

#    This program is free software; you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation; either version 2 of the License, or
#    (at your option) any later version.

#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.

#    You should have received a copy of the GNU General Public License
#    along with this program; if not, write to the Free Software
#    Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA

#    My e-mail is zinoviev@debian.org

# We need to overwrite the standard texmf.cnf in order to
# generate hugelatex.fmt
TEXMFCNF=.
export TEXMFCNF

SHELL = /bin/sh

GSFONTS = /usr/share/fonts/type1/gsfonts

# FONTINST_VERSION = $(shell dpkg --status tetex-bin|grep ^Version: \
# 			| sed 's/.* //')

# NEW_FONTINST = $(shell dpkg --compare-versions 3.0 gt $(FONTINST_VERSION) \
# 			|| echo yes)

NEW_FONTINST = yes

#CYRFINST = /usr/share/texmf/source/latex/t2/cyrfinst

NEW_CYRFINST = ../t2/cyrfinst
OLD_CYRFINST = ../t2-991215/cyrfinst
CYRFINST = $(if $(NEW_FONTINST), $(NEW_CYRFINST), $(OLD_CYRFINST))

TEXMF.CNF = /usr/share/texlive/texmf-dist/web2c/texmf.cnf

TEXFACES = ftm fhv fcr fag fbk fsb fpl fta fsj fzc
TEXENCS = OT1 OT2 T1 TS1 T2A T2B T2C

#################################################################

all: plvplfd tfmvf

cyrfinstfiles = $(wildcard \
		$(CYRFINST)/*.etx \
		$(CYRFINST)/derivatives/*.etx \
		$(CYRFINST)/cyrillic.mtx \
		$(CYRFINST)/etc/fnstcorr.tex \
		$(CYRFINST)/etc/cyralias.tex \
		)

finst_myfiles = $(notdir $(cyrfinstfiles))

$(finst_myfiles): $(cyrfinstfiles)
	cp $(cyrfinstfiles) .
# If we use the original 6r.etx we have to distribute the corresponding
# 6r.enc.  Its copiright however is not specified.
	cp ../6r.etx . 

cyrfontinst: $(finst_myfiles)

copyafms:
	cp $(GSFONTS)/s050000l.afm psyr.afm
	for j in ../texfonts/*.afm; do \
		../shortenafm $$j >`basename $$j`; \
	done
	touch copyafms

copyall: $(finst_myfiles) copyafms
	touch copyall

face_mtx_tex = $(TEXFACES:%=%-mtx.tex)

$(face_mtx_tex) : face = $(@:%-mtx.tex=%)
$(face_mtx_tex) : makemtx.perl
	perl makemtx.perl $(face) 8a 6w >$@

latex_mtx: texmf.cnf copyall $(face_mtx_tex)
	set -e && for i in $(face_mtx_tex); do\
		latex $$i; \
	done
	touch latex_mtx

texmf.cnf: 99cyrfonts-build.cnf
	cp $(TEXMF.CNF) .
	cat 99cyrfonts-build.cnf >> texmf.cnf

hugelatex.fmt: texmf.cnf 
	luatex --ini '\input hugelatex.ini \dump'

face_enc_tex = $(foreach enc, $(TEXENCS), $(addsuffix -$(enc).tex, $(TEXFACES)))
$(face_enc_tex) : face_enc = $(subst -,/,$(@:%.tex=%))
$(face_enc_tex) : face = $(subst /,,$(dir $(face_enc)))
$(face_enc_tex) : enc = $(notdir $(face_enc))
$(face_enc_tex): makefonts.perl latex_mtx
	perl makefonts.perl $(face) $(enc) >$@

latex_fonts: copyall latex_mtx hugelatex.fmt $(face_enc_tex)
	set -e && for i in $(face_enc_tex); do\
		luatex \&hugelatex $$i; \
	done
	touch latex_fonts

plvplfd: latex_fonts
	touch plvplfd

tfmvf:	plvplfd
	-rm psy*.pl psy*.vpl psy*.tfm psy*.vf
	for f in *.vpl; do vptovf $$f; done
	for f in *.pl; do pltotf $$f; done
	touch tfmvf

.PHONY: clean
clean:
	-rm -f latex_mtx latex_fonts copyafms tfmvf copyall plvplfd
	-rm -f $(finst_myfiles)
	-rm -f makefonts.tex cyrfonts.map
	-rm -f $(face_enc_tex) $(face_mtx_tex)
	-rm -f *.etx *.mtx fnstcorr.tex cyralias.tex
	-rm -f *.afm *.pl *.tfm *.mtx *.fd *.vpl *.vf *.log
	-rm -f *~
	-rm -f hugelatex.fmt hugelatex.log hugelatex.aux texsys.aux
	-rm texmf.cnf

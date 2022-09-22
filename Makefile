#    Copyright (C) 2000,2001,2003 Anton Kirilov Zinoviev

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


SHELL = /bin/bash

all:	build

unpack:
	-mkdir fonts
	-mkdir teams
	tar zxf teams-1.1.tar.gz -C teams
	cp teams/teams/Teams/*.{pfa,afm} fonts
	-mkdir urw
	tar jxf urw-fonts-1.0.7pre40-src.tar.bz2 -C urw
	cat fontnames | while read a b; do mv -v $$a $$b; done
	-mkdir oldslavic
	tar jxf oldslavic.tar.bz2 -C oldslavic
	cp oldslavic/*.{afm,pfb} fonts
	touch unpack

convert: unpack
	-mkdir texfonts
	./convert_fonts
	touch convert

t1-cyrillic-fonts.alias:	hint.awk hintinfo
	awk -f hint.awk -v cat=alias -v pkg=t1-cyrillic <hintinfo >$@

t1-teams-fonts.alias:	hint.awk hintinfo
	awk -f hint.awk -v cat=alias -v pkg=t1-teams <hintinfo >$@

t1-oldslavic-fonts.alias:	hint.awk hintinfo
	awk -f hint.awk -v cat=alias -v pkg=t1-oldslavic <hintinfo >$@

t1-cyrillic-fonts.scale:	hint.awk hintinfo
	awk -f hint.awk -v cat=scale -v pkg=t1-cyrillic <hintinfo >$@

t1-teams-fonts.scale:	hint.awk hintinfo
	awk -f hint.awk -v cat=scale -v pkg=t1-teams <hintinfo >$@

t1-oldslavic-fonts.scale:	hint.awk hintinfo
	awk -f hint.awk -v cat=scale -v pkg=t1-oldslavic <hintinfo >$@

fonts.alias: t1-cyrillic-fonts.alias t1-teams-fonts.alias t1-oldslavic-fonts.alias 

fonts.scale: t1-cyrillic-fonts.scale t1-teams-fonts.scale t1-oldslavic-fonts.scale 

build:	convert fonts.alias fonts.scale scalable-cyrfonts-tex.map
	cd fontinst && $(MAKE) all
	touch build

scalable-cyrfonts-tex.map:	hint.awk hintinfo
	awk -f hint.awk -v cat=texfontmap <hintinfo | sort >scalable-cyrfonts-tex.map

clean:
	-rm -f unpack convert makeafm1 makeafm2 makeafm makeraw1 makeraw2 makeraw3 makepfa makepfb build
	-rm -rf *~
	-rm -rf teams urw oldslavic fonts
	-rm -rf RAW Teams URW afm1 raw1 raw3 afm2 raw2 afm pfa pfb doc
	-rm -f *fonts.alias *fonts.scale Fontmap scalable-cyrfonts-tex.map
	-rm -rf fontinst/*.pfb fontinst/*.pfa
	-cd fontinst && $(MAKE) clean
	-rm -rf texfonts/ cidfonts/

checkroot:
	test root = "`whoami`"

.PHONY:	clean checkroot

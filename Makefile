
clean:
	rm -f *~
	rm -f .*~
	rm -f */*~
	rm -f */.*~

# knit the vignettes
vignettes/%.md:vignettes/%.Rmd
	cd vignettes;R -e 'library(knitr);knit("$(<F)")';cd ..

# slides
tex/profile_press.pdf: tex/profile_press.Rnw
	cd tex;	R CMD Sweave profile_press.Rnw;	pdflatex profile_press.tex;pdflatex profile_press.tex;pdflatex profile_press.tex;cd ..

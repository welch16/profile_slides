
clean:
	rm -f *~
	rm -f .*~
	rm -f */*~
	rm -f */.*~

# slides
tex/profile_press.pdf: tex/profile_press.Rnw
	cd tex;	R -e "library(knitr);knit('profile_press.Rnw')";pdflatex profile_press.tex;pdflatex profile_press.tex;pdflatex profile_press.tex;cd ..

# profileMatrices
data/generated/matrices.RData: 
	cd rscripts; R CMD BATCH profile_code.R; cd ..

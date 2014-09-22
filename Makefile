
clean:
	rm -f *~
	rm -f .*~
	rm -f */*~
	rm -f */.*~
	rm -f rscripts/.R*	

# slides
tex/profile_press.pdf: tex/profile_press.Rnw
	cd tex;	R -e "library(knitr);knit('profile_press.Rnw')";pdflatex profile_press.tex;pdflatex profile_press.tex;pdflatex profile_press.tex;cd ..

# profileMatrices
data/generated/matrices.RData: 
	cd rscripts; R CMD BATCH profile_code.R; cd ..

# example1
profiles:
	cd rscripts; R CMD BATCH example1.R;cd ..

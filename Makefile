R_OPTS=--no-save --no-restore --no-init-file --no-site-file # --vanilla, but without --no-environ

STEM = magic2019

FIGS = Figs/rqtl_lines_code.pdf \
	   Figs/phefile.pdf \
	   Figs/geno_reconstruct.pdf

docs/$(STEM).pdf: $(STEM).pdf
	cp $< $@

$(STEM).pdf: $(STEM).tex header.tex $(FIGS)
	xelatex $<

web: $(STEM).pdf
	scp $(STEM).pdf adhara.biostat.wisc.edu:Website/presentations/$(STEM).pdf

Figs/rqtl_lines_code.pdf: R/colors.R Data/lines_code_by_version.csv R/rqtl_lines_code.R
	cd R;R CMD BATCH rqtl_lines_code.R

Figs/phefile.pdf: R/data_files_fig.R
	cd $(<D);R CMD BATCH $(<F)

Figs/geno_reconstruct.pdf: R/geno_reconstruct_fig.R
	cd $(<D);R CMD BATCH $(<F)

Data/lines_code_by_version.csv: Perl/grab_lines_code.pl Data/versions.txt
	cd Perl;grab_lines_code.pl

Figs/magic19_scan.pdf: R/magic19_figs.R R/colors.R
	cd $(<D);R $(R_OPTS) -e "source('$(<F)')"

ALL := output.dot output.png

all: report.html vowels_consonants_report.html output.png

output.png: output.dot
	dot -Tpng < $< > $@
	
output.dot: Makefile makefile2dot.py
	./makefile2dot.py < $< >$@

clean:
	rm -f words.txt histogram.tsv histogram.png report.md report.html words_vowels.tsv words_vowels.png words_consonants.tsv words_consonants.png vowels_cosonants_report.md vowels_cosonants_report.html output.dot output.png

report.html: report.rmd histogram.tsv histogram.png
	Rscript -e 'rmarkdown::render("$<")'

histogram.png: histogram.tsv
	Rscript -e 'library(ggplot2); qplot(Length, Freq, data=read.delim("$<")); ggsave("$@")'
	rm Rplots.pdf

histogram.tsv: histogram.r words.txt
	Rscript $<

words.txt: /usr/share/dict/words
	cp $< $@

# words.txt:
#	Rscript -e 'download.file("http://svnweb.freebsd.org/base/head/share/dict/web2?view=co", destfile = "words.txt", quiet = TRUE)'

vowels_consonants_report.html: vowels_consonants_report.rmd words_vowels.tsv words_vowels.png words_consonants.tsv words_consonants.png
	Rscript -e 'rmarkdown::render("$<")'

words_vowels.png: words_vowels.tsv
	Rscript -e 'library(ggplot2); qplot(vowels, Freq, data=read.delim("$<")); ggsave("$@")'
	rm Rplots.pdf
	
words_vowels.tsv: words_vowel_consonants.r words.txt
	Rscript $<
	
words_consonants.png: words_consonants.tsv
	Rscript -e 'library(ggplot2); qplot(consonants, Freq, data=read.delim("$<")); ggsave("$@")'
	rm Rplots.pdf
	
words_consonants.tsv: words_vowel_consonants.r words.txt
	Rscript $<
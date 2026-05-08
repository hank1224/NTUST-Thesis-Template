$pdf_mode = 5;
@default_files = ('thesis.tex');
$out_dir = 'build';
$aux_dir = 'build';
$jobname = 'thesis';

$xelatex = 'xelatex -synctex=1 -interaction=nonstopmode -halt-on-error -file-line-error %O %S';
$biber = 'biber %O %B';
$bibtex_use = 2;

$silent = 0;

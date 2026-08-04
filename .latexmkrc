$pdf_mode = 4;

$lualatex = "lualatex -synctex=1 -interaction=nonstopmode -halt-on-error -file-line-error %O %S";
$biber = "biber %O %B";
$bibtex_use = 2;

$silent = 0;

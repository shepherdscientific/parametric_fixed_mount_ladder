#!/bin/bash
outfile=${PWD##*/}.pdf
rm $outfile
pdfunite $(ls -v *.pdf) $outfile


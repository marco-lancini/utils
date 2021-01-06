# Latex

Docker image for compiling Latex documents.


## Usage
```bash
$ docker run --rm -v $(pwd):/src                \
            ghcr.io/marco-lancini/latex:latest  \
            <pdflatex|xelatex>
            --halt-on-error                     \
            -output-directory=build             \
            file.tex
```

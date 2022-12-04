FROM pandoc/latex:2.19.2

LABEL org.opencontainers.image.source = "https://github.com/marco-lancini/utils"

# Install Latex packages
RUN tlmgr install adjustbox awesomebox babel-german background bidi collectbox csquotes everypage filehook fontawesome5 footmisc footnotebackref framed fvextra koma-script letltxmacro ly1 mdframed mweights needspace pagecolor pdfpages sourcecodepro sourcesanspro titlesec titling ucharcat ulem unicode-math upquote xecjk xurl zref

# Create low-privileged user
RUN addgroup --gid 11111 -S app
RUN adduser -s /bin/false -u 11111 -G app -S app

WORKDIR /src
RUN chown -R app:app /src
USER app

# Command
CMD [ "pandoc" ]

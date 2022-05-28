FROM pandoc/latex:2.18.0

# Install Latex packages
RUN tlmgr install adjustbox babel-german background bidi collectbox csquotes everypage filehook footmisc footnotebackref framed fvextra letltxmacro ly1 mdframed mweights needspace pagecolor sourcecodepro sourcesanspro titling ucharcat ulem unicode-math upquote xecjk xurl zref koma-script

# Create low-privileged user
RUN addgroup --gid 11111 -S app
RUN adduser -s /bin/false -u 11111 -G app -S app

WORKDIR /src
RUN chown -R app:app /src
USER app

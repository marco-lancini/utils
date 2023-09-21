FROM pandoc/extra:3.1.1

LABEL org.opencontainers.image.source = "https://github.com/marco-lancini/utils"

# Install Latex packages
COPY docker/pandoc/packages.txt /packages.txt
RUN sed -e 's/ *#.*$//' -e '/^ *$/d' /packages.txt |    \
     xargs tlmgr install                                \
     && rm -f /packages.txt

# Install extra requirements
COPY docker/pandoc/requirements.txt /requirements.txt
RUN pip3 install --no-cache-dir -r /requirements.txt    \
    && rm -f /requirements.txt

# Install custom filters
COPY docker/pandoc/filters/* /root/.pandoc/filters/

# Set working directory
WORKDIR /data

# Command
CMD [ "pandoc" ]

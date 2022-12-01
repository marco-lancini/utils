FROM debian:11.5

LABEL org.opencontainers.image.source = "https://github.com/marco-lancini/utils"

# Install packages
RUN apt update &&                   \
    apt install -y                  \
    wget                            \
    texlive                         \
    texlive-xetex                   \
    texlive-latex-recommended       \
    texlive-latex-extra             \
    texlive-fonts-extra             \
    && rm -rf /var/lib/apt/lists/*

# Install the roboto font
WORKDIR /root
RUN wget http://mirror.ctan.org/install/fonts/roboto.tds.zip

WORKDIR /root/texmf
RUN unzip /root/roboto.tds.zip && \
    texhash && \
    updmap-sys --enable Map=roboto.map

# Create low-privilege user
RUN addgroup --gid 11111 app
RUN adduser --shell /bin/false --uid 11111 --gid 11111 --disabled-login app
RUN chown -R app:app /src
USER app

# Define workdir
WORKDIR /src

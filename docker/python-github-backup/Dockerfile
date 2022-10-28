FROM python:3.9.5-slim-buster

LABEL org.opencontainers.image.source = "https://github.com/marco-lancini/utils"

RUN addgroup --gid 11111 app
RUN adduser --shell /bin/false --no-create-home --uid 11111 --gid 11111 app

RUN apt-get update \
  && apt-get install -y --no-install-recommends git \
  && apt-get purge -y --auto-remove \
  && rm -rf /var/lib/apt/lists/*

WORKDIR /src
COPY docker/python-github-backup/python-github-backup /src
RUN pip install -e .

RUN chown -R app:app /src
USER app

ENTRYPOINT ["github-backup"]

FROM ruby:2.6.4-alpine3.9

RUN apk add --no-cache git

COPY docker/github-changelog-generator/Gemfile Gemfile
RUN gem install bundler --version $(cat Gemfile | grep bundler | awk -F "'" '{print $4}') \
  && bundle install --system \
  && gem uninstall bundler

ENV SRC_PATH /src
RUN mkdir -p $SRC_PATH
VOLUME [ "$SRC_PATH" ]
WORKDIR $SRC_PATH

RUN addgroup --gid 11111 -S app
RUN adduser -s /bin/false -u 11111 -G app -S app
RUN chown -R app:app /src
USER app

CMD ["--help"]
ENTRYPOINT ["github_changelog_generator"]

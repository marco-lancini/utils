FROM ruby:3.0.0-alpine3.13

LABEL org.opencontainers.image.source = "https://github.com/marco-lancini/utils"

# Create user
RUN addgroup --gid 11111 -S app
RUN adduser -s /bin/false -u 11111 -G app -S app

# Setup workdir
RUN mkdir -p /src
WORKDIR /src
RUN chown -R app:app /src

# Install dependencies
RUN apk add --no-cache git

# Install Gems
COPY docker/github-changelog-generator/Gemfile Gemfile
RUN bundle install

# Run app
USER app
CMD ["--help"]
ENTRYPOINT ["github_changelog_generator"]

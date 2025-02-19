# Dockerfile

FROM ruby:3.4.1

WORKDIR /app

RUN apt-get update -qq && \
    apt-get install -y nodejs npm postgresql-client

COPY Gemfile Gemfile.lock ./

RUN bundle install

COPY . .

RUN npm install

RUN chmod +x ./entrypoint.sh

ENTRYPOINT ["./entrypoint.sh"]

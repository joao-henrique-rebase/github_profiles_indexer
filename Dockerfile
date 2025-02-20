FROM ruby:3.4.1

WORKDIR /app

# 1. Instala pacotes essenciais (incluindo o Firefox ESR)
RUN apt-get update -qq && \
    apt-get install -y nodejs npm postgresql-client firefox-esr wget

# 2. Instala o Geckodriver manualmente a partir do GitHub
#    Determina a versão mais recente, baixa e extrai para /usr/local/bin
RUN GECKODRIVER_VERSION="$(curl --silent https://api.github.com/repos/mozilla/geckodriver/releases/latest \
      | grep '"tag_name":' \
      | sed -E 's/.*"([^"]+)".*/\1/')" && \
    wget -qO /tmp/geckodriver.tar.gz "https://github.com/mozilla/geckodriver/releases/download/$GECKODRIVER_VERSION/geckodriver-$GECKODRIVER_VERSION-linux64.tar.gz" && \
    tar -xzf /tmp/geckodriver.tar.gz -C /usr/local/bin && \
    chmod +x /usr/local/bin/geckodriver && \
    rm -f /tmp/geckodriver.tar.gz

COPY Gemfile Gemfile.lock ./
RUN bundle install

COPY . .

RUN npm install

RUN chmod +x ./entrypoint.sh

ENTRYPOINT ["./entrypoint.sh"]

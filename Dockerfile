FROM ruby:2.5
RUN apt-get update -qq
RUN apt-get install -y g++ qt5-default libqt5webkit5-dev gstreamer1.0-plugins-base gstreamer1.0-tools gstreamer1.0-x
RUN curl -sL https://deb.nodesource.com/setup_10.x | bash -
RUN apt-get install -y nodejs postgresql

RUN mkdir /bottlenose
COPY Gemfile Gemfile.lock package.json package-lock.json /bottlenose/
WORKDIR /bottlenose

RUN bundle install
RUN npm install

RUN echo "local all all trust" | tee /etc/postgresql/9.6/main/pg_hba.conf
RUN /etc/init.d/postgresql start && su - postgres -c "createuser -d bottlenose"

CMD /etc/init.d/postgresql start && bundle exec rails db:create && bundle exec rails db:migrate && rm -f /bottlenose/tmp/pids/server.pid && bundle exec rails s -p 3000 -b '0.0.0.0'

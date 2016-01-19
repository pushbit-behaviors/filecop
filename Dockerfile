FROM pushbit/rvm

MAINTAINER Tom Moor "tom.moor@gmail.com"

RUN /bin/bash -l -c "gem install filecop"
RUN /bin/bash -l -c "gem install faraday"

ADD ./execute.sh ./execute.sh
ADD ./execute.rb ./execute.rb

CMD /bin/bash -l -c "./execute.sh"

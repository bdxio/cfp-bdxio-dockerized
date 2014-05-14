FROM dockerfile/java

WORKDIR     /tmp
RUN         wget https://download.elasticsearch.org/elasticsearch/elasticsearch/elasticsearch-1.1.0.tar.gz
RUN         tar xvzf elasticsearch-1.1.0.tar.gz
RUN         rm -f elasticsearch-1.1.0.tar.gz
RUN         mv /tmp/elasticsearch-1.1.0 /elasticsearch
RUN         mkdir -p /usr/local/var/db/elasticsearch/data /var/log/elasticsearch/ /etc/elasticsearch/
ADD         ./elasticsearch.yml /etc/elasticsearch/elasticsearch.yml
WORKDIR     /usr/local/var/db/elasticsearch/data
ENV         PATH /elasticsearch/bin:$PATH
EXPOSE      9200
EXPOSE      9300
CMD         ["elasticsearch", "-Des.config=/etc/elasticsearch/elasticsearch.yml"]

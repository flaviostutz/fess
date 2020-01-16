FROM codelibs/fess:13.5.0

ENV NODE_NAME ''

ADD dictionary/* /var/lib/elasticsearch/config
RUN chown -R elasticsearch:elasticsearch /var/lib/elasticsearch/config

ADD startup.sh /

ENTRYPOINT /startup.sh

FROM codelibs/fess-elasticsearch:7.5.1 AS ES

FROM codelibs/fess:13.5.0
COPY --from=ES /usr/share/elasticsearch/config/dictionary /var/lib/elasticsearch/config

ADD startup.sh /

ENTRYPOINT /startup.sh

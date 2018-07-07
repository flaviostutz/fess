# fess
FESS Docker Container. See more at https://github.com/codelibs/fess
Demo at https://search.n2sm.co.jp

# Usage
docker-compose.yml

```
version: '3'
services:
  fess:
    image: codelibs/fess:12.1
    ports:
      - "8080:8080"
    environment:
      - ES_HTTP_URL=http://elasticsearch:9200
      - ES_TRANSPORT_URL=elasticsearch:9300
      - FESS_DICTIONARY_PATH=/var/lib/elasticsearch/config/

  elasticsearch:
    image: elasticsearch:5.6
    ports:
      - "9200:9200"
    volumes:
      - elasticsearch:/usr/share/elasticsearch/data

volumes:
  elasticsearch:
```

Try it at http://localhost:8080

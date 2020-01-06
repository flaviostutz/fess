# FESS docker-compose
FESS Docker Container. See more at https://github.com/codelibs/fess

Demo at https://search.n2sm.co.jp

For more advanced FESS usage (Elasticsearch clustering etc), visit https://github.com/codelibs/docker-fess/blob/master/compose/docker-compose.yml

# Requirements

* On Ubuntu run `sysctl -w vm.max_map_count=262144`. This is required by Elasticsearch.
  * For more information, refer to https://www.elastic.co/guide/en/elasticsearch/reference/current/vm-max-map-count.html

* For Elasticsearch containers, it's optimal to use ENVIRONMENT `bootstrap.memory_lock=true` for better ram usage, but this requires a change to /etc/security/limits.conf. See https://stackoverflow.com/questions/45008355/elasticsearch-process-memory-locking-failed

# Usage

### Bring up FESS service
docker-compose.yml

```
version: '3'
services:
  fess:
    image: codelibs/fess:12.1
    ports:
      - "8080:8080"
    volumes:
      - elasticsearch:/var/lib/elasticsearch

volumes:
  elasticsearch:
```

### Login to admin panel
http://localhost:8080
User: admin
Password: admin

### Configure a Web Crawler
The crawler configuration needs a Regex for matching URLs. Special attention to the fact that the match must be a full match, so any chars before or after the part you want to match must be included in the match.

Example 1: 
  * This will navigate and index all pages inside www.stf.jus.br/portal/jurisprudencia/
  * URLs: http://www.stf.jus.br/portal/jurisprudencia/listarResultadoPesquisaJurisprudenciaFavoritaRamos.asp
  * Included URLs For Crawling: .\*www.stf.jus.br/portal/jurisprudencia/.*
  * Included URLs For Indexing: .\*www.stf.jus.br/portal/jurisprudencia/.*

Example 2: 
  * This will start indexing all web pages (from any sites) found starting from http://br.yahoo.com
  * URLs: http://br.yahoo.com
  * Included URLs For Crawling: .\*
  * Included URLs For Indexing: .\*

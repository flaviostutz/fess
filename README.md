# FESS docker-compose
FESS Docker Container with advanced clustering configurations.

Demo at https://search.n2sm.co.jp

See more at:

* FESS usage (Elasticsearch clustering etc): https://github.com/codelibs/docker-fess/blob/master/compose/docker-compose.yml

* Source code: https://github.com/codelibs/fess


# Requirements

* On Ubuntu run `sysctl -w vm.max_map_count=262144`. This is required by Elasticsearch.
  * For more information, refer to https://www.elastic.co/guide/en/elasticsearch/reference/current/vm-max-map-count.html

* For Elasticsearch containers, it's optimal to use ENVIRONMENT `bootstrap.memory_lock=true` for better ram usage, but this requires a change to /etc/security/limits.conf. See https://stackoverflow.com/questions/45008355/elasticsearch-process-memory-locking-failed


# Usage

### Bring up FESS service
docker-compose.yml

```
version: "3"
services:
  fess01:
    image: flaviostutz/fess
    ports:
      - 8080:8080
    environment:
      - "ES_HTTP_URL=http://es01:9200"

  es01:
    image: flaviostutz/fess-elasticsearch
    environment:
      - node.name=es01
      - cluster.initial_master_nodes=es01
      - cluster.name=fess-es
      - bootstrap.memory_lock=false
    ports:
      - 9200:9200

  kibana:
    image: docker.elastic.co/kibana/kibana:7.5.1
    environment:
      - "ELASTICSEARCH_HOSTS=http://es01:9200"
    ports:
      - 5601:5601
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
  * Excluded URLs For Crawling: (?i).*\.(css|js|jpeg|jpg|gif|png|bmp|wmv|exe|mp4|json)
  * Excluded URLs For Indexing: (?i).*\.(css|js|jpeg|jpg|gif|png|bmp|wmv|exe|mp4|json)
  
Example 2: 
  * This will start indexing all web pages (from any sites) found starting from http://br.yahoo.com
  * URLs: http://br.yahoo.com
  * Included URLs For Crawling: .\*
  * Included URLs For Indexing: .\*
  * Excluded URLs For Crawling: (?i).*\.(css|js|jpeg|jpg|gif|png|bmp|wmv|exe|mp4|json)
  * Excluded URLs For Indexing: (?i).*\.(css|js|jpeg|jpg|gif|png|bmp|wmv|exe|mp4|json)

# ENVs configurations

* ES_HTTP_URL - Full URL for Elasticsearch http API. ex.: http://es01:9200
* NODE_NAME - FESS 'scheduler.target.name' configuration. Can be used as 'target name' in schedulers so that only a specific node in a FESS cluster will run a job. See https://fess.codelibs.org/11.0/admin/scheduler-guide.html#target and https://github.com/codelibs/fess/issues/553 for more info.


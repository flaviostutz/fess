# FESS docker-compose

[<img src="https://img.shields.io/docker/automated/flaviostutz/fess"/>](https://hub.docker.com/r/flaviostutz/fess)

FESS Docker Container with advanced clustering configurations.

FESS is an advanced search engine. Demo at https://search.n2sm.co.jp

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

# More advanced cluster example

In this example, we will have:

* a three-nodes Elasticsearch cluster 
* 4 instances of FESS dedicated to handle user searches
* 2 worker nodes that will handle scheduled jobs (indexing, crawling etc).
  * fess-worker1 has NODE_NAME=fess-worker1
  * fess-worker2 has NODE_NAME=fess-worker2
  * Change the "Target" of the jobs in FESS admin to "fess-worker1" or "fess-worker2" to distribute workload among instances
  * Don't let any job running on "all" targets to avoid using unecessary resources in fess-api nodes (the nodes that will handle user queries)
* As FESS doesn't not perform a cluster coordination, the initial instantiation must be standalone to avoid concurrence in initial indexes creation

* Get docker-compose file at http://github.com/flaviostutz/fess/docker-compose-cluster.yml

* Run 
```
#Warm up Elasticsearch cluster first (starting all at the same time throws errors - investigate later)
docker-compose -f docker-compose-cluster.yml up es01 es02 es03

#Start FESS (will create initial indexes)
docker-compose -f docker-compose-cluster.yml up fess-api

#Scale FESS api containers to handle more users
docker-compose -f docker-compose-cluster.yml up --scale fess-api=4 fess-api fess-worker1 fess-worker2
```

After configuring Crawler and assigning it to a scheduler that runs on worker2, something like this will show up:

![docker stats](/screen1.png?raw=true "docker stats")

Observe that only worker2 and Elasticsearch instances are using considerable CPU. All other FESS instances are free to handle user queries (maybe you would need more Elasticsearch instances in a real production deployment).

# More information


* Oficial FESS usage (Elasticsearch clustering etc): https://github.com/codelibs/docker-fess/blob/master/compose/docker-compose.yml

* Source code: https://github.com/codelibs/fess

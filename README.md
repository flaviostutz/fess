# FESS docker-compose
FESS Docker Container. See more at https://github.com/codelibs/fess

Demo at https://search.n2sm.co.jp

# Before bringing the Container up

On Ubuntu we had to set the `vm.max_map_count` setting to 262144. Run `sysctl -w vm.max_map_count=262144`.

For more information, refer to https://www.elastic.co/guide/en/elasticsearch/reference/current/vm-max-map-count.html

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
Example: 
  * URLs: http://www.stf.jus.br/portal/jurisprudencia/listarResultadoPesquisaJurisprudenciaFavoritaRamos.asp
  * Included URLs For Crawling: .\*www.stf.jus.br/portal/jurisprudencia/.*
  * Included URLs For Indexing: .\*www.stf.jus.br/portal/jurisprudencia/.*
  * This will navigate and index all pages inside www.stf.jus.br/portal/jurisprudencia/

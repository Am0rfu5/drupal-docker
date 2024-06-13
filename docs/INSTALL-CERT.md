# Install on prod/dev with new certificate

Put Digital Oceans API key in config/digitalocean/digitalocean.ini

Run the docker-compose-certbot.yml to retrieve new certificate
```
docker-compose -f docker-compose-certbot.yml up -d
```

Modify the command for your needs and run it to retrieve new cert.

```
docker exec -it certbot_temp certbot certonly --dns-digitalocean --dns-digitalocean-credentials /etc/letsencrypt/digitalocean.ini -d "<domain.com>" --agree-tos --no-eff-email --email <your@email.com>
```

```
docker-compose -f docker-compose-certbot.yml down

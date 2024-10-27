# Audit Sécurité

Pour tester les failles de sécurité de notre site, nous avons mis en place une série de tests de sécurité.

## Nmap

Nmap nous a permis de contrôler les ports ouverts sur le serveur avec la commande :

> nmap -p- timeman.chickenkiller.com

### Avant firewall

```bash
Not shown: 65525 closed tcp ports (conn-refused)
PORT     STATE    SERVICE
22/tcp   open     ssh
80/tcp   open     http
135/tcp  filtered msrpc
137/tcp  filtered netbios-ns
138/tcp  filtered netbios-dgm
139/tcp  filtered netbios-ssn
443/tcp  open     https
445/tcp  filtered microsoft-ds
4000/tcp open     remoteanything
5432/tcp open     postgresql 
```

Après firewall

PORT    STATE  SERVICE

```bash
Starting Nmap 7.92 ( https://nmap.org ) at 2024-10-27 17:30 CET
Nmap scan report for timeman.chickenkiller.com (157.230.106.92)
Host is up (0.053s latency).
Not shown: 65527 filtered tcp ports (no-response)
PORT     STATE  SERVICE
22/tcp   open   ssh
25/tcp   closed smtp
80/tcp   open   http
443/tcp  open   https
2375/tcp closed docker
2376/tcp closed docker
```
Il n'est pas non plus possible de se connecter au ssh de manière anonyme. 
Nous avons ensuite testé les pages Http et https avec Ghostbuster. 


## Gobuster

Exemple de commande passée :

➜  ~ gobuster dir -b "200,204,301,302,307,400,401,403" -u http://157.230.106.92:443 -w ~/gobuster.txt

Les tests sur Gobuster n'ont rien donné.

### Vérification des routes api

On a essayé de modifier des utilisateurs avec les routes de l'api sans être administrateur. Les routes ont bien été protégées en fonction des rôles et de l'authentification.
Une faille potentielle de sécurité est à régler sur le post:api/clocks/{user_id} qui n'est pas encore limitée uniquement à l'utilisateur connecté.


# DataPipe_signalement_docelec

Ce répertoire contient les différentes feuilles de style XSLT utilisées pour alimenter l'Opac (Primo) avec des  métadonnées de documentation électroniques, ainsi que les fonctions et méthodes python nécessaires à leur exécution. L'ensemble du dispositif a pour but à la fois d'automatiser sous forme de de pipe de données les phases manuelles de mise en forme des métadonnées pour Primo, et à la fois de permettre des installations et des accès multiples (en local via la CLI, en local via un Jupyter notebook ou une UI Voila activé dans un environnement virtuel, en local via un conteneur Docker, en version conteneurisée déployée sur le serveur distant si-scd).

## Installation locale (Windows)

### Pré-requis

Python v3 et environnement Anaconda pour ouvrir le notebook


### Download

- Télécharger l'archive zippée ou cloner le dépôt depuis Github.

- Installer le dossier dans un emplacement du serveur ou du PC accessible en écriture

### Virtualenv

- Si besoin, installer le package virtualenv (pip install virtualenv)

- Se placer à la racine du dossier et lancer la commande :

```
virtualenv NOM_DE_VOTRE_ENV # créé un environnement virtuel
```
- Activer l'environnement virtuel

```
cd NOM_DE_VOTRE_ENV/Scripts & activate
pip install -r ../../win_requirements.txt # installe toutes les dépendances
```
- Rendre accessible l'environnement virtuel dans le kernel des notebooks
  
 ```
 ipython kernel install --user --name=NOM_DE_VOTRE_ENV
 ```


## Utilisation en local

### Documentation complète

[https://wiki.univ-cotedazur.fr/display/SCDDeptSIDoc/Data+Pipe+Signalement+docelec](https://wiki.univ-cotedazur.fr/display/SCDDeptSIDoc/Data+Pipe+Signalement+docelec)

### Dans le notebook

- Avec l'application Notebook ou Jupyter de la suite Anaconda (accessibles avec Anaconda Navigator)

### En CLI

```
#Exemples
python execute_workflow.py -w:ftf -f:ftf_source_records.csv
python execute_workflow.py -w:numilog -f:numilog.xml
```

## Utilisation en production

Sur le serveur distant si-scd, le paramétrage du pipe est rendu dans une mini app web servie grâce à Voila (package permettant de convertir à la volée des Jupyter notebooks en pages html).

Le code du pipe est déployé au sein d'un conteneur Docker, dont l'image est accessible librement sur le registre Docker Hub

[https://hub.docker.com/repository/docker/gegedenice/datapipe-signalement-docelec](https://hub.docker.com/repository/docker/gegedenice/datapipe-signalement-docelec)

## Développement

### Pré-requis

Docker installé

### Méthodo

Les devs se font dans une installation locale du repo, et l'assemblage au sein d'un conteneur Docker peut être testé grâce au fichier descripteur Dockerfile.
Pour lancer le conteneur, il faut spécifier dans la commande :

- le mapping des ports (argument -p)
- quels dossiers locaux seront bindés avec ceux du conteneur (arguments -v)

```
#Exemple
docker run --name datapipe-signalement-docelec -e JUPYTER_ENABLE_LAB=yes -d -p 8888:8888 -p 8889:8889 -p 8866:8866 -v C:/Users/geoffroy/Docker/DataPipe-signalement-docelec/source_files:/home/jovyan/source_files -v C:/Users/geoffroy/Docker/DataPipe-signalement-docelec/result_files:/home/jovyan/result_files gegedenice/datapipe-signalement-docelec:latest
```
### CI Pipeline

Le commit et le push sur la branche main du repo actionne automatiquement une Github action de build et de push de la nouvelle image sur le Docker Hub.
(Le fichier de configuration du workflow est dans .github/workflows)

## Synthèse




 



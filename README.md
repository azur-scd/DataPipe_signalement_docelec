# DataPipe_signalement_docelec

Ce répertoire contient les différentes feuilles de style XSLT utilisées pour alimenter l'Opac (Primo) avec des  métadonnées de documentation électroniques, ainsi que les fonctions et méthodes python nécessaires à leur exécution. 
L'ensemble du dispositif a pour but d'automatiser sous forme de de pipe de données les phases (jusqu'ici manuelles) de mise en forme des métadonnées pour Primo, et d'utiliser pour ce faire l'environnement python des notebooks Jupyter permettant à la fois d'exécuter et documenter le code au même endroit.

Il répond également à un objectif d'ouverture et de "démocratisation" de l'accès au différents workflows, autant du point de vue de leurs exécutions que de celui de leur développement. Pour ce faire, le code est structuré  de manière à pouvoir permettre des installations et des accès multiples :
- installation du code source en local 
  - exécution via la CLI
  - accès et exécution via un Jupyter notebook
  - accès et exécution via une UI basique générée avec la librairie Voila qui convertit le notebook en app web interactive
- installation du conteneur Docker en local
  - accès et exécution via l'UI Voila
- accès distant partagé au conteneur Docker installé sur dev-scd
  - accès et exécution via l'UI Voila

## Code source : installation locale (Windows)

### Pré-requis

Python v3 et environnement Anaconda pour ouvrir le notebook

### Download

- Télécharger l'archive zippée ou cloner le dépôt depuis Github.

- Installer le dossier dans un emplacement du serveur ou du PC accessible en écriture

### Environnement virtuel

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
- Lancer le notebook
  - en ligne de commande : 
  - avec Anaconda Navigator

- Lancer l'app web Voila
  - en lige de commande : voila
  - depuis le notebook

### Focntionnement (exécution des workflows)

La documentation utilisateur complète se trouve sur le wiki [https://wiki.univ-cotedazur.fr/display/SCDDeptSIDoc/Data+Pipe+Signalement+docelec](https://wiki.univ-cotedazur.fr/display/SCDDeptSIDoc/Data+Pipe+Signalement+docelec)

#### Dans le notebook ou 

- Avec l'application Notebook ou Jupyter de la suite Anaconda (accessibles avec Anaconda Navigator)

#### En CLI

```
#Exemples
python execute_workflow.py -w:ftf -f:ftf_source_records.csv
python execute_workflow.py -w:numilog -f:numilog.xml
```

## Conteneur Docker : installation en local (Windows)

### Pré-requis

Docker Desktop pour Windows installé

### Download et utilisation

L'image du conteneur est accessible depuis le Docker registry à cette adresse : [https://hub.docker.com/repository/docker/gegedenice/datapipe-signalement-docelec](https://hub.docker.com/repository/docker/gegedenice/datapipe-signalement-docelec)

Une seule commande suffit à récupérer l'image et lancer le conteneur, en précisant en argument le mapping du port 8866 écouté à l'intérieur du conteneur ainsi que l'emplacement des répertoires du PC local à binder sur ceux du conteneur

```
#Exemple
docker run --name datapipe-signalement-docelec -e JUPYTER_ENABLE_LAB=yes -d -p 8866:8866 -p 8888:8888 -v C:/Users/user/Docker_examples/source_files:/home/scd/source_files -v C:/Users/user/Docker_examples/result_files:/home/scd/result_files gegedenice/datapipe-signalement-docelec:latest
```
*Personnaliser le path C:/Users/user/Docker_examples par votre propre path*

L'application est accessible en local sur http://localhost:<PORT>/datapipe-signalement-docelec




 



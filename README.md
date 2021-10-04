# DataPipe_signalement_docelec

Ce répertoire contient les différentes feuilles de style XSLT utilisées pour alimenter l'Opac (Primo) avec des  métadonnées de documentation électroniques, ainsi que les fonctions et méthodes python nécessaires à leur exécution. 

Ces scripts de data preprocessing qui permettent d'automatiser sous forme de de pipe de données les phases manuelles de mise en forme des métadonnées pour Primo peuvent être lancés en CLI (ligne de commande) ou depuis une UI sommaire dans le Jupyter Noptebook execute_workflow_ui.ipynb.
 
Ce pipe est accessible depuis si-scd.unice.fr pour une utilisation distante ou être installé en local sur son PC (Windows)

## Pré-requis

Python v3 et environnement Anaconda pour ouvrir le notebook

### Environnement Python sur Centos

Voir [cette page](https://wiki.univ-cotedazur.fr/display/SCDDeptSIDoc/Environnement+technique) du wiki pour installer Anaconda sur l'OS Centos 7

## Download

- Télécharger l'archive zippée ou cloner le dépôt depuis Github.

- Installer le dossier dans un emplacement du serveur ou du PC accessible en écriture

- serveur Linux : si besoin mettre l'utilisateur scd en propriétaire du folder 
```  
sudo chown -R scd:scd DataPipe_signalement_docelec
```

## Virtualenv

Si besoin, installer le package virtualenv (pip install virtualenv)

Se placer à la racine du dossier et lancer la commande :

```
virtualenv NOM_DE_VOTRE_ENV # créé un environnement virtuel
```

#### Activation sous Windows

**Important : décommenter les lignes correspondant aux packages pywin32 et pywinpty (spécifiques Windows) dans requirements.txt**

```
cd NOM_DE_VOTRE_ENV/Scripts
activate # active l'environnement virtuel
pip install -r ../../requirements.txt # installe toutes les dépendances
```

#### Activation sous Linux

```
source NOM_DE_VOTRE_ENV/bin/activate
pip install -r requirements.txt # installe toutes les dépendances
```

## Usage

### Documentation complète

[https://wiki.univ-cotedazur.fr/display/SCDDeptSIDoc/Data+Pipe+Signalement+docelec](https://wiki.univ-cotedazur.fr/display/SCDDeptSIDoc/Data+Pipe+Signalement+docelec)

### Exemples CLI

```
python execute_workflow.py -w:ftf -f:ftf_source_records.csv
python execute_workflow.py -w:numilog -f:numilog.xml
```

 



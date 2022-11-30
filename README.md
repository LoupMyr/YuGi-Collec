# YuGi'Collec

## Sommaire
- [Présentation](#présentation)
- [Base de donnée](#base-de-donnée)
- [Détails de l'application](#détails-de-lapplication)
- [Exemple d'utilisation](#exemple-dutilisation)


## Présentation

### L'application

L'application YuGi'Collec est une application mobile conçu en Flutter. Elle a pour but de retrouver facilement toutes sortes de cartes Yu-Gi-Oh. Elle permet égalemment de regrouper et gérer sa collection personnelle de carte ainsi que ses propres decks grâce à un compte utilisateur.

### Les API
YuGi'Collec utilise deux API distinctes. La première est l'API publique de "ygoprodeck". Elle permet à l'application de récupérer l'ensemble des cartes Yu-Gi-Oh afin de récupérer leurs informations et leurs images. La seconde est "YuGi'Collec Account API" conçu spécialement pour créer et gérer les comptes de chaque utilisateurs de l'application. C'est grâce à celle-ci que YuGi'Collec peut gérer les collections et les decks et de tous les utilisateurs.


## Base de donnée
![uml](https://user-images.githubusercontent.com/100768194/204823703-8ea875a1-6bd8-4b6b-8000-557d06986627.png)


## Détails de l'application

### Inscription & connexion

Pour utiliser pleinement l'application, un compte est nécessaire. Pour celà, lors du démarrage de YuGi'Collec, un écran de connxion vous est proposé ainsi qu'un écran d'inscription si vous n'avez pas encore de compte. 

### Fonctionnalités de recherches

YuGi'Collec propose 3 types de recherches de cartes chacun sur des écrans différents :
* Par identifiant, permet la recherche d'une carte précisément.
* Par type, permet de rechercher toutes les cartes ayant un type précis.
* Par niveau, permet de retrouver toutes les cartes ayant un certain niveau.
Ces 3 recherches portent sur l'API "ygoprodeck". À la suite d'une recherche d'une ou plusieurs cartes, vous aurez plusieurs informations à propos de cette/ces cartes tel que son nom, son niveau, son type et une image de la/les carte.s en question. De plus, vous pourrez ajouter une ou plusieurs cartes pour les ajouter à votre collection et/ou vos decks. Si vous souhaitez ajouté une carte à un deck mais que vous ne l'avez pas encore créé, vous aurez possibilité de le faire en entrant un simple nom.

### Fonctionnalités utilisateur

Comme vu précédemment, YuGi'Collec propose une gestion simple et rapide de sa collection et de ses decks, vous trouverez donc un écran pour voir votre collection ainsi qu'un second pour voir tout vos decks. 
En ce qui concerne la page collection, vous y verrez la liste de toutes les cartes que vous aurez ajouté à celle-ci ainsi que la possibilité d'en supprimer.
Pour ce qui  est de la page decks, vous trouverez tout d'abord une liste de tout vos decks et la possibilité d'en créer un. Après selection d'un deck en particulier, vous remarquerez un listing de toutes les cartes ajoutés à ce dernier.

## Exemple d'utilisation

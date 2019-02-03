// ce package contien les class de base que nous allons utiliser
import 'package:flutter/material.dart';
// ce package nous permet d'utiliser WordPair
import 'package:english_words/english_words.dart';


// Notre application se lance à partir de cette instruction
// on essaye ainsi de créer une application à afficher
void main() => runApp(new MonApp());


// cette classe est notre application
// on y décrit ces composants
class MonApp extends StatelessWidget {

  // cette fonction retourne les widget à afficher
  @override
  Widget build(BuildContext context) {
    
   // MaterialApp est un template d'application 
   // respectant les bases du Material Designe
    return new MaterialApp(
      
      // cette instruction élimine la barre qui 
      //indique que l'application est un prototype
      
      debugShowCheckedModeBanner: false,
      // cette proprièté indique le nom de notre application
      title: 'Générateur de noms de Startups',
      // cette proriété précise le théme couleur de notre application
      theme: new ThemeData(
         primaryColor:  Colors.green,
      ),
      // on précise ici la structure de notre page d'accueil
      // ici elle serra généré par la classe PairesAleatoires()
      home: new PairesAleatoires(),
    );
  }
}

// cette sert surtout de placeholdeur dans l'arboraissance de Widgets
// de notre application elle prend une place et son contenu est chargé 
// grace aux appelles de la classe EtatdeceWidget 
class PairesAleatoires extends StatefulWidget {

  // cette instruction nous permet de créer un état initiale 
  // à partir de la classe EtatPairesAleatoires 
  // qui se charge de générer un nouvel état à chaque solicitation
  // NB: un état c'est ce que l'on va afficher 
  @override
  EtatPairesAleatoires createState() => new EtatPairesAleatoires();
}

class EtatPairesAleatoires extends State<PairesAleatoires> {
 
 // cette variable va contenir l'ensemble des Paires 
  final List<WordPair> _suggestions = <WordPair>[];
 //cette varable va contenir les paires retenues  
  final Set<WordPair> _sauvegarde = new Set<WordPair>();
 // cette variable contient la déclaration de la proprièté 
 // Text plus grand 
  final TextStyle _grandeFont = const TextStyle(fontSize: 18.0);

// cette fonction retourne ce que l'on va afficher
  @override
  Widget build(BuildContext context) {
    // le scaffold est un template de page
    return new Scaffold(
      // AppBar est un template de barre d'application
      appBar: new AppBar(
        // son titre
        title: new Text('Générateur de nom de Startups'),
        // un boutton cliquable
        actions: <Widget>[
          // on cas de clique on execute _pushSaved
          new IconButton(icon: const Icon(Icons.list), onPressed: _pushSaved),
        ],
      ),
      // le corp de la page
      body: _GenererSuggestions(),
    );
  }
 // cette fonction nous permet de génrer une liste infinie de paires
  Widget _GenererSuggestions() {
    // déclaration d'une listeView
    return new ListView.builder(
       
        padding: const EdgeInsets.all(16.0),
        itemBuilder: (BuildContext _context, int i) {
          // on met un divider ou séparateur entre chaque deux lignes
          if (i.isOdd) {
            return new Divider();
          }
          // on calcule le vrai index de chaque ligne 
          //sans prendre en compte le divider
          final int index = i ~/ 2;
          // à chaque fois que l'on a attein le max de Paires
          if (index >= _suggestions.length) {
            // génération de 10 Paires
            _suggestions.addAll(generateWordPairs().take(10));
          }
          // généaraion d'autant de lignes que de Paires
          return _GenererLigne(_suggestions[index]);
        });
  }

// cette fonction construit des lignes
  Widget _GenererLigne(WordPair pair) {

    // ce booleen nous précise si la pair est déja retenue ou non
    final bool alreadySaved = _sauvegarde.contains(pair);
    // construction d'un element de liste
    return new ListTile(
      // son titre serra la valeure d'une paire
      title: new Text(
        pair.asPascalCase,
        style: _grandeFont,
      ),
      // ajout d'une icone coeur dont la couleur dépend de si ou non elle a été liké
      trailing: new Icon(
        alreadySaved ? Icons.favorite : Icons.favorite_border,
        color: alreadySaved ? Colors.red : null,
      ),
      // on cas de clique on ajoute ou on retir la paire de la liste sauvegardé
      onTap: () {
        setState(() {
          if (alreadySaved) {
            _sauvegarde.remove(pair);
          } else {
            _sauvegarde.add(pair);
          }
        });
      },
    );
  }
  // cette fonction sert à construire la seconde page de l'application
  void _pushSaved() {
    // changement de page
    Navigator.of(context).push(

      // nouvelle Page
      new MaterialPageRoute<void>(

        builder: (BuildContext context) {
          //transformation de nos Paires sauvegrdées en ListTile
          final Iterable<ListTile> tiles = _sauvegarde.map(
            (WordPair pair) {
              return new ListTile(
                title: new Text(
                  pair.asPascalCase,
                  style: _grandeFont,
                ),
              );
            },
          );
         // création d'une liste de ces ListTiles
          final List<Widget> divided = ListTile.divideTiles(
            context: context,
            tiles: tiles,
          ).toList();
          // la page à afficher
          return new Scaffold(
            appBar: new AppBar(
              title: const Text('Suggestions Sauvegardées'),
            ),
            // construction d'une listView à partir de la liste de ListTile 
            body: new ListView(children: divided),
          );
        },
      ),
    );
  }
}

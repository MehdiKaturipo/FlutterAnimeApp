import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Movie {
  final String id;
   String title;
   String type;
   String description;
   double rating;
   String imageUrl;
  bool isFavorite;
  List<MovieReview> reviews;

  Movie({
    required this.id,
    required this.title,
    required this.type,
    required this.description,
    required this.rating,
    required this.imageUrl,
    this.isFavorite = false,
    required this.reviews,
  });
}
enum MovieListType {
  mostReviewed,
  myFavorites,
}

class MovieReview {
  final String username;
  double rating;
  String comment;

  MovieReview({required this.username, this.rating = 0.0, this.comment = ''});
}

class MovieReviewWidget extends StatelessWidget {
  final MovieReview review;

  MovieReviewWidget({required this.review});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text('${review.username} - Rating: ${review.rating}'),
      subtitle: Text(review.comment),
    );
  }
}


class MovieCartItem extends StatefulWidget {
  final Movie movie;
  final VoidCallback onDelete;

  MovieCartItem({required this.movie, required this.onDelete});

  @override
  _MovieCartItemState createState() => _MovieCartItemState();
}

class _MovieCartItemState extends State<MovieCartItem> {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      child: InkWell(
        onTap: () {
          // Navigate to movie details screen
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => MovieDetailsScreen(movie: widget.movie)),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(widget.movie.imageUrl),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.movie.title,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          for (int i = 0; i < widget.movie.rating.toInt(); i++)
                            Icon(Icons.star, color: Colors.yellow),
                        ],
                      ),
                      SizedBox(width: 8),
                      Text('(${widget.movie.rating})'),
                    ],
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: Icon(
                    widget.movie.isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: widget.movie.isFavorite ? Colors.red : null,
                    size: 32,
                  ),
                  onPressed: () {
                    setState(() {
                      // Toggle favorite status
                      widget.movie.isFavorite = !widget.movie.isFavorite;
                    });

                    Fluttertoast.showToast(
                      msg: '${widget.movie.title} ${widget.movie.isFavorite ? 'ajouté aux' : 'retiré des'} favoris',
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 2,
                      backgroundColor: Colors.black,
                      textColor: Colors.white,
                      fontSize: 16.0,
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}




class MovieDetailsScreen extends StatefulWidget {
   Movie movie;
  MovieDetailsScreen({required this.movie});

  @override
  _MovieDetailsScreenState createState() => _MovieDetailsScreenState();
}

class _MovieDetailsScreenState extends State<MovieDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.movie.title),
        actions: [
          // Ajoutez un IconButton avec l'icône d'édition
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              // Fonction pour gérer le clic sur l'icône d'édition
              _editMovieDetails(context);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(
              widget.movie.imageUrl,
              height: 300,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            SizedBox(height: 16),
            Center(
              child: Text(
                'Type: ${widget.movie.type}',
                textAlign: TextAlign.center,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Afficher des étoiles en fonction de la note
                for (int i = 0; i < widget.movie.rating.toInt(); i++)
                  Icon(Icons.star, color: Colors.yellow),
                SizedBox(width: 8),
                Text('Rating: ${widget.movie.rating}'),
              ],
            ),
            SizedBox(height: 16),
            Center(
              child: Text(
                'Description: ${widget.movie.description}',
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Basculer l'état favori
                    widget.movie.isFavorite = !widget.movie.isFavorite;
                   Fluttertoast.showToast(
                              msg: '${widget.movie.title} ${widget.movie.isFavorite ? 'ajouté aux' : 'retiré des'} favoris',
                             toastLength: Toast.LENGTH_SHORT,
                             gravity: ToastGravity.BOTTOM,
                             timeInSecForIosWeb: 2,
                             backgroundColor: Colors.black,
                              textColor: Colors.white,
                             fontSize: 16.0,
                          );
                    setState(() {}); // Forcer la reconstruction du widget pour refléter le changement d'état
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        widget.movie.isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: widget.movie.isFavorite ? Colors.red : null,
                      ),
                      SizedBox(width: 8),
                      Text(widget.movie.isFavorite ? 'Retirer des favoris' : 'Ajouter aux favoris'),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  } void _editMovieDetails(BuildContext context) async {
  // Utilisez Navigator.push pour naviguer vers une nouvelle page de modification
  final updatedMovie = await Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => MovieEditScreen(movie: widget.movie),
    ),
  );

  // Vérifiez si les détails du film ont été modifiés
  if (updatedMovie != null) {
    // Mettez à jour l'état avec les nouvelles informations
    setState(() {
      widget.movie = updatedMovie;
    });

    // Affichez une Snackbar ou tout autre indicateur de réussite
                  Fluttertoast.showToast(
  msg: 'Détails du film mis à jour avec succès',
  toastLength: Toast.LENGTH_SHORT,
  gravity: ToastGravity.BOTTOM,
  timeInSecForIosWeb: 2,
  backgroundColor: Colors.black,
  textColor: Colors.white,
  fontSize: 16.0,
);
  }
}
}
class MovieEditScreen extends StatefulWidget {
  final Movie movie;

  MovieEditScreen({required this.movie});

  @override
  _MovieEditScreenState createState() => _MovieEditScreenState();
}

class _MovieEditScreenState extends State<MovieEditScreen> {
  late TextEditingController titleController;
  late TextEditingController descriptionController;
  late TextEditingController typeController;
  late TextEditingController ratingController;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.movie.title);
    descriptionController = TextEditingController(text: widget.movie.description);
    typeController = TextEditingController(text: widget.movie.type);
    ratingController = TextEditingController(text: widget.movie.rating.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Modifier les détails de l`a anime'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Image.asset(
              widget.movie.imageUrl,
              height: 300,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            TextField(
              controller: titleController,
              onChanged: (value) {
                widget.movie.title = value;
              },
              decoration: InputDecoration(labelText: 'Titre de l`a anime'),
            ),
            SizedBox(height: 16),
            TextField(
              controller: descriptionController,
              onChanged: (value) {
                widget.movie.description = value;
              },
              decoration: InputDecoration(labelText: 'Description du l`a anime'),
            ),
            SizedBox(height: 16),
            TextField(
              controller: typeController,
              onChanged: (value) {
                widget.movie.type = value;
              },
              decoration: InputDecoration(labelText: 'Type de l`a anime'),
            ),
            SizedBox(height: 16),
            TextField(
              controller: ratingController,
              onChanged: (value) {
                // Vous devez ajouter une logique pour vous assurer que la note est un double valide
                // Par exemple, vous pouvez utiliser try-catch pour gérer les erreurs de conversion
                try {
                  double rating = double.parse(value);
                  widget.movie.rating = rating;
                } catch (e) {
                  // Gérez l'erreur de conversion ici
                }
              },
              decoration: InputDecoration(labelText: 'Note du l`a anime'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Retournez le film modifié à l'écran précédent
                Navigator.pop(context, widget.movie);
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.yellow, // Couleur jaune
              ),
              child: Text(
                'Enregistrer les modifications',
                style: TextStyle(color: Colors.black), // Couleur du texte noir
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MovieListScreen extends StatefulWidget {
  @override
  _MovieListScreenState createState() => _MovieListScreenState();
}

class _MovieListScreenState extends State<MovieListScreen> {
  final List<Movie> movies = [
    Movie(
      id: '1',
      title: 'One Piece',
      description: 'Monkey D. Luffy sets out on a grand adventure to become the Pirate King and find the legendary treasure, One Piece.',
      rating: 5,
      imageUrl: 'assets/one.jpg',
      type: 'Action',
      reviews: [],
    ),
    Movie(
      id: '2',
      title: 'Naruto',
      description: 'Follow Naruto Uzumaki, a young ninja with dreams of becoming the strongest ninja and earning the title of Hokage, the leader of his village.',
      rating: 4.0,
      imageUrl: 'assets/naruto4.png',
      type: 'Action',
      reviews: [],
    ),
    Movie(
      id: '3',
      title: 'Jujutsu Kaisen',
      description: 'Yuji Itadori joins a secret school to battle curses after he encounters a cursed object and becomes involved in a world of supernatural threats.',
      rating: 3.0,
      imageUrl: 'assets/Jujutsu1.jpg',
      type: 'Supernatural',
      reviews: [],
    ),
    Movie(
      id: '4',
      title: 'Demon Slayer',
      description: 'Tanjiro Kamado seeks to avenge his family and save his demon-turned sister, Nezuko, by becoming a demon slayer and battling powerful demons.',
      rating: 2.0,
      imageUrl: 'assets/demon.png',
      type: 'Action',
      reviews: [],
    ),
    Movie(
      id: '5',
      title: 'Vinland Saga',
      description: 'Thorfinn, a young Viking, embarks on a journey of revenge against the men who killed his father, all while experiencing the historical events of the Viking Age.',
      rating: 1.0,
      imageUrl: 'assets/saga.png',
      type: 'Action',
      reviews: [],
    ), Movie(
    id: '6',
    title: 'Attack on Titan',
    description: 'Eren Yeager and his friends join the military to fight the Titans and uncover the mysteries of their world.',
    rating: 3.0,
    imageUrl: 'assets/aot1.jpg',
    type: 'Action',
    reviews: [],
  ),
  Movie(
    id: '7',
    title: 'My Hero Academia',
    description: 'Izuku Midoriya trains to become a hero in a world where superpowers, or quirks, are common.',
    rating: 1.0,
    imageUrl: 'assets/mha.png',
    type: 'Action',
    reviews: [],
  ),Movie(
  id: '8',
  title: 'Fullmetal Alchemist: Brotherhood',
  description: 'Two brothers search for the Philosopher\'s Stone to restore their bodies after a failed alchemical ritual.',
  rating: 2.8,
  imageUrl: 'assets/fma.jpg',
  type: 'Adventure',
  reviews: [],
),
Movie(
  id: '9',
  title: 'Death Note',
  description: 'Light Yagami discovers a mysterious notebook that allows him to kill anyone by writing their name in it.',
  rating: 3.7,
  imageUrl: 'assets/death2.jpg',
  type: 'Mystery',
  reviews: [],
),
Movie(
  id: '10',
  title: 'Cowboy Bebop',
  description: 'Bounty hunter Spike Spiegel and his crew travel through space in pursuit of the galaxy\'s most dangerous criminals.',
  rating: 1.5,
  imageUrl: 'assets/coboy1.jpg',
  type: 'Space Western',
  reviews: [],
),
Movie(
  id: '11',
  title: 'One Punch Man',
  description: 'Saitama, a hero who can defeat any opponent with a single punch, seeks a worthy challenge.',
  rating: 4.9,
  imageUrl: 'assets/opm.webp',
  type: 'Action',
  reviews: [],
),
    // ... (similar entries for other movies)
  ];

  List<Movie> getMostReviewedMovies() {
    return movies.where((movie) => movie.rating == 4 || movie.rating == 5).toList();
  }

  List<Movie> getFavoriteMovies() {
    return movies.where((movie) => movie.isFavorite).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Anime List'),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Anime App',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
           ListTile(
  leading: Icon(Icons.star),
  title: Text('Most Reviewed (4-5 stars)'),
  onTap: () {
    Navigator.pop(context);
    _navigateToMovieList(context, getMostReviewedMovies(), 'Most Reviewed Anime', MovieListType.mostReviewed);
  },
),
ListTile(
  leading: Icon(Icons.favorite),
  title: Text('My Favorites'),
  onTap: () {
    Navigator.pop(context);
    _navigateToMovieList(context, getFavoriteMovies(), 'My Favorite Anime', MovieListType.myFavorites);
  },
),
          ],
        ),
      ),
     body: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 4.0,
          mainAxisSpacing: 4.0,
        ),
        itemCount: movies.length,
        itemBuilder: (context, index) {
          return MovieCartItem(
            movie: movies[index],
            onDelete: () {
              _deleteMovieFromFavorites(movies[index]);
            },
          );
        },
      ),
    );
  }

 void _navigateToMovieList(BuildContext context, List<Movie> movieList, String title, MovieListType listType) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => MovieListDetailsScreen(
        movieList: movieList,
        title: title,
        listType: listType, // Pass the list type
      ),
    ),
  );
}

  void _deleteMovieFromFavorites(Movie movie) {
    movie.isFavorite = false;
   Fluttertoast.showToast(
  msg: '${movie.title} retiré des favoris',
  toastLength: Toast.LENGTH_SHORT,
  gravity: ToastGravity.BOTTOM,
  timeInSecForIosWeb: 2,
  backgroundColor: Colors.black,
  textColor: Colors.white,
  fontSize: 16.0,
);
    setState(() {});
  }
}

class MovieListDetailsScreen extends StatefulWidget {
  final List<Movie> movieList;
  final String title;
  final MovieListType listType; // Add this line

  MovieListDetailsScreen({
    required this.movieList,
    required this.title,
    required this.listType, // Add this line
  });

  @override
  _MovieListDetailsScreenState createState() => _MovieListDetailsScreenState();
}
class _MovieListDetailsScreenState extends State<MovieListDetailsScreen> {
  List<Movie> filteredMovies = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              _showSearch(context);
            },
          ),
        ],
      ),
      body: _buildMovieList(),
    );
  }

 Widget _buildMovieList() {
  return ListView.builder(
    itemCount: filteredMovies.isNotEmpty ? filteredMovies.length : widget.movieList.length,
    itemBuilder: (context, index) {
      final currentMovie = filteredMovies.isNotEmpty ? filteredMovies[index] : widget.movieList[index];
      return ListTile(
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: AssetImage(currentMovie.imageUrl),
              radius: 20, // Adjust the radius as needed
            ),
            SizedBox(width: 16),
            Text(currentMovie.title),
            Spacer(),
            if (widget.listType == MovieListType.myFavorites) // Conditionally show delete icon
              IconButton(
                icon: Icon(Icons.delete),
                onPressed: () {
                  _deleteMovieFromFavorites(context, currentMovie);
                },
              ),
          ],
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => MovieDetailsScreen(movie: currentMovie)),
          );
        },
      );
    },
  );
}

   void _deleteMovieFromFavorites(BuildContext context, Movie movie) {
  // Supprimer le film de la liste des favoris
  movie.isFavorite = false;

  // Afficher une notification
  Fluttertoast.showToast(
    msg: '${movie.title} retiré des favoris',
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIosWeb: 2,
    backgroundColor: Colors.black,
    textColor: Colors.white,
    fontSize: 16.0,
  );

  // Mettre à jour filteredMovies
  setState(() {
    // Retirer le film de filteredMovies
      movie.isFavorite = false;
      widget.movieList.removeWhere((m) => m.id == movie.id);  });
}


  void _showSearch(BuildContext context) async {
    final result = await showSearch(
      context: context,
      delegate: MovieSearchDelegate(widget.movieList),
    );

    // Handle the result from the search, if needed
    if (result != null) {
      print('Search result: $result');
    }
  }
}

class MovieSearchDelegate extends SearchDelegate<Movie?> {
  final List<Movie> movieList;

  MovieSearchDelegate(this.movieList);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // Implement logic to display search results based on the query
    // For simplicity, this example just returns the first matching result.

    final results = movieList.where((movie) => movie.title.toLowerCase().contains(query.toLowerCase())).toList();

    return _buildResultList(results);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // You can implement suggestions based on the query if needed
    return _buildResultList(movieList);
  }

  Widget _buildResultList(List<Movie> resultList) {
    return ListView.builder(
      itemCount: resultList.length,
      itemBuilder: (context, index) {
        final movie = resultList[index];
        return ListTile(
          title: Text(movie.title),
          subtitle: Text('Rating: ${movie.rating}'),
          onTap: () {
            close(context, movie);
          },
        );
      },
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: MovieListScreen(),
  ));
}

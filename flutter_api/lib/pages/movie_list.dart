import 'package:flutter/material.dart';
import 'package:flutter_api/pages/movie_detail.dart';
import 'package:flutter_api/service/http_service.dart';

class MovieList extends StatefulWidget {
  @override
  _MovieListState createState() => _MovieListState();
}

class _MovieListState extends State<MovieList> {
  int movieCount;
  List movies;
  HttpService service;

  // String result = "";

  Future initialize() async {
    movies = [];
    movies = await service.getPopularMovies();
    setState(() {
      movieCount = movies.length;
      movies = movies;
    });
  }

  @override
  void initState() {
    service = HttpService();
    initialize();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final String imgPath = 'https://image.tmdb.org/t/p/w500/';

    return Scaffold(
      appBar: AppBar(
        title: Text("Popular Movies"),
      ),
      body: ListView.builder(
        itemCount: (this.movieCount == null) ? 0 : this.movieCount,
        itemBuilder: (context, int position) {
          return Card(
            color: Colors.white,
            elevation: 2.0,
            child: InkWell(
              onTap: () {
                MaterialPageRoute route = MaterialPageRoute(
                    builder: (_) => MovieDetail(movies[position]));
                Navigator.push(context, route);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(width: 5),
                  Container(
                    width: 100,
                    height: 155,
                    child: Image.network(imgPath + movies[position].posterPath),
                  ),
                  SizedBox(width: 10),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(movies[position].title),
                      Text('Rating = ' +
                          movies[position].voteAverage.toString()),
                    ],
                  ),
                ],
              ),
            ),

            // child: ListTile(
            //   title: Text(movies[position].title),
            //   subtitle: Text(
            //     'Rating = ' + movies[position].voteAverage.toString(),
            //   ),
            //   onTap: () {
            //     MaterialPageRoute route = MaterialPageRoute(
            //         builder: (_) => MovieDetail(movies[position]));
            //     Navigator.push(context, route);
            //   },
            // ),
          );
        },
      ),
    );
    // service.getPopularMovies().then((value) => {
    //       setState(() {
    //         result = value;
    //       })
    //     });
    // return Scaffold(
    //   appBar: AppBar(
    //     title: Text("Popular Movies"),
    //   ),
    //   body: Container(
    //     child: Text(result),
    //   ),
    // );
  }
}

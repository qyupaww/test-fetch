import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'post.dart';
import 'post_widget.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Test Fetch'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Post> posts = [];

  @override
  void initState() {
    super.initState();
    _initPost();
  }

  void _initPost() async {
    final result = await _fetchPostLists();

    setState(() {
      posts.addAll(result);
    });
  }

  Future<List<Post>> _fetchPostLists() async {
    const api = "https://jsonplaceholder.typicode.com/posts";

    final response = await http.get(Uri.parse(api));

    if (response.statusCode == 200) {
      final decode = json.decode(response.body);

      List<Post> posts = (decode as List)
          .map((post) => Post.fromJson(post))
          .toList();

      return posts;
    } else {
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,

        title: Text(widget.title),
      ),
      body: Center(
        child: ListView.separated(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
          itemBuilder: (context, index) {
            return PostWidget(post: posts[index]);
          },
          separatorBuilder: (_, __) {
            return const SizedBox(height: 16);
          },
          itemCount: posts.length,
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

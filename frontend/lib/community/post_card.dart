import 'package:flutter/material.dart';


class PostCard extends StatefulWidget {
  int number;

  PostCard({required this.number, super.key});

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Text(widget.number.toString()),
      ),
    );
  }
}

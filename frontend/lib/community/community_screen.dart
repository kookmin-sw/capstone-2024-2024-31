import 'package:flutter/material.dart';
import 'package:frontend/community/post_card.dart';

class CommunityScreen extends StatefulWidget {
  const CommunityScreen({super.key});

  @override
  State<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.builder(
        itemCount: 30,
          itemBuilder: (BuildContext context, int index){
          return PostCard(
            number : index,
          );
          })
    );
  }
}

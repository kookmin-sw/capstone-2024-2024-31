import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class FollowingTab extends StatelessWidget {
  List<dynamic> followingList;

  FollowingTab({super.key, required this.followingList});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: followingList.length,
      itemBuilder: (context, index) {
        final follower = followingList[index];
        return FollowerCard(
          imageUrl: follower['image'],
          nickName: follower['name'],
          isFollowing: follower['isFollowing'],
        );
      },
    );
  }
}

class FollowerCard extends StatefulWidget {
  final String imageUrl;
  final String nickName;
  bool isFollowing;

  FollowerCard({
    Key? key,
    required this.imageUrl,
    required this.nickName,
    required this.isFollowing,
  }) : super(key: key);

  @override
  _FollowerCardState createState() => _FollowerCardState();
}

class _FollowerCardState extends State<FollowerCard> {
  bool _isFollowing = false;

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.symmetric(vertical: 5, horizontal: 12),
        width: double.infinity,
        height: 80,
        child: Row(
          children: [
            CircleAvatar(
              radius: 25,
              backgroundImage: AssetImage(widget.imageUrl),
            ),
            SizedBox(width: 10),
            Expanded(
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.nickName,
                        style: TextStyle(
                          fontSize: 12,
                          fontFamily: 'Pretendard',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      widget.isFollowing
                          ? GestureDetector(
                        onTap: () {
                          setState(() {
                            widget.isFollowing = !widget.isFollowing;
                          });
                        },
                        child: SvgPicture.asset(
                            "assets/svgs/follow_delete_btn.svg"),
                      )
                          : GestureDetector(
                        onTap: () {
                          setState(() {
                            widget.isFollowing = !widget.isFollowing;
                          });
                        },
                        child:
                        SvgPicture.asset("assets/svgs/follow_able_btn.svg"),
                      )
                    ]))
          ],
        ));
  }
}

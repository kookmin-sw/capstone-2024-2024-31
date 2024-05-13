import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend/community/widget/post_card.dart';
import 'package:frontend/model/config/palette.dart';

class CommunityScreen extends StatefulWidget {
  const CommunityScreen({super.key});

  @override
  State<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen>
    with TickerProviderStateMixin {
  int _selectedIndex = 0; // 탭 인덱스
  int _sortIndex = 0; // 정렬 방식 인덱스

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // 버튼 스타일 정의
  final _selectedButtonStyle = ElevatedButton.styleFrom(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(26.0),
      ),
      foregroundColor: Palette.white,
      backgroundColor: Palette.purPle400,
      disabledBackgroundColor: Palette.greySoft,
      disabledForegroundColor: Colors.white,
      minimumSize: Size(60, 36));

  final _unselectedButtonStyle = ElevatedButton.styleFrom(
    shape: RoundedRectangleBorder(
      side: BorderSide.none,
      borderRadius: BorderRadius.circular(20.0),
    ),
    foregroundColor: Palette.grey200,
    backgroundColor: Palette.greySoft,
    shadowColor: Colors.transparent,
    minimumSize: Size(60, 36),

    // padding: const EdgeInsets.symmetric(vertical: 12.0),
  );

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildSortButtons(),
        Expanded(
            child: ListView.builder(
                itemCount: 30,
                itemBuilder: (BuildContext context, int index) {
                  return PostCard(
                    number: index,
                  );
                }))
      ],
    );
  }

  Widget _buildSortButtons() {
    return Container(padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        color: Palette.white,
        child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        ElevatedButton(
          onPressed: () {
            setState(() {
              _sortIndex = 0;
            });
          },
          style:
              _sortIndex == 0 ? _selectedButtonStyle : _unselectedButtonStyle,
          child: const Text(
            '최신순',
            style: TextStyle(
                fontWeight: FontWeight.w500,
                fontFamily: 'Pretendard',
                fontSize: 12),
          ),
        ),
        const SizedBox(width: 10),
        ElevatedButton(
          onPressed: () {
            setState(() {
              _sortIndex = 1;
            });
          },
          style:
              _sortIndex == 1 ? _selectedButtonStyle : _unselectedButtonStyle,
          child: const Text('인기순',
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Pretendard',
                  fontSize: 12)),
        ),
      ],
    ));
  }
}

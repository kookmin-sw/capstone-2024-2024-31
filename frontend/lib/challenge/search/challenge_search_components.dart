import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend/model/config/palette.dart';

class CategorySelector extends StatelessWidget {
  final List<String> categoryList;
  final int selectedIndex;
  final Function(int) onCategorySelected;

  const CategorySelector({
    super.key,
    required this.categoryList,
    required this.selectedIndex,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(
            categoryList.length,
                (index) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: ElevatedButton(
                onPressed: () => onCategorySelected(index),
                style: ButtonStyle(
                  padding: MaterialStateProperty.all(
                    const EdgeInsets.symmetric(horizontal: 15),
                  ),
                  maximumSize: MaterialStateProperty.all(const Size(80, 35)),
                  minimumSize: MaterialStateProperty.all(const Size(10, 35)),
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  backgroundColor: selectedIndex == index
                      ? MaterialStateProperty.all(Palette.purPle400)
                      : null,
                ),
                child: Text(
                  categoryList[index],
                  style: TextStyle(
                    color: selectedIndex == index ? Colors.white : Palette.grey200,
                    fontSize: 11,
                    fontWeight: selectedIndex == index ? FontWeight.bold : FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class PrivateToggle extends StatelessWidget {
  final bool isPrivate;
  final ValueChanged<bool> onToggle;

  const PrivateToggle({
    super.key,
    required this.isPrivate,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        const Text(
          "비공개 챌린지만",
          style: TextStyle(
            fontFamily: "Pretendard",
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Palette.grey300,
          ),
        ),
        const SizedBox(width: 5),
        CupertinoSwitch(
          value: isPrivate,
          thumbColor: Palette.white,
          trackColor: Palette.greySoft,
          activeColor: Palette.purPle300,
          onChanged: onToggle,
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';

class EpisodeList extends StatefulWidget {
  final List<String> episode;

  const EpisodeList({Key? key, required this.episode}) : super(key: key);

  @override
  _EpisodeListState createState() => _EpisodeListState();
}

class _EpisodeListState extends State<EpisodeList> {
  int? _selectedIndex;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 6,
      runSpacing: 6,
      children: widget.episode.asMap().entries.map((entry) {
        int index = entry.key;
        String e = entry.value;
        bool isSelected = _selectedIndex == index;

        return GestureDetector(
          onTap: () {
            setState(() {
              _selectedIndex = index;
            });
          },
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 4.0),
            decoration: BoxDecoration(
              color: Colors.grey.shade900,
              borderRadius: BorderRadius.circular(6.0),
              boxShadow: [
                BoxShadow(
                  color: isSelected
                      ? Colors.orange.withOpacity(0.3)
                      : Colors.black.withOpacity(0.3),
                  spreadRadius: 1,
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: SizedBox(
              width: 60,
              height: 50,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Text(
                    e,
                    style: const TextStyle(fontSize: 16, color: Colors.white),
                  ),
                  AnimatedPositioned(
                    duration: const Duration(milliseconds: 300),

                    bottom: isSelected ? 8 : -2,
                    // Move the border in and out

                    left: 25,
                    child: Container(
                      width: 22, // Match the width of the text container
                      height: 2.0, // Thickness of the border

                      decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius:
                              BorderRadius.circular(10)), // Color of the border
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

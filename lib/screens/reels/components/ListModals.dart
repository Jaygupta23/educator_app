import 'package:flutter/material.dart';
import 'package:reelies/screens/reels/components/EpisodeList.dart';

class ListModals extends StatelessWidget {
  const ListModals({super.key});

  static final List<String> episode = [
    'Trailer',
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
    '10',
    '11',
    '12',
    '13',
    '14',
    '15',
    '16',
    '17',
    '18',
    '19',
    '20',
    '21',
    '22',
    '23',
    '24',
    '25',
    '26',
    '27',
    '28',
    '29',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        color: Colors.black,
      ),
      height: 400,
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Episode',
                style: TextStyle(color: Colors.white, fontSize: 17),
              ),
              Transform.translate(
                offset: const Offset(10, -10), // Move up by 10 pixels
                child: IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: const Icon(
                    Icons.close,
                    color: Colors.white70,
                  ),
                ),
              ),
            ],
          ),
          const Row(
            children: [
              Text(
                "0 - 29",
                style: TextStyle(color: Colors.white),
              )
            ],
          ),
          const Divider(
            color: Colors.blueGrey,
            thickness: 1,
            indent: 0, // No left spacing
            endIndent: 0,
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            height: 260,
            margin: const EdgeInsets.only(top: 4),
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: EpisodeList(episode: episode), // Correct instantiation
            ),
          ),
        ],
      ),
    );
  }
}

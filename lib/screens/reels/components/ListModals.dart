import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reelies/utils/appColors.dart';

import '../VideoListScreen.dart';

class ListModals extends StatefulWidget {
  final List<String> urls;
  final int? initialSelectedIndex;

  const ListModals(
      {Key? key, required this.urls, required this.initialSelectedIndex})
      : super(key: key);

  @override
  State<ListModals> createState() => _ListModalsState();
}

class _ListModalsState extends State<ListModals> {
  int? _selectedIndex;

  @override
  void initState() {
    super.initState();
    // Set the selected index based on the initial argument passed
    _selectedIndex = widget
        .initialSelectedIndex; // Assume this is passed from VideoListScreen
  }

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
                offset: const Offset(10, -10),
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
          Row(
            children: [
              Text(
                "0-${widget.urls.length}",
                style: TextStyle(color: AppColors.colorWhiteHighEmp),
              ),
            ],
          ),
          const Divider(
            color: Colors.blueGrey,
            thickness: 1,
            indent: 0,
            endIndent: 0,
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            height: 260,
            margin: const EdgeInsets.only(top: 4),
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Wrap(
                spacing: 6,
                runSpacing: 6,
                children: List.generate(widget.urls.length, (index) {
                  bool isSelected = _selectedIndex == index;
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedIndex = index;
                      });
                      Future.delayed(Duration(milliseconds: 500), () {
                        Get.back(
                            result:
                                index); // Close modal and return selected index
                        // Get.to(() => VideoListScreen(urls: widget.urls));
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
                        child: Stack(alignment: Alignment.center, children: [
                          Text(
                            index == 0 ? "Trailer" : "${index}",
                            style: const TextStyle(
                                fontSize: 16, color: Colors.white),
                          ),
                          AnimatedPositioned(
                            duration: const Duration(milliseconds: 300),
                            bottom: isSelected ? 8 : -2,
                            left: 20,
                            child: Container(
                              width: 22,
                              height: 2.0,
                              decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(10)),
                            ),
                          ),
                        ]),
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

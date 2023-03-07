import 'package:flutter/material.dart';

class MusicItem extends StatelessWidget {
  final String image1;
  final String text1;
  final String text2;

  const MusicItem({
    Key? key,
    required this.image1,
    required this.text1,
    required this.text2,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Image(
              image: NetworkImage(image1),
              width: 80,
              height: 80,
            ),
            SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  text1,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                Text(text2),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    SizedBox(
                      width: 5,
                    ),
                  ],
                )
              ],
            ),
          ],
        ),
        SizedBox(
          height: 10,
        )
      ],
    );
  }
}

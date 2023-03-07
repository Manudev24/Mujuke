import 'package:flutter/material.dart';

class MusicItem extends StatelessWidget {
  final String image1;
  final String image2;
  final String text1;
  final String text2;
  final String text3;

  const MusicItem({
    Key? key,
    required this.image1,
    required this.image2,
    required this.text1,
    required this.text2,
    required this.text3,
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
                    Text('Sugerido por ${text3}'),
                    SizedBox(
                      width: 5,
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4.0),
                      child: Image(
                        image: NetworkImage(image2),
                        width: 20,
                        height: 20,
                      ),
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

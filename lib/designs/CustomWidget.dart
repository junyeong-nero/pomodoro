import 'package:flutter/material.dart';

import 'CustomTheme.dart';

class CustomWidget {
  CustomWidget();

  Column getTitle(String s) {
    return Column(
      children: [
        Text(
          s,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        SizedBox(
          width: 56,
          child: Divider(color: CustomTheme.currentTheme()[0]),
        )
      ],
    );
  }

  Card cardView(Icon icon, String content, String sub) {
    return Card(
        elevation: 8,
        color: CustomTheme.currentTheme()[4],
        child: Stack(
          children: [
            Container(
              width: 24,
              margin: const EdgeInsets.all(8),
              height: 24,
              child: icon,
            ),
            Container(
              alignment: Alignment.topRight,
              padding: const EdgeInsets.all(8),
              child: Text(content,
                  textAlign: TextAlign.right,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold)),
            ),
            Container(
              alignment: Alignment.bottomRight,
              padding: const EdgeInsets.all(8),
              child: Text(
                sub,
                textAlign: TextAlign.right,
                style:
                    const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              ),
            )
          ],
        ));
  }
}

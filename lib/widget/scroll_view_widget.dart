import 'package:flutter/material.dart';
import 'package:rapigo/other/colors_style.dart';

class ScrollViewWidget extends StatelessWidget {
  final String title;
  final StreamBuilder streamBuilder;

  ScrollViewWidget({
    this.title,
    this.streamBuilder
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
      child: DraggableScrollableSheet(
        initialChildSize: 0.075,
        maxChildSize: 0.5,
        minChildSize: 0.075,
        builder: (BuildContext context, ScrollController scrollController) {
          return Container(
            color: Colors.blue,
            child: SingleChildScrollView(
              controller: scrollController,
              child: Column(
                children: [
                  Container(
                    height: 60,
                    width: double.infinity,
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                          child: Icon(Icons.directions_bike, size: 25, color: Colores.Primary,),
                        ),
                        Text(
                          this.title,
                          style: TextStyle(
                            letterSpacing: 5,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colores.Primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    children: [this.streamBuilder],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
import 'package:flutter/material.dart';

class EventDescription extends StatelessWidget {
  final String description;

  const EventDescription({Key? key, required this.description})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Description",
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        SizedBox(
          height: height * 0.01,
        ),
        Text(
          description,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class CleanerRatingBar extends StatefulWidget {
  final double initialRating;
  final Function(double) onRatingChanged;

  const CleanerRatingBar({
    super.key,
    this.initialRating = 5,
    required this.onRatingChanged,
  });

  @override
  State<CleanerRatingBar> createState() => _CleanerRatingBarState();
}

class _CleanerRatingBarState extends State<CleanerRatingBar> {
  late double _rating;

  @override
  void initState() {
    super.initState();
    _rating = widget.initialRating;
  }

  @override
  Widget build(BuildContext context) {
    return RatingBar.builder(
      initialRating: _rating,
      minRating: 1,
      direction: Axis.horizontal,
      allowHalfRating: true,
      itemCount: 5,
      itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
      itemBuilder: (context, _) => const Icon(
        Icons.star,
        color: Colors.amber,
      ),
      onRatingUpdate: (rating) {
        setState(() {
          _rating = rating;
        });
        widget.onRatingChanged(rating);
      },
    );
  }
}

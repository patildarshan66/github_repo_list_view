import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class LoadingShimmer extends StatelessWidget {
  const LoadingShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Shimmer.fromColors(
          baseColor: Colors.grey.shade200,
          highlightColor: Colors.grey.shade300,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Card(
              elevation: 0,
              child: Container(
                height: 90.0,
                width: double.infinity,
                color: Colors.grey,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

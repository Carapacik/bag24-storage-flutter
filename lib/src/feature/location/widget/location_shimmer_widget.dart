import 'package:bag24/src/feature/shared_widgets/loading/shimmer.dart';
import 'package:flutter/material.dart';

class const LocationShimmerWidget({super.key}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Shimmer(
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 8,
        padding: const EdgeInsets.all(16),
        separatorBuilder: (context, index) => const SizedBox(height: 12),
        itemBuilder: (context, index) => const ShimmerLoading(inProgress: true, child: SizedBox(height: 84)),
      ),
    );
  }
}

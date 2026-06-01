import 'package:bag24/src/core/utils/extensions/extensions.dart';
import 'package:bag24/src/core/utils/layout/layout.dart';
import 'package:bag24/src/feature/shared_widgets/loading/shimmer.dart';
import 'package:flutter/material.dart';

class const OrderInitialProcessingWidget({super.key}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Shimmer(
      child: CustomScrollView(
        physics: const NeverScrollableScrollPhysics(),
        slivers: [
          SliverList(
            delegate: SliverChildListDelegate([
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    SafeArea(bottom: false, child: SizedBox(height: 56)),
                    ShimmerLoading(inProgress: true, child: SizedBox(height: 32, width: 180)),
                    SizedBox(height: 16),
                    ShimmerLoading(inProgress: true, child: SizedBox(height: 32, width: 200)),
                    SizedBox(height: 8),
                    ShimmerLoading(inProgress: true, child: SizedBox(height: 16, width: 240)),
                    SizedBox(height: 24),
                    ShimmerLoading(inProgress: true, child: SizedBox(height: 112, width: compactMaxWidth)),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              DecoratedBox(
                decoration: BoxDecoration(
                  color: context.colors.baseBgPrimary,
                  borderRadius: const BorderRadius.all(Radius.circular(24)),
                ),
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ShimmerLoading(inProgress: true, child: SizedBox(height: 24, width: 140)),
                      SizedBox(height: 16),
                      ShimmerLoading(inProgress: true, child: SizedBox(height: 32, width: 300)),
                      SizedBox(height: 24),
                      ShimmerLoading(inProgress: true, child: SizedBox(height: 24, width: 300)),
                      SizedBox(height: 24),
                      ShimmerLoading(inProgress: true, child: SizedBox(height: 24, width: 300)),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 8),
              DecoratedBox(
                decoration: BoxDecoration(
                  color: context.colors.baseBgPrimary,
                  borderRadius: const BorderRadius.all(Radius.circular(24)),
                ),
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ShimmerLoading(inProgress: true, child: SizedBox(height: 24, width: 140)),
                      SizedBox(height: 16),
                      ShimmerLoading(inProgress: true, child: SizedBox(height: 110, width: double.infinity)),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 8),
              DecoratedBox(
                decoration: BoxDecoration(
                  color: context.colors.baseBgPrimary,
                  borderRadius: const BorderRadius.all(Radius.circular(24)),
                ),
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ShimmerLoading(inProgress: true, child: SizedBox(height: 24, width: 140)),
                      SizedBox(height: 16),
                      ShimmerLoading(inProgress: true, child: SizedBox(height: 50, width: double.infinity)),
                      SizedBox(height: 16),
                      ShimmerLoading(inProgress: true, child: SizedBox(height: 50, width: double.infinity)),
                      SizedBox(height: 16),
                      ShimmerLoading(inProgress: true, child: SizedBox(height: 50, width: double.infinity)),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 8),
              DecoratedBox(
                decoration: BoxDecoration(
                  color: context.colors.baseBgPrimary,
                  borderRadius: const BorderRadius.all(Radius.circular(24)),
                ),
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ShimmerLoading(inProgress: true, child: SizedBox(height: 24, width: 140)),
                      SizedBox(height: 16),
                      ShimmerLoading(inProgress: true, child: SizedBox(height: 24, width: double.infinity)),
                      SizedBox(height: 24),
                      ShimmerLoading(inProgress: true, child: SizedBox(height: 24, width: double.infinity)),
                      SizedBox(height: 24),
                      ShimmerLoading(inProgress: true, child: SizedBox(height: 24, width: double.infinity)),
                    ],
                  ),
                ),
              ),
            ]),
          ),
        ],
      ),
    );
  }
}

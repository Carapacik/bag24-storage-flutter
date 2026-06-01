import 'package:bag24/src/core/constant/generated/assets.gen.dart';
import 'package:bag24/src/core/utils/extensions/extensions.dart';
import 'package:bag24/src/core/utils/layout/layout.dart';
import 'package:bag24/src/feature/authentication/widget/authentication_scope.dart';
import 'package:bag24/src/feature/order/model/order_item.dart';
import 'package:bag24/src/feature/orders/bloc/active_orders/active_orders_bloc.dart';
import 'package:bag24/src/feature/orders/bloc/inactive_orders/inactive_orders_bloc.dart';
import 'package:bag24/src/feature/orders/widget/order_item_card.dart';
import 'package:bag24/src/feature/shared_widgets/button/gradient_button.dart';
import 'package:bag24/src/feature/shared_widgets/button/toggle_buttons.dart';
import 'package:bag24/src/feature/shared_widgets/button/tonal_button.dart';
import 'package:bag24/src/feature/shared_widgets/loading/custom_circular_progress_indicator.dart';
import 'package:bag24/src/feature/shared_widgets/loading/shimmer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

class const OrdersScreen({super.key}) extends StatefulWidget {
  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState() extends State<OrdersScreen> with SingleTickerProviderStateMixin {
  late final TabController _tabController = TabController(length: 2, vsync: this);

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.baseBgSecondary,
      body: NestedScrollView(
        physics: const NeverScrollableScrollPhysics(),
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverAppBar(
            title: Text(context.l10n.orders, style: context.textStyles.largeTitleEmphasized),
            pinned: true,
            stretch: true,
            centerTitle: false,
            collapsedHeight: kToolbarHeight,
            expandedHeight: kToolbarHeight,
            backgroundColor: context.colors.baseBgPrimary,
          ),
          SliverPersistentHeader(pinned: true, delegate: _ToggleButtonsHeader(tabController: _tabController)),
        ],
        body: _OrdersBody(tabController: _tabController),
      ),
    );
  }
}

class _ToggleButtonsHeader({required final TabController tabController}) extends SliverPersistentHeaderDelegate {
  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(24)),
        color: context.colors.baseBgPrimary,
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 1, 16, 15),
        child: CustomToggleButtons(
          initialIndex: 0,
          toggleItems: [
            (
              onTap: () => tabController.animateTo(0),
              text: context.l10n.active,
              suffixIcon: SvgPicture.asset(
                tabController.index == 0 ? Assets.svg.flashActive.path : Assets.svg.flash.path,
                height: 20,
                width: 20,
                colorFilter: tabController.index == 0
                    ? null
                    : ColorFilter.mode(context.colors.iconTertiary, BlendMode.srcIn),
              ),
            ),
            (
              onTap: () => tabController.animateTo(1),
              text: context.l10n.closed,
              suffixIcon: SvgPicture.asset(
                tabController.index == 1 ? Assets.svg.archiveActive.path : Assets.svg.archive.path,
                height: 20,
                width: 20,
                colorFilter: tabController.index == 1
                    ? null
                    : ColorFilter.mode(context.colors.iconTertiary, BlendMode.srcIn),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  double get maxExtent => 56 + 16;

  @override
  double get minExtent => 56 + 16;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => true;
}

class const _OrdersBody({required final TabController tabController}) extends StatefulWidget {
  @override
  State<_OrdersBody> createState() => _OrdersBodyState();
}

class _OrdersBodyState() extends State<_OrdersBody> {
  late final _activeScrollController = ScrollController();
  late final _inactiveScrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    final bool isAuthenticated = AuthenticationScope.userOf(context, listen: false).isAuthenticated;
    if (isAuthenticated) {
      context.read<ActiveOrdersBloc>().add(const ActiveOrdersEvent.start());
      context.read<InactiveOrdersBloc>().add(const InactiveOrdersEvent.start());
    }
    _activeScrollController.addListener(_onScrollActive);
    _inactiveScrollController.addListener(_onScrollInactive);
  }

  void _onScrollActive() {
    if (_isBottomActive) {
      context.read<ActiveOrdersBloc>().add(const ActiveOrdersEvent.fetched());
    }
  }

  bool get _isBottomActive {
    final ActiveOrdersBloc bloc = context.read<ActiveOrdersBloc>();
    if (!_activeScrollController.hasClients || bloc.state.hasReachedMax) {
      return false;
    }
    final double maxScroll = _activeScrollController.position.maxScrollExtent;
    final double currentScroll = _activeScrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  void _onScrollInactive() {
    if (_isBottomInactive) {
      context.read<InactiveOrdersBloc>().add(const InactiveOrdersEvent.fetched());
    }
  }

  bool get _isBottomInactive {
    final InactiveOrdersBloc bloc = context.read<InactiveOrdersBloc>();
    if (!_inactiveScrollController.hasClients || bloc.state.hasReachedMax) {
      return false;
    }
    final double maxScroll = _inactiveScrollController.position.maxScrollExtent;
    final double currentScroll = _inactiveScrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  @override
  void dispose() {
    _activeScrollController.removeListener(_onScrollActive);
    _inactiveScrollController.removeListener(_onScrollInactive);
    _activeScrollController.dispose();
    _inactiveScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isAuthenticated = AuthenticationScope.userOf(context).isAuthenticated;
    return TabBarView(
      physics: const NeverScrollableScrollPhysics(),
      controller: widget.tabController,
      children: isAuthenticated
          ? [
              BlocBuilder<ActiveOrdersBloc, ActiveOrdersState>(
                builder: (context, state) {
                  return _OrdersContent(
                    orders: state.orders,
                    isActive: true,
                    scrollController: _activeScrollController,
                    inProgress: state.inProgress,
                    isFailure: state.isFailure,
                    isFetchFailure: state.isFetchFailure,
                    hasReachedMax: state.hasReachedMax,
                    onFetch: () => context.read<ActiveOrdersBloc>().add(const ActiveOrdersEvent.fetched()),
                  );
                },
              ),
              BlocBuilder<InactiveOrdersBloc, InactiveOrdersState>(
                builder: (context, state) {
                  return _OrdersContent(
                    orders: state.orders,
                    isActive: false,
                    scrollController: _inactiveScrollController,
                    inProgress: state.inProgress,
                    isFailure: state.isFailure,
                    isFetchFailure: state.isFetchFailure,
                    hasReachedMax: state.hasReachedMax,
                    onFetch: () => context.read<InactiveOrdersBloc>().add(const InactiveOrdersEvent.fetched()),
                  );
                },
              ),
            ]
          : const [_EmptyOrdersBody(isActive: true), _EmptyOrdersBody()],
    );
  }
}

class const _OrdersContent({
  required final List<OrderItem> orders,
  required final bool isActive,
  required final ScrollController scrollController,
  required final bool inProgress,
  required final bool isFailure,
  required final bool isFetchFailure,
  required final bool hasReachedMax,
  required final VoidCallback onFetch,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    if (inProgress) {
      return const _LoadingBody();
    }
    if (isFailure) {
      return _FailureLoadingBody(isActive: isActive);
    }
    if (orders.isEmpty) {
      return _EmptyOrdersBody(isActive: isActive);
    }
    return RefreshIndicator(
      onRefresh: () async {
        context.read<ActiveOrdersBloc>().add(const ActiveOrdersEvent.start());
        context.read<InactiveOrdersBloc>().add(const InactiveOrdersEvent.start());
      },
      child: ListView.separated(
        padding: EdgeInsets.fromLTRB(16, 16, 16, 16 + MediaQuery.paddingOf(context).bottom),
        physics: const AlwaysScrollableScrollPhysics(),
        controller: scrollController,
        itemCount: orders.length + (!hasReachedMax || isFetchFailure ? 1 : 0),
        separatorBuilder: (context, index) => const SizedBox(height: 8),
        itemBuilder: (context, index) {
          if (isFetchFailure && index == orders.length) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    context.l10n.failedToLoad,
                    style: context.textStyles.subheadlineRegular,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  CustomTonalButton.compact(
                    onPressed: onFetch,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(context.l10n.update),
                        const SizedBox(width: 8),
                        SvgPicture.asset(
                          Assets.svg.update.path,
                          height: 16,
                          width: 16,
                          colorFilter: ColorFilter.mode(context.colors.iconPrimaryInverse, BlendMode.srcIn),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }
          if (!hasReachedMax && index == orders.length) {
            return const Padding(padding: EdgeInsets.symmetric(vertical: 24), child: CustomLoadingSpinner());
          }
          return OrderItemCard(order: orders[index]);
        },
      ),
    );
  }
}

class const _EmptyOrdersBody({final bool isActive = false}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final WindowSize windowSize = WindowSizeScope.of(context);
    final double dimension = windowSize.maybeMap(compact: () => 140.0, orElse: () => 160.0);
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Spacer(),
          Image.asset(Assets.images.reports.path, height: dimension, width: dimension),
          const SizedBox(height: 24),
          Text(
            context.l10n.youHaveNoOrdersYet,
            style: context.textStyles.title2Emphasized,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            isActive
                ? context.l10n.thereWillBeOrdersAndRequests
                : context.l10n.thereWillBecompletedAndCancelledOrdersAndRequests,
            style: context.textStyles.bodyRegular,
            textAlign: TextAlign.center,
          ),
          const Spacer(flex: 2),
        ],
      ),
    );
  }
}

class const _FailureLoadingBody({required final bool isActive}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(context.l10n.failedToUploadData, style: context.textStyles.bodyRegular, textAlign: TextAlign.center),
          const SizedBox(height: 60),
          GradientElevatedButton(
            onPressed: () => isActive
                ? context.read<ActiveOrdersBloc>().add(const ActiveOrdersEvent.start())
                : context.read<InactiveOrdersBloc>().add(const InactiveOrdersEvent.start()),
            text: context.l10n.tryAgain,
          ),
        ],
      ),
    );
  }
}

class const _LoadingBody() extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Shimmer(
      child: ListView.separated(
        padding: EdgeInsets.fromLTRB(16, 16, 16, 16 + MediaQuery.paddingOf(context).bottom),
        physics: const NeverScrollableScrollPhysics(),
        primary: false,
        itemCount: 10,
        separatorBuilder: (context, index) => const SizedBox(height: 8),
        itemBuilder: (context, index) => SizedBox(
          height: 184,
          child: DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(24)),
              color: context.colors.baseBgPrimary,
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ShimmerLoading(inProgress: true, child: SizedBox(width: 150, height: 20)),
                      ShimmerLoading(inProgress: true, child: SizedBox(width: 100, height: 24)),
                    ],
                  ),
                  const SizedBox(height: 4),
                  const ShimmerLoading(inProgress: true, child: SizedBox(width: 100, height: 24)),
                  const SizedBox(height: 8),
                  const ShimmerLoading(inProgress: true, child: SizedBox(width: 300, height: 20)),
                  const SizedBox(height: 20),
                  Row(
                    children: List.generate(
                      3,
                      (index) => const Padding(
                        padding: EdgeInsets.only(right: 6),
                        child: ShimmerLoading(inProgress: true, child: SizedBox(width: 44, height: 44)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

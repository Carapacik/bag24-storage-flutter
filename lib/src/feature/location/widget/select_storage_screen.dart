import 'dart:async';

import 'package:bag24/src/core/constant/generated/assets.gen.dart';
import 'package:bag24/src/core/router/routes.dart';
import 'package:bag24/src/core/utils/extensions/extensions.dart';
import 'package:bag24/src/core/utils/layout/layout.dart';
import 'package:bag24/src/feature/authentication/widget/authentication_scope.dart';
import 'package:bag24/src/feature/home/bloc/banners/banners_bloc.dart';
import 'package:bag24/src/feature/location/bloc/select_storage/select_storage_bloc.dart';
import 'package:bag24/src/feature/location/data/storage_store.dart';
import 'package:bag24/src/feature/location/model/storage_model.dart';
import 'package:bag24/src/feature/location/widget/location_shimmer_widget.dart';
import 'package:bag24/src/feature/shared_widgets/base/app_bar.dart';
import 'package:bag24/src/feature/shared_widgets/loading/shimmer.dart';
import 'package:bag24/src/feature/shared_widgets/text_field/search_bar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class const SelectStorageScreen({super.key}) extends StatefulWidget {
  @override
  State<SelectStorageScreen> createState() => _SelectStorageScreenState();
}

class _SelectStorageScreenState() extends State<SelectStorageScreen> {
  late final TextEditingController _controller = TextEditingController();
  late final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _controller.addListener(_onSearch);
  }

  void _onSearch() {
    final SelectStorageBloc bloc = context.read<SelectStorageBloc>();
    if (bloc.state.inProgress && bloc.state.storages.isEmpty) {
      return;
    }
    final String text = _controller.text.trim().toLowerCase();
    bloc.add(SelectStorageEvent.search(text));
  }

  void _onScroll() {
    if (_isBottom) {
      context.read<SelectStorageBloc>().add(const SelectStorageEvent.fetched());
    }
  }

  bool get _isBottom {
    final SelectStorageBloc bloc = context.read<SelectStorageBloc>();
    if (!_scrollController.hasClients || bloc.state.hasReachedMax) {
      return false;
    }
    final double maxScroll = _scrollController.position.maxScrollExtent;
    final double currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    _controller
      ..removeListener(_onSearch)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final WindowSize windowSize = WindowSizeScope.of(context);
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: CustomAppBar(
          title: Column(
            crossAxisAlignment: windowSize.isCompact ? CrossAxisAlignment.center : CrossAxisAlignment.start,
            children: [
              Text(context.l10n.chooseStorageCamera, style: context.textStyles.bodyEmphasized),
              Text(
                context.l10n.step1of2,
                style: context.textStyles.caption1Regular.copyWith(color: context.colors.textTertiary),
              ),
            ],
          ),
          backgroundColor: context.colors.baseBgSecondary,
        ),
        backgroundColor: context.colors.baseBgSecondary,
        body: BlocListener<SelectStorageBloc, SelectStorageState>(
          listenWhen: (_, current) => current.maybeMap(success: (_) => true, orElse: () => false),
          listener: (context, state) {
            state.mapOrNull(
              success: (s) {
                if (s.position != null) {
                  context.read<BannersBloc>().add(BannersEvent.updateBookBanner(s.position!));
                }
              },
            );
          },
          child: Stack(
            children: [
              Column(
                children: [
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: ListenableBuilder(
                      listenable: _controller,
                      builder: (context, child) =>
                          CustomSearchBar(controller: _controller, hintText: context.l10n.airportOrIata),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: Material(
                      color: context.colors.baseBgPrimary,
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
                      clipBehavior: Clip.antiAlias,
                      child: SizedBox(
                        width: double.infinity,
                        child: _ListWidget(scrollController: _scrollController),
                      ),
                    ),
                  ),
                ],
              ),
              LinearProgressIndicator(
                value: 0.1,
                minHeight: 4,
                backgroundColor: context.colors.buttonBgTertiary,
                valueColor: AlwaysStoppedAnimation(context.colors.progressBar),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class const _ListWidget({required final ScrollController scrollController}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final WindowSize windowSize = WindowSizeScope.of(context);
    final double imageDimension = windowSize.maybeMap(compact: () => 160.0, orElse: () => 200.0);
    return BlocBuilder<SelectStorageBloc, SelectStorageState>(
      builder: (context, state) {
        if (state.inProgress) {
          return const LocationShimmerWidget();
        }
        if (state.storages.isEmpty) {
          return Column(
            children: [
              const Spacer(),
              Image.asset(Assets.images.refresh.path, height: imageDimension, width: imageDimension),
              const SizedBox(height: 12),
              Text(context.l10n.noSuitableOptions, style: context.textStyles.title2Emphasized),
              const SizedBox(height: 12),
              Text(
                context.l10n.tryToFindAnotherAirport,
                style: context.textStyles.bodyRegular.copyWith(color: context.colors.textSecondary),
              ),
              const Spacer(flex: 2),
            ],
          );
        }
        return ListView.separated(
          shrinkWrap: true,
          itemCount: state.storages.length,
          controller: scrollController,
          padding: EdgeInsets.fromLTRB(16, 16, 16, 16 + MediaQuery.paddingOf(context).bottom),
          separatorBuilder: (context, index) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final Storage storage = state.storages[index];
            return Material(
              borderRadius: const BorderRadius.all(Radius.circular(16)),
              color: context.colors.cellBgPrimary,
              clipBehavior: Clip.antiAlias,
              child: InkWell(
                onTap: () async {
                  unawaited(context.dependencies.analytics.luggageStorageTracker.trackLuggageStorageSelected(storage));
                  if (AuthenticationScope.userOf(context, listen: false).isAuthenticated) {
                    await context.pushNamed(Routes.checkInLuggageOrder.name, pathParameters: {'storageId': storage.id});
                  } else {
                    StorageStore.instance.storageId = storage.id;
                    await context.pushNamed(Routes.signIn.name);
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: CachedNetworkImage(
                          width: 52,
                          height: 52,
                          fit: BoxFit.cover,
                          imageUrl: storage.photoUrl,
                          placeholder: (context, url) => const Shimmer(
                            child: ShimmerLoading(inProgress: true, child: SizedBox(height: 52, width: 52)),
                          ),
                          errorWidget: (context, url, error) => Container(
                            width: 52,
                            height: 52,
                            decoration: BoxDecoration(
                              color: context.colors.iconSecondary,
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              storage.fullName,
                              style: context.textStyles.bodyRegular.copyWith(color: context.colors.textPrimary),
                            ),
                            if (storage.locationDescription.isNotEmpty) ...[
                              const SizedBox(height: 4),
                              Text(
                                storage.locationDescription,
                                style: context.textStyles.footnoteRegular.copyWith(color: context.colors.textTertiary),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}

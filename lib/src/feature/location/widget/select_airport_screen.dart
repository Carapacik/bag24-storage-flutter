import 'package:bag24/src/core/constant/generated/assets.gen.dart';
import 'package:bag24/src/core/utils/extensions/extensions.dart';
import 'package:bag24/src/core/utils/layout/layout.dart';
import 'package:bag24/src/feature/home/bloc/banners/banners_bloc.dart';
import 'package:bag24/src/feature/location/bloc/select_airport/select_airport_bloc.dart';
import 'package:bag24/src/feature/location/model/location_model.dart';
import 'package:bag24/src/feature/location/widget/location_shimmer_widget.dart';
import 'package:bag24/src/feature/shared_widgets/base/app_bar.dart';
import 'package:bag24/src/feature/shared_widgets/loading/shimmer.dart';
import 'package:bag24/src/feature/shared_widgets/text_field/search_bar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class const SelectAirportScreen({super.key}) extends StatefulWidget {
  @override
  State<SelectAirportScreen> createState() => _SelectAirportScreenState();
}

class _SelectAirportScreenState() extends State<SelectAirportScreen> {
  late final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onSearch);
  }

  void _onSearch() {
    final SelectAirportBloc bloc = context.read<SelectAirportBloc>();
    if (bloc.state.inProgress && bloc.state.locations.isEmpty) {
      return;
    }
    final String text = _controller.text.trim().toLowerCase();
    bloc.add(SelectAirportEvent.search(text));
  }

  @override
  void dispose() {
    _controller
      ..removeListener(_onSearch)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: CustomAppBar(titleText: context.l10n.airport, backgroundColor: context.colors.baseBgSecondary),
        backgroundColor: context.colors.baseBgSecondary,
        body: BlocListener<SelectAirportBloc, SelectAirportState>(
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
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: ListenableBuilder(
                  listenable: _controller,
                  builder: (context, child) =>
                      CustomSearchBar(hintText: context.l10n.airportSearch, controller: _controller),
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: Material(
                  color: context.colors.baseBgPrimary,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
                  clipBehavior: Clip.antiAlias,
                  child: const SizedBox(width: double.infinity, child: _ListWidget()),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class const _ListWidget() extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final WindowSize windowSize = WindowSizeScope.of(context);
    final double imageDimension = windowSize.maybeMap(compact: () => 160.0, orElse: () => 200.0);
    return BlocBuilder<SelectAirportBloc, SelectAirportState>(
      builder: (context, state) {
        if (state.inProgress) {
          return const LocationShimmerWidget();
        }
        final List<Location> list = state.searchQuery.isEmpty ? state.locations : state.filteredLocations;
        if (list.isEmpty) {
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
          itemCount: list.length,
          padding: EdgeInsets.fromLTRB(16, 16, 16, 16 + MediaQuery.paddingOf(context).bottom),
          separatorBuilder: (context, index) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final Location item = list[index];
            return Material(
              borderRadius: const BorderRadius.all(Radius.circular(16)),
              color: context.colors.cellBgPrimary,
              clipBehavior: Clip.antiAlias,
              child: InkWell(
                onTap: () => context.pop(item),
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
                          imageUrl: item.photoUrl,
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
                          children: [
                            Text(
                              '(${item.shortName}) ${item.name}',
                              style: context.textStyles.bodyRegular.copyWith(color: context.colors.textPrimary),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              item.city,
                              style: context.textStyles.footnoteRegular.copyWith(color: context.colors.textSecondary),
                            ),
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

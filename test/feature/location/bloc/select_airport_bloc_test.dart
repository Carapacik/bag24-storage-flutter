import 'package:bag24/src/feature/location/bloc/select_airport/select_airport_bloc.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../example/location.dart';
import '../../../example/position.dart';
import '../../../mock/mock.mocks.dart';

void main() {
  late MockIPermissionsRepository permissionsRepository;
  late MockILocationRepository locationRepository;
  late MockIGeolocationRepository geolocationRepository;
  late SelectAirportBloc bloc;

  setUp(() {
    permissionsRepository = MockIPermissionsRepository();
    locationRepository = MockILocationRepository();
    geolocationRepository = MockIGeolocationRepository();

    bloc = SelectAirportBloc(
      permissionsRepository: permissionsRepository,
      locationRepository: locationRepository,
      geolocationRepository: geolocationRepository,
    );
  });

  group('SelectAirportBloc', () {
    test('initial state is processing with empty locations', () {
      expect(bloc.state, const SelectAirportState.processing(locations: [], filteredLocations: [], searchQuery: ''));
    });

    blocTest<SelectAirportBloc, SelectAirportState>(
      'start event emits success when location permission is granted',
      setUp: () {
        when(geolocationRepository.requestPermission()).thenAnswer((_) async => {});
        when(permissionsRepository.checkLocationPermission()).thenAnswer((_) async => true);
        when(geolocationRepository.getCurrentPosition()).thenAnswer((_) async => mockPosition);
        when(locationRepository.getLocations(currentPosition: mockPosition)).thenAnswer((_) async => mockLocations);
      },
      build: () => bloc,
      act: (bloc) => bloc.add(const SelectAirportEvent.start()),
      expect: () => [
        const SelectAirportState.processing(locations: [], filteredLocations: [], searchQuery: ''),
        SelectAirportState.success(
          locations: mockLocations,
          filteredLocations: [],
          searchQuery: '',
          position: mockPosition,
        ),
        SelectAirportState.idle(locations: mockLocations, filteredLocations: [], searchQuery: ''),
      ],
      verify: (_) {
        verify(geolocationRepository.requestPermission()).called(1);
        verify(permissionsRepository.checkLocationPermission()).called(1);
        verify(geolocationRepository.getCurrentPosition()).called(1);
        verify(locationRepository.getLocations(currentPosition: mockPosition)).called(1);
      },
    );

    blocTest<SelectAirportBloc, SelectAirportState>(
      'start event emits success when location permission is denied',
      setUp: () {
        when(geolocationRepository.requestPermission()).thenAnswer((_) async => {});
        when(permissionsRepository.checkLocationPermission()).thenAnswer((_) async => false);
        when(locationRepository.getLocations()).thenAnswer((_) async => mockLocations);
      },
      build: () => bloc,
      act: (bloc) => bloc.add(const SelectAirportEvent.start()),
      expect: () => [
        const SelectAirportState.processing(locations: [], filteredLocations: [], searchQuery: ''),
        SelectAirportState.success(locations: mockLocations, filteredLocations: [], searchQuery: ''),
        SelectAirportState.idle(locations: mockLocations, filteredLocations: [], searchQuery: ''),
      ],
      verify: (_) {
        verify(geolocationRepository.requestPermission()).called(1);
        verify(permissionsRepository.checkLocationPermission()).called(1);
        verifyNever(geolocationRepository.getCurrentPosition());
        verify(locationRepository.getLocations()).called(1);
      },
    );

    // TODO(akozlov): разобраться
    // blocTest<SelectAirportBloc, SelectAirportState>(
    //   'start event emits failure on error',
    //   setUp: () {
    //     when(geolocationRepository.requestPermission()).thenThrow(Exception('Test error'));
    //   },
    //   build: () => bloc,
    //   act: (bloc) => bloc.add(const SelectAirportEvent.start()),
    //   expect: () => [
    //     const SelectAirportState.processing(locations: [], filteredLocations: [], searchQuery: ''),
    //     const SelectAirportState.failure(
    //       locations: [],
    //       filteredLocations: [],
    //       searchQuery: '',
    //       exception: AppException.unknown('Exception: Test error'),
    //     ),
    //     const SelectAirportState.idle(locations: [], filteredLocations: [], searchQuery: ''),
    //   ],
    // );

    blocTest<SelectAirportBloc, SelectAirportState>(
      'search event filters locations correctly',
      seed: () => SelectAirportState.idle(locations: mockLocations, filteredLocations: [], searchQuery: ''),
      build: () => bloc,
      act: (bloc) => bloc.add(const SelectAirportEvent.search('Moscow')),
      expect: () => [
        SelectAirportState.processing(locations: mockLocations, filteredLocations: [], searchQuery: 'moscow'),
        SelectAirportState.idle(
          locations: mockLocations,
          filteredLocations: mockLocations
              .where(
                (location) =>
                    location.name.toLowerCase().contains('moscow') ||
                    location.shortName.toLowerCase().contains('moscow') ||
                    location.city.toLowerCase().contains('moscow'),
              )
              .toList(),
          searchQuery: 'moscow',
        ),
      ],
    );
  });
}

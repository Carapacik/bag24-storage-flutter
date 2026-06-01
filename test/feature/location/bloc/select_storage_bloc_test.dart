import 'package:bag24/src/feature/location/bloc/select_storage/select_storage_bloc.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../example/position.dart';
import '../../../example/storage.dart';
import '../../../mock/mock.mocks.dart';

void main() {
  late MockIPermissionsRepository permissionsRepository;
  late MockIStorageRepository storageRepository;
  late MockIGeolocationRepository geolocationRepository;
  late SelectStorageBloc bloc;

  setUp(() {
    permissionsRepository = MockIPermissionsRepository();
    storageRepository = MockIStorageRepository();
    geolocationRepository = MockIGeolocationRepository();

    bloc = SelectStorageBloc(
      permissionsRepository: permissionsRepository,
      storageRepository: storageRepository,
      geolocationRepository: geolocationRepository,
    );
  });

  group('SelectStorageBloc', () {
    test('initial state is processing with empty storages', () {
      expect(bloc.state, const SelectStorageState.processing(storages: [], searchQuery: ''));
    });

    blocTest<SelectStorageBloc, SelectStorageState>(
      'start emits success when location permission is granted',
      setUp: () {
        when(geolocationRepository.requestPermission()).thenAnswer((_) async => {});
        when(permissionsRepository.checkLocationPermission()).thenAnswer((_) async => true);
        when(geolocationRepository.getCurrentPosition()).thenAnswer((_) async => mockPosition);
        when(storageRepository.getStorages(position: mockPosition)).thenAnswer((_) async => mockStorages);
      },
      build: () => bloc,
      act: (bloc) => bloc.add(const SelectStorageEvent.start()),
      expect: () => [
        const SelectStorageState.processing(storages: [], searchQuery: ''),
        SelectStorageState.success(
          storages: mockStorages,
          searchQuery: '',
          position: mockPosition,
          hasReachedMax: true,
        ),
        SelectStorageState.idle(storages: mockStorages, searchQuery: '', position: mockPosition, hasReachedMax: true),
      ],
      verify: (_) {
        verify(geolocationRepository.requestPermission()).called(1);
        verify(permissionsRepository.checkLocationPermission()).called(1);
        verify(geolocationRepository.getCurrentPosition()).called(1);
        verify(storageRepository.getStorages(position: mockPosition)).called(1);
      },
    );

    blocTest<SelectStorageBloc, SelectStorageState>(
      'start emits success when location permission is denied',
      setUp: () {
        when(geolocationRepository.requestPermission()).thenAnswer((_) async => {});
        when(permissionsRepository.checkLocationPermission()).thenAnswer((_) async => false);
        when(storageRepository.getStorages()).thenAnswer((_) async => mockStorages);
      },
      build: () => bloc,
      act: (bloc) => bloc.add(const SelectStorageEvent.start()),
      expect: () => [
        const SelectStorageState.processing(storages: [], searchQuery: ''),
        SelectStorageState.success(storages: mockStorages, searchQuery: '', hasReachedMax: true),
        SelectStorageState.idle(storages: mockStorages, searchQuery: '', hasReachedMax: true),
      ],
      verify: (_) {
        verify(geolocationRepository.requestPermission()).called(1);
        verify(permissionsRepository.checkLocationPermission()).called(1);
        verifyNever(geolocationRepository.getCurrentPosition());
        verify(storageRepository.getStorages()).called(1);
      },
    );

    // TODO(akozlov): разобраться
    // blocTest<SelectStorageBloc, SelectStorageState>(
    //   'start emits failure on error',
    //   setUp: () {
    //     when(geolocationRepository.requestPermission()).thenThrow(Exception('Test error'));
    //   },
    //   build: () => bloc,
    //   act: (bloc) => bloc.add(const SelectStorageEvent.start()),
    //   expect: () => [
    //     const SelectStorageState.processing(storages: [], searchQuery: ''),
    //     const SelectStorageState.failure(
    //       storages: [],
    //       searchQuery: '',
    //       position: null,
    //       hasReachedMax: false,
    //       exception: AppException.unknown('Exception: Test error'),
    //     ),
    //     const SelectStorageState.idle(
    //       storages: [],
    //       searchQuery: '',
    //       position: null,
    //       hasReachedMax: false,
    //     ),
    //   ],
    // );

    blocTest<SelectStorageBloc, SelectStorageState>(
      'search emits success with filtered storages',
      setUp: () {
        when(storageRepository.getStorages(searchQuery: 'test')).thenAnswer((_) async => [mockStorages[0]]);
      },
      build: () => bloc,
      act: (bloc) => bloc.add(const SelectStorageEvent.search('test')),
      expect: () => [
        const SelectStorageState.processing(storages: [], searchQuery: 'test'),
        SelectStorageState.success(storages: [mockStorages[0]], searchQuery: 'test'),
        SelectStorageState.idle(storages: [mockStorages[0]], searchQuery: 'test'),
      ],
    );

    // TODO(akozlov): разобраться
    // blocTest<SelectStorageBloc, SelectStorageState>(
    //   'search emits failure on error',
    //   setUp: () {
    //     when(storageRepository.getStorages(searchQuery: 'test')).thenThrow(Exception('Test error'));
    //   },
    //   build: () => bloc,
    //   act: (bloc) => bloc.add(const SelectStorageEvent.search('test')),
    //   expect: () => [
    //     const SelectStorageState.processing(storages: [], searchQuery: 'test'),
    //     const SelectStorageState.failure(
    //       storages: [],
    //       searchQuery: 'test',
    //       position: null,
    //       hasReachedMax: false,
    //       exception: AppException.unknown('Exception: Test error'),
    //     ),
    //     const SelectStorageState.idle(
    //       storages: [],
    //       searchQuery: 'test',
    //       position: null,
    //       hasReachedMax: false,
    //     ),
    //   ],
    // );

    blocTest<SelectStorageBloc, SelectStorageState>(
      'fetched emits success with more storages',
      setUp: () {
        when(storageRepository.getStorages(offset: 1)).thenAnswer((_) async => [mockStorages[1]]);
      },
      seed: () => SelectStorageState.success(storages: [mockStorages[0]], searchQuery: ''),
      build: () => bloc,
      act: (bloc) => bloc.add(const SelectStorageEvent.fetched()),
      expect: () => [
        SelectStorageState.fetching(storages: [mockStorages[0]], searchQuery: ''),
        SelectStorageState.success(storages: [mockStorages[0], mockStorages[1]], searchQuery: ''),
        SelectStorageState.idle(storages: [mockStorages[0], mockStorages[1]], searchQuery: ''),
      ],
    );

    // TODO(akozlov): разобраться
    // blocTest<SelectStorageBloc, SelectStorageState>(
    //   'fetched emits failure on error',
    //   setUp: () {
    //     when(storageRepository.getStorages(offset: 1)).thenThrow(Exception('Test error'));
    //   },
    //   seed: () => SelectStorageState.success(
    //     storages: [mockStorages[0]],
    //     searchQuery: '',
    //     position: null,
    //     hasReachedMax: false,
    //   ),
    //   build: () => bloc,
    //   act: (bloc) => bloc.add(const SelectStorageEvent.fetched()),
    //   expect: () => [
    //     SelectStorageState.fetching(
    //       storages: [mockStorages[0]],
    //       searchQuery: '',
    //       position: null,
    //       hasReachedMax: false,
    //     ),
    //     SelectStorageState.failure(
    //       storages: [mockStorages[0]],
    //       searchQuery: '',
    //       position: null,
    //       hasReachedMax: false,
    //       exception: const AppException.unknown('Exception: Test error'),
    //     ),
    //     SelectStorageState.idle(
    //       storages: [mockStorages[0]],
    //       searchQuery: '',
    //       position: null,
    //       hasReachedMax: false,
    //     ),
    //   ],
    // );

    blocTest<SelectStorageBloc, SelectStorageState>(
      'fetched does nothing when hasReachedMax is true',
      seed: () => SelectStorageState.success(storages: mockStorages, searchQuery: '', hasReachedMax: true),
      build: () => bloc,
      act: (bloc) => bloc.add(const SelectStorageEvent.fetched()),
      expect: () => <SelectStorageState>[],
      // Не должно быть никаких эмитов
      verify: (_) {
        verifyNever(storageRepository.getStorages());
      },
    );
  });
}

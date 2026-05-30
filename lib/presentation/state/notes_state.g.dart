// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notes_state.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(blockRepository)
final blockRepositoryProvider = BlockRepositoryProvider._();

final class BlockRepositoryProvider extends $FunctionalProvider<
    IsarBlockRepository,
    IsarBlockRepository,
    IsarBlockRepository> with $Provider<IsarBlockRepository> {
  BlockRepositoryProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'blockRepositoryProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$blockRepositoryHash();

  @$internal
  @override
  $ProviderElement<IsarBlockRepository> $createElement(
          $ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  IsarBlockRepository create(Ref ref) {
    return blockRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(IsarBlockRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<IsarBlockRepository>(value),
    );
  }
}

String _$blockRepositoryHash() => r'f248ce93c55e4ccf92218d372eaa424db377a3ff';

@ProviderFor(Pages)
final pagesProvider = PagesProvider._();

final class PagesProvider
    extends $AsyncNotifierProvider<Pages, List<domain.Page>> {
  PagesProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'pagesProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$pagesHash();

  @$internal
  @override
  Pages create() => Pages();
}

String _$pagesHash() => r'4c01f67ce8e443f60c6ace9d20a501a03e8c196c';

abstract class _$Pages extends $AsyncNotifier<List<domain.Page>> {
  FutureOr<List<domain.Page>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<List<domain.Page>>, List<domain.Page>>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<AsyncValue<List<domain.Page>>, List<domain.Page>>,
        AsyncValue<List<domain.Page>>,
        Object?,
        Object?>;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(currentPageBlocks)
final currentPageBlocksProvider = CurrentPageBlocksFamily._();

final class CurrentPageBlocksProvider extends $FunctionalProvider<
        AsyncValue<List<Block>>, List<Block>, FutureOr<List<Block>>>
    with $FutureModifier<List<Block>>, $FutureProvider<List<Block>> {
  CurrentPageBlocksProvider._(
      {required CurrentPageBlocksFamily super.from,
      required String super.argument})
      : super(
          retry: null,
          name: r'currentPageBlocksProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$currentPageBlocksHash();

  @override
  String toString() {
    return r'currentPageBlocksProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<Block>> $createElement(
          $ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<List<Block>> create(Ref ref) {
    final argument = this.argument as String;
    return currentPageBlocks(
      ref,
      argument,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is CurrentPageBlocksProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$currentPageBlocksHash() => r'b01b1e88a0b1a306e23b4f3c0e602555b8c361a3';

final class CurrentPageBlocksFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<Block>>, String> {
  CurrentPageBlocksFamily._()
      : super(
          retry: null,
          name: r'currentPageBlocksProvider',
          dependencies: null,
          $allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  CurrentPageBlocksProvider call(
    String pageId,
  ) =>
      CurrentPageBlocksProvider._(argument: pageId, from: this);

  @override
  String toString() => r'currentPageBlocksProvider';
}

@ProviderFor(SearchQuery)
final searchQueryProvider = SearchQueryProvider._();

final class SearchQueryProvider extends $NotifierProvider<SearchQuery, String> {
  SearchQueryProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'searchQueryProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$searchQueryHash();

  @$internal
  @override
  SearchQuery create() => SearchQuery();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$searchQueryHash() => r'286abcff51dc844febe02639bb2e883ccab22cfd';

abstract class _$SearchQuery extends $Notifier<String> {
  String build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<String, String>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<String, String>, String, Object?, Object?>;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(searchResults)
final searchResultsProvider = SearchResultsProvider._();

final class SearchResultsProvider extends $FunctionalProvider<
        AsyncValue<List<domain.Page>>,
        List<domain.Page>,
        FutureOr<List<domain.Page>>>
    with
        $FutureModifier<List<domain.Page>>,
        $FutureProvider<List<domain.Page>> {
  SearchResultsProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'searchResultsProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$searchResultsHash();

  @$internal
  @override
  $FutureProviderElement<List<domain.Page>> $createElement(
          $ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<List<domain.Page>> create(Ref ref) {
    return searchResults(ref);
  }
}

String _$searchResultsHash() => r'5fb3d31e386d28042382ec4055d69c60d9069f3e';

@ProviderFor(taskRepository)
final taskRepositoryProvider = TaskRepositoryProvider._();

final class TaskRepositoryProvider
    extends $FunctionalProvider<TaskRepository, TaskRepository, TaskRepository>
    with $Provider<TaskRepository> {
  TaskRepositoryProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'taskRepositoryProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$taskRepositoryHash();

  @$internal
  @override
  $ProviderElement<TaskRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  TaskRepository create(Ref ref) {
    return taskRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TaskRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TaskRepository>(value),
    );
  }
}

String _$taskRepositoryHash() => r'7f58ac49f1b945ed01a5f09fd5f25905a132bd1b';

@ProviderFor(openTasks)
final openTasksProvider = OpenTasksProvider._();

final class OpenTasksProvider extends $FunctionalProvider<
        AsyncValue<List<Block>>, List<Block>, FutureOr<List<Block>>>
    with $FutureModifier<List<Block>>, $FutureProvider<List<Block>> {
  OpenTasksProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'openTasksProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$openTasksHash();

  @$internal
  @override
  $FutureProviderElement<List<Block>> $createElement(
          $ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<List<Block>> create(Ref ref) {
    return openTasks(ref);
  }
}

String _$openTasksHash() => r'72fccd6bb241d2ba5dc3f6056d75eeffee85ebf9';

@ProviderFor(todayTasks)
final todayTasksProvider = TodayTasksProvider._();

final class TodayTasksProvider extends $FunctionalProvider<
        AsyncValue<List<Block>>, List<Block>, FutureOr<List<Block>>>
    with $FutureModifier<List<Block>>, $FutureProvider<List<Block>> {
  TodayTasksProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'todayTasksProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$todayTasksHash();

  @$internal
  @override
  $FutureProviderElement<List<Block>> $createElement(
          $ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<List<Block>> create(Ref ref) {
    return todayTasks(ref);
  }
}

String _$todayTasksHash() => r'b8310923b9c7b87ca06b0faf6a3cd8ed7d0ef9b7';

@ProviderFor(AdvancedQueryString)
final advancedQueryStringProvider = AdvancedQueryStringProvider._();

final class AdvancedQueryStringProvider
    extends $NotifierProvider<AdvancedQueryString, String> {
  AdvancedQueryStringProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'advancedQueryStringProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$advancedQueryStringHash();

  @$internal
  @override
  AdvancedQueryString create() => AdvancedQueryString();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$advancedQueryStringHash() =>
    r'061ae5bef0200cf537b062555fcfc018faac4811';

abstract class _$AdvancedQueryString extends $Notifier<String> {
  String build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<String, String>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<String, String>, String, Object?, Object?>;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(advancedQueryResults)
final advancedQueryResultsProvider = AdvancedQueryResultsProvider._();

final class AdvancedQueryResultsProvider extends $FunctionalProvider<
        AsyncValue<List<Block>>, List<Block>, FutureOr<List<Block>>>
    with $FutureModifier<List<Block>>, $FutureProvider<List<Block>> {
  AdvancedQueryResultsProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'advancedQueryResultsProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$advancedQueryResultsHash();

  @$internal
  @override
  $FutureProviderElement<List<Block>> $createElement(
          $ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<List<Block>> create(Ref ref) {
    return advancedQueryResults(ref);
  }
}

String _$advancedQueryResultsHash() =>
    r'ac9251840cab4ac740d28588e79fa3e92765295b';

@ProviderFor(Templates)
final templatesProvider = TemplatesProvider._();

final class TemplatesProvider
    extends $AsyncNotifierProvider<Templates, List<Template>> {
  TemplatesProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'templatesProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$templatesHash();

  @$internal
  @override
  Templates create() => Templates();
}

String _$templatesHash() => r'f01b4fd723a748ef4615404f01caf0893cd6a4ce';

abstract class _$Templates extends $AsyncNotifier<List<Template>> {
  FutureOr<List<Template>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<List<Template>>, List<Template>>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<AsyncValue<List<Template>>, List<Template>>,
        AsyncValue<List<Template>>,
        Object?,
        Object?>;
    element.handleCreate(ref, build);
  }
}

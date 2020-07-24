// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies

part of 'firestore_query_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

class _$FirestoreQueryStateTearOff {
  const _$FirestoreQueryStateTearOff();

// ignore: unused_element
  FirestoreQueryUninitializedState<T>
      uninitialized<T extends FirestoreDocument>() {
    return FirestoreQueryUninitializedState<T>();
  }

// ignore: unused_element
  FirestoreQueryLoadingState<T> loading<T extends FirestoreDocument>() {
    return FirestoreQueryLoadingState<T>();
  }

// ignore: unused_element
  FirestoreQueryLoadedState<T> loaded<T extends FirestoreDocument>(
      {@required List<T> documents}) {
    return FirestoreQueryLoadedState<T>(
      documents: documents,
    );
  }

// ignore: unused_element
  FirestoreQueryLoadFailedState<T> loadFailed<T extends FirestoreDocument>(
      {Object error}) {
    return FirestoreQueryLoadFailedState<T>(
      error: error,
    );
  }
}

// ignore: unused_element
const $FirestoreQueryState = _$FirestoreQueryStateTearOff();

mixin _$FirestoreQueryState<T extends FirestoreDocument> {
  @optionalTypeArgs
  Result when<Result extends Object>({
    @required Result uninitialized(),
    @required Result loading(),
    @required Result loaded(List<T> documents),
    @required Result loadFailed(Object error),
  });
  @optionalTypeArgs
  Result maybeWhen<Result extends Object>({
    Result uninitialized(),
    Result loading(),
    Result loaded(List<T> documents),
    Result loadFailed(Object error),
    @required Result orElse(),
  });
  @optionalTypeArgs
  Result map<Result extends Object>({
    @required Result uninitialized(FirestoreQueryUninitializedState<T> value),
    @required Result loading(FirestoreQueryLoadingState<T> value),
    @required Result loaded(FirestoreQueryLoadedState<T> value),
    @required Result loadFailed(FirestoreQueryLoadFailedState<T> value),
  });
  @optionalTypeArgs
  Result maybeMap<Result extends Object>({
    Result uninitialized(FirestoreQueryUninitializedState<T> value),
    Result loading(FirestoreQueryLoadingState<T> value),
    Result loaded(FirestoreQueryLoadedState<T> value),
    Result loadFailed(FirestoreQueryLoadFailedState<T> value),
    @required Result orElse(),
  });
}

abstract class $FirestoreQueryStateCopyWith<T extends FirestoreDocument, $Res> {
  factory $FirestoreQueryStateCopyWith(FirestoreQueryState<T> value,
          $Res Function(FirestoreQueryState<T>) then) =
      _$FirestoreQueryStateCopyWithImpl<T, $Res>;
}

class _$FirestoreQueryStateCopyWithImpl<T extends FirestoreDocument, $Res>
    implements $FirestoreQueryStateCopyWith<T, $Res> {
  _$FirestoreQueryStateCopyWithImpl(this._value, this._then);

  final FirestoreQueryState<T> _value;
  // ignore: unused_field
  final $Res Function(FirestoreQueryState<T>) _then;
}

abstract class $FirestoreQueryUninitializedStateCopyWith<
    T extends FirestoreDocument, $Res> {
  factory $FirestoreQueryUninitializedStateCopyWith(
          FirestoreQueryUninitializedState<T> value,
          $Res Function(FirestoreQueryUninitializedState<T>) then) =
      _$FirestoreQueryUninitializedStateCopyWithImpl<T, $Res>;
}

class _$FirestoreQueryUninitializedStateCopyWithImpl<
        T extends FirestoreDocument,
        $Res> extends _$FirestoreQueryStateCopyWithImpl<T, $Res>
    implements $FirestoreQueryUninitializedStateCopyWith<T, $Res> {
  _$FirestoreQueryUninitializedStateCopyWithImpl(
      FirestoreQueryUninitializedState<T> _value,
      $Res Function(FirestoreQueryUninitializedState<T>) _then)
      : super(_value, (v) => _then(v as FirestoreQueryUninitializedState<T>));

  @override
  FirestoreQueryUninitializedState<T> get _value =>
      super._value as FirestoreQueryUninitializedState<T>;
}

class _$FirestoreQueryUninitializedState<T extends FirestoreDocument>
    implements FirestoreQueryUninitializedState<T> {
  const _$FirestoreQueryUninitializedState();

  @override
  String toString() {
    return 'FirestoreQueryState<$T>.uninitialized()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is FirestoreQueryUninitializedState<T>);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  Result when<Result extends Object>({
    @required Result uninitialized(),
    @required Result loading(),
    @required Result loaded(List<T> documents),
    @required Result loadFailed(Object error),
  }) {
    assert(uninitialized != null);
    assert(loading != null);
    assert(loaded != null);
    assert(loadFailed != null);
    return uninitialized();
  }

  @override
  @optionalTypeArgs
  Result maybeWhen<Result extends Object>({
    Result uninitialized(),
    Result loading(),
    Result loaded(List<T> documents),
    Result loadFailed(Object error),
    @required Result orElse(),
  }) {
    assert(orElse != null);
    if (uninitialized != null) {
      return uninitialized();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  Result map<Result extends Object>({
    @required Result uninitialized(FirestoreQueryUninitializedState<T> value),
    @required Result loading(FirestoreQueryLoadingState<T> value),
    @required Result loaded(FirestoreQueryLoadedState<T> value),
    @required Result loadFailed(FirestoreQueryLoadFailedState<T> value),
  }) {
    assert(uninitialized != null);
    assert(loading != null);
    assert(loaded != null);
    assert(loadFailed != null);
    return uninitialized(this);
  }

  @override
  @optionalTypeArgs
  Result maybeMap<Result extends Object>({
    Result uninitialized(FirestoreQueryUninitializedState<T> value),
    Result loading(FirestoreQueryLoadingState<T> value),
    Result loaded(FirestoreQueryLoadedState<T> value),
    Result loadFailed(FirestoreQueryLoadFailedState<T> value),
    @required Result orElse(),
  }) {
    assert(orElse != null);
    if (uninitialized != null) {
      return uninitialized(this);
    }
    return orElse();
  }
}

abstract class FirestoreQueryUninitializedState<T extends FirestoreDocument>
    implements FirestoreQueryState<T> {
  const factory FirestoreQueryUninitializedState() =
      _$FirestoreQueryUninitializedState<T>;
}

abstract class $FirestoreQueryLoadingStateCopyWith<T extends FirestoreDocument,
    $Res> {
  factory $FirestoreQueryLoadingStateCopyWith(
          FirestoreQueryLoadingState<T> value,
          $Res Function(FirestoreQueryLoadingState<T>) then) =
      _$FirestoreQueryLoadingStateCopyWithImpl<T, $Res>;
}

class _$FirestoreQueryLoadingStateCopyWithImpl<T extends FirestoreDocument,
        $Res> extends _$FirestoreQueryStateCopyWithImpl<T, $Res>
    implements $FirestoreQueryLoadingStateCopyWith<T, $Res> {
  _$FirestoreQueryLoadingStateCopyWithImpl(FirestoreQueryLoadingState<T> _value,
      $Res Function(FirestoreQueryLoadingState<T>) _then)
      : super(_value, (v) => _then(v as FirestoreQueryLoadingState<T>));

  @override
  FirestoreQueryLoadingState<T> get _value =>
      super._value as FirestoreQueryLoadingState<T>;
}

class _$FirestoreQueryLoadingState<T extends FirestoreDocument>
    implements FirestoreQueryLoadingState<T> {
  const _$FirestoreQueryLoadingState();

  @override
  String toString() {
    return 'FirestoreQueryState<$T>.loading()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) || (other is FirestoreQueryLoadingState<T>);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  Result when<Result extends Object>({
    @required Result uninitialized(),
    @required Result loading(),
    @required Result loaded(List<T> documents),
    @required Result loadFailed(Object error),
  }) {
    assert(uninitialized != null);
    assert(loading != null);
    assert(loaded != null);
    assert(loadFailed != null);
    return loading();
  }

  @override
  @optionalTypeArgs
  Result maybeWhen<Result extends Object>({
    Result uninitialized(),
    Result loading(),
    Result loaded(List<T> documents),
    Result loadFailed(Object error),
    @required Result orElse(),
  }) {
    assert(orElse != null);
    if (loading != null) {
      return loading();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  Result map<Result extends Object>({
    @required Result uninitialized(FirestoreQueryUninitializedState<T> value),
    @required Result loading(FirestoreQueryLoadingState<T> value),
    @required Result loaded(FirestoreQueryLoadedState<T> value),
    @required Result loadFailed(FirestoreQueryLoadFailedState<T> value),
  }) {
    assert(uninitialized != null);
    assert(loading != null);
    assert(loaded != null);
    assert(loadFailed != null);
    return loading(this);
  }

  @override
  @optionalTypeArgs
  Result maybeMap<Result extends Object>({
    Result uninitialized(FirestoreQueryUninitializedState<T> value),
    Result loading(FirestoreQueryLoadingState<T> value),
    Result loaded(FirestoreQueryLoadedState<T> value),
    Result loadFailed(FirestoreQueryLoadFailedState<T> value),
    @required Result orElse(),
  }) {
    assert(orElse != null);
    if (loading != null) {
      return loading(this);
    }
    return orElse();
  }
}

abstract class FirestoreQueryLoadingState<T extends FirestoreDocument>
    implements FirestoreQueryState<T> {
  const factory FirestoreQueryLoadingState() = _$FirestoreQueryLoadingState<T>;
}

abstract class $FirestoreQueryLoadedStateCopyWith<T extends FirestoreDocument,
    $Res> {
  factory $FirestoreQueryLoadedStateCopyWith(FirestoreQueryLoadedState<T> value,
          $Res Function(FirestoreQueryLoadedState<T>) then) =
      _$FirestoreQueryLoadedStateCopyWithImpl<T, $Res>;
  $Res call({List<T> documents});
}

class _$FirestoreQueryLoadedStateCopyWithImpl<T extends FirestoreDocument, $Res>
    extends _$FirestoreQueryStateCopyWithImpl<T, $Res>
    implements $FirestoreQueryLoadedStateCopyWith<T, $Res> {
  _$FirestoreQueryLoadedStateCopyWithImpl(FirestoreQueryLoadedState<T> _value,
      $Res Function(FirestoreQueryLoadedState<T>) _then)
      : super(_value, (v) => _then(v as FirestoreQueryLoadedState<T>));

  @override
  FirestoreQueryLoadedState<T> get _value =>
      super._value as FirestoreQueryLoadedState<T>;

  @override
  $Res call({
    Object documents = freezed,
  }) {
    return _then(FirestoreQueryLoadedState<T>(
      documents: documents == freezed ? _value.documents : documents as List<T>,
    ));
  }
}

class _$FirestoreQueryLoadedState<T extends FirestoreDocument>
    implements FirestoreQueryLoadedState<T> {
  const _$FirestoreQueryLoadedState({@required this.documents})
      : assert(documents != null);

  @override
  final List<T> documents;

  @override
  String toString() {
    return 'FirestoreQueryState<$T>.loaded(documents: $documents)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is FirestoreQueryLoadedState<T> &&
            (identical(other.documents, documents) ||
                const DeepCollectionEquality()
                    .equals(other.documents, documents)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^ const DeepCollectionEquality().hash(documents);

  @override
  $FirestoreQueryLoadedStateCopyWith<T, FirestoreQueryLoadedState<T>>
      get copyWith => _$FirestoreQueryLoadedStateCopyWithImpl<T,
          FirestoreQueryLoadedState<T>>(this, _$identity);

  @override
  @optionalTypeArgs
  Result when<Result extends Object>({
    @required Result uninitialized(),
    @required Result loading(),
    @required Result loaded(List<T> documents),
    @required Result loadFailed(Object error),
  }) {
    assert(uninitialized != null);
    assert(loading != null);
    assert(loaded != null);
    assert(loadFailed != null);
    return loaded(documents);
  }

  @override
  @optionalTypeArgs
  Result maybeWhen<Result extends Object>({
    Result uninitialized(),
    Result loading(),
    Result loaded(List<T> documents),
    Result loadFailed(Object error),
    @required Result orElse(),
  }) {
    assert(orElse != null);
    if (loaded != null) {
      return loaded(documents);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  Result map<Result extends Object>({
    @required Result uninitialized(FirestoreQueryUninitializedState<T> value),
    @required Result loading(FirestoreQueryLoadingState<T> value),
    @required Result loaded(FirestoreQueryLoadedState<T> value),
    @required Result loadFailed(FirestoreQueryLoadFailedState<T> value),
  }) {
    assert(uninitialized != null);
    assert(loading != null);
    assert(loaded != null);
    assert(loadFailed != null);
    return loaded(this);
  }

  @override
  @optionalTypeArgs
  Result maybeMap<Result extends Object>({
    Result uninitialized(FirestoreQueryUninitializedState<T> value),
    Result loading(FirestoreQueryLoadingState<T> value),
    Result loaded(FirestoreQueryLoadedState<T> value),
    Result loadFailed(FirestoreQueryLoadFailedState<T> value),
    @required Result orElse(),
  }) {
    assert(orElse != null);
    if (loaded != null) {
      return loaded(this);
    }
    return orElse();
  }
}

abstract class FirestoreQueryLoadedState<T extends FirestoreDocument>
    implements FirestoreQueryState<T> {
  const factory FirestoreQueryLoadedState({@required List<T> documents}) =
      _$FirestoreQueryLoadedState<T>;

  List<T> get documents;
  $FirestoreQueryLoadedStateCopyWith<T, FirestoreQueryLoadedState<T>>
      get copyWith;
}

abstract class $FirestoreQueryLoadFailedStateCopyWith<
    T extends FirestoreDocument, $Res> {
  factory $FirestoreQueryLoadFailedStateCopyWith(
          FirestoreQueryLoadFailedState<T> value,
          $Res Function(FirestoreQueryLoadFailedState<T>) then) =
      _$FirestoreQueryLoadFailedStateCopyWithImpl<T, $Res>;
  $Res call({Object error});
}

class _$FirestoreQueryLoadFailedStateCopyWithImpl<T extends FirestoreDocument,
        $Res> extends _$FirestoreQueryStateCopyWithImpl<T, $Res>
    implements $FirestoreQueryLoadFailedStateCopyWith<T, $Res> {
  _$FirestoreQueryLoadFailedStateCopyWithImpl(
      FirestoreQueryLoadFailedState<T> _value,
      $Res Function(FirestoreQueryLoadFailedState<T>) _then)
      : super(_value, (v) => _then(v as FirestoreQueryLoadFailedState<T>));

  @override
  FirestoreQueryLoadFailedState<T> get _value =>
      super._value as FirestoreQueryLoadFailedState<T>;

  @override
  $Res call({
    Object error = freezed,
  }) {
    return _then(FirestoreQueryLoadFailedState<T>(
      error: error == freezed ? _value.error : error,
    ));
  }
}

class _$FirestoreQueryLoadFailedState<T extends FirestoreDocument>
    implements FirestoreQueryLoadFailedState<T> {
  const _$FirestoreQueryLoadFailedState({this.error});

  @override
  final Object error;

  @override
  String toString() {
    return 'FirestoreQueryState<$T>.loadFailed(error: $error)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is FirestoreQueryLoadFailedState<T> &&
            (identical(other.error, error) ||
                const DeepCollectionEquality().equals(other.error, error)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^ const DeepCollectionEquality().hash(error);

  @override
  $FirestoreQueryLoadFailedStateCopyWith<T, FirestoreQueryLoadFailedState<T>>
      get copyWith => _$FirestoreQueryLoadFailedStateCopyWithImpl<T,
          FirestoreQueryLoadFailedState<T>>(this, _$identity);

  @override
  @optionalTypeArgs
  Result when<Result extends Object>({
    @required Result uninitialized(),
    @required Result loading(),
    @required Result loaded(List<T> documents),
    @required Result loadFailed(Object error),
  }) {
    assert(uninitialized != null);
    assert(loading != null);
    assert(loaded != null);
    assert(loadFailed != null);
    return loadFailed(error);
  }

  @override
  @optionalTypeArgs
  Result maybeWhen<Result extends Object>({
    Result uninitialized(),
    Result loading(),
    Result loaded(List<T> documents),
    Result loadFailed(Object error),
    @required Result orElse(),
  }) {
    assert(orElse != null);
    if (loadFailed != null) {
      return loadFailed(error);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  Result map<Result extends Object>({
    @required Result uninitialized(FirestoreQueryUninitializedState<T> value),
    @required Result loading(FirestoreQueryLoadingState<T> value),
    @required Result loaded(FirestoreQueryLoadedState<T> value),
    @required Result loadFailed(FirestoreQueryLoadFailedState<T> value),
  }) {
    assert(uninitialized != null);
    assert(loading != null);
    assert(loaded != null);
    assert(loadFailed != null);
    return loadFailed(this);
  }

  @override
  @optionalTypeArgs
  Result maybeMap<Result extends Object>({
    Result uninitialized(FirestoreQueryUninitializedState<T> value),
    Result loading(FirestoreQueryLoadingState<T> value),
    Result loaded(FirestoreQueryLoadedState<T> value),
    Result loadFailed(FirestoreQueryLoadFailedState<T> value),
    @required Result orElse(),
  }) {
    assert(orElse != null);
    if (loadFailed != null) {
      return loadFailed(this);
    }
    return orElse();
  }
}

abstract class FirestoreQueryLoadFailedState<T extends FirestoreDocument>
    implements FirestoreQueryState<T> {
  const factory FirestoreQueryLoadFailedState({Object error}) =
      _$FirestoreQueryLoadFailedState<T>;

  Object get error;
  $FirestoreQueryLoadFailedStateCopyWith<T, FirestoreQueryLoadFailedState<T>>
      get copyWith;
}

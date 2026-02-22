// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'honk_status_option.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$HonkStatusOption {

 String get statusKey; String get label; int get sortOrder; bool get isDefault; bool get isActive;
/// Create a copy of HonkStatusOption
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HonkStatusOptionCopyWith<HonkStatusOption> get copyWith => _$HonkStatusOptionCopyWithImpl<HonkStatusOption>(this as HonkStatusOption, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HonkStatusOption&&(identical(other.statusKey, statusKey) || other.statusKey == statusKey)&&(identical(other.label, label) || other.label == label)&&(identical(other.sortOrder, sortOrder) || other.sortOrder == sortOrder)&&(identical(other.isDefault, isDefault) || other.isDefault == isDefault)&&(identical(other.isActive, isActive) || other.isActive == isActive));
}


@override
int get hashCode => Object.hash(runtimeType,statusKey,label,sortOrder,isDefault,isActive);

@override
String toString() {
  return 'HonkStatusOption(statusKey: $statusKey, label: $label, sortOrder: $sortOrder, isDefault: $isDefault, isActive: $isActive)';
}


}

/// @nodoc
abstract mixin class $HonkStatusOptionCopyWith<$Res>  {
  factory $HonkStatusOptionCopyWith(HonkStatusOption value, $Res Function(HonkStatusOption) _then) = _$HonkStatusOptionCopyWithImpl;
@useResult
$Res call({
 String statusKey, String label, int sortOrder, bool isDefault, bool isActive
});




}
/// @nodoc
class _$HonkStatusOptionCopyWithImpl<$Res>
    implements $HonkStatusOptionCopyWith<$Res> {
  _$HonkStatusOptionCopyWithImpl(this._self, this._then);

  final HonkStatusOption _self;
  final $Res Function(HonkStatusOption) _then;

/// Create a copy of HonkStatusOption
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? statusKey = null,Object? label = null,Object? sortOrder = null,Object? isDefault = null,Object? isActive = null,}) {
  return _then(_self.copyWith(
statusKey: null == statusKey ? _self.statusKey : statusKey // ignore: cast_nullable_to_non_nullable
as String,label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,sortOrder: null == sortOrder ? _self.sortOrder : sortOrder // ignore: cast_nullable_to_non_nullable
as int,isDefault: null == isDefault ? _self.isDefault : isDefault // ignore: cast_nullable_to_non_nullable
as bool,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [HonkStatusOption].
extension HonkStatusOptionPatterns on HonkStatusOption {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HonkStatusOption value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HonkStatusOption() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HonkStatusOption value)  $default,){
final _that = this;
switch (_that) {
case _HonkStatusOption():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HonkStatusOption value)?  $default,){
final _that = this;
switch (_that) {
case _HonkStatusOption() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String statusKey,  String label,  int sortOrder,  bool isDefault,  bool isActive)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HonkStatusOption() when $default != null:
return $default(_that.statusKey,_that.label,_that.sortOrder,_that.isDefault,_that.isActive);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String statusKey,  String label,  int sortOrder,  bool isDefault,  bool isActive)  $default,) {final _that = this;
switch (_that) {
case _HonkStatusOption():
return $default(_that.statusKey,_that.label,_that.sortOrder,_that.isDefault,_that.isActive);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String statusKey,  String label,  int sortOrder,  bool isDefault,  bool isActive)?  $default,) {final _that = this;
switch (_that) {
case _HonkStatusOption() when $default != null:
return $default(_that.statusKey,_that.label,_that.sortOrder,_that.isDefault,_that.isActive);case _:
  return null;

}
}

}

/// @nodoc


class _HonkStatusOption implements HonkStatusOption {
  const _HonkStatusOption({required this.statusKey, required this.label, required this.sortOrder, required this.isDefault, this.isActive = true});
  

@override final  String statusKey;
@override final  String label;
@override final  int sortOrder;
@override final  bool isDefault;
@override@JsonKey() final  bool isActive;

/// Create a copy of HonkStatusOption
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HonkStatusOptionCopyWith<_HonkStatusOption> get copyWith => __$HonkStatusOptionCopyWithImpl<_HonkStatusOption>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _HonkStatusOption&&(identical(other.statusKey, statusKey) || other.statusKey == statusKey)&&(identical(other.label, label) || other.label == label)&&(identical(other.sortOrder, sortOrder) || other.sortOrder == sortOrder)&&(identical(other.isDefault, isDefault) || other.isDefault == isDefault)&&(identical(other.isActive, isActive) || other.isActive == isActive));
}


@override
int get hashCode => Object.hash(runtimeType,statusKey,label,sortOrder,isDefault,isActive);

@override
String toString() {
  return 'HonkStatusOption(statusKey: $statusKey, label: $label, sortOrder: $sortOrder, isDefault: $isDefault, isActive: $isActive)';
}


}

/// @nodoc
abstract mixin class _$HonkStatusOptionCopyWith<$Res> implements $HonkStatusOptionCopyWith<$Res> {
  factory _$HonkStatusOptionCopyWith(_HonkStatusOption value, $Res Function(_HonkStatusOption) _then) = __$HonkStatusOptionCopyWithImpl;
@override @useResult
$Res call({
 String statusKey, String label, int sortOrder, bool isDefault, bool isActive
});




}
/// @nodoc
class __$HonkStatusOptionCopyWithImpl<$Res>
    implements _$HonkStatusOptionCopyWith<$Res> {
  __$HonkStatusOptionCopyWithImpl(this._self, this._then);

  final _HonkStatusOption _self;
  final $Res Function(_HonkStatusOption) _then;

/// Create a copy of HonkStatusOption
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? statusKey = null,Object? label = null,Object? sortOrder = null,Object? isDefault = null,Object? isActive = null,}) {
  return _then(_HonkStatusOption(
statusKey: null == statusKey ? _self.statusKey : statusKey // ignore: cast_nullable_to_non_nullable
as String,label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,sortOrder: null == sortOrder ? _self.sortOrder : sortOrder // ignore: cast_nullable_to_non_nullable
as int,isDefault: null == isDefault ? _self.isDefault : isDefault // ignore: cast_nullable_to_non_nullable
as bool,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on

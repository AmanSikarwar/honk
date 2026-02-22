// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'honk_status_option_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$HonkStatusOptionModel {

 String get statusKey; String get label; int get sortOrder; bool get isDefault; bool get isActive;
/// Create a copy of HonkStatusOptionModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HonkStatusOptionModelCopyWith<HonkStatusOptionModel> get copyWith => _$HonkStatusOptionModelCopyWithImpl<HonkStatusOptionModel>(this as HonkStatusOptionModel, _$identity);

  /// Serializes this HonkStatusOptionModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HonkStatusOptionModel&&(identical(other.statusKey, statusKey) || other.statusKey == statusKey)&&(identical(other.label, label) || other.label == label)&&(identical(other.sortOrder, sortOrder) || other.sortOrder == sortOrder)&&(identical(other.isDefault, isDefault) || other.isDefault == isDefault)&&(identical(other.isActive, isActive) || other.isActive == isActive));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,statusKey,label,sortOrder,isDefault,isActive);

@override
String toString() {
  return 'HonkStatusOptionModel(statusKey: $statusKey, label: $label, sortOrder: $sortOrder, isDefault: $isDefault, isActive: $isActive)';
}


}

/// @nodoc
abstract mixin class $HonkStatusOptionModelCopyWith<$Res>  {
  factory $HonkStatusOptionModelCopyWith(HonkStatusOptionModel value, $Res Function(HonkStatusOptionModel) _then) = _$HonkStatusOptionModelCopyWithImpl;
@useResult
$Res call({
 String statusKey, String label, int sortOrder, bool isDefault, bool isActive
});




}
/// @nodoc
class _$HonkStatusOptionModelCopyWithImpl<$Res>
    implements $HonkStatusOptionModelCopyWith<$Res> {
  _$HonkStatusOptionModelCopyWithImpl(this._self, this._then);

  final HonkStatusOptionModel _self;
  final $Res Function(HonkStatusOptionModel) _then;

/// Create a copy of HonkStatusOptionModel
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


/// Adds pattern-matching-related methods to [HonkStatusOptionModel].
extension HonkStatusOptionModelPatterns on HonkStatusOptionModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HonkStatusOptionModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HonkStatusOptionModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HonkStatusOptionModel value)  $default,){
final _that = this;
switch (_that) {
case _HonkStatusOptionModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HonkStatusOptionModel value)?  $default,){
final _that = this;
switch (_that) {
case _HonkStatusOptionModel() when $default != null:
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
case _HonkStatusOptionModel() when $default != null:
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
case _HonkStatusOptionModel():
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
case _HonkStatusOptionModel() when $default != null:
return $default(_that.statusKey,_that.label,_that.sortOrder,_that.isDefault,_that.isActive);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _HonkStatusOptionModel extends HonkStatusOptionModel {
  const _HonkStatusOptionModel({required this.statusKey, required this.label, required this.sortOrder, this.isDefault = false, this.isActive = true}): super._();
  factory _HonkStatusOptionModel.fromJson(Map<String, dynamic> json) => _$HonkStatusOptionModelFromJson(json);

@override final  String statusKey;
@override final  String label;
@override final  int sortOrder;
@override@JsonKey() final  bool isDefault;
@override@JsonKey() final  bool isActive;

/// Create a copy of HonkStatusOptionModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HonkStatusOptionModelCopyWith<_HonkStatusOptionModel> get copyWith => __$HonkStatusOptionModelCopyWithImpl<_HonkStatusOptionModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$HonkStatusOptionModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _HonkStatusOptionModel&&(identical(other.statusKey, statusKey) || other.statusKey == statusKey)&&(identical(other.label, label) || other.label == label)&&(identical(other.sortOrder, sortOrder) || other.sortOrder == sortOrder)&&(identical(other.isDefault, isDefault) || other.isDefault == isDefault)&&(identical(other.isActive, isActive) || other.isActive == isActive));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,statusKey,label,sortOrder,isDefault,isActive);

@override
String toString() {
  return 'HonkStatusOptionModel(statusKey: $statusKey, label: $label, sortOrder: $sortOrder, isDefault: $isDefault, isActive: $isActive)';
}


}

/// @nodoc
abstract mixin class _$HonkStatusOptionModelCopyWith<$Res> implements $HonkStatusOptionModelCopyWith<$Res> {
  factory _$HonkStatusOptionModelCopyWith(_HonkStatusOptionModel value, $Res Function(_HonkStatusOptionModel) _then) = __$HonkStatusOptionModelCopyWithImpl;
@override @useResult
$Res call({
 String statusKey, String label, int sortOrder, bool isDefault, bool isActive
});




}
/// @nodoc
class __$HonkStatusOptionModelCopyWithImpl<$Res>
    implements _$HonkStatusOptionModelCopyWith<$Res> {
  __$HonkStatusOptionModelCopyWithImpl(this._self, this._then);

  final _HonkStatusOptionModel _self;
  final $Res Function(_HonkStatusOptionModel) _then;

/// Create a copy of HonkStatusOptionModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? statusKey = null,Object? label = null,Object? sortOrder = null,Object? isDefault = null,Object? isActive = null,}) {
  return _then(_HonkStatusOptionModel(
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

import 'package:equatable/equatable.dart';

final class const UserId(final String value) extends Equatable {
  @override
  List<Object?> get props => [value];
}

part of 'view_model.dart';

extension Action0Binding<T> on FutureResult<T> Function() {
  Command0<T> bind() => Command0<T>(this);
}

extension Action1Binding<T, A> on Action1fn<T, A> {
  Command1<T, A> bind() => Command1<T, A>(this);
}

extension Action2Binding<T, A, B> on Action2fn<T, A, B> {
  Command2<T, A, B> bind() => Command2<T, A, B>(this);
}

extension SyncAction0Binding<T> on Result<T> Function() {
  Command0<T> bind() => Command0<T>(() async => this());
}

extension SyncAction1Binding<T, A> on Result<T> Function(A) {
  Command1<T, A> bind() => Command1<T, A>((a) async => this(a));
}

extension SyncAction2Binding<T, A, B> on Result<T> Function(A, B) {
  Command2<T, A, B> bind() => Command2<T, A, B>((a, b) async => this(a, b));
}

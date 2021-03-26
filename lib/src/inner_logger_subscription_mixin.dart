import 'dart:async';

import 'inner_logger.dart';
import 'log_level.dart';
import 'log_message.dart';
import 'log_message_with_stack_trace.dart';

/// {@nodoc}
mixin InnerLoggerSubscriptionMixin on InnerLogger {
  /// Whether there is a subscriber on the [Stream].
  bool get hasListener => _controller.hasListener;

  final StreamController<LogMessage> _controller 
	= StreamController<LogMessage>.broadcast();

  @override
  StreamSubscription<LogMessage> listen(
    void Function(LogMessage event)? onData, {
    Function? onError,
    void Function()? onDone,
    bool? cancelOnError = false,
  }) =>
      _controller.stream.listen(
        onData,
        onError: onError,
        onDone: onDone,
        cancelOnError: cancelOnError ?? false,
      );

  @override
  void notifyListeners({
    required Object message,
    required LogLevel logLevel,
    StackTrace? stackTrace,
  }) {
    if (!hasListener) return;
    final logMessage = stackTrace == null
        ? LogMessage(
            message: message,
            date: DateTime.now(),
            level: logLevel,
          )
        : LogMessageWithStackTrace(
            message: message,
            date: DateTime.now(),
            level: logLevel,
            stackTrace: stackTrace,
          );
    _controller.add(logMessage);
  }
}

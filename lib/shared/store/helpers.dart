import 'dart:async';

import 'package:flutter/material.dart';

class StreamBuilder<V, T extends Stream<V>> extends StatefulWidget {
  final Function(BuildContext, V?) builder;
  final T store;

  const StreamBuilder({required this.builder, required this.store, super.key});

  @override
  State<StreamBuilder> createState() => _StreamBuilderState<V, T>();
}

class _StreamBuilderState<V, T extends Stream<V>>
    extends State<StreamBuilder<V, T>> {
  late V _value;
  late StreamSubscription<V> _subscription;

  @override
  void initState() {
    _subscription = widget.store.listen((event) {
      setState(() {
        _value = event;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, _value);
  }
}

import 'package:flutter/material.dart';

class StoreBuilder<V, T extends Store<V>> extends StatefulWidget {
  final Function(BuildContext, V) builder;
  final T store;

  const StoreBuilder({required this.builder, required this.store, super.key});

  @override
  State<StoreBuilder> createState() => _StoreBuilderState<V, T>();
}

class _StoreBuilderState<V, T extends Store<V>>
    extends State<StoreBuilder<V, T>> {
  late V _value;
  late Function() _unsubscribe;

  @override
  void initState() {
    _value = widget.store.value;
    _unsubscribe = widget.store.subscribe((event) {
      setState(() {
        _value = event;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    _unsubscribe();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, _value);
  }
}

class Store<T> {
  T value;
  List<Function(T)> _listeners = [];

  Store({required this.value});

  Function() subscribe(Function(T) cb) {
    _listeners.add(cb);

    return () {
      _listeners = _listeners.where((el) => el != cb).toList();
    };
  }

  next(T value) {
    this.value = value;
    _notify();
  }

  _notify() {
    for (var cb in _listeners) {
      cb(value);
    }
  }
}

import 'dart:async';

class PageScrollEvent {
  int index;

  PageScrollEvent(int i) {
    index = i;
  }
}

class HomeBloc {
  int _currentIndex = 1;
  final StreamController<int> _indexStateController = StreamController<int>();

  StreamSink<int> get _inIndex => _indexStateController.sink;

  Stream<int> get index => _indexStateController.stream;
  final _indexEventController = StreamController<PageScrollEvent>();

  Sink<PageScrollEvent> get pageScrollEventSink => _indexEventController.sink;

  HomeBloc() {
    _indexEventController.stream.listen(_eventToState);
  }

  void _eventToState(PageScrollEvent event) {
    if (event.index >= 0 && event.index <= 2)
      _currentIndex = event.index;
    _inIndex.add(_currentIndex);
  }

  void dispose() {
    _indexEventController.close();
    _indexStateController.close();
  }
}

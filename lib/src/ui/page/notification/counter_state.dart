class CounterState {
  int? count = 0;
  String? label = 'a label';

  CounterState();

  CounterState.fromObject(CounterState obj) {
    count = obj?.count ?? 0;
    label = obj?.label ?? 'a label';
  }
}

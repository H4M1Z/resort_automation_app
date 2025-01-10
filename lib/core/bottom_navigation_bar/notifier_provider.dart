import 'package:flutter_riverpod/flutter_riverpod.dart';

// Define the NotifierProvider for managing the bottom navigation state
final bottomBarStateProvider =
    NotifierProvider<BottomStateNotifier, int>(BottomStateNotifier.new);

// Implement the Notifier for the bottom navigation state
class BottomStateNotifier extends Notifier<int> {
  int index = 0;
  @override
  int build() {
    // Initial index for the bottom navigation bar
    return index;
  }

  // Method to update the current index
  void changeIndex(int index) {
    state = index;
  }

  void restoreState() {
    state = 0;
  }
}

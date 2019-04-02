// part 'partTest_g.dart';

abstract class PartTest {
  String get fullWord;
}

class _PartTest implements PartTest {
  final String fullWord;
  _PartTest(this.fullWord) {
    assert(this.fullWord != null);
  }

  _PartTest copyWith({
    String fullWord,
  }) =>
      _PartTest(
        fullWord == null ? this.fullWord : fullWord,
      );
}

_PartTest partTest(String fullWord) {
  return _PartTest(fullWord);
}

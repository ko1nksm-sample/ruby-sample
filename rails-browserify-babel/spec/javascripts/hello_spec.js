import assert from 'power-assert'
import hello from 'hello'

describe('hello 関数のテスト', function() {
  it('hello', function() {
    assert(hello("test") === "Hello test")
  });
});

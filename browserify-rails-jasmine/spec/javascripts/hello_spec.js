import hello from 'hello'

function add(a, b) {
      return a + b;
}

describe('add 関数のテスト', function() {
    it('hello', function() {
        expect(hello()).toBe("hello");
    });

    it('1 + 1 は 2', function() {
        expect(add(1, 1)).toBe(2);
    });
    it('1 + 4 は 5', function() {
        expect(add(1, 4)).toBe(5);
    });
});

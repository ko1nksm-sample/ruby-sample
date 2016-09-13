import hello from "hello";

const say = () => {
  $(document.body).append(hello('world'));
};

$(function() {
  say();
})

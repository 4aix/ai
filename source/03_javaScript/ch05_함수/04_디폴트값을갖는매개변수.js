console.log(pow(5,3));
console.log(pow(5));
console.log(pow(y=2, x=3)); // 첫번째 매개변수는 x(2), 두cl번째 매개변수는 y(3)
console.log(pow());

function pow(x=5, y=2){
  // x의 y승을 return
  console.log(`함수 내의 x=${x}, y=${y}`);
  result = x ** y;
  return result;
}
let funVar = function(i){
  console.log('1. 일반함수호출');
};
funVar();
funVar = () => {
  console.log('2. 매개변수가 없거나 2개이상인 화살표함수 호출');
};
funVar();
funvar = i => {
  console.log('3. 매개변수가 하나 있는 화살표 함수 호출');
  console.log('매개변수 i =', i);
};
funvar();
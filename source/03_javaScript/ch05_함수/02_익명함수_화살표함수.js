let funVar = function(i){
  console.log('1. 일반함수호출');
};
funVar();
funVar = () => {
  console.log('2. 매개변수가 없거나 2개이상인 화살표함수 호출');
};
funVar();
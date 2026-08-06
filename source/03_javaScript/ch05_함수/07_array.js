/* array함수 : 가변인자함수(화살표함수는 불가)
 * 매개변가 0개 : length가 0인 배열을 return
 * 매개변수 1개 : length가 매개변수만큼인 크기의 배열을 return
 * 매개변수 2개 이상 : 매개변수로 배열을 생성 return */
function array(){ // arguments : 매개변수 내용이 들어옴/arguments.length:매개변수갯수
  //console.log(arguments, arguments.length);
  let result = [];
  if(arguments.length==1){
    // result를 arguments[0] 만큼 크기의 빈 배열
    for(let cnt=1 ; cnt<=arguments[0]; cnt++){
      result.push(undefined);
    }
  }else if(arguments.length>=2){
    // result를 arguments의 내용으로 만들기

  }
  return result;
}
array();
array(3);
array(1, 2, '삼');
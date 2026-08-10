// now.getNumberOfDays(openday) 
Date.prototype.getNumberOfDays = function(thatday){ // now가 this / openday가 thatday
  let interval; // 두 시점간 밀리세컨
  if (this>thatday){
    interval = this.getTime() - thatday.getTime();
  }else{
    interval = thatday.getTime() - this.getTime();
  }
  let day = interval/(1000*60*60*24);
  return day;
};
let now = new Date(); // 현재 시점
let limitday = new Date(2026, 10, 19, 18, 0, 0); // 2026.11.19
console.log(now.getNumberOfDays(limitday));
console.log(limitday.getNumberOfDays(now));
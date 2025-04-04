void main(){
  int number = 31;
  if(number %2==1){
    print("홀수!");
  }else{
    print("짝수!");
  }
  
  String light = "red";
  if(light=="green"){
    print("초록불");
  }else if(light=="yellow"){
    print("노란불");
  }else if(light=="red"){
    print("빨간불");
  }else{
  print("잘못된 신호입니다.");
  }

  String light2 = "purple";
  if(light2=="green"){
    print("초록불");
  }else if(light=="yellow"){
    print("노란불");
  }else if(light=="red"){
    print("빨간불");
  }

  for(int i=0;i<100;i++){
    print(i+1);
  }

  List<String> subject = ["자료구조","이산수학","알고리즘","플러터"];
  for(String subject in subject){
    print(subject);
  }

  int i2= 0;
  while(i2<100){
    print(i2+1);
    i2 = i2 + 1;
  }

  // int i3 = 0;
  // while(true){
  //   print(i3+1);
  //   i3 = i3 + 1;
  // }
  int i4 = 0;
  while(true){
    print(i4 +1);
    i4 = i4+1;
    if(i4==100){
      break;
    }
  }

  for(int i5 = 0; i5<100;i5++){
    if(i5%2==0){
      continue;
    }
    print(i5+1);
  }

  int add(int a,int b){
    return a+b;
  }

  int number1 = add(1,2);
  print(number1);


  const a= 'a';
  const b = 'b';
  const obj = [a,b];
  switch(obj){
    case[a,b]:
      print('$a,$b');
  }

  const obj1 =1;
  const first =1;
  const last  = 10;
   switch(obj1){
     case 1:
       print('one');

     case >=first && <=last:
       print('in range');

     case(var a10, var b10):
       print('a = $a, b = $b');

       default:
   }


  }
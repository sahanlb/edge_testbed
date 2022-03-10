#define 	GPIO 		0x10000000	
#define memorder 0

void write_led(int val){
	__atomic_store_n((int*)GPIO, val, memorder);
	//*((int*)GPIO) = val;
}				  


void main(void){
int i = 0;


while (1){
  for(i=0; i<100000; i=i+1){
  }
  write_led(0);

  for(i=0; i<100000; i=i+1){
  }
  write_led(1);

  for(i=0; i<100000; i=i+1){
  }
  write_led(2);

  for(i=0; i<100000; i=i+1){
  }
  write_led(3);

  for(i=0; i<100000; i=i+1){
  }
  write_led(4);

  for(i=0; i<100000; i=i+1){
  }
  write_led(5);

  for(i=0; i<100000; i=i+1){
  }
  write_led(6);

  for(i=0; i<100000; i=i+1){
  }
  write_led(7);

  for(i=0; i<100000; i=i+1){
  }
  write_led(8);

  for(i=0; i<100000; i=i+1){
  }
  write_led(9);

  for(i=0; i<100000; i=i+1){
  }
  write_led(10);

  for(i=0; i<100000; i=i+1){
  }
  write_led(11);

  for(i=0; i<100000; i=i+1){
  }
  write_led(12);

  for(i=0; i<100000; i=i+1){
  }
  write_led(13);

  for(i=0; i<100000; i=i+1){
  }
  write_led(14);

  for(i=0; i<100000; i=i+1){
  }
  write_led(15);
}
return;
}

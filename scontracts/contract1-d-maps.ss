/*

contract Wallet {
 mapping(address => uint) private userBalances;

 function withdrawBalance() {
  uint amountToWithdraw = userBalances[msg.sender];
  if (amountToWithdraw > 0) {
    msg.sender.call(userBalances[msg.sender]);
    userBalances[msg.sender] = 0;
   }
  }
...
}


contract AttackerContract {
 function () {
  Wallet wallet;
  wallet.withdrawBalance();
 }
}
*/

/*
msg.data (bytes): complete calldata
msg.gas (uint): remaining gas - deprecated in version 0.4.21 and to be replaced by gasleft()
msg.sender (address): sender of the message (current call)
msg.sig (bytes4): first four bytes of the calldata (i.e. function identifier)
msg.value (uint): number of wei sent with the message
*/

/* data structures for the special variables */
data message{
       int data_;
       int gas;
       int sender;
       int sig;
       int value;
       }

/*********************/
/** contract Wallet **/
/*********************/
data bnode{ int userid; int val; bnode next;}

global message msg;
global mapping(t1 ==> t2) userBalances;
global int     bal;  //contract's balance

// mapping(address => uint) private userBalances;

void call(int userid, int arg)
   requires  arg>0
   ensures   bal'=bal-arg;


// fixed version
// should fail because of the recursive call
void withdrawBalance_a()
   //infer [@reentrancy]
   requires  msg::message<_,_,id,_,_>@L & userBalances[id]=n & n>0 & bal>=n
   ensures   userBalances'[id]=0 & bal'=bal-n;
   requires  msg::message<_,_,id,_,_>@L & userBalances[id]=n & n=0 & bal>=n
   ensures   bal'=bal & userBalances'=userBalances;
{
  int amountToWithdraw = userBalances[msg.sender];
  if (amountToWithdraw > 0) {
     userBalances[msg.sender] = 0;
     call(msg.sender,amountToWithdraw);                  // call(msg.sender,arg)             <- msg.sender.call(arg)
     withdrawBalance_a();
  }
}

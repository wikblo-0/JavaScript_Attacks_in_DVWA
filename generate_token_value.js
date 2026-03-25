//Low security level
md5(rot13("success"));

//Medium security level
do_something("XX" + "success" + "XX");

//High security level
let step1 = "success".split("").reverse().join("");
let step2 = sha256("XX" + step1);
let step3 = sha256(step2 + "ZZ");
console.log(step3);

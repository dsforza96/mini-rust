fn main(){
    fn dummy <'a, 'b>(x: &'a i32, y: &'b i32) -> &'a i32{
        let r = x + 15;
        x
    }
    let w = 10;
    let s = 41;
    let res;
    let k = &s;
    {
        let q = 5;
        res = dummy (&w, &q);
        println!("{}", k);
    }
    println!("{}", res);
}

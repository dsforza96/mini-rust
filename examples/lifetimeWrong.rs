fn main (){
    fn dummy <'a, 'b>(x: &'a i32, y: &'b i32) -> &'a i32{
        y
    }
    let w = 10;
    let res;
    {
        let q = 5;
        res = dummy (&w, &q);
    }
    println!("{}", res);
}

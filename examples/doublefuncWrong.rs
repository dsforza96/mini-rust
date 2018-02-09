fn main (){
    fn dummy1 <'a, 'b>(x: &'a i32, y: &'b i32) -> &'a i32{
        let z;
        {
            let k = 3;
            z = &k;
        }
        x
    }

    fn dummy2 <'a, 'b>(x: &'a i32, y: &'b i32) -> &'a i32{
        let r = x + 15;
        println!("{}", x);
        dummy1(&x, &y);
        x
    }
    let q = 10;
    let w = 20;
    let p1;
    let a = dummy1(&w, &q);
    println!("{}", a);
}

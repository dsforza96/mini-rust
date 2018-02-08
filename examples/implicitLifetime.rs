fn main (){
    fn dummy(a: &i32, b: &i32) -> &i32 {
        a
    }
    
    let x = 2;
    let r;
    {
        let y = 5;
        r = dummy(&x, &y);
    }
    println!("{}", r);
}

fn main (){
    let x = 2;
    {
        let b = 2;
        x = b;
    }
    println!("{}", x);
}
